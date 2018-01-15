
; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; ------------------------------------------------------------------------
;; エラーが起こりそうなことリスト
;; ・rcodetoolsのgemが入っているか、pathが通っているか
;; ・rbenvがインストールされているか
;; ・robe用にpry,pry-doc,method_sourceが入っているか
;; ・jedi用にvirtualenvが入っているか(インストールはpipでよい)
;; ------------------------------------------------------------------------
;; @ load-path

;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path "elisp")

;;環境変数PATHを取得
(setq exec-path (parse-colon-path (getenv "PATH")))

;; ------------------------------------------------------------------------
;; @ general

;; common lisp
(require 'cl)

;; 文字コード
(set-language-environment "Japanese")
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (prefer-coding-system 'utf-8-unix)
         (set-default-coding-systems 'utf-8-unix)
         (setq file-name-coding-system 'sjis)
         (setq locale-coding-system 'utf-8))
        ((eq ws 'ns)
         (require 'ucs-normalize)
         (prefer-coding-system 'utf-8-hfs)
         (setq file-name-coding-system 'utf-8-hfs)
         (setq locale-coding-system 'utf-8-hfs))))

;; スタートアップ非表示
(setq inhibit-startup-screen t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; ツールバー非表示
(tool-bar-mode -1)

;; メニューバーを非表示
;;(menu-bar-mode -1)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; 行番号表示
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#800"
                    :height 0.9)

;; 行番号フォーマット
;;(setq linum-format "%4d")

;; 選択領域の色
(set-face-background 'region "#555")

;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;; 最近使ったファイルをメニューに表示
(recentf-mode t)

;; 最近使ったファイルの表示数
(setq recentf-max-menu-items 10)

;; 最近開いたファイルの保存数を増やす
(setq recentf-max-saved-items 3000)

;; ミニバッファの履歴を保存する
(savehist-mode 1)

;; ミニバッファの履歴の保存数を増やす
(setq history-length 3000)

;; バックアップを残さない
(setq make-backup-files nil)

;; モードラインに行番号表示
(line-number-mode t)

;; モードラインに列番号表示
(column-number-mode t)

;; C-Ret で矩形選択
;; 詳しいキーバインド操作：http://dev.ariel-networks.com/articles/emacs/part5/
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; ------------------------------------------------------------------------
;; @ modeline

;; モードラインの割合表示を総行数表示
(defvar my-lines-page-mode t)
(defvar my-mode-line-format)

(when my-lines-page-mode
  (setq my-mode-line-format "%d")
  (if size-indication-mode
      (setq my-mode-line-format (concat my-mode-line-format " of %%I")))
  (cond ((and (eq line-number-mode t) (eq column-number-mode t))
         (setq my-mode-line-format (concat my-mode-line-format " (%%l,%%c)")))
        ((eq line-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " L%%l")))
        ((eq column-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " C%%c"))))

  (setq mode-line-position
        '(:eval (format my-mode-line-format
                        (count-lines (point-max) (point-min))))))

;; ------------------------------------------------------------------------
;; @ initial frame maximize

;; 起動時にウィンドウ最大化
;; http://www.emacswiki.org/emacs/FullScreen#toc12
(defun jbr-init ()
  "Called from term-setup-hook after the default
   terminal setup is
   done or directly from startup if term-setup-hook not
   used.  The value
   0xF030 is the command for maximizing a window."
  (interactive)
  (w32-send-sys-command #xf030)
  (ecb-redraw-layout)
  (calendar))

;;(let ((ws window-system))
;;  (cond ((eq ws 'w32)
;;         (set-frame-position (selected-frame) 0 0)
;;         (setq term-setup-hook 'jbr-init)
;;         (setq window-setup-hook 'jbr-init))
;;        ((eq ws 'ns)
;;         (set-frame-position (selected-frame) 0 0)
;;         (set-frame-size (selected-frame) 100 50))))

;;バックスペースキー割り当て
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;;; 対応する括弧を光らせる。
(show-paren-mode 1)

;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
(setq ring-bell-function 'ignore)

;;==============================================================
;; set font
;;
;; 英語
 (set-face-attribute 'default nil
             :family "Ricty" ;; font
             :height 200)    ;; font size

;; 日本語
(set-fontset-font
 nil 'japanese-jisx0208
  (font-spec :family "Ricty")) ;; font

;;=============================================================

;;背景色変更
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "#55FF55")))))
 '(cursor ((((class color)
             (background dark))
            (:background "#00AA00"))
           (((class color)
             (background light))
            (:background "#999999"))
           (t ())
           ))


;;マルチスクラッチ
(require 'multi-scratch)
(define-key global-map [?\C-:] 'multi-scratch-new)

;;smart-compile設定
(load "~/.emacs.d/elisp/smart-compile.el")
(require 'smart-compile)
(add-hook 'ruby-mode-hook
          '(lambda ()
  (define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
  (define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-x c C-m"))
))
;;popwin設定
(require 'popwin)
;;(setq display-buffer-function 'popwin:display-buffer)

;;quickrun設定
(require 'quickrun)
(define-key global-map [f5] 'my-quickrun-output-fix)
(push '("*quickrun*") popwin:special-display-config)
(defun my-quickrun-output-fix ()
  (interactive)
  (quickrun)
  (sit-for 0.5)
  (beginning-of-buffer)
  (sit-for 0.5)
  (end-of-buffer)
  )

;;auto-install設定
;(when (require 'auto-install nil t')
;    (setq auto-install-directory "~/.emacs.d/elisp/")
;    (auto-install-update-emacswiki-package-name t)
;    (auto-install-compatibility-setup))

;;melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

 ;; \の代わりにバックスラッシュを入力する
(define-key global-map [?¥] [?\\]) 

;;company
(require 'company)
(global-company-mode) ; 全バッファで有効にする 
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 2) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る


;helmの設定
(require 'helm-config)
(helm-mode 1)

;helmのキーバインド
(global-set-key (kbd "C-c h") 'helm-mini)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)

;;helm-swoop
(require 'helm-swoop)

;cua-mode設定
(cua-mode t)
(setq cua-enable-cua-keys nil)

;ruby-modeのマジックコメントを停止
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-jedi ace-jump-mode undo-tree rbenv robe helm-robe company auto-complete exec-path-from-shell pcre2el visual-regexp-steroids multiple-cursors helm-swoop ruby-electric quickrun helm-git helm)))
 '(ruby-insert-encoding-magic-comment nil))

;外部で変更があった場合自動で読み込む
(global-auto-revert-mode t)

;helmでgitを扱う
;(require 'helm-ls-git)
(put 'upcase-region 'disabled nil)

;org-modeに関する記述
; TODO状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))
; DONEの時刻を記録
(setq org-log-done 'time)
; 見出しの*を消す
(setq org-hide-leading-stars t)

; 自動かっことじ
(electric-pair-mode 1)


;; rbenv
(require 'rbenv)
(global-rbenv-mode)
(setq rbenv-installation-dir "~/.rbenv")

;; inf-ruby
(require 'inf-ruby)
(setq inf-ruby-default-implementation "pry")
(setq inf-ruby-eval-binding "Pry.toplevel_binding")
(add-hook 'inf-ruby-mode-hook 'ansi-color-for-comint-mode-on)

; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
(setq ruby-electric-expand-delimiters-list nil)

;; ruby-block.el --- highlight matching block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;;rcodetools
(require 'rcodetools)
(setq rct-find-tag-if-available nil)
(defun make-ruby-scratch-buffer ()
  (with-current-buffer (get-buffer-create "*ruby scratch*")
    (ruby-mode)
    (current-buffer)))
(defun ruby-scratch ()
  (interactive)
  (pop-to-buffer (make-ruby-scratch-buffer)))
(defun ruby-mode-hook-rcodetools ()
  (define-key ruby-mode-map "\C-c\C-w" 'rct-complete-symbol)
  (define-key ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "\C-c\C-d" 'xmp)
  (define-key ruby-mode-map "\C-c\C-f" 'rct-ri))
(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)

;;robe
(add-hook 'ruby-mode-hook 'robe-mode)
(eval-after-load 'company
  '(push 'company-robe company-backends))

;;python用company
(add-to-list 'exec-path "~/.pyenv/shims")
(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi) ; backendに追加


;; 正規表現
(require 'visual-regexp-steroids)
(setq vr/engine 'python) ; 'python, 'pcre2el, or 'emacs
;; python が インストールされてない環境では、上１行をコメントアウト、下２行をコメント解除
;; (setq vr/engine 'pcre2el)
;; (require 'pcre2el)
(define-key global-map (kbd "M-%") 'vr/query-replace)

;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; ace jump mode
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c s") 'ace-jump-char-mode)
