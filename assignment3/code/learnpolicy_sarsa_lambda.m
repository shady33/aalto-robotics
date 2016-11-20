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
%         policy = zeros(1,16);
%         current_state = start_state;
%         for j = 1:16
% 
%         [t(1),ns(1),r(1)] = environment(current_state,1);
%         [t(2),ns(2),r(2)] = environment(current_state,2);
%         [t(3),ns(3),r(3)] = environment(current_state,3);
%         [t(4),ns(4),r(4)] = environment(current_state,4);
%         [d,i] = max(r);
%         policy(current_state) = i;
%         current_state = ns(i);
%         rewards(j) = r(i);
%         terminal(j) = t(i);
%         end
%         rewards
%         terminal
        policy = zeros(1,16);
        numepisodes = 10000;
        gamma = 0.9;
        alpha = 0.05; % Learning rate
        lambda = 0.9;
        q = rand(16,4);

        for episode = 1:numepisodes
            current_state = start_state;
            a = 3;
            terminal = 0;
            e = zeros(16,4);
            while ~terminal
                [terminal,ns,r] = environment(current_state,a);
                a_prime = epsiongreedy(q,ns,episode);
                delta = r + (gamma * q(ns,a_prime)) - q(current_state,a);
                 e(current_state,a) = e(current_state,a) + 1;
                 q = q + (alpha * delta * e);
                 e = gamma * lambda * e;
%                 for d = 1:16
%                     for l = 1:4
%                         q(d,l) = q(d,l) + (alpha * delta * e(d,l));
%                         e(d,l) = gamma * lambda * e(d,l);
%                     end
%                 end
                current_state = ns;
                a = a_prime;
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
