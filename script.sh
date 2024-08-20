#!/bin/bash

# FFmpegのパス
ffmpeg="/c/Users/r1999/Desktop/Systems/ffmpeg.exe"

# 使用方法を表示する関数
usage() {
    echo "使用方法: $0 <入力ファイル> [ノイズ除去強度]"
    echo "ノイズ除去強度: 0.01から97の間の値。大きいほど強い除去効果。"
    echo "指定しない場合、ノイズ除去は適用されません。"
    exit 1
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

# 浮動小数点数の比較関数
float_cmp() {
    awk "BEGIN {exit !($1 $2 $3)}"
}

# 入力ファイルが指定されているか確認
if [ $# -eq 0 ]; then
    usase
fi

input_file="$1"
noise_reduction=""

# ノイズ除去強度が指定されている場合、フィルターを設定
if [ $# -eq 2 ]; then
    if float_cmp "$2" ">=" "0.01" && float_cmp "$2" "<=" "97"; then
        noise_reduction="-af afftdn=nr=$2"
        nr_suffix="_nr$2"
    else
        echo "エラー: ノイズ除去強度は0.01から97の間で指定してください。"
        exit 1
    fi
fi

# 入力ファイルのディレクトリとファイル名を取得
input_dir=$(dirname "$input_file")
filename=$(basename -- "$input_file")
filename_noext="${filename%.*}"

# タイムスタンプを生成（ミリ秒まで）
timestamp=$(date +"%Y%m%d%H%M%S%3N")

# 出力ファイル名を生成（入力ファイルと同じディレクトリ、タイムスタンプ付き）
output_file="$input_dir/${filename_noext}_${timestamp}_$2.wav"

# FFmpegを使用してファイルをWAVに変換し、ノイズ除去を適用
"$ffmpeg" -i "$input_file" $noise_reduction -acodec pcm_s16le -ac 1 -ar 16000 "$output_file"

echo "変換完了: $input_file -> $output_file"
if [ -n "$noise_reduction" ]; then
    echo "ノイズ除去適用: 強度 $2"
else
    echo "ノイズ除去: 適用なし"
fi
