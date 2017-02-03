;(load "globals.lisp")

(defun atHomeGen (player case)
	(let ((rangeStart (* (car player) 6)))
		(if
			(and
				(>= case rangeStart)
				(< case (+ rangeStart 6))
			)
			t
			nil
		)
	)
)

(defun positionPlayableGen (board player case)
	(if (numberp (nth case board))
		(if (= (nth case board) 0)
			nil
			(atHomeGen player case)
		)
		nil
	)
)

(defun canPlayGen (board player)
  (let ((myBoard (nthcdr (* (car player) 6) board)) (i 0) (retVal nil))
		(loop for e in myBoard while (< i 6) do
			(if (/= e 0)
			    (return-from canPlayGen t)
			    (incf i)
			    )
			
		)
		retVal
	)
)

;(defun addPointsGen (player points)
;	(if (= *player* NORTH)
;		(setf *northPoints* (+ *northPoints* points))
;		(setf *southPoints* (+ *southPoints* points))
;	)
;)

(defun playPositionGen (board player points case)
	(let ((leftBeans 0) (firstPass t) (lastAlteredPosition nil))
	(if (positionPlayableGen board player case)
		(progn
			(let ((i 0))
				(loop while (or firstPass (> leftBeans 0)) do
					(loop for e on board do
						(progn
							(if (and (> leftBeans 0) (/= i case))
								(progn
									(decf leftBeans)
									(incf (car e))
									(setf lastAlteredPosition i)
								)
							)
							(if (and
									firstPass
									(= i case)
								)
								(progn
									(setf leftBeans (car e))
									(rplaca e 0)
								)
							)
							(incf i)
						)
					)
					(setf firstPass nil)
					(setf i 0)
				)
				(if lastAlteredPosition
					(let ((posCdr (nthcdr lastAlteredPosition board)))
						(loop while
							(and
								(not (atHomeGen player lastAlteredPosition))
								(or
									(= (car posCdr) 2)
									(= (car posCdr) 3)
								)
							) do
							;(progn
								(setf (car points) (+ (car points) (car posCdr)))
								;(addPoints (car posCdr))
								(rplaca posCdr 0)
								(decf lastAlteredPosition)
								(if (< lastAlteredPosition 0) (return))
								(setf posCdr (nthcdr lastAlteredPosition board))
							;)
						)
					)
				)
			)
			t
		)
		nil
	)
	)
)

(defun atHome (case)
	(atHomeGen *player* case)
)

(defun positionPlayable (case)
	(positionPlayableGen *board* *player* case)
)

(defun canPlay ()
	(canPlayGen *board* *player*)
)

(defun playPosition (case)
	(playPositionGen
		*board*
		*player*
		(if
			(=
				(car *player*)
				NORTH
				)
			*northPoints*
			*southPoints*
			)
		case
		)
)
