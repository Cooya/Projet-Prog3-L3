(in-package :awele)

(defvar *nb-games*)
(setf *nb-games* 5)

(defgeneric tournament-array (strategies))
(defmethod tournament-array  ((strategies vector))
  (loop
     with nb-strat = (length strategies)
     with results = (make-array (list nb-strat nb-strat))
     for i from 0 below nb-strat
     do (loop
	   for j from 0 below nb-strat
	   when (/= i j)
	   do (setf (aref results i j)
		    (server-games *nb-games*
				  :strategy0 (aref strategies i)
				  :strategy1 (aref strategies j))))
    finally (return results)))

(defmethod tournament-array  ((strategies list))
  (tournament-array (make-array (length strategies) :initial-contents strategies)))

(defun tournament-results (strategies array)
  (let* ((nb-strat (length strategies))
	 (res (make-array nb-strat)))
    (loop
       for i from 0 below nb-strat
       do (setf (aref res i) (make-array 3))) ;; 0: point, 1: victory, 2: draw
    (loop
       for i from 0 below nb-strat
       do (loop for j from 0 below i
	     do
	       (let ((statij (aref array i j))
		     (statji (aref array j i)))
		 (incf (aref (aref res i) 1) (nb-victory0 statij))
		 (incf (aref (aref res j) 1) (nb-victory1 statij))
		 (incf (aref (aref res i) 1) (nb-victory1 statji))
		 (incf (aref (aref res j) 1) (nb-victory0 statji))
		 (incf (aref (aref res i) 2) (nb-draw statij))
		 (incf (aref (aref res j) 2) (nb-draw statij))
		 (if (stat= statij statji)
		     (progn 
		       (incf (aref (aref res i) 0))
		       (incf (aref (aref res j) 0)))
		     (incf (aref (aref res (winner i j statij statji)) 0)))))
       finally (return res))))

(defun sort-results (strategies res)
    (loop
       for i from 0 below (length res)
       do (setf (aref res i) (cons (aref strategies i) (aref res i))))
    (nreverse (stable-sort res #'lexi< :key #'cdr)))

(defgeneric run-tournament (strategies))
(defmethod run-tournament ((strategies vector))
  (sort-results
   strategies
   (tournament-results
    strategies
    (tournament-array strategies))))

(defmethod run-tournament ((strategies list))
  (run-tournament
   (make-array (length strategies) :initial-contents strategies)))

(defun global-tournament (&optional (*nb-games* *nb-games*))
  (run-tournament (collect-strategies)))
