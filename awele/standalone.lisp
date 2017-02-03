(in-package :awele)
(defvar *game*)
(defvar *empty-strategy* (make-strategy "EMPTY" nil))

(defun init-standalone-with-strategy (strategy firstp)
  (init-random)
  (setf *game* (make-game (if firstp strategy *empty-strategy*)
			  (if firstp *empty-strategy* strategy)))
  (when firstp (toggle-player *game*)))


(defun play-if-not-nil (house-number game)
  (if house-number
      (game-house-play game house-number)
      (toggle-player game)))

(defun main-standalone (house-number)
  (play-if-not-nil house-number *game*)
  (let ((house (next-valid-house-number *game*)))
    (play-if-not-nil house *game*)
    house))
