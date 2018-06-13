import itertools

adddata = [1, 2]
localData = [3, 4, 5]
localData = [x + y for x, y in list(itertools.izip_longest(adddata, localData, fillvalue=0))]

print localData