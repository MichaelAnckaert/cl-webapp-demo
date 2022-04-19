;;;; webapp-demo.lisp

(in-package #:webapp-demo)

(defparameter *server* nil)

(defun start-web-server (port)
  (setf *server* (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))

(defun stop-web-server ()
  (hunchentoot:stop *server*))


(defmacro add-route (route-url (&key (content-type "text/html")) &body body)
  "Add a route with the given url to the dispatcher"
  (let ((route-handler-name (gensym)))
    `(progn (defun ,route-handler-name ()
              (setf (hunchentoot:content-type*) ,content-type)
              ,@body)
            (push
             (hunchentoot:create-prefix-dispatcher ,route-url ',route-handler-name)
             hunchentoot:*dispatch-table*))))


(defmacro render-to-template (template-filename &rest variables)
  `(with-output-to-string (s)
     (let ((template-name (intern ,template-filename)))
       (defparameter template-name (djula:compile-template* ,template-filename))
       (djula:render-template* template-name s ,@variables))))


(defun request-get (name &optional (default nil))
  (or (hunchentoot:get-parameter name)
      default))


(defun main (argv)
  (setup-routes)
  (start-web-server 5050)
  (sb-thread:join-thread (find-if
                          (lambda (th)
                            (search "hunchentoot-listener" (sb-thread:thread-name th))))


;;; Sample usages
(add-route "/my-route" ()
  (format nil "Hello, this is my-route"))

(add-route "/hello" (:content-type "text/plain") ()
  (let ((name (request-get "name" "anonymous")))
    (format nil "Hello, ~a" name)))

(add-route "/data" (:content-type "text/json") ()
  (let ((response (json:encode-json-to-string '#( ((ids . (1 2 3)) (bar . t))))))
    (format nil response)))

(add-route "/hello-templated" ()
  (let ((name (request-get "name" "Anonymous"))
        (age (request-get "age" "37"))
        (country (request-get "country" "the world")))
    (render-to-template "hello.html" :name name :age age :country country)))
