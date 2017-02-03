; Biggest points for me, lowest for opponent AI

(defun calcPoints (case)
  (let (
    (board (copy-list *board*))

    (gainedPointsMe)
    (gainedPointsOther)

    (savedPointsMe)
    (savedPointsOther)

    (playRet)
    )

    (if (= (car *player*) 0)
      (progn
        (setf savedPointsMe (car *northPoints*))
        (setf savedPointsOther (car *southPoints*))
        )
      (progn
        (setf savedPointsMe (car *southPoints*))
        (setf savedPointsOther (car *northPoints*))
        )
      )

    (setf playRet (playPositionGen board *player* (if
      (=
        (car *player*)
        NORTH
        )
      *northPoints*
      *southPoints*
      ) case))

    (if (= (car *player*) 0)
      (progn
        (setf gainedPointsMe (- (car *northPoints*) savedPointsMe))
        (setf gainedPointsOther (- (car *southPoints*) savedPointsOther))
        (setf (car *northPoints*) savedPointsMe)
        (setf (car *southPoints*) savedPointsOther)
        )
      (progn
        (setf gainedPointsMe (- (car *southPoints*) savedPointsMe))
        (setf gainedPointsOther (- (car *northPoints*) savedPointsOther))
        (setf (car *southPoints*) savedPointsMe)
        (setf (car *northPoints*) savedPointsOther)
        )
      )
    
    (if playRet
      (- gainedPointsMe gainedPointsOther)
      nil
      )
    )
  )

(defun aiJason1 ()
  (let (
    (myRangeStart (* (car *player*) 6))
    (bestPosition nil)
    (bestPoints nil)
    (tmpResult nil)
    )

    (loop for i from myRangeStart to (+ myRangeStart 5) do
      (setf tmpResult (calcPoints i))

      (if tmpResult
        (if bestPosition
          (if (> tmpResult bestPoints)
            (progn
              (setf bestPoints tmpResult)
              (setf bestPosition i)
              )
            )
          (progn
            (setf bestPoints tmpResult)
            (setf bestPosition i)
            )
          )
        )
      ;(format t "Iter ~a test ~a best ~a~%" i tmpResult bestPosition)
      )
    bestPosition
    )
  )
