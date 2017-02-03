(defun computePoints (range case)
	(let (
		(board (copy-list *board*))
		(player *player*)
		(points (cons 0 nil))
		(weakCases 0)
		(weakCasesEnemy 0)
		(rangeEnemy (- 6 range))
		)
		(if (playPositionGen board player points case)
			(progn
				(loop for i from range to (+ range 5) do
					(if (or (equal (nth i board) 1) (equal (nth i board) 2))
						(setf weakCases (+ weakCases 1))
					)
				)
				(setf (car points) (- (car points) weakCases))
				(loop for i from rangeEnemy to (+ rangeEnemy 5) do
					(if (or (equal (nth i board) 1) (equal (nth i board) 2))
						(setf weakCasesEnemy (+ weakCases 1))
					)
				)
				(+ (car points) weakCasesEnemy)
			)
			nil
		)
	)
) 

(defun aiNico ()
	(let (
		(range (* (car *player*) 6))
		(maxPoints (- 1000))
		(bestPos nil)
		(currentPoints nil)
		)
		(loop for i from range to (+ range 5) do
			(setf currentPoints (computePoints range i))
			(if(and currentPoints (> currentPoints maxPoints))
				(progn
					(setf maxPoints currentPoints)
					(setf bestPos i)
				)
			)
		)
		bestPos
	)
)

; compter le nombre de points gagnés (grâce à la fonction playPositionGen)
; compter le nombre de points perdus
; regarder le nombre de cases faibles chez soi
; regarder le nombre de cases faibles chez l'adveraire
