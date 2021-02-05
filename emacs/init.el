(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
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
(use-package diminish)

;; eldoc
(use-package eldoc
  :ensure t
  :diminish)

;; ob-http
(use-package ob-http
  :defer t)

;; plantuml
(use-package plantuml-mode
  :defer t)

;; Flymake
(use-package flymake
  :bind (:map flymake-mode-map
              ("M-n" . 'flymake-goto-next-error)
              ("M-p" . 'flymake-goto-prev-error)))

;; Org
(use-package org
  :pin gnu
  :ensure t
  :config
  (setq org-babel-python-command "python3"
        org-src-fontify-natively t
        org-hide-emphasis-markers t
        org-plantuml-jar-path "~/plantuml.jar"
        org-babel-min-lines-for-block-output 2)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (http . t)
     (plantuml .t)
     (dot .t)
     (sql .t))))


(use-package ivy
  :diminish)

;; Counsel
(use-package counsel
  :bind
  ("C-s" . swiper)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers nil))


;; Themes
(use-package gruvbox-theme :defer t)
(use-package kaolin-themes :defer t)
(use-package doom-themes :defer t)

;; Rainbow delimiters
(use-package rainbow-delimiters)

;; YAML
(use-package yaml-mode)

;; Magit
(use-package magit
  :bind
  ("C-x g" . magit-status)
  ("C-x M-g" . magit-file-dispatch))

;; Projectile
(use-package projectile
  :disabled
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  ;;(projectile-global-mode)
  (setq projectile-completion-system 'ivy
        projectile-mode-line-prefix "  ")
  (projectile-mode "+1"))

;; LSP
(use-package lsp-mode
  :defer t
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-keep-workspace-alive nil
        lsp-eldoc-render-all nil
        lsp-idle-delay 0.500))

(use-package lsp-ui
  :config
  (setq lsp-ui-doc-enable nil)
  :bind
  (:map lsp-mode-map
        ("C-c C-b" . lsp-ui-doc-glance)))

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
  (add-hook 'go-mode-hook #'go-setup)
  (add-hook 'go-mode-hook #'yas-minor-mode)
  (add-hook 'go-mode-hook (lambda ()
                            (cond ((string= lsp-implementation "eglot")
                                   (setq eglot-workspace-configuration '((gopls . (:hoverKind "FullDocumentation"))))
                                   ;; (define-advice eglot-imenu (:override () ignore)
                                   ;;   (imenu-default-create-index-function))
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
  :diminish
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
  :bind ("M-o" . ace-window))

;; Vue
(use-package vue-mode
  :defer t)

;; Elisp
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode-enable)

(use-package highlight-indent-guides
  :defer t
  :config
  (setq highlight-indent-guides-method 'fill))

(use-package smartparens
  :defer t)

;; Python
(use-package elpy
  :disabled
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
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))
(use-package dired-subtree
  :disabled
  :bind (:map dired-mode-map
              ("<tab>" . 'dired-subtree-toggle)))

(use-package dired-sidebar
  :disabled
  :ensure t
  :bind (([f9] . dired-sidebar-toggle-sidebar))
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  
  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'ascii)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;; Modeline
(use-package telephone-line
  :disabled
  :config
  (telephone-line-mode 1))

(use-package mood-line
  :disabled
  :config
  (mood-line-mode 1))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(use-package flycheck
  :diminish)

(use-package treemacs-all-the-icons)

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
  (treemacs-load-theme "all-the-icons"))

(use-package project
  :ensure nil
  :config
  (defvar project-root-markers '("go.mod")
    "Files or directories that indicate the root of a project.")
  (defun aorst/project-find-root (path)
    "Tail-recursive search in PATH for root markers."
    (let* ((this-dir (file-name-as-directory (file-truename path)))
           (parent-dir (expand-file-name (concat this-dir "../")))
           (system-root-dir (expand-file-name "/")))
      (cond
       ((aorst/project-root-p this-dir) (cons 'transient this-dir))
       ((equal system-root-dir this-dir) nil)
       (t (aorst/project-find-root parent-dir)))))
  (defun aorst/project-root-p (path)
    "Check if current PATH has any of project root markers."
    (let ((results (mapcar (lambda (marker)
                             (file-exists-p (concat path marker)))
                           project-root-markers)))
      (eval `(or ,@ results))))
  (add-to-list 'project-find-functions #'aorst/project-find-root))

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
    (ivy-read "Select Pod: " pod-list)))


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
        (toggle-truncate-lines nil)))
    (switch-to-buffer buffer-name)))

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

    (defhydra hydra-org-table-mark-field
      (:body-pre (org-table-mark-field)
       :color red
       :hint nil)
      "
   ^^      ^🠙^     ^^
   ^^      _p_     ^^
🠘 _b_  selection  _f_ 🠚          | Org table mark ▯field▮ |
   ^^      _n_     ^^
   ^^      ^🠛^     ^^
"
      ("x" exchange-point-and-mark "exchange point/mark")
      ("f" (lambda (arg)
             (interactive "p")
             (when (eq 1 arg)
               (setq arg 2))
             (org-table-end-of-field arg)))
      ("b" (lambda (arg)
             (interactive "p")
             (when (eq 1 arg)
               (setq arg 2))
             (org-table-beginning-of-field arg)))
      ("n" next-line)
      ("p" previous-line)
      ("q" nil "cancel" :color blue))

    (bind-keys
     :map org-mode-map
     :filter (org-at-table-p)
     ("S-SPC" . hydra-org-table-mark-field/body))))
