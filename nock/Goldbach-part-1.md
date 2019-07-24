---
type: post
date: ~2017.3.12..05.37.44..7d5e
title: Goldbach Conjecture counterexample tester in Nock
author: ~taglux-nidsep
navsort: bump
navuptwo: true
comments: reverse
---

The Goldbach conjecture states:

"Every even number greater than 2 is the sum of two primes."

Mathematicians have no proof of this.  (If they did, we'd be calling it a "theorem" rather than a "conjecture".)  For all we know, it could be false.  If we could find some number N that is even and greater than 2, and such that no pair of primes have N as their sum, then we would have shown Goldbach's conjecture to be false.  This number N would hence be a counterexample (CE).

In the following, we'll construct a Nock program that takes N as input, and then tells us whether it's a CE to the Goldbach conjecture.  If it isn't, and N is even and greater than 2, it will also give us a pair of primes whose sum is N.

For this program, we'll take advantage of a library of functions from previous posts.  I'll also use two new functions that aren't mentioned in previous posts, but the latter are very simple and unlikely to cause any confusion for someone with a little Nock knowledge.  As a reminder, I have no tech background, and besides learning Nock in the last several weeks I haven't done any computer programming since playing around with GW/QBasic in middle school.  Not unless you count lazily attempting a few intro lessons of Python at Codecademy.  Learning Nock really isn't that difficult.

The two new functions are:  "both_prime(x y)" and "decrement".  I haven't written out these functions in any previous posts, but you can find a version of decrement in the Urbit documentation.  "Both prime" is a function that takes two numbers, x and y, and then tells us whether both are prime numbers.  This function is easy to create once one has a prime checker, which we do!  (See earlier post for that.)  Everything we need in our library is listed at the bottom of this post.

What follows is a pseudo-code algorithm of the program, which has two parts: setup, and loop.

```
    i = 2                                              ::  i = 2 and j = N - 2
    j = decrement(decrement(N))      ::  note that the sum of i and j is N
    If 3 > N then return "1"                  ::  If N isn't greater than 2, it can't be a counterexample (CE)
        else
    If N is even then goto :loop_start
        else
    return "1"                                       ::  If N isn't even, it can't be a CE
    
    :loop_start
    If both_prime(i, j) then return "((i j) 1)"  ::  We've found a pair of primes whose sum is N
        else
    If i + 2 = N then return "0"                     ::  We've tested all pairs whose sum is N, none are pairs of primes
                                                                  ::  If this happens contact a mathematics department.  You've made
                                                                  ::  a major discovery.  Fame and fortune coming your way.
        else
    Add 1 to i, decrement 1 from j, and goto :loop_start    ::  Take the next pair, (i, j), whose sum is N and test it
```

The basic idea is not terribly complicated.  First, check to see if N is even and greater than 2.  If not, then it's not a CE.  Second, for the loop, you need to check all pairs of numbers whose sum is N.  If any pair is both prime, then your N isn't a CE.  To generate our list of primes, we start with i = 2 and j = N - 2.  Obviously the sum of these is N.  For the next pair, add 1 to i and take 1 from j.  Repeat this until all pairs have been tested.

Enough of that.  On to the Nock!

`[8 a w]      ::  'a' builds the library, and 'w' calls the CE-checking function in the library`

a:

`[[[[[[[[q DGB] EGB] BPGB] r] s] MGB] AGB] [1 0]]`

This is our library-generating formula and it needs some explanation.  First, a key:

    AGB = Addition Gate Builder
    MGB = Multiplication Gate Builder
    s = 'greater than' core builder (not gate, has two arms in the battery)
    r = prime checker core builder (not gate, has two arms in the battery)
    BPGB = Both Prime Gate Builder
    EGB = Even Checker Gate Builder
    DGB = Decrement Gate Builder
    q = Goldback CE checker (this is what we're writing today)

The order of these formulas in the library-builder is important.  In previous functions we've written, e.g., the prime checker, we called various other functions.  We don't want to have to go back and re-write functions we've already finished, so we want to keep all our library formulas in the same tree addresses every time we write a library-builder.

All of the formulas in our library-builder have a '1' function to start with, which is removed when the library is built and put in the subject.

The initial subject is just `N`.  With the library tacked in front of that, the new subject, to be passed to w, is:

`[[[[[[[[[q* DGB*] EGB*] BPGB*] r*] s*] MGB*] AGB*] 0] N]`

As a reminder from previous posts, the '*' indicates that the '1' of each formula is now gone.  (I.e., `[1 0]* = 0`.)  The left-hand side of this formula (address # 2) is the library.

w:

`[8 [9 256 [0 2]] [9 4 [[0 4] [0 7] [0 5]]]]    ::  build the q* core and call the first arm`

The `[9 256 [0 2]]` formula passes the library to q*, which has two arms: one for setup and one for looping.  Let's take a quick look at q, the ancestor of q*:

`[1 [[CEAB1 CEAB2] [[[1 2] [1 0]] [0 1]]]]    :: CEAB = Counterexample Arm Builder`

So q* is: `[[CEAB1 CEAB2] [[[1 2] [1 0]] [0 1]]]`.  The tuple `[[1 2] [1 0]]` is for initializing our variables, i and j, respectively.  Passing the library to this formula results in:

`[[CE Arm 1  CE Arm 2] [[2 0] z]]    ::  ...letting z be the library`

Thus, the next subject is:  `[[CE Arm 1  CE Arm 2] [[2 0] z]] [z N]`

Then for `[9 4 [[0 4] [0 7] [0 5]]]`, we pass to the first CE arm a subject it expects, which by convention is of the form:

`[Battery] [[Argument] [Context]]`

    Battery:  [0 4] => [CE Arm 1  CE Arm 2]
    Argument:  [0 7] => N
    Context:  [0 5] => [[2 0] z]]

Now we just need the formulas for our two arms.  I.e., we need a lot!

For our first arm, we'll start by making cores from our library for all the functions we need: decrement, 'greater than', 'both prime', and the even number checker.  We construct and add these cores to the subject so that they are ready to be called.  For the following it will be useful to have the library, z, ready to refer to:

z:   `[[[[[[[[q* DGB*] EGB*] BPGB*] r*] s*] MGB*] AGB*] 0]`

CEAB1:

```
    [1 [8 [9 257 [0 15]] b]]                 ::  The library is at address # 15 of the current subject, and 
                                                           ::  the decrement gate-builder is at address # 257 of the library.
    b:   [8 [9 17 [0 31]] c]                   ::  The library's new address # is 31, and the 'greater than' core
                                                           ::  builder is at address # 17 of the library.
    c:   [8 [9 65 [0 63]] d]                 ::  The library's even newer address # is 63, and the 'both prime'
                                                           ::  gate builder is at address # 65 of the library.
    d:   [8 [9 129 [0 127]] e]               ::  The library's even-more-new address # is 127, and the even
                                                           ::  number checker gate builder is at address # 129 of the library.
```

At this point all the functions we need to call directly are in the subject.  (The formulas in the library that aren't explicitly called in the following are called by at least one of the above four.)  Here is our new subject:

`[[E Arm] [E C]] [[BP Arm] [BP C]] [[GT-A1 GT-A2] [GT C]] [[D Arm] [D C]] [[CE-A 1 CE-A 2] [N [[2 0] z]]]`

And here is a key so that you can actually read the subject:

    'E Arm' => Even Checker Arm
    'E C' => Even Checker Context
    'BP Arm' => Both Prime Checker Arm
    'BP C' => Both Prime Checker Context
    'GT-A1' => 'Greater Than' Arm 1
    'GT C' => you see the pattern...
    'D Arm' => Decrement Arm
    'CE-A 1' => Counterexample Arm 1

...and so on.  For the rest of CEAB1:

```
    e:   [6 f [1 1] g]                                                 ::  "If 3 > N then return '1', else continue at g."
    f:    [9 4 [[0 28] [[[1 3] [0 126]] [0 29]]]]   ::  f = "3 > N".
    g:   [6 [9 2 [[0 4] [[0 126] [0 5]]]] k [1 1]]   ::  "If N is even then continue at k, else return '1'."
    k:   [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[0 508] k2] [0 255]]]
                                                                            ::  "Call CE-Arm 2, the loop arm, passing the whole subject
    k2:  [9 2 [[0 60] k3 [0 61]]]                         ::  ...except that we set the value of j, address # 509,
    k3:  [9 2 [[0 60] [0 126] [0 61]]]                 ::  to be Decrement(Decrement(N))."
```

For those not keeping close track of the subject:

```
    Address # 28:  'Greater than' battery
    Address # 4:  Even number checker arm
    Address # 125:  CE-Arm 2, the loop arm
    Address # 60:  Decrement Arm
    Address # 126:  N
    Address # 508:  i
    Address # 509:  j
```

As for the loop arm, CEAB2:

```
    [1 [6 m [[0 254] [1 1]] o]]                           ::  "If both_prime(i, j) [is true] then return [[i j] 1], else
                                                                         ::  continue at o."
    m:   [9 2 [[0 12] [0 254] [0 13]]]              ::  m = "both_prime(i, j)"
    o:   [6 [5 [4 [4 [0 508]]] [0 126]] [1 0] p]    ::  "If i + 2 = N then return '0', else continue at p."
    p:   [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [p2 p3] [0 255]]]
                                                                             ::  "Call CE-Arm 2 (i.e., 'loop'), with the same subject,
                                                                             ::  but modify i and j:
    p2:  [4 [0 508]]                                              ::  add 1 to i, and,
    p3:  [9 2 [[0 60] [0 509] [0 61]]]                ::  decrement 1 from j."
```

Again, for those not keeping close track of the subject:

```
    Address # 254:  The tuple of (i, j)
    Address # 12:  Both prime checker arm
    Address # 508:  i
    Address # 509:  j
    Address # 126:  N
    Address # 125:  CE-Arm 2, the loop arm
    Address # 60:  Decrement Arm
```

And that's pretty much it.  As promised earlier, here are all the library formulas: two which we just wrote, CEAB 1 and 2, many of which come from earlier posts, and two of which are otherwise exercises for the reader: decrement and both_prime.

```
    AGB (addition):   [1 [1 [6 [5 [0 13] [0 14]] [0 12] [9 2 [[0 2] [[4 [0 12]] [0 13]] [[4 [0 14]] [0 15]]]]]] [1 0] [0 1]]
    MGB (multiplication):   [1 [[1 [8 [9 5 [0 15]] [6 [5 [0 29] [0 61]] [0 60] [9 2 [[0 6] [0 14] [[[9 2 [[0 4] [[[0 60] [0 28]] [0 5]]]] [4 [0 61]]] [0 31]]]]]]] [[[1 0] [1 0]] [0 1]]]]
    
    s (greater than):   [1 [[GT-A1 GT-A2] [[[1 0] [1 0]] [0 1]]]]
    GT-A1:   [1 [6 [5 [0 14] [0 15]] [1 1] [9 5 [[0 2] [[0 6] [[0 6] [0 15]]]]]]]
    GT-A2:   [1 [6 [5 [4 [0 28]] [0 13]] [1 1] [6 [5 [4 [0 29]] [0 12]] [1 0] [9 5 [[0 2] [[0 6] [[[4 [0 28]] [4 [0 29]]] [0 15]]]]]]]]
    
    r (prime checker):  [1 [[PC-A1 PC-A2] [[[1 2] [1 2]] [0 1]]]]
    PC-A1:    [1 [8 [9 9 [0 15]] [8 [9 17 [0 31]] [8 [9 129 [0 63]] [6 [5 [0 62] [1 0]] [1 1] [6 [5 [0 62] [1 1]] [1 1] [6 [5 [0 62] [1 2]] [1 0] [6 [5 [0 62] [1 3]] [1 0] [6 [9 2 [[0 4] [0 62] [0 5]]] [1 1] [9 61 [0 1]]]]]]]]]]]
    PC-A2:   [1 [6 [5 [9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [1 1] [6 [5 [4 [0 253]] [0 62]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [1 0] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[1 2] [4 [0 253]]] [0 127]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]]]]]
    (Note:  I've modified the prime checker from the earlier post to run a little more quickly.  Ask if you'd like details.)
    
    BPGB (both_prime):   [1 [[1 [8 [9 33 [0 7]] [6 [9 4 [[0 4] [0 28] [0 5]]] [6 [9 4 [[0 4] [0 29] [0 5]]] [1 0] [1 1]] [1 1]]]] [0 1]]]
    EGB (even checker):   [1 [[1 [6 [5 [0 28] [0 6]] [1 0] [6 [5 [0 29] [0 6]] [1 1] [9 2 [[0 2] [[0 6] [[[4 [4 [0 28]]] [4 [4 [0 29]]]] [0 15]]]]]]]] [[[1 0] [1 1]] [0 1]]]]
    DGB (decrement):   [1 [[1 [6 [5 [4 [0 14]] [0 6]] [0 14] [9 2 [[0 2] [[0 6] [[4 [0 14]] [0 15]]]]]]] [[1 0] [0 1]]]]

    q (CE checker):   [1 [[CEAB1 CEAB2] [[[1 2] [1 0]] [0 1]]]]
    CEAB1:   [1 [8 [9 257 [0 15]] [8 [9 17 [0 31]] [8 [9 65 [0 63]] [8 [9 129 [0 127]] [6 [9 4 [[0 28] [[[1 3] [0 126]] [0 29]]]] [1 1] [6 [9 2 [[0 4] [[0 126] [0 5]]]] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[0 508] [9 2 [[0 60] [9 2 [[0 60] [0 126] [0 61]]] [0 61]]]] [0 255]]] [1 1]]]]]]]]
   CEAB2:   [1 [6 [9 2 [[0 12] [0 254] [0 13]]] [[0 254] [1 1]] [6 [5 [4 [4 [0 508]]] [0 126]] [1 0] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[4 [0 508]] [9 2 [[0 60] [0 509] [0 61]]]] [0 255]]]]]]
```

Here's the whole program, with all substitutions made:

`[8 [[[[[[[[[1 [[[1 [8 [9 257 [0 15]] [8 [9 17 [0 31]] [8 [9 65 [0 63]] [8 [9 129 [0 127]] [6 [9 4 [[0 28] [[[1 3] [0 126]] [0 29]]]] [1 1] [6 [9 2 [[0 4] [[0 126] [0 5]]]] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[0 508] [9 2 [[0 60] [9 2 [[0 60] [0 126] [0 61]]] [0 61]]]] [0 255]]] [1 1]]]]]]]] [1 [6 [9 2 [[0 12] [0 254] [0 13]]] [[0 254] [1 1]] [6 [5 [4 [4 [0 508]]] [0 126]] [1 0] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[4 [0 508]] [9 2 [[0 60] [0 509] [0 61]]]] [0 255]]]]]]] [[[1 2] [1 0]] [0 1]]]] [1 [[1 [6 [5 [4 [0 14]] [0 6]] [0 14] [9 2 [[0 2] [[0 6] [[4 [0 14]] [0 15]]]]]]] [[1 0] [0 1]]]]] [1 [[1 [6 [5 [0 28] [0 6]] [1 0] [6 [5 [0 29] [0 6]] [1 1] [9 2 [[0 2] [[0 6] [[[4 [4 [0 28]]] [4 [4 [0 29]]]] [0 15]]]]]]]] [[[1 0] [1 1]] [0 1]]]]] [1 [[1 [8 [9 33 [0 7]] [6 [9 4 [[0 4] [0 28] [0 5]]] [6 [9 4 [[0 4] [0 29] [0 5]]] [1 0] [1 1]] [1 1]]]] [0 1]]]] [1 [[[1 [8 [9 9 [0 15]] [8 [9 17 [0 31]] [8 [9 129 [0 63]] [6 [5 [0 62] [1 0]] [1 1] [6 [5 [0 62] [1 1]] [1 1] [6 [5 [0 62] [1 2]] [1 0] [6 [5 [0 62] [1 3]] [1 0] [6 [9 2 [[0 4] [0 62] [0 5]]] [1 1] [9 61 [0 1]]]]]]]]]]] [1 [6 [5 [9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [1 1] [6 [5 [4 [0 253]] [0 62]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [1 0] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[1 2] [4 [0 253]]] [0 127]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]]]]]] [[[1 2] [1 2]] [0 1]]]]] [1 [[[1 [6 [5 [0 14] [0 15]] [1 1] [9 5 [[0 2] [[0 6] [[0 6] [0 15]]]]]]] [1 [6 [5 [4 [0 28]] [0 13]] [1 1] [6 [5 [4 [0 29]] [0 12]] [1 0] [9 5 [[0 2] [[0 6] [[[4 [0 28]] [4 [0 29]]] [0 15]]]]]]]]] [[[1 0] [1 0]] [0 1]]]]] [1 [[1 [8 [9 5 [0 15]] [6 [5 [0 29] [0 61]] [0 60] [9 2 [[0 6] [0 14] [[[9 2 [[0 4] [[[0 60] [0 28]] [0 5]]]] [4 [0 61]]] [0 31]]]]]]] [[[1 0] [1 0]] [0 1]]]]] [1 [1 [6 [5 [0 13] [0 14]] [0 12] [9 2 [[0 2] [[4 [0 12]] [0 13]] [[4 [0 14]] [0 15]]]]]] [1 0] [0 1]]] [1 0]] [8 [9 256 [0 2]] [9 4 [[0 4] [0 7] [0 5]]]]]`

Okay, that was just for showing off.  Here's a (slightly) more readable version:

```
    [ 8
      [ [ [ [ [ [ [ [ [ 1
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
                      9 2 [0 2] [0 6] [[4 4 0 28] 4 4 0 29] [0 15]]
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
      [9 256 0 2]
      9 4 [0 4] [0 7] [0 5]
    ]
```

If you want to check whether 368 is a counterexample to the Goldbach conjecture... then for heaven's sake please don't paste any of the above into dojo.  The parser will take forever and a day to respond, if you try.  Instead, do the following:

1.  Mount your home desk with `|mount %` in dojo.
2.  Paste the following into a text editor:

```
:gate  arg/atom
.*(arg [8 [[[[[[[[[[1 [[[1 [8 [9 513 [0 7]] [6 [5 [0 14] [1 0]] [9 13 [0 1]] [9 4 [[0 4] [0 14] [0 5]]]]]] [1 [6 [5 [9 4 [[0 4] [0 14] [0 5]]] [1 0]] [0 14] [9 13 [[0 2] [0 6] [4 [4 [0 14]]] [0 15]]]]]] [0 1]]] [1 [[[1 [8 [9 257 [0 15]] [8 [9 17 [0 31]] [8 [9 65 [0 63]] [8 [9 129 [0 127]] [6 [9 4 [[0 28] [[[1 3] [0 126]] [0 29]]]] [1 1] [6 [9 2 [[0 4] [[0 126] [0 5]]]] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[0 508] [9 2 [[0 60] [9 2 [[0 60] [0 126] [0 61]]] [0 61]]]] [0 255]]] [1 1]]]]]]]] [1 [6 [9 2 [[0 12] [0 254] [0 13]]] [[0 254] [1 1]] [6 [5 [4 [4 [0 508]]] [0 126]] [1 0] [9 125 [[0 2] [0 6] [0 14] [0 30] [0 62] [0 126] [[4 [0 508]] [9 2 [[0 60] [0 509] [0 61]]]] [0 255]]]]]]] [[[1 2] [1 0]] [0 1]]]]] [1 [[1 [6 [5 [4 [0 14]] [0 6]] [0 14] [9 2 [[0 2] [[0 6] [[4 [0 14]] [0 15]]]]]]] [[1 0] [0 1]]]]] [1 [[1 [6 [5 [0 28] [0 6]] [1 0] [6 [5 [0 29] [0 6]] [1 1] [9 2 [[0 2] [[0 6] [[[4 [4 [0 28]]] [4 [4 [0 29]]]] [0 15]]]]]]]] [[[1 0] [1 1]] [0 1]]]]] [1 [[1 [8 [9 33 [0 7]] [6 [9 4 [[0 4] [0 28] [0 5]]] [6 [9 4 [[0 4] [0 29] [0 5]]] [1 0] [1 1]] [1 1]]]] [0 1]]]] [1 [[[1 [8 [9 9 [0 15]] [8 [9 17 [0 31]] [8 [9 129 [0 63]] [6 [5 [0 62] [1 0]] [1 1] [6 [5 [0 62] [1 1]] [1 1] [6 [5 [0 62] [1 2]] [1 0] [6 [5 [0 62] [1 3]] [1 0] [6 [9 2 [[0 4] [0 62] [0 5]]] [1 1] [9 61 [0 1]]]]]]]]]]] [1 [6 [5 [9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [1 1] [6 [5 [4 [0 253]] [0 62]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [1 0] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]] [6 [9 4 [[0 12] [[[9 2 [[0 28] [[0 126] [0 29]]]] [0 62]] [0 13]]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[1 2] [4 [0 253]]] [0 127]]] [9 61 [[0 2] [0 6] [0 14] [0 30] [0 62] [[4 [0 252]] [0 253]] [0 127]]]]]]]] [[[1 2] [1 2]] [0 1]]]]] [1 [[[1 [6 [5 [0 14] [0 15]] [1 1] [9 5 [[0 2] [[0 6] [[0 6] [0 15]]]]]]] [1 [6 [5 [4 [0 28]] [0 13]] [1 1] [6 [5 [4 [0 29]] [0 12]] [1 0] [9 5 [[0 2] [[0 6] [[[4 [0 28]] [4 [0 29]]] [0 15]]]]]]]]] [[[1 0] [1 0]] [0 1]]]]] [1 [[1 [8 [9 5 [0 15]] [6 [5 [0 29] [0 61]] [0 60] [9 2 [[0 6] [0 14] [[[9 2 [[0 4] [[[0 60] [0 28]] [0 5]]]] [4 [0 61]]] [0 31]]]]]]] [[[1 0] [1 0]] [0 1]]]]] [1 [1 [6 [5 [0 13] [0 14]] [0 12] [9 2 [[0 2] [[4 [0 12]] [0 13]] [[4 [0 14]] [0 15]]]]]] [1 0] [0 1]]] [1 0]] [8 [9 512 [0 2]] [9 4 [[0 4] [0 7] [0 5]]]]])
```

3.  Save it as "goldbach.hoon" in home/gen/ of your Urbit pier.
4.  Type `+goldbach 368` in dojo.

You should get `[[19 349] 1]` as your answer.  The '1' is for Martion 'no", and 19 + 349 = 368.  (19 and 349 are each prime.)

Keep in mind, this is not a particularly efficient program.  If you test numbers of three digits or fewer you should get a pretty quick result.  Lower-end 4 digits usually aren't too bad, but if you get too high you might want to take a short vacation with your family while it's running.

Enjoy!
