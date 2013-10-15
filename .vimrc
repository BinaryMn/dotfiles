"""""""""""""""""""""""""""""""""""""""""
"Author=> Chris Olin (www.chrisolin.com)
"
"Purpose => vim configuration for cygwin
"
"Created date: 08-16-2012
"
"Last modified: Wed Feb  6 13:09:00 2013
"""""""""""""""""""""""""""""""""""""""""

" DO NOT ENABLE THE GitBranch() FUNCTION ON LINE 89!
" It causes strange charaters, like ^[OA, to appear
" when scrolling or editing a file in vi.

syntax on
set nocompatible smd ar si et bg=dark ts=4 sw=4 

"""""""""""""""""""""""""""""
" => The Basics
"""""""""""""""""""""""""""""
"Insert datestamp!
:nnoremap <F5> "=strftime("%c")<CR>P
:inoremap <F5> <C-R>=strftime("%c")<CR>

"Turn on line numbers:
"set number
" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

filetype plugin indent off
autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(

"Quick switching through buffer tabs
:nnoremap <F11> :tabp<CR>
:nnoremap <F12> :tabn<CR>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Return to last edit position (You want this!) *N*
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

"Git branch
function! GitBranch()
    let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
    if branch != ''
        return '   Git Branch: ' . substitute(branch, '\n', '', 'g')
    en
    return ''
endfunction

" Just a simple substitute. Be sure to change this to your own home directory.
function! CurDir()
    return substitute(getcwd(), '/home/chris/', "~/", "g")
endfunction

" Just a blantantly obvious reminder when we're in paste mode
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    en
    return ''
endfunction

" Format the statusline
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L%{GitBranch()}
" set statusline=\ %{HasPaste()}%f\ \ %{&ff}%y%m%r%h\ %w\ CWD:\ %r%{CurDir()}%h\ \ Line:\ %l/%L
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

let cwd = getcwd()
let cwfp = expand("%:p:h")

set statusline=
set statusline +=%1*\%{HasPaste()}\ %*                  "got paste mode?
set statusline +=%4*%{&ff}%*                            "file format
set statusline +=%3*%y%*                                "file type
"set statusline +=%6*\ %{GitBranch()}                    "git branch, if it exists (KEEP DISABLED! BREAKS STUFF!)
if cwd != cwfp                                          "this is to get rid of absolute path spam
    set statusline +=%1*\ CWD:\ \%<%{CurDir()}          "current working directory
en
    set statusline +=%5*\ File:\ \%F%*                  "current file and absolute path
set statusline +=%2*%m%*                                "modified flag
set statusline +=%1*%=%5l%*                             "current line
set statusline +=%2*/%L%*                               "total lines
"set statusline +=%1*%4v\ %*                            "virtual column number
set statusline +=%2*\ 0x%04B\ %*                        "character under cursor

"TERM variable must be set to xterm-256color or another term that supports 256 colors, otherwise this will not work
hi User1 ctermfg=208
hi User2 ctermfg=196
hi User3 ctermfg=27
hi User4 ctermfg=46
hi User5 ctermfg=226
hi User6 ctermfg=3

"""""""""""""""""""""""""""""""""
" => Mutt
"""""""""""""""""""""""""""""""""
"I don't like long, endless lines when typing e-mails.
au BufRead /tmp/mutt-* set tw=75
"Except I have a habit going back and rewording sentences and VIM doesn't automagically adjust lines. ,r will now reformat the current paragraph!
nmap <leader>r gqap  


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

set backspace=indent,eol,start

"""""""""""""""""""""""""""""""""""""""""""""""
" => Insert modeline
"""""""""""""""""""""""""""""""""""""""""""""""
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
" Use <leader>ml to append.

function! AppendModeline()
    let l:modeline = printf("# vim:smd:ar:si:et:bg=dark:ts=%d:sw=%d ",
          \ &tabstop, &shiftwidth)
    let l:modeline = substitute(l:modeline, "%s", l:modeline, "")
    let l:line = line (".")
    call append(l:line - 1, l:modeline)

endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""
" => Insert header
""""""""""""""""""""""""""""""""""""""""""""""""
" All the fun is in this file so we can comment one line to disable it.

source $HOME/.vimheader