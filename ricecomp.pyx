cdef extern from "cfitsio_rcomp.h":
   int fits_rcomp(int *input, int nx, unsigned char *buf, int maxbuflen, int nblock)
   int fits_rcomp_byte(signed char *input, int nx, unsigned char *buf, int maxbuflen, int nblock)
   int fits_rcomp_short(short *input, int nx, unsigned char *buf, int maxbuflen, int nblock)
   int fits_rdecomp(unsigned char *buf, int buflen, int *output, int nx, int nblock)
   int fits_rdecomp_byte(unsigned char *buf, int buflen, char *output, int nx, int nblock)
   int fits_rdecomp_short(unsigned char *buf, int buflen, short *output, int nx, int nblock)
cdef extern from "cfitsio/fitsio.h":
   int ffgmsg(char *err_message)

class RiceError(Exception):
   def __init__(self, msg=None):
      cdef int rval
      cdef char[80] msg_c
      tmp = []
      if msg is not None:
         tmp.append(msg)
      while ffgmsg(msg_c) > 0:
         pstr = <bytes>msg_c
         tmp.append("  "+(pstr.strip()))
      Exception.__init__(self,"\n".join(tmp))

import numpy as np
cimport numpy as np
from cython.view cimport array as cvarray

def rcomp8(np.ndarray data, int nblock):
   assert(data.size > 0)
   assert(nblock > 0)
   if data.dtype != np.int8: raise ValueError("Input data must be int8")
   cdef int nx = data.size
   cdef int maxbuflen = data.size * data.itemsize + 100 # need a bit extra for uncompressible pieces
   cdef signed char [::1] pData = data.reshape(-1)
   cdef unsigned char [::1] pBuf

   buf = np.ndarray((maxbuflen,), dtype=np.uint8)
   pBuf = buf
   blen = fits_rcomp_byte(&pData[0], nx, &pBuf[0], maxbuflen, nblock)
   if blen <= 0:
      raise RiceError("Failure to compress data")
   buf = buf[:blen]
   return buf

def rdecomp8(np.ndarray buf, int nx, int nblock):
   assert(buf.size > 0)
   assert(nx > 0)
   assert(nblock > 0)
   if buf.dtype != np.uint8: raise ValueError("Buffer must be uint8")
   cdef int buflen = buf.size
   cdef unsigned char [:] pBuf = buf.reshape(-1)
   cdef char [:] pData

   data = np.ndarray((nx,), dtype=np.int8)
   pData = data
   if fits_rdecomp_byte(&pBuf[0], buflen, &pData[0], nx, nblock) != 0:
      raise RiceError("Failure to decompress data")
   return data

def rcomp16(np.ndarray data, int nblock):
   assert(data.size > 0)
   assert(nblock > 0)
   if data.dtype != np.int16: raise ValueError("Input data must be int32")
   cdef int nx = data.size
   cdef int maxbuflen = data.size * data.itemsize
   cdef short [::1] pData = data.reshape(-1)
   cdef unsigned char [::1] pBuf

   buf = np.ndarray((maxbuflen,), dtype=np.uint8)
   pBuf = buf
   blen = fits_rcomp_short(&pData[0], nx, &pBuf[0], maxbuflen, nblock)
   if blen <= 0:
      raise RiceError("Failure to compress data")
   buf = buf[:blen]
   return buf

def rdecomp16(np.ndarray buf, int nx, int nblock):
   assert(buf.size > 0)
   assert(nx > 0)
   assert(nblock > 0)
   if buf.dtype != np.uint8: raise ValueError("Buffer must be uint8")
   cdef int buflen = buf.size
   cdef unsigned char [:] pBuf = buf.reshape(-1)
   cdef short [:] pData

   data = np.ndarray((nx,), dtype=np.int16)
   pData = data
   if fits_rdecomp_short(&pBuf[0], buflen, &pData[0], nx, nblock) != 0:
      raise RiceError("Failure to decompress data")
   return data

