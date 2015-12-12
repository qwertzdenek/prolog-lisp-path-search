# transforms file into language specific format:
# [vertex_count]
# [edges_count]
# [from_vertex to_vertex weight]

dataset_name = 'mediumEWD.txt'

with open(dataset_name, 'r') as f:
    dataset_values = f.read().splitlines()

vertex_count = int(dataset_values.pop(0))
edges_count = int(dataset_values.pop(0))

def transform_prolog():
    with open('graph.pl', 'w') as fr:
        for v in range(vertex_count):
            fr.write('v(%d).\n' % v)

        fr.write('\n')

        for edge in dataset_values[:edges_count]:
            props = edge.split()
            from_vertex = int(props[0])
            to_vertex = int(props[1])
            weight = float(props[2])
            fr.write('e(%d, %d, %f).\n' % (from_vertex, to_vertex, weight))

def transform_lisp():
    pass

if __name__ == '__main__':
    transform_prolog()
    transform_lisp()

