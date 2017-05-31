def fib(n):
    if n < 0: raise Exception("No negative values !!!")
    if n < 2: return 1
    return fib(n - 1) + fib(n - 2)
