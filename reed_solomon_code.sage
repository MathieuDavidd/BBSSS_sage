import copy

# fichier qui contient les principales fonctions sur reed_solomon (pas terminé) : besoin définir les corps dans lequel on se situe avant d'appeler la fonction 
# le corps de taille p^l se basera sur la variable y et le les polynomes d'interpolations sur la variables x  

# dans le fichier main on définit le corps (finalement on peut le redefinir dans la fonction sans que ca pose de probleme)


# principal constant parametrizable

def reed_solomon_code(p,m,k,n,t):
	Fpm.<y> = GF(p**m)

	alpha_array = reed_solomon_alpha(p,m,k,n,t)
		
	f_array = []
	FX.<x> = Fpm[]
	
	# prendre la base canonique (plus simple)
	for i in range(t+1):
		f_array.append(x**i)
		
	Ap = reed_solomon_matrix(p,m,k,n,t, alpha_array, f_array) # getting the matrix of the reed solomon code
	Msg = message(p,m,k,n,t, 1) # random set to 1
	
	Shares = Msg * Ap.transpose()
	
	print("Shares of the message : ", Shares)
	return (alpha_array, Shares)
		

def reed_solomon_alpha(p,m,k,n,t):
	alpha_array = [] # choosing randomly alpha1, alpha2 ..., alphan
	for i in range(n):
		alphai = Fpm.random_element()
		while alphai in (alpha_array): # a revoir peut être
			alphai = Fpm.random_element()
		alpha_array.append(alphai)	
	return alpha_array

def reed_solomon_matrix(p,m,k,n,t, alpha_array, polynomial_basis):

	if polynomial_basis == []:
		Fpm.<y> = GF(p**m)
		FX.<x> = Fpm[]
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
	return Matrix(Ap)
	
### same function as above but return an array, not a
def reed_solomon_array(p,m,k,n,t, alpha_array, polynomial_basis):

	if polynomial_basis == []:
		Fpm.<y> = GF(p**m)
		FX.<x> = Fpm[]
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
	return Ap
	
	
	
# fonction renvoie la matrice étendue
def reed_solomon_expension(p, m, matrice):
	return 0


# should return a message generated randomly if needed (random = 1) of the vector format

def message(p,m,k,n,t ,random):
	
	message_t = []
	Fpm.<y> = GF(p**m)
	
	if random == 1: # if we decide to generate randomuly the message
		for i in range(k):
			message_t.append(Fpm.random_element())
		print("Randomly generated message with sage in F pm: ",message_t)
		
	else : # default message [1,1,1,...,1]
		for i in range(k):
			message_t.append(1)
		print("Most basic message in F pm: ", message_t)
	
	return vector(message_t)
			

def return_poly_interpolation(coded_part, set_of_polynomial, alpha_part):

	print("=== decoding ===")
	print("\ngiven in input :")
	print("\nshares : ", coded_part)
	print("\nsubset of alpha :", alpha_part)
	FX.<x> = set_of_polynomial[]
	poly = 0
	for i in range (len(coded_part)):
		poly_temp = coded_part[i]
		for j in range (len(coded_part)):
			if i != j:
				poly_temp *= (x - alpha_part[j])/(alpha_part[i] - alpha_part[j])
		poly += copy.deepcopy(poly_temp) 
	print("decoding by interpolation : polynomial => ", poly)
	return poly
	
# do the reverse operation of reed-solomon code

def reed_solomon_uncode(p,m,k,n,t, shares_part, alpha_part):
	if len(shares_part)<k:
		print("not enough informations to retrieve the message")
		return 1
	else:
	
		Fpm.<y> = GF(p**m)
		FX.<x> = Fpm[]
		poly = return_poly_interpolation(shares_part, Fpm, alpha_part)
		
		# decoding of the polynomial part (ie. should depends on the basis used but here we handcoded it with the canonical basis)
		result = []
		for i in range(k):
			result.append( (poly % x**(i+1) ) // x^i )
		print("message successfully recovered : ",result)
	
	
##### not tested yet #####
# should return the matrix of the code (will be the next use when we will concatenate matrix and lift them) of the Matrix object format
# we implement the mapping phi with the canonical basis of the gaulois field
# we put a 2D array as input to manipulate it easier
 
# not tested !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# pour construire la matrice on passe par la transposé
def reed_solomon_ext_matrix(p,m,k,n,t, matrix_table): # question : est ce que les variables de la matrice 
	Fpm.<y> = GF(p**m) # we set the polynomials in t 
	
	basis = [] # we fix the canonical basis 
	for i in range (m):
		basis.append(y**i)	
	
	#now we want to get the Fp coefficient of each element of the matrix
	
	coordinate = []
	big_matrix = []
	
	dimy = len(matrix_table)
	dimx = len(matrix_table[0])
	
	for j in range(dimy):
		for i in range(m):
			for k in range(dimx):
			# reset du vecteur coordinate
				coordinate = phi(basis[i] * matrix_table[j][k], basis) 
				if k == 0:
					big_matrix.append(copy.deepcopy(coordinate)) # on commence une nouvelle ligne
				else:
					big_matrix[j*i].extend(copy.deepcopy(coordinate)) # on etend la ligne en question
		
	
	print("la matrice : ", Matrix(big_matrix).transpose())
	return Matrix(big_matrix.transpose())
				
							
# should return a vector of coordinate
# en partant du principe qu'on a deja définit y la variable de définition du corps
def phi(element , basis):
	coordinate = []
	for i in range(len(basis)):
		coordinate.append((elem % y**(i+1) ) // y^i)
	return coordinate	
	

