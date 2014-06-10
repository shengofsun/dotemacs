;; basic settings
(custom-set-variables
 '(tool-bar-mode nil)
 '(scroll-bar-mode nil))

;; parenthesis setting
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)

(ido-mode)
(setq make-backup-files nil)

(setq ring-bell-function 'ignore) ; close ringbell warning of emacs

(setq frame-title-format "minsky-pc@%b") ;; title in one frame
(setq inhibit-startup-message t) ;;close emacs init window
(setq gnus-inhibit-startup-message t) ;;close gnu init window
(setq-default kill-whole-line t) ;;When using 'Ctrl-k', kill whole line 

;; ediff setting
(setq ediff-split-window-function 'split-window-horizontally)

;; font setting, including English fonts and Chinese Fonts
(set-frame-font "Monaco-11")
(if window-system
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
			charset
			(font-spec :family "Microsoft Yahei" :size 15)))
  nil)

; conding indents
(setq c-default-style '((java-mode . "java")
			(awk-mode . "awk")
			(other . "stroustrup")))
(defun my-c-mode-common-hook()
  (setq indent-tabs-mode nil
        c-basic-offset 4
        tab-width 4))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

; dired
(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")
	    (setq dired-omit-files
		  (concat dired-omit-files "\\|^\\..+$"))))
(add-hook 'dired-mode-hook
	  (lambda ()
	    (dired-omit-mode 1)))

;;find the file which name is around the point.
(defun find-file-around-point()
  (interactive)
  (let ((filename (current-word t)))
    (if (file-exists-p filename)
	(find-file filename)
      (message "File not exist!"))))

;;key binding
(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key "\C-cc" 'compile)
(global-set-key "\C-c." 'find-file-around-point)

;; color-theme
(add-to-list 'load-path (concat my-config-path "/thirdparty/color-theme"))
(require 'color-theme)

(if window-system
    (load-file "deepblue-color-theme.el")
  (load-file "hobor-color-theme.el"))
(my-color-theme)
