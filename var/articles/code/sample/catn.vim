" 1度スクリプトを読み込んだら、2度目は読み込まない
:if &cp || exists("loaded_catn")
    :finish
:endif
:let loaded_catn = 1

" ユーザの初期設定を逃がす
:let s:save_cpo = &cpo
:set cpo&vim

" 引数の数で処理を分岐する。
:function! s:Catn(...) range
    :if len(a:000) == 0
        :call s:CatnFormat("%d ", 1, a:firstline, a:lastline)
    :elseif len(a:000) == 1
        :call s:CatnFormat("%d ", a:1, a:firstline, a:lastline)
    :else
        :call s:CatnFormat(a:1, a:2, a:firstline, a:lastline)
    :endif
:endfunction

" 指定範囲の先頭に、指定フォーマットの連番を挿入する。
:function! s:CatnFormat(format, start_no, start, end)
    " 順番に行を置き換えていく
    :let l:i = 0
    :while (a:start + l:i) <= a:end
        " 連番の作成
        :let l:no_fmt = printf(a:format, a:start_no + l:i)
        " 行の置き換え
        :let l:line_fmt = printf("%s%s", l:no_fmt, getline(a:start + l:i))
        :call setline(a:start + l:i, l:line_fmt)
        :let l:i += 1
    :endwhile
:endfunction

" 引数可変のコマンドの定義。
:command! -narg=* -range Catn :<line1>,<line2>call s:Catn(<f-args>)

" 退避していたユーザのデータをリカバリ
:let &cpo = s:save_cpo
" スクリプトはここまで
:finish

==============================================================================
スクリプトの説明

選択した範囲の先頭に連番を挿入する。Unixの"cat -n"

:'<,'>Catn {フォーマット} {開始値}
:'<,'>Catn [{開始値}]

:'<,'>Catn
:'<,'>Catn 1000
:'<,'>Catn %08d\  500

==============================================================================
見るべきところ

・書式文字列の使い方
・行の文字列の置き換え方
・コマンドのパラメータの数で呼び出す処理を分岐

==============================================================================

" vim: set ff=unix et ft=vim nowrap :
