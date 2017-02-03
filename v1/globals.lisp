; globals
(defparameter *board* (make-list 12))
(defconstant NORTH 0)
(defconstant SOUTH 1)
(defparameter *northPoints* (cons 0 nil))
(defparameter *southPoints* (cons 0 nil))
(defparameter *player* (cons NORTH nil))
;player types are :  HUMAN = 0 ; AI_RANDOM = 1; AI_...= ....
(defparameter *northPlayerType* 0)
(defparameter *southPlayerType* 0)

