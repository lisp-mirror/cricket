(in-package #:cl-user)

(defpackage #:coherent-noise.generators.multifractal-4d
  (:local-nicknames
   (#:gen #:coherent-noise.generators)
   (#:int #:coherent-noise.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl))

(in-package #:coherent-noise.generators.multifractal-4d)

(defstruct (multifractal-4d
            (:include int:sampler)
            (:conc-name "")
            (:predicate nil)
            (:copier nil))
  (sources (vector) :type simple-vector)
  (scale 1.0 :type u:f32)
  (octaves 4 :type (integer 1 32))
  (frequency 1.0 :type u:f32)
  (lacunarity int::+default-lacunarity+ :type u:f32)
  (persistence 0.5 :type u:f32))

(defun gen:multifractal-4d (&key seed (generator #'gen:perlin-2d) (octaves 4) (frequency 1.0)
                              (lacunarity int::+default-lacunarity+) (persistence 0.5))
  (let ((rng (int::make-rng seed)))
    (make-multifractal-4d :rng rng
                          :sources (int::make-fractal-sources generator rng octaves)
                          :scale (int::calculate-multifractal-scaling-factor octaves persistence)
                          :octaves octaves
                          :frequency (float frequency 1f0)
                          :lacunarity (float lacunarity 1f0)
                          :persistence (float persistence 1f0))))

(defmethod int:sample ((sampler multifractal-4d) x &optional (y 0d0) (z 0d0) (w 0d0))
  (loop :with sources = (sources sampler)
        :with frequency = (frequency sampler)
        :with lacunarity = (lacunarity sampler)
        :with persistence = (persistence sampler)
        :for i :below (octaves sampler)
        :for fx = (* x frequency) :then (* fx lacunarity)
        :for fy = (* y frequency) :then (* fy lacunarity)
        :for fz = (* z frequency) :then (* fz lacunarity)
        :for fw = (* w frequency) :then (* fw lacunarity)
        :for amplitude = 1 :then (* amplitude persistence)
        :for sample = (int:sample (aref sources i) fx fy fz fw)
        :for result = sample :then (+ result (* result sample amplitude))
        :finally (return (/ result (scale sampler)))))