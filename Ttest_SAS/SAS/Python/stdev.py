# a function to obtain the standard deviation challenge!
# n = [1,2,3,4,5]
# i need the mean.
# i need to iterate through the list of numbers
def stddev(n):
    import math
    cum = 0 #initialize the sum of integers to 0
    dmcum = 0
    df = (len(n)-1) #df = degrees of freedom
    for i in n:
        cum +=i #simple loop starts with i+0 then the value of i is added to the subsequent number in the list
    mean = cum/len(n)
    
    for j in n:
        dmvar = (j-mean)**2 #dmvar = data-mean variance or difference
        dmcum += dmvar
    dmcum1 = dmcum
    
    sd = math.sqrt(dmcum1/df)
    return sd

stddev([-1,-6,-5,-1,-4,-1,-2,-2,3,0,-8,0,2,-5,-2,1,-4,-4,-2,-6])