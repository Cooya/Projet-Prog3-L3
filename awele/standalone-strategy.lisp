(in-package :awele)

(defvar *time-out*)
(setf *time-out* 1)

(defvar *previous-house-number* nil)

(defmethod player-standalone ((player integer))
  (let*
      ((timeout (list nil))
       (exceptionp nil)
       (thread
	 (sb-thread::make-thread
	  (lambda (*previous-house-number* *standard-output*)
	    (let ((*standard-output* *standard-output*))
	      (handler-case 
		  (player-main-standalone player *previous-house-number*)
		(condition (c)
		  (setq exceptionp t)
		  (format t "Player~A raised ~S~%" player c)))))
	  :name "Player"
	  :arguments (list *previous-house-number* *standard-output*)))
       (result
	 (sb-thread::join-thread
	  thread
	  :timeout *time-out* :default timeout)))
    (if exceptionp
	(signal 'player-error :error-string "crashed")
	(if (eq result timeout)
	    (signal 'player-error :error-string "too slow")
	    result))))

(defgeneric standalone-fun (game))
(defmethod standalone-fun ((game game))
  (setf *previous-house-number* (player-standalone (current-player game))))

(defvar *standalone-strategy*
  (make-strategy "Standalone" #'standalone-fun))

(add-strategy *standalone-strategy*)
