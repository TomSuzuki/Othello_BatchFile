@echo off
setlocal ENABLEDELAYEDEXPANSION
cls

rem 配列じゃないよ、全部変数だよ
set textColumn[0]=１
set textColumn[1]=２
set textColumn[2]=３
set textColumn[3]=４
set textColumn[4]=５
set textColumn[5]=６
set textColumn[6]=７
set textColumn[7]=８
set textDraw[1]=●
set textDraw[2]=○
set textPlayer[0]=Player
set textPlayer[1]=AI
set /a inputX[A]=0
set /a inputX[B]=1
set /a inputX[C]=2
set /a inputX[D]=3
set /a inputX[E]=4
set /a inputX[F]=5
set /a inputX[G]=6
set /a inputX[H]=7
set /a inputX[a]=0
set /a inputX[b]=1
set /a inputX[c]=2
set /a inputX[d]=3
set /a inputX[e]=4
set /a inputX[f]=5
set /a inputX[g]=6
set /a inputX[h]=7
set /a inputY[1]=0
set /a inputY[2]=1
set /a inputY[3]=2
set /a inputY[4]=3
set /a inputY[5]=4
set /a inputY[6]=5
set /a inputY[7]=6
set /a inputY[8]=7
set /a wayX[0]=-1
set /a wayX[1]=0
set /a wayX[2]=1
set /a wayX[3]=-1
set /a wayX[4]=1
set /a wayX[5]=-1
set /a wayX[6]=0
set /a wayX[7]=1
set /a wayY[0]=-1
set /a wayY[1]=-1
set /a wayY[2]=-1
set /a wayY[3]=0
set /a wayY[4]=0
set /a wayY[5]=1
set /a wayY[6]=1
set /a wayY[7]=1

rem 盤面とか初期化
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
	set /a turn=1

rem ゲームモードを選択
:modeSet
	cls
	echo ゲームモードを選択してください。
	echo [0] Player vs Player
	echo [1] Player vs AI
	echo [2] AI vs Player
	echo [3] AI vs AI
	echo [4] Exit
	set /p mode=">>"
	if not !mode! == 0 if not !mode! == 1 if not !mode! == 2 if not !mode! == 3 if not !mode! == 4 ( goto :modeSet )
	if !mode! == 0 (
		set /a player[1]=0
		set /a player[2]=0
	) else if !mode! == 1 (
		set /a player[1]=0
		set /a player[2]=1
	) else if !mode! == 2 (
		set /a player[1]=1
		set /a player[2]=0
	 )else if !mode! == 3 (
		set /a player[1]=1
		set /a player[2]=1
	) else if !mode! == 4 ( exit )

rem ゲーム
:game
	rem 現在の盤面の描画
	call :draw
	echo ------------------
	call echo %%textDraw[!turn!]%%のターンです。
	
	rem プレイヤーの処理
	call set t=%%player[!turn!]%%
	if !t! == 0 (
		rem player
		call :runPlayer
	) else (
		rem AI
		call :runAI
	)
	
	rem ゲーム処理
	if !turn! == 1 (
		set /a turn=2
	) else (
		set /a turn=1
	)
	
	rem 置ける場所があるかチェック（両方なければ終了）
	call :funcCHKcell
	set /a num=0
	for /l %%i in (0,1,7) do (
		for /l %%j in (0,1,7) do (
			set /a x=%%i
			set /a y=%%j
			call set /a num=!num!+%%CHKcell[!x!][!y!]%%
		)
	)
	
	rem 次のターンのプレイヤーが石を置けない
	if num == 0 (
		if !turn! == 1 (
			set /a turn=2
		) else (
			set /a turn=1
		)
		call :funcCHKcell
		set /a num=0
		for /l %%i in (0,1,7) do (
			for /l %%j in (0,1,7) do (
				set /a x=%%i
				set /a y=%%j
				call set /a num=!num!+%%CHKcell[!x!][!y!]%%
			)
		)
		if num == 0 ( goto :gameExit )
	)
	
	goto :game
	
	pause
	exit
	
:gameExit

	call :draw
	echo ------------------
	echo ゲームが終了しました。
	
	pause
	exit


rem プレイヤーの処理
:runPlayer
	set /p put=置く場所を入力してください（x,y） : 
	call set /a px=%%inputX[%put:~0,1%]%%
	call set /a py=%%inputY[%put:~1,1%]%%
	
	rem 置けるかチェック
	call :funcCHKcell
	call set /a t=%%CHKcell[!px!][!py!]%%
	if !t! == 0 (
		echo !put!に石を置くことができません。別の場所を指定してください。
		goto :runPlayer
	)
	
	rem 置く
	set /a putX=!px!
	set /a putY=!py!
	call :funcSETcell
	
	exit /b

