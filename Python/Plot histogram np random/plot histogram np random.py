import numpy as np

s = np.random.uniform(-1,0,1000)

np.all(s >= -1)
np.all(s < 0)

import matplotlib.pyplot as plt
count, bins, ignored = plt.hist(s, 15, normed=True)
plt.plot(bins, np.ones_like(bins), linewidth=2, color='r')
plt.show()