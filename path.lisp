(defconstant INFINITY 10000)

(defstruct graph-data
  to_vertex
  weight
  )

(defstruct relax-data
  distance
  vertex
  )


(load "graph.lisp")

; relaxed vertex distances
(setf relax (make-array (list VERTEX_COUNT)))

(defvar vertex_list nil)

; returns actual vertex relax state
(defun get_dist (u)
  (cond
    ( (null (aref relax u)) (make-relax-data :distance INFINITY :vertex u))
    ( T (aref relax u))
  )
)

(defun set_dist (u d fr) (setf (aref relax u)
            (make-relax-data :distance d :vertex fr)))

(defun extract_min ()
  (setq min_d INFINITY)
  (setq min_v 0)
  (loop for v in vertex_list do
    (setq v_relax (get_dist v))
    (setq dv (relax-data-distance v_relax))
    (if (< dv min_d) (list (setq min_d dv) (setq min_v v)))
  )
  (setq vertex_list (delete min_v vertex_list))
  (symbol-value 'min_v)
)

(defun search_graph (u)
   (set_dist u 0 u)
   ; initialize all unvisited vertices
   (setq vertex_list nil)
   (setq v (- VERTEX_COUNT 1))
   (loop
     (setq vertex_list (cons v vertex_list))
     (setq v (- v 1))
     (when (< v 0) (return))
   )
   (loop 
     (when (endp vertex_list) (return T))
     (setq u (extract_min))
     (setq du (relax-data-distance (get_dist u)) )
     (setq u_adj (aref graph u))
     (dolist (v_edge u_adj)
       (setq v (graph-data-to_vertex v_edge))
       (setq luv (graph-data-weight v_edge))
       (setq dv (relax-data-distance (get_dist v)))
       (setq alt (+ du luv))
       (if (< alt dv) (set_dist v alt u))
    )
   )
)

(defun trace_path (u v)
  (setq path (list v))
  (setq x v)
  (setq distance (relax-data-distance (get_dist v)))
  ( loop
    (setq x_relax (get_dist x))
    (setq x (relax-data-vertex x_relax))
    (setq path (cons x path))
    (when (= u x) (return))
  )
  (format t "Path = ~S~%Length = ~D" path distance)
)
