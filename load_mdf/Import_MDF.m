function [] = Import_MDF(filename)

if nargin == 0
    [FileName,PathName] = uigetfile('*.mdf','Select MDF');
    filename = [PathName FileName];
end

mdfimport(filename, 'Auto MAT-File');

file = filename(1:end-4);

%vars = whos('-file',file);

vars = load(file);

fields = fieldnames(vars);
delete([file '.mat']);
for i = 2:numel(fields)
    var = vars.(fields{i});
    s = strsplit(fields{i},'_');
    t = vars.(['time_' s{end}]);
    ts = timeseries(var(1:length(t)),t,'name', s{1});
    assignin('base',s{1},ts);
end
    