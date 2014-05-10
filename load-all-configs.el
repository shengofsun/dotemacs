(add-to-list 'load-path (concat my-config-path "/" "thirdparty"))

(let ((package (list 
		"config-basic.el"
		"config-lisp.el"
		"config-autocomplete.el"
		"config-markdown.el")))
  (dolist (package-file package)
    (load package-file)))
