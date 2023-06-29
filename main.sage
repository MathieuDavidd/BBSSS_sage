#### file where I will call all the procedure to have the matrix of the msp and method to build secret ####

load("crt.sage") # fichier qui renvoie G pour tout les p < n
load("msp.sage") # fichier qui renvoie la matrice finale du msp 

print("====== R.Cramer & C.Xing MSP implementation ======")
G = crt_on_array(matrix_after_exp, prime_number) # appel du crt.sage avec des instruction hors function aussi (peut-être les enelever) et les mettre ici
msp_mat = msp_matrix(G, m, n, k)


# savoir comment instancier sur un groupe particulier 
print("=== choose the order of the group simulation ===")
q = input("q = ")
q = (sage.rings.integer.Integer)(q)

len_y = len(msp_mat)
len_x = len(msp_mat[0])


##### zkdadalmzdùald #####
gp = AbelianGroup(q, [i for i in range(q)])


#for i in range(len_y):
#	for j in range(len_x):
#		msp_mat[i][j] = msp_mat[i][j] % q

s = input("secret to split = ")
s = (sage.rings.integer.Integer)(s)



