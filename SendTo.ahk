/*
* @Author : @fwt(chn.fwt@foxmail.com(QQ:408576175))
* @ModIfied by: Jiang Hui (jianghui@zigui.me)
* @Link : https://github.com/536/SendTo
* @Version : 2019-02-02 21:06:30
*/

#NoEnv
#SingleInstance, force
SetWorkingDir, % A_ScriptDir

global DIR_SENDTO := A_AppData "\Microsoft\Windows\SendTo"
global ADD_FOLDER := "__AddFolder.lnk"

Menu, Tray, Icon, % A_ScriptDir "\sources\SendTo.ico"

Menu, Menu_Add, UseErrorLevel
Menu, Menu_Add, Add, About SendTo, label_Menu_About
Menu, Menu_Add, Icon, About SendTo, % A_ScriptDir "\sources\SendTo.ico"
Menu, Menu_Add, Add
Menu, Menu_Add, Add, LinkTo, label_Menu_LinkTo
Menu, Menu_Add, Icon, LinkTo, % A_ScriptDir "\sources\LinkTo.ico"
Menu, Menu_Add, Add
Menu, Menu_Add, Add, CopyTo, label_Menu_CopyTo
Menu, Menu_Add, Icon, CopyTo, % A_ScriptDir "\sources\CopyTo.ico"
Menu, Menu_Add, Add, MoveTo, label_Menu_MoveTo
Menu, Menu_Add, Icon, MoveTo, % A_ScriptDir "\sources\MoveTo.ico"

