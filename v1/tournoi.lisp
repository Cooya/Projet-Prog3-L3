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

  ;;; Game loop

;;testing purpose variables
;(defparameter *northPlayerType* NIL)
;(defparameter *southPlayerType* NIL)

; initialisation du plateau
(defun initialize-board ()
  (setf *board* (make-list 12 :initial-element 4))
)
  

(defun initAwele ()
  (initialize-board) 
  (setf (car *northPoints*) 0)
  (setf (car *southPoints*) 0)
)

(defun getCurrentPlayerType ()
  (if (= (car *player*) 0)
      *northPlayerType*
      *southPlayerType*
      )
  )
    
(defun countAndEmptyRemainingBeans ()
  (let ((count 0))
    (loop for e on *board* do
      (setf count (+ count (car e)))
      (setf (car e) 0)
	  )
    count
    )
  )


(defun checkInputNumberType(number)
  (if (numberp number)
      (if (and (>= number 0) (<= number 4)) ; add (or ... (= number 1) (for random etc)
	  T
	  NIL)
      NIL)
  )


(defun askPlayersType()
  (format t "Please enter value of North player : ~% Human is 0 -- Random AI is 1 -- Jason1 AI is 2 -- Jason AI is 3 -- Nico AI is 4~%~%>>>") ; ... later ~% AI RANDOM IS 1 ~% AI ... ... ~%~%")
  (let ( (input NIL) )
    (setf input (read))
    (if (not (checkInputNumberType input))
	(loop do
	  (format t "Bad input number, please input good number bro~%>>>")
	  (setf input (read))
	      while (not (checkInputNumberType input))) ; while it is not number, re-iterate
	)
    (setf *northPlayerType* input)
    (format t "Ok we got the North Player type which is : ~D ~%" *northPlayerType*)
    (setf input NIL)
    (format t "Please enter value of South player : ~% Human is 0 -- Random AI is 1 -- Jason1 AI is 2 -- Jason AI is 3 -- Nico AI is 4~%~%>>>") ; later AI RANDOM IS 1, AI is 2... etc
    (setf input (read)) ; Read input first time
    (if (not (checkInputNumberType input))
	(loop do
	  (format t "Bad input number, please input good number bro~%>>>")
	  (setf input (read))
	      while (not (checkInputNumberType input))) ; while it is not number, re-iterate
	)
    (setf *southPlayerType* input)
    (format t "Ok we got the North Player type which is : ~D ~%" *southPlayerType*)
    ) ;end let
  (if (and (= *southPlayerType* 0) (= *northPlayerType* 0)) ; humans
      (format t "Ok guys, you're two humans, let the game begins, good luck have fun ! ~%")
      (if (and (not (= *southPlayerType* 0)) (not (= *northPlayerType* 0)))
	  (format t "No humans will be playing, Let me play alone. ~%")
	  (format t "Good luck, I'll beat you for sure... ~%")
	  ))

  )

(defun print-score ()
  (format t "~% NORTH POINTS : ~D ~% SOUTH POINTS : ~D ~%~%" (car *northPoints*) (car *southPoints*))
  )

(defun checkFirstPlayer(n)
  (if (numberp n)
      (if (or (= 0 n) (= 1 n))
	  T
	  NIL)
      NIL)
  )
  
(defun setCurrentPlayer (cardinal)
  (setf (car *player*) cardinal)
  )

(defun askFirstPlayer()
  (format t "~% WHO WILL BEGIN TO PLAY? NORTH PLAYER PUT 0; SOUTH PLAYER PUT 1; ~%~%>>>")
  (let ( (input NIL) )
    (setf input (read))
    (loop while (not (checkFirstPlayer input)) do
		(format t "Bad number bro, type correct one (north=0; south = 1)~%>>>")
		(setf input (read))
	  )
    (setCurrentPlayer input)
    
  (format t "Ok the player ~D will begin to play ~%" (car *player*)))
  )

  (defun init-standalone (firstp)
        (declare (ignore firstp))
	(initAwele)
	)

(defun main-standalone (case)
	(let*
		(
			(otherPlayer nil)
			(player nil)
			(chosenPosition nil)
			)

    (if case
      (progn
        (setf otherPlayer (cons (if (< case 6) NORTH SOUTH) nil))
        (setf player (cons (- 1 (car otherPlayer)) nil))
        )
      (setf player *player*)
      )

    (if otherPlayer
      (progn
		    (setf *player* otherPlayer)
		    (playPosition case)
        )
      )
		(setf *player* player)
		(setf chosenPosition (aiJason))
    (if chosenPosition
      (if (playPosition chosenPosition)
        chosenPosition
        nil
        )
      nil
      )
		)
	)
