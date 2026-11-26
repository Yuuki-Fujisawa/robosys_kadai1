#!/bin/bash
# SPDX-FileCopyrightText: 2026 Yuuki Fujisawa
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目のテスト失敗"
    res=1
}

res=0

# 1. 正常系（単一行）：500mL x 6本 = 3000mL, 540円 -> 100mLあたり 18.00 円
out=$(printf "500 6 540\n" | ./water)
[ "${out}" = "18.00" ] || ng "$LINENO"

# 2. 正常系（複数行）
out=$(printf "500 6 540\n2000 6 1200\n" | ./water)
expected=$(printf "18.00\n10.00")
[ "${out}" = "${expected}" ] || ng "$LINENO"

# 3. 異常系（数値以外）：終了ステータスが 1 になること
printf "abc\n" | ./water >/dev/null 2>&1
[ "$?" = "1" ] || ng "$LINENO"

# 4. 異常系（負の値段）：終了ステータスが 1 になること
printf "500 6 -100\n" | ./water >/dev/null 2>&1
[ "$?" = "1" ] || ng "$LINENO"

# 5. 異常系（空行）：終了ステータスが 1 になること
printf "\n" | ./water >/dev/null 2>&1
[ "$?" = "1" ] || ng "$LINENO"

[ "${res}" = "0" ] && echo "OK"
exit $res