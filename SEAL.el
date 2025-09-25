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

(defun bkamp/format-for-line()
  (interactive)
  (kill-whole-line)
  (insert "for (iterator; condition; increment){\n\n}")
  (forward-line -1)
  (indent-for-tab-command)
  )


(defun bkamp/format-while-line()
  (interactive)
  (kill-whole-line)
  (insert "while(condition){\n\n}")
  (forward-line -1)
  (indent-for-tab-command)
  )


(defun int-main ()
  (interactive)
  (if (string= (thing-at-point 'line) "main")
      (bkamp/format-main-line)
    (if (string= (thing-at-point 'line) "main\n")
	(bkamp/format-main-line)
      (if (string= (current-word) "forc")
	  (bkamp/format-for-line)
	(if (string= (current-word) "whilec")
	    (bkamp/format-while-line)
	  (indent-for-tab-command)
	  )
	)
      )
    )
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

(add-hook 'c-initialization-hook
  (lambda () (define-key c-mode-base-map "(" 'closing-bracket)))

(add-hook 'c-initialization-hook
  (lambda () (define-key c-mode-base-map "{" 'closing-brace)))


(add-hook 'c-initialization-hook
  (lambda () (define-key c-mode-base-map (kbd "TAB") 'int-main)))

(add-hook 'c-initialization-hook
  (lambda () (define-key c-mode-base-map (kbd "[") 'sq_bracket)))


(defun rofrol/indent-region(numSpaces)
    (progn 
        ; default to start and end of current line
        (setq regionStart (line-beginning-position))
        (setq regionEnd (line-end-position))

        ; if there's a selection, use that instead of the current line
        (when (use-region-p)
            (setq regionStart (region-beginning))
            (setq regionEnd (region-end))
        )

        (save-excursion ; restore the position afterwards            
            (goto-char regionStart) ; go to the start of region
            (setq start (line-beginning-position)) ; save the start of the line
            (goto-char regionEnd) ; go to the end of region
            (setq end (line-end-position)) ; save the end of the line

            (indent-rigidly start end numSpaces) ; indent between start and end
            (setq deactivate-mark nil) ; restore the selected region
        )
    )
)

(defun rofrol/indent-lines(&optional N)
    (interactive "p")
    (indent-rigidly (line-beginning-position)
                    (line-end-position)
                    (* (or N 1) tab-width)))

(defun rofrol/untab-region (&optional N)
    (interactive "p")
    (rofrol/indent-region (* (* (or N 1) tab-width)-1)))

(defun  rofrol/tab-region (N)
    (interactive "p")
    (if (use-region-p)
        (rofrol/indent-region (* (or N 1) tab-width)) ; region was selected, call indent-region
        (rofrol/indent-lines N); else insert spaces as expected
    ))

(global-set-key (kbd "C->") 'rofrol/tab-region)
(global-set-key (kbd "C-<") 'rofrol/untab-region)


;;; SEAL.el ends here

(provide 'SEAL)
