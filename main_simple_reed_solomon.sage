# quand on ouvre sage math => d'abord load le code et ensuite attacher tout le reste (voir pour faire un script qui lance tout)
# main file will call the reed_solomon function

p = 2 # p du F p^m
m = 3 # m similairement

# n, k et t les constantes de la du code (faire avec un petit n au début)
n = 6
k = 3 
t = 3 

Fpm.<y> = GF(p**m)
FX.<x> = Fpm[]

alpha_array, shares = reed_solomon_code(p,m,k,n,t)


# choice of k elements of the shares (simulating a part of the secret)

component_num = []
for i in range(k):
	alphai = (ZZ.random_element())%6
	while alphai in (component_num): # a revoir peut être
		alphai = (ZZ.random_element())%6
	component_num.append(alphai)

component = []
component_alpha = []
for elem in component_num:
	component.append(shares[elem])
	component_alpha.append(alpha_array[elem])


reed_solomon_uncode(p,m,k,n,t, component, component_alpha)

print(" end :) ")

# ca va me donner une matrice dans Z/15Z si je fait un crt de Z/3Z, et Z/5Z (en tout cas a quelque chose d'isomorphe)
# https://doc.sagemath.org/html/fr/tutorial/tour_numtheory.html => pour comment utiliser le theoreme des restes chinois dans sage (/!\ peut-être utiliser les formes 
# listes plutot que les objets matrice directement



