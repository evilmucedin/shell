; $Id: .emacs,v 1.1 2007/11/07 19:51:11 denplusplus Exp $

(defun go-r ()
  (interactive)
  (let ((here (point)))
    (skip-syntax-forward "-")
    (if (/= (point) here)
        (goto-char (point))
      (goto-char (1+ (point))))))

(defun go-l ()
  (interactive)
  (let ((here (point)))
    (skip-syntax-backward "-")
    (if (/= (point) here)
        (goto-char (point))
      (goto-char (1- (point))))))

(defun bs-l ()
  (interactive)
  (let ((here (point)))
    (skip-syntax-backward "-")
    (if (/= (point) here)
        (kill-region (point) here)
      (kill-region (1- (point)) (point)))))

(define-key global-map [left] 'go-l)
(define-key global-map [right] 'go-r)

;backspace binding
(setq key-translation-map (make-sparse-keymap))
(define-key key-translation-map "\177" "\C-HJ")
(defvar BACKSPACE "\C-HJ")
(global-set-key BACKSPACE 'bs-l)

;(setq load-path (cons "~/elisp/xref/emacs" load-path))
;(setq exec-path (cons "~/elisp/xref" exec-path))
;(load "xrefactory")

(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(c-backspace-function (quote backward-delete-char))
 '(c-basic-offset 4)
 '(c-default-style "ellemtel")
 '(c-echo-syntactic-information-p t)
 '(c-offsets-alist (quote ((arglist-cont-nonempty . +))))
 '(c-tab-always-indent (quote other))
 '(case-fold-search t)
 '(current-language-environment "UTF-8")
 '(default-input-method "rfc1345")
 '(global-font-lock-mode t nil (font-lock))
 '(save-place t nil (saveplace))
 '(show-paren-mode t nil (paren))
 '(tab-width 4)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(font-lock-builtin-face ((t (:foreground "white" :weight bold :height 1.2))))
 '(font-lock-comment-face ((((type tty pc) (class color) (background dark)) (:foreground "yellow"))))
 '(show-paren-match ((((class color)) (:foreground "white" :weight bold :height 1.2))))
 '(show-paren-match-face ((((class color)) (:foreground "white" :weight bold :height 1.2)))))

(autoload 'c++-mode "cc-mode" "C++ Editing Mode" t)
;; To associate *.h files with c++ mode use the following line
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'load-path (expand-file-name "~/elisp/"))

;(require 'cpp-font-lock)

;; Treat 'y' or <CR> as yes, 'n' as no.
(fset 'yes-or-no-p 'y-or-n-p)
;(global-set-key [enter] 'reindent-then-newline-and-indent)
(define-key global-map [f1] 'info)
(define-key global-map [f2] 'save-buffer)
(define-key global-map [f12] 'buffer-menu)
(define-key global-map [f11] 'nc)
;(set-input-method 'cyrillic-jcuken)
(prefer-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;(prefer-coding-system 'cp866)
;(prefer-coding-system 'koi8-r-unix)
;(prefer-coding-system 'windows-1251-dos)
(prefer-coding-system 'utf-8-unix)

(require 'useful-commands)

(global-set-key "\r" 'c-my-context-line-break)
(autoload 'nc "nc" "Emulate MS-DOG file shell" t)

(autoload 'lua-mode "lua-mode" "Mode for editing Lua source files")
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))

(autoload 'python-mode "python-21" "Python mode" t)
(autoload 'pair-mode "pair-mode" "Pair Mode" t)
(setq auto-mode-alist
     (cons '("\\.py$" . python-mode) auto-mode-alist))
     (add-hook 'python-mode-hook
               '(lambda () 
                (pair-mode 1)
                (eldoc-mode 1) 
                (outline-minor-mode 1)
                t))

;(autoload 'python-mode "python-mode" "Python Mode." t)
;(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(menu-bar-mode 'nil)
;(add-hook 'python-mode-hook
;		  (lambda ()
;			(set (make-variable-buffer-local 'beginning-of-defun-function)
;				 'py-beginning-of-def-or-class)
;			(setq outline-regexp "def\\|class ")))

;; Make sure that the file ends in a newline.
(setq require-final-newline t)

;; Use spaces instead of tabs.
(setq-default indent-tabs-mode nil)

;; Hungry delete is nice since we use spaces instead of tabs.
;(setq c-hungry-delete-key t)

;; Let emacs insert newlines automatically whenever it can.
;(setq c-auto-newline 1)
