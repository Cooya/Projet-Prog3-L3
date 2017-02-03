(cl:in-package #:gui-awele)

(defparameter *automatic* nil)

(defun automatic-p () *automatic*)

(defun toggle-automatic ()
  (setq *automatic* (not *automatic*)))

;;; For now, we can handle only one game at a time.  This game is
;;; stored in the special variable *GAME*. It would be better to
;;; support different sessions, so that when the URI "/awele" (without
;;; a house number following), a new session is created. 

;;; Main entry point.  When this function is called, the acceptor goes
;;; into an infinite loop serving requests.  If you still want to be
;;; able to evaluate forms, run this function in its own thread.

(defun start-acceptor (port)
  (setf hunchentoot::*supports-threads-p* nil)
  (start (make-instance 'hunchentoot:easy-acceptor
			      :port port
			      :document-root ".")))

(define-condition quit-condition (condition)
  ())

(defun awele (&optional (port 5050))
  (setf *game* (new-game))
  (setq *automatic* nil)
  (handler-case
      (start-acceptor port)
    (quit-condition (c)
      (declare (ignore c)))))

;;; In this version, we consider the house in the rightmost
;;; position on the top row to be house 0, and the number increases
;;; counter clockwise, so that to rigthmost house on the bottom row is
;;; house number 11.  
(defgeneric echo (object))

(defgeneric html-strategy-player (strategy-player))
(defmethod html-strategy-player ((strategy-player strategy-player))
  (with-html-output (*standard-output*)
    (str
     (format nil "~A (~A) to go"
	     (player-name (player strategy-player))
	     (strategy-name (strategy strategy-player))))))

(defun html-restart-button ()
  (with-html-output (*standard-output*)
    (:div :class "bouton" (:p (:a :href "/restart" "Restart")))))

(defun html-undo-button ()
  (with-html-output (*standard-output*)
    (:div :class "bouton" (:p (:a :href "/undo" "Undo")))))

(defun html-quit-button ()
  (with-html-output (*standard-output*)
    (:div :class "bouton" (:p (:a :href "/quit" "Quit")))))

(defun html-player-score (player houses)
  (with-html-output (*standard-output*)
    (format t "~A: ~A~%"
	    (player-name player)
	    (player-score player houses))
    (format t "<br>")))

(defun html-score (houses)
  (with-html-output (*standard-output*)
    (:b
     (html-player-score 0 houses)
     (html-player-score 1 houses))))

(defun html-game-over (result)
  (when result
    (if (playerp result)
	(format t "The winner is player ~A~%" result)
	(format t "The game is null~%"))
    (format t "<br>")))

(defgeneric active-p (player game))
(defmethod active-p ((player integer) (game game))
  (and (not (game-over game))
       (= player (current-player game))
       (interactive-p game)))

(defgeneric play-button-p (player game))
(defmethod play-button-p ((player integer) (game game))
  (and (not (game-over game))
       (= player (current-player game))
       (not (interactive-p game))
       (not (automatic-p))
       ))

(defun html-house-image (house)
  (with-html-output (*standard-output*)
    (:div :class "house"
	  (:p (str (format nil "~2D" (seed-count house)))))))

(defun html-clickable-house (house)
  (with-html-output (*standard-output*)
    (:a :href (format nil "house-click?n=~a" (house-number house))
	(html-house-image house))))

(defun html-house (player house-number houses active)
  (let ((house (nth-house house-number houses))
	(clickable
	  (and active
	       (valid-house-number-p player house-number houses))))
    (with-html-output (*standard-output* nil)
      (:td
       (if clickable
	   (html-clickable-house house)
	   (html-house-image house))))))

(defun html-play-button ()
  (with-html-output (*standard-output*)
    (:div :class "bouton" (:p (:a :href "/play" "Play")))))

(defun html-player-houses (player game)
  (let ((active (active-p player game)))
    (with-html-output (*standard-output*)
      (:tr
       (loop
	  for house-number in (player-house-numbers player)
	  do (html-house player house-number (game-houses game) active))
       (:td
	(when (play-button-p player game)
	  (html-play-button)))))))
;;  (format *error-output* "~A~%" game))

(defun html-br ()
  (with-html-output (*standard-output*)
    (:br)))

(defun html-houses (game)
  (with-html-output (*standard-output*)
    (:table :id "house-table"
     (loop for player from 0 to 1
	do (html-player-houses player game)))))

