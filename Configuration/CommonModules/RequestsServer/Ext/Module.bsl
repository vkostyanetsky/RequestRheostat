////////////////////////////////////////////////////////////////////////////////
// PUBLIC

#Region Public

Procedure MakeRequest(SourceID) Export

	Record = InformationRegisters.Requests.CreateRecordManager();

	Record.PendingDate = CurrentSessionDate();
	
	StickToMaximumRequestsNumberPerSecond();
		
	Record.JobNumber = SourceID;
	Record.RequestDateInMS = CurrentUniversalDateInMilliseconds();
	
	Record.RequestDate = CurrentSessionDate();	

	Record.Write();		
	
EndProcedure

Procedure MakeRequests(SourceID, RequestsNumber) Export

	For RequestNumber = 1 To RequestsNumber Do
		MakeRequest(SourceID);	
	EndDo;
	
EndProcedure

Procedure SetMaximumRequestsNumberPerSecond(Value) Export
	
	Constants.MaximumRequestsNumberPerSecond.Set(Value);
	
EndProcedure	
	
Function MaximumRequestsNumberPerSecond() Export
	
	Return Constants.MaximumRequestsNumberPerSecond.Get();
	
EndFunction

#EndRegion

////////////////////////////////////////////////////////////////////////////////
// PRIVATE

#Region Private

Procedure LockRequestsNumberPerSecondConstant()

	DataLock = New DataLock;
				
	LockItem = DataLock.Add("Constant.RequestsNumberPerSecond");
	LockItem.Mode = DataLockMode.Exclusive;
				
	DataLock.Lock();	

EndProcedure

Procedure StickToMaximumRequestsNumberPerSecond()

	While Not CanMakeRequestInThisSecond() Do
		Pause(0.5);
	EndDo;	
			
EndProcedure

Procedure Pause(DurationInSeconds)
	
	BeginDate	= CurrentSessionDate();
	Counter		= 0;
	
	While True Do
		
		Counter = Counter + 1;
		
		If Counter % 10000 = 0 Then
			
			If CurrentSessionDate() - BeginDate > DurationInSeconds Then
				Return;
			EndIf;
			
		EndIf;
		
	EndDo;
	
EndProcedure

Function RequestsNumberPerThisSecondByDefault(Date)

	Result = New Structure;
			
	Result.Insert("Date", Date);
	Result.Insert("Value", 0);	
	
	Return Result;
	
EndFunction

Function RequestsNumberPerThisSecond()
	
	Date = CurrentSessionDate();
	
	RequestsNumber = Constants.RequestsNumberPerSecond.Get().Get();
	
	If RequestsNumber = Undefined Or RequestsNumber.Date <> Date Then
		RequestsNumber = RequestsNumberPerThisSecondByDefault(Date);	
	EndIf;
		
	Return RequestsNumber; 
	
EndFunction		

Function CanMakeRequestInThisSecond()
	
	Result = False;
	
	BeginTransaction();
			
	Try
				
		LockRequestsNumberPerSecondConstant();		
			
		RequestsNumber = RequestsNumberPerThisSecond();
		                  		
		If RequestsNumber.Value < MaximumRequestsNumberPerSecond() Then

			Result = True;
			
			RequestsNumber.Value = RequestsNumber.Value + 1;
	
			Constants.RequestsNumberPerSecond.Set(New ValueStorage(RequestsNumber));		
			
		EndIf;
							
		CommitTransaction();
				
	Except
				
		RollbackTransaction();
			
		Raise;
				
	EndTry;		
	
	Return Result;
	
EndFunction	

#EndRegion