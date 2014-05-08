(let ((package (list 
		"config-basic.el"
		"config-scheme.el"
		"config-autocomplete.el")))
  (dolist (package-file package)
    (load package-file)))
