@echo off
setlocal ENABLEDELAYEDEXPANSION
cls

set textColumn[0]=�P
set textColumn[1]=�Q
set textColumn[2]=�R
set textColumn[3]=�S
set textColumn[4]=�T
set textColumn[5]=�U
set textColumn[6]=�V
set textColumn[7]=�W
set textDraw[1]=��
set textDraw[2]=��

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


rem �Ֆʂ�`�悷��
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
	echo �{�`�a�b�c�d�e�f�g
	for /l %%i in (0,1,7) do (
		call set msg=%%textColumn[%%i]%%
		for /l %%j in (0,1,7) do (
			set /a x=%%i
			set /a y=%%j
			call set /a s=%%cell[!x!][!y!]%%
			if !s! == 0 ( set msg=!msg!�@)
			if !s! == 1 ( set msg=!msg!��)
			if !s! == 2 ( set msg=!msg!��)
		)
		echo !msg!
	)
	exit /b
