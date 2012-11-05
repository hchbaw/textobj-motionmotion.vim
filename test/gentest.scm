(use gauche.experimental.lamb)
(use util.match)

(define (%print-count-testloop-calls hi lo)
  (print #`"call s:testloop(\",|hi|,|lo|\", \",|hi|\", \",|lo|\")")
  (print #`"call s:testloop(\",|hi|20,|lo|\", \",|hi|\", \"20,|lo|\")")
  (print #`"call s:testloop(\"20,|hi|,|lo|\", \"20,|hi|\", \",|lo|\")")
  (print #`"call s:testloop(\"20,|hi|20,|lo|\", \"20,|hi|\", \"20,|lo|\")"))

(define (%print-testloop-calls hi lo)
  (print #`"call s:testloop(\",|hi|,|lo|\", \",|hi|\", \",|lo|\")"))

(define string-commandsify (cut string-split <> #/\s+/))
(define commands-stringify (cut string-join <> " "))

(define (print-testloop-calls-raw printproc mix)
  (define commands (string-commandsify mix))
  (define loop
    ;; (a b c ... z) = (a b) ⇒ (b c) ⇒ (c … z) ⇒ (z a)
    (^. ((and (a b . _) (_ . xs))
         (printproc a b)
         (loop xs))
        ((a)
         (printproc a (car commands)))))

  (loop commands))

(define-values (print-count-testloop-calls print-testloop-calls)
  (let1 p print-testloop-calls-raw
    (values (pa$ p %print-count-testloop-calls)
            (pa$ p %print-testloop-calls))))

(print-count-testloop-calls "h l $ |")
(print-testloop-calls "0 ^ g0 g^ gm")
(print-count-testloop-calls "fa Fa ta Ta")
(print-count-testloop-calls "k j - + _ G gg % gk gj")
(print-count-testloop-calls "w W e E b B ge gE ) ( } {")
(print-count-testloop-calls "]] [[ ][ [] [( [{ [m [M")
(print-count-testloop-calls "]( ]{ ]m ]M [# ]# [* ]*")
(print-count-testloop-calls "n N * # g* g# gd gD")
(let ((ms (string-commandsify "a A 0 ` \" [ ] < > ."))
      (scat (^(a b) #`",|a|,|b|"))
      (prs (.$ print-testloop-calls commands-stringify)))
  (prs `("ma" ,@(map (pa$ scat "`") ms)))
  (prs (map (pa$ scat "'") ms)))
(print-count-testloop-calls "\\<c-o> \\<c-i>")
(print-testloop-calls "% M")
(print-count-testloop-calls "H L go")

