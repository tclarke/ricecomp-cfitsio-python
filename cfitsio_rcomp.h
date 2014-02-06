#ifndef CFITSIO_RCOMP_H
#define CFITSIO_RCOMP_H

extern int fits_rcomp(int a[], int nx, unsigned char *c, int clen, int nblock);
extern int fits_rcomp_byte(signed char a[], int nx, unsigned char *c, int clen, int nblock);
extern int fits_rcomp_short(short a[], int nx, unsigned char *c, int clen, int nblock);
extern int fits_rdecomp(unsigned char *c, int clen, int array[], int nx, int nblock);
extern int fits_rdecomp_byte(unsigned char *c, int clen, char array[], int nx, int nblock);
extern int fits_rdecomp_short(unsigned char *c, int clen, short array[], int nx, int nblock);

#endif
