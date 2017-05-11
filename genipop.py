# Simple program to generate a random array and a sorted array
# Saves the random array to one file, sorted one to another file

from random import randint
xf = open("xin.txt", "w")
sf = open("sin.txt","w")
MIN=1; MAX=100
NUMINPUTS = 16
a=[]
for i in range(NUMINPUTS):
    a.append(randint(MIN, MAX))
    xf.write("%s\n"%str(bin(a[-1]&0xFF)[2:].zfill(16)))
    
s = sorted(a)
for i in range(NUMINPUTS):
    sf.write("%s\n"%str(bin(s[i]&0xFF)[2:].zfill(16)))
