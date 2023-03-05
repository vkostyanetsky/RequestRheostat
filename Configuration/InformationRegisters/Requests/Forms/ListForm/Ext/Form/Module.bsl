////////////////////////////////////////////////////////////////////////////////
// FORM EVENT HANDLERS

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	If RequestsServer.MaximumRequestsNumberPerSecond() = 0 Then
		RequestsServer.SetMaximumRequestsNumberPerSecond(1);	
	EndIf;
	
	If JobsNumber = 0 Then
		JobsNumber = 10;
	EndIf;
	
	If RequestsNumberPerJob = 0 Then
		RequestsNumberPerJob = 5;	
	EndIf;
	
	SetListGroupedParameters();
	
EndProcedure

#EndRegion

////////////////////////////////////////////////////////////////////////////////
// FORM ITEM HANDLERS

#Region FormItemHandlers

&AtClient
Procedure MaximumRequestsNumberPerSecondOnChange(Item)

	MaximumRequestsNumberPerSecondOnChangeAtServer();

EndProcedure

#EndRegion

////////////////////////////////////////////////////////////////////////////////
// COMMAND HANDLERS

#Region CommandHandlers

&AtClient
Procedure MakeRequests(Command)
	
	MakeRequestsAtServer(JobsNumber, RequestsNumberPerJob);			

EndProcedure

&AtClient
Procedure DeleteRequests(Command)
	
	DeleteRequestsAtServer();

    RefreshListsAtClient();

EndProcedure

&AtClient
Procedure RefreshLists(Command) 
	
	RefreshListsAtClient();	
	
EndProcedure

#EndRegion

////////////////////////////////////////////////////////////////////////////////
// PRIVATE

#Region Private

&AtServerNoContext
Procedure MakeRequestsAtServer(JobsNumber, RequestsNumberPerJob)
	
	For JobNumber = 1 To JobsNumber Do			

		JobParameters = New Array;
		JobParameters.Add(JobNumber);
		JobParameters.Add(RequestsNumberPerJob);
		
		BackgroundJobs.Execute("RequestsServer.MakeRequests", JobParameters, JobNumber);	
		
	EndDo;	
		
EndProcedure

&AtServer
Procedure SetListGroupedParameters()
	
	MaximumRequestsNumberPerSecond = MaximumRequestsNumberPerSecond();
	
	Exceedings.Parameters.SetParameterValue("MaximumRequestsNumber", MaximumRequestsNumberPerSecond);	
	
EndProcedure

&AtClient
Procedure RefreshListsAtClient() 
	
	Items.List.Refresh();
	Items.Exceedings.Refresh();	
	
EndProcedure

&AtServer
Procedure DeleteRequestsAtServer()
	
	RecordManager = InformationRegisters.Requests.CreateRecordSet();
	
	RecordManager.Write();
	
EndProcedure

&AtServer
Procedure MaximumRequestsNumberPerSecondOnChangeAtServer()

	RequestsServer.SetMaximumRequestsNumberPerSecond(MaximumRequestsNumberPerSecond);	
	
	SetListGroupedParameters();

EndProcedure

&AtServerNoContext
Function MaximumRequestsNumberPerSecond()
	
	Return RequestsServer.MaximumRequestsNumberPerSecond();	
	
EndFunction

#EndRegion