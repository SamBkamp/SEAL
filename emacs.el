(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (deeper-blue))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun int-main ()
  (interactive)
  (if (string= (thing-at-point 'line) "main")
      (insert "int main(int argc, char* argv[]){\n}")
    (indent-for-tab-command)))

(defun closing-brace ()
  (interactive)
  (insert "{\n}")
  (backward-char 2))


(defun closing-bracket ()
  (interactive)
  (insert "()")
  (backward-char 1))


(add-hook 'c-initialization-hook
  (lambda () (define-key c-mode-base-map "(" 'closing-bracket)))

(add-hook 'c-initialization-hook
  (lambda () (define-key c-mode-base-map "{" 'closing-brace)))


(add-hook 'c-initialization-hook
  (lambda () (define-key c-mode-base-map (kbd "TAB") 'int-main)))
