" loki.vim "{{{1

" Last Update: Nov 21, Fri | 23:42:06 | 2014

" vars "{{{2

let s:BufE_Loc='english.loc'
let s:BufC_Loc='chinese.loc'
let s:BufT_Loc='tmp.loc'
let s:BufG_Loc='glossary.loc'

let s:File_Glossary = 'glossary.loc'
let s:File_Source = 'english.loc'
let s:File_Tmp = 'ztmp'
let s:File_Output = 'tmp.loc'

let s:Win_Shell = 1
let s:Win_Trans = 2

 "}}}2

" functions "{{{2

" parts "{{{3

function! s:Yank() "{{{

    " yank GUID
    if bufwinnr('%') == s:Win_Trans
        execute 'normal ^2f	lviW'
    " yank Chinese
    elseif bufwinnr('%') == s:Win_Shell
        execute 'normal ^5f	lviW'
    endif

endfunction "}}}

function! s:Grep(text,output) "{{{

    " grep glossary/source
    if a:text == 'glossary'
        let l:text = s:File_Glossary
    elseif a:text == 'source'
        let l:text = s:File_Source
    endif

    let l:grep = 'grep -i' . " '" . @" . "'" .
    \ ' ' . l:text

    " tmp file
    let l:tmp = ' >' . ' ' . s:File_Tmp . ' &&' .
    \ ' cat' . ' ' . s:File_Tmp

    " output to Vim
    " overwrite buffer
    if a:output == 'write'
        let l:output = ' >' . ' ' . s:File_Output
    " add to buffer
    elseif a:output == 'add'
        let l:output = ' >>' . ' ' . s:File_Output
    endif

    " shell command
    if a:output == 'write' || a:output == 'add'
        let l:command = l:grep . l:tmp . l:output
    elseif a:output == 'shell'
        let l:command = l:grep
    endif

    let @+ = l:command

endfunction "}}}

 "}}}3
" F1 "{{{3

function! s:F1_Loc() "{{{

    " window jump
    nno <buffer> <silent> <f1> <c-w>w

    nno <buffer> <silent> <s-f1>
    \ :call <sid>Yank()<cr>

endfunction "}}}

 "}}}3

" F2 "{{{3

function! s:F2_Loc() "{{{

    nno <buffer> <silent> <f2>
    \ :execute 'normal ^f	'<cr>

endfunction "}}}

 "}}}3

" F3 "{{{3

function! s:F3_Loc() "{{{

    vno <buffer> <silent> <f3>
    \ y:call <sid>Grep('glossary','write')<cr>

    vno <buffer> <silent> <s-f3>
    \ y:call <sid>Grep('glossary','add')<cr>

endfunction "}}}

 "}}}3

" F4 "{{{3

function! s:F4_Loc() "{{{

    vno <buffer> <silent> <f4>
    \ y:call <sid>Grep('source','write')<cr>

    vno <buffer> <silent> <s-f4>
    \ y:call <sid>Grep('source','add')<cr>

endfunction "}}}

 "}}}3

" F5 "{{{3

function! s:F5_Loc() "{{{

    vno <buffer> <silent> <f5>
    \ y:call <sid>Grep('glossary','shell')<cr>

endfunction "}}}

 "}}}3

" F6 "{{{3

function! s:F6_Loc() "{{{

    vno <buffer> <silent> <f6>
    \ y:call <sid>Grep('source','shell')<cr>

endfunction "}}}

 "}}}3

function! s:Localization() "{{{3
    let i=1
    while i<7
        execute 'call <sid>F' . i . '_Loc()'
        let i=i+1
    endwhile
endfunction "}}}3

function! s:FileFormat_Loc() "{{{3
    set fileencoding=utf-8
    set fileformat=unix
    %s/\r//ge
endfunction "}}}3

 "}}}2

" commands "{{{2

command! KeLocal call <sid>Localization()

command! LocFormat call <sid>FileFormat_Loc()
"command! LocLine call LineBreak_Loc()
autocmd! BufRead *.loc call <sid>Localization()

 "}}}2

" old scripts "{{{2

" need to tweak the Excel table first
" insert #MARK# before English column | #END# after the last column

" [tmp | English = glossary] = Chinese
" [up-left | up-right-above = up-right-below] = down
" split window equally between all buffers except for glossary
" :resize 3

" function! LineBreak_Loc() "{{{3
" 	1s/$/\r
" 	call cursor(1,1)
" 	while line('.')<line('$')
" 		call search('#MARK#')
" 		if substitute(getline('.'),'#MARK#.*#END#','','')==getline('.')
" 			mark j
" 			/#END#/mark k
" 			'j,'k-1s/$/<br10>/
" 			'j,'kjoin!
" 		endif
" 	endwhile
" endfunction
"  "}}}3

" " Function key: <F1> "{{{3
" " put cursor after the first \t
" function! F1_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <f1> ^f	
" endfunction "}}}4
" " search GUID (short line) in English buffer
" " let @d='GUID'
" function! F1_Shift_Normal_Loc() "{{{4
"   nnoremap <buffer> <silent> <s-f1>
" 		\ $2F	l"dyt	
" 		\ :1wincmd w<cr>gg
" 		\ :%s/<c-r>d\c//n<cr>
" 		\ /<c-r>/<cr>
" endfunction "}}} 
" 
" function! F1_Loc() "{{{4
" 	call F1_Normal_Loc()
" 	call F1_Shift_Normal_Loc()
" endfunction "}}}4
"  "}}}3
" 
" " Function key: <F2> "{{{3
" " switch between windows
" function! F2_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <f2> :call SwitchWindow_Trans(4,2,3,4,'loc')<cr>
" endfunction "}}}4
" " search glossary
" function! F2_Visual_Loc() "{{{4
" 	vnoremap <buffer> <silent> <f2> y:call SearchGlossary_Trans(4,4,'loc')<cr>
" endfunction "}}}4
" " search English buffer
" function! F2_Shift_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <s-f2> 
" 		\ ^yt	
" 		\ :1wincmd w<cr>gg
" 		\ :%s/\(\t#MARK#\t.\{-\}\)\@<=<c-r>"\c//n<cr>
" 		\ /<c-r>/<cr>
" endfunction "}}}4
" function! F2_Shift_Visual_Loc() "{{{4
" 	vnoremap <buffer> <silent> <s-f2> 
" 		\ y
" 		\ :1wincmd w<cr>gg
" 		\ :%s/\(\t#MARK#\t.\{-\}\)\@<=<c-r>"\c//n<cr>
" 		\ /<c-r>/<cr>
" endfunction "}}}4
" 
" function! F2_Loc() "{{{4
" 	call F2_Normal_Loc()
" 	call F2_Visual_Loc()
" 	call F2_Shift_Normal_Loc()
" 	call F2_Shift_Visual_Loc()
" endfunction "}}}4
"  "}}}3
" 
" " Function key: <F3> "{{{3
" " put '<c-r>/' text into tmp buffer
" " let @d='search pattern'
" " note: it seems that when a command will delete all characters in one buffer,
" " and it is at the end of a script line,
" " it will break the key mapping
" " compare these two mappings
" " nnoremap <f12> ggdG
" " \ oTEST<esc>
" " nnoremap <f12> ggdGoTEST<esc>
" function! F3_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <f3>
" 		\ :let @d=''\|:g/<c-r>//y D<cr>
" 		\ :2wincmd w<cr>
" 		\ :call OverwriteBuffer()<cr>
" 		\ :1<cr>
" endfunction "}}}4
" " search wrong translation
" " let @c='English'
" " let @b='Chinese correction'
" function! F3_Shift_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <s-f3>
" 		\ :%s/<c-r>c\(.\{-\}\t.\{-\}<c-r>b\)\@!\c//n<cr>
" endfunction "}}}4
" 
" function! F3_Loc() "{{{4
" 	call F3_Normal_Loc()
" 	call F3_Shift_Normal_Loc()
" endfunction "}}}4
"  "}}}3
" 
" " Function key: <F4> "{{{3
" " switch buffer
" function! F4_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <f4> <c-w>w
" endfunction "}}}4
" function! F4_Shift_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <s-f4> :call SwitchBuffer_Trans('l')<cr>
" endfunction "}}}4
" 
" function! F4_Loc() "{{{4
" 	call F4_Normal_Loc()
" 	call F4_Shift_Normal_Loc()
" endfunction "}}}4
"  "}}}3
" 
" " Function key: <F5> "{{{3
" " search and complete missing lines
" " when there are more than one lines in an Excel cell
" " let @d='search pattern'
" " let @e='completion'
" " mark S (shared between buffers): search line
" function! F5_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <f5>
" 		\ mS^"dy6t	
" 		\ :1wincmd w<cr>gg/<c-r>d/+1<cr>
" 		\ :let @e=''<cr>
" 		\ :?#MARK#?;/#END#/y E<cr>
" 		\ :3wincmd w<cr>'Scc<c-r>e<esc>gg
" 		\ :g/^$/d<cr>/<c-r>d<cr>/#END#/+1<cr>
" endfunction "}}}4
" function! F5_Visual_Loc() "{{{4
" 	vnoremap <buffer> <silent> <f5>
" 		\ mS"dy
" 		\ :1wincmd w<cr>gg/<c-r>d/+1<cr>
" 		\ :let @e=''<cr>
" 		\ :?#MARK#?;/#END#/y E<cr>
" 		\ :3wincmd w<cr>'Scc<c-r>e<esc>gg
" 		\ :g/^$/d<cr>/<c-r>d<cr>/#END#/+1<cr>
" endfunction "}}}4
" " put broken lines into Scratch (left)
" function! F5_Shift_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <s-f5>
" 		\ :let @d=''<cr>
" 		\ :g/\(#END#\)\@<!$/d D<cr>
" 		\ :let @"=@d<cr>
" 		\ :3wincmd w<cr>:b 2<cr>:call OverwriteBuffer()<cr>
" 		\ :1<cr>
" endfunction "}}}4
" 
" function! F5_Loc() "{{{4
" 	call F5_Normal_Loc()
" 	call F5_Visual_Loc()
" 	call F5_Shift_Normal_Loc()
" endfunction "}}}4
"  "}}}3
" 
" " Function key: <F6> "{{{3
" " add text to bug fix
" function! F6_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <f6>
" 		\ :2wincmd w<cr>
" 		\ :1,$yank<cr>:3wincmd w<cr>
" 		\ :b chinese.loc<cr>
" 		\ :$-1put! "<cr>'a
" 		\ :2wincmd w<cr>
" endfunction "}}}4
" " search GUID (long line) in English buffer
" function! F6_Shift_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <s-f6>
" 		\ $F-T	yt	
" 		\ :1wincmd w<cr>gg
" 		\ :%s/<c-r>"\c//n<cr>
" 		\ /<c-r>/<cr>
" endfunction "}}}4
" 
" function! F6_Loc() "{{{4
" 	call F6_Normal_Loc()
" 	call F6_Shift_Normal_Loc()
" endfunction "}}}4
"  "}}}3
" 
" " Function key: <F7> "{{{3
" " put text into the lower-right buffer
" " overwrite buffer
" function! F7_Normal_Loc() "{{{4
" 	" put text into buffer where tmp buffer is
" 	nnoremap <buffer> <silent> <f7>
" 		\ :y<cr>:2wincmd w<cr>
" 		\ :call OverwriteBuffer()<cr>
" 		\ :1<cr>
" endfunction "}}}4
" function! F7_Visual_Loc() "{{{4
" 	vnoremap <buffer> <silent> <f7>
" 		\ :y<cr>:2wincmd w<cr>
" 		\ :call OverwriteBuffer()<cr>
" 		\ :1<cr>
" endfunction "}}}4
" " append to buffer
" function! F7_Shift_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <s-f7>
" 		\ :y<cr>:2wincmd w<cr>
" 		\ :$put<cr>
" endfunction "}}}4
" function! F7_Shift_Visual_Loc() "{{{4
" 	vnoremap <buffer> <silent> <s-f7>
" 		\ :y<cr>:2wincmd w<cr>
" 		\ :$put<cr>
" endfunction "}}}4
" function! F7_Loc() "{{{4
" 	call F7_Normal_Loc()
" 	call F7_Visual_Loc()
" 	call F7_Shift_Normal_Loc()
" 	call F7_Shift_Visual_Loc()
" endfunction "}}}4
"  "}}}3
" 
" " Function key: <F8> "{{{3
" " move cursor to Chinese in an Excel line
" function! F8_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <f8>
" 		\ ^5/\t<cr>l
" endfunction "}}}4
" " move cursor into the top-right buffer
" function! F8_Shift_Normal_Loc() "{{{4
" 	nnoremap <buffer> <silent> <s-f8>
" 		\ :1wincmd w<cr>
" endfunction "}}}4
" function! F8_Loc() "{{{4
" 	call F8_Normal_Loc()
" 	call F8_Shift_Normal_Loc()
" endfunction "}}}4
"  "}}}3
" 
 "}}}2
 "}}}1
