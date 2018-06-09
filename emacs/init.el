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

;; Custom file
(setq custom-file "~/.emacs.d/custom.el")
(if (file-readable-p custom-file)
    (load-file custom-file))

;; Tramp
(setq tramp-default-method "ssh"
      tramp-terminal-type "tramp")

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)
(require 'diminish)
(require 'bind-key)


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
(load-theme 'gruvbox-dark-medium t)
;;(load-theme 'darktooth t)


;; Rainbow delimiters
(use-package rainbow-delimiters)

