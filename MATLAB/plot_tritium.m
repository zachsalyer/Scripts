function [ output_args ] = plot_tritium(errors_array, arrays_to_plot)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    maxX = 0;
    minX = 0;
    maxY = 0;
    minY = 0;
    totalArrays = size(arrays_to_plot);
    % Find absolute max and min out of all arrays passed
    for i = 1:2:(totalArrays(2))
        if maxX < max(arrays_to_plot(:,i))
            maxX = max(arrays_to_plot(:,i));
        end
        if minX > min(arrays_to_plot(:,i))
            minX = min(arrays_to_plot(:,i));
        end
        if maxY < max(arrays_to_plot(:,i))
            maxY = max(arrays_to_plot(:,i));
        end
        if minY > min(arrays_to_plot(:,i))
            minY = min(arrays_to_plot(:,i));
        end
        if maxX < max(arrays_to_plot(:,i+1))
            maxX = max(arrays_to_plot(:,i+1));
        end
        if minX > min(arrays_to_plot(:,i+1))
            minX = min(arrays_to_plot(:,i+1));
        end
        if maxY < max(arrays_to_plot(:,i+1))
            maxY = max(arrays_to_plot(:,i+1));
        end
        if minY > min(arrays_to_plot(:,i+1))
            minY = min(arrays_to_plot(:,i+1));
        end
    end
    maxX
    minX
    maxY
    minY
    axis([minX maxX minY maxY])
    len = size(errors_array);
    len = len(1);
    startOfColor = 1;
    img = zeros(len, len, 3);
    lastErrorState = 0;
    for i = 1:len
        currentErrorState = errors_array(i);
        lastErrorState;
        startOfColor;
        if(lastErrorState == 1)
           red = 1;
           blue = 0;
           green = 0;
        else
           red = 1;
           blue = 1;
           green = 1;
        end
        if lastErrorState ~= currentErrorState
            img(:,startOfColor:i,1) = red;
            img(:,startOfColor:i,2) = blue;
            img(:,startOfColor:i,3) = green;
            startOfColor = i;
            lastErrorState = currentErrorState;
        end
    end
    img(:,startOfColor:i,1) = red;
    img(:,startOfColor:i,2) = blue;
    img(:,startOfColor:i,3) = green;
    img = single(img);
    imagesc(minX:maxX,minY:maxY,img)
    hold on
    %axis off
    for i = 1:2:(totalArrays(2))
        plot(arrays_to_plot(:,i),arrays_to_plot(:,i+1), '-k', 'markersize',14);
    end
    %plot(x,y,'-k','markersize',14);
    hold on
end

