" loki.vim "{{{1

" Last Update: Feb 10, Tue | 11:33:32 | 2015

" vars "{{{2

let s:BufE = 'english.loc'
let s:BufC = 'chinese.loc'
let s:BufT = 'tmp.loc'
let s:BufG = 'glossary.loc'

let s:FileGlossary = 'glossary.loc'
let s:FileSource = 'english.loc'
let s:FileTmp = 'ztmp'
let s:FileOutput = 'tmp.loc'

let s:WinShell = 1
let s:WinTrans = 2

let s:KeySearchTab = '<cr>'
let s:KeySearchTabReverse = '<c-cr>'

 "}}}2

" functions "{{{2

" parts "{{{3

function! s:Yank() "{{{

    " yank GUID
    if bufwinnr('%') == s:WinTrans
        execute 'normal ^2f	lviW'
    " yank Chinese
    elseif bufwinnr('%') == s:WinShell
        execute 'normal ^5f	lviW'
    endif

endfunction "}}}

function! s:Grep(text,output) "{{{

    " grep glossary/source
    if a:text == 'glossary'
        let l:text = s:FileGlossary
    elseif a:text == 'source'
        let l:text = s:FileSource
    endif

    let l:grep = 'grep -i' . ' ' .
    \ shellescape(@") . ' ' . l:text

    "let l:grep = 'grep -i' . " '" . @" . "'" .
    "\ ' ' . l:text

    " tmp file
    let l:tmp = ' >' . ' ' . s:FileTmp . ' &&' .
    \ ' cat' . ' ' . s:FileTmp

    " output to Vim
    " overwrite buffer
    if a:output == 'write'
        let l:output = ' >' . ' ' . s:FileOutput
    " add to buffer
    elseif a:output == 'add'
        let l:output = ' >>' . ' ' . s:FileOutput
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

function! s:KeyMap() "{{{3

    execute 'nno <buffer> <silent>' . ' ' .
    \ s:KeySearchTab . ' ' .
    \ ':call moveCursor#SearchInLine(' .
    \ "'\t','f')<cr>"

    execute 'nno <buffer> <silent>' . ' ' .
    \ s:KeySearchTabReverse . ' ' .
    \ ':call moveCursor#SearchInLine(' .
    \ "'\t','b')<cr>"

endfunction "}}}3

function! s:Localization() "{{{3
    let i=1
    while i<7
        execute 'call <sid>F' . i . '_Loc()'
        let i=i+1
    endwhile

    call <sid>KeyMap()

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
 "}}}1
