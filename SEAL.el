;;; SEAL.el --- Sam's EmAcs pLugin 
;;
;; Filename: SEAL.el
;; Package-Requires: ()
;; Version: 1
;; Package-Version: 1
;;
;; Description: Sam's emacs config stuff
;; Author: Sam Bonnekamp
;; Maintainer: Sam Bonnekamp
;; Created: Wed Sep 25 2025 (+0800)
;; Last-Updated: Wed Sep 25 2025 (+0800)
;; Keywords: config
;; Compatibility: GNU Emacs: 21.x, 22.x, 23.x
;;
;; Features that might be required by this library:
;;
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;; Code:


(defun bkamp/format-main-line()
  (kill-whole-line)
  (save-excursion
    (goto-char (point-min))
    (insert "#include <stdio.h>\n#include <stdlib.h>\n")
    )
  (if (< (line-number-at-pos) 4)
      (progn
       (forward-line 2)
       (dotimes (i (- 4 (line-number-at-pos)))
	(insert "\n")
	))
    )
  (insert "int main(int argc, char* argv[]){\n\n}")
  (backward-char 2)
  (indent-for-tab-command)
  )

(defun bkamp/format-for-line ()
  (interactive)
  (forward-char -1)
  (delete-char 1)
  (insert "(iterator; condition; increment){ }")
  )


(defun bkamp/format-while-line ()
  (interactive)
  (forward-char -1)
  (delete-char 1)
  (insert "(condition){ }")
  )


(defun int-main ()
  (interactive)
  (if (or (string= (thing-at-point 'line) "main") (string= (thing-at-point 'line) "main\n"))
      (bkamp/format-main-line))
  (if (string= (current-word) "forc")
      (bkamp/format-for-line))
  (if (string= (current-word) "whilec")
      (bkamp/format-while-line))
  (indent-for-tab-command)
  )

(defun closing-brace ()
  (interactive)
  (save-excursion
    (insert "{}")
    )
  (forward-char 1)
)
  
(defun closing-bracket ()
  (interactive)
  (insert "()")
  (backward-char 1))

(defun sq_bracket ()
  (interactive)
  (insert "[]")
  (forward-char 1)
  ;might remove the semi colon if it doesn't work.
  )

(defun SEAL-c-mode-setup ()
  (define-key (current-local-map) "(" 'closing-bracket)
  (define-key (current-local-map) "{" 'closing-brace)
  (define-key (current-local-map) (kbd "TAB") 'int-main)
  (define-key (current-local-map) (kbd "[") 'sq_bracket)
  )

(add-hook 'c-mode-common-hook 'SEAL-c-mode-setup)


;;; SEAL.el ends here

(provide 'SEAL)
