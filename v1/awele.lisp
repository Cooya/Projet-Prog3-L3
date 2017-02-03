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
 
(defun awele(&optional n s f) ; attention pas de test pour les paramètres optionnels
  (format t "Welcome to Awele ~%")
  (initAwele)
  (if n
	(progn
	  (setf *northPlayerType* n)
	  (setf *southPlayerType* s)
	)
	(askPlayersType)
  )
  (if f
    (setf (car *player*) f)
	(askFirstPlayer)
  )
  (format t "GAME BEGIN ~%")
  (print-board)
  (loop while
	(and
	 (canPlay)
	 (and
	  (<= (car *northPoints*) 24)
	  (<= (car *southPoints*) 24)
	  )
	 ) do
	   (let ((chosenPosition NIL) (playResults nil))
	     (loop while (not (numberp chosenPosition)) do
	       (case (getCurrentPlayerType)
		 (0 ; HUMAN
		  (format t "~a, please enter your playing position :~%" (if (= (car *player*) 0) "North" "South") )
		  (setf chosenPosition (read))
		 )
		 (1 ; AI RANDOM
		  (setf chosenPosition (aiRandom))
		 )
		 (2 ; AI Jason1
		  (setf chosenPosition (aiJason1))
		 )
		 (3 ; AI Jason
		  (setf chosenPosition (aiJason))
		 )
		 (4 ; AI Nicolas
		  (setf chosenPosition (aiNico))
		 )
		 (otherwise
		  (format t "ERROR! NOT SUPPORTED PLAYER TYPE!!!!!!!!!~%")
		 )
	       )
	     )
	     
	     (setf playResults (playPosition chosenPosition))
	     (print-board)
	     (format t "~a played case ~D~%" (if (= (car *player*) 0) "North" "South") chosenPosition)
	     
	     (if playResults
		 (setf (car *player*) (- 1 (car *player*)))
		 (format t "Can't play here.~%")
	     )
	     (format t "~%")
	   )
	)
					;ajouter partage des graines restantes
  (let  ((remainingBeans (countAndEmptyRemainingBeans)))
    (if (= (mod remainingBeans 2) 0) ; pair
	(progn
	  (setf (car *northPoints*) (+ (car *northPoints*) (/ remainingBeans 2)))
	  (setf (car *southPoints*) (+ (car *southPoints*) (/ remainingBeans 2)))
	  ) ; si impair donner le +1 au joueur qui ne peut pas jouer
	(if (= (car *player*) 0) ; si c'est le north
	    (progn
	      (setf (car *northPoints*) (1+ (+ (car *northPoints*) (floor remainingBeans 2))))
	      (setf (car *southPoints*) (+ (car *southPoints*) (floor remainingBeans 2)))
	      ) ; si c'est le south
	    (progn
	      (setf (car *southPoints*) (1+ (+ (car *southPoints*) (floor remainingBeans 2))))
	      (setf (car *northPoints*) (+ (car *northPoints*) (floor remainingBeans 2)))
	      )
	    )
	)
    )

  (format t "FINAL RESULTS ~%")
  (print-board)
  (if (= (car *southPoints*) (car *northPoints*))
      (format t "No winner for this game... Re-play ! ~%~%")
      (format t "Game is finished ~% and the winner is ~a player!! ~% Congratulations you can now eat more beans than ~a player! :) ~%~%" (if (> (car *southPoints*) (car *northPoints*)) "South" "North") (if (> (car *southPoints*) (car *northPoints*)) "North" "South"))
      )
  (format t "Do you want to play again ? (y/n)~%>>>")
  (let ( (input NIL) )
  	(setf input (read))
  	(loop while (not (or (equal input 'y) (equal input 'n))) do
  		(format t "Please type y or n~%>>>")
  		(setf input (read))
  		)
  	(if (equal input 'y)
  		(awele)
  		(format t "Bye!~%")
  		)
  	)
  )
