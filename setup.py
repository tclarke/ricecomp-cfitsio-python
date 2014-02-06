from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
   name="ricecomp-cfitsio",
   version="1.0",
   description="Rice compression and decompression for Python.",
   long_description="Rice comression and decompression using the routines in the cfitsio library.",
   author="Trevor R.H. Clarke",
   author_email="trevor@notcows.com",
   url="https://github.com/tclarke/ricecomp-cfitsio-python.git",
   license="BSD License",
   classifiers=[
          'Development Status :: 4 - Beta',
          'Intended Audience :: Developers',
          'License :: OSI Approved :: BSD License',
          'Operating System :: OS Independent',
          'Programming Language :: Python',
          'Topic :: Software Development :: Libraries :: Python Modules',
          'Topic :: System :: Archiving :: Compression',
      ],
   keywords = ('compression','rice','lossless','module'),
   requires = ["Cython (>=0.2)","numpy (>=1.7.0)"],
   cmdclass = {'build_ext':build_ext},
   ext_modules = [Extension("ricecomp", ["ricecomp.pyx"],
                            libraries=["cfitsio"])]
)
