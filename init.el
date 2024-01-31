(setq initial-scratch-message "Welcome to Emacs!")

(desktop-save-mode 1)

;;(set-frame-font "Ubuntu Regular-16" nil t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;;(package-refresh-contents)

;; move keys by 5 positions
(global-set-key (kbd "S-<left>") (lambda () (interactive) (backward-char 5)))
(global-set-key (kbd "S-<right>") (lambda () (interactive) (forward-char 5)))
(global-set-key (kbd "S-<up>") (lambda () (interactive) (previous-line 5)))
(global-set-key (kbd "S-<down>") (lambda () (interactive) (next-line 5)))

;; full screen
(add-to-list 'initial-frame-alist '(fullscreen . fullboth))

;; directory completion
(ido-mode 1)
(setq ido-everywhere t)

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)

;; fix tab error
(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)

;; Don't show the splash screen
(setq inhibit-startup-message t)  ; Comment at end of line!

;; Turn off some unneeded UI elements
(menu-bar-mode -1)  ; Leave this one on if you're a beginner!
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Customize color of selected texts
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(region ((t (:background "black" :foreground "white")))))

;; Customize color of selected texts

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; Use Tab and Shift-Tab to navigate through the suggestions
(add-hook 'ido-setup-hook
	  (lambda ()
	    (define-key ido-completion-map [tab] 'ido-next-match)
	    (define-key ido-completion-map (kbd "S-TAB") 'ido-prev-match)))

(unless (package-installed-p 'swiper)
  (package-install 'swiper))

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(unless (package-installed-p 'counsel)
  (package-install 'counsel))

(global-set-key (kbd "C-s") 'swiper)    ;; Bind Swiper to Ctrl-s
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(undo-tree grip-mode markdown-preview-mode markdown-mode company pdf-tools swiper helm evil)))

(global-set-key (kbd "C-c e") 'eshell)

;; LSP in emacs
(unless (package-installed-p 'company)
  (package-install 'company))

(add-hook 'after-init-hook 'global-company-mode)

;; Autoformat
(defun my-remove-extra-blank-lines (start end)
  "Remove multiple consecutive blank lines in a region."
  (interactive "r")
  (save-excursion
    (goto-char start)
    (while (re-search-forward "^\n\\{2,\\}" end t)
      (replace-match "\n\n")))

  (defun my-elisp-auto-format-function ()
    "Automatically format the current Emacs Lisp buffer before saving."
    (when (eq major-mode 'emacs-lisp-mode)
      ;; Indent the entire buffer
      (indent-region (point-min) (point-max))
      ;; Clean up whitespace
      (whitespace-cleanup)
      ;; Remove extra blank lines
      (my-remove-extra-blank-lines (point-min) (point-max))))

  (add-hook 'emacs-lisp-mode-hook
	    (lambda ()
	      (add-hook 'before-save-hook 'my-elisp-auto-format-function nil 'local))))


;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; adjust size of panes
(setq window-resize-pixelwise t)

(setq evil-want-C-w-in-emacs-state t)

(defun my-resize-window-left (&optional pixels)
  "Resize the window to the left by PIXELS."
  (interactive "p")
  (if (numberp pixels)
      (shrink-window-horizontally pixels)
    (shrink-window-horizontally 5)))

(defun my-resize-window-right (&optional pixels)
  "Resize the window to the right by PIXELS."
  (interactive "p")
  (if (numberp pixels)
      (enlarge-window-horizontally pixels)
    (enlarge-window-horizontally 5)))

(defun my-resize-window-down (&optional lines)
  "Resize the window down by LINES."
  (interactive "p")
  (if (numberp lines)
      (shrink-window lines)
    (shrink-window 5)))

(defun my-resize-window-up (&optional lines)
  "Resize the window up by LINES."
  (interactive "p")
  (if (numberp lines)
      (enlarge-window lines)
    (enlarge-window 5)))

(with-eval-after-load 'evil-maps
  (define-key evil-window-map (kbd "h") 'my-resize-window-left)
  (define-key evil-window-map (kbd "j") 'my-resize-window-down)
  (define-key evil-window-map (kbd "k") 'my-resize-window-up)
  (define-key evil-window-map (kbd "l") 'my-resize-window-right))


;; redo
(unless (package-installed-p 'undo-tree)
  (package-install 'undo-tree))

(global-undo-tree-mode)

;; exwm
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)

;; copy and paste
(global-set-key (kbd "s-c") 'kill-ring-save)  ; Super-c for copy
(global-set-key (kbd "s-v") 'yank)           ; Super-v for paste
(global-set-key (kbd "s-x") 'kill-region)    ; Super-x for cut
(global-set-key (kbd "s-a") 'mark-whole-buffer) ; Super-a for select-all

;; same clipboard between firefox and emacs
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)
(setq select-active-regions t)
(setq mouse-drag-copy-region t)

;; short-cut for applications

;; Keybinding to open Firefox
(exwm-input-set-key (kbd "s-f") (lambda ()
                                  (interactive)
                                  (start-process "" nil "firefox")))

;; Keybinding to open GNOME Terminal
(exwm-input-set-key (kbd "s-t") (lambda ()
                                  (interactive)
                                  (start-process "" nil "gnome-terminal")))

;; Keybinding to re-eval init.el 
(global-set-key (kbd "s-e") 'eval-buffer)



