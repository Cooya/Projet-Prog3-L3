
;for testing
;(defparameter *test-print-board* '(1 2 3 4 5 6 7 8 9 10 11 12))


(defun print-board()
  (format t "|  C5 | C4 | C3 | C2 | C1 | C0 | ~%")
  (format t "--------------------------------~%")
  (let ((semiboard (subseq *board* 0 6)))
    (format t "| ")
    (dotimes (n 6)
      (format t "~3D" (car (last semiboard)))
      (format t " |")
      (setf semiboard (butlast semiboard))
      )
    (format t "   NORTH POINTS = ~D  " (car *northPoints*))
    (format t "~%--------------------------------~%")
    (format t "| ")
    (setf semiboard (subseq *board* 6 12))
    (dotimes (n 6)
      (format t "~3D" (car semiboard))
      (format t " |")
      (setf semiboard (cdr semiboard))
      )
    )
  (format t "    SOUTH POINTS = ~D  " (car *southPoints*))
  (format t "~%--------------------------------~%")
  (format t "|  C6 | C7 | C8 | C9 | C10| C11 | ~%")
   )

