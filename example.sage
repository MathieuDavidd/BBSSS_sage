### file containing the example provided in the report ###
import copy
# define the settings 
p = 2
m = 4
Fpm.<y> = GF(p**m) # defining the finite field 
FpmX.<x> = Fpm[] # defining the polynomial space over Fpm

n = 4
k = 2 
t = 2


# dead code
# choosing randomly the alpha_i coefficients
alpha_array = [] # choosing randomly alpha1, alpha2 ..., alphan
for i in range(n):
	alphai = Fpm.random_element()
	while alphai in (alpha_array): # a revoir peut être
		alphai = Fpm.random_element()
	alpha_array.append(alphai)	

alpha_array = [y**3+y**2+y+1, y**3+y**2+1, y**3+y+1, y**3+1] 



print("alphas publicly known", alpha_array)

polynomial_basis = []

for i in range(t+1):
	polynomial_basis.append(x**i)
		
Fpm.<y> = GF(p**m)
FX.<x> = Fpm[]	
Ap = []
temp_vect = []
for i in range (n):
	for j in range (t):
		if i == 0:
			temp_vect.append( (polynomial_basis[j])(alpha_array[i]) ) # evaluation de polynome ??
		else:
			temp_vect[j] = (polynomial_basis[j])(alpha_array[i])
	Ap.append(copy.deepcopy(temp_vect))

print("full matrix", Matrix(Ap))

# ===============================================================================================================================================================================
# should return a vector of coordinate
# en partant du principe qu'on a deja définit y la variable de définition du corps
def phi(element):
	v =  vector(element)
	return list(v)
	
	
def transpose_array_to_array(Darray):
	print("before transpose : ",Darray) 
	v = Matrix(Darray)
	v = v.transpose()
	v = list(v)
	for i in range(len(v)):
		v[i] = list(v[i])
	print("after transpose : ", v)
	return v
	
# ===============================================================================================================================================================================

#test = [[1,2],[3,4]]
#Ap = transpose_array_to_array(Ap)

coordinate = []
big_matrix = []
temp = []
basis = []

dimy = len(Ap)
dimx = len(Ap[0])

# series of tests (all should be true)
print("test : ", n == dimy)

for i in range(m):
	basis.append(y**i)


for j in range(dimx):
	
	for i in range(m):
		for k in range(dimy): # of length n 
		# reset du vecteur coordinate
			print("checkpoint : j ", j)
			print("k ",k)
			print(" i(m) ",i)
			coordinate = phi(basis[i] * Ap[k][j])
			 
			if k == 0:
				temp = (copy.deepcopy(coordinate)) # on commence une nouvelle ligne
				print("nouvelle ligne")
					
			else:
				temp.extend(copy.deepcopy(coordinate))
				#big_matrix[j*i].extend(copy(coordinate)) # on etend la ligne en question
		big_matrix.append(copy.deepcopy(temp))

print("la matrice : \n", Matrix(big_matrix).transpose())
#return Matrix(big_matrix.transpose())
				
# le resultat semble assez coherent avec le papier


# tester avec les matrices blocks


				
							

