function [optimal_policy]=find_the_optimal_policy(discount, livingReward, noise )

    global east;
    global north;
    global west;
    global south;
    
    east  = 1;
    north = 2;
    west  = 3;
    south = 4;
    
    grid = [0 0 0 0 0; 0 -100 0 0 0;0 -100 +1 -100 +10; 0 0 0 0 0; -10 -10 -10 -10 -10];
    direction = zeros(5,5);
    
    steps = [4 5; 4 4; 4 3; 4 2; 2 5; 2 4; 1 5; 1 4; 2 3; 1 3; 1 2; 1 1; 2 1; 3 1; 4 1];
    
    for l = 1:1
    for j = 1:15
        [grid(steps(j,1),steps(j,2)) , direction(steps(j,1),steps(j,2)) ] = v_iter(grid,steps(j,1),steps(j,2),discount,livingReward,noise);
    end
    end
    grid
    direction
%     [grid(4,4) , direction(4,4) ] = v_iter(grid,4,4,discount,livingReward,noise)
%     [grid(4,3) , direction(4,3) ] = v_iter(grid,4,3,discount,livingReward,noise)
%     [grid(4,2) , direction(4,2) ] = v_iter(grid,4,2,discount,livingReward,noise)
%     
%     [grid(2,5) , direction(2,5) ] = v_iter(grid,2,5,discount,livingReward,noise)
end

function [max_value , direction] = v_iter(grid,x,y,discount, livingReward, noise)
    
    try
        south_local = grid(x+1,y);
    catch
        south_local = grid(x,y);
    end
    try
        east_local = grid(x,y+1);
    catch
        east_local = grid(x,y);
    end
    try
       north_local = grid(x-1,y);
    catch
       north_local = grid(x,y);
    end
    try
      west_local = grid(x,y-1);
    catch
      west_local = grid(x,y);
    end
    
    [minimum,pos ]= min([east_local north_local west_local south_local]);
    if minimum == -100
        if ( pos == 1)
            east_local = grid(x,y);
        end
        if ( pos == 2)
            north_local = grid(x,y);
        end  
        if ( pos == 3)
            west_local = grid(x,y);
        end
        if ( pos == 4)
            south_local = grid(x,y);
        end
    end
    
    direction_north = ((1 - noise) * (livingReward + discount * (north_local))) ...
    + ((noise / 2) * (livingReward + discount * (east_local))) ...
    + ((noise / 2) * (livingReward + discount * (west_local)));
    

    direction_south = ((1 - noise) * (livingReward + discount * (south_local))) ...
    + ((noise / 2) * (livingReward + discount * (east_local))) ...
    + ((noise / 2) * (livingReward + discount * (west_local)));


    direction_east = ((1 - noise) * (livingReward + discount * (east_local))) ...
    + ((noise / 2) * (livingReward + discount * (north_local))) ...
    + ((noise / 2) * (livingReward + discount * (south_local)));


    direction_west = ((1 - noise) * (livingReward + discount * (west_local))) ...
    + ((noise / 2) * (livingReward + discount * (north_local))) ...
    + ((noise / 2) * (livingReward + discount * (south_local)));
    
    [max_value , direction ] = max([direction_east direction_north direction_west direction_south]);
end

function valid = valid_side(x,y,direction)
    global east;
    global north;
    global west;
    global south;
    valid = false;
    switch(direction)
        case east
            if( y + 1 ) < 6
                valid = true;
            end
        case north
            if( x - 1 ) > 0
                valid = true;
            end
        case west
            if( y - 1 ) > 0
                valid = true;
            end            
        case south
             if( x + 1 ) < 6
                valid = true;
            end           
    end
end