% Supply a mat file from the kvaser and this will create a new mat file
% better structured to do analsys on.

%% USER UPDATE THIS!

% Prompt
[file, path] = uigetfile( 'mat', 'Select an input MATfile to convert' );
matname = [ path file(1:end-4) '_Converted.mat' ];
file = fullfile( path, file );

% Hard-coded
% file = '2015-01-06_airflow_test_001.mat';
% matname = 'test.mat';

%% USER DON'T CHANGE THIS!
map = containers.Map;
varlist = whos('-file',file);

% Save the Kvaser start time (to write into timeseries)
load(file, 'header');
starttime = [header.startdate ' ' header.starttime];

clear headers
[r,c] = size(varlist);
headers{1} = '0';
for i = [1:r]
    if(strcmp(varlist(i).name,'header')) 
        continue 
    end
    k = load(file,varlist(i).name);
    var = getfield(k,varlist(i).name);
    n = regexp(var.Channelname, '_\d*_', 'split');
    n = regexp(n{2}, '_\d*', 'split');
    sig.name = n{1};
    check = 0;
    while max(ismember(headers,sig.name))
        if check == 0
           sig.name = strcat(sig.name,'2');
           check = 3;
        else
            sig.name(end) = check;
            check = check + 1;
        end
    end
    sig.ts = timeseries(var.signals.values,var.time);
    sig.ts.Name = sig.name;
	sig.ts.TimeInfo.StartDate = starttime; 
    sig.time = var.time;
    sig.value = var.signals.values;
    map(sig.name) = sig;
    headers{i} = sig.name;
end

save(matname,'headers','map');

