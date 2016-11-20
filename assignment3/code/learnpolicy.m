function [ policy ] = learnpolicy( environment, start_state )
%LEARNPOLICY Summary of this function goes here
%   environment is just a function handle to next_state
%   start_state is the index of the starting state
%   policy will be a row vector of size 1*16 
%   each element of this vector will be a positive integer from 1 to 4
%   This vector should contain the learned policy
%   For example, policy(1) should be the best action for state=1
%                policy(2) should be the best action for state=2                  
%                                       .
%                                       .
%                                       .
%                policy(16) should be the best action for state=16                  

%   Implement an RL method here
    policy = zeros(1,16);
    numepisodes = 10000;
    q = rand(16,4);

    for episode = 1:numepisodes
        current_state = start_state;
        a = epsiongreedy(q,current_state,episode);
        terminal = 0;
        alpha_t = 1;
        while ~terminal
            [terminal,ns,r] = environment(current_state,a);
            a_prime = epsiongreedy(q,ns,episode);
            q(current_state,a) = q(current_state,a) + (1/alpha_t) * ( r + (0.9 * q(ns,a_prime)) - q(current_state,a));
            current_state = ns;
            a = a_prime;
            alpha_t = alpha_t + 1;
        end
    end
    for j = 1:16
        [~,policy(1,j)] = max(q(j,:));
    end
end

function [action] = epsiongreedy(q,ns,episode)
    if (rand(1,1) > (1/episode))
        [~,action] = max(q(ns,:));
    else
        action = randi(4,1);
    end
end
