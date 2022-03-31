(defun dot-package ()
  (require 'package)
  
  (add-to-list 'package-archives
               '("melpa-stable" . "https://stable.melpa.org/packages/")
							 t)

  (add-to-list 'package-archives
							 '("melpa" . "https://melpa.org/packages/")							 
							 t)

  (package-initialize)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))  
  )

(defun dot-packages ()
  (use-package diminish
    :ensure t
    :config
		(eval-after-load "hideshow" '(diminish 'hs-minor-mode))
    (eval-after-load "eldoc" '(diminish 'eldoc-mode))
    (eval-after-load "autorevert" '(diminish 'auto-revert-mode)))

  (use-package smartparens
    :ensure t
    :diminish smartparens-mode
    :config
    (require 'smartparens-config))

  (use-package beacon
    :ensure t
    :diminish beacon-mode
    :init
    (beacon-mode 1))

  (use-package org-bullets
    :ensure t
    :init
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

  (use-package rainbow-delimiters
    :ensure t
    :init
    (rainbow-delimiters-mode 1))

  (use-package yaml-mode
    :ensure t)

	(if (eq system-type 'gnu/linux)
			(progn
				;; .gnupg/gpg-agent.conf
				;; allow-emacs-pinentry
				;; allow-loopback-pinentry
				(use-package pinentry
					:ensure t
					:config
					(setq epa-pinentry-mode 'loopback)
					:init
					(pinentry-start))

				(use-package magit
					:ensure t
					:bind (("C-x g" . magit-status)))				
				))
  )

(defun dot-global-keys ()
  (global-set-key (kbd "C-;") 'comment-region)
  (global-set-key (kbd "C-'") 'uncomment-region)

  (global-set-key (kbd "C-.") 'hs-toggle-hiding)
	(global-set-key (kbd "C--") 'hs-hide-all)
  (global-set-key (kbd "C-=") 'hs-show-all)

  (global-set-key (kbd "C-w") 'backward-kill-word)
  (global-set-key (kbd "C-x C-k") 'kill-region)

	(global-set-key (kbd "C-x C--") 'text-scale-decrease)
  (global-set-key (kbd "C-x C-=") 'text-scale-increase)

  (global-set-key (kbd "C-x C-b") 'ibuffer)

  (global-set-key (kbd "C-c a") 'beginning-of-buffer)
  (global-set-key (kbd "C-c e") 'end-of-buffer)
	(global-set-key (kbd "C-c l") 'goto-line)

  (defun goto-window (n)
    (select-window (frame-first-window))
    (other-window n))
  
  (global-set-key (kbd "M-1") (lambda () (interactive) (goto-window 0)))
  (global-set-key (kbd "M-2") (lambda () (interactive) (goto-window 1)))
  (global-set-key (kbd "M-3") (lambda () (interactive) (goto-window 2)))
  (global-set-key (kbd "M-4") (lambda () (interactive) (goto-window 3)))

  (defun split-follow-window-horizontally ()
    (interactive)
    (split-window-below)
    (balance-windows)
    (other-window 1))

  (defun split-follow-window-vertically ()
    (interactive)
    (split-window-right)
    (balance-windows)
    (other-window 1))

  (global-set-key (kbd "C-x 2") 'split-follow-window-horizontally)
  (global-set-key (kbd "C-x 3") 'split-follow-window-vertically)
  )

(defun dot-look ()
  (setq inhibit-startup-message 1)
  (setq auto-save-default nil)
  (setq make-backup-files nil)
  (setq ring-bell-function 'ignore)
  (setq scroll-step 1)
  (setq fill-column 80)
	(setq eshell-aliases-file "~/.emacs.d/eshell-alias")
	
	(setq-default tab-width 2)
	(set-face-underline-p 'highlight nil)
  
  (global-font-lock-mode 1)
  (global-hl-line-mode 1)
  (global-so-long-mode 1)

  (transient-mark-mode 1)
  
  (show-paren-mode 1)
  (line-number-mode 1)
  (column-number-mode 1)

  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)

  (fset 'yes-or-no-p 'y-or-n-p)

  (set-face-attribute 'default nil
		      ;; :font "Source Code Pro"
		      :weight 'normal
		      :width 'normal
		      :height 120)

	(if (eq system-type 'windows-nt)
			(set-face-attribute 'default nil
		      :weight 'normal
		      :width 'normal
		      :height 100))

  (add-to-list 'default-frame-alist '(alpha . (95 . 75)))
  (set-frame-parameter nil 'alpha '(95 . 75))

  (use-package zenburn-theme :ensure t)
  
	(unless (package-installed-p 'spacemacs-theme)
    (package-refresh-contents)
    (package-install 'spacemacs-theme))
	
	(load-theme 'zenburn t)
	;; (load-theme 'spacemacs-dark t)
  )

(defun dot-alias ()
  (defalias 'rs 'replace-string)  
	)

(defun dot-ido ()
  (setq ido-enable-flex-matching nil)
  (setq ido-create-new-buffer 'always)
  (setq ido-everywhere t)
  (ido-mode 1)

  (use-package ido-vertical-mode
    :ensure t
    :init
    (ido-vertical-mode 1)
    :config
    (setq ido-vertical-define-keys 'C-n-and-C-p-only))
  )

(defun dot-company ()
  (use-package company
    :ensure t
    :diminish company-mode
    ;; :init
    ;; (add-hook 'after-init-hook 'global-company-mode)
    :config
    (setq company-idle-delay 0)
    (setq company-minimum-prefix-length 3))

  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "M-.") 'company-show-location)
  )

(defun dot-org ()
  (setq org-confirm-babel-evaluate nil)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     ))
  )

(defun dot-emms ()
  (use-package emms
    :ensure t
    :config
    (require 'emms-setup)
    (emms-minimalistic)
    (emms-default-players)
    
    (setq emms-source-file-default-directory "~/music/")
    
    (require 'emms-mode-line)
    (emms-mode-line 1)
    
    (require 'emms-playing-time)
    (emms-playing-time 1))
  )

(defun dot-emacs-lisp ()
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
  (add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
  (add-hook 'emacs-lisp-mode-hook 'smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-sql ()
  (require 'sql)
  
  (defun sql-send-smart()
    (interactive)
    (if (region-active-p)
	(sql-send-region (region-beginning) (region-end))
      (sql-send-line-and-next)))

  (define-key sql-mode-map (kbd "C-<return>") 'sql-send-region)
  )

(defun dot-sbcl ()
  (use-package slime
    :ensure t)

  (use-package slime-company
    :ensure t)

  (defun slime-eval-smart()
    (interactive)
    (if (region-active-p)
	(slime-eval-region (region-beginning) (region-end))
      (slime-eval-defun)))

  (setq inferior-lisp-program "sbcl")
  (setq slime-contribs '(slime-repl slime-company))
  
  (setq common-lisp-hyperspec-root "file:///home/a7o/dl/clhs/")
  (setq browse-url-browser-function 'eww-browse-url)

  (add-to-list 'auto-mode-alist '("\\.lisp\\'" . lisp-mode))
  
  (define-key lisp-mode-map (kbd "C-<return>") 'slime-eval-smart)

  (define-key lisp-mode-map (kbd "C-c -") 'sp-splice-sexp)
  (define-key lisp-mode-map (kbd "C-c =") 'sp-wrap-round)

  (add-hook 'lisp-mode-hook 'company-mode)
  (add-hook 'lisp-mode-hook 'hs-minor-mode)
  (add-hook 'lisp-mode-hook 'smartparens-mode)
  (add-hook 'lisp-mode-hook 'smartparens-strict-mode)
  (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-python ()
  (use-package python
    :ensure t)

  (setq python-indent-offset 2)
  
  (setq python-shell-interpreter "pypy3"
				python-shell-interpreter-args "-i")

  (defun python-shell-send-line()
    (interactive)
    (python-shell-send-string (thing-at-point 'line t)))

  (defun python-shell-send-reg()
    (interactive)
    (python-shell-send-string (buffer-substring (region-beginning) (region-end)))
    (deactivate-mark))

  (defun python-shell-send-str()
    (interactive)
    (if (region-active-p)
	(python-shell-send-reg)
      (python-shell-send-line)))

  (define-key python-mode-map (kbd "C-<return>") 'python-shell-send-str)
  
  (add-hook 'python-mode-hook 'company-mode)
  (add-hook 'python-mode-hook 'hs-minor-mode)
  (add-hook 'python-mode-hook 'smartparens-mode)
  (add-hook 'python-mode-hook 'smartparens-strict-mode)
  (add-hook 'python-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-go ()
  (use-package go-mode
    :ensure t)
  
  (add-hook 'go-mode-hook 'company-mode)
  (add-hook 'go-mode-hook 'hs-minor-mode)
  (add-hook 'go-mode-hook 'smartparens-mode)
  (add-hook 'go-mode-hook 'smartparens-strict-mode)
  (add-hook 'go-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-julia ()
  (use-package julia-mode
    :ensure t)
  
  (use-package julia-repl
    :ensure t)

  (setq julia-indent-offset 2)

  (define-key julia-repl-mode-map (kbd "C-<return>") 'julia-repl-send-region-or-line)
  
  (add-hook 'julia-mode-hook 'julia-repl-mode)
  (add-hook 'julia-mode-hook 'company-mode)
  (add-hook 'julia-mode-hook 'hs-minor-mode)
  (add-hook 'julia-mode-hook 'smartparens-mode)
  (add-hook 'julia-mode-hook 'smartparens-strict-mode)
  (add-hook 'julia-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-rust ()
  (use-package rust-mode
    :ensure t)
  
  (use-package cargo
    :ensure t
    :config
    (add-hook 'rust-mode-hook 'cargo-minor-mode))

  (use-package racer
    :ensure t
    :config
    (add-hook 'rust-mode-hook 'racer-mode)
    (add-hook 'racer-mode-hook 'eldoc-mode)
    (add-hook 'racer-mode-hook #'company-mode))

  (define-key cargo-mode-map (kbd "C-c") 'cargo-minor-mode-command-map)
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (setq company-tooltip-align-annotations t)
  
  (add-hook 'rust-mode-hook 'company-mode)
  (add-hook 'rust-mode-hook 'hs-minor-mode)
  (add-hook 'rust-mode-hook 'smartparens-mode)
  (add-hook 'rust-mode-hook 'smartparens-strict-mode)
  (add-hook 'rust-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-json ()
  (use-package json-mode
    :ensure t)
  
  (add-hook 'json-mode-hook 'hs-minor-mode)
  (add-hook 'json-mode-hook 'smartparens-mode)
  (add-hook 'json-mode-hook 'smartparens-strict-mode)
  (add-hook 'json-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-prolog ()
  (load "~/.emacs.d/prolog.el")
  
  (setq prolog-electric-if-then-else-flag t)

  (add-to-list 'auto-mode-alist '("\\.pl$" . prolog-mode))

  (define-key prolog-mode-map (kbd "C-c C-i") 'run-prolog)
  (define-key prolog-mode-map (kbd "C-c C-c") 'prolog-consult-predicate)
  (define-key prolog-mode-map (kbd "C-c C-r") 'prolog-consult-region)
  (define-key prolog-mode-map (kbd "C-c C-f") 'prolog-consult-file)

  (add-hook 'prolog-mode-hook 'company-mode)
  (add-hook 'prolog-mode-hook 'smartparens-mode)
  (add-hook 'prolog-mode-hook 'smartparens-strict-mode)
  (add-hook 'prolog-mode-hook 'rainbow-delimiters-mode)

  ;; ediprolog

  (load "~/.emacs.d/ediprolog.el")
  (require 'ediprolog)

  (setq ediprolog-system 'scryer)
  (setq ediprolog-program "/home/a7o/scryer-prolog/target/release/scryer-prolog")

  ;; (setq ediprolog-system 'swi)
  ;; (setq ediprolog-program "/usr/bin/swipl")

  (defun ediprolog-cdwim()
    (interactive)
    (ediprolog-consult)
    (ediprolog-dwim))
  
  (define-key prolog-mode-map (kbd "C-<return>") 'ediprolog-dwim)

  (defun ediprolog-comment-prompt () (interactive) (insert "%%?- "))
  (defun ediprolog-clear-output () (interactive) (flush-lines "^%@"))

  (define-key prolog-mode-map (kbd "C-c C-/") 'ediprolog-comment-prompt)
  (define-key prolog-mode-map (kbd "C-c C-c") 'ediprolog-clear-output)
  )

(defun dot-c ()
  (require 'cc-mode)

  (defun gdb-repl-make()
    (interactive)
    (process-send-string "*gud-out*" "kill inferiors 1\n")
    (process-send-string "*gud-out*" "make\n")
    (process-send-string "*gud-out*" "clear\n")
    (process-send-string "*gud-out*" "break main\n")
    (process-send-string "*gud-out*" "run\n"))

  (defun gdb-repl-clean()
    (interactive)
    (process-send-string "*gud-out*" "make clean\n"))

  (defun gdb-repl-send()
    (interactive)
    (process-send-string "*gud-out*"
			 (replace-regexp-in-string "// "
						   "p "
						   (thing-at-point 'line t))))

  (define-key c-mode-map (kbd "C-c C-c") 'gdb-repl-make)
  (define-key c-mode-map (kbd "C-c C-k") 'gdb-repl-clean)
  (define-key c-mode-map (kbd "C-<return>") 'gdb-repl-send)

  (add-hook 'c-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'smartparens-mode)
  (add-hook 'c-mode-hook 'smartparens-strict-mode)
  (add-hook 'c-mode-hook 'rainbow-delimiters-mode)

  ;; in the same dir as the Makefile
  ;; Mx gud-gdb (gdb out)
  ;; Mx rename-buffer *gud-out*

  ;;----------------------------------------------------------------------
  ;; Makefile

  ;; OUT = out
  ;; SRC = $(wildcard *.c)
  ;; OBJ = $(SRC:.c=.o)
  ;; DEP = $(OBJ:.o=.d)

  ;; CC = cc
  ;; CFLAGS = -g -Wall -Wno-char-subscripts -pedantic -ansi -std=c99
  ;; LDFLAGS = -lm

  ;; $(OUT): $(OBJ)
  ;; 	$(CC) $(LDFLAGS) -o $@ $^

  ;; -include $(DEP)

  ;; %.d: %.c
  ;; 	$(CC) $(CFLAGS) $< -MM -MT $(@:.d=.o) > $@

  ;; .PHONY: clean
  ;; clean:
  ;; 	rm -f $(OUT) $(OBJ)

  ;; .PHONY: cleandep
  ;; cleandep:
  ;; 	rm -f $(DEP)

  ;; # ref: http://nuclear.mutantstargoat.com/articles/make
  )

(defun dot-scheme ()
  (setq geiser-guile-binary "/usr/bin/guile")
  (setq geiser-active-implementations '(guile))

  (add-hook 'scheme-mode-hook 'hs-minor-mode)
  (add-hook 'scheme-mode-hook 'smartparens-mode)
  (add-hook 'scheme-mode-hook 'smartparens-strict-mode)
  (add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-erlang ()
  (setq load-path (cons  "/usr/lib64/erlang/lib/tools-2.11.2/emacs"
												 load-path))
  (setq erlang-root-dir "/usr/lib64/erlang")
  (setq exec-path (cons "/usr/lib64/erlang/bin" exec-path))

  (require 'erlang-start)
  (require 'erlang)

  (defun erlang-shell-send-line()
    (interactive)
    (process-send-string "*erlang*"
			 (replace-regexp-in-string "%% " "" (thing-at-point 'line t))))

  (define-key erlang-mode-map (kbd "C-<return>") 'erlang-shell-send-line)

  (add-hook 'erlang-mode-hook 'smartparens-mode)
  (add-hook 'erlang-mode-hook 'smartparens-strict-mode)
  (add-hook 'erlang-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-haskell ()
  (use-package haskell-mode
    :ensure t
    :config
    (require 'haskell-interactive-mode)
    (require 'haskell-process))

  (defun haskell-process-do-eval (line)
    (let ((process (haskell-process)))
      (haskell-process-queue-command
       process
       (make-haskell-command
	:state (list process line)
	:go (lambda (state)
	      (haskell-process-send-string (car state) (cadr state)))
	:complete (lambda (state response)
		    (haskell-interactive-mode-echo
		     (haskell-process-session (car state))
		     response))))))
  
  (defun haskell-interactive-send-line()
    (interactive)
    (haskell-process-do-eval (replace-regexp-in-string "-- " "" (thing-at-point 'line t))))
  
  (define-key haskell-mode-map (kbd "C-<return>") 'haskell-interactive-send-line)
  
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)

  (add-hook 'haskell-mode-hook 'hs-minor-mode)
  (add-hook 'haskell-mode-hook 'smartparens-mode)
  (add-hook 'haskell-mode-hook 'smartparens-strict-mode)
  (add-hook 'haskell-mode-hook 'rainbow-delimiters-mode)
  )

(defun dot-exwm ()
  (use-package exwm
    :ensure t
    :config
    (require 'exwm-config)
    (exwm-config-default)
    (exwm-config-ido)
    (require 'exwm-systemtray)
    (exwm-systemtray-enable))

  (defun exwm-start-process (command)
    (interactive (list (read-shell-command "$ ")))
    (start-process-shell-command command nil command))

  (defun exwm-start-lock ()
    (interactive)
    (start-process "slock" nil "slock"))

  (exwm-input-set-key (kbd "s-SPC") 'exwm-start-process)
  (exwm-input-set-key (kbd "s-<backspace>") 'exwm-start-lock)
  
  (define-key exwm-mode-map (kbd "s-<tab>") 'exwm-input-send-next-key)

  (require 'subr-x) ;; for string-trim function

  (defun xbl-msg (cmd)
    (message
     "%s"
     (string-join
      (list
       (nth 0 (split-string (string-trim (shell-command-to-string cmd)) "\\."))
       "%"))))

  (defun pactl-msg (cmd)
    (message
     "%s"
     (string-trim
      (nth 1
	   (split-string (shell-command-to-string cmd) " / ")))))

  (exwm-input-set-key
   (kbd "<XF86MonBrightnessDown>")
   (lambda ()
     (interactive)
     (xbl-msg "xbacklight -dec 5; xbacklight")))

  (exwm-input-set-key
   (kbd "<XF86MonBrightnessUp>")
   (lambda ()
     (interactive)
     (xbl-msg "xbacklight -inc 5; xbacklight")))

  (exwm-input-set-key
   (kbd "<XF86AudioLowerVolume>")
   (lambda ()
     (interactive)
     (pactl-msg "pactl set-sink-volume 0 -5%; pactl list sinks | grep Volume")))

  (exwm-input-set-key
   (kbd "<XF86AudioRaiseVolume>")
   (lambda ()
     (interactive)
     (pactl-msg "pactl set-sink-volume 0 +5%; pactl list sinks | grep Volume")))

  (exwm-input-set-key
   (kbd "<XF86AudioMute>")
   (lambda ()
     (interactive)
     (message "%s" (shell-command-to-string "pactl set-sink-mute 0 toggle"))))

  ;; init
  (exwm-workspace-switch-create 1)
  (shell "*shell*<1>")
  (delete-other-windows)
  (exwm-workspace-switch-create 2)
  (shell "*shell*<2>")
  (delete-other-windows)
  (exwm-workspace-switch-create 3)
  (shell "*shell*<3>")
  (delete-other-windows)
  (exwm-workspace-switch 1)
  )

(defun dot-spaceline ()
  (use-package fancy-battery
    :ensure t
    :config
    (setq fancy-battery-show-percentage t)
    (add-hook 'after-init-hook 'fancy-battery-mode))

  (use-package spaceline
    :ensure t
    :config
    (require 'spaceline-config)

    ;; redefine buffer-size to show current workspace index
    (spaceline-define-segment buffer-size
      "Current workspace index."
      (format "%s" exwm-workspace-current-index))
    
    (spaceline-toggle-buffer-encoding-abbrev-off)
    (spaceline-toggle-hud-off)
    
    (setq powerline-height 30)
    (setq powerline-default-separator (quote wave))
    (spaceline-emacs-theme))

  (setq display-time-day-and-date 1)
  (display-time-mode 1)
  )

(defun dot-pdf-tools ()
  (use-package pdf-tools
    :ensure t
    :config
    (pdf-tools-install))

  (setq pdf-view-resize-factor 1.1)

  (add-hook 'pdf-view-mode-hook
	    (lambda () (pdf-view-midnight-minor-mode)))

  ;; diminish setup
  ;; (eval-after-load "pdf-view" '(diminish 'pdf-view-midnight-minor-mode))

  ;; spaceline setup
  ;; redefine line-column for pdf-view mode
  ;; (spaceline-define-segment line-column
  ;;   "The current line and column numbers."
  ;;   (if (eq major-mode 'pdf-view-mode)
  ;; 	(concat (number-to-string (pdf-view-current-page))
  ;; 		"/"
  ;; 		(number-to-string (pdf-cache-number-of-pages)))
  ;;     mode-line-position
  ;;     "%l:%2c"))
  )

;;----------------------------------------------------------------------

(progn
  (dot-package)
	(dot-packages)
  (dot-global-keys)
  (dot-look)
	(dot-alias)
  (dot-ido)
  (dot-company)
  (dot-emacs-lisp)
	(dot-sbcl)
;;  (dot-emms)
;;  (dot-org)
;;  (dot-sql)
;;  (dot-python)
;;  (dot-json)
;;  (dot-prolog)
;;  (dot-c)
;;  (dot-rust)
;;  (dot-julia)
;;  (dot-exwm)
;;  (dot-spaceline)
)

;;----------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default))
 '(package-selected-packages
	 '(slime-company slime magit pinentry zenburn-theme yaml-mode use-package spacemacs-theme smartparens rainbow-delimiters org-bullets ido-vertical-mode company beacon)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
