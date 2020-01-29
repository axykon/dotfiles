;; https://www.reddit.com/r/orgmode/comments/cvmjjr/workaround_for_tlsrelated_bad_request_and_package/
(when (and (>= libgnutls-version 30603)
           (version<= emacs-version "26.2"))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(setq custom-file "~/.emacs.d/custom.el")

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

;; Descreas long lines impact
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
;; (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
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
;;(use-package diminish)

;; ob-http
(use-package ob-http
  :defer t)

;; plantuml
(use-package plantuml-mode
  :defer t)

;; Org
(use-package org
  :pin gnu
  :config
  (require 'org-tempo)
  (setq org-babel-python-command "python3"
        org-src-fontify-natively t
        org-hide-emphasis-markers t
        org-babel-min-lines-for-block-output 2)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (http . t)
     (plantuml .t)
     (sql .t))))

;; Counsel
(use-package counsel
  :bind
  ("C-s" . swiper)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers nil))

;; Themes
(use-package darktooth-theme :defer t)
(use-package gruvbox-theme :defer t)
(use-package dracula-theme :defer t)
(use-package monokai-theme :defer t)
(use-package kaolin-themes :defer t)
(use-package doom-themes :defer t)

;; Rainbow delimiters
(use-package rainbow-delimiters)

;; YAML
(use-package yaml-mode)

;; Magit
(use-package magit
  :bind
  ("C-x g" . magit-status))

;; Projectile
(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  ;;(projectile-global-mode)
  (setq projectile-completion-system 'ivy)
  (setq projectile-mode-line
        '(:eval 
          (if (file-remote-p default-directory)
              "  [-]"
            (format "  [%s]" (projectile-project-name)))))
  (projectile-mode "+1"))

;; LSP
(use-package lsp-mode
  :defer t
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-keep-workspace-alive nil))

(use-package company-lsp
  :defer t
  :config (push 'company-lsp company-backends))


(defcustom lsp-implementation "lsp"
  "Current LPS implementation"
  :type '(choice (const "lsp")
                 (const "eglot"))
  :group 'local)

;; Go
;; Used tools:
;; GO111MODULE=on go get golang.org/x/tools/gopls@latest
;; GO111MODULE=on go get golang.org/x/lint/golint@latest
(use-package go-mode
  :bind (([f10] . compile)
         ("C-c ." . counsel-imenu))
  :preface
  (defun go-setup ()
    (when buffer-file-name
      (setq-local compile-command
                  (if (string-suffix-p "_test.go" buffer-file-name)
                      "go test -v"
                    "go build"))))
  :config
  (setq godoc-at-point-function 'godoc-gogetdoc)
  (add-hook 'go-mode-hook #'go-setup)
  (add-hook 'go-mode-hook #'yas-minor-mode)
  (add-hook 'go-mode-hook (lambda ()
                            (cond ((string= lsp-implementation "eglot")
                                   (setq eglot-workspace-configuration '((gopls . (:hoverKind "SynopsisDocumentation"))))
                                   (setq eglot-put-doc-in-help-buffer t)
                                   (define-advice eglot-imenu (:override () ignore)
                                     (imenu-default-create-index-function))
                                   (eglot-ensure)
                                   (company-mode)
                                   (add-hook 'before-save-hook #'eglot-format-buffer nil t))
                                  ((string= lsp-implementation "lsp")
                                   (lsp-deferred)
                                   (add-hook 'before-save-hook #'lsp-organize-imports nil t)
                                   (add-hook 'before-save-hook #'lsp-format-buffer))))))

(use-package go-playground)

;; Rust
(use-package rust-mode
     :defer t)

;; Direnv
(use-package direnv
  :defer t)

;; Company
(use-package company
  :init
  (add-hook 'prog-mode-hook #'company-mode)
  :config
  (setq-default company-backends
                '(company-capf
                  company-files
                  (company-dabbrev-code company-keywords)
                  company-dabbrev)))

;; Eglot
(use-package eglot
  :defer t
  :config
  (setq eglot-autoshutdown t)
  (add-to-list 'eglot-server-programs '(go-mode . ("gopls"))))

;; Ace-window
(use-package ace-window
  :config
  (setq aw-scope 'frame
        aw-display-mode-overlay nil)
  (ace-window-display-mode 1)
  :bind ("M-o" . ace-window))

;; Vue
(use-package vue-mode
  :defer t)

;; Elisp
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode-enable)

(use-package highlight-indent-guides
  :defer t
  :config
  (setq highlight-indent-guides-method 'character))

(use-package smartparens
  :defer t)

;; Python
(use-package elpy
  :defer t
  :init
  (add-hook 'python-mode-hook 'elpy-mode)
  :config
  (setq elpy-rpc-python-command "python3"))
  
(add-hook 'python-mode-hook 'smartparens-mode)
(add-hook 'python-mode-hook 'rainbow-delimiters-mode)
;;(add-hook 'python-mode-hook 'highlight-indent-guides-mode)

;; REST-client
(use-package restclient
  :defer t)

;; SQL-mode
(use-package sql
  :defer t)

(use-package sqlup-mode
  :defer t)

;; Multiple cursors
(use-package multiple-cursors)

;; Dired
(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(use-package dired-sidebar
  :ensure t
  :bind (([f9] . dired-sidebar-toggle-sidebar))
  :commands (dired-sidebar-toggle-sidebar))

;; Modline
(use-package doom-modeline
  :config
  (setq doom-modeline-buffer-file-name-style 'relative-to-project)
  :hook (after-init . doom-modeline-mode))

;; Additional library path
(add-to-list 'load-path "~/.emacs.d/lib")

;; Load custom file if exists
(if (file-readable-p custom-file)
    (load-file custom-file))

;; Enable narrowing to region
(put 'narrow-to-region 'disabled nil)
