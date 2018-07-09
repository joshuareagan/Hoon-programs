::
::  Simple Nock interpreter
::
::  Save as 'nock.hoon' in the `/gen` directory of your urbit's
::  pier and run: 
::
::  +nock [subj form]
::
::  ...where `subj` is a noun for the subject, and `form` is a
::  Nock formula.
::
|=  [subj=* form=*]
^-  *
=,  form
?+  form  !!
  [b=^ c=*]  [$(form b) $(form c)]                           :: autocons
  [%0 b=@]  ?:  =(0 b.form)  !!                              :: Nock 0
            ?+  b.form
              ?:  =(0 (mod b.form 2))
                $(b.form 2, subj $(b.form (div b.form 2)))
              $(b.form 3, subj $(b.form (div b.form 2)))
            %1  subj
            %2  -.subj
            %3  +.subj  ==
  [%1 b=*]  b                                                :: Nock 1
  [%2 b=* c=*]  $(subj $(form b), form $(form c))            :: Nock 2
  [%3 b=*]  .?($(form b))                                    :: Nock 3
  [%4 b=*]  =/(n $(form b) ?^(n !! +(n)))                    :: Nock 4
  [%5 b=*]  =/(n $(form b) ?@(n !! =(-.n +.n)))              :: Nock 5
  [%6 b=* c=* d=*]                                           :: Nock 6
    $(form [2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b])
  [%7 b=* c=*]  $(form [2 b 1 c])                            :: Nock 7
  [%8 b=* c=*]  $(form [7 [[7 [0 1] b] 0 1] c])              :: Nock 8
  [%9 b=@ c=*]  $(form [7 c 2 [0 1] 0 b])                    :: Nock 9
  [%10 [b=* c=*] d=*]  $(form [8 c 7 [0 3] d])               :: Nock 10
  [%10 b=@ c=*]  $(form c)  ==                               :: Nock 10 (2nd variant)
