(cl:in-package #:common-lisp-user)

(defpackage #:awele (:use #:common-lisp)
  (:export
   #:game
   #:game-houses
   #:new-game
   #:seed-count
   #:current-player
   #:house-number
   #:nth-house
   #:player-house-numbers
   #:game-house-play
   #:game-over
   #:toggle-player
   #:terminate-game
   #:player-score
   #:playerp
   #:player-name
   #:strategy-player
   #:current-player-can-play
   #:next-valid-house-number
   #:interactive-p
   #:init-game
   #:game-undo
   #:play-count
   #:assign-strategy-from-name
   #:strategy
   #:strategy-name
   #:player
   #:current-strategy-player
   #:available-strategies
   #:nth-strategy-player
   #:strategy-player-string
   #:*game*
   #:valid-house-number-p
   #:game-end
   ))
