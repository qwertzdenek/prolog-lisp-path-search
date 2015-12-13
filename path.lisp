(defconstant INFINITY 20)
(defconstant VERTEX_COUNT 7)

(defstruct graph-data
  to_vertex
  weight
  )

(defstruct relax-data
  distance
  vertex
  )

(setf graph (make-array (list VERTEX_COUNT)))
(setf (aref graph 0)
  (list (make-graph-data :to_vertex 1 :weight 0.5)
  )
)

(setf (aref graph 1)
  (list (make-graph-data :to_vertex 3 :weight 0.2)
				(make-graph-data :to_vertex 5 :weight 0.7)
  )
)

(setf (aref graph 2)
  (list (make-graph-data :to_vertex 0 :weight 0.2)
				(make-graph-data :to_vertex 4 :weight 1.2)
  )
)

(setf (aref graph 3)
  (list (make-graph-data :to_vertex 2 :weight 1)
				(make-graph-data :to_vertex 4 :weight 1.5)
  )
)

(setf (aref graph 4)
  (list (make-graph-data :to_vertex 5 :weight 3)
  )
)

(setf (aref graph 5)
  (list (make-graph-data :to_vertex 6 :weight 2)
				(make-graph-data :to_vertex 0 :weight 2)
  )
)

(setf (aref graph 6)
  (list (make-graph-data :to_vertex 6 :weight 0)
  )
)

; relaxed vertex distances
(setf relax (make-array (list VERTEX_COUNT)))

; returns actual vertex relax state
(defun get_dist (u)
  (setq val (aref relax u))
  (cond
    ( (endp val) (list INFINITY 0) )
    ( T (list (relax-data-distance val) (relax-data-vertex val)) )
  )
)

(defun set_dist (u d fr) (setf (aref relax u)
            (make-relax-data :distance d :vertex fr)))

(defun extract_min (vertex_list)
	(setq min_d INFINITY)
	(setq min_v 0)
	(loop for v in vertex_list do
		(setq v_relax (get_dist v))
    (setq dv (car v_relax))
    (setq v_id (car v_relax))
		(if (< dv min_d) (list (setq min_d dv) (setq min_v v_id)))
	)
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
     (when (endp vertex_list) (return))
     (setq u (extract_min vertex_list))
     (setq du (car (get_dist u)) )
     (setq u_adj (aref graph u))
     (dolist (v_edge u_adj)
       (setq v (graph-data-to_vertex v_edge))
       (setq dv (car (get_dist v)))
       (setq luv (graph-data-weight v_edge))
       (setq alt (+ du luv))
       (if (< alt dv) (set_dist v alt u))
    )
   )
)
