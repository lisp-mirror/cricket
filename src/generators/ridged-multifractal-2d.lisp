(in-package #:cl-user)

;;;; 2-dimensional "ridged" multifractal fractal noise generator

(defpackage #:%cricket.generators.ridged-multifractal-2d
  (:local-nicknames
   (#:gen #:%cricket.generators)
   (#:int #:%cricket.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl))

(in-package #:%cricket.generators.ridged-multifractal-2d)

(defstruct (gen:ridged-multifractal-2d
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

(defun gen:ridged-multifractal-2d (&key seed (generator #'gen:perlin-2d) (octaves 4) (frequency 1.0)
                                     (lacunarity 2.0) (persistence 1.0) (attenuation 2.0))
  "Construct a sampler that, when sampled, outputs the application of multiple octaves of a
2-dimensional ridged multifractal noise, using the supplied `generator` function to construct each
octave's sampler.

`seed`: A string used to seed the random number generator for this sampler, or NIL. If a seed is not
supplied, one will be generated automatically which will negatively affect the reproducibility of
the noise (optional, default: NIL).

`generator`: a function object pointing to one of the built-in 2-dimensional generator samplers that
is used to construct a different sampler, each with a different seed, for each octave (optional,
default `#'perlin-2d`).

`octaves`: An integer between 1 and 32, denoting the number of octaves to apply (optional, default:
4).

`frequency`: The frequency of the first octave's signal (optional, default: 1.0).

`lacunarity`: A multiplier that determines how quickly the frequency increases for successive
octaves (optional, default: 2.0).

`persistence`: A multiplier that determines how quickly the amplitude diminishes for successive
octaves (optional, default 1.0).

`attenuation`: The attenuation to apply to the weight of each octave (optional, default: 2.0)."
  (unless (typep octaves '(integer 1 32))
    (error 'int:invalid-fractal-octave-count :sampler-type 'ridged-multifractal-2d :value octaves))
  (unless (realp frequency)
    (error 'int:invalid-real-argument
           :sampler-type 'ridged-multifractal-2d
           :argument :frequency
           :value frequency))
  (unless (realp lacunarity)
    (error 'int:invalid-real-argument
           :sampler-type 'ridged-multifractal-2d
           :argument :lacunarity
           :value lacunarity))
  (unless (realp persistence)
    (error 'int:invalid-real-argument
           :sampler-type 'ridged-multifractal-2d
           :argument :persistence
           :value persistence))
  (unless (realp attenuation)
    (error 'int:invalid-real-argument
           :sampler-type 'ridged-multifractal-2d
           :argument :attenuation
           :value attenuation))
  (let ((rng (int::make-rng seed)))
    (make-ridged-multifractal-2d :rng rng
                                 :sources (int::make-fractal-sources generator rng octaves)
                                 :scale (get-scale-factor octaves persistence attenuation)
                                 :octaves octaves
                                 :frequency (float frequency 1f0)
                                 :lacunarity (float lacunarity 1f0)
                                 :persistence (float persistence 1f0)
                                 :attenuation (float attenuation 1f0))))

(defmethod int:sample ((sampler gen:ridged-multifractal-2d) x &optional (y 0d0) (z 0d0) (w 0d0))
  (declare (ignore z w))
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
        :for sample = (* (expt (- 1 (abs (int:sample (aref sources i) fx fy))) 2) weight amplitude)
        :sum sample :into result
        :finally (return (1- (* result (scale sampler))))))
