(defun read-puzzle-input (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun parse-password-strategy (strategy)
  (let ((dash-pos (position #\- strategy))
        (space-pos (position #\space strategy)))
    (list
     (parse-integer (subseq strategy 0 dash-pos))
     (parse-integer (subseq strategy (1+ dash-pos) space-pos))
     (elt strategy (1+ space-pos)))))

(defun check-password-1 (password strategy)
  (let ((occurrences (length (remove-if-not (lambda (e) (char= e (third strategy))) password))))
    (and (>= occurrences (first strategy))
         (<= occurrences (second strategy)))))

(defun check-password-2 (password strategy)
  (let ((valid1 (char= (third strategy) (elt password (1- (first strategy)))))
        (valid2 (char= (third strategy) (elt password (1- (second strategy))))))
    (or (and valid1 (not valid2))
        (and valid2 (not valid1)))))

(defun count-valid-passwords (input check)
  (length (remove-if-not
           (lambda (pw)
             (let ((colon-pos (position #\: pw)))
               (funcall check
                        (subseq pw (+ colon-pos 2))
                        (parse-password-strategy (subseq pw 0 colon-pos)))))
           input)))

(defun part1 ()
  (count-valid-passwords (read-puzzle-input "input.txt") #'check-password-1))

(defun part2 ()
  (count-valid-passwords (read-puzzle-input "input.txt") #'check-password-2))
