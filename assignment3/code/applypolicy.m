function [ totalreward ] = applypolicy( environment, policy, start_state )
%APPLYPOLICY Summary of this function goes here
%   Detailed explanation goes here
    discount_factor=0.9;
    totalreward=0;
    state = start_state;
    action = policy(start_state);

    [terminal, snew, r] = environment(state, action);
    totalreward =  totalreward + (discount_factor * r);
    t=0;
    while (~terminal) 
        t=t+1;
        state = snew;
        action = policy(state);

        [terminal, snew, r] = environment(state, action);
        totalreward =  totalreward + (discount_factor ^ t * r);
    end;


end

