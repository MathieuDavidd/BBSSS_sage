### fichier ou on met les fonction d'encodage et de decodage 


######### attention !!!! : pas sur du temp = 0 dans la multiplication


## fonction qui retourne la multiplication scalaire d'un element de groupe avec un entier

# faire un test pour voir si n est entier : isinstance(u[0], sage.rings.rational.Rational) and sage.rings.integer.Integer

# c'est toujours un rationel de renvoyé

def scalar_mul(g_elem, n, G):
	
	if n < 0:
		if n == -1:
			return g_elem.inverse()
		elif (n % 2) == 0:
			return scalar_mul(g_elem * g_elem, - n//2, G).inverse() # peut etre mettre des parenthèses 
		else :
			return (g_elem * scalar_mul(g_elem * g_elem, - (n-1)//2, G)).inverse()
	else:
		if n == 0:
			return G.one()
		elif n == 1:
			return g_elem
		elif (n % 2) == 0:
			return scalar_mul(g_elem * g_elem, n//2, G)
		else :
			return (g_elem * scalar_mul(g_elem * g_elem, (n-1)//2, G))
		
def vector_matrix_scalar_mul(v,M, G):
	if len(v) != len(M):
		return -1
	result = []
	for j in range (len(M[0])):
		start = 0
		for i in range (len(M)):
			if start == 0:
				#print("scalar_mul", v[i])
				#print(M[i][j])
				temp = scalar_mul(v[i], M[i][j], G)
				start = 1
			else: 
				temp *= scalar_mul(v[i], M[i][j], G)
		result.append(temp)
	return result
	
def vector_vector_scalar_mul(v1g, v2i, G):

	# check si les longueurs de vecteurs sont bien correspondantes 
	if len(v1g) != len(v2i):
		return -1
	else:
		#result = 1 # trouver comment faire l'element neutre dans un groupe en sage
		result = G.one()
		for i in range(len(v1g)):
			result *= scalar_mul(v1g[i], v2i[i], G)
		return result
	

# par simplicité, on considère que la matrice n'est pas transposé
def matrix_surfun_group(M, m, numero):
	numero = numero * (m)
	temp = []
	for i in range (m):
		temp.append( copy.deepcopy(M[numero + i]) )
	return temp
	

## genearation de la matrice du msp
def msp_gen():
	load("crt.sage") # fichier qui renvoie G pour tout les p < n
	load("msp.sage") # fichier qui renvoie la matrice finale du msp 
	G = crt_on_array(matrix_after_exp, prime_number) # appel du crt.sage avec des instruction hors function aussi (peut-être les enelever) et les mettre ici
	msp_mat = msp_matrix(G, m, n, k)
	#print("end of the generation")
	return msp_mat

## encodage 
# on passe en paramètre un groupe abelien, et un secret (du meme groupe) => retourne les n shares
# renvoie une liste de n tuples suivant le pattern (Numero de share, [element1, element2, ..., element m+1])
def msp_enc(groupe, s, M):
	
	# to do later
	mp = transpose_array_to_array(M)
	
	# verifier que groupe soit bien un groupe abelien 
	#if (isinstance(groupe, Group)) == False:
	#	print("bad args : msp_encode")
	#	return -1
	
	
	# verifier que s soit bien un element du groupe 
	if (s in groupe) == False:
		print("s & group doesn't correspond")
		return -1
	
	# lifter la matrice par l'ordre du groupe
	o = groupe.order()
	#print("order of the group : ", o)
	for i in range(len(mp)):
		for j in range(len(mp[0])):
			mp[i][j] %= o
	
	
	#print("after lifting modulo the order of the group : ", mp)
	
	init = [s]
	for i in range(len(mp) - 1):
		init.append(groupe.random_element())
	
	
	#print("g = ", init)
	
	shares = vector_matrix_scalar_mul(init, mp, groupe)
	
	
	# reshape le vector de shares => liste de liste => connaitre m
	m = (len(mp[0])/n)
	
	shares_r = []
	for i in range(len(shares)):
		if i%m == 0:
			if i != 0:
				shares_r.append( (i//m - 1, copy.deepcopy(temp)) ) # pas sûr de la division entière
			temp = []
		temp.append(shares[i		])
		
		if i == len(shares)-1:
			shares_r.append( (n-1, copy.deepcopy(temp)))	
		
	return shares_r
	
# mettre une fonction qui groupe les colones et faire en sorte qu'on puisse numeroter les shares
# M est toujours le tableau non transposé
def msp_dec(groupe, sub_list_shares, M):
	m = len(M)/n
	# formation de la sous matrice de M 
	sub_M = []
	info_vector = []
	for i in range(len(sub_list_shares)):
		(num_temp, info) = sub_list_shares[i]
		sub_M.extend( copy.deepcopy( matrix_surfun_group( M, m, num_temp ) ) )
		info_vector += copy.deepcopy(info)
		
	# sub_M est la bonne sous matrice (non-transposée) 
	# trouver un vecteur u qui est la solution au systeme linéaire u * M_s = (1, 0, ..., 0)
	
	
	target_vector = [1]
	for i in range(len(M[0]) - 1):
		target_vector.append(0)
	
	o = groupe.order()
	#for i in range(len(sub_M)):
	#	for j in range(len(sub_M[0])):
	#		sub_M[i][j] %= o
	
	
	#print("debug sub_m : ", sub_M)
	
	
	
	
	#u = matrix(sub_M).solve_left(vector(target_vector))
	
	(B,U,V) = (matrix(sub_M).transpose()).smith_form()
	target_vector = vector(target_vector)
	D = U * target_vector
	y = B.solve_right(D)
	x = V*y
	x = list(x)
	mod_x = [x[i]%o for i in range(len(x))]
	
	"""
	print("avant erreur")
	print("u : ", u)
	k = 3 * u[8].denominator()
	print("k : ", k)
	u = list(u)
	
	for i in range(len(u)):
		u[i] = u[i] * k
		
	print("u list", u)
	print(type(u[0]))
	print(isinstance(u[0], sage.rings.rational.Rational))
	"""
	
	# appel à la fonction scalar product avec la multiplication scalaire
	s = vector_vector_scalar_mul(info_vector, mod_x, groupe)
	
	return s 
	
