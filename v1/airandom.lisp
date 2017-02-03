					; Random AI

(defun aiRandom ()
  (let ((rangeStart (* (car *player*) 6)) )
    (let ((rCase (+ rangeStart (random 6)))) 
      (loop while (not (positionPlayable rCase)) do
	(setf rCase (+ rangeStart (random 6)))
	    )
      (return-from aiRandom rCase)
      )
    )
  )
