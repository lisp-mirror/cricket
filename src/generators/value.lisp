(in-package #:coherent-noise/internal)

;;; 2D Value

(u:fn-> %value-2d (u:ub32 f50 f50) u:f32)
(declaim (inline %value-2d))
(defun %value-2d (seed x y)
  (declare (optimize speed))
  (labels ((in-range (x)
             (logand x (1- (expt 2 32))))
           (coord (seed x y)
             (let ((hash (expt (in-range (* (logxor seed x y) 668265261)) 2)))
               (* (in-range (logxor hash (ash hash -19)))
                  (/ 2147483648.0)))))
    (declare (inline in-range coord))
    (u:mvlet* ((x0 xs (floor x))
               (xs (interpolate/cubic xs))
               (x0 (in-range (* x0 +prime-x+)))
               (x1 (+ x0 +prime-x+))
               (y0 ys (floor y))
               (ys (interpolate/cubic ys))
               (y0 (in-range (* y0 +prime-y+)))
               (y1 (+ y0 +prime-y+)))
      (float (1- (u:lerp ys
                         (u:lerp xs (coord seed x0 y0) (coord seed x1 y0))
                         (u:lerp xs (coord seed x0 y1) (coord seed x1 y1))))
             1f0))))

;;; 3D Value

(u:fn-> %value-3d (u:ub32 f50 f50 f50) u:f32)
(declaim (inline %value-3d))
(defun %value-3d (seed x y z)
  (declare (optimize speed))
  (labels ((in-range (x)
             (logand x (1- (expt 2 32))))
           (coord (seed x y z)
             (let ((hash (expt (in-range (* (logxor seed x y z) 668265261)) 2)))
               (* (in-range (logxor hash (ash hash -19)))
                  (/ 2147483648.0)))))
    (declare (inline in-range coord))
    (u:mvlet* ((x0 xs (floor x))
               (xs (interpolate/cubic xs))
               (x0 (in-range (* x0 +prime-x+)))
               (x1 (+ x0 +prime-x+))
               (y0 ys (floor y))
               (ys (interpolate/cubic ys))
               (y0 (in-range (* y0 +prime-y+)))
               (y1 (+ y0 +prime-y+))
               (z0 zs (floor z))
               (zs (interpolate/cubic zs))
               (z0 (in-range (* z0 +prime-z+)))
               (z1 (+ z0 +prime-z+)))
      (float
       (1- (u:lerp zs
                   (u:lerp ys
                           (u:lerp xs (coord seed x0 y0 z0) (coord seed x1 y0 z0))
                           (u:lerp xs (coord seed x0 y1 z0) (coord seed x1 y1 z0)))
                   (u:lerp ys
                           (u:lerp xs (coord seed x0 y0 z1) (coord seed x1 y0 z1))
                           (u:lerp xs (coord seed x0 y1 z1) (coord seed x1 y1 z1)))))
       1f0))))
