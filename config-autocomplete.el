;; auto-completion
(add-to-list 'load-path (concat my-config-path "/thirdparty/auto-complete"))
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat my-config-path "/thirdparty/auto-complete/ac-dict"))
(ac-config-default)

