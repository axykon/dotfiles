(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq custom-file "~/.emacs.d/custom.el")
(global-so-long-mode)

;; UI
(setq inhibit-startup-screen t)
(menu-bar-mode 0)

(setq ring-bell-function 'ignore)

(defun set-gtk-theme-variant (frame)
  "Set dark GTK theme variant"
  (start-process "set-theme-variant" nil
                 "xprop" "-f" "_GTK_THEME_VARIANT" "8u"
                 "-set" "_GTK_THEME_VARIANT" "dark" "-id"
                 (frame-parameter frame 'outer-window-id)))

(if (display-graphic-p)
    (progn
      (add-to-list 'after-make-frame-functions 'set-gtk-theme-variant t)
      (set-gtk-theme-variant (car (frame-list)))
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      (setq-default frame-title-format "Emacs: %b - %f")
      (setq font-use-system-font t)))

;; Descrease long lines impact
(setq-default bidi-display-reordering nil)

;; Use spaces instead of tabs
;; Also set default tab-width to 4
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Do not fold long lines
(setq-default truncate-lines t)

;; Backup and autosave
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))
(setq version-control t)
(setq delete-old-versions t)
(setq auto-save-list-file-prefix "~/.emacs.d/autosave/")
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/autosave/" t)))

;; Tramp
(setq tramp-default-method "ssh"
      tramp-terminal-type "tramp")

;; Ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; Packages
(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq package-archive-priorities
      '(("melpa" . 10)
        ("melpa-stable" . 5)))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)
(require 'bind-key)

;; Diminish
(use-package diminish)

;; eldoc
(use-package eldoc
  :ensure t
  :diminish)

(use-package js
  :defer t
  :init (setq js-indent-level 2))

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"
              markdown-hide-markup t))

;; plantuml
(use-package plantuml-mode
  :mode "\\.puml\\'"
  :config
  (setq plantuml-default-exec-mode 'jar
        plantuml-jar-path "~/.local/lib/java/plantuml.jar"))

;; Flymake
(use-package flymake
  :bind (:map flymake-mode-map
              ("M-n" . 'flymake-goto-next-error)
              ("M-p" . 'flymake-goto-prev-error)))

;; Org
(use-package org
  :pin gnu
  :ensure t
  :init
  (require 'org-tempo)
  (setenv "NODE_PATH"
      (concat (getenv "HOME") "/.emacs.d/node_modules"  ":"
              (getenv "NODE_PATH")))
  :config
  (setq org-src-fontify-natively t
        org-hide-emphasis-markers t
        org-plantuml-jar-path "~/.local/lib/java/plantuml.jar"
        org-babel-min-lines-for-block-output 2
        org-babel-results-keyword "results")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (http . t)
     (plantuml .t)
     (dot .t)
     (sql .t)
     (js . t))))

(use-package vertico
  :config
  (vertico-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless)))

(use-package consult
  :bind (
         ("C-c ." . consult-imenu)
         ("C-s" . consult-line)))

;; Avy
(use-package avy
  :bind ("C-'" . avy-goto-char-timer))

;; Themes
(use-package gruvbox-theme :defer t)
(use-package kaolin-themes :defer t)
(use-package doom-themes :defer t)
(use-package modus-themes :defer t)

;; Rainbow delimiters
(use-package rainbow-delimiters)

;; YAML
(use-package yaml-mode)

;; Magit
(use-package magit
  :bind
  ("C-x g" . magit-status)
  ("C-x M-g" . magit-file-dispatch))

;; LSP
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-keep-workspace-alive nil
        lsp-headerline-breadcrumb-enable nil
        lsp-idle-delay 0.500)
  (setq lsp-java-vmargs
        '("-noverify" "-Xmx1G" "-XX:+UseG1GC"
          "-XX:+UseStringDeduplication"
          "-javaagent:/home/axykon/.local/lib/java/lombok.jar"
          "-Xbootclasspath/a:/home/axykon/.local/lib/java/lombok.jar"))
  :bind
  ([remap display-local-help] . lsp-describe-thing-at-point))

(use-package lsp-ui
  :config
  ;;(setq lsp-ui-doc-enable nil)
  :bind
  (:map lsp-mode-map
        ("C-c C-b" . lsp-ui-doc-glance)))

(defcustom lsp-implementation "lsp"
  "Current LPS implementation"
  :type '(choice (const "lsp")
                 (const "eglot"))
  :group 'local)

(use-package yasnippet
  :config
  (yas-reload-all))

(use-package rfc-mode
  :defer t)

(use-package page-break-lines
  :defer t)

