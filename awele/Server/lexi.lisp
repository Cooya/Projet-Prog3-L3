(in-package :awele)

(defgeneric lexi< (vector1 vector2 &key test))

(defmethod lexi< ((vector1 vector) (vector2 vector) &key (test #'<))
  (let ((l1 (length vector1))
	(l2 (length vector2)))
    (assert (= l1 l2))
    (labels ((aux (i)
	       (and
		(/= i l1)
		(let* ((v1 (aref vector1 i))
		       (v2 (aref vector2 i)))
		  (or (funcall test v1 v2)
		      (and
		       (not (funcall test v2 v1))
		       (aux (1+ i))))))))
      (aux 0))))
			    
	     
