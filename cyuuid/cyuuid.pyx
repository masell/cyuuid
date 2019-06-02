#distutils: language = c
#cython: language_level = 3

RESERVED_NCS = 'reserved for NCS compatibility'
RFC_4122 = 'specified in RFC 4122'
RESERVED_MICROSOFT = 'reserved for Microsoft compatibility'
RESERVED_FUTURE = 'reserved for future definition'

from uuid import UUID as _UUID

cdef dict params = {'hex':None, 'bytes': None, 'bytes_le': None, 'fields': None, 'int': None, 'version':None, 'uuid': None}

cdef class UUID:
    def __cinit__(self, hex=None, **params):
        cdef dict data = {}
        data.setdefault('hex', hex)
        data.setdefault('bytes', None)
        data.setdefault('bytes_le', None)
        data.setdefault('fields', None)
        data.setdefault('int', None)
        data.setdefault('version', None)
        data.setdefault('uuid', None)
        data.update(params)

        (hex, _bytes, bytes_le, fields, _int, version, uuid) = data.values()

        if [uuid, hex, _bytes, bytes_le, fields, _int].count(None) != 5:
            raise TypeError('one of the hex, bytes, bytes_le, fields, or int arguments must be given')


        if uuid is not None:
            self._init_uuid(uuid)

        if hex is not None:
            self._init_hex(hex)

        if _bytes is not None:
            self._init_bytes(_bytes)

        if bytes_le is not None:
            self._init_bytes_le(bytes_le)

        if fields is not None:
            self._init_fields(fields)

        if _int is not None:
            self._init_int(_int)

        if version is not None:
            if not 1 <= version <= 5:
                raise ValueError('illegal version number')
            self.value &= ~(0xc000 << 48)
            self.value |= 0x8000 << 48
            self.value &= ~(0xf000 << 64)
            self.value |= version << 76

    cdef _init_fields(self, tuple fields):
        if len(fields) != 6:
            raise ValueError('fields is not a 6-tuple')
        cdef int128 time_low = fields[0]
        cdef int128 time_mid = fields[1]
        cdef int128 time_hi_version = fields[2]
        cdef int128 clock_seq_hi_variant = fields[3]
        cdef int128 clock_seq_low= fields[4]
        cdef int128 node = fields[5]

        if not 0 <= time_low < 1<<32:
            raise ValueError('field 1 out of range (need a 32-bit value)')
        if not 0 <= time_mid < 1<<16:
            raise ValueError('field 2 out of range (need a 16-bit value)')
        if not 0 <= time_hi_version < 1<<16:
            raise ValueError('field 3 out of range (need a 16-bit value)')
        if not 0 <= clock_seq_hi_variant < 1<<8:
            raise ValueError('field 4 out of range (need an 8-bit value)')
        if not 0 <= clock_seq_low < 1<<8:
            raise ValueError('field 5 out of range (need an 8-bit value)')
        if not 0 <= node < 1<<48:
            raise ValueError('field 6 out of range (need a 48-bit value)')
        clock_seq = (clock_seq_hi_variant << 8) | clock_seq_low
        self.value = ((time_low << 96) | (time_mid << 80) | (time_hi_version << 64) | (clock_seq << 48) | node)

    cdef _init_bytes_le(self, bytes bytes_le):
            cdef bytes _bytes = (bytes_le[4-1::-1] + bytes_le[6-1:4-1:-1] + bytes_le[8-1:6-1:-1] + bytes_le[8:])
            self._init_bytes(_bytes)

    cdef _init_bytes(self, bytes _bytes):
        if len(_bytes) != 16:
            raise ValueError('bytes is not a 16-char string')
        self.value = int.from_bytes(_bytes, 'big')

    cdef _init_hex(self, str hex):
        hex= hex.replace('urn:', '').replace('uuid:', '')
        hex = hex.strip('{}').replace('-', '')
        if len(hex) != 32:
            raise ValueError('badly formed hexadecimal UUID string')
        self.value = int(hex, 16)

    cdef _init_int(self, int128 _int):
        self.value = _int

    cdef _init_uuid(self, uuid):
        self.value = int(uuid)

    def __int__(self):
        return self.value

    def __eq__(self, other):
        if isinstance(other, UUID):
            return self.value == other.value
        elif isinstance(other, _UUID):
            return self.value == int(other)
        else:
            return NotImplemented

    def __lt__(self, other):
        if isinstance(other, UUID):
            return self.value < other.value
        elif isinstance(other, _UUID):
            return self.value < int(other)
        else:
            return NotImplemented

    def __gt__(self, other):
        if isinstance(other, UUID):
            return self.value > other.value
        elif isinstance(other, _UUID):
            return self.value > int(other)
        else:
            return NotImplemented

    def __le__(self, other):
        if isinstance(other, UUID):
            return self.value <= other.value
        elif isinstance(other, _UUID):
            return self.value <= int(other)
        else:
            return NotImplemented

    def __ge__(self, other):
        if isinstance(other, UUID):
            return self.value >= other.value
        elif isinstance(other, _UUID):
            return self.value >= int(other)
        else:
            return NotImplemented

    def __hash__(self):
        return hash(self.value)

    def __repr__(self):
        return '%s(%r)' % (self.__class__.__name__, str(self))

    def __setattr__(self, name, value):
        raise TypeError('UUID objects are immutable')

    def __str__(self):
        hex = '%032x' % self.value
        return '%s-%s-%s-%s-%s' % (
            hex[:8], hex[8:12], hex[12:16], hex[16:20], hex[20:])

    @property
    def bytes(self):
        return self.value.to_bytes(16, 'big')

    @property
    def bytes_le(self):
        bytes = self.bytes
        return (bytes[4-1::-1] + bytes[6-1:4-1:-1] + bytes[8-1:6-1:-1] +
                bytes[8:])

    @property
    def fields(self):
        return (self.time_low, self.time_mid, self.time_hi_version,
                self.clock_seq_hi_variant, self.clock_seq_low, self.node)

    @property
    def time_low(self):
        return self.value >> 96

    @property
    def time_mid(self):
        return (self.value >> 80) & 0xffff

    @property
    def time_hi_version(self):
        return (self.value >> 64) & 0xffff

    @property
    def clock_seq_hi_variant(self):
        return (self.value >> 56) & 0xff

    @property
    def clock_seq_low(self):
        return (self.value >> 48) & 0xff

    @property
    def time(self):
        return (((self.time_hi_version & 0x0fff) << 48) |
                (self.time_mid << 32) | self.time_low)

    @property
    def clock_seq(self):
        return (((self.clock_seq_hi_variant & 0x3f) << 8) |
                self.clock_seq_low)

    @property
    def node(self):
        return self.value & 0xffffffffffff

    @property
    def hex(self):
        return '%032x' % self.value

    @property
    def urn(self):
        return 'urn:uuid:' + str(self)

    @property
    def variant(self):
       if not self.value & (0x8000 << 48):
           return RESERVED_NCS
       elif not self.value & (0x4000 << 48):
           return RFC_4122
       elif not self.value & (0x2000 << 48):
           return RESERVED_MICROSOFT
       else:
           return RESERVED_FUTURE

    @property
    def version(self):
        # The version bits are only meaningful for RFC 4122 UUIDs.
        if self.variant == RFC_4122:
            return (self.value >> 76) & 0xf
