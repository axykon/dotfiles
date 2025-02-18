(setq custom-file "~/.emacs.d/custom.el")

(setq ring-bell-function 'ignore)

;; Disable compilation warnings
(setq native-comp-async-report-warnings-errors nil)

;; Backup and autosave
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))
(setq version-control t)
(setq delete-old-versions t)
(setq auto-save-list-file-prefix "~/.emacs.d/autosave/")
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/autosave/" t)))

;; (setq completions-format 'one-column)
;; (setq completion-auto-help 'always)
;; (setq completions-header-format nil)
;; (setq completions-max-height 20)
;; (setq completion-auto-select 'second-tab)
;; (define-key minibuffer-mode-map (kbd "C-n") 'minibuffer-next-completion)
;; (define-key minibuffer-mode-map (kbd "C-p") 'minibuffer-previous-completion)
;; (define-key completion-in-region-mode-map (kbd "C-n") 'minibuffer-next-completion)
;; (define-key completion-in-region-mode-map (kbd "C-p") 'minibuffer-previous-completion)

(set-frame-font "JetBrains Mono-12")

;; In WSL2 use browsers installed as windows programms
;; TODO: override other browser programms
(when (getenv "WSL_DISTRO_NAME")
  ;; (setopt browse-url-firefox-program "firefox.exe")
  (setopt browse-url-chrome-program "/mnt/c/Users/akravtsov/AppData/Local/Google/Chrome/Application/chrome.exe"))

(setq treesit-language-source-alist
	  '(
		(bash "https://github.com/tree-sitter/tree-sitter-bash")
		(c "https://github.com/tree-sitter/tree-sitter-c")
		(cpp "https://github.com/tree-sitter/tree-sitter-cpp")
		(css "https://github.com/tree-sitter/tree-sitter-css")
		(docker "https://github.com/camdencheek/tree-sitter-dockerfile")
		(go "https://github.com/tree-sitter/tree-sitter-go")
		(gomod "https://github.com/camdencheek/tree-sitter-go-mod" "main" "src")
		(html "https://github.com/tree-sitter/tree-sitter-html")
		(java "https://github.com/tree-sitter/tree-sitter-java")
		(javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
		(json "https://github.com/tree-sitter/tree-sitter-json")
		(markdown "https://github.com/ikatyang/tree-sitter-markdown")
		(rust "https://github.com/tree-sitter/tree-sitter-rust")
		(svelte "https://github.com/Himujjal/tree-sitter-svelte")
		(toml "https://github.com/tree-sitter/tree-sitter-toml")
		(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
		(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
		(yaml "https://github.com/ikatyang/tree-sitter-yaml")
		))

(setq treesit-load-name-override-list
	  '((dockerfile "libtree-sitter-docker" "tree_sitter_dockerfile")))

(setq major-mode-remap-alist
      '((java-mode . java-ts-mode)
	    (javascript-mode . js-ts-mode)))

(require 'package)
(setq use-package-compute-statistics t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities
      '(("gnu" . 30)
        ("nongnu" . 20)
        ("melpa" . 10)))
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

(setopt indent-tabs-mode nil)
(setopt tab-width 4)

(use-package tab-bar
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-hints t)
  (tab-bar-select-tab-modifiers '(control)))

(use-package vterm
  :disabled
  :ensure
  :config
  (setq vterm-timer-delay 0.01))

(use-package orderless
  :ensure
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin :no-confirm))

(use-package vertico
  :ensure
  :custom
  (vertico-sort-function nil)
  :config
  (vertico-mode))

(use-package consult
  :ensure
  :bind
  ([remap imenu] . consult-imenu)
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))

(use-package marginalia
  :ensure
  :config
  (marginalia-mode))

(use-package project-mode-line-tag
  :ensure
  :config
  (project-mode-line-tag-mode 1))

(use-package rainbow-delimiters
  :ensure
  :config
  (rainbow-delimiters-mode 1))

(use-package go-ts-mode
  :custom
  (go-ts-mode-indent-offset 4)
  :config
  (display-line-numbers-mode))

(use-package tab-bar
  :custom
  (tab-bar-close-button-show nil))

(use-package surround
  :ensure t
  :bind-keymap ("M-'" . surround-keymap))
  
(use-package yaml-ts-mode)
(use-package json-ts-mode)
(use-package java-ts-mode)
(use-package js-ts-mode
  :bind
  ([remap js-find-symbol] . xref-find-definitions)
  :mode
  ("\\.[m]?js\\'")
  :custom
  (js-indent-level 2))

(use-package typescript-ts-mode)

(use-package corfu
  :ensure
  :custom
  (corfu-auto t)
  :hook
  (prog-mode . corfu-mode))

(use-package corfu-terminal
  :ensure
  :unless
  (or (display-graphic-p) (featurep 'tty-child-frames))
  :hook
  (corfu-mode . corfu-terminal-mode))

(use-package vertico
  :ensure)

(use-package markdown-mode
  :defer t
  :ensure)

(use-package yasnippet
  :ensure t)

(use-package eglot
  :defer t
  :bind
  (:map eglot-mode-map
        ("C-c l r" . eglot-reconnect)
		("C-c l a" . eglot-code-actions)
		("C-c l i" . eglot-code-action-organize-imports)
		("C-c l f" . eglot-format-buffer))
  :custom
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  :hook
  ((go-ts-mode . eglot-ensure)
   (js-ts-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
			   `((java-mode java-ts-mode) .
				 (
				  ,(expand-file-name "~/.local/lib/jvm/jdtls/bin/jdtls")
				  "-data" ,(expand-file-name "cache/java-workspace" user-emacs-directory)
				  ,(concat "--jvm-arg=-javaagent:" (expand-file-name "~/.m2/repository/org/projectlombok/lombok/1.18.34/lombok-1.18.34.jar"))
				  :initializationOptions
				  (:autobuild (:enabled t)
							  :contentProvider (:preferred "fernflower")
							  :extendedClientCapabilities (:classFileContentsSupport t)))))
  
  (setq-default eglot-workspace-configuration
				'((:gopls .
						  ((staticcheck . t)
						   (usePlaceholders . t)
						   (matcher . "Fuzzy"))))))


(use-package eglot-booster
  :vc (:fetcher github :repo jdtsmith/eglot-booster)
  :after eglot
  :config
  (eglot-booster-mode))

(use-package consult-eglot
  :ensure
  :defer t)

;; (setq eglot-java-user-init-opts-fn 'custom-eglot-java-init-opts)
;; (defun custom-eglot-java-init-opts (server eglot-java-eclipse-jdt)
;;   "Custom options that will be merged with any default settings."
;;   '(:settings
;;     (:java
;;      (:format
;;       (:settings
;;        (:url "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
;;        :enabled t)))))
;; (use-package eglot-java-mode
;;   :defer t
;;   ;; :hook
;;   ;; (java-ts-mode)
;;   )

(use-package lspce
  :disabled
  :config (progn
            (setq lspce-send-changes-idle-time 0.1)
            (setq lspce-show-log-level-in-modeline t) ;; show log level in mode line

            ;; You should call this first if you want lspce to write logs
            (lspce-set-log-file "/tmp/lspce.log")

            ;; By default, lspce will not write log out to anywhere. 
            ;; To enable logging, you can add the following line
            ;; (lspce-enable-logging)
            ;; You can enable/disable logging on the fly by calling `lspce-enable-logging' or `lspce-disable-logging'.

            ;; enable lspce in particular buffers
            ;; (add-hook 'rust-mode-hook 'lspce-mode)

            ;; modify `lspce-server-programs' to add or change a lsp server, see document
            ;; of `lspce-lsp-type-function' to understand how to get buffer's lsp type.
            ;; Bellow is what I use
            (setq lspce-server-programs `(("rust"  "rust-analyzer" "" lspce-ra-initializationOptions)
                                          ("python" "pylsp" "" )
										  ("go" "gopls")
                                          ;; ("C" "clangd" "--all-scopes-completion --clang-tidy --enable-config --header-insertion-decorators=0")
                                          ;; ("java" "java" lspce-jdtls-cmd-args lspce-jdtls-initializationOptions)
                                          ))
            )
  )

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

(use-package denote
  :ensure
  :custom
  (denote-prompts '(title))
  :hook
  (dired-mode . denote-dired-mode))

(use-package nerd-icons
  :config
  (add-to-list 'nerd-icons-mode-icon-alist
			   '(go-ts-mode nerd-icons-sucicon "nf-seti-go2" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-extension-icon-alist
			   '("go" nerd-icons-sucicon "nf-seti-go2" :face nerd-icons-blue)))

(use-package vundo
  :ensure)

(use-package doom-themes
  :ensure
  :defer)

(use-package indent-bars
  :vc (:fetcher github :repo jdtsmith/indent-bars)
  :defer t
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-no-descend-string t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  (indent-bars-width-frac 0.1)
  :hook
  (yaml-ts-mode . (lambda ()
					(setq-local indent-bars-spacing-override 2)
					(indent-bars-mode))))

(use-package magit
  :ensure
  :defer t)

(use-package git-link
  :ensure
  :defer t)

;; (use-package yaml-pro
;;   :ensure
;;   :defer t
;;   :hook
;;   :disabled
;;   (yaml-ts-mode . yaml-pro-ts-mode))

(use-package web-mode
  :ensure
  :mode "\\.tpl\\'"
  :custom
  (web-mode-engines-alist
   '(("go" . "\\.tpl\\'"))))

(use-package uniline
  :defer t)

(use-package unfill
  :ensure)

(use-package autorevert
  :custom
  (auto-revert-check-vc-info t)
  (auto-revert-use-notify t)
  :config
  (global-auto-revert-mode))

;; Org
(use-package org
  ;;  :pin gnu
  ;; :ensure t
  :defer t
  ;; :init
  ;; (require 'org-tempo)
  ;; (setenv "NODE_PATH"
  ;;         (concat (getenv "HOME") "/.emacs.d/node_modules"  ":"
  ;;                 (getenv "NODE_PATH")))
  :custom
  (org-agenda-files '("~/org/todo.org"))
  :config
  (setq org-src-fontify-natively t
        org-hide-emphasis-markers t
        org-plantuml-jar-path "~/.local/lib/java/plantuml.jar"
        org-babel-min-lines-for-block-output 2
        org-babel-results-keyword "results"
        org-babel-python-command "python3"
        org-log-done 'time)
  (require 'org-tempo)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (plantuml .t)
     (dot .t)
     (sql .t)
     (js . t)))
  ; (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  :bind ("C-c DEL" . org-agenda))


(use-package dired
  :after denote
  :config
  (setq dired-dwim-target t)
  :custom
  (dired-listing-switches "-alh")
  :hook
  (dired-mode . dired-omit-mode))

(use-package ediff
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain))

(use-package flymake :ensure nil
  :custom
  (flymake-indicator-type 'margins)
  (flymake-margin-indicators-string
   `((error ,(nerd-icons-faicon "nf-fa-remove_sign") compilation-error)
     (warning ,(nerd-icons-faicon "nf-fa-warning") compilation-warning)
     (note ,(nerd-icons-faicon "nf-fa-circle_info") compilation-info))))

(use-package eglot)

(use-package eldoc
  :custom
  (eldoc-idle-delay 0.1)
  (eldoc-echo-area-use-multiline-p nil))

(use-package compile
  :custom
  (compilation-scroll-output t))

;; (use-package combobulate
;;   :preface
;;   ;; You can customize Combobulate's key prefix here.
;;   ;; Note that you may have to restart Emacs for this to take effect!
;;   (setq combobulate-key-prefix "C-c o")

;;   ;; Optional, but recommended.
;;   ;;
;;   ;; You can manually enable Combobulate with `M-x
;;   ;; combobulate-mode'.
;;   :hook ((python-ts-mode . combobulate-mode)
;;          (js-ts-mode . combobulate-mode)
;;          (css-ts-mode . combobulate-mode)
;;          ;;(yaml-ts-mode . combobulate-mode)
;;          (json-ts-mode . combobulate-mode)
;;          (typescript-ts-mode . combobulate-mode)
;;          (tsx-ts-mode . combobulate-mode))
;;   ;; Amend this to the directory where you keep Combobulate's source
;;   ;; code.
;;   :load-path ("~/pro/ext/combobulate"))

;; Custom functions
(defun ak/show-buffer-file-name ()
  "Prints the current buffer's file name"
  (interactive)
  (if (buffer-file-name)
      (message (buffer-file-name))
    (message "no file for this buffer")))

(require 'thingatpt)
(defun ak/word-definition ()
  "Looks up the definition of the word under cursor"
  (interactive)
  (let ((word (thing-at-point 'word)))
    (browse-url (format "https://www.merriam-webster.com/dictionary/%s" word))))
(global-set-key (kbd "C-c *") 'ak/word-definition)

;; https://www.emacswiki.org/emacs/NxmlMode
(defun nxml-where ()
  "Display the hierarchy of XML elements the point is on as a path."
  (interactive)
  (let ((path nil))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (< (point-min) (point)) ;; Doesn't error if point is at beginning of buffer
                    (condition-case nil
                        (progn
                          (nxml-backward-up-element) ; always returns nil
                          t)
                      (error nil)))
          (setq path (cons (xmltok-start-tag-local-name) path)))
        (if (called-interactively-p t)
            (message "/%s" (mapconcat 'identity path "/"))
          (format "/%s" (mapconcat 'identity path "/")))))))

(defun k8s-select-pod ()
  (let ((pod-list (split-string (shell-command-to-string "kubectl -n local get pods -o jsonpath='{.items[*].metadata.name}'"))))
    (completing-read "Select Pod: " pod-list)))

(defun k8s-log ()
  (interactive)
  (let* ((pod (k8s-select-pod))
         (process-name (format "k8s-log-%s" pod))
         (buffer-name (format "*k8s-log-%s*" pod)))
    (unless (get-buffer buffer-name)
      (progn
        (start-process process-name buffer-name "kubectl" "-n" "local" "logs" "-f" "--tail" "100" pod)
        (set-buffer buffer-name)
        (view-mode t)
        (hl-line-mode)
        (toggle-truncate-lines nil)))
    (switch-to-buffer buffer-name)))

;; https://justinchips.medium.com/have-vim-emacs-tmux-use-system-clipboard-4c9d901eef40
(defun yank-to-clipboard ()
  "Use ANSI OSC 52 escape sequence to attempt clipboard copy"
  ;; https://sunaku.github.io/tmux-yank-osc52.html
  (interactive)
  (let ((tmx_tty (shell-command-to-string "tmux display-message -p '#{client_tty}'"))
        (base64_text (base64-encode-string (encode-coding-string (substring-no-properties (nth 0 kill-ring)) 'utf-8) t)))
    ;; Check if inside TMUX
    (if (getenv "TMUX")
        (shell-command
         (format "printf \"\033]52;c;%s\a\" > %s" base64_text tmx_tty))
      ;; Check if inside SSH
      (if (getenv "SSH_TTY")
          (shell-command (format "printf \"\033]52;c;%s\a\" > %s" base64_text (getenv "SSH_TTY")))
        ;; Send to current TTY
        (send-string-to-terminal (format "\033]52;c;%s\a" base64_text))))))

;; Load custom file if exists
(if (file-readable-p custom-file)
    (load-file custom-file))
(put 'narrow-to-region 'disabled nil)


(defun ak/open-hover-link (pos)
  (interactive "d")
  (let ((link (get-text-property pos 'help-echo)))
    (if link
        (browse-url link))))

(global-set-key (kbd "C-c C-o") 'ak/open-hover-link)

(add-hook 'window-configuration-change-hook
          (lambda ()
            (unless (display-graphic-p)
              (let ((display-table (or buffer-display-table
                                       standard-display-table)))
                (set-display-table-slot display-table 'vertical-border ?│)))))

(defun ak/jdt-file-name-handler (operation &rest args)
  "Support Eclipse jdtls `jdt://' uri scheme."
  (let* ((uri (car args))
         (cache-dir "/tmp/.eglot")
         (source-file
          (expand-file-name
           (file-name-concat
            cache-dir
            (save-match-data
              (when (string-match "jdt://contents/\\(.*?\\)/\\(.*\\)\.class\\?" uri)
                (format "%s.java" (replace-regexp-in-string "/" "." (match-string 2 uri) t t))))))))
    (unless (file-readable-p source-file)
      (let ((content (jsonrpc-request (eglot-current-server) :java/classFileContents (list :uri uri)))
            (metadata-file (format "%s.%s.metadata"
                                   (file-name-directory source-file)
                                   (file-name-base source-file))))
        (unless (file-directory-p cache-dir) (make-directory cache-dir t))
        (with-temp-file source-file (insert content))
        (with-temp-file metadata-file (insert uri))))
    source-file))
(add-to-list 'file-name-handler-alist '("\\`jdt://" . ak/jdt-file-name-handler))

(add-to-list 'load-path "~/.emacs.d/local")
(require 'google-java-format)
(setopt google-java-format-executable "~/.local/bin/google-java-format")
