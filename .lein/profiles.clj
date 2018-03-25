{:user {:ultra {:color-scheme :solarized_dark
                :stacktraces  true
                :repl true
                :java true
                :tests true}
        :plugins [[lein-try "0.4.3"]
                  [lein-ancient "0.6.10-SNAPSHOT"]
                  [lein-kibit "0.1.2"]
                  [jonase/eastwood "0.2.3"]
                  ;[venantius/ultra "0.5.1"]
                 ]
        :repl-options {:init (set! *print-length* 42)}
	}}
