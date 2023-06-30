# BBSSS_sage
Black Box Secret Sharing Scheme proposed by Ronald Cramer and Chaoping Xing. Blackbox secret sharing revisited: A
coding-theoretic approach with application to expansionless near-threshold schemes. Cryptology ePrint Archive, Paper 2019/1134, 2019. https://eprint.iacr.org/2019/1134.

This partial implementation has been done during a two month internship at Laboratoire Jean Kuntzman, UGA. The implementation cover only the threshold secret sharing scheme based on Reed-Solomon codes.

# Interface
The interface provided here is located in the msp_interface.sage file. The interface gives 3 main methods : 
- msp_gen() :                                             
        input : the parameters n & k given via the standard input
        output : a matrix M
        spec : M is the matrix of the integer Monotone spane program / BBSSS
                                                                                                                        
- msp_enc(gr, secret, M) : 
        input : a group, a secret (element over gr), and the matrix (returned by msp_gen()) 
        output : n tuple of the form (i, [info])      
        spec : each tuple stands for a share where i is the number of the share and [info] is a list of coordinate for one share (usually the list has log_2(n) + 1 elements)
               this method encode the secret and
- msp_dec(gr, sub_shares, M) :
        input : a group (the same as before), a subset of shares, M the same matrix
        output : an element s of the group gr (if no error raised)
        spec : s is the secret encoded (if k shares are given), raise an error if too few shares are given

# How to use it

1- install SageMath : https://www.sagemath.org/fr/telecharger.html
2- launch SageMath (in the corresponding folder, process the command "sage")
3- in the sage console : process the command 'load("main.sage")'

# Content of the repository

Reed_Solomon_code.sage -> methods to create a RS code with the desired parameters, methods where we can extend matrices from an extension field to a prime field

CRT.sage -> file where there is the chinese remainder theroem application function, call functions from Reed_Solomon_code.sage, set parameters (n,m,k ...) and return the monotone span Program matrix which compute the access structure for any prime p <= n

Vandermonde.sage -> file where there are simple functions related to a Vandermonde matrix  

MSP.sage -> file which use Vandermonde.sage functions and provide more functions like the computations of rho_N and zeta_N and THE CONSTRUCTION OF THE FINAL MSP MATRIX

msp_interface.sage -> file that provide the interface of the bbsss   
