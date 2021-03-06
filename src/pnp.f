C
C
C License to Use
C
C Copyright (c) 1970-2003, Wm. Randolph Franklin
C
C Permission is hereby granted, free of charge, to any person obtaining 
C a copy of this software and associated documentation files (the "Software"), 
C to deal in the Software without restriction, including without limitation 
C the rights to use, copy, modify, merge, publish, distribute, sublicense, 
C and/or sell copies of the Software, and to permit persons to whom the 
C Software is furnished to do so, subject to the following conditions:
C
C   1. Redistributions of source code must retain the above copyright notice, 
C this list of conditions and the following disclaimers.
C   2. Redistributions in binary form must reproduce the above copyright notice 
C in the documentation and/or other materials provided with the distribution.
C   3. The name of W. Randolph Franklin may not be used to endorse or promote 
C products derived from this Software without specific prior written permission. 
C
C THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
C INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
C PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
C HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
C OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
C SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
C
C
C>>>PNP1 
C 
C .................................................................. 
C 
C SUBROUTINE PNPOLY 
C 
C PURPOSE 
C TO DETERMINE WHETHER A POINT IS INSIDE A POLYGON 
C 
C USAGE 
C CALL PNPOLY (PX, PY, XX, YY, N, INOUT ) 
C 
C DESCRIPTION OF THE PARAMETERS 
C PX - X-COORDINATE OF POINT IN QUESTION. 
C PY - Y-COORDINATE OF POINT IN QUESTION. 
C XX - N LONG VECTOR CONTAINING X-COORDINATES OF 
C VERTICES OF POLYGON. 
C YY - N LONG VECTOR CONTAING Y-COORDINATES OF 
C VERTICES OF POLYGON. 
C N - NUMBER OF VERTICES IN THE POLYGON. 
C INOUT - THE SIGNAL RETURNED: 
C -1 IF THE POINT IS OUTSIDE OF THE POLYGON, 
C 0 IF THE POINT IS ON AN EDGE OR AT A VERTEX, 
C 1 IF THE POINT IS INSIDE OF THE POLYGON. 
C 2 IF N>2000 
C
C REMARKS 
C THE VERTICES MAY BE LISTED CLOCKWISE OR ANTICLOCKWISE. 
C THE FIRST MAY OPTIONALLY BE REPEATED, IF SO N MAY 
C OPTIONALLY BE INCREASED BY 1. 
C THE INPUT POLYGON MAY BE A COMPOUND POLYGON CONSISTING 
C OF SEVERAL SEPARATE SUBPOLYGONS. IF SO, THE FIRST VERTEX 
C OF EACH SUBPOLYGON MUST BE REPEATED, AND WHEN CALCULATING 
C N, THESE FIRST VERTICES MUST BE COUNTED TWICE. 
C INOUT IS THE ONLY PARAMETER WHOSE VALUE IS CHANGED. 
C THE SIZE OF THE ARRAYS MUST BE INCREASED IF N > MAXDIM 
C WRITTEN BY RANDOLPH FRANKLIN, UNIVERSITY OF OTTAWA, 7/70. 
C 
C SUBROUTINES AND FUNCTION SUBPROGRAMS REQUIRED 
C NONE 
C 
C METHOD 
C A VERTICAL LINE IS DRAWN THRU THE POINT IN QUESTION. IF IT 
C CROSSES THE POLYGON AN ODD NUMBER OF TIMES, THEN THE 
C POINT IS INSIDE OF THE POLYGON. 
C 
C .................................................................. 
C 
C NO REPEAT POINT IN (XX, YY); 
C REPEAT THE FIRST POINT IN THIS SUBROUTINE AUTOMATICALLY;
	SUBROUTINE PNPOLY(PX,PY,XX,YY,N,INOUT) 
	REAL*8 X(3001),Y(3001),PX, PY, XX(N),YY(N) 
	INTEGER N, INOUT
	LOGICAL MX,MY,NX,NY 
	MAXDIM=3000
C	X(N+1) = X(1) OPTIONAL??
C	Y(N+1) = Y(1) OPTIONAL??
	IF(N.LE.MAXDIM)GO TO 6 	
	INOUT=2
	RETURN 
6 	DO 1 I=1,N 
	X(I)=XX(I)-PX 
1 	Y(I)=YY(I)-PY 
	INOUT=-1 
	DO 2 I=1,N 
	J=1+MOD(I,N) 
	MX=X(I).GE.0.0 
	NX=X(J).GE.0.0 
	MY=Y(I).GE.0.0 
	NY=Y(J).GE.0.0 
	IF(.NOT.((MY.OR.NY).AND.(MX.OR.NX)).OR.(MX.AND.NX)) GO TO 2
	IF(.NOT.(MY.AND.NY.AND.(MX.OR.NX).AND..NOT.(MX.AND.NX))) GO TO 3
	INOUT=-INOUT 
	GO TO 2 
3 	IF((Y(I)*X(J)-X(I)*Y(J))/(X(J)-X(I))) 2,4,5 
4 	INOUT=0 
	RETURN 
5 	INOUT=-INOUT 
2 	CONTINUE 
	RETURN 
	END 
C 	
	SUBROUTINE PSNPOLY(PX,PY,PN,XX,YY,N,INOUT) 
	INTEGER PN, N
	REAL*8 XX(N),YY(N) 
	REAL*8 PX(PN), PY(PN)
	INTEGER INOUT(PN)
	DO 1 I=1,PN
	   CALL PNPOLY(PX(I),PY(I),XX,YY,N,INOUT(I))
 1	CONTINUE
	RETURN
	END
