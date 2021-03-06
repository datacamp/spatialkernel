## {y}={0,1,2,..,m-1} converted inside
## calculate var(phat) at point pts

##return NAs at points outside polygon???
varphat <- function(pts, dpts, y, p, h)
{
    npts <- length(pts)/2
    n <- length(y)
    ynames <- names(table(y))
    m <- length(ynames)
    ynames0 <- c(0:(m-1))
    names(ynames0) <- ynames
    yy <- ynames0[as.character(y)]
    c <- rep(1, npts)
    wrksp <- rep(0, n)
    ans<-.C("var_phat", as.double(pts), as.integer(npts), as.double(dpts),
            as.integer(yy), as.double(p), as.integer(n), as.double(h), as.integer(1),
            as.double(c), as.integer(m), as.double(wrksp), pvar=double(npts*m), 
            PACKAGE="spatialkernel")$pvar
    ans <- matrix(ans, ncol=m, dimnames=list(NULL, ynames))
    invisible(list(pvar=ans, pts=pts, dpts=dpts, y=y, h=h))
}
