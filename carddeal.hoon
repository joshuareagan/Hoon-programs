::
::  carddeal.hoon
::
::  this program deals cards from a randomly shuffled deck.
::
::  save as `carddeal.hoon` in the `/gen` directory of your
::  urbit's pier and run in the dojo:
::
::  +carddeal [4 5]
::
::
=<
::
::  a is the number of hands to be dealt
::  b is the number of cards per hand
::
|=  [a=@ b=@]
::
::  `cards` is a core with a shuffled deck as state
::
=/  cards  shuffle:sorted-deck:cards
|-  ^-  (list (list card))
?:  =(0 a)  ~
::
::  `draw` returns a pair of [hand cards]
::  `hand` is a list of cards, i.e. a dealt hand, and
::  `cards` is the core with a modified deck
::  (the cards of `hand` were removed from the deck)
::
=^  hand  cards  (draw:cards b)
[hand $(a (dec a))]
::
|%
::
::  a `card` is a pair of [value suit]
::
+=  card  [value suit]
::
::  a `value` is either a number or a face value
::
+=  value  $?  %2  %3  %4
               %5  %6  %7
               %8  %9  %10
               %jack
               %queen
               %king
               %ace
            ==
::
::  the card suits are: clubs, hearts, spades,
::  and diamonds
::
+=  suit  $?  %clubs
              %hearts
              %spades
              %diamonds
          ==
::
::  `cards` is a door with `deck` and `rng` as state
::  `deck` is a deck of cards
::  `rng` is a Hoon stdlib core for random # generation
::  a door is a core with a sample, often multi-arm
::
++  cards
  |_  [deck=(list card) rng=_~(. og 123.458)]
  ::
  ::  `this` is, by convention, how a door refers
  ::  to itself
  ::
  ++  this  .
  ::
  ::  `draw` returns two things: (1) a list of cards (i.e. a hand),
  ::  and (2) a modified core for `cards`.  the `deck` in `cards`
  ::  has the dealt cards removed.
  ::
  ++  draw
    |=  a=@
    =|  hand=(list card)
    |-  ^-  [(list card) _this]
    ?:  =(0 a)  [hand this]
    ?~  deck  !!
    %=  $
      hand  [i.deck hand]
      deck  t.deck
      a  (dec a)
    ==
  ::
  ::  `shuffle` returns the `cards` core with a modifed `deck`.
  ::  the cards in the deck have been shuffled randomly.
  ::
  ++  shuffle
    =|  shuffled=(list card)
    =/  len=@  (lent deck)
    |-  ^-  _this
    ?:  =(~ deck)  this(deck shuffled)
    =^  val  rng  (rads:rng len)
    %=  $
      shuffled  [(snag val deck) shuffled]
      deck  (oust [val 1] deck)
      len  (dec len)
    ==
  ::
  ::  `sorted-deck` returns the `cards` core with a modifed
  ::  `deck`.  the full deck of cards is provided, unshuffled.
  ::
  ++  sorted-deck
    %_  this
      deck  =|  sorted=(list card)
            =/  suits=(list suit)
              ~[%spades %diamonds %clubs %hearts]
            |-  ^-  (list card)
            ?~  suits  sorted
            %=  $
              suits  t.suits
              sorted
                :*  [%2 i.suits]
                    [%3 i.suits]
                    [%4 i.suits]
                    [%5 i.suits]
                    [%6 i.suits]
                    [%7 i.suits]
                    [%8 i.suits]
                    [%9 i.suits]
                    [%10 i.suits]
                    [%jack i.suits]
                    [%queen i.suits]
                    [%king i.suits]
                    [%ace i.suits]
                    sorted  ==
            ==
    ==
  --
--
