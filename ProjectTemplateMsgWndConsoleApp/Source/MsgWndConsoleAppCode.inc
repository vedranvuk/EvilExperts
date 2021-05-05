const ProjectSource = 'program %s;' + #13#10 +
'' + #13#10 +
'uses' + #13#10 +
'	WinApi.Windows, WinApi.Messages;' + #13#10 +
'' + #13#10 +
'{$APPTYPE CONSOLE}' + #13#10 +
'' + #13#10 +
'const' + #13#10 +
'	CMsgWndCls = ''MsgWndClass'';' + #13#10 +
'' + #13#10 +
'var' + #13#10 +
'	wndClass: TWndClass;' + #13#10 +
'	mainWnd : HWND = 0;' + #13#10 +
'' + #13#10 +
'function MsgWndProc(aHandle: HWND; aMessage: UINT; aWParam: WPARAM; aLParam: LPARAM): LRESULT; stdcall;' + #13#10 +
'begin' + #13#10 +
'  	{ Handle messages here }' + #13#10 +
'' + #13#10 +
'	Result := DefWindowProc(aHandle, aMessage, aWParam, aLParam);' + #13#10 +
'end;' + #13#10 +
'' + #13#10 +
'function CreateMsgWindow: boolean;' + #13#10 +
'begin' + #13#10 +
'	Result := False;' + #13#10 +
'	ZeroMemory(@wndClass, SizeOf(wndClass));' + #13#10 +
'' + #13#10 +
'	wndClass.lpfnWndProc   := @MsgWndProc;' + #13#10 +
'	wndClass.hInstance     := hInstance;' + #13#10 +
'	wndClass.lpszClassName := CMsgWndCls;' + #13#10 +
'' + #13#10 +
'	if (RegisterClass(wndClass) <> 0) then' + #13#10 +
'	begin' + #13#10 +
'		mainWnd := CreateWindowEx(0, CMsgWndCls, CMsgWndCls, 0, 0, 0, 0, 0, HWND_MESSAGE, 0, hInstance, nil);' + #13#10 +
'		Result  := (mainWnd <> 0);' + #13#10 +
'	end;' + #13#10 +
'end;' + #13#10 +
'' + #13#10 +
'var' + #13#10 +
'	msg: TMsg;' + #13#10 +
'	ret: integer;' + #13#10 +
'' + #13#10 +
'begin' + #13#10 +
'	if (CreateMsgWindow = False) then' + #13#10 +
'		Exit;' + #13#10 +
'' + #13#10 +
'    { Your Code Here }' + #13#10 +
'' + #13#10 +
'	while (True) do' + #13#10 +
'	begin' + #13#10 +
'		ret := integer(GetMessage(Msg, 0, 0, 0));' + #13#10 +
'		if (ret = 0) then' + #13#10 +
'			Break' + #13#10 +
'		else if (ret = - 1) then' + #13#10 +
'        begin' + #13#10 +
'        	WriteLn(''Error in message loop.'');' + #13#10 +
'            Break;' + #13#10 +
'        end' + #13#10 +
'		else' + #13#10 +
'		begin' + #13#10 +
'			TranslateMessage(Msg);' + #13#10 +
'			DispatchMessage(Msg);' + #13#10 +
'		end;' + #13#10 +
'	end;' + #13#10 +
'end.';
