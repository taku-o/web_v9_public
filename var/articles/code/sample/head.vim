" 1�x�X�N���v�g��ǂݍ��񂾂�A2�x�ڂ͓ǂݍ��܂Ȃ�
:if exists('loaded_head')
    :finish
:endif
:let loaded_head = 1

" g:head_file_splitter�I�v�V�������ݒ肳��Ă�����A�A
" ���̃I�v�V�����̒l���g�p����
" g:head_file_splitter�I�v�V�������ݒ肳��Ă��Ȃ�������A�A
" �X�N���v�g�Œ�`�����f�t�H���g�l���g�p����
:if exists('g:head_file_splitter')
    :let s:spc = g:head_file_splitter
:else
    :if has('win32')
        :let s:spc = ";"
    :else
        :let s:spc = ":"
    :endif
:endif

" g:head_display_lines�I�v�V�������ݒ肳��Ă�����A���̒l���g�p����
" �ݒ肳��Ă��Ȃ�������A�X�N���v�g�̃f�t�H���g�l���g�p����
:if exists('g:head_display_lines')
    :let s:viewsize = g:head_display_lines
:else
    :let s:viewsize = 10
:endif

" �n���ꂽ�l�ŁAs:viewsize���X�V����
:function! s:UpdateViewSize(size)
    :let s:viewsize = a:size
:endfunction

" head:sample.txt�A�������́Ahead;sample.txt
" �Ƃ����t�@�C������n�����̂ŁA
" ���̃t�@�C���̏�̕�������ǂݍ���
:function! s:HeadRead(path)
    " <afile>�Ȃ�expand()�œW�J����
    " �����łȂ��Ȃ�n���ꂽ�t�@�C�������g�p����
    :if a:path == "<afile>"
        :let l:file = expand(a:path)
    :else
        :let l:file = a:path
    :endif

    " ���ۂɓǂލ��ނׂ��t�@�C���̃p�X���擾
    :let l:prot = matchstr(l:file,'^\(head\)\ze' . s:spc)
    :if l:prot != ''
        :let l:file = strpart(l:file, strlen(l:prot) + 1)
    :endif

    " �t�@�C����ǂݍ���ŁA�o�b�t�@�ɃZ�b�g
    :0,$d
    :call setline(1,"foo")
    :let l:lines = readfile(l:file, "", s:viewsize)
    :let l:i = 0
    :while l:i < len(l:lines)
        :call setline(l:i + 2, l:lines[l:i])
        :let l:i += 1
    :endwhile
    :1d

    " �ҏW���ł͂Ȃ���Ԃɂ���
    :set nomodified
    " �t�@�C���^�C�v���Ĕ���
    :filetype detect
:endfunction

" head:sample.txt�A�������́Ahead;sample.txt
" �Ƃ����t�@�C������n�����̂ŁA
" ���̃t�@�C���̏�̕��������o�b�t�@�̃e�L�X�g�ōX�V����
:function! s:HeadWrite(path)
    " <afile>�Ȃ�expand()�œW�J����
    " �����łȂ��Ȃ�n���ꂽ�t�@�C�������g�p����
    :if a:path == "<afile>"
        :let l:file = expand(a:path)
    :else
        :let l:file = a:path
    :endif

    " ���ۂɓǂލ��ނׂ��t�@�C���̃p�X���擾
    :let l:prot = matchstr(l:file,'^\(head\)\ze' . s:spc)
    :if l:prot != ''
        :let l:file = strpart(l:file, strlen(l:prot) + 1)
    :endif

    " �X�V���Ă��ǂ����A���[�U�ɖ₢���킹
    :let choice = confirm("Are you sure, update '".l:file."' head ?", "&Update\n&Cancel")
    :if choice == 1
        " �S�s�ǂݍ���ŁA�t�@�C���̏�̕������X�V
        " �Ō�ɕҏW����Ԃ��N���A�B�ҏW���Ă��Ȃ���Ԃɂ���B
        :let l:lines = filereadable(l:file)? readfile(l:file): []
        :if len(l:lines) > s:viewsize
            :let l:i = 0
            :while l:i < s:viewsize
                :unlet l:lines[l:i- 1]
                :let l:i += 1
            :endwhile

            :let l:curbufs = getline(0, line("$"))
            :call extend(l:curbufs, l:lines)
            :call writefile(l:curbufs, l:file)
            :set nomodified
        :else
            :call writefile(getline(0, line("$")), l:file)
            :set nomodified
        :endif
        :return
    :else
        :return
    :endif
:endfunction

" tail:sample.txt�A�������́Atail;sample.txt
" �Ƃ����t�@�C������n�����̂ŁA
" ���̃t�@�C���̉��̕��������o�b�t�@�ɓǂݍ��ށB
:function! s:TailRead(path)
    " <afile>�Ȃ�expand()�œW�J����
    " �����łȂ��Ȃ�n���ꂽ�t�@�C�������g�p����
    :if a:path == "<afile>"
        :let l:file = expand(a:path)
    :else
        :let l:file = a:path
    :endif

    " ���ۂɓǂލ��ނׂ��t�@�C���̃p�X���擾
    :let l:prot = matchstr(l:file,'^\(tail\)\ze' . s:spc)
    :if l:prot != ''
        :let l:file = strpart(l:file, strlen(l:prot) + 1)
    :endif

    " �t�@�C�������̕������ǂݍ���ŁA�o�b�t�@�ɃZ�b�g����
    :0,$d
    :call setline(1,"foo")
    :let l:lines = readfile(l:file)
    :if len(l:lines) > s:viewsize
        :let l:i = 0
        :while l:i < s:viewsize
            :call setline(l:i + 2, l:lines[len(l:lines) - s:viewsize + l:i])
            :let l:i += 1
        :endwhile
    :else
        :let l:i = 0
        :while l:i < len(l:lines)
            :call setline(l:i + 2, l:lines[l:i])
            :let l:i += 1
        :endwhile
    :endif
    :1d

    " �ҏW���ł͂Ȃ���Ԃɂ���
    :set nomodified
    " �t�@�C���^�C�v���Ĕ���
    :filetype detect
