Const ForReading = 1
Const ForWriting = 2
Const bWaitOnReturn = True

Set oShell = CreateObject("WScript.Shell")
SysDrive = oShell.ExpandEnvironmentStrings("%SystemDrive%")
Set objFSO = CreateObject("Scripting.FileSystemObject")
PathToScript = Wscript.ScriptFullName
Set ScriptFile = objFSO.GetFile(PathToScript)
CurrentDirectory = objFSO.GetParentFolderName(ScriptFile)

' Exporta lista de File Screens
oShell.Run "cmd /c chcp 1251 & filescrn screen list /list-notifications > """ & CurrentDirectory & "\all_filescreens.txt""", 0, bWaitOnReturn

' Exporta templates
oShell.Run "filescrn template export /file:" & CurrentDirectory & "\filescreen_templates.xml", 0, bWaitOnReturn

' Abre arquivos
Set objFileIn = objFSO.OpenTextFile(CurrentDirectory & "\all_filescreens.txt", ForReading)
Set objFileOut = objFSO.OpenTextFile(CurrentDirectory & "\filescreens_create.bat", ForWriting, True)

objFileOut.Write("@echo off" & vbCrLf)
objFileOut.Write("chcp 1251" & vbCrLf)

' Importa templates no novo servidor
objFileOut.Write("filescrn template import /file:" & CurrentDirectory & "\filescreen_templates.xml /Overwrite" & vbCrLf)

Dim screenPath, sourceTemplate

Do Until objFileIn.AtEndOfStream
    line = objFileIn.ReadLine

    If InStr(line, "File Screen Path:") = 1 Then
        screenPath = Trim(Mid(line, Len("File Screen Path:") + 2))
    End If

    If InStr(line, "Source Template:") = 1 Then
        sourceTemplate = Trim(Mid(line, Len("Source Template:") + 2))

        ' Remove sufixos
        sourceTemplate = Replace(sourceTemplate, "(Matches template)", "")
        sourceTemplate = Replace(sourceTemplate, "(Does not match template)", "")
        sourceTemplate = Trim(sourceTemplate)

        ' Gera comando
        If screenPath <> "" And sourceTemplate <> "" Then
            objFileOut.Write("filescrn screen add /path:""" & screenPath & """ /sourcetemplate:""" & sourceTemplate & """ /Overwrite" & vbCrLf)
        End If
    End If
Loop

objFileIn.Close
objFileOut.Close