If A_Args.Length()
{
    ; for i,v in A_Args
    ; {
    ;     MsgBox % "A_Args[" i "] is`n" v
    ; }
    ; 1️⃣with args
    ; 🔶
    If (A_Args[1] = "Add")
    {
        If (A_Args.Length() = 1)
        {
            Run % A_ScriptDir
        }
        Else If (file_IsFolderOrFile(A_Args[2]) = "folder")
        {
            Menu, Menu_Add, Show
        }
    }
    Else If (A_Args[1] = "Linkto")
    {
        If (A_Args.Length() = 1)
        {
            Run % A_ScriptDir
        }
        Else
        {
            for i, v in A_Args
            {
                If (i = 1)
                    Continue
                If (i = 2)
                    Continue
                If (i = A_Args.Length())
                    Run % A_Args[2]
                Linkto(A_Args[i], A_Args[2])
            }
        }
    }
    Else If (A_Args[1] = "CopyTo")
    {
        If (A_Args.Length() = 1)
        {
            Run % A_ScriptDir
        }
        Else
        {
            for i, v in A_Args
            {
                If (i = 1)
                    Continue
                If (i = 2)
                    Continue
                If (i = A_Args.Length())
                    Run % A_Args[2]
                CopyTo(A_Args[i], A_Args[2])
            }
        }
    }
    Else If (A_Args[1] = "MoveTo")
    {
        If (A_Args.Length() = 1)
        {
            Run % A_ScriptDir
        }
        Else
        {
            for i, v in A_Args
            {
                If (i = 1)
                    Continue
                If (i = 2)
                    Continue
                If (i = A_Args.Length())
                    Run % A_Args[2]
                MoveTo(A_Args[i], A_Args[2])
            }
        }
    }
}
Else If FileExist(DIR_SENDTO "\" ADD_FOLDER)
{
    ; 1️⃣no args2️⃣ADD_FOLDER already exists
    MsgBox, 4100, , % A_ScriptName " is installed, do you want to uninstall it?"
    IfMsgBox, Yes
        Gosub label_uninstall
}
Else
{
    ; 1️⃣no args2️⃣ADD_FOLDER not exists
    gosub label_install
}
return

label_install:
    FileCreateShortcut
    , % A_AhkPath
    , % DIR_SENDTO "\" ADD_FOLDER
    ,
    , % """" A_ScriptFullPath """ Add"
    , % "Add Folder"
    , % A_ScriptDir "\sources\SendTo.ico"

    Run % DIR_SENDTO
    MsgBox, 4096, , % "Enjoy it!"
Return
label_uninstall:
Loop, %DIR_SENDTO%\*.lnk
{
    If (A_LoopFileName = ADD_FOLDER)
        FileDelete % A_LoopFileFullPath
    Else If (A_LoopFileName ~= "^_(LinkTo|CopyTo|MoveTo)_.+\.lnk$")
        FileDelete % A_LoopFileFullPath
}
MsgBox, 4096, , % "Thank you for using!"
Return

label_Menu_About:
Return
label_Menu_LinkTo:
    for i, v in A_Args
    {
        If (i = 1)
            Continue
        If (i = A_Args.Length())
            Run % DIR_SENDTO
        If (file_IsFolderOrFile(A_Args[i]) = "folder")
        {
            FileCreateShortcut
            , % """" A_AhkPath """"
            , % DIR_SENDTO "\_" A_ThisMenuItem "_" file_FileNameNoExt(A_Args[i]) ".lnk"
            ,
            , % """" A_ScriptFullPath """ " A_ThisMenuItem " """ A_Args[i] """"
            , % "Create Link to directory: """ A_Args[i] """"
            , % A_ScriptDir "\sources\LinkTo.ico"
        }
    }
Return
label_Menu_CopyTo:
    for i, v in A_Args
    {
        If (i = 1)
            Continue
        If (i = A_Args.Length())
            Run % DIR_SENDTO
        If (file_IsFolderOrFile(A_Args[i]) = "folder")
        {
            FileCreateShortcut
            , % """" A_AhkPath """"
            , % DIR_SENDTO "\_" A_ThisMenuItem "_" file_FileNameNoExt(A_Args[i]) ".lnk"
            ,
            , % """" A_ScriptFullPath """ " A_ThisMenuItem " """ A_Args[i] """"
            , % "Copy selected files to directory: """ A_Args[i] """"
            , % A_ScriptDir "\sources\CopyTo.ico"
        }
    }
Return
label_Menu_MoveTo:
    for i, v in A_Args
    {
        If (i = 1)
            Continue
        If (i = A_Args.Length())
            Run % DIR_SENDTO
        If (file_IsFolderOrFile(A_Args[i]) = "folder")
        {
            FileCreateShortcut
            , % """" A_AhkPath """"
            , % DIR_SENDTO "\_" A_ThisMenuItem "_" file_FileNameNoExt(A_Args[i]) ".lnk"
            ,
            , % """" A_ScriptFullPath """ " A_ThisMenuItem " """ A_Args[i] """"
            , % "Move selected files to directory: """ A_Args[i] """"
            , % A_ScriptDir "\sources\MoveTo.ico"
        }
    }
Return

LinkTo(src, dst) {
    FileCreateShortcut
    , % src
    , % dst "\" file_FileNameNoExt(src) ".lnk"
}
CopyTo(src, dst) {
    If (file_IsFolderOrFile(src) = "Folder")
        FileCopyDir, % src, % dst "\" file_FileNameNoExt(src)
    Else
        FileCopy, % src, % dst
}
MoveTo(src, dst) {
    If (file_IsFolderOrFile(src) = "Folder")
        FileMoveDir, % src, % dst "\" file_FileNameNoExt(src)
    Else
        FileMove, % src, % dst
}

file_IsFolderOrFile(path) {
    If FileExist(path)
    {
        If path ~= "i)^[a-z]:\\$"
            Return "drive"
        Else If RegExMatch(path, "\\$")
            Return "folder"
        Else If FileExist(path "\")
            Return "folder"
        Else
            Return "file"
    }
}
file_FileNameNoExt(path) {
    If (file_IsFolderOrFile(path) = "drive")
        Return path
    SplitPath, path, , , , OutNameNoExt
Return OutNameNoExt
}