:endfunction

" tail:sample.txt�A�������́Atail;sample.txt
" �Ƃ����t�@�C������n�����̂ŁA
" ���̃t�@�C���̉��̕��������o�b�t�@�̃e�L�X�g�ōX�V����
:function! s:TailWrite(path)
    " <afile>�Ȃ�expand()�œW�J����
    " �����łȂ��Ȃ�n���ꂽ�t�@�C�������g�p����
    :if a:path == "<afile>"
        :let l:file = expand(a:path)
    :else
        :let l:file = a:path
    :endif

    " ���ۂɓǂލ��ނׂ��t�@�C���̃p�X���擾
    :let l:prot = matchstr(l:file,'^\(tail\)\ze' . s:spc)
    :if l:prot != ''
        :let l:file = strpart(l:file, strlen(l:prot) + 1)
    :endif

    " �X�V���Ă��ǂ����A���[�U�ɖ₢���킹
    :let choice = confirm("Are you sure, update '".l:file."' tail ?", "&Update\n&Cancel")
    :if choice == 1
        " �S�s�ǂݍ���ŁA�t�@�C���̉��̕������X�V
        " �Ō�ɕҏW����Ԃ��N���A�B�ҏW���Ă��Ȃ���Ԃɂ���B
        :let l:lines = filereadable(l:file)? readfile(l:file): []
        :if len(l:lines) > s:viewsize
            :let l:i = 0
            :while l:i < s:viewsize
                :unlet l:lines[len(l:lines) - 1]
                :let l:i += 1
            :endwhile
            :call extend(l:lines, getline(0, line("$")))
            :call writefile(l:lines, l:file)
            :set nomodified
        :else
            :call writefile(getline(0, line("$")), l:file)
            :set nomodified
        :endif
        :return
    :else
        :return
    :endif
:endfunction

" autocmd�̃O���[�v���`
" head�Atail�Ŏn�܂�t�@�C���́A���̃X�N���v�g�ɑ��삳�������Ȃ��̂ŁA
" autocmd!�ŁA�ݒ肳�ꂽautocmd�������Ă��܂��B
:augroup Head
    :autocmd!
    :execute ":autocmd BufReadCmd   head" .s:spc. "*,head" .s:spc. "*/* HeadRead  <afile>"
    :execute ":autocmd FileReadCmd  head" .s:spc. "*,head" .s:spc. "*/* HeadRead  <afile>"
    :execute ":autocmd BufWriteCmd  head" .s:spc. "*,head" .s:spc. "*/* HeadWrite <afile>"
    :execute ":autocmd FileWriteCmd head" .s:spc. "*,head" .s:spc. "*/* HeadWrite <afile>"
:augroup END
:augroup Tail
    :autocmd!
    :execute ":autocmd BufReadCmd   tail" .s:spc. "*,tail" .s:spc. "*/* TailRead  <afile>"
    :execute ":autocmd FileReadCmd  tail" .s:spc. "*,tail" .s:spc. "*/* TailRead  <afile>"
    :execute ":autocmd BufWriteCmd  tail" .s:spc. "*,tail" .s:spc. "*/* TailWrite <afile>"
    :execute ":autocmd FileWriteCmd tail" .s:spc. "*,tail" .s:spc. "*/* TailWrite <afile>"
:augroup END

" �t�@�C���̓ǂݏ����p�̃R�}���h���`
:command! -nargs=1 HeadRead  :call s:HeadRead(<f-args>)
:command! -nargs=1 HeadWrite :call s:HeadWrite(<f-args>)
:command! -nargs=1 TailRead  :call s:TailRead(<f-args>)
:command! -nargs=1 TailWrite :call s:TailWrite(<f-args>)

" �v���p�e�B�X�V�p�̃R�}���h���`
:command! -nargs=1 Head      :call s:UpdateViewSize(<f-args>)

" �X�N���v�g�͂����܂�
:finish

==============================================================================
�X�N���v�g�̐���

"head;"�iWindows�ȊO�ł�head:�j���t�@�C�����ɕt����ƁA
�t�@�C���̏ォ��10�s�݂̂�ǂݍ��݁A
"tail;"�iWindows�ȊO�ł�tail:�j���t�@�C�����ɕt����ƁA
�t�@�C���̉�����10�s�݂̂�ǂݍ��ށB
sudo.vim�̂悤�ȏ������s���B

(Windows)
:e head;sample.txt
:r head;sample.txt
:w head;sample.txt
:e tail;sample.txt
:r tail;sample.txt
:w tail;sample.txt

(Windows�ȊO)
:e head:sample.txt
:r head:sample.txt
:w head:sample.txt
:e tail:sample.txt
:r tail:sample.txt
:w tail:sample.txt

==============================================================================
����ׂ��Ƃ���

�E���[�U�[�̐ݒ�̒l�̎���
�Eaugroup�Aautocmd�̎g����
�E���ۂɂ͑��݂��Ȃ��A"head;sample.txt"�A"tail;sample.txt"�Ƃ������O�̃t�@�C���ւ̑����autocmd�ŉ���肷��B
�E"set nomodified"�ŁA�ҏW���̏�Ԃ����Z�b�g
�E"filetype detect"�ŁA�t�@�C���^�C�v�𔻒�ł���
�E���[�U�Ɏ���𓊂��āA���̌��ʂŏ�����ς���

==============================================================================

" vim: set et nowrap ff=unix ft=vim :
