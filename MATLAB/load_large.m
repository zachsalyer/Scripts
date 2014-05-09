function [ headers, mapData ] = load_large( fileName )
%LOAD_LARGE This function loads a file and returns the headers and a map
%with the data. It has no options and is optimized for speed and to
%minimize memory usage
%   Headers is a character array that contains the headers for each of the
%   columns of data
%   mapData is the map containing the data from the file.

    fileIn = fopen(fileName);
    headers = [];
    lineIn = fgets(fileIn);
    
    last = 1;
    pos = 1;
    moveOn =0;
    
    %gets the headers and removes the garbage at the end
    while(pos < length(lineIn))
        if(lineIn(pos) == ' ')
            if moveOn == 0;
                headers = char(headers, lineIn(last:(pos-1)));
                last = pos;
            end
            moveOn = 1;
        else if(lineIn(pos) == ',')
            if moveOn == 0;
                headers = char(headers, lineIn(last:(pos-1)));
            end
            last = pos+1;
            moveOn = 0;
            end
        end
        pos = pos + 1;
    end
    
    %removes the first empty string
    headers = headers((2:length(headers)),:);
    %header for the system time column
    timeHeader = headers(2,:);
    
    row = 1;
    data = [];
    timeData = [];
    while(~feof(fileIn))
        pos = 1;
        column = 1;
        last = 1;
        lineIn = fgets(fileIn);
        while(pos < length(lineIn))
            if(lineIn(pos) == ',')
                if(column == 2)%special case for non-numerical data
                    timeData = char(timeData, lineIn(last:(pos-1)));
                    data(row,column) = 0;
                else%numerical data entry
                    data(row,column) = str2double(lineIn(last:(pos-1)));
                end
                column = column + 1;
                last = pos+1;
            end
            %parse last column's data
            data(row,column) = str2double(lineIn(last:(pos)));
            pos = pos + 1;
        end
        row=row+1;
    end
    
    mapData = containers.Map(headers(1,:),data(:,1));
    timeMap = containers.Map(timeHeader,timeData);
    
    mapData = [mapData;timeMap];
    for n = 2:column
        moreData = containers.Map(headers(n,:),data(:,n));
        mapData=[mapData; moreData];
    end
    
    fclose(fileIn);
end