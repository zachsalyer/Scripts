function [offset, fit] = sync_logfiles(ts1, ts2)
	% Set bounds on the offset s.t. the two dataseries must overlap
	% by at least 10% of the length of the shorter one.
	shortest = min( range( ts1.Time ), range( ts2.Time ));
	bound1 = ts2.Time(1) - ts1.Time(end);
	bound2 = ts2.Time(end) - ts1.Time(1);
	
	% TODO: add 10% overlap requirement
	offset_min = min( bound1, bound2 ) + 0.1*shortest;
	offset_max = max( bound1, bound2 ) - 0.1*shortest;
	
	[offset, fit] = fminbnd( @(offset) offset_error(ts1, ts2, offset), offset_min, offset_max );
end

function error = offset_error(ts1, ts2, offset)
	% Apply offset
	ts2.Time = ts2.Time + offset;
	
	% Synchronize on union
	[ts1 ts2] = synchronize(ts1, ts2, 'Union');
	avg = mean( ts2.Data - ts1.Data );
	error = sum( (ts2.Data-ts1.Data).^2 );		% SSE
	%error = rms( ts2.Data-ts1.Data );			% RMS
	%error = sum( (ts2.Data-ts1.Data).^2 )/sum( (ts2.Data-ts1.Data)-avg ); % R^2
end
