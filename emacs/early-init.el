(setq inhibit-startup-message t)
(menu-bar-mode -1)

(when window-system
  (tool-bar-mode -1)
  (setq font-use-system-font t)  
  (setopt scroll-bar-mode nil))
