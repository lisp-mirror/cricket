(in-package #:cl-user)

(defpackage #:coherent-noise.generators.ridged-multifractal-4d
  (:local-nicknames
   (#:gen #:coherent-noise.generators)
   (#:int #:coherent-noise.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl))

(in-package #:coherent-noise.generators.ridged-multifractal-4d)

(defstruct (ridged-multifractal-4d
            (:include int:sampler)
            (:conc-name "")
            (:predicate nil)
            (:copier nil))
  (sources (vector) :type simple-vector)
  (scale 1.0 :type u:f32)
  (octaves 4 :type (integer 1 32))
  (frequency 1.0 :type u:f32)
  (lacunarity 2.0 :type u:f32)
  (persistence 1.0 :type u:f32)
  (attenuation 2.0 :type u:f32))

(defun get-scale-factor (octaves persistence attenuation)
  (loop :repeat octaves
        :for amplitude = 1.0 :then (* amplitude persistence)
        :for weight = 1.0 :then (u:clamp (/ sample attenuation) 0 1)
        :for sample = (* weight amplitude)
        :sum sample :into result
        :finally (return (float (/ 2 result) 1f0))))

(defun gen:ridged-multifractal-4d (&key seed (generator #'gen:perlin-4d) (octaves 4) (frequency 1.0)
                                     (lacunarity 2.0) (persistence 1.0) (attenuation 2.0))
  (let ((rng (int::make-rng seed)))
    (make-ridged-multifractal-4d :rng rng
                                 :sources (int::make-fractal-sources generator rng octaves)
                                 :scale (get-scale-factor octaves persistence attenuation)
                                 :octaves octaves
                                 :frequency (float frequency 1f0)
                                 :lacunarity (float lacunarity 1f0)
                                 :persistence (float persistence 1f0)
                                 :attenuation (float attenuation 1f0))))

(defmethod int:sample ((sampler ridged-multifractal-4d) x &optional (y 0d0) (z 0d0) (w 0d0))
  (loop :with sources = (sources sampler)
        :with frequency = (frequency sampler)
        :with lacunarity = (lacunarity sampler)
        :with persistence = (persistence sampler)
        :with attenuation = (attenuation sampler)
        :for i :below (octaves sampler)
        :for amplitude = 1.0 :then (* amplitude persistence)
        :for weight = 1.0 :then (u:clamp (/ sample attenuation) 0 1)
        :for fx = (* x frequency) :then (* fx lacunarity)
        :for fy = (* y frequency) :then (* fy lacunarity)
        :for fz = (* z frequency) :then (* fz lacunarity)
        :for fw = (* w frequency) :then (* fw lacunarity)
        :for sample = (* (expt (- 1 (abs (int:sample (aref sources i) fx fy fz fw))) 2)
                         weight
                         amplitude)
        :sum sample :into result
        :finally (return (1- (* result (scale sampler))))))