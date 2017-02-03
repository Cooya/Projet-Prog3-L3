(cl:in-package #:common-lisp-user)

(defpackage :awele-system
  (:use :asdf :common-lisp))

(in-package :awele-system)

(defparameter *awele-directory* (directory-namestring *load-truename*))
(format t "awele-directory is ~A ~%" *awele-directory*)

(asdf:defsystem :awele
  :depends-on (:hunchentoot)
  :serial t
  :components
  (
   (:file "package")
   (:file "general")
   (:file "strategy")
   (:file "player")
   (:file "house-number")
   (:file "house")
   (:file "houses")
   (:file "stat")
   (:file "strategy-player")
   (:file "strategies")
   (:file "standalone")
   (:file "game")
   (:file "run-game")
   (:file "games")
   (:file "interactive-strategy")
   (:file "random-strategy")
   (:file "smallest-strategy")
   (:file "gain")
   (:file "minmax")
   (:file "minmax-strategy")
   (:file "awele")
   (:file "standalone-strategy")
   (:file "Server/file-path")
   (:file "Server/player-strategy")
   (:file "Server/server")
   (:file "Server/lexi")
   (:file "Server/tournament")
   ))

(pushnew :awele *features*)