def rcomp32(np.ndarray data, int nblock):
   assert(data.size > 0)
   assert(nblock > 0)
   if data.dtype != np.int32: raise ValueError("Input data must be int32")
   cdef int nx = data.size
   cdef int maxbuflen = data.size * data.itemsize
   cdef int [::1] pData = data.reshape(-1)
   cdef unsigned char [::1] pBuf

   buf = np.ndarray((maxbuflen,), dtype=np.uint8)
   pBuf = buf
   blen = fits_rcomp(&pData[0], nx, &pBuf[0], maxbuflen, nblock)
   if blen <= 0:
      raise RiceError("Failure to compress data")
   buf = buf[:blen]
   return buf

def rdecomp32(np.ndarray buf, int nx, int nblock):
   assert(buf.size > 0)
   assert(nx > 0)
   assert(nblock > 0)
   if buf.dtype != np.uint8: raise ValueError("Buffer must be uint8")
   cdef int buflen = buf.size
   cdef unsigned char [:] pBuf = buf.reshape(-1)
   cdef int [:] pData

   data = np.ndarray((nx,), dtype=np.int32)
   pData = data
   if fits_rdecomp(&pBuf[0], buflen, &pData[0], nx, nblock) != 0:
      raise RiceError("Failure to decompress data")
   return data

def condition_unsigned_input(data):
   if data.dtype == np.uint8:
      data = data.astype(np.int)
      data -= 128
      return data.astype(np.int8)
   elif data.dtype == np.uint16:
      data = data.astype(np.int)
      data -= 32768
      return data.astype(np.int16)
   elif data.dtype == np.uint32:
      data = data.astype(np.int)
      data -= 2147483648
      return data.astype(np.int32)
   raise ValueError("Invalid type")

def condition_unsigned_output(data):
   if data.dtype == np.int8:
      data = data.astype(np.int)
      data += 128
      return data.astype(np.uint8)
   elif data.dtype == np.int16:
      data = data.astype(np.int)
      data += 32768
      return data.astype(np.uint16)
   elif data.dtype == np.int32:
      data = data.astype(np.int)
      data += 2147483648
      return data.astype(np.uint32)
   raise ValueError("Invalid type")

def rcomp(np.ndarray data, int nblock=32):
   """
   Perform rice compression on int data.
   Input must be signed or unsigned 8, 16, or 32 bit data.

   @param data A numpy array of data to compress.
   @param nblock The rice compression block size.
   @return A numpy array of np.uint8 compressed data.
   """
   assert(data.size > 0)
   assert(nblock > 0)
   if data.dtype in [np.uint8,np.uint16,np.uint32]:
      data = condition_unsigned_input(data)
   if data.dtype == np.int8:
      buf = rcomp8(data, nblock)
   elif data.dtype == np.int16:
      buf = rcomp16(data, nblock)
   elif data.dtype == np.int32:
      buf = rcomp32(data, nblock)
   else:
      raise ValueError("Input data type not supported.")
   return buf

def rdecomp(np.ndarray buf, dtype, int nx, int nblock=32):
   """
   Perform rice decompression on int data.

   @param buf A numpy array of np.uint8 data to decompress.
   @param dtype The data type of the decompressed data. (must be int8, uint8, int16, uint16, int32, or uint32)
   @param nx The number of elements in the decompessed data. (must be the same as the data length used for compression)
   @param nblock The rice compression block size. (must be the same value used for compression)
   @return A numpy array of decompressed data.
   """
   assert(buf.size > 0)
   assert(nx > 0)
   assert(nblock > 0)
   if dtype == np.int8 or dtype == np.uint8:
      out = rdecomp8(buf, nx, nblock)
   elif dtype == np.int16 or dtype == np.uint16:
      out = rdecomp16(buf, nx, nblock)
   elif dtype == np.int32 or dtype == np.uint32:
      out = rdecomp32(buf, nx, nblock)
   else:
      raise ValueError("Input data type not supported. %r" % dtype)
   if dtype in [np.uint8,np.uint16,np.uint32]:
      out = condition_unsigned_output(out)
   return out
