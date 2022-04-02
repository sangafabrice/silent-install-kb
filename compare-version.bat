@Echo OFF

:main
: 1=:left_operand_version_string
: 2=:right_operand_version_string
: return:=comparison_value

SetLocal ENABLEDELAYEDEXPANSION
Call :ConvertVersionString "%~1" left_operand
Call :ConvertVersionString "%~2" right_operand
Call :TokenizeVersionString left %left_operand%
Call :TokenizeVersionString right %right_operand%
Set max_length=%left_operand_length%
If %max_length% LSS %right_operand_length% Set max_length=%right_operand_length%
Set GTR_VALUE=2
Set EQU_VALUE=1
Set LSS_VALUE=0
Set comparison_value=%EQU_VALUE%
For /L %%i In (1,1,%max_length%) Do (
    Call :ParseVersionToken left !left_operand[%%i]!
    Call :ParseVersionToken right !right_operand[%%i]!
    If Not !left_check!==!right_check! (
        If !left_check! LSS !right_check! ( Set "comparison_value=%LSS_VALUE%" ) Else Set comparison_value=%GTR_VALUE%
        GoTo End
    )
    Set left_check=
    Set right_check=
)
:End
Echo %comparison_value%
EndLocal
GoTo :EOF

:ConvertVersionString 1=:non-proper-version-string 2:=returned-version-string
    Set operand=%~1
    Echo version:%operand%| FindStr "0 1 2 3 4 5 6 7 8 9" > Nul || (
        Set %~2=0
        GoTo :EOF
    )
    Set operand=%operand:_=.%
    Set operand=%operand:-=.%
    For %%L In (
        " "
        a
        A
        b
        B
        c
        C
        d
        D
        e
        E
        f
        F
        g
        G
        h
        H
        i
        I
        j
        J
        k
        K
        l
        L
        m
        M
        n
        N
        o
        O
        p
        P
        q
        Q
        r
        R
        s
        S
        t
        T
        u
        U
        v
        V
        w
        W
        x
        X
        y
        Y
        z
        Z
    ) Do Set operand=!operand:%%~L=!
    :LoopDot
    Set o=%operand:..=.%
    For %%d In (
        0
        1
        2
        3
        4
        5
        6
        7
        8
        9
    ) Do Set o=!o:.0%%~d=.%%d!
    If Not "%operand%"=="%o%" (
        Set operand=%o%
        GoTo LoopDot
    )
    :LoopChar
    If "%operand:~-1%"=="." (
        Set operand=%operand:~0,-1%
        GoTo LoopChar
    )
    If "%operand:~0,1%"=="." (
        Set operand=%operand:~1%
        GoTo LoopChar
    )
    Set %~2=%operand%
    GoTo :EOF

:TokenizeVersionString 1=:left-or-right 2=:operand_value
    Set i=1
    :LoopSide
    For /F "Tokens=%i% Delims=." %%V In ("%~2") Do (
        Set %~1_operand[%i%]=%%V
        Set %~1_operand_length=%i%
        Set /A i+=1
        GoTo :LoopSide
    )
    GoTo :EOF

:ParseVersionToken 1=:left-or-right 2=:token_value
    Set %~1_check=0
    For /F "Tokens=*" %%d In ('^
        Echo %~2^|^
        FindStr /R /C:"^[0-9]*$"^
    ') Do Set %~1_check=%%d
    GoTo :EOF