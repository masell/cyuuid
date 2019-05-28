from Cython.Build import cythonize
from setuptools import setup, Extension

NAME = "cyuuid"
VERSION = "0.1.0"

REQUIRES = [
    "cython>=0.29"
]
    
setup(
    name=NAME,
    version=VERSION,
    description="Cython implementation of RFC4122",
    author="martin.asell",
    author_email="martin.asell@localhost",
    install_requires=REQUIRES,
    setup_requires=REQUIRES,
    license="PSF",
    url="https://github.com/masell/cyuuid/",
    zip_safe=False,
    ext_modules = cythonize(
	Extension(
	    "cyuuid",
	    sources=["cyuuid/**/*.pyx"],
	    ),
	language_level=3
    )
)
