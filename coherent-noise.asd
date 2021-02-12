(asdf:defsystem #:coherent-noise
  :description ""
  :author ("Michael Fiano <mail@mfiano.net>")
  :license "MIT"
  :homepage "https://mfiano.net/projects/coherent-noise"
  :source-control (:git "https://github.com/mfiano/coherent-noise.git")
  :encoding :utf-8
  :depends-on (#:cl-cpus
               #:lparallel
               #:golden-utils
               #:seedable-rng
               #:zpng
               #:uiop)
  :pathname "src"
  :serial t
  :components
  ((:file "package")
   (:file "conditions")
   (:file "common")
   (:module "generators"
    :components
    ((:file "perlin-1d")
     (:file "perlin-2d")
     (:file "perlin-3d")
     (:file "perlin-4d")
     (:file "simplex-1d")
     (:file "simplex-2d")
     (:file "simplex-3d")
     (:file "simplex-4d")
     (:file "open-simplex-2d")
     (:file "open-simplex-3d")
     (:file "open-simplex-4d")
     (:file "open-simplex2f-2d")
     (:file "open-simplex2f-3d")
     (:file "open-simplex2f-4d")
     (:file "value-2d")
     (:file "value-3d")
     (:file "cellular-2d")
     (:file "cellular-3d")
     (:file "misc")))
   (:module "api"
    :components
    ((:file "api")
     (:file "modifiers")
     (:file "package")))))