;; Go
;; Used tools:
;; GO111MODULE=on go get golang.org/x/tools/gopls@latest
;; GO111MODULE=on go get golang.org/x/lint/golint@latest
(use-package go-mode
  :bind (([f10] . compile))
  :preface
  (defun go-setup ()
    (when buffer-file-name
      (setq-local compile-command
                  (if (string-suffix-p "_test.go" buffer-file-name)
                      "go test -v"
                    "go build"))))
  :config
  ;;(add-hook 'go-mode-hook #'go-setup)
  ;;(add-hook 'go-mode-hook #'yas-minor-mode)
  (add-hook 'go-mode-hook (lambda ()
                            (go-setup)
                            (yas-minor-mode-on)
                            (cond ((string= lsp-implementation "eglot")
                                   (setq-default eglot-workspace-configuration
                                                 '((:gopls .
                                                           ((hoverKind ."FullDocumentation")
                                                            (staticcheck . t)
                                                            (usePlaceholders . t)
                                                            (linksInHover . :json-false)))))
                                   (eglot-ensure)
                                   (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
                                  ((string= lsp-implementation "lsp")
                                   (lsp-deferred)
                                   (lsp-register-custom-settings
                                    '(("gopls.completeUnimported" t t)
                                      ("gopls.hoverKind" "FullDocumentation")
                                      ("gopls.staticcheck" t t)))
                                   (add-hook 'before-save-hook #'lsp-organize-imports nil t)
                                   (add-hook 'before-save-hook #'lsp-format-buffer))))))

(use-package go-playground)

;; Rust
(use-package rust-mode
     :defer t)

;; Direnv
(use-package direnv
  :defer t)

;; Corfu
(use-package corfu
  :diminish
  :hook ((prog-mode . corfu-mode)
         (eshell-mode . corfu-mode))
  :config
  (setq corfu-cycle t))

;; Eglot
(use-package eglot
  :defer t
  :config
  (setq eglot-autoshutdown t)
  (advice-add 'eglot--format-markup :filter-return
              (lambda (r)
                (replace-regexp-in-string "\\\\\\([.'()\\:\";=*<>_]\\|-\\|/\\|\\[\\|\\]\\)" "\\1" r)))
  (define-key eglot-mode-map (kbd "C-c a") 'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename))


;; Ace-window
(use-package ace-window
  :config
  (setq aw-scope 'frame
        aw-display-mode-overlay nil)
  :bind ("M-o" . ace-window))

;; Vue
(use-package vue-mode
  :defer t)

;; Elisp
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode-enable)

(use-package highlight-indentation
  :defer t
  :hook (yaml-mode . highlight-indentation-current-column-mode)
  :diminish)

(use-package smartparens
  :defer t)

;; REST-client
(use-package restclient
  :defer t)

;; SQL-mode
(use-package sql
  :defer t)

(use-package sqlup-mode
  :defer t)

;; Multiple cursors
(use-package multiple-cursors
  :defer t)

;; Dired
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))

(add-hook 'dired-mode-hook
          (lambda ()
            (dired-omit-mode 1)
            (dired-hide-details-mode)))

(use-package treemacs-all-the-icons
  :disabled)

(use-package treemacs
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  :config
  (setq treemacs-read-string-input 'from-minibuffer)
  (treemacs-load-theme "all-the-icons"))

(use-package project
  :ensure nil
  :config
  (defun project-find-go-module (dir)
    (when-let ((root (locate-dominating-file dir "go.mod")))
      (cons 'go-module root)))
  (cl-defmethod project-root ((project (head go-module)))
    (cdr project))
    (add-hook 'project-find-functions #'project-find-go-module)
  )

;; Dockerfile
(use-package dockerfile-mode
  :defer t)

;; Groovy
(use-package groovy-mode
  :config
  (setq groovy-indent-offset 2))

;; Browse at git remote
(use-package browse-at-remote)

;; Graphviz
(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 2))

;; Additional library path
(add-to-list 'load-path "~/.emacs.d/lib")

;; Load custom file if exists
(if (file-readable-p custom-file)
    (load-file custom-file))

;; Enable narrowing to region
(put 'narrow-to-region 'disabled nil)

;; k8s
(defun k8s-select-pod ()
  (let ((pod-list (split-string (shell-command-to-string "kubectl get pods -o jsonpath='{.items[*].metadata.name}'"))))
    (completing-read "Select Pod: " pod-list)))


(defun k8s-log ()
  (interactive)
  (let* ((pod (k8s-select-pod))
         (process-name (format "k8s-log-%s" pod))
         (buffer-name (format "*k8s-log-%s*" pod)))
    (unless (get-buffer buffer-name)
      (progn
        (start-process process-name buffer-name "kubectl" "logs" "-f" pod)
        (set-buffer buffer-name)
        (view-mode t)
        (hl-line-mode)
        (toggle-truncate-lines nil)))
    (switch-to-buffer buffer-name)))

;; Ligatures
;; https://github.com/mickeynp/ligature.el
(use-package ligature
  :disabled
  :if (file-directory-p "~/pro/misc/ligature.el")
  :load-path "~/pro/misc/ligature.el"
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; some borrowed snippets
(use-package org
  :defer t
  :config
  (progn
;;;; Table Field Marking
    (defun org-table-mark-field ()
      "Mark the current table field."
      (interactive)
      ;; Do not try to jump to the beginning of field if the point is already there
      (when (not (looking-back "|[[:blank:]]?"))
        (org-table-beginning-of-field 1))
      (set-mark-command nil)
      (org-table-end-of-field 1))
    (bind-keys
     :map org-mode-map
     :filter (org-at-table-p)
     ("S-SPC" . org-table-mark-field))))


(use-package emacs
  :init
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete))
