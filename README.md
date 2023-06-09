# BBSSS_sage
BBSSS construction of Cramer & Xing in "Blackbox Secret Sharing Revisited: A Coding-Theoretic Approach
with Application to Expansionless Near-Threshold Schemes" of a Monotone Span Program matrix with Reed Solomon Linear Code

# Disclaimer
This repository is on the "Draft branch" meaning that the code is not fully tested and there is still debuging traces of programs

# Content of the repository
Reed_Solomon_code.sage -> methods to create a RS code with the desired parameters, methods where we can extend matrices from an extension field to a prime field
Main_simple_Reed_solomon.sage -> main to use simple ad hoc reed solomon codes (with encode and decode methods)

CRT.sage -> file where there is the chinese remainder theroem application function, call functions from Reed_Solomon_code.sage, set parameters (n,m,k ...) and return the monotone span Program matrix which compute the access structure for any prime p <= n

Vandermonde.sage -> file where there are simple functions related to a Vandermonde matrix  

MSP.sage -> file which use Vandermonde.sage functions and provide more functions like the computations of rho_N and zeta_N and THE CONSTRUCTION OF THE FINAL MSP MATRIX

Main.sage -> file which use MSP.sage and CRT.sage files and calls functions to display the final matrix on the screen (in addition ot lot of trace used for the debuging)
(as an indication, all parameteres are set in the CRT.Sage file)

example.sage -> file used to illustrate the example of the section 3.2 of the final report



# How to use it

1- install SageMath : https://www.sagemath.org/fr/telecharger.html
2- launch SageMath (in the corresponding folder, process the command "sage")
3- in the sage console : process the command 'load("main.sage")'
