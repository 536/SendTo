/*
 * @Author     : @fwt(chn.fwt@foxmail.com(QQ:408576175))
 * @Modified by: Jiang Hui (jianghui@zigui.me)
 * @Link       : https://github.com/536/SendTo
 * @Version    : 2019-02-02 21:06:30
 */

#NoEnv
#SingleInstance, force
SetWorkingDir, % A_ScriptDir

global DIR_SENDTO := A_AppData "\Microsoft\Windows\SendTo"
global ADD_FOLDER := "__AddFolder.lnk"
/*
AddFolder
    foldername
        menu Menu_Add
                Copy
                    foldername
                Link
                    foldername
                Move
                    foldername
Copy
    src dst
Link
    src dst
Move
    src dst
*/
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

if A_Args.Length()
{
    ; for i,v in A_Args
    ; {
    ;     msgbox % "A_Args[" i "] is`n" v
    ; }
    for i, v in A_Args
    {
        if (A_Args[1] != "Add" And i = 2)
        {
            Run % A_Args[2]
        }
        Else if (i > 1)
        {
            if (A_Args[1] = "Add" And FileExist(A_Args[i]) And file_IsFolderOrFile(A_Args[i]) = "folder")
                Menu, Menu_Add, Show
        }
        Else if (i > 2)
        {
            if FileExist(A_Args[2]) And FileExist(A_Args[i])
            {
                if (A_Args[1] = "Linkto")
                    Linkto(A_Args[i], A_Args[2])
                Else If (A_Args[1] = "CopyTo")
                    CopyTo(A_Args[i], A_Args[2])
                Else If (A_Args[1] = "MoveTo")
                    MoveTo(A_Args[i], A_Args[2])
            }
        }
    }
}
else if fileexist(DIR_SENDTO "\" ADD_FOLDER)
{
    msgbox, 4, , % A_ScriptName " is installed, do you want to uninstall it?"
    IfMsgBox, Yes
        Gosub label_uninstall
    Else
        msgbox % "Thank you for using!"
}
Else
{
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
        , % A_ScriptDir "\sources\" file_FileNameNoExt(A_ScriptFullPath) ".ico"

    MsgBox Success!
    Run % DIR_SENDTO
    Return
label_uninstall:
    Return

label_Menu_About:
    Return
label_Menu_LinkTo:
    FileCreateShortcut
        , % """" A_AhkPath """"
        , % DIR_SENDTO "\_" A_ThisMenuItem "_" file_FileNameNoExt(A_Args[2]) ".lnk"
        ,
        , % """" A_ScriptFullPath """ " A_ThisMenuItem " """ A_Args[2] """"
        , % "Create Link to directory: """ A_Args[2] """"
        , % A_ScriptDir "\sources\LinkTo.ico"
    Return
label_Menu_CopyTo:
    FileCreateShortcut
        , % """" A_AhkPath """"
        , % DIR_SENDTO "\_" A_ThisMenuItem "_" file_FileNameNoExt(A_Args[2]) ".lnk"
        ,
        , % """" A_ScriptFullPath """ " A_ThisMenuItem " """ A_Args[2] """"
        , % "Copy selected files to directory: """ A_Args[2] """"
        , % A_ScriptDir "\sources\CopyTo.ico"
    Return
label_Menu_MoveTo:
    FileCreateShortcut
        , % """" A_AhkPath """"
        , % DIR_SENDTO "\_" A_ThisMenuItem "_" file_FileNameNoExt(A_Args[2]) ".lnk"
        ,
        , % """" A_ScriptFullPath """ " A_ThisMenuItem " """ A_Args[2] """"
        , % "Move selected files to directory: """ A_Args[2] """"
        , % A_ScriptDir "\sources\MoveTo.ico"
    Return

LinkTo(src, dst) {
    FileCreateShortcut
        , % src
        , % dst "\" file_FileNameNoExt(src) ".lnk"
}
CopyTo(src, dst) {
    if (file_IsFolderOrFile(src) = "Folder")
        FileCopyDir, % src, % dst "\" file_FileNameNoExt(src)
    else
        FileCopy, % src, % dst
}
MoveTo(src, dst) {
    if (file_IsFolderOrFile(src) = "Folder")
        FileMoveDir, % src, % dst "\" file_FileNameNoExt(src)
    else
        FileMove, % src, % dst
    return
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
