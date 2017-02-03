; Biggest points for me, lowest for opponent AI

(defparameter *AIJASONITER* 8)

(defun aiJasonGetScoreOfCase (board player points case remainingIter)
  (let (
    (rangeStart nil)
    (result 0)
    (tmpResult nil)
    (sumResults 0)
    (nbPlayable 0)
    (testBoard (copy-list board))
    (testPoints (copy-list points))
    (testPlayer (copy-list player))
    )

    ; hypothetic play
    (if(playPositionGen testBoard player testPoints case)
      (setf result (- (car testPoints) (car points)))
      (return-from aiJasonGetScoreOfCase nil)
      )

    (setf (car testPlayer) (- 1 (car testPlayer)))
    (setf rangeStart (* (car testPlayer) 6))

    ; recursion test
    (if (> remainingIter 1)
      (loop for i from rangeStart to (+ rangeStart 5) do
        (setf
          tmpResult
          (aiJasonGetScoreOfCase
            testBoard
            testPlayer
            testPoints
            i
            (1- remainingIter)
            )
          )

        (if tmpResult
          (setf
            sumResults
            (+
              sumResults
              tmpResult)
            )
          )

        (incf nbPlayable)
        )
      )

    ;(format t "Partial res : ~a~%" (float (/ tmpResult nbPlayable)))
    (if (= sumResults 0)
      result
      ;(progn
        ;(format t "Partial res : ~a~%" (- result (float (/ sumResults nbPlayable))))
        (- result (float (/ sumResults nbPlayable)))
        ;)
      )
    )
  )

(defun aiJason ()
  (let (
    (myRangeStart (* (car *player*) 6))
    (bestPosition nil)
    (bestPoints nil)
    (tmpResult nil)
    )

    (loop for i from myRangeStart to (+ myRangeStart 5) do
      (setf tmpResult (aiJasonGetScoreOfCase
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
          i
          *AIJASONITER*
          )
        )

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