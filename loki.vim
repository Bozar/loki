" loki.vim
" Last Update: Oct 23, Fri | 16:50:29 | 2015

" nightly version

" vars

let s:BufE = 'english.loc'
let s:BufC = 'chinese.loc'
let s:BufT = 'tmp.loc'
let s:BufG = 'glossary.loc'

let s:Folder = 'd:/Documents/'
let s:FileGlossary = s:Folder . 'glossary.loc'
let s:FileSource = s:Folder . 'english.loc'
let s:FileTmp = s:Folder . 'ztmp'
let s:FileOutput = s:Folder . 'tmp.loc'

let s:WinShell = 1
let s:WinTrans = 2

let s:KeySearchTab = '<cr>'
let s:KeySearchTabReverse = '<c-cr>'

let s:BufWork = 'memo.loc'
let s:BufTemp = 'tmp.loc'

" functions

function! s:SplitScreen()
    if bufname('%') =~# s:BufWork
        if winnr('$') ># 1
            only
        endif
        split
        if bufexists(s:BufTemp)
            execute 'buffer' . ' ' . s:BufTemp
        else
            execute 'find' . ' ' . s:BufTemp
        endif
        wincmd j
    endif
endfunction

function! s:Yank()
    " yank GUID
    if bufwinnr('%') == s:WinTrans
        execute 'normal ^2f	lviW'
    " yank Chinese
    elseif bufwinnr('%') == s:WinShell
        execute 'normal ^5f	lviW'
    endif
endfunction

function! s:Grep(text,output,...)
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

    if exists('a:1') && a:1 ># 0
        execute 'silent !' . @+
        "execute '!' . @+
    endif
endfunction

function s:SearchInLine(pat,move)
    if a:move ==# 'f' || a:move ==# ''
        let l:noCursorPos = 'W'
        let l:cursorPos = 'cW'
    elseif a:move ==# 'b'
        let l:noCursorPos = 'bW'
        let l:cursorPos = 'bcW'
    endif

    let l:i = 0

    while l:i <# 2
        if search(a:pat,l:noCursorPos,line('.'))
        \ ==# 0
        \ &&
        \ search(a:pat,l:cursorPos,line('.'))
        \ ==# 0
            if l:i ==# 0
                let l:cursor = getpos('.')
                if a:move ==# 'f' || a:move ==# ''
                    execute 'normal! 0'
                elseif a:move ==# 'b'
                    execute 'normal! $'
                endif
            elseif l:i ==# 1
                call setpos('.',l:cursor)
                return 2
            endif
            let l:i = l:i + 1
        else
            return 1
        endif
    endwhile
endfunction

" jump between windows
function! s:F1_Loc()
    nno <buffer> <silent> <f1> <c-w>w
    nno <buffer> <silent> <s-f1>
    \ :call <sid>Yank()<cr>
endfunction

" move between tabs in one line
function! s:F2_Loc()
    nno <buffer> <silent> <f2>
    \ :execute 'normal ^f	'<cr>
endfunction

" search glossary.loc in vim
function! s:F3_Loc()
    vno <buffer> <silent> <f3>
    \ y:call <sid>Grep('glossary','write',1)<cr>
endfunction

" search english.loc in vim
function! s:F4_Loc()
    vno <buffer> <silent> <f4>
    \ y:call <sid>Grep('source','write',1)<cr>
endfunction

" search glossary.loc in vim/shell
function! s:F5_Loc()
    vno <buffer> <silent> <f5>
    \ y:call <sid>Grep('glossary','write')<cr>
endfunction

" search english.loc in vim/shell
function! s:F6_Loc()
    vno <buffer> <silent> <f6>
    \ y:call <sid>Grep('source','write')<cr>
endfunction

" print glossary.loc in shell
function! s:F7_Loc()
    vno <buffer> <silent> <f7>
    \ y:call <sid>Grep('glossary','shell')<cr>
endfunction

" print english.loc in shell
function! s:F8_Loc()
    vno <buffer> <silent> <f8>
    \ y:call <sid>Grep('source','shell')<cr>
endfunction

function! s:KeyMap()
    execute 'nno <buffer> <silent>' . ' ' .
    \ s:KeySearchTab . ' ' .
    \ ':call <sid>SearchInLine(' .
    \ "'\t','f')<cr>"

    execute 'nno <buffer> <silent>' . ' ' .
    \ s:KeySearchTabReverse . ' ' .
    \ ':call <sid>SearchInLine(' .
    \ "'\t','b')<cr>"

    nno <buffer> <silent> <s-cr>
    \ :call <sid>SplitScreen()<cr>
endfunction

function! s:Localization()
    let i=1
    while i<7
    "while i<9
        execute 'call <sid>F' . i . '_Loc()'
        let i=i+1
    endwhile

    call <sid>KeyMap()
endfunction

function! s:FileFormat_Loc()
    set fileencoding=utf-8
    set fileformat=unix
    %s/\r//ge
endfunction

" commands
command! KeLocal call <sid>Localization()
command! LocFormat call <sid>FileFormat_Loc()
"command! LocLine call LineBreak_Loc()
autocmd! BufRead *.loc call <sid>Localization()

" vim: set fdm=indent tw=50 :
