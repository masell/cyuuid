#distutils: language = c
#cython: language_level = 3

cdef extern from "header_int128.h":
    ctypedef unsigned long long int128

cdef class UUID:
    cdef int128 value
    cdef _init_fields(self, tuple fields)
    cdef _init_bytes_le(self, bytes bytes_le)
    cdef _init_bytes(self, bytes _bytes)
    cdef _init_hex(self, str hex)
    cdef _init_int(self, int128 _int)
    cdef _init_uuid(self, uuid)
