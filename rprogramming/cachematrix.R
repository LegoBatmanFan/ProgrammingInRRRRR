## LegoBatmanFan
###
## R Programming Assignment #2
##
## write a pair of functions that cache the inverse of a matrix.
##
##

## makeCacheMatrix: creates a special "matrix" object (called "batMatrix") 
## that can cache its inverse.
makeCacheMatrix <- function(x = matrix()) {
        batMatrix <- NULL
        set <- function(y) {
                x <<- y
                batMatrix <<- NULL
        }
        get <- function() x
        setinverse <- function(inverse) batMatrix <<- inverse
        getinverse <- function() batMatrix
        list(set = set, get = get,
             setinverse = setinverse,
             getinverse = getinverse)
}

## cacheSolve: computes the inverse of the batMatrix (returned by makeCacheMatrix).
## if the inverse has already been calculated (and the batMatrix has not changed), 
## then the cachesolve function retrieves the inverse from the cache.
cacheSolve <- function(x, ...) {
        batMatrix <- x$getinverse()
        if(!is.null(batMatrix)) {
                message("gEtTiNg CaChEd DaTa")
                return(batMatrix)
        }
        data <- x$get()
        batMatrix <- solve(data, ...)
        x$setinverse(batMatrix)
        batMatrix
}