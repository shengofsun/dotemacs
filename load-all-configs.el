(let ((package (list 
		"config-basic.el"
		"config-lisp.el"
		"config-autocomplete.el")))
  (dolist (package-file package)
    (load package-file)))
