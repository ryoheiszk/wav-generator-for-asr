#!/bin/bash

# FFmpegのパス
ffmpeg="/c/Users/r1999/Desktop/Systems/ffmpeg.exe"

# 入力ファイルが指定されているか確認
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <入力ファイル>"
    exit 1
fi

input_file="$1"

# 入力ファイルのディレクトリとファイル名を取得
input_dir=$(dirname "$input_file")
filename=$(basename -- "$input_file")
filename_noext="${filename%.*}"

# 出力ファイル名を生成（入力ファイルと同じディレクトリ）
output_file="$input_dir/${filename_noext}.wav"

# FFmpegを使用してファイルをWAVに変換
"$ffmpeg" -i "$input_file" -acodec pcm_s16le -ac 1 -ar 16000 "$output_file"

echo "変換完了: $input_file -> $output_file"
