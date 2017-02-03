(in-package :serveur)

(defun joueur1 ()
 (write-line "thread1"))

(defun joueur2 ()
 (write-line "thread2"))

(defun main ()
  (let ((thread1 (make-thread #'joueur1))
	(thread2 (make-thread #'joueur2)))
    (print thread1)
    (print thread2)))
	
;; (eval-when (:compile-toplevel :load-toplevel :execute)
;;   (require :sb-bsd-sockets)
;;   (require :sb-posix))

;; (defvar *survive-fork-p* nil
;;   "A functional semipredicate to determine if this thread will continue in the child of a fork.")

;; (defvar *after-fork-parent-hook* ())
;; (defvar *after-fork-child-hook* ())

;; (defun call-hook (hook)
;;   (if (listp hook)
;;       (mapc #'funcall hook)
;;       (funcall hook))
;;   nil)

;; (defun eval-semipred (semi)
;;   "Evaluate a functional semipredicate.  A functional semipredicate
;; can be NIL to indicate false, any non-function true value to indicate
;; true, or a function which will be called with no arguments, which will
;; evaluate to a functional semipredicate."
;;   (cond
;;     ((null semi) nil)
;;     ((functionp semi) (eval-semipred (funcall semi)))
;;     (t t)))

;; (declaim (inline posix-open posix-dup2 posix-close))
;; (defun posix-open (path oflag mode)
;;   (sb-posix:open path oflag mode))
;; (defun posix-dup2 (source-fd dest-fd)
;;   (sb-posix:dup2 source-fd dest-fd))
;; (defun posix-close (fd)
;;   (sb-posix:close fd))
;; (defconstant +o-rdonly+ sb-posix:o-rdonly)
;; (defconstant +o-wronly+ sb-posix:o-wronly)
;; (defconstant +o-rdwr+ sb-posix:o-rdwr)
;; (defconstant +o-append+ sb-posix:o-append)
;; (defconstant +o-creat+ sb-posix:o-creat)

;; (defun fork (&key (input "/dev/null") (output "/dev/null") (error "/dev/null"))
;;   (labels ((as-fd (spec direction)
;;              (if (typep spec '(integer 0))
;;                  spec
;;                  (posix-open spec
;;                              (ecase direction
;;                                (:input +o-rdonly+)
;;                                (:output (logior +o-creat+ +o-wronly+ +o-append+)))
;;                              0)))
;;            (child (in out err)
;;              (posix-dup2 in 0)
;;              (posix-dup2 out 1)
;;              (posix-dup2 err 2)
;; 	     nil
;; 	     )
;;            (parent (in out err)
;;              (posix-close in)
;;              (posix-close out)
;;              (posix-close err)
;;              (call-hook *after-fork-parent-hook*))
;; 	   (really-fork ()
;; 	     (sb-posix:fork)))
;;     (let ((in (as-fd input :input))
;;           (out (as-fd output :output))
;;           (err (as-fd error :output)))
;;       (let ((child (really-fork)))
;;         (if (zerop child)
;;             (child in out err)
;;             (parent in out err))
;;         child))))

;; (defun disconnect-slime ()
;;   (when (find-package "SWANK")
;;     (let ((close (find-symbol "CLOSE-CONNECTION" "SWANK"))
;; 	  (connections (find-symbol "*CONNECTIONS*" "SWANK")))
;;       (mapc (symbol-function close) (symbol-value connections)))))

;; (pushnew 'disconnect-slime *after-fork-child-hook*)

;; ;; (defun main ()
;; ;;   (let ((pid (sb-posix:fork)))
;; ;;     (cond
;; ;;       ((= 0 pid) ;; child
;; ;;        (format t " child") (sb-posix::exit 0))
;; ;;       ((> 0 pid) ;; parent
;; ;;        (format t "parent") (sb-posix::exit 1))
;; ;;       (t (error "unable to fork")))))
       
	
