clear all
clc

for num_dipole=1:5
    eval(['srcorigin_' num2str(num_dipole) '=zeros(1000,' num2str(num_dipole*6) ');']);
    for a=1:1000
        rng('shuffle');
        nS=num_dipole;
    
        % Constrain the magnitude of the magnetic moment 
        % and the range of positions
        srcmommat = -0.5 + rand(3, nS);
        srcposmat = -0.25 + 0.5*rand(3, nS);
    
        % Determine if the randomly generated magnetic moment 
        % positions are too close (less than 0.1m)
        flag = 1;fflag = 0;
        if nS > 1
            while flag
                for i = 1:nS-1
                    for j = 1:nS-i
                        temp1 = srcposmat(1:3, i);
                        temp2 = srcposmat(1:3, i+j);
                        if norm(temp1 - temp2) > 0.1
                            flag=0;
                        else
                            srcmommat = -0.5 + rand(3, nS);
                            srcposmat = -0.25 + 0.5*rand(3, nS);
                            srcmommat = roundn(srcmommat,-4);
                            srcposmat = roundn(srcposmat, -4);
                        end
                    end
                end
            end
        end
    
        sortedsrcmommat = zeros(3,nS);
        sortedsrcposmat = zeros(3,nS);
        for i = 1:size(srcmommat, 2)
            [sortedColumn,index] = sort(srcmommat(:, i));
            
            sortedsrcmommat(:,i) = sortedColumn;
            sortedsrcposmat(:,i) = srcposmat(index,i);
        end
        [~, index] = sort(srcmommat(1,:));
        srcmommat = sortedsrcmommat(:,index);
        srcposmat = sortedsrcposmat(:,index);
        
        sortedsrcmommat = zeros(1,num_dipole*3);
        sortedsrcposmat = zeros(1,num_dipole*3);
        for i = 1:size(srcmommat, 2)
            sortedsrcmommat(3*(i-1)+1:3*(i-1)+3) = srcmommat(:,i)';
            sortedsrcposmat(3*(i-1)+1:3*(i-1)+3) = srcposmat(:,i)';
        end
    
        eval(['srcorigin_' num2str(num_dipole) '(a,:)=[sortedsrcmommat sortedsrcposmat];']);
        
    end
%     disp(num_dipole);
end

