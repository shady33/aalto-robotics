% Laksh Bhatia -- 604561
% Inputs Shape: Nx2 Friction : 0 < u < 1
% Output contacts of optimal grasp: 2x2

function contacts = grasp_planner(shape, friction)
    N = size(shape,1);
    mids1 = [];
    mids2 = [];
    xs = [];
    ys = [];
    ks = [];
    short_dist = 0;
    
    % Running Loop for all possible side combinations
    for p1 = 1:N-1
        for p2 = p1+1:N
            % Extracting Coordinates d1,d2 for side 1 and d3,d4 for side 2
            d1 = shape(p1,:);
            d2 = shape(p1+1,:);
            d3 = shape(p2,:);
            if p2 == N
                d4 = shape(1,:);
            else
                d4 = shape(p2+1,:);
            end
            % Midpoints of the two sides
            mid1 = (d1 + d2)/2;
            mid2 = (d3 + d4)/2;
            
            % Perpendiculars to normal i.e. in the direction of the side
            % and its unit normal
            n1per = d2 - mid1;
            n2per = d4 - mid2;
            
            n1per = n1per / norm(n1per);
            n2per = n2per / norm(n2per);
            
            % Angle of rotation - 270 - atan(friction) and 270 +
            % atan(friction)
            alpha = atan(friction);
            theta = (3.14/2);
            R1 = [cos(theta -  alpha) -sin(theta - alpha); sin(theta - alpha) cos(theta - alpha)];
            R2 = [cos(theta + alpha) -sin(theta + alpha); sin(theta + alpha) cos(theta + alpha)];
            
            % Friction Cone
            fc1m = n1per * R1;
            fc1p = n1per * R2;
            fc2m = n2per * R1;
            fc2p = n2per * R2;
            
            % Friction cone to xy coordinates
            x = [fc1m(1) fc1p(1) fc2m(1) fc2p(1)];
            y = [fc1m(2) fc1p(2) fc2m(2) fc2p(2)];
            
             % Convex Hull and Checking whether origin is inside
             k = convhull(x,y);
             IN = inpolygon(0,0,x(k),y(k));

             if(IN == 1)
                 % Shortest Distance from origin to convexhull
                 shortest = -1 * p_poly_dist(0,0,x,y);
                 
                 % Shortest Distance should be maximum to have the most
                 % stable grasp
                 if short_dist < shortest
                     short_dist = shortest;
                     mids1 = mid1;
                     mids2 = mid2;
                     xs = x;
                     ys = y;
                     ks = k;
                 end
             end
        end
    end 
    
    % Plotting Force closure curve and origin
    figure('Name','Force closure and origin')
    hold on
    plot(xs(ks),ys(ks),'r-',xs,ys,'b+')
    plot(0,0,'g*')
    
    ang=0:0.01:2*pi; 
    xp=short_dist*cos(ang);
    yp=short_dist*sin(ang);
    plot(xp,yp)
    axis equal
	hold off
    
    %Polygon Clockwise or not
    sum = 0;
    for i = 1:N
        d1 = shape(i,:);
        if i == N
            d2 = shape(1,:);
        else
            d2 = shape(i+1,:);
        end
        sum = sum + ((d2(1)-d1(1)) * (d2(2)+d1(2)));
    end
    
    % Polygon Clockwise or not 
    if sum < 0 
        % Polygon is clockwise
        xs = -xs;
        ys = -ys;
    end
    
    % Plotting Polygon with friction cone   
    figure('Name','Polygon with Friction Cone')
    hold on
	plot([shape(:,1) ; shape(1,1)],[shape(:,2) ; shape(1,2)])
    plot([mids1(1) mids2(1)],[mids1(2) mids2(2)],'r*')
    quiver([mids1(1) mids1(1) mids2(1) mids2(1)],[mids1(2) mids1(2) mids2(2) mids2(2)],xs,ys);
    axis equal
    hold off
    
    % Returning midpoints
    contacts(1,:) = mids1;
    contacts(2,:) = mids2;
end

function [d,x_poly,y_poly] = p_poly_dist(x, y, xv, yv) 

% If (xv,yv) is not closed, close it.
xv = xv(:);
yv = yv(:);
Nv = length(xv);
if ((xv(1) ~= xv(Nv)) || (yv(1) ~= yv(Nv)))
    xv = [xv ; xv(1)];
    yv = [yv ; yv(1)];
%     Nv = Nv + 1;
end

% linear parameters of segments that connect the vertices
% Ax + By + C = 0
A = -diff(yv);
B =  diff(xv);
C = yv(2:end).*xv(1:end-1) - xv(2:end).*yv(1:end-1);

% find the projection of point (x,y) on each rib
AB = 1./(A.^2 + B.^2);
vv = (A*x+B*y+C);
xp = x - (A.*AB).*vv;
yp = y - (B.*AB).*vv;

% Test for the case where a polygon rib is 
% either horizontal or vertical. From Eric Schmitz
id = find(diff(xv)==0);
xp(id)=xv(id);
clear id
id = find(diff(yv)==0);
yp(id)=yv(id);

% find all cases where projected point is inside the segment
idx_x = (((xp>=xv(1:end-1)) & (xp<=xv(2:end))) | ((xp>=xv(2:end)) & (xp<=xv(1:end-1))));
idx_y = (((yp>=yv(1:end-1)) & (yp<=yv(2:end))) | ((yp>=yv(2:end)) & (yp<=yv(1:end-1))));
idx = idx_x & idx_y;

% distance from point (x,y) to the vertices
dv = sqrt((xv(1:end-1)-x).^2 + (yv(1:end-1)-y).^2);

if(~any(idx)) % all projections are outside of polygon ribs
   [d,I] = min(dv);
   x_poly = xv(I);
   y_poly = yv(I);
else
   % distance from point (x,y) to the projection on ribs
   dp = sqrt((xp(idx)-x).^2 + (yp(idx)-y).^2);
   [min_dv,I1] = min(dv);
   [min_dp,I2] = min(dp);
   [d,I] = min([min_dv min_dp]);
   if I==1, %the closest point is one of the vertices
       x_poly = xv(I1);
       y_poly = yv(I1);
   elseif I==2, %the closest point is one of the projections
       idxs = find(idx);
       x_poly = xp(idxs(I2));
       y_poly = yp(idxs(I2));
   end
end

if(inpolygon(x, y, xv, yv)) 
   d = -d;
end
end