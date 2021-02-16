(in-package #:cl-user)

(defpackage #:coherent-noise.modifiers.turbulence
  (:local-nicknames
   (#:int #:coherent-noise.internal)
   (#:mod #:coherent-noise.modifiers)
   (#:perlin-3d #:coherent-noise.generators.perlin-3d)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl))

(in-package #:coherent-noise.modifiers.turbulence)

(defstruct (turbulence
            (:include int::sampler)
            (:conc-name "")
            (:predicate nil)
            (:copier nil))
  (source nil :type int::sampler)
  (displacement-source nil :type int::sampler)
  (power 1d0 :type u:f32)
  (x1 0f0 :type u:f32)
  (x2 0f0 :type u:f32)
  (x3 0f0 :type u:f32)
  (x4 0f0 :type u:f32)
  (y1 0f0 :type u:f32)
  (y2 0f0 :type u:f32)
  (y3 0f0 :type u:f32)
  (y4 0f0 :type u:f32)
  (z1 0f0 :type u:f32)
  (z2 0f0 :type u:f32)
  (z3 0f0 :type u:f32)
  (z4 0f0 :type u:f32)
  (w1 0f0 :type u:f32)
  (w2 0f0 :type u:f32)
  (w3 0f0 :type u:f32)
  (w4 0f0 :type u:f32))

(defun mod:turbulence (source displacement-source &key (frequency 1.0) (power 1.0) (roughness 3))
  (let ((rng (int::sampler-rng source)))
    (make-turbulence :rng (int::sampler-rng source)
                     :source source
                     :displacement-source (mod:fractal displacement-source
                                                       :octaves roughness
                                                       :frequency (float frequency 1f0))
                     :power (float power 1f0)
                     :x1 (rng:float rng 0.0 1.0)
                     :x2 (rng:float rng 0.0 1.0)
                     :x3 (rng:float rng 0.0 1.0)
                     :x4 (rng:float rng 0.0 1.0)
                     :y1 (rng:float rng 0.0 1.0)
                     :y2 (rng:float rng 0.0 1.0)
                     :y3 (rng:float rng 0.0 1.0)
                     :y4 (rng:float rng 0.0 1.0)
                     :z1 (rng:float rng 0.0 1.0)
                     :z2 (rng:float rng 0.0 1.0)
                     :z3 (rng:float rng 0.0 1.0)
                     :w1 (rng:float rng 0.0 1.0)
                     :w2 (rng:float rng 0.0 1.0)
                     :w3 (rng:float rng 0.0 1.0)
                     :w4 (rng:float rng 0.0 1.0))))

(defmethod int::sample ((sampler turbulence) x &optional (y 0d0) (z 0d0) (w 0d0))
  (let ((displacement-source (displacement-source sampler))
        (power (power sampler)))
    (int::sample (source sampler)
                 (+ x (* (int::sample displacement-source
                                      (+ x (x1 sampler))
                                      (+ y (y1 sampler))
                                      (+ z (z1 sampler))
                                      (+ w (w1 sampler)))
                         power))
                 (+ y (* (int::sample displacement-source
                                      (+ x (x2 sampler))
                                      (+ y (y2 sampler))
                                      (+ z (z2 sampler))
                                      (+ w (w2 sampler)))
                         power))
                 (+ z (* (int::sample displacement-source
                                      (+ x (x3 sampler))
                                      (+ y (y3 sampler))
                                      (+ z (z3 sampler))
                                      (+ w (w3 sampler)))
                         power))
                 (+ x (* (int::sample displacement-source
                                      (+ x (x4 sampler))
                                      (+ y (y4 sampler))
                                      (+ z (z4 sampler))
                                      (+ w (w4 sampler)))
                         power)))))
