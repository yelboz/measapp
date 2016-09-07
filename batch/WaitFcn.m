function WaitFcn(~,event,data_object,data)
%WAITSTART Callback function for the "wait" timer.
% event == StartFcn means stopping the timer running the batch (starting to wait)
% event == StopFcn restarting the timer running the batch (stop waiting)

switch event
	case 'StartFcn'
		data.batchflag=0;
	case 'StopFcn'
		data.batchflag=1;

guidata(data_object,data);

end

