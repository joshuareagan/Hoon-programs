|=  [subj=* form=*]  ^-  *
=,  form
?+  form  !!
  [b=^ c=*]  [$(form b) $(form c)]
  [%0 b=@]  ?:  =(0 b.form)  !!
            ?+  b.form
              ?:  =(0 (mod b.form 2))
                $(b.form 2, subj $(b.form (div b.form 2)))
              $(b.form 3, subj $(b.form (div b.form 2)))
            %1  subj
            %2  -.subj
            %3  +.subj  ==
  [%1 b=*]  b
  [%2 b=* c=*]  $(subj $(form b), form $(form c))
  [%3 b=*]  .?($(form b))
  [%4 b=*]  =/(n $(form b) ?^(n !! +(n)))
  [%5 b=*]  =/(n $(form b) ?@(n !! =(-.n +.n)))
  [%6 b=* c=* d=*]
    $(form [2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b])
  [%7 b=* c=*]  $(form [2 b 1 c])
  [%8 b=* c=*]  $(form [7 [[7 [0 1] b] 0 1] c])
  [%9 b=@ c=*]  $(form [7 c 2 [0 1] 0 b])
  [%10 [b=* c=*] d=*]  $(form [8 c 7 [0 3] d])
  [%10 b=@ c=*]  $(form c)  ==
