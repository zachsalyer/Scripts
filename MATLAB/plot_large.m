function [ output_args ] = plot_large( filename, xheader, yheaders ,errors ,limits)
%PLOT_LARGE Summary of this function goes here
%   Detailed explanation goes here

    markers = ['k.'; 'ko'; 'kx'; 'k+'; 'k*'; 'ks'; 'kd' ];
    curmark = 1;
    elcolors = ['y';'m';'c';'r';'g';'b'];
    
    [rows, cols] = size(yheaders);
    xdata = csvimport(filename,'columns',xheader);
    data = csvimport(filename,'columns',yheaders);
    errordata = csvimport(filename,'columns',errors);
    limitdata = csvimport(filename,'columns',limits);
    
    minX = min(xdata);
    maxX = max(xdata);
    minY = 0;
    maxY = 0;

    %find the min/max of data set
    for n = 1:rows
        if minY > min(data(:,n))
            minY = min(data(:,n));
        end
        if maxY < max(data(:,n))
            maxY = max(data(:,n));
        end
    end
    
    %plot the errors and limits
    ratio = 1;
    numoferrors = size(errors);
    numoferrors = numoferrors(1);
    numoflimits = size(limits);
    numoflimits = numoflimits(1);
    dec = ratio/(numoflimits + numoferrors+1);
    curcolor = 1;
    figure();
    if isempty(errors) ~= 1
        for n = 1:numoferrors
            H=area(xdata,ratio*maxY*limitdata(:,n));
            h=get(H,'children');
            set(h,'FaceAlpha',1,'FaceColor',elcolors(curcolor,:));
            hold on;
            ratio = ratio - dec;
            curcolor = curcolor + 1;
        end
    end
    if isempty(limits) ~= 1
        for n = 1:numoflimits
            H=area(xdata,ratio*maxY*errordata(:,n));
            h=get(H,'children');
            set(h,'FaceAlpha',1,'FaceColor',elcolors(curcolor,:));
            hold on;
            ratio = ratio - dec;
            curcolor = curcolor + 1;
        end
    end
    
    for n = 1:rows
        %grab data from file, plot
        ydata = data(:,n);
        plot(xdata, ydata, markers(curmark,:));

        hold on;
        if curmark == length(markers)
            curmark = 1;
        else
            curmark = curmark + 1;
        end
    end
    axis([minX maxX minY maxY])
    legendheaders = char(errors,limits,yheaders);
    legend(legendheaders,'location','NorthEastOutside')
end