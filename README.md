# mp3_vol_adjustment
* ffmpegを使用して、EBU_R128規格でmp3ファイルの音量を調節してくれるといいなと。
* ざっくり作っちゃったので、諸々問題あるかもですが、一応動くといいな。

## 動作環境
* macOS(のつもりです)
    * ffmpegはdocker使って実行させてるし、M1 macでもいけるはず。

## やってほしいこと
* dockerのインストール
* docker image である、 jrottenberg/ffmpeg をpull
    * docker pull jrottenberg/ffmpeg
* jqコマンドのインストール
    * brew install jq

## スクリプトについて
* ffmpegを使用して、EBU_R128規格でmp3ファイルをエンコードします。
* 3つの引数を取ります。
    * 第1引数: mp3ファイルが置かれているディレクトリのフルパス
    * 第2引数: 音量を調整したいmp3ファイル(入力ファイル)
    * 第3引数: 音量調節後のmp3ファイル(出力ファイル)

## 実行サンプル

```
# [Before] Directory Structure
# /your/target/dir
#               ├── sample1.mp3
#               ├── sample2.mp3
#               └── sample3.mp3

# Execute script.
$ TARGET_DIR='/your/target/dir'
$ INPUT_FILE_NAME='sample1.mp3'
$ OUTPUT_FILE_NAME='encoded_sample1.mp3'
$ mp3_vol_adjustment ${TARGET_DIR} ${INPUT_FILE_NAME} ${OUTPUT_FILE_NAME}


# [After] Directory Structure
# /your/target/dir
#               ├── output
#               │        └── encoded_sample1.mp3
#               ├── sample1.mp3
#               ├── sample2.mp3
#               └── sample3.mp3
```

## やってること

以下の処理の流れをシェルスクリプトでまとめた感じです。
(ffmpegの実行は、jrottenberg/ffmpeg のdocker imageを通して実行してます。)

1. 下のコマンドで、対象mp3ファイルの情報を取得

`$ ffmpeg -i input.mp3 -af loudnorm=I=-23:LRA=7:TP=-2.0:print_format=json -f null -`

2. 1.で得られた結果を measured_X に適応して、再エンコードする

`$ ffmpeg -i input.mp3 -af loudnorm=I=-23:LRA=7:TP=-2.0:measured_I=-23.2:measured_LRA=6.5:measured_TP=-2.5:linear=true:print_format=summary -codec:a libmp3lame -q:a 2 output.mp3`


### 今回使用したffmpegのオプション説明
* loudnorm
    * 音量を正規化するためのフィルター
    * EBU R128規格に基づいたアルゴリズムを使用して音量を自動調整
* I
    * 目標の平均音量を指定
    * -23は一般的な目標音量
* LRA
    * 目標の音量範囲を指定
    * 7は一般的な値
* TP
    * 目標ピーク音量を指定
    * -2.0は一般的な値
* measured_I
    * 実際に計測された平均音量を指定
* measured_LRA
    * 実際に計測された音量範囲を指定
* measured_TP
    * 実際に計測されたピーク音量を指定
* linear
    * 音量正規化を線形モードで行うかどうかを指定
    * trueに設定されている場合は線形モードで処理 (音量の変換にロスのない処理)
* print_format
    * 結果の出力形式を指定
    * summary: 簡略的な形式で出力

* -codec:a libmp3lame
    * 出力ファイルの音声コーデックを指定するオプション
    * この場合、libmp3lameというMP3のエンコーダが指定されていmす
 
* -q:a 2
    * 音質を指定するオプション
    * 2は、音声の品質を指定するオプション
        * 2は、比較的高音質でありながら、ファイルサイズを大幅に削減することが可能らしいです。
    * 0から9の範囲で指定可能
        * 0: 最高品質
        * 9: 最低品質
