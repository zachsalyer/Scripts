function [ headers ] = load_headers( filename )
%LOAD_LARGE_FILE Summary of this function goes here
%   Detailed explanation goes here

    fileIn = fopen(filename);
    dirname = (filename(1:(length(filename))-4));
    if isdir(dirname) ~= 1%dir does not exist
        mkdir(dirname);
    end    
    %get the column of data
    line_str = fgets(fileIn);
    fclose(fileIn);
    hfile = fopen([dirname 'headers.csv'],'w');
    fprintf(hfile,'%s',line_str);
    fclose(hfile);
    
    headers = csvimport([dirname 'headers.csv']);
    fprintf('%i Headers found\n',length(headers));
    end