(defun html-menu ()
  (with-html-output (*standard-output*)
    (:nav
     (:ul
      (:li (:a :href "#" (str (strategy-player-string (nth-strategy-player 0 *game*))))
	   (:ul
	    (:li
	     (:a :href "strategy-choice?player=0&strategy-name=interactive" "Interactive")
	     (:a :href "strategy-choice?player=0&strategy-name=random" "Random")
	     )))
      (:li (:a :href "#" (str (strategy-player-string (nth-strategy-player 1 *game*))))
	   (:ul
	    (:li
	     (:a :href "strategy-choice?player=1&strategy-name=interactive" "Interactive")
	     (:a :href "strategy-choice?player=1&strategy-name=random" "Random")
	     )))
      (unless (interactive-p *game*)
	(with-html-output (*standard-output*)
	  (:li (:a :href "/automatic" (str (if (automatic-p) "Automatic (Manual)"  "Manual (Automatic)"))))))))))

(defmethod echo ((game game))
  (html-menu)
  (let ((game-over (game-over game)))
    (unless game-over
      (html-strategy-player (current-strategy-player game)))
    (html-houses game)
    (when (plusp (play-count game))
      (html-undo-button)
      (html-restart-button))
    (html-score (game-houses game))
    (html-game-over game-over)
    (html-quit-button)))

(defmacro page-template ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent nil)
     (:html :xmlns "http://www.w3.org/1999/xhtml" :xml\:lang "en" :lang "en"
            (:head (:meta :http-equiv "Content-Type" :content "text/html;charset=utf-8")
                   (:title (str ,title))
                   (:link :rel "stylesheet" :type "text/css" :href "/Web/awele.css"))
            (:body ,@body))))

(defgeneric play (game))
(defmethod play ((game game))
  (play-house game (next-valid-house-number game))
  (game-end game)
  (when (and (not (game-over game)) (automatic-step-p game))
    (play game)))

(defgeneric automatic-step-p (game))
(defmethod automatic-step-p ((game game))
  (and (not (interactive-p game)) (automatic-p)))

(defgeneric next-step (game))
(defmethod next-step ((game game))
  (assert (not (game-over game)))
  (unless (current-player-can-play game)
    (toggle-player game)))

(defgeneric play-house (game valid-house))
(defmethod play-house ((game game) (valid-house integer))
  (assert (member valid-house (player-house-numbers (current-player game))))
  (game-house-play game valid-house)
  (if (game-over game)
      (terminate-game game)
      (next-step game)))

;;; We serve URIs that end with "/awele" or "/house-click?n=N" where N is a
;;; small non-negative integer.  In the first case, the value of the
;;; parameter will be NIL and we then initialize a new game.  In the
;;; second case, we take it to mean that house number N was clicked on
;;; (this is how it is presented in the function SHOW-GAME above).
(hunchentoot:define-easy-handler (house-click-handler :uri "/house-click") (n)
  (if (null n)
      (init-game *game*)
      (progn 
	(format *error-output* "click-~A~%" *game*)
	(play-house *game* (read-from-string n))))
  (redirect "/awele"))

(hunchentoot:define-easy-handler (game-handler :uri "/awele") ()
  (page-template (:title "Awele")
    (when (automatic-step-p *game*)
      (play *game*))
    (echo *game*)))

(hunchentoot:define-easy-handler (quit-handler :uri "/quit") ()
  (signal 'quit-condition))

(hunchentoot:define-easy-handler (restart-handler :uri "/restart") ()
  (init-game *game*)
  (setq *automatic* nil)
  (redirect "/awele"))

(hunchentoot:define-easy-handler (undo-handler :uri "/undo") ()
  (game-undo *game*)
  (redirect "/awele"))

(hunchentoot:define-easy-handler (front-page :uri "/") ()
  (redirect "/restart"))

(hunchentoot:define-easy-handler (strategy-choice-handler :uri "/strategy-choice") (player strategy-name)
  (format *trace-output* "strategy-choice ~A ~A ~%" player strategy-name)
  (assign-strategy-from-name (nth-strategy-player (read-from-string player) *game*) strategy-name)
  (redirect "/awele"))

(hunchentoot:define-easy-handler (play-handler :uri "/play") ()
  (play *game*)
  (redirect "/awele"))

(hunchentoot:define-easy-handler (automatic-handler :uri "/automatic") ()
  (toggle-automatic)
  (redirect "/awele"))
