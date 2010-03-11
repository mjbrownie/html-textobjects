" textobj-html - Text objects for html
" Version: 0.2.0
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
" Dependencies:
"
"     textobj-user by Kana Natsuno
"     http://www.vim.org/scripts/script.php?script_id=2100
"
"
" Overview:
"
"     This plugin adds some textobjects to the html filetype
"
"    ihf/ahf - in/around a <form>
"    ihf/ahd - in/around a <div>
"    ihf/ahs - in/around a <span>
"
"
"   ihb   <body>
"   ihp   <p>
"   ihu   <ul>
"   ihl   <li>
"   iht   <table>
"   ihr   <tr>
"   ihc   <td> (in-html-cell  to avoid clash with <div>)
""
"    so Use as you would other text objects in visual selection, cutting and
"    dealleting etc.
"
" Installation:
"
"   Please ensure you have the above plugins installed as instructed
"   This file should be in your after/ftplugin for html
"
"   ~/.vim/after/ftplugin/html/html_textobjects.vim
"
" }}

if !exists("loaded_matchit")
    finish
endif

" Definitions {{{1
if !exists('*g:textobj_function_html') 

    " Worker functions {{{2
    fun s:select_html_a(type)

        let initpos = getpos(".")

        let e =searchpairpos('<'.a:type.'[ >]','', '</' . a:type .  '>' , 'b')
        if  ( e == [0,0])
            return 0
        endif

        let e = [bufnr("%")] + e + [0]

        call setpos(".",initpos)

        call searchpair('<'.a:type.'[ >]','', '</' . a:type .  '>' ,'')

        norm f>
        let b =  getpos(".")

        return ['v',b,e]
    endfun

    fun s:select_html_i(type)
        let initpos = getpos(".")
        if ( searchpair('<'.a:type . "[ >]",'', '</' . a:type . '>', 'b') == 0)
            return 0
        endif
        normal f>
        call search('.')
        let e =getpos('.')

        call setpos(".",initpos)

        call searchpair('<'.a:type . "[ >]",'', '</' . a:type . '>', '')

        call search('.','b')

        let b = getpos(".")
        return ['v',b,e]
    endfun

    fun! g:textobj_function_html(block_type,object_type)
        return s:select_{a:block_type}_{a:object_type}()
    endfun

    "Wrapper functions  {{{2
    "Note: Its most likely retarded to do it like this but It works and I'm
    "not devoting any research on doing it better for now :)
    "
    fun s:select_form_a()
       return  s:select_html_a('form')
    endfun

    fun s:select_form_i()
       return  s:select_html_i('form')
    endfun

    fun s:select_div_a()
       return  s:select_html_a('div')
    endfun

    fun s:select_div_i()
       return  s:select_html_i('div')
    endfun

    fun s:select_span_a()
       return  s:select_html_a('span')
    endfun

    fun s:select_span_i()
       return  s:select_html_i('span')
    endfun

    fun s:select_body_a()
       return  s:select_html_a('body')
    endfun

    fun s:select_body_i()
       return  s:select_html_i('body')
    endfun

    fun s:select_p_a()
       return  s:select_html_a('p')
    endfun

    fun s:select_p_i()
       return  s:select_html_i('p')
    endfun

    fun s:select_ul_a()
       return  s:select_html_a('ul')
    endfun

    fun s:select_ul_i()
       return  s:select_html_i('ul')
    endfun

    fun s:select_li_a()
       let temp_matchwords = b:match_words
       let b:match_words = "<li[^>]*>:</li>"
       let result = s:select_html_a('li')
       let b:match_words = temp_matchwords
       return result
    endfun

    fun s:select_li_i()
       let temp_matchwords = b:match_words
       let b:match_words = "<li[^>]*>:</li>"
       let result = s:select_html_i('li')
       let b:match_words = temp_matchwords
       return result
    endfun

    fun s:select_table_a()
       return  s:select_html_a('table')
    endfun

    fun s:select_table_i()
       return  s:select_html_i('table')
    endfun

    fun s:select_tr_a()
       return  s:select_html_a('tr')
    endfun

    fun s:select_tr_i()
       return  s:select_html_i('tr')
    endfun

    fun s:select_td_a()
       let temp_matchwords = b:match_words
       let b:match_words = "<td[^>]*>:</td>"
       let result =  s:select_html_a('td')
       let b:match_words = temp_matchwords
       return result
    endfun

    fun s:select_td_i()
       let temp_matchwords = b:match_words
       let b:match_words = "<td[^>]*>:</td>"
       let result =  s:select_html_i('td')
       let b:match_words = temp_matchwords
       return  result
    endfun

    " 2}}}
endif

call textobj#user#plugin('html',{
\   'form':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahf','*select-a-function*':'s:select_form_a',
\       'select-i':'ihf', '*select-i-function*':'s:select_form_i'
\   },
\   'div':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahd','*select-a-function*':'s:select_div_a',
\       'select-i':'ihd', '*select-i-function*':'s:select_div_i'
\   },
\   'span':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahs','*select-a-function*':'s:select_span_a',
\       'select-i':'ihs', '*select-i-function*':'s:select_span_i'
\   },
\   'body':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahb','*select-a-function*':'s:select_body_a',
\       'select-i':'ihb', '*select-i-function*':'s:select_body_i'
\   },
\   'p':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahp','*select-a-function*':'s:select_p_a',
\       'select-i':'ihp', '*select-i-function*':'s:select_p_i'
\   },
\   'ul':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahu','*select-a-function*':'s:select_ul_a',
\       'select-i':'ihu', '*select-i-function*':'s:select_ul_i'
\   },
\   'li':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahl','*select-a-function*':'s:select_li_a',
\       'select-i':'ihl', '*select-i-function*':'s:select_li_i'
\   },
\   'table':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'aht','*select-a-function*':'s:select_table_a',
\       'select-i':'iht', '*select-i-function*':'s:select_table_i'
\   },
\   'tr':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahr','*select-a-function*':'s:select_tr_a',
\       'select-i':'ihr', '*select-i-function*':'s:select_tr_i'
\   },
\   'td':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'ahc','*select-a-function*':'s:select_td_a',
\       'select-i':'ihc', '*select-i-function*':'s:select_td_i'
\   },
\})
