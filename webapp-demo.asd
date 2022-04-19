;;;; webapp-demo.asd

(asdf:defsystem #:webapp-demo
  :description "Describe webapp-demo here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchentoot
               #:cl-json
               #:djula)
  :components ((:file "package")
               (:file "webapp-demo")))
