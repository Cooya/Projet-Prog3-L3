(in-package :awele)
(defvar *projects-relative-directory*)
(setf *projects-relative-directory* "Strategies")
(defvar *projects-directory*)

(defun default-directory ()
  "The default directory."
  (truename "."))

(defun projects-directory ()
  (concatenate 'string
	       (namestring 
;;		(default-directory)
		awele-system::*awele-directory*)
	       *projects-relative-directory*))
  
(setf *projects-directory* (projects-directory))

(defun objects-directory ()
  (format nil "~A/~A" (projects-directory) "Objects"))

(defun collect-strategies ()
  (loop
     for strategy-name in (directory (format nil "~A/*.lisp" *projects-directory*))
     collect (pathname-name strategy-name)))
