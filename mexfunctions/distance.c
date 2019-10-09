/*
 * =============================================================
 * distance.c
  
 * Takes two matrices (or one matrix) and outputs the pairwise squared L2 distances of the columns
 *
 * Example:
 * D1=distance(x,z);  
 * D2=distance(x);
 * 
 * all inputs have to be of type double and must have matching number of rows.  
 *
 * copyright 2007 Kilian Q. Weinberger
 * =============================================================
 */

/* $Revision: 1.2 $ */

#include "mex.h"

/* If you are using a compiler that equates NaN to zero, you must
 * compile this example using the flag -DNAN_EQUALS_ZERO. For 
 * example:
 *
 *     mex -DNAN_EQUALS_ZERO findnz.c  
 *
 * This will correctly define the IsNonZero macro for your
   compiler. */

#if NAN_EQUALS_ZERO
#define IsNonZero(d) ((d) != 0.0 || mxIsNaN(d))
#else
#define IsNonZero(d) ((d) != 0.0)
#endif


double square(double x) { return(x*x);}

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  /* Declare variables. */ 
  int N1,N2, o1,o2,i1,i2;
  int c,r,size1,size2;
  double *X1,*X2,*C,*sx1,*sx2;
  int m,p,n;
  char *chn="N"; 
  char *chn2="T";
  char *chL="L";  
  char *chU="U";    
  double minustwo=-2.0,one=1.0, zero=0.0;



  /* Check for proper number of input and output arguments. */    
  if (nrhs != 1 && nrhs!=2) {
    mexErrMsgTxt("Two input arguments required.");
  } 

  if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments.");
  }

  /* Check data type of input argument. */
  if (!(mxIsDouble(prhs[0]))) {
   mexErrMsgTxt("Input array must be of type double.");
  }

    
  /* Get the number of elements in the input argument. */
  N1 = mxGetNumberOfElements(prhs[0]);


  if(nrhs==2){  
  /* Get the data. */
  X1  = mxGetPr(prhs[0]);
  X2  = mxGetPr(prhs[1]);

  p = mxGetM(prhs[0]);
  m = mxGetN(prhs[0]);
  n = mxGetN(prhs[1]);
  
 if(p!=mxGetM(prhs[1])) mexErrMsgTxt("Inner dimensions must agree!\n");
  
  plhs[0]=mxCreateDoubleMatrix(m,n,mxREAL);
  C=mxGetPr(plhs[0]);

  /* Computer C=-2.*X1'*X2 */
  dgemm_ (chn2,chn,&m, &n, &p, &minustwo, X1, &p, X2, &p, &zero, C, &m);

  /* compute the squares of X1*/
  sx1=mxCalloc(m,sizeof(double));
  i1=0;i2=0;
  for(c=0;c<m;c++){
    sx1[c]=0;
   for(r=0;r<p;r++) {
     sx1[c]=sx1[c]+X1[i1]*X1[i1];/*square(X1[i1]);   */
     i1=i1+1;
    }
   i2=i2+1;
  }

  /* compute the squares of X2*/  
  sx2=mxCalloc(n,sizeof(double));
  i1=0;
  for(c=0;c<n;c++){
   for(r=0;r<p;r++) {
     sx2[c]=sx2[c]+square(X2[i1]);   
     i1=i1+1;
    }
  }

  /* compute distance as x1^2+x2^2-2x1'*x2 */
  i1=0;
  for(c=0;c<n;c++){
   for(r=0;r<m;r++) {
     C[i1]=C[i1]+sx1[r]+sx2[c]; /*+sx2[r];*/
    i1=i1+1;
   }
  }
}
 else
{
  /* In the case of only one input we can exploint the fact that the output matrix is symmetrc */
  /* Get the data. */
  X1  = mxGetPr(prhs[0]);
  p = mxGetM(prhs[0]);
  m = mxGetN(prhs[0]);  
  
  /* Create empty output matrix - we rely on the fact that it will be filled with zeros */
  plhs[0]=mxCreateDoubleMatrix(m,m,mxREAL);
  C=mxGetPr(plhs[0]);

  /* Compute -2.*X1'*X1 */
  dsyrk_ (chU,chn2,&m, &p, &minustwo, X1, &p, &zero, C, &m); 

  /* Compute X1.^2 */
  sx1=mxCalloc(m,sizeof(double));
  i1=0;i2=0;
  for(c=0;c<m;c++){
   for(r=0;r<p;r++) {
     sx1[i2]=sx1[i2]+square(X1[i1]);   
     i1=i1+1;
    }
   i2=i2+1;
  }

  /* Compute distances as d=x1^2+x2^2-2*x1*x2 */
  i1=0;
  for(c=0;c<m;c++){
   for(r=0;r<=c;r++) {
     C[i1]=C[i1]+sx1[c]+sx1[r];
     i1=i1+1;
   }
   i1+=(m-r);
  }
  /* Fill in symmetric values */
  for(c=0;c<m;c++){
      for(r=c+1;r<m;r++){
          C[c*m+r]=C[r*m+c];
      }
  }
}
}

