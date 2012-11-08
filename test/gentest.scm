(use gauche.experimental.lamb)
(use util.match)

(define (%print-count-testloop-calls hi lo hi2 lo2)
  (print #`"call s:testloopbuiltin(\",|hi|,|lo|\", \",|hi2|\", \",|lo2|\")")
  (print #`"call s:testloopbuiltin(\",|hi|20,|lo|\", \",|hi2|\", \"20,|lo2|\")")
  (print #`"call s:testloopbuiltin(\"20,|hi|,|lo|\", \"20,|hi2|\", \",|lo2|\")")
  (print #`"call s:testloopbuiltin(\"20,|hi|20,|lo|\", \"20,|hi2|\", \"20,|lo2|\")"))

(define (%print-testloop-calls hi lo hi2 lo2)
  (print #`"call s:testloopbuiltin(\",|hi|,|lo|\", \",|hi2|\", \",|lo2|\")"))

(define string-commandsify (cut string-split <> #/\s+/))
(define commands-stringify (cut string-join <> " "))

(define (print-testloop-calls-raw printproc genok mix)
  (define commands (string-commandsify mix))
  (define loop
    ;; (a b c ... z) = (a b) ⇒ (b c) ⇒ (c … z) ⇒ (z a)
    (^. ((and (a b . _) (_ . xs))
         (printproc a b (genok a) (genok b))
         (loop xs))
        ((a)
         (printproc a (car commands) (genok a) (genok (car commands))))))

  (loop commands))

(define-values (print-count-testloop-calls print-testloop-calls)
  (let1 p print-testloop-calls-raw
    (values (pa$ p %print-count-testloop-calls)
            (pa$ p %print-testloop-calls))))

(define (scat a b) #`",|a|,|b|")

(print-count-testloop-calls values "h l $ |")
(print-testloop-calls values "0 ^ g0 g^ gm")
(print-count-testloop-calls values "fa Fa ta Ta")
(print-count-testloop-calls values "k j - + _ G gg % gk gj")
(print-count-testloop-calls values "w W e E b B ge gE ) ( } {")
(print-count-testloop-calls values "]] [[ ][ [] [( [{ [m [M")
(print-count-testloop-calls values "]( ]{ ]m ]M [# ]# [* ]*")
(print-count-testloop-calls values "n N * # g* g# gd gD")
(let ((ms (string-commandsify "a A 0 ` \" [ ] < > ."))
      (prs (.$ (pa$ print-testloop-calls values) commands-stringify)))
  (prs `("ma" ,@(map (pa$ scat "`") ms)))
  (prs (map (pa$ scat "'") ms)))
(print-count-testloop-calls values "\\<c-o> \\<c-i>")
(print-testloop-calls values "% M")
(print-count-testloop-calls values "H L go")
(let ((ms (string-commandsify "w W s p ] [ ) ( b > < t } {  B \" ' `"))
      (prs (.$ (pa$ print-testloop-calls (pa$ scat "g@"))
               commands-stringify)))
  (prs (map (pa$ scat "a") ms))
  (prs (map (pa$ scat "i") ms)))
