### file where the vandermonde matrix and all other elements decribed in the paper (ro etc...) are returned by methods
import copy
	
# determinant function of the vandermonde matrix
def delta_L(k, n):
	mat = []
	vect = []
	for i in range(1, n+1):
		vect = []
		for j in range(1, n+1):
			vect.append(i**j)
		mat.append(copy.deepcopy(vect))
	return (matrix(mat)).det()

# return the vector needed for the matrix construction of the msp
def ei(i,k):
	return [i**t for t in range(1,k)]

