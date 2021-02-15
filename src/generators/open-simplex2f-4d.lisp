(in-package #:cl-user)

(defpackage #:coherent-noise.generators.open-simplex2f-4d
  (:local-nicknames
   (#:int #:coherent-noise.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl)
  (:export #:open-simplex2f-4d))

(in-package #:coherent-noise.generators.open-simplex2f-4d)

(u:eval-always
  (defstruct (lattice-point
              (:constructor %make-lattice-point)
              (:conc-name nil)
              (:predicate nil)
              (:copier nil))
    (xsv 0 :type u:b32)
    (ysv 0 :type u:b32)
    (zsv 0 :type u:b32)
    (wsv 0 :type u:b32)
    (dx 0d0 :type u:f64)
    (dy 0d0 :type u:f64)
    (dz 0d0 :type u:f64)
    (dw 0d0 :type u:f64)
    (xsi 0 :type u:f64)
    (ysi 0 :type u:f64)
    (zsi 0 :type u:f64)
    (wsi 0 :type u:f64)
    (ssi-delta 0d0 :type u:f64))

  (defun make-lattice-point (xsv ysv zsv wsv)
    (let ((ssv (* (+ xsv ysv zsv wsv) 0.309016994374947d0)))
      (%make-lattice-point :xsv (+ xsv 409)
                           :ysv (+ ysv 409)
                           :zsv (+ zsv 409)
                           :wsv (+ wsv 409)
                           :dx (- (- xsv) ssv)
                           :dy (- (- ysv) ssv)
                           :dz (- (- zsv) ssv)
                           :dw (- (- wsv) ssv)
                           :xsi (- 0.2d0 xsv)
                           :ysi (- 0.2d0 ysv)
                           :zsi (- 0.2d0 zsv)
                           :wsi (- 0.2d0 wsv)
                           :ssi-delta (* (- 0.8 xsv ysv zsv wsv) 0.309016994374947d0)))))

(u:define-constant +lookup+
    (let ((table (make-array 16)))
      (dotimes (i 16)
        (let ((xsv (logand i 1))
              (ysv (logand (ash i -1) 1))
              (zsv (logand (ash i -2) 1))
              (wsv (logand (ash i -3) 1)))
          (setf (aref table i) (make-lattice-point xsv ysv zsv wsv))))
      table)
  :test #'equalp)

(u:define-constant +gradients+
    (let ((gradients #(#(-81.86373337167335d0 -41.25921575029163d0
                         -41.25921575029163d0 -41.25921575029163d0)
                       #(-84.99633945511172d0 -46.96039101846709d0
                         -46.96039101846709d0 13.179723993791775d0)
                       #(-84.99633945511172d0 -46.96039101846709d0
                         13.179723993791775d0 -46.96039101846709d0)
                       #(-84.99633945511172d0 13.179723993791775d0
                         -46.96039101846709d0 -46.96039101846709d0)
                       #(-93.30749894107312d0 -55.27155050442849d0
                         4.868564507830381d0 4.868564507830381d0)
                       #(-93.30749894107312d0 4.868564507830381d0
                         -55.27155050442849d0 4.868564507830381d0)
                       #(-93.30749894107312d0 4.868564507830381d0
                         4.868564507830381d0 -55.27155050442849d0)
                       #(-108.48097067001083d0 -3.6750735606247997d0
                         -3.6750735606247997d0 -3.6750735606247997d0)
                       #(-41.25921575029163d0 -81.86373337167335d0
                         -41.25921575029163d0 -41.25921575029163d0)
                       #(-46.96039101846709d0 -84.99633945511172d0
                         -46.96039101846709d0 13.179723993791775d0)
                       #(-46.96039101846709d0 -84.99633945511172d0
                         13.179723993791775d0 -46.96039101846709d0)
                       #(13.179723993791775d0 -84.99633945511172d0
                         -46.96039101846709d0 -46.96039101846709d0)
                       #(-55.27155050442849d0 -93.30749894107312d0
                         4.868564507830381d0 4.868564507830381d0)
                       #(4.868564507830381d0 -93.30749894107312d0
                         -55.27155050442849d0 4.868564507830381d0)
                       #(4.868564507830381d0 -93.30749894107312d0
                         4.868564507830381d0 -55.27155050442849d0)
                       #(-3.6750735606247997d0 -108.48097067001083d0
                         -3.6750735606247997d0 -3.6750735606247997d0)
                       #(-41.25921575029163d0 -41.25921575029163d0
                         -81.86373337167335d0 -41.25921575029163d0)
                       #(-46.96039101846709d0 -46.96039101846709d0
                         -84.99633945511172d0 13.179723993791775d0)
                       #(-46.96039101846709d0 13.179723993791775d0
                         -84.99633945511172d0 -46.96039101846709d0)
                       #(13.179723993791775d0 -46.96039101846709d0
                         -84.99633945511172d0 -46.96039101846709d0)
                       #(-55.27155050442849d0 4.868564507830381d0
                         -93.30749894107312d0 4.868564507830381d0)
                       #(4.868564507830381d0 -55.27155050442849d0
                         -93.30749894107312d0 4.868564507830381d0)
                       #(4.868564507830381d0 4.868564507830381d0
                         -93.30749894107312d0 -55.27155050442849d0)
                       #(-3.6750735606247997d0 -3.6750735606247997d0
                         -108.48097067001083d0 -3.6750735606247997d0)
                       #(-41.25921575029163d0 -41.25921575029163d0
                         -41.25921575029163d0 -81.86373337167335d0)
                       #(-46.96039101846709d0 -46.96039101846709d0
                         13.179723993791775d0 -84.99633945511172d0)
                       #(-46.96039101846709d0 13.179723993791775d0
                         -46.96039101846709d0 -84.99633945511172d0)
                       #(13.179723993791775d0 -46.96039101846709d0
                         -46.96039101846709d0 -84.99633945511172d0)
                       #(-55.27155050442849d0 4.868564507830381d0
                         4.868564507830381d0 -93.30749894107312d0)
                       #(4.868564507830381d0 -55.27155050442849d0
                         4.868564507830381d0 -93.30749894107312d0)
                       #(4.868564507830381d0 4.868564507830381d0
                         -55.27155050442849d0 -93.30749894107312d0)
                       #(-3.6750735606247997d0 -3.6750735606247997d0
                         -3.6750735606247997d0 -108.48097067001083d0)
                       #(-73.24258499101933d0 -35.20663655437469d0
                         -35.20663655437469d0 62.96942689452883d0)
                       #(-81.55374447698073d0 -43.51779604033608d0
                         16.62231897192279d0 54.65826740856744d0)
                       #(-81.55374447698073d0 16.62231897192279d0
                         -43.51779604033608d0 54.65826740856744d0)
                       #(-95.93348467660688d0 8.872412432779166d0
                         8.872412432779166d0 49.476930054160874d0)
                       #(-49.476930054160874d0 -8.872412432779166d0
                         -8.872412432779166d0 95.93348467660688d0)
                       #(-54.65826740856744d0 -16.62231897192279d0
                         43.51779604033608d0 81.55374447698073d0)
                       #(-54.65826740856744d0 43.51779604033608d0
                         -16.62231897192279d0 81.55374447698073d0)
                       #(-62.96942689452883d0 35.20663655437469d0
                         35.20663655437469d0 73.24258499101933d0)
                       #(-35.20663655437469d0 -73.24258499101933d0
                         -35.20663655437469d0 62.96942689452883d0)
                       #(-43.51779604033608d0 -81.55374447698073d0
                         16.62231897192279d0 54.65826740856744d0)
                       #(16.62231897192279d0 -81.55374447698073d0
                         -43.51779604033608d0 54.65826740856744d0)
                       #(8.872412432779166d0 -95.93348467660688d0
                         8.872412432779166d0 49.476930054160874d0)
                       #(-8.872412432779166d0 -49.476930054160874d0
                         -8.872412432779166d0 95.93348467660688d0)
                       #(-16.62231897192279d0 -54.65826740856744d0
                         43.51779604033608d0 81.55374447698073d0)
                       #(43.51779604033608d0 -54.65826740856744d0
                         -16.62231897192279d0 81.55374447698073d0)
                       #(35.20663655437469d0 -62.96942689452883d0
                         35.20663655437469d0 73.24258499101933d0)
                       #(-35.20663655437469d0 -35.20663655437469d0
                         -73.24258499101933d0 62.96942689452883d0)
                       #(-43.51779604033608d0 16.62231897192279d0
                         -81.55374447698073d0 54.65826740856744d0)
                       #(16.62231897192279d0 -43.51779604033608d0
                         -81.55374447698073d0 54.65826740856744d0)
                       #(8.872412432779166d0 8.872412432779166d0
                         -95.93348467660688d0 49.476930054160874d0)
                       #(-8.872412432779166d0 -8.872412432779166d0
                         -49.476930054160874d0 95.93348467660688d0)
                       #(-16.62231897192279d0 43.51779604033608d0
                         -54.65826740856744d0 81.55374447698073d0)
                       #(43.51779604033608d0 -16.62231897192279d0
                         -54.65826740856744d0 81.55374447698073d0)
                       #(35.20663655437469d0 35.20663655437469d0
                         -62.96942689452883d0 73.24258499101933d0)
                       #(-73.24258499101933d0 -35.20663655437469d0
                         62.96942689452883d0 -35.20663655437469d0)
                       #(-81.55374447698073d0 -43.51779604033608d0
                         54.65826740856744d0 16.62231897192279d0)
                       #(-81.55374447698073d0 16.62231897192279d0
                         54.65826740856744d0 -43.51779604033608d0)
                       #(-95.93348467660688d0 8.872412432779166d0
                         49.476930054160874d0 8.872412432779166d0)
                       #(-49.476930054160874d0 -8.872412432779166d0
                         95.93348467660688d0 -8.872412432779166d0)
                       #(-54.65826740856744d0 -16.62231897192279d0
                         81.55374447698073d0 43.51779604033608d0)
                       #(-54.65826740856744d0 43.51779604033608d0
                         81.55374447698073d0 -16.62231897192279d0)
                       #(-62.96942689452883d0 35.20663655437469d0
                         73.24258499101933d0 35.20663655437469d0)
                       #(-35.20663655437469d0 -73.24258499101933d0
                         62.96942689452883d0 -35.20663655437469d0)
                       #(-43.51779604033608d0 -81.55374447698073d0
                         54.65826740856744d0 16.62231897192279d0)
                       #(16.62231897192279d0 -81.55374447698073d0
                         54.65826740856744d0 -43.51779604033608d0)
                       #(8.872412432779166d0 -95.93348467660688d0
                         49.476930054160874d0 8.872412432779166d0)
                       #(-8.872412432779166d0 -49.476930054160874d0
                         95.93348467660688d0 -8.872412432779166d0)
                       #(-16.62231897192279d0 -54.65826740856744d0
                         81.55374447698073d0 43.51779604033608d0)
                       #(43.51779604033608d0 -54.65826740856744d0
                         81.55374447698073d0 -16.62231897192279d0)
                       #(35.20663655437469d0 -62.96942689452883d0
                         73.24258499101933d0 35.20663655437469d0)
                       #(-35.20663655437469d0 -35.20663655437469d0
                         62.96942689452883d0 -73.24258499101933d0)
                       #(-43.51779604033608d0 16.62231897192279d0
                         54.65826740856744d0 -81.55374447698073d0)
                       #(16.62231897192279d0 -43.51779604033608d0
                         54.65826740856744d0 -81.55374447698073d0)
                       #(8.872412432779166d0 8.872412432779166d0
                         49.476930054160874d0 -95.93348467660688d0)
                       #(-8.872412432779166d0 -8.872412432779166d0
                         95.93348467660688d0 -49.476930054160874d0)
                       #(-16.62231897192279d0 43.51779604033608d0
                         81.55374447698073d0 -54.65826740856744d0)
                       #(43.51779604033608d0 -16.62231897192279d0
                         81.55374447698073d0 -54.65826740856744d0)
                       #(35.20663655437469d0 35.20663655437469d0
                         73.24258499101933d0 -62.96942689452883d0)
                       #(-73.24258499101933d0 62.96942689452883d0
                         -35.20663655437469d0 -35.20663655437469d0)
                       #(-81.55374447698073d0 54.65826740856744d0
                         -43.51779604033608d0 16.62231897192279d0)
                       #(-81.55374447698073d0 54.65826740856744d0
                         16.62231897192279d0 -43.51779604033608d0)
                       #(-95.93348467660688d0 49.476930054160874d0
                         8.872412432779166d0 8.872412432779166d0)
                       #(-49.476930054160874d0 95.93348467660688d0
                         -8.872412432779166d0 -8.872412432779166d0)
                       #(-54.65826740856744d0 81.55374447698073d0
                         -16.62231897192279d0 43.51779604033608d0)
                       #(-54.65826740856744d0 81.55374447698073d0
                         43.51779604033608d0 -16.62231897192279d0)
                       #(-62.96942689452883d0 73.24258499101933d0
                         35.20663655437469d0 35.20663655437469d0)
                       #(-35.20663655437469d0 62.96942689452883d0
                         -73.24258499101933d0 -35.20663655437469d0)
                       #(-43.51779604033608d0 54.65826740856744d0
                         -81.55374447698073d0 16.62231897192279d0)
                       #(16.62231897192279d0 54.65826740856744d0
                         -81.55374447698073d0 -43.51779604033608d0)
                       #(8.872412432779166d0 49.476930054160874d0
                         -95.93348467660688d0 8.872412432779166d0)
                       #(-8.872412432779166d0 95.93348467660688d0
                         -49.476930054160874d0 -8.872412432779166d0)
                       #(-16.62231897192279d0 81.55374447698073d0
                         -54.65826740856744d0 43.51779604033608d0)
                       #(43.51779604033608d0 81.55374447698073d0
                         -54.65826740856744d0 -16.62231897192279d0)
                       #(35.20663655437469d0 73.24258499101933d0
                         -62.96942689452883d0 35.20663655437469d0)
                       #(-35.20663655437469d0 62.96942689452883d0
                         -35.20663655437469d0 -73.24258499101933d0)
                       #(-43.51779604033608d0 54.65826740856744d0
                         16.62231897192279d0 -81.55374447698073d0)
                       #(16.62231897192279d0 54.65826740856744d0
                         -43.51779604033608d0 -81.55374447698073d0)
                       #(8.872412432779166d0 49.476930054160874d0
                         8.872412432779166d0 -95.93348467660688d0)
                       #(-8.872412432779166d0 95.93348467660688d0
                         -8.872412432779166d0 -49.476930054160874d0)
                       #(-16.62231897192279d0 81.55374447698073d0
                         43.51779604033608d0 -54.65826740856744d0)
                       #(43.51779604033608d0 81.55374447698073d0
                         -16.62231897192279d0 -54.65826740856744d0)
                       #(35.20663655437469d0 73.24258499101933d0
                         35.20663655437469d0 -62.96942689452883d0)
                       #(62.96942689452883d0 -73.24258499101933d0
                         -35.20663655437469d0 -35.20663655437469d0)
                       #(54.65826740856744d0 -81.55374447698073d0
                         -43.51779604033608d0 16.62231897192279d0)
                       #(54.65826740856744d0 -81.55374447698073d0
                         16.62231897192279d0 -43.51779604033608d0)
                       #(49.476930054160874d0 -95.93348467660688d0
                         8.872412432779166d0 8.872412432779166d0)
                       #(95.93348467660688d0 -49.476930054160874d0
                         -8.872412432779166d0 -8.872412432779166d0)
                       #(81.55374447698073d0 -54.65826740856744d0
                         -16.62231897192279d0 43.51779604033608d0)
                       #(81.55374447698073d0 -54.65826740856744d0
                         43.51779604033608d0 -16.62231897192279d0)
                       #(73.24258499101933d0 -62.96942689452883d0
                         35.20663655437469d0 35.20663655437469d0)
                       #(62.96942689452883d0 -35.20663655437469d0
                         -73.24258499101933d0 -35.20663655437469d0)
                       #(54.65826740856744d0 -43.51779604033608d0
                         -81.55374447698073d0 16.62231897192279d0)
                       #(54.65826740856744d0 16.62231897192279d0
                         -81.55374447698073d0 -43.51779604033608d0)
                       #(49.476930054160874d0 8.872412432779166d0
                         -95.93348467660688d0 8.872412432779166d0)
                       #(95.93348467660688d0 -8.872412432779166d0
                         -49.476930054160874d0 -8.872412432779166d0)
                       #(81.55374447698073d0 -16.62231897192279d0
                         -54.65826740856744d0 43.51779604033608d0)
                       #(81.55374447698073d0 43.51779604033608d0
                         -54.65826740856744d0 -16.62231897192279d0)
                       #(73.24258499101933d0 35.20663655437469d0
                         -62.96942689452883d0 35.20663655437469d0)
                       #(62.96942689452883d0 -35.20663655437469d0
                         -35.20663655437469d0 -73.24258499101933d0)
                       #(54.65826740856744d0 -43.51779604033608d0
                         16.62231897192279d0 -81.55374447698073d0)
                       #(54.65826740856744d0 16.62231897192279d0
                         -43.51779604033608d0 -81.55374447698073d0)
                       #(49.476930054160874d0 8.872412432779166d0
                         8.872412432779166d0 -95.93348467660688d0)
                       #(95.93348467660688d0 -8.872412432779166d0
                         -8.872412432779166d0 -49.476930054160874d0)
                       #(81.55374447698073d0 -16.62231897192279d0
                         43.51779604033608d0 -54.65826740856744d0)
                       #(81.55374447698073d0 43.51779604033608d0
                         -16.62231897192279d0 -54.65826740856744d0)
                       #(73.24258499101933d0 35.20663655437469d0
                         35.20663655437469d0 -62.96942689452883d0)
                       #(3.6750735606247997d0 3.6750735606247997d0
                         3.6750735606247997d0 108.48097067001083d0)
                       #(-4.868564507830381d0 -4.868564507830381d0
                         55.27155050442849d0 93.30749894107312d0)
                       #(-4.868564507830381d0 55.27155050442849d0
                         -4.868564507830381d0 93.30749894107312d0)
                       #(-13.179723993791775d0 46.96039101846709d0
                         46.96039101846709d0 84.99633945511172d0)
                       #(55.27155050442849d0 -4.868564507830381d0
                         -4.868564507830381d0 93.30749894107312d0)
                       #(46.96039101846709d0 -13.179723993791775d0
                         46.96039101846709d0 84.99633945511172d0)
                       #(46.96039101846709d0 46.96039101846709d0
                         -13.179723993791775d0 84.99633945511172d0)
                       #(41.25921575029163d0 41.25921575029163d0
                         41.25921575029163d0 81.86373337167335d0)
                       #(3.6750735606247997d0 3.6750735606247997d0
                         108.48097067001083d0 3.6750735606247997d0)
                       #(-4.868564507830381d0 4.868564507830381d0
                         93.30749894107312d0 55.27155050442849d0)
                       #(-4.868564507830381d0 55.27155050442849d0
                         93.30749894107312d0 -4.868564507830381d0)
                       #(-13.179723993791775d0 46.96039101846709d0
                         84.99633945511172d0 46.96039101846709d0)
                       #(55.27155050442849d0 -4.868564507830381d0
                         93.30749894107312d0 -4.868564507830381d0)
                       #(46.96039101846709d0 -13.179723993791775d0
                         84.99633945511172d0 46.96039101846709d0)
                       #(46.96039101846709d0 46.96039101846709d0
                         84.99633945511172d0 -13.179723993791775d0)
                       #(41.25921575029163d0 41.25921575029163d0
                         81.86373337167335d0 41.25921575029163d0)
                       #(3.6750735606247997d0 108.48097067001083d0
                         3.6750735606247997d0 3.6750735606247997d0)
                       #(-4.868564507830381d0 93.30749894107312d0
                         -4.868564507830381d0 55.27155050442849d0)
                       #(-4.868564507830381d0 93.30749894107312d0
                         55.27155050442849d0 -4.868564507830381d0)
                       #(-13.179723993791775d0 84.99633945511172d0
                         46.96039101846709d0 46.96039101846709d0)
                       #(55.27155050442849d0 93.30749894107312d0
                         -4.868564507830381d0 -4.868564507830381d0)
                       #(46.96039101846709d0 84.99633945511172d0
                         -13.179723993791775d0 46.96039101846709d0)
                       #(46.96039101846709d0 84.99633945511172d0
                         46.96039101846709d0 -13.179723993791775d0)
                       #(41.25921575029163d0 81.86373337167335d0
                         41.25921575029163d0 41.25921575029163d0)
                       #(108.48097067001083d0 3.6750735606247997d0
                         3.6750735606247997d0 3.6750735606247997d0)
                       #(93.30749894107312d0 -4.868564507830381d0
                         -4.868564507830381d0 55.27155050442849d0)
                       #(93.30749894107312d0 -4.868564507830381d0
                         55.27155050442849d0 -4.868564507830381d0)
                       #(84.99633945511172d0 -13.179723993791775d0
                         46.96039101846709d0 46.96039101846709d0)
                       #(93.30749894107312d0 55.27155050442849d0
                         -4.868564507830381d0 -4.868564507830381d0)
                       #(84.99633945511172d0 46.96039101846709d0
                         -13.179723993791775d0 46.96039101846709d0)
                       #(84.99633945511172d0 46.96039101846709d0
                         46.96039101846709d0 -13.179723993791775d0)
                       #(81.86373337167335d0 41.25921575029163d0
                         41.25921575029163d0 41.25921575029163d0)))
          (table (make-array 8192 :element-type 'u:f64)))
      (dotimes (i 2048)
        (setf (aref table (* i 4)) (aref (aref gradients (mod i 160)) 0)
              (aref table (+ (* i 4) 1)) (aref (aref gradients (mod i 160)) 1)
              (aref table (+ (* i 4) 2)) (aref (aref gradients (mod i 160)) 2)
              (aref table (+ (* i 4) 3)) (aref (aref gradients (mod i 160)) 3)))
      table)
  :test #'equalp)

(defstruct (open-simplex2f-4d
            (:include int::sampler)
            (:constructor %open-simplex2f-4d)
            (:conc-name "")
            (:predicate nil)
            (:copier nil))
  (gradients (make-array 8192 :element-type 'u:f64) :type (simple-array u:f64 (8192)))
  (table (make-array 2048 :element-type 'u:b16) :type (simple-array u:b16 (2048)))
  (orientation :standard :type (member :standard :xy/zw :xz/yw :xyz/w)))

(u:fn-> permute (rng:generator) (values (simple-array u:f64 (8192)) (simple-array u:b16 (2048))))
(defun permute (rng)
  (declare (optimize speed))
  (let ((source (make-array 2048 :element-type 'u:b16 :initial-element 0))
        (table (make-array 2048 :element-type 'u:b16 :initial-element 0))
        (gradients (make-array 8192 :element-type 'u:f64)))
    (dotimes (i 2048)
      (setf (aref source i) i))
    (loop :for i :from 2047 :downto 0
          :for r = (mod (+ (rng:int rng 0 #.(1- (expt 2 32)) nil) 31) (1+ i))
          :for x = (aref source r)
          :for pgi = (* i 4)
          :for gi = (* x 4)
          :do (setf (aref table i) x
                    (aref gradients pgi) (aref +gradients+ gi)
                    (aref gradients (+ pgi 1)) (aref +gradients+ (+ gi 1))
                    (aref gradients (+ pgi 2)) (aref +gradients+ (+ gi 2))
                    (aref gradients (+ pgi 3)) (aref +gradients+ (+ gi 3))
                    (aref source r) (aref source i)))
    (values gradients table)))

(declaim (inline orient))
(defun orient (sampler x y z w)
  (ecase (orientation sampler)
    (:standard
     (let ((s (* (+ x y z w) -0.138196601125011d0)))
       (values (+ x s) (+ y s) (+ z s) (+ w s))))
    (:xy/zw
     (let ((s2 (+ (* (+ x y) -0.178275657951399372d0)
                  (* (+ z w) 0.215623393288842828d0)))
           (t2 (+ (* (+ z w) -0.403949762580207112d0)
                  (* (+ x y) -0.375199083010075342d0))))
       (values (+ x s2) (+ y s2) (+ z t2) (+ w t2))))
    (:xz/yw
     (let ((s2 (+ (* (+ x z) -0.178275657951399372d0)
                  (* (+ y w) 0.215623393288842828d0)))
           (t2 (+ (* (+ y w) -0.403949762580207112d0)
                  (* (+ x z) -0.375199083010075342d0))))
       (values (+ x s2) (+ y t2) (+ z s2) (+ w t2))))
    (:xyz/w
     (let* ((xyz (+ x y z))
            (ww (* w 0.2236067977499788d0))
            (s2 (+ (* xyz -0.16666666666666666d0) ww)))
       (values (+ x s2) (+ y s2) (+ z s2) (+ (* xyz -0.5d0) ww))))))

(defun open-simplex2f-4d (&key seed (orientation :standard))
  (u:mvlet* ((rng (int::make-rng seed))
             (gradients table (permute rng)))
    (%open-simplex2f-4d :rng rng
                        :gradients gradients
                        :table table
                        :orientation orientation)))

(defmethod int::sample ((sampler open-simplex2f-4d) x &optional (y 0d0) (z 0d0) (w 0d0))
  (declare (optimize speed)
           (int::f50 x y z w))
  (u:mvlet* ((gradients (gradients sampler))
             (table (table sampler))
             (value 0d0)
             (xs ys zs ws (orient sampler x y z w))
             (xsb xsi (floor xs))
             (ysb ysi (floor ys))
             (zsb zsi (floor zs))
             (wsb wsi (floor ws))
             (si-sum (+ xsi ysi zsi wsi))
             (ssi (* si-sum 0.309016994374947d0))
             (lower-half-p (< si-sum 2)))
    (declare (u:f64 value xsi ysi zsi wsi ssi)
             (u:b16 xsb ysb zsb wsb))
    (when lower-half-p
      (setf xsi (- 1 xsi)
            ysi (- 1 ysi)
            zsi (- 1 zsi)
            wsi (- 1 wsi)
            si-sum (- 4 si-sum)))
    (let* ((aabb (- (+ xsi ysi) zsi wsi))
           (abab (- (+ (- xsi ysi) zsi) wsi))
           (abba (+ (- xsi ysi zsi) wsi))
           (aabb-score (abs aabb))
           (abab-score (abs abab))
           (abba-score (abs abba))
           (vertex-index 0)
           (via 0)
           (vib 0)
           (asi 0d0)
           (bsi 0d0))
      (declare (u:b32 vertex-index))
      (cond
        ((and (> aabb-score abab-score) (> aabb-score abba-score))
         (if (plusp aabb)
             (setf asi zsi
                   bsi wsi
                   vertex-index #b0011
                   via #b0111
                   vib #b1011)
             (setf asi xsi
                   bsi ysi
                   vertex-index #b1100
                   via #b1101
                   vib #b1110)))
        ((> abab-score abba-score)
         (if (plusp abab)
             (setf asi ysi
                   bsi wsi
                   vertex-index #b0101
                   via #b0111
                   vib #b1101)
             (setf asi xsi
                   bsi zsi
                   vertex-index #b1010
                   via #b1011
                   vib #b1110)))
        (t
         (if (plusp abba)
             (setf asi ysi
                   bsi zsi
                   vertex-index #b1001
                   via #b1011
                   vib #b1101)
             (setf asi xsi
                   bsi wsi
                   vertex-index #b0110
                   via #b0111
                   vib #b1110))))
      (when (> bsi asi)
        (setf via vib)
        (rotatef asi bsi))
      (when (> (+ si-sum asi) 3)
        (if (> (+ si-sum bsi) 4)
            (setf vertex-index #b1111)
            (setf vertex-index via)))
      (when lower-half-p
        (setf xsi (- 1 xsi)
              ysi (- 1 ysi)
              zsi (- 1 zsi)
              wsi (- 1 wsi)
              vertex-index (logxor vertex-index #b1111)))
      (block nil
        (dotimes (i 5)
          (let* ((c (aref +lookup+ vertex-index))
                 (xi (+ xsi ssi))
                 (yi (+ ysi ssi))
                 (zi (+ zsi ssi))
                 (wi (+ wsi ssi))
                 (dx (+ xi (dx c)))
                 (dy (+ yi (dy c)))
                 (dz (+ zi (dz c)))
                 (dw (+ wi (dw c)))
                 (attn (- 0.5 (expt dx 2) (expt dy 2) (expt dz 2) (expt dw 2))))
            (incf xsb (xsv c))
            (incf ysb (ysv c))
            (incf zsb (zsv c))
            (incf wsb (wsv c))
            (when (plusp attn)
              (let* ((pxm (aref table (logand xsb 2047)))
                     (pym (aref table (logxor pxm (logand ysb 2047))))
                     (pzm (aref table (logxor pym (logand zsb 2047))))
                     (pwm (aref table (logxor pzm (logand wsb 2047))))
                     (grad-index (* pwm 4))
                     (grad-x (* (aref gradients grad-index) dx))
                     (grad-y (* (aref gradients (+ grad-index 1)) dy))
                     (grad-z (* (aref gradients (+ grad-index 2)) dz))
                     (grad-w (* (aref gradients (+ grad-index 3)) dw)))
                (setf attn (expt attn 2))
                (incf value (* (expt attn 2) (+ grad-x grad-y grad-z grad-w)))))
            (when (= i 4)
              (return))
            (incf xsi (xsi c))
            (incf ysi (ysi c))
            (incf zsi (zsi c))
            (incf wsi (wsi c))
            (incf ssi (ssi-delta c))
            (setf vertex-index #b0000)
            (let ((score (- 1 xsi ysi zsi wsi)))
              (cond
                ((and (>= xsi ysi) (>= xsi zsi) (>= xsi wsi) (>= xsi score))
                 (setf vertex-index #b0001))
                ((and (> ysi xsi) (>= ysi zsi) (>= ysi wsi) (>= ysi score))
                 (setf vertex-index #b0010))
                ((and (> zsi xsi) (> zsi ysi) (>= zsi wsi) (>= zsi score))
                 (setf vertex-index #b0100))
                ((and (> wsi xsi) (> wsi ysi) (> wsi zsi) (>= wsi score))
                 (setf vertex-index #b1000)))))))
      (float value 1f0))))
