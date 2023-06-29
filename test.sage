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