rem AIの処理
:runAI
	
	rem 多く返せるところに置く
	set /a putX=-1
	set /a putY=-1
	set /a max=0
	call :funcCHKcell
	for /l %%i in (0,1,7) do (
		for /l %%j in (0,1,7) do (
			set /a x=%%i
			set /a y=%%j
			call set /a t=%%CHKcell[!x!][!y!]%%
			if !t! gtr !max! (
				set /a max=!t!
				set /a putX=!x!
				set /a putY=!y!
			)
		)
	)
		
	rem 置く
	call :funcSETcell
	
	exit /b

rem 指定したセル（putX,putY）に置く（置けることが前提の関数）
:funcSETcell
	
	set /a cell[!putX!][!putY!]=!turn!
	
	for /l %%f in (0,1,7) do (
		call set /a wx=%%wayX[%%f]%%
		call set /a wy=%%wayY[%%f]%%
		set /a k=0
		set /a add=0
		set /a flg=1
		for /l %%k in (1,1,7) do (
			if !flg! == 1 (
				set /a flg=0
				set /a nx=!putX!+!wx!*%%k
				set /a ny=!putY!+!wy!*%%k
				if !nx! == -1 (
					set /a add=0
				) else if !nx! == 8 (
					set /a add=0
				) else if !ny! == -1 (
					set /a add=0
				) else if !ny! == 8 (
					set /a add=0
				) else (
				 	call set /a t=%%cell[!nx!][!ny!]%%
					if !t! == !turn! (
						rem 自分の石なら処理を終了
					) else if !t! == 0 (
						rem 空白セルなら返せる数を0にし、処理を終了
						set /a add=0
					) else (
						rem 相手の石のときなら返せる数を増やし処理を続行
						set /a add=!add!+1
						set /a flg=1
					)
				)
			)
		)
		for /l %%k in (1,1,!add!) do (
			set /a nx=!putX!+!wx!*%%k
			set /a ny=!putY!+!wy!*%%k
			set /a cell[!nx!][!ny!]=!turn!
		)
	)
	
	exit /b

rem 置ける場所のチェックを行うための配列を生成する
:funcCHKcell
	rem CHKcellの初期化（そのセルにおいたときに返せる石の数が代入される）
	for /l %%i in (0,1,7) do (
		for /l %%j in (0,1,7) do (
			set /a x=%%i
			set /a y=%%j
			set /a CHKcell[!x!][!y!]=0
		)
	)
	
	rem 数える
	for /l %%i in (0,1,7) do (
		for /l %%j in (0,1,7) do (
			set /a cx=%%i
			set /a cy=%%j
			set /a cnt=0
			for /l %%f in (0,1,7) do (
				call set /a wx=%%wayX[%%f]%%
				call set /a wy=%%wayY[%%f]%%
				set /a k=0
				set /a add=0
				set /a flg=1
				for /l %%k in (1,1,7) do (
					if !flg! == 1 (
						set /a flg=0
						set /a nx=!cx!+!wx!*%%k
						set /a ny=!cy!+!wy!*%%k
						if !nx! == -1 (
							set /a add=0
						) else if !nx! == 8 (
							set /a add=0
						) else if !ny! == -1 (
							set /a add=0
						) else if !ny! == 8 (
							set /a add=0
						) else (
						 	call set /a t=%%cell[!nx!][!ny!]%%
							if !t! == !turn! (
								rem 自分の石なら処理を終了
							) else if !t! == 0 (
								rem 空白セルなら返せる数を0にし、処理を終了
								set /a add=0
							) else (
								rem 相手の石のときなら返せる数を増やし処理を続行
								set /a add=!add!+1
								set /a flg=1
							)
						)
					)
				)
				set /a cnt=!cnt!+!add!
			)
			set /a CHKcell[!cx!][!cy!]=!cnt!
		)
	)

	exit /b


rem 盤面を描画する
:draw
	cls
	for /l %%c in (1,1,2) do (
		set /a cnt=0
		for /l %%i in (0,1,7) do (
			for /l %%j in (0,1,7) do (
				set /a t=!cell[%%i][%%j]!
				if !t! == %%c ( set /a cnt=!cnt!+1 )
			)
		)
		call set /a t=%%player[%%c]%%
		call echo %%textDraw[%%c]%% : !cnt! （%%textPlayer[!t!]%%）
	)
	echo ------------------
	echo ＋ＡＢＣＤＥＦＧＨ
	for /l %%i in (0,1,7) do (
		call set msg=%%textColumn[%%i]%%
		for /l %%j in (0,1,7) do (
			set /a x=%%j
			set /a y=%%i
			call set /a s=%%cell[!x!][!y!]%%
			if !s! == 0 ( set msg=!msg!　)
			if !s! == 1 ( set msg=!msg!!textDraw[1]!)
			if !s! == 2 ( set msg=!msg!!textDraw[2]!)
		)
		echo !msg!
	)
	exit /b
