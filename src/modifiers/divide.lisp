(in-package #:cl-user)

;;;; Division (/) modifier
;;;; This noise modifier outputs the result of dividing the output of its first input sampler by its
;;;; second input sampler.

(defpackage #:%cricket.modifiers.divide
  (:local-nicknames
   (#:int #:%cricket.internal)
   (#:mod #:%cricket.modifiers)
   (#:u #:golden-utils))
  (:use #:cl))

(in-package #:%cricket.modifiers.divide)

(defstruct (mod:/
            (:constructor make-divide)
            (:include int:sampler)
            (:conc-name "")
            (:predicate nil)
            (:copier nil))
  (source1 nil :type int:sampler)
  (source2 nil :type int:sampler))

(defun mod:/ (source1 source2)
  "Construct a sampler that, when sampled, outputs the result of dividing the output `source1` by
the output of `source2`.

`source1`: The first input sampler (required).

`source2`: The second input sampler (required)."
  (unless (typep source1 'int:sampler)
    (error 'int:invalid-sampler-argument :sampler-type '/ :argument :source1 :value source1))
  (unless (typep source2 'int:sampler)
    (error 'int:invalid-sampler-argument :sampler-type '/ :argument :source2 :value source2))
  (make-divide :rng (int::sampler-rng source1) :source1 source1 :source2 source2))

(defmethod int:sample ((sampler mod:/) x &optional (y 0d0) (z 0d0) (w 0d0))
  (declare (optimize speed))
  (let ((sample1 (the u:f32 (int:sample (source1 sampler) x y z w)))
        (sample2 (the u:f32 (int:sample (source2 sampler) x y z w))))
    (if (zerop sample2) 0.0 (/ sample1 sample2))))
