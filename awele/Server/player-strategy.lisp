(in-package :awele)

(defgeneric player-package-name (player strategy-name)
  (:documentation "name of the package of PLAYER playing with STRATEGY-NAME"))

(defmethod player-package-name ((player integer) (strategy-name string))
  (string-upcase (player-strategy-string player strategy-name)))

(defgeneric player-package-symbol (player strategy-name))
(defmethod player-package-symbol ((player integer) (strategy-name string))
  (intern
   (player-package-name player strategy-name)
   :keyword))

(defgeneric make-player-package (player strategy-name))
(defmethod make-player-package ((player integer) (strategy-name string))
  (let* ((package-name (player-package-name player strategy-name))
	 (package (find-package package-name)))
    (when package
      (delete-package package))
    (make-package
     package-name
     :use '(#:common-lisp))))

(defgeneric player-package (player strategy-name))
(defmethod player-package ((player integer) (strategy-name string))
  (find-package (player-package-symbol player strategy-name)))

;; (defpackage #:server (:use #:common-lisp #:awele))
;; (in-package #:server)

;;; Compiling
(defgeneric make-strategy-filename (strategy-name extension))
(defmethod make-strategy-filename ((strategy-name string) (extension string))
  (format nil "~A~A.~A" *projects-directory* strategy-name extension))

(defgeneric make-strategy-source-filename (strategy-name))
(defmethod make-strategy-source-filename ((strategy-name string))
  (format nil "~A/~A.lisp" *projects-directory* strategy-name))

(defgeneric make-strategy-object-filename (player strategy-name))
(defmethod make-strategy-object-filename ((player integer) (strategy-name string))
  (format
   nil "~A/~A.fasl"
   (objects-directory)
   (string-downcase
    (player-package-name player strategy-name))))

(defgeneric compile-player-strategy  (player strategy-name))
(defmethod compile-player-strategy  ((player integer) (strategy-name string))
  (let ((*package* (make-player-package player strategy-name)))
    (compile-file
     (make-strategy-source-filename strategy-name)
     :output-file (make-strategy-object-filename player strategy-name))))

(defun compile-strategy (strategy-name)
  (compile-player-strategy 0 strategy-name)
  (compile-player-strategy 1 strategy-name))

(defun compile-strategies (strategy-names)
  (loop
    for strategy-name in strategy-names
    do (compile-strategy strategy-name)))

(defun compile-all-strategies ()
  (compile-strategies (collect-strategies)))

;;; Loading
(defgeneric player-strategy-load (player strategy-name))
(defmethod player-strategy-load ((player integer) (strategy-name string))
  (let ((object (make-strategy-object-filename player strategy-name)))
    ;;    (let ((*package* (player-package player strategy-name)))
    (load object)))
