/*
 * @Author     : @fwt(chn.fwt@foxmail.com(QQ:408576175))
 * @Modified by: Jiang Hui (jianghui@zigui.me)
 * @Link       :
 * @Version    : 2019-02-02 21:06:30
 */

#NoEnv
#SingleInstance, force
; #NoTrayIcon
SetWorkingDir, % A_ScriptDir

global U_SendTo := A_AppData "\Microsoft\Windows\SendTo"
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
Menu, Menu_Add, Add, CopyTo, label_Menu_Add
Menu, Menu_Add, Add, LinkTo, label_Menu_Add
Menu, Menu_Add, Add, MoveTo, label_Menu_Add

if A_Args.Length()
{
    ; for i,v in A_Args
    ; {
    ;     msgbox % "A_Args[" i "] is`n" v
    ; }
    if (A_Args[1] = "Add")
    {
        if FileExist(A_Args[2]) && (file_IsFolderOrFile(A_Args[2]) = "folder")
            Menu, Menu_Add, Show
    }
    else if (A_Args[1] = "CopyTo")
    {
        if FileExist(A_Args[2])
        {
            if FileExist(A_Args[3])
            {
                CopyTo(A_Args[3], A_Args[2])
                run % A_Args[2]
            }
            Else
                run % A_Args[2]
        }
    }
    Else if (A_Args[1] = "Linkto")
    {
        if FileExist(A_Args[2])
        {
            if FileExist(A_Args[3])
            {
                LinkTo(A_Args[3], A_Args[2])
                run % A_Args[2]
            }
            Else
                run % A_Args[2]
        }
    }
    Else if (A_Args[1] = "MoveTo")
    {
        if FileExist(A_Args[2])
        {
            if FileExist(A_Args[3])
            {
                MoveTo(A_Args[3], A_Args[2])
                run % A_Args[2]
            }
            Else
                run % A_Args[2]
        }
    }
}
else if fileexist(U_SendTo "\__AddFolder.lnk")
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
        , % U_SendTo "\__AddFolder.lnk"
        ,
        , % """" A_ScriptFullPath """ Add"
        , % "Add Folder"
        , % A_ScriptDir "\" file_FileNameNoExt(A_ScriptFullPath) ".ico"

    MsgBox Success!
    Run % U_SendTo
    Return
label_uninstall:
    Return

label_Menu_Add:
    if (A_Args[2] = A_Desktop)
        IconNumber := 105
    Else
        IconNumber := 4
    FileCreateShortcut
        , % """" A_AhkPath """"
        , % U_SendTo "\_" A_ThisMenuItem "_" file_FileNameNoExt(A_Args[2]) ".lnk"
        ,
        , % """" A_ScriptFullPath """ " A_ThisMenuItem " """ A_Args[2] """"
        , % "Description"
        , % "imageres.dll"
        ,
        , % IconNumber
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
