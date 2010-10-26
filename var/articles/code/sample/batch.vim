" 1�x�X�N���v�g��ǂݍ��񂾂�A2�x�ڂ͓ǂݍ��܂Ȃ�
:if &cp || exists("loaded_batch")
    :finish
:endif
:let loaded_batch = 1

" ���[�U�̏����ݒ�𓦂���
:let s:save_cpo = &cpo
:set cpo&vim

" 1. �I�������͈͂̍s��vim�X�N���v�g��ǂݍ���
" 2. �ꎞ�t�@�C���ɏ����o��
" 3. �ꎞ�t�@�C���ɏ����o����vim�X�N���v�g�����s����
" 4. �ꎞ�t�@�C�����폜����
:function! s:Batch() range
    " �I�������͈͂̍s��vim�X�N���v�g��ǂݍ���
    :let l:selected = getline(a:firstline, a:lastline)
    " �ꎞ�t�@�C���̖��O���擾����
    :let l:tempfile = tempname()
    " try-finally���Ŋm���Ɉꎞ�t�@�C������n������
    :try
        " �ꎞ�t�@�C���ɓǂݍ��񂾃X�N���v�g�������o��
        :call writefile(l:selected, l:tempfile)
        :try
            " �ꎞ�t�@�C����vim�X�N���v�g�����s����
            :execute ":source " . l:tempfile
        :catch
            " �G���[�������́A�G���[�̌����ƃG���[�̋N�����ꏊ��\��
            :echohl WarningMsg |
                \ :echo "EXCEPTION :" v:exception |
                \ :echo "THROWPOINT:" v:throwpoint |
                \ :echohl None
        :endtry
    :finally
        " �t�@�C����ύX�ł��邩�`�F�b�N
        " �i���łɃt�@�C�������邩�ǂ������j
        :if filewritable(l:tempfile)
            " �ꎞ�t�@�C�����폜
            :call delete(l:tempfile)
        :endif
    :endtry
:endfunction

" �s��I�����Ď��s����R�}���hBatch�Bs:Batch()���Ăяo��
:command! -range -narg=0 Batch :<line1>,<line2>call s:Batch()

" �ޔ����Ă������[�U�̃f�[�^�����J�o��
:let &cpo = s:save_cpo
" �X�N���v�g�͂����܂�
:finish

==============================================================================
�X�N���v�g�̐���

vim�X�N���v�g���L�q�����s���r�W���A�����[�h�őI�����āA
:'<,'>Batch
�ŁA�I�������͈͂̍s��vim�X�N���v�g�������Ɏ��s����B

�E�ݒ�t�@�C���̈ꕔ�̂ݓǂݍ���ŁA���ʂ���������
�E�X�N���v�g�̈ꕔ���̂݁A�e�X�g�I�Ɏ��s��������
�ȂǂɎg�p����B

==============================================================================
����ׂ��Ƃ���

�E�ꎞ�t�@�C���̎g����
�Etry-finally�̎g����
�E�͈͎w��\�ȃR�}���h��`�A�I��͈͂̎擾���@

==============================================================================

" vim: set ff=unix et ft=vim nowrap :
