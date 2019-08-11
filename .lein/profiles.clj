{:user {:ultra {:color-scheme :solarized_dark
                :stacktraces  true
                :repl true
                :java true
                :tests true}
        :plugins [[lein-ancient "0.6.15"]]
        :repl-options {:init (set! *print-length* 42)}
        :dependencies [[pjstadig/humane-test-output "0.8.3"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]}}
