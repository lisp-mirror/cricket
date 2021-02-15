(in-package #:cl-user)

(defpackage #:coherent-noise.generators.simplex-1d
  (:local-nicknames
   (#:int #:coherent-noise.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl)
  (:export #:simplex-1d))

(in-package #:coherent-noise.generators.simplex-1d)

(u:define-constant +scale+ 0.395d0)

(defstruct (simplex-1d
            (:include int::sampler)
            (:constructor %simplex-1d)
            (:conc-name nil)
            (:predicate nil)
            (:copier nil))
  (table int::+perlin-permutation+ :type (simple-array u:ub8 (512))))

(defun simplex-1d (&key seed)
  (let* ((rng (int::make-rng seed))
         (table (rng:shuffle rng int::+perlin-permutation+)))
    (%simplex-1d :rng rng :table table)))

(defmethod int::sample ((sampler simplex-1d) x &optional (y 0d0) (z 0d0) (w 0d0))
  (declare (ignore y z w)
           (optimize speed)
           (int::f50 x y z w))
  (flet ((noise (hash x)
           (let* ((s (- 1 (* x x)))
                  (h (logand hash 15))
                  (grad (if (zerop (logand h 8))
                            (* (1+ (logand h 7)) x)
                            (* (- (1+ (logand h 7))) x))))
             (if (plusp s)
                 (* (expt s 4) grad)
                 0d0))))
    (let* ((table (table sampler))
           (i1 (floor x))
           (i2 (1+ i1))
           (x1 (- x i1))
           (x2 (1- x1)))
      (float (* (+ (noise (int::lookup table i1) x1)
                   (noise (int::lookup table i2) x2))
                +scale+)
             1f0))))
