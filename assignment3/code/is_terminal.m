function [ terminal,reward ] = is_terminal( i,j )
%IS_NON_TERMINAL This function checks whether [i, j] is a terminal state or not
%   
%   
    r=[10 5 -5 -10];
    %All the cells in the last column are terminal states
    if j==4
        terminal=1;
        reward=r(i);
    else
        terminal=0;
        reward=-1;
    end
        
end

