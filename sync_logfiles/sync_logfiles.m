function offset = sync_logfiles(ts1, ts2)
	% This function returns the offset that should be APPLIED to ts2 in
	% order to synchronize ts1 and ts2. 
	% 
	% SO: ts2.Time + offset(ts1, ts2) will match ts1.

	% Resample both timeseries to a suitably small timestep.
	% Our WS200 log interval is 200 ms, so we will use 10 ms here.
	precision = 0.01;	% second
	ts1 = resample( ts1, 0:precision:range(ts1.Time) );
	ts2 = resample( ts2, 0:precision:range(ts2.Time) );
	
	% Offset them so they start at the same time. This is part of our total
	% offset
	offset = ts1.Time(1) - ts2.Time(1);
	
	% Find the cross-correlation between the two timeseries.
	[xc, lags] = xcorr(ts1.Data, ts2.Data);
	[m,i] = max(xc);
	offset = offset + lags(i)*precision;
end