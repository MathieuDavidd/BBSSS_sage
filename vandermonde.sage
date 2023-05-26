### file where the vandermonde matrix and all other elements decribed in the paper (ro etc...) are returned by methods
import copy


# list_xi are all the xi in the vandermond matrix, n is the number of element in a line
# h is the lowest power of element in the vandermonde matrix

def Vandermonde_array(list_xi, n, h):
	matrx = []
	vectr = []
	for i in range(len(list_xi)):
		vector = []
		for j in range(n):
			vector.append(list_xi[i] **(j+h))
		matrx.append(copy.deepcopy(vector))
	print(matrix(matrx))
	return matrx	
	
# t is the length of the element which should be in the vandemronde matrix : element are from 1 to t		
def L(t, n):
	element = [i for i in range(1, t+1)]
	print("element", element)
	return Vandermonde_array(element, n,0)


	



