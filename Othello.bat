@echo off
setlocal ENABLEDELAYEDEXPANSION
cls

set textColumn[0]=ÇP
set textColumn[1]=ÇQ
set textColumn[2]=ÇR
set textColumn[3]=ÇS
set textColumn[4]=ÇT
set textColumn[5]=ÇU
set textColumn[6]=ÇV
set textColumn[7]=ÇW
set textDraw[1]=Åú
set textDraw[2]=Åõ

:initialize
	for /l %%i in (0,1,7) do (
		for /l %%j in (0,1,7) do (
			set /a x=%%i
			set /a y=%%j
			set /a cell[!x!][!y!]=0
		)
	)
	set /a cell[3][3]=2
	set /a cell[4][4]=2
	set /a cell[4][3]=1
	set /a cell[3][4]=1
	

:game
	call :draw

pause
exit


rem î’ñ Çï`âÊÇ∑ÇÈ
:draw
	for /l %%c in (1,1,2) do (
		set /a cnt=0
		for /l %%i in (0,1,7) do (
			for /l %%j in (0,1,7) do (
				set /a t=!cell[%%i][%%j]!
				if !t! == %%c ( set /a cnt=!cnt!+1 )
			)
		)
		call echo %%textDraw[%%c]%% : !cnt!
	)
	echo Å{Ç`ÇaÇbÇcÇdÇeÇfÇg
	for /l %%i in (0,1,7) do (
		call set msg=%%textColumn[%%i]%%
		for /l %%j in (0,1,7) do (
			set /a x=%%i
			set /a y=%%j
			call set /a s=%%cell[!x!][!y!]%%
			if !s! == 0 ( set msg=!msg!Å@)
			if !s! == 1 ( set msg=!msg!Åú)
			if !s! == 2 ( set msg=!msg!Åõ)
		)
		echo !msg!
	)
	exit /b
