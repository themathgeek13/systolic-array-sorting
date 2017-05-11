def psort(t):
    array=list(t)
    if(array[0]>array[1]):
        array[0],array[1]=array[1],array[0]
    if(array[2]>array[3]):
        array[2],array[3]=array[3],array[2]
    if(array[1]>array[2]):
        array[1],array[2]=array[2],array[1]
    if(array[2]>array[3]):
        array[2],array[3]=array[3],array[2]
    if(array[0]>array[1]):
        array[0],array[1]=array[1],array[0]
    if(array[1]>array[2]):
        array[1],array[2]=array[2],array[1]
    return array
