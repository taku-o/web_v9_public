" 1�x�X�N���v�g��ǂݍ��񂾂�A2�x�ڂ͓ǂݍ��܂Ȃ�
:if &cp || exists("loaded_catn")
    :finish
:endif
:let loaded_catn = 1

" ���[�U�̏����ݒ�𓦂���
:let s:save_cpo = &cpo
:set cpo&vim

" �����̐��ŏ����𕪊򂷂�B
:function! s:Catn(...) range
    :if len(a:000) == 0
        :call s:CatnFormat("%d ", 1, a:firstline, a:lastline)
    :elseif len(a:000) == 1
        :call s:CatnFormat("%d ", a:1, a:firstline, a:lastline)
    :else
        :call s:CatnFormat(a:1, a:2, a:firstline, a:lastline)
    :endif
:endfunction

" �w��͈͂̐擪�ɁA�w��t�H�[�}�b�g�̘A�Ԃ�}������B
:function! s:CatnFormat(format, start_no, start, end)
    " ���Ԃɍs��u�������Ă���
    :let l:i = 0
    :while (a:start + l:i) <= a:end
        " �A�Ԃ̍쐬
        :let l:no_fmt = printf(a:format, a:start_no + l:i)
        " �s�̒u������
        :let l:line_fmt = printf("%s%s", l:no_fmt, getline(a:start + l:i))
        :call setline(a:start + l:i, l:line_fmt)
        :let l:i += 1
    :endwhile
:endfunction

" �����ς̃R�}���h�̒�`�B
:command! -narg=* -range Catn :<line1>,<line2>call s:Catn(<f-args>)

" �ޔ����Ă������[�U�̃f�[�^�����J�o��
:let &cpo = s:save_cpo
" �X�N���v�g�͂����܂�
:finish

==============================================================================
�X�N���v�g�̐���

�I�������͈͂̐擪�ɘA�Ԃ�}������BUnix��"cat -n"

:'<,'>Catn {�t�H�[�}�b�g} {�J�n�l}
:'<,'>Catn [{�J�n�l}]

:'<,'>Catn
:'<,'>Catn 1000
:'<,'>Catn %08d\  500

==============================================================================
����ׂ��Ƃ���

�E����������̎g����
�E�s�̕�����̒u��������
�E�R�}���h�̃p�����[�^�̐��ŌĂяo�������𕪊�

==============================================================================

" vim: set ff=unix et ft=vim nowrap :
