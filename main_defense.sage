M = msp_gen()

## input de n et k



# creation d'un groupe fini si possible
gr = AbelianGroup(3,[2]*3) # ?

secret = gr.random_element() # pour le test
print("secret : ", secret)

shares = msp_enc(gr, secret, M)
print("shares : ", shares)


# peut etre changé plus tard
player = [shares[0], shares[3]]

ret_secret = msp_dec(player, gr, M)
print("retrieve the secret : ", ret_secret)


