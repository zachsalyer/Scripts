function [pBCurrent, pCCurrent, BusCurrent] = read_wt3000( logfile ) 

delimiter = ',';
startRow = 76;


formatSpec = '%s%*s%s%s%s%s%s%s%*s%*s%s%s%s%s%s%s%s%*s%*s%s%s%s%s%s%s%s%*s%*s%*s%s%s%s%s%s%s%*s%*s%s%*s%*s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(logfile,'r');

textscan(fileID, '%[^\n\r]', startRow-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

% Convert the contents of columns with dates to MATLAB datetimes using date
% format string.
try
    dates{2} = datetime(dataArray{2}, 'Format', 'HH:mm:ss', 'InputFormat', 'HH:mm:ss');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{2} = cellfun(@(x) x(2:end-1), dataArray{2}, 'UniformOutput', false);
        dates{2} = datetime(dataArray{2}, 'Format', 'HH:mm:ss', 'InputFormat', 'HH:mm:ss');
    catch
        dates{2} = repmat(datetime([NaN NaN NaN]), size(dataArray{2}));
    end
end

anyBlankDates = cellfun(@isempty, dataArray{2});
anyInvalidDates = isnan(dates{2}.Hour) - anyBlankDates;
dates = dates(:,2);

%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
StoreNo = cell2mat(rawNumericColumns(:, 1));
Time1 = dates{:, 1};
UE2 = cell2mat(rawNumericColumns(:, 2));
IE2 = cell2mat(rawNumericColumns(:, 3));
PE2 = cell2mat(rawNumericColumns(:, 4));
SE2 = cell2mat(rawNumericColumns(:, 5));
QE2 = cell2mat(rawNumericColumns(:, 6));
FUE2 = cell2mat(rawNumericColumns(:, 7));
IpkE2 = cell2mat(rawNumericColumns(:, 8));
UE3 = cell2mat(rawNumericColumns(:, 9));
IE3 = cell2mat(rawNumericColumns(:, 10));
PE3 = cell2mat(rawNumericColumns(:, 11));
SE3 = cell2mat(rawNumericColumns(:, 12));
QE3 = cell2mat(rawNumericColumns(:, 13));
FUE3 = cell2mat(rawNumericColumns(:, 14));
IpkE3 = cell2mat(rawNumericColumns(:, 15));
UE4 = cell2mat(rawNumericColumns(:, 16));
IE4 = cell2mat(rawNumericColumns(:, 17));
PE4 = cell2mat(rawNumericColumns(:, 18));
SE4 = cell2mat(rawNumericColumns(:, 19));
QE4 = cell2mat(rawNumericColumns(:, 20));
IpkE4 = cell2mat(rawNumericColumns(:, 21));
USigA = cell2mat(rawNumericColumns(:, 22));
ISigA = cell2mat(rawNumericColumns(:, 23));
PSigA = cell2mat(rawNumericColumns(:, 24));
SSigA = cell2mat(rawNumericColumns(:, 25));
QSigA = cell2mat(rawNumericColumns(:, 26));
eta1 = cell2mat(rawNumericColumns(:, 27));
Speed = cell2mat(rawNumericColumns(:, 28));
Torque = cell2mat(rawNumericColumns(:, 29));
Pm = cell2mat(rawNumericColumns(:, 30));


sec = second(Time1) + minute(Time1)*60;
m = tabulate(sec);

i = find(m(:,2)> 1);
secmean = mean(m(i,2));
timediff = 1/secmean;

t = [0:timediff:timediff*(size(Time1)-1)];


% Make timeseries

MotorSpeed                      = timeseries(Speed, t);
MotorSpeed .DataInfo.Units      = 'RPM';
MotorSpeed .Name                = 'Wt3000 Measured Dyno/Motor Speed';
MotorSpeed .UserData            = logfile;

pBCurrent	= timeseries(IE2, t);
pBCurrent.DataInfo.Units		= 'Ampere RMS';
pBCurrent.Name                    = 'Wt3000 Phase B Current';
pBCurrent.UserData                = logfile;

pCCurrent = timeseries(IE3, t);
pCCurrent.DataInfo.Units		= 'Ampere RMS';
pCCurrent.Name                  = 'Phase C Current';
pCCurrent.UserData              = logfile;

BusCurrent	= timeseries(IE4, t);
BusCurrent.DataInfo.Units          = 'Ampere';
BusCurrent.Name                    = 'BusCurrent';
BusCurrent.UserData                = logfile;

end