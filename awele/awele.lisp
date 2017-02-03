(in-package :awele)

(defun new-game (&key
		 (strategy1 *interactive-strategy*)
		 (strategy2 *interactive-strategy*))
  "returns a new game with first player having STRATEGY1\
 and second player having STRATEGY2"
  (make-game strategy1 strategy2))

(defun awele ()
  (run-game (new-game)))
