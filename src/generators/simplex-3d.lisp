(in-package #:cl-user)

(defpackage #:coherent-noise.generators.simplex-3d
  (:local-nicknames
   (#:int #:coherent-noise.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl)
  (:export #:simplex-3d))

(in-package #:coherent-noise.generators.simplex-3d)

(u:define-constant +skew-factor+ (/ 3d0))

(u:define-constant +unskew-factor+ (/ 6d0))

(u:define-constant +scale+ 32d0)

(u:fn-> sample ((simple-array u:ub8 (512)) int::f50 int::f50 int::f50) u:f32)
(declaim (inline sample))
(defun sample (table x y z)
  (declare (optimize speed))
  (flet ((get-simplex (x y z)
           (if (>= x y)
               (cond
                 ((>= y z) (values 1 0 0 1 1 0))
                 ((>= x z) (values 1 0 0 1 0 1))
                 (t (values 0 0 1 1 0 1)))
               (cond
                 ((< y z) (values 0 0 1 0 1 1))
                 ((< x z) (values 0 1 0 0 1 1))
                 (t (values 0 1 0 1 1 0)))))
         (noise (hash x y z)
           (let* ((s (- 0.6 (* x x) (* y y) (* z z)))
                  (h (logand hash 15))
                  (u (if (< h 8) x y))
                  (v (case h
                       ((0 1 2 3) y)
                       ((12 14) x)
                       (t z)))
                  (grad (+ (if (zerop (logand h 1)) u (- u))
                           (if (zerop (logand h 2)) v (- v)))))
             (if (plusp s)
                 (* (expt s 4) grad)
                 0d0))))
    (u:mvlet* ((s (* (+ x y z) +skew-factor+))
               (i (floor (+ x s)))
               (j (floor (+ y s)))
               (k (floor (+ z s)))
               (tx (* (+ i j k) +unskew-factor+))
               (x1 (- x (- i tx)))
               (y1 (- y (- j tx)))
               (z1 (- z (- k tx)))
               (i1 j1 k1 i2 j2 k2 (get-simplex x1 y1 z1))
               (x2 (+ (- x1 i1) +unskew-factor+))
               (y2 (+ (- y1 j1) +unskew-factor+))
               (z2 (+ (- z1 k1) +unskew-factor+))
               (x3 (+ (- x1 i2) #.(* +unskew-factor+ 2)))
               (y3 (+ (- y1 j2) #.(* +unskew-factor+ 2)))
               (z3 (+ (- z1 k2) #.(* +unskew-factor+ 2)))
               (x4 (+ (1- x1) #.(* +unskew-factor+ 3)))
               (y4 (+ (1- y1) #.(* +unskew-factor+ 3)))
               (z4 (+ (1- z1) #.(* +unskew-factor+ 3))))
      (float (* (+ (noise (int::lookup table i j k) x1 y1 z1)
                   (noise (int::lookup table (+ i i1) (+ j j1) (+ k k1)) x2 y2 z2)
                   (noise (int::lookup table (+ i i2)  (+ j j2) (+ k k2)) x3 y3 z3)
                   (noise (int::lookup table (1+ i) (1+ j) (1+ k)) x4 y4 z4))
                +scale+)
             1f0))))

(defun simplex-3d (&key (seed "default"))
  (let* ((rng (int::make-rng seed))
         (table (rng:shuffle rng int::+perlin-permutation+)))
    (lambda (x &optional (y 0d0) (z 0d0) w)
      (declare (ignore w))
      (sample table x y z))))
