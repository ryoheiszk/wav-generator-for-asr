#!/usr/bin/env bash

# Windowsパスをbash形式に変換する関数
win_to_bash_path() {
    echo "/$1" | sed -e 's/\\/\//g' -e 's/://'
}

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 入力ファイルが指定されているか確認
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <入力ファイル> [ノイズ除去強度]"
    exit 1
fi

# 入力ファイルのパスを変換
input_file=$(win_to_bash_path "$1")

# 元のスクリプトを呼び出す
if [ $# -eq 1 ]; then
    "$SCRIPT_DIR/script.sh" "$input_file"
else
    "$SCRIPT_DIR/script.sh" "$input_file" "$2"
fi

# ユーザーに何かキーを押すよう促す
echo "処理が完了しました。任意のキーを押して終了してください..."
read -n 1 -s
