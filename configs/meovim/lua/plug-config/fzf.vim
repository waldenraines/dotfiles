" `basedir` is already passed in when creating the funcref with
" `function('<SID>open_edits', [s:dir])` (same for `open_ripgreps`).
function! s:open_edits(basedir, lines)
  let s:files = map(a:lines, 'a:basedir . "/" . v:val')
  execute 'edit ' . remove(s:files, 0)
  for file in s:files
    execute 'badd ' . file
  endfor
endfunction

function! s:open_ripgreps(basedir, lines)
  let s:regex = '^\([^:]*\):\([^:]*\):\([^:]*\):.*$'
  let s:lnum = matchlist(a:lines[0], s:regex)[2]
  let s:col = matchlist(a:lines[0], s:regex)[3]
  let s:files = map(a:lines, 'a:basedir . "/" . matchlist(v:val, s:regex)[1]')
  execute 'edit ' . remove(s:files, 0)
  call cursor(s:lnum, s:col)
  for file in s:files
    execute 'badd ' . file
  endfor
endfunction

function! s:fuzzy_edit()
  let s:dir = '$HOME'
  let s:spec = {
    \ 'options': [
    \   '--multi',
    \   '--prompt=Edit> ',
    \   '--preview=previewer {}',
    \ ],
    \ 'dir': s:dir,
    \ 'sinklist': function('<SID>open_edits', [s:dir]),
    \ }
  call fzf#run(fzf#wrap(s:spec))
endfunction

function! s:fuzzy_ripgrep()
  " Piping ripgrep's output into sed to filter empty lines
  let s:query_format =
    \ 'rg --column --color=always -- %s'
    \ . " | sed '/.*:\\x1b\\[0m[0-9]*\\x1b\\[0m:$/d'"
    \ . " || true"
  let s:initial_query = printf(s:query_format, shellescape(''))
  let s:reload_query = printf(s:query_format, '{q}')
  let s:dir =
    \ system('git status') =~ '^fatal'
    \ ? expand('%:p:h')
    \ : systemlist('git rev-parse --show-toplevel')[0]
  let s:spec = {
    \ 'source': s:initial_query,
    \ 'options': [
    \   '--multi',
    \   '--prompt=Rg> ',
    \   '--disabled',
    \   '--delimiter=:',
    \   '--with-nth=1,2,4..',
    \   '--bind=change:reload:' . s:reload_query,
    \   '--preview=rg-previewer {1,2}',
    \   '--preview-window=+{2}-/2',
    \ ],
    \ 'dir': s:dir,
    \ 'sinklist': function('<SID>open_ripgreps', [s:dir]),
    \ }
  call fzf#run(fzf#wrap(s:spec))
endfunction

nmap <silent> <C-x><C-e> <Cmd>call <SID>fuzzy_edit()<CR>
nmap <silent> <C-x><C-r> <Cmd>call <SID>fuzzy_ripgrep()<CR>
