(in-package :awele)

(defgeneric random-fun (game))
(defmethod random-fun ((game game))
  (let ((valid-house-numbers (game-valid-house-numbers game)))
    (random-element valid-house-numbers)))

(defvar *random-strategy*
  (make-strategy "random" #'random-fun))

(add-strategy *random-strategy*)

(defun init-standalone (firstp)
  (init-standalone-with-strategy *random-strategy* firstp))
