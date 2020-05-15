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
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; ediff setting
(setq ediff-split-window-function 'split-window-horizontally)

;; font setting, including English fonts and Chinese Fonts
(set-frame-font "Monaco-14")
(if window-system
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
			charset
			(font-spec :family "Microsoft Yahei" :size 15)))
  nil)

;; conding indents
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(load "google-c-style.el")
(add-hook 'c-mode-common-hook 'google-set-c-style)

(defun my-sh-mode-hook()
  (setq sh-basic-offset 4))
(add-hook 'sh-mode-hook 'my-sh-mode-hook)

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
(global-set-key "\C-c." 'find-file-around-point)

;; file name handle for c++
(defun reverse-ext (ext)
  (cond ((string= ext ".h") ".cc")
        ((string= ext ".cc") ".h")
        (t nil)))

(defun last-char (str char)
  (defun last-char-inner (pos)
    (if (< pos 0)
        pos
      (if (= (elt str pos) char)
          pos
        (last-char-inner (- pos 1)))))
  (last-char-inner (- (length str) 1)))

(defun filename-non-ext (filename)
  (let ((pos (last-char filename ?.)))
    (if (< pos 0)
        filename
      (substring filename 0 pos))))

(defun filename-ext (filename)
  (let ((pos (last-char filename ?.)))
    (if (< pos 0)
        nil
      (substring filename pos))))

;; xxx.h->xxx.cc or xxx.cc->xxx.h, must be at same directory
(defun get-related-filename (filename)
  (let ((pos (last-char filename ?.)))
    (if (= pos -1)
        nil
      (concat (substring filename 0 pos) (reverse-ext (substring filename pos))))))

(defun go-related-file ()
  (interactive)
  (let* ((dir-part (file-name-directory buffer-file-name))
         (base-part (file-name-nondirectory buffer-file-name))
         (rev (get-related-filename base-part))
         (rev-fullpath (concat dir-part "/" rev)))
    (if (file-exists-p rev-fullpath)
        (find-file rev-fullpath)
      (message (concat "File not exist!: " rev-fullpath)))))
(global-set-key "\C-cr" 'go-related-file)

;; xxx_test.cc->xxx.cc, or xxx.h/xxx.cc->xxx_test.cc, must be at same directory
(defun get-test-related-filename (filename)
  (defun test-file? (name)
    (and (> (length name) 5)
         (string= (substring name -5 nil)
                  "_test")))
  (let ((non-ext (filename-non-ext filename)))
    (if (test-file? non-ext)
        (concat (substring non-ext 0 -5) ".cc")
      (concat non-ext "_test.cc"))))

(defun go-test-related-file ()
  (interactive)
  (let* ((dir-part (file-name-directory buffer-file-name))
         (base-part (file-name-nondirectory buffer-file-name))
         (related-test (get-test-related-filename base-part))
         (r-fullpath (concat dir-part "/" related-test)))
    (if (file-exists-p r-fullpath)
        (find-file r-fullpath)
      (message (concat "File not exist!: " r-fullpath)))))
(global-set-key "\C-ct" 'go-test-related-file)

(if window-system
    nil
  (setq linum-format "%4d \u2502 "))
(global-linum-mode)

;;key binding
(global-set-key "\C-x\C-b" 'ibuffer)
(global-set-key "\C-cc" 'compile)
(global-set-key "\C-cp" 'replace-string)
(global-set-key "\C-cq" 'query-replace)
(global-set-key "\C-cg" 'goto-line)

;; visit tags
(global-set-key "\M-*" 'pop-tag-mark)

;; color-theme
(add-to-list 'load-path (concat my-config-path "/thirdparty/color-theme"))
(require 'color-theme)
(when window-system
  (load "classical-color-theme.el")
  (my-color-theme))

(add-to-list 'load-path (concat my-config-path "/thirdparty/neotree"))
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; lua-mode
(add-to-list 'load-path "~/source/lua-mode")
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;; el-get mode
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;; jedi mode
(setq exec-path (append exec-path '("/usr/local/bin")))
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
