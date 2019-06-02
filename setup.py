from setuptools import setup, Extension, _install_setup_requires

REQUIRES = [
    'setuptools>=18.0',
    'cython>=0.29'
]

_install_setup_requires({'setup_requires':REQUIRES})

from Cython.Build import cythonize
    
setup(
    name='cyuuid',
    version='0.1.1',
    author='martin.asell',
    description='Cython implementation of RFC4122',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    install_requires=REQUIRES,
    setup_requires=REQUIRES,
    license='PSF',
    url='https://github.com/masell/cyuuid/',
    packages=['cyuuid', ],
    ext_modules = cythonize(
	Extension('cyuuid.*', sources=["cyuuid/*.pyx"])
    ),
    include_package_data=True,
    zip_safe=False,
    classifiers=[
        'Development Status :: 4 - Beta',
        'License :: OSI Approved :: Python Software Foundation License',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Cython',
        'Intended Audience :: Developers',
    ]
)
