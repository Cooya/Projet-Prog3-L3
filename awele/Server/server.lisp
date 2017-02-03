(in-package :awele)

(defvar *playing-strategies* (make-array 2))

(defun setup-player-strategy (player strategy)
  (when strategy
    (setf (aref *playing-strategies* player) strategy)
    (player-strategy-load player strategy)))

(defun server-load-code (strategy0 strategy1)
  (setup-player-strategy 0 strategy0)
  (setup-player-strategy 1 strategy1))

;;; Playing
(defgeneric find-player-symbol (symbol-name player))
(defmethod find-player-symbol
    (symbol-name (player integer))
  (find-symbol
   symbol-name
   (player-package
    player (aref *playing-strategies* player))))

(defgeneric player-main-standalone (player previous-house-number))
(defmethod player-main-standalone
    ((player integer) previous-house-number)
  (when *trace*
    (format *standard-output* "Playing P~A[~A] ~%" player (player-score player (game-houses  *game*)))
    (show-player-houses *game* *standard-output*))
  (let ((play
	 (funcall
	  (find-player-symbol "MAIN-STANDALONE" player)
	  previous-house-number)))
    (when *trace*
      (format *standard-output* "P~A played in ~A~%" player play))
    play))

(defgeneric player-init-standalone (player))
(defmethod player-init-standalone ((player integer))
  (funcall
   (find-player-symbol
    "INIT-STANDALONE" player)
   (zerop player)))

(defun server-play (game)
  (let ((*server-game* t)
	(*previous-house-number* nil))
    (player-init-standalone 0)
    (player-init-standalone 1)
    (run-game game)))

(defun server-game (&key (strategy0 nil)  (strategy1 nil))
  (server-load-code strategy0 strategy1)
  (let ((game (make-game *standalone-strategy* *standalone-strategy*)))
    (setq *game* game)
    (server-play game)))

(defun server-games (n &key (strategy0 nil)  (strategy1 nil))
  (server-load-code strategy0 strategy1)
  (let ((game (make-game *standalone-strategy* *standalone-strategy*))
	(*one-game* nil)
	(*interactive* nil))
    (setq *game* game)
    (loop
      repeat n
      do (server-play game))
    (game-stat game)))
