(cl:in-package #:common-lisp-user)

(asdf:defsystem :gui-awele
  :depends-on (:hunchentoot :awele :cl-who)
  :serial t
  :components
  ((:file "package-gui")
   (:file "gui-awele")
   ))
