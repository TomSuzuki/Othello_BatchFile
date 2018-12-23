# Reversi_BatchFile
動かないときは文字コードをSift-JIS、改行コードをCR+LFにしてください。（何故か文字化けすることがある。）
リバーシ。  
処理が遅い。  
なぜBatchFileで作ろうと思ったのか...

## 配列もどき
iが0のとき、  
call echo %%arr[%i%]%%は  
echo %arr[0]%に変換される（らしい）
