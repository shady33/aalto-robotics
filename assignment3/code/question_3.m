%you can use this script for answering questions 3 to 6
% report average_reward

start_state=13;

%Very Important note: evaluate the 4 policies which you have learned in
%question 3 


num_episodes= 10000; 



totalreward=0;

policy
for i=1:num_episodes
    % you have learned policy in question 1
    totalreward  = totalreward + applypolicy( @next_state, policy, start_state );
    
end


average_reward = totalreward/num_episodes
