%you can use this script for answering question 1
% report the learned policy

start_state=13;

%Important note: Your code should return a policy in less than 7 minutes
tic;
policy = learnpolicy( @next_state, start_state );
toc;


