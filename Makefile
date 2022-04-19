
demo: manifest
	buildapp --manifest-file quicklisp-manifest.txt --load-system webapp-demo --load-system slynk --output demo --entry webapp-demo:main


manifest:
	sbcl --no-userinit --no-sysinit --non-interactive \
	     --load ~/quicklisp/setup.lisp \
	     --eval '(ql:quickload "webapp-demo")' \
	     --eval '(ql:write-asdf-manifest-file "quicklisp-manifest.txt")'

clean:
	echo "Cleaning build files"
	rm demo quicklisp-manifest.txt
