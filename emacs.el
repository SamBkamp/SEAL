
(defun bkamp/format-main-line()
  (kill-whole-line) 
  (insert "int main(int argc, char* argv[]){\n\n}")
  (backward-char 2)
  (indent-for-tab-command)
  )

(defun bkamp/format-for-line()
  (kill-whole-line)
  (insert "\n")
  (backward-char 1)
  (indent-for-tab-command)
  (insert "for (iterator; condition; increment){}")
  (backward-char 1)
  (insert "\n\n")
  (indent-for-tab-command)
  (previous-line)
  (previous-line)
  (indent-for-tab-command)
  (forward-char 5)
  )


(defun bkamp/format-while-line()
  (kill-whole-line)
  (insert "\n")
  (backward-char 1)
  (indent-for-tab-command)
  (insert "while(condition){\n\n}")
  (indent-for-tab-command)
  (previous-line)
  (previous-line)
  (indent-for-tab-command)
  (forward-char 5)
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
  (backward-char 2)
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
