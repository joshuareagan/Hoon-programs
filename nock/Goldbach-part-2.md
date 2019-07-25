### Goldbach Conjecture in Nock, part 2

author: ~taglux-nidsep

date: ~2017.3.12..07.53.29..7d94

In the last Goldbach post we wrote a counterexample tester.  As a reminder, the Goldbach conjecture states:

"Every even number greater than 2 is the sum of two primes."

The function from the last post takes any N and checks whether: (i) N is greater than 2, (ii) N is even, and (iii) there is no pair of prime numbers whose sum is N.  If the answer is 'yes' to all three, then N is proof that the conjecture is false.  (Mathematicians right now don't have a proof either way about the Goldbach conjecture; they don't know whether it's true or false.)

Rather than testing the Goldbach Conjecture by checking one number at a time, ad hoc, let's write a function that systematically checks all relevant numbers for a counterexample.  When it finds one, it tells us.

Of course, it could be that the Goldbach Conjecture is true.  If that's the case, then our Nock program will never stop.  It only stops when it finds proof that the conjecture is false.  Otherwise, it'll grind its gears forever.  You've been warned: you can't say that you didn't know the dangers going in.

In fact, the following program will also incorporate the function of the Goldbach program from the last post (which I'll call "CE_Check").  It will work as follows:  If the input, N, is some number greater than 0, then it will do a one-number check (CE_Check) to see whether N is a counterexample to Goldbach's Conjecture, and return the result.  If N = 0, however, then the program will test all even numbers to see whether any is a counterexample; if it finds one, it'll return N.

Here is the algorithm, in pseudo-code:

```
    if ( N = 0 ) then start_loop(N)            ::  "If N = 0, then don't stop until a CE is found."
    else return CE_Check(N)                    ::  "Test whether N is a CE, return the result."
    
    def start_loop(int N):
        if ( CE_Check(N) = 0 ) return N        ::  Remember that in Martian, '0' is yes.
        else
            N += 2
            start_loop(N)                      ::  "Now check the next even number."
```

Let's call this function "Goldbach_final" because it's the final Goldbach program I'm writing in Nock.

To the Nock!  

`[8 a w]`  ::  'a' builds the library, and 'w' calls 'Goldbach_final' from it.

We'll use the library from the last post, with one new addition:

`a:  [[[[[[[[[p q] DGB] EGB] BPGB] r] s] MGB] AGB] [1 0]]`

The new function here is 'p'.  The library key:

```
    AGB = Addition Gate Builder
    MGB = Multiplication Gate Builder
    s = 'greater than' core builder (not gate, has two arms in the battery)
    r = prime checker core builder (not gate, has two arms in the battery)
    BPGB = Both Prime Gate Builder
    EGB = Even Checker Gate Builder
    DGB = Decrement Gate Builder
    q = Goldback CE_check (from the last GB post)
    p = Goldback_final (we're writing this in this post)
```

The library Nock functions are all listed toward the end of this post, other than p of course.

As always, the order of the formulas in the library-builder is important: the functions we call in Goldbach_final need to know where in the library to look when they want to make function calls for themselves.  For another reminder, all formulas in the library-builder start with the "1" function which goes away when the library is put into the subject.

Speaking of which, while the initial subject is N, the subject passed to w is:

`[[[[[[[[[[p* q*] DGB*] EGB*] BPGB*] r*] s*] MGB*] AGB*] 0] N]`

The '*' indicates that the '1' of each formula is now gone. (I.e., `[1 0]*` = `0`.) The left-hand side of this formula (address # 2) is the library.

w, 'Build the Goldbach_final core and call its first arm.':

`[8 [9 512 [0 2]] [9 4 [[0 4] [0 7] [0 5]]]]`

The `[9 512 [0 2]]` formula passes the library to p* , which has two arms: one for the non-looping function and one for the looping one. Here's p, the ancestor of p* :

`[1 [[GFAB1 GFAB2] [0 1]]]`  ::  GFAB = Goldbach_final Arm Builder

So p* is: `[[GFAB1 GFAB2] [0 1]]`. Passing the library to this formula results in:

`[[GF-A1 GF-A2] z]`  ::   z is the library. 'GF-A' stands for 'Goldbach_Final Arm'.

The next subject is therefore: `[[GF-A1 GF-A2] z] [z N]`

For `[9 4 [[0 4] [0 7] [0 5]]]`, we pass to GF-A1 a subject of the form:

`[Battery] [[Argument] [Context]]`

```
    Battery:  [0 4] => [GF-A1 GF-A2]
    Argument:  [0 7] => N
    Context:  [0 5] => z
```

The resulting subject:  `[GF-A1 GF-A2] [N z]`

All that's left is to write our surprisingly short arm-builders.

```
    GFAB1:  [1 [8 [9 513 [0 7]] b]]  ::  "Build the GB CE_Check core and
                                     ::  attach it in front of the subject.
                                     ::  Then pass it to b.
```

The library is at address # 7, and the GB CE_Check core builder is at address # 513 of the library.  So the new subject is:

`[[CE-A1 CE-A2] [[2 0] z]] [[GF-A1 GF-A2] [N z]]`

```
    b:  [6 [5 [0 14] [1 0]] c d]    ::  "If N = 0 then c, else d."
    c:  [9 13 [0 1]]                ::  "Call GF-A2 and pass it the subject unchanged."
    d:  [9 4 [[0 4] [0 14] [0 5]]]  ::  "Return CE_Check(N)."
```

Here's an address key for those who aren't keeping track:

```
    Address # 14:  N
    Address # 13:  Goldbach_final Arm 2 (GF-A2)
    Address # 4:  The Goldbach CE_Check battery
    Address # 5:  The Goldbach CE_Check context
```

Now the loop arm:

```
    GFAB2:  [1 [6 f [0 14] e]]  ::  "If e [is true] then return 'N', else f."
    e:  [5 [9 4 [[0 4] [0 14] [0 5]]] [1 0]]  ::  e says "CE_Check(N)"
    f:   [9 13 [[0 2] [0 6] [4 [4 [0 14]]] [0 15]]]  :: "Add 2 to N, loop."
```

A partial address key:

```
    Address # 14:  N
    Address # 4:  The Goldbach CE_Check battery
    Address # 5:  The Goldbach CE_Check context
    Address # 13:  Goldbach_final Arm 2 (GF-A2)
```

And that's all.  

Here's the whole library:

```
    AGB (addition):   [1 [1 [6 [5 [0 13] [0 14]] [0 12] [9 2 [[0 2] [[4 [0 12]] [0 13]] [[4 [0 14]] [0 15]]]]]] [1 0] [0 1]]
    MGB (multiplication):   [1 [[1 [8 [9 5 [0 15]] [6 [5 [0 29] [0 61]] [0 60] [9 2 [[0 6] [0 14] [[[9 2 [[0 4] [[[0 60] [0 28]] [0 5]]]] [4 [0 61]]] [0 31]]]]]]] [[[1 0] [1 0]] [0 1]]]]
    
    s (greater than):   [1 [[GT-A1 GT-A2] [[[1 0] [1 0]] [0 1]]]]
    GT-A1:   [1 [6 [5 [0 14] [0 15]] [1 1] [9 5 [[0 2] [[0 6] [[0 6] [0 15]]]]]]]
    GT-A2:   [1 [6 [5 [4 [0 28]] [0 13]] [1 1] [6 [5 [4 [0 29]] [0 12]] [1 0] [9 5 [[0 2] [[0 6] [[[4 [0 28]] [4 [0 29]]] [0 15]]]]]]]]
    
    r (prime checker):  [1 [[PC-A1 PC-A2] [[[1 2] [1 2]] [0 1]]]]
    PC-A1:    [1 [8 [9 9 [0 15]] [8 [9 17 [0 31]] [8 [9 129 [0 63]] [6 [5 [0 62] [1 0]] [1 1] [6 [5 [0 62] [1 1]] [1 1] [6 [5 [0 62] [1 2]] [1 0] [6 [5 [0 62] [1 3]] [1 0] [6 [9 2 [[0 4] [0 62] [0 5]]] [1 1] [9 61 [0 1]]]]]]]]]]]
    PC-A2:   [1 [6 [5 [9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [1 1] [6 [5 [4 [0 253]] [0 62]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [1 0] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[1 2] [4 [0 253]]] [0 127]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]]]]]
    
    BPGB (both_prime):   [1 [[1 [8 [9 33 [0 7]] [6 [9 4 [[0 4] [0 28] [0 5]]] [6 [9 4 [[0 4] [0 29] [0 5]]] [1 0] [1 1]] [1 1]]]] [0 1]]]
    EGB (even checker):   [1 [[1 [6 [5 [0 28] [0 6]] [1 0] [6 [5 [0 29] [0 6]] [1 1] [9 2 [[0 2] [[0 6] [[[4 [4 [0 28]]] [4 [4 [0 29]]]] [0 15]]]]]]]] [[[1 0] [1 1]] [0 1]]]]
    DGB (decrement):   [1 [[1 [6 [5 [4 [0 14]] [0 6]] [0 14] [9 2 [[0 2] [[0 6] [[4 [0 14]] [0 15]]]]]]] [[1 0] [0 1]]]]
    
    q (CE checker):   [1 [[CEAB1 CEAB2] [[[1 2] [1 0]] [0 1]]]]
    CEAB1:   [1 [8 [9 257 [0 15]] [8 [9 17 [0 31]] [8 [9 65 [0 63]] [8 [9 129 [0 127]] [6 [9 4 [[0 28] [[[1 3] [0 126]] [0 29]]]] [1 1] [6 [9 2 [[0 4] [[0 126] [0 5]]]] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[0 508] [9 2 [[0 60] [9 2 [[0 60] [0 126] [0 61]]] [0 61]]]] [0 255]]] [1 1]]]]]]]]
    CEAB2: [1 [6 [9 2 [[0 12] [0 254] [0 13]]] [[0 254] [1 1]] [6 [5 [4 [4 [0 508]]] [0 126]] [1 0] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[4 [0 508]] [9 2 [[0 60] [0 509] [0 61]]]] [0 255]]]]]]
    
    p:  [1 [[GFAB1 GFAB2] [0 1]]]
    GFAB1:  [1 [8 [9 513 [0 7]] [6 [5 [0 14] [1 0]] [9 13 [0 1]] [9 4 [[0 4] [0 14] [0 5]]]]]]
    GFAB2:  [1 [6 [5 [9 4 [[0 4] [0 14] [0 5]]] [1 0]] [0 14] [9 13 [[0 2] [0 6] [4 [4 [0 14]]] [0 15]]]]]
```  
   
After making all the substitutions, here's the whole program (with minimal formatting):

```
    [ 8
      [ [ [ [ [ [ [ [ [ [ 1
                          [ [ 1
                              8
                              [9 513 0 7]
                              6
                                  [5 [0 14] 1 0]
                                [9 13 0 1]
                              9 4 [0 4] [0 14] [0 5]
                            ]
                            1
                            6
                                [5 [9 4 [0 4] [0 14] 0 5] 1 0]
                              [0 14]
                            9 13 [0 2] [0 6] [4 4 0 14] [0 15]
                          ]
                          [0 1]
                        ]
                        1
                       [ [ 1
                            8
                            [9 257 0 15]
                            8
                            [9 17 0 31]
                            8
                            [9 65 0 63]
                            8
                            [9 129 0 127]
                            6
                                [9 4 [0 28] [[1 3] 0 126] 0 29]
                              [1 1]
                            6
                                [9 2 [0 4] [0 126] 0 5]
                              [ 9 125 [0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[0 508] 9 2 [0 60] [9 2 [0 60] [0 126] 0 61] 0 61] [0 255]
                            ]
                            [1 1]
                          ]
                          1
                          6
                              [9 2 [0 12] [0 254] 0 13]
                            [[0 254] 1 1]
                          6
                              [5 [4 4 0 508] 0 126]
                            [1 0]
                          9 125 [0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[4 0 508] 9 2 [0 60] [0 509] 0 61] [0 255]
                        ]
                        [[1 2] 1 0]
                        [0 1]
                      ]
                      1
                      [1 6 [5 [4 0 14] 0 6] [0 14] 9 2 [0 2] [0 6] [4 0 14] 0 15]
                      [1 0]
                      [0 1]
                    ]
                    1
                    [ 1
                      6
                          [5 [0 28] 0 6]
                        [1 0]
                      6
                          [5 [0 29] 0 6]
                        [1 1]
                      9 2 [0 2] [0 6] [[4 4 0 28] 4 4 0 29] [0 15]
                    ]
                    [[1 0] 1 1]
                    [0 1]
                  ]
                  1
                  [ 1
                    8
                    [9 33 0 7]
                    6
                        [9 4 [0 4] [0 28] 0 5]
                      [6 [9 4 [0 4] [0 29] 0 5] [1 0] 1 1]
                    [1 1]
                  ]
                  [0 1]
                ]
                1
                [ [ 1
                    8
                    [9 9 0 15]
                    8
                    [9 17 0 31]
                    8
                    [9 129 0 63]
                    6
                        [5 [0 62] 1 0]
                      [1 1]
                    6
                        [5 [0 62] 1 1]
                      [1 1]
                    6
                        [5 [0 62] 1 2]
                      [1 0]
                    6
                        [5 [0 62] 1 3]
                      [1 0]
                    6
                        [9 2 [0 4] [0 62] 0 5]
                      [1 1]
                    9 61 [0 1]
                  ]
                  1
                  6
                      [5 [9 2 [0 28] [0 126] 0 29] 0 62]
                    [1 1]
                  6
                      [5 [4 0 253] 0 62]
                    [ 6
                        [9 4 [0 12] [[9 2 [0 28] [0 126] 0 29] 0 62] 0 13]
                      [1 0]
                    9 61 [0 2] [0 6] [0 14] [0 30] [0 62] [[4 0 252] 0 253] [0 127]
                  ]
                  6
                      [9 4 [0 12] [[9 2 [0 28] [0 126] 0 29] 0 62] 0 13]
                    [9 61 [0 2] [0 6] [0 14] [0 30] [0 62] [[1 2] 4 0 253] 0 127]
                  9 61 [0 2] [0 6] [0 14] [0 30] [0 62] [[4 0 252] 0 253] [0 127]
                ]
                [[1 2] 1 2]
                [0 1]
              ]
              1
              [ [1 6 [5 [0 14] 0 15] [1 1] 9 5 [0 2] [0 6] [0 6] 0 15]
                1
                6
                    [5 [4 0 28] 0 13]
                  [1 1]
                6
                    [5 [4 0 29] 0 12]
                  [1 0]
                9 5 [0 2] [0 6] [[4 0 28] 4 0 29] [0 15]
               ]
              [[1 0] 1 0]
              [0 1]
            ]
            1
            [ 1
              8
              [9 5 0 15]
              6
                  [5 [0 29] 0 61]
                [0 60]
              9 2 [0 6] [0 14] [[9 2 [0 4] [[0 60] 0 28] 0 5] 4 0 61] [0 31]
            ]
            [[1 0] 1 0]
            [0 1]
          ]
          1
          [1 6 [5 [0 13] 0 14] [0 12] 9 2 [0 2] [[4 0 12] 0 13] [4 0 14] 0 15]
          [1 0]
          [0 1]
        ]
        [1 0]
      ]
      8
      [9 512 0 2]
      9 4 [0 4] [0 7] [0 5]
    ]
```

As in the last program, you can test whether 368 is a counterexample to the Goldbach conjecture by doing the following:

1.  Mount your home desk with |mount % in dojo, if you haven't already.
1.  Paste the following into a text editor:


```
:gate  arg/atom
.*(arg [8 [[[[[[[[[[1 [[[1 [8 [9 513 [0 7]] [6 [5 [0 14] [1 0]] [9 13 [0 1]] [9 4 [[0 4] [0 14] [0 5]]]]]] [1 [6 [5 [9 4 [[0 4] [0 14] [0 5]]] [1 0]] [0 14] [9 13 [[0 2] [0 6] [4 [4 [0 14]]] [0 15]]]]]] [0 1]]] [1 [[[1 [8 [9 257 [0 15]] [8 [9 17 [0 31]] [8 [9 65 [0 63]] [8 [9 129 [0 127]] [6 [9 4 [[0 28] [[[1 3] [0 126]] [0 29]]]] [1 1] [6 [9 2 [[0 4] [[0 126] [0 5]]]] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[0 508] [9 2 [[0 60] [9 2 [[0 60] [0 126] [0 61]]] [0 61]]]] [0 255]]] [1 1]]]]]]]] [1 [6 [9 2 [[0 12] [0 254] [0 13]]] [[0 254] [1 1]] [6 [5 [4 [4 [0 508]]] [0 126]] [1 0] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[4 [0 508]] [9 2 [[0 60] [0 509] [0 61]]]] [0 255]]]]]]] [[[1 2] [1 0]] [0 1]]]]] [1 [[1 [6 [5 [4 [0 14]] [0 6]] [0 14] [9 2 [[0 2] [[0 6] [[4 [0 14]] [0 15]]]]]]] [[1 0] [0 1]]]]] [1 [[1 [6 [5 [0 28] [0 6]] [1 0] [6 [5 [0 29] [0 6]] [1 1] [9 2 [[0 2] [[0 6] [[[4 [4 [0 28]]] [4 [4 [0 29]]]] [0 15]]]]]]]] [[[1 0] [1 1]] [0 1]]]]] [1 [[1 [8 [9 33 [0 7]] [6 [9 4 [[0 4] [0 28] [0 5]]] [6 [9 4 [[0 4] [0 29] [0 5]]] [1 0] [1 1]] [1 1]]]] [0 1]]]] [1 [[[1 [8 [9 9 [0 15]] [8 [9 17 [0 31]] [8 [9 129 [0 63]] [6 [5 [0 62] [1 0]] [1 1] [6 [5 [0 62] [1 1]] [1 1] [6 [5 [0 62] [1 2]] [1 0] [6 [5 [0 62] [1 3]] [1 0] [6 [9 2 [[0 4] [0 62] [0 5]]] [1 1] [9 61 [0 1]]]]]]]]]]] [1 [6 [5 [9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [1 1] [6 [5 [4 [0 253]] [0 62]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [1 0] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[1 2] [4 [0 253]]] [0 127]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]]]]]] [[[1 2] [1 2]] [0 1]]]]] [1 [[[1 [6 [5 [0 14] [0 15]] [1 1] [9 5 [[0 2] [[0 6] [[0 6] [0 15]]]]]]] [1 [6 [5 [4 [0 28]] [0 13]] [1 1] [6 [5 [4 [0 29]] [0 12]] [1 0] [9 5 [[0 2] [[0 6] [[[4 [0 28]] [4 [0 29]]] [0 15]]]]]]]]] [[[1 0] [1 0]] [0 1]]]]] [1 [[1 [8 [9 5 [0 15]] [6 [5 [0 29] [0 61]] [0 60] [9 2 [[0 6] [0 14] [[[9 2 [[0 4] [[[0 60] [0 28]] [0 5]]]] [4 [0 61]]] [0 31]]]]]]] [[[1 0] [1 0]] [0 1]]]]] [1 [1 [6 [5 [0 13] [0 14]] [0 12] [9 2 [[0 2] [[4 [0 12]] [0 13]] [[4 [0 14]] [0 15]]]]]] [1 0] [0 1]]] [1 0]] [8 [9 512 [0 2]] [9 4 [[0 4] [0 7] [0 5]]]]])
```

1.  Save it as "goldbach.hoon" in home/gen/ of your Urbit pier.
1.  Type `+goldbach 368` in dojo.

If you happen to have access to a supercomputer than runs Nock---or better yet, Martian technology that transcends current processor speeds by several orders of magnitude---you may want to enter `+goldbach 0` in dojo.  The program won't stop until it finds a counterexample.  Of course, as we noted before, there might not be one.  So maybe it goes on forever.  On the other hand, if you're patient, and you do find a counterexample, you'll be famous for proving that Goldbach's conjecture is false, once and for all!

If you're using human technology, the odds of fame and glory don't look so good.  Are you a fatalist?  Do you find yourself attracted to lost causes?  You may want to try it anyway: `+goldbach 0`.  You can always hit [ctrl]-c!

In any case, enjoy.
