from setuptools import setup, Extension

REQUIRES = [
    'setuptools>=18.0',
    'cython>=0.29'
]
    
setup(
    name='cyuuid',
    version='0.1.0',
    author='martin.asell',
    description='Cython implementation of RFC4122',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    install_requires=REQUIRES,
    setup_requires=REQUIRES,
    license='PSF',
    url='https://github.com/masell/cyuuid/',
    zip_safe=False,
    ext_modules = [
	Extension(
	    'cyuuid',
	    sources=['cyuuid/cyuuid.pyx']
        )
    ],
    classifiers=[
        'Development Status :: 4 - Beta',
        'License :: OSI Approved :: Python Software Foundation License',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Cython',
        'Intended Audience :: Developers',
    ]
)
