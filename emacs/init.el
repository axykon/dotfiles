;; UI
(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(if (display-graphic-p)
    (progn
      (setq-default cursor-type 'bar)
      (setq font-use-system-font t)
      (setq default-frame-alist
            '((width . 129)
	      (height . 35)))))

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Do not fold long lines
(setq-default truncate-lines t)

;; Tramp
(setq tramp-default-method "ssh"
      tramp-terminal-type "tramp")

;; Ediff
(setq 
 ediff-window-setup-function 'ediff-setup-windows-plain)

;; Packages
(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq package-archive-priorities
      '(("melpa-stable" . 10)
        ("melpa"        . 5)))
(setq package-pinned-packages '())
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

;; Org
(use-package org
  :config
  (setq org-babel-python-command "python3"
        org-src-fontify-natively t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t))))

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
(load-theme 'gruvbox-dark-hard t)
;;(load-theme 'darktooth t)


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
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy)
  (setq projectile-mode-line
        '(:eval 
          (if (file-remote-p default-directory)
              "  [-]"
            (format "  [%s]" (projectile-project-name))))))

;; Go
(use-package go-mode)
(use-package go-playground)

(add-hook 'before-save-hook 'gofmt-before-save)
(setq-default gofmt-command "goimports")
;;(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))
(add-hook 'go-mode-hook 'yas-minor-mode)
;;(add-hook 'go-mode-hook 'flycheck-mode)

;; Direnv
(use-package direnv
  :config
  (direnv-mode))

;; Company
(use-package company)

;; Eglot
(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '(go-mode . ("go-langserver" "-gocodecompletion"))))

;; Winum
(use-package winum
  :demand t
  :bind (("C-`" . winum-select-window-by-number)
         ("M-0" . winum-select-window-0-or-10)
         ("M-1" . winum-select-window-1)
         ("M-2" . winum-select-window-2)
         ("M-3" . winum-select-window-3)
         ("M-4" . winum-select-window-4)
         ("M-5" . winum-select-window-5)
         ("M-6" . winum-select-window-6)
         ("M-7" . winum-select-window-7)
         ("M-8" . winum-select-window-8)
         ("M-9" . winum-select-window-9))
  :config
  (winum-mode))

;; Vue
(use-package vue-mode)

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
  (add-hook 'python-mode-hook 'elpy-mode))
  
(add-hook 'python-mode-hook 'smartparens-mode)
(add-hook 'python-mode-hook 'rainbow-delimiters-mode)
;;(add-hook 'python-mode-hook 'highlight-indent-guides-mode)

;; REST-client
(use-package restclient
  :defer t)

;; SQL-mode
(use-package sql
  :init
  (setq sql-postgres-program "docker-psql"
        sql-mysql-program "docker-mysql"))

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
