if !get(g:, 'loaded_gitgutter', 0) && !get(g:, 'loaded_fugitive', 0)
  finish
endif

let s:branch_symbol = get(g:, 'lightline#hunks#branch_symbol', ' ')
let s:hunk_symbols = get(g:, 'lightline#hunks#hunk_symbols', ['+', '~', '-'])
let s:exclude_filetypes = get(g:, 'lightline#hunks#exclude_filetypes', [])
let s:only_branch = get(g:, 'lightline#hunks#only_branch', 0)

function! s:get_hunks_gitgutter()
  if !get(g:, 'gitgutter_enabled', 0) || index(s:exclude_filetypes, &filetype) >= 0
    return ''
  endif
  return GitGutterGetHunkSummary()
endfunction

function! lightline#hunks#composer()
  let hunks = s:get_hunks_gitgutter()

  if exists('*FugitiveHead') && !empty(hunks)
    let compose = ''

    for i in [0, 1, 2]
      if winwidth(0) > 100
        let compose .= printf('%s%s', s:hunk_symbols[i], hunks[i]).' '
      endif
    endfor
    
    let branch = FugitiveHead()
    if branch ==# ''
      return ''
    endif
    
    if s:only_branch == 1
      return s:branch_symbol . branch
    endif
    
    return compose . s:branch_symbol . branch
  endif

  return ''
endfunction
