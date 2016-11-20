function [ terminal, snext, reward ] = next_state( s,a )
%NEXT_STATE is your interface to the dynamic of the environment which you
%want to experience and extract a ploicy

%   s denotes the current state
%   a denotes the action; a belongs to {1, 2, 3, 4}
%   snext is the next state
%   reward is the immediate transition reward
%   terminal is a boolean
%   if terminal==0, snext is non_terminal otherwise it is a terminal state
%   indicating the end of an episode
    
    noise_prob=0.2;

    r=ceil(s/4);
    c=mod(s,4);
    if c==0
        c=4;
    end
    
    neighbors=extract_neighbor(r,c,a,noise_prob);
    
    trans_prob=cumsum(neighbors(:,3));
    rand_num=rand;
    next_index=0;
    for i=1:3
        if rand_num <= trans_prob(i)
            next_index=i;
            break;
        end
    end
    
    r=neighbors(next_index,1);
    c=neighbors(next_index,2);
    
    snext=((r-1)*4)+c;
    [terminal, reward]=is_terminal(r,c);
        
end

