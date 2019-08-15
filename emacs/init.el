;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=34341
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; UI
(setq inhibit-startup-screen t)
(menu-bar-mode 0)

(setq ring-bell-function 'ignore)

(if (display-graphic-p)
    (progn
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      (setq-default frame-title-format "Emacs: %b - %f")
      (setq font-use-system-font t)
      (setq default-frame-alist
            '((width . 129)
              (height . 35)
              (fullscreen . maximized)))))

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
(setq package-archive-priorities
      '(("melpa-stable" . 10)
        ("melpa"        . 5)))
(setq package-pinned-packages '((gruber-darker-theme . "melpa")
                                (ace-window . "melpa")
                                (plantuml-mode . "melpa")))

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
(use-package ob-http)

;; plantuml
(use-package plantuml-mode
  :pin melpa
  :defer t)

;; Org
(use-package org
  :config
  (setq org-babel-python-command "python3"
        org-src-fontify-natively t
        org-hide-emphasis-markers t
        org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (http . t)
     (plantuml .t))))

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
  :commands (lsp lsp-deferred))

;; Go
;; Used tools:
;; github.com/stamblerre/gocode
;; github.com/zmb3/gogetdoc
;; golang.org/x/tools/cmd/goimports
(use-package go-mode
  :bind (([f9] . compile))
  :config
  (setq godoc-at-point-function 'godoc-gogetdoc))
;; (use-package go-playground)
;; (use-package company-go)
;; (add-hook 'before-save-hook 'gofmt-before-save)
;; (setq-default gofmt-command "goimports")
;; (add-hook 'go-mode-hook (lambda ()
;;                           (set (make-local-variable 'company-backends) '(company-go))
;;                           (company-mode)))
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'display-line-numbers-mode)
(add-hook 'go-mode-hook 'yas-minor-mode)

;; Rust
(use-package rust-mode
     :defer t)

;; Direnv
(use-package direnv
  :defer t)

;; Company
(use-package company)

;; Eglot
(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '(go-mode . ("gopls"))))

;; Ace-window
(use-package ace-window
  :config
  (setq aw-scope 'frame)
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

;; Additional library path
(add-to-list 'load-path "~/.emacs.d/lib")

;; Custom file
(setq custom-file "~/.emacs.d/custom.el")
(if (file-readable-p custom-file)
    (load-file custom-file))
(put 'narrow-to-region 'disabled nil)


