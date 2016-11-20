function [ neighbor ] = move_from_toward( i, j, a )
%MOVE_FROM_TOWARD This function move the agent from position (i,j) toward a
%   i is the row of the grid
%   j is the column of the grid
%   a is an action
%   (2,2), (3,2) are two obstacles 
%   Move the agent toward a if the action a does not lead you toward an
%   obstacle or the wall
%   otherwise, stay at the same place
%   
    neighbor=[i j];% I assume that I cannot move because of an obstacle or wall
    temp_neighbor= move_toward(i,j,a);
    r=temp_neighbor(1);%the row of the resulting action
    c=temp_neighbor(2);%the column of the resulting action
    
    %now, I check if [r c] is an obstacle 
    if ( ( (r==2)&&(c==2) ) || ( (r==3)&&(c==2) ) )
        %do nothing because it is an obstacle
    elseif ( (r<1) || (r>4) || (c<1) || (c>4) )
        %do nothing because the agent is moving toward a wall
    else
        neighbor=[r c];
    end
end

