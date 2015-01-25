%% save_kvaser_mat
% Run Kvaser_Mat.m and generate a .mat file

% Prompt for file
[file, path] = uigetfile('', 'Choose a Kvaser MAT file to convert...');
outfile = [ path file(1:end-4) '_Converted.mat' ];
infile = fullfile( path, file );

% Convert and save
[KvaserMap, KvaserHeader] = Kvaser_Mat( infile );
save( outfile, 'KvaserMap', 'KvaserHeader' );