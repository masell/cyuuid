#distutils: language = c

RESERVED_NCS = 'reserved for NCS compatibility'
RFC_4122 = 'specified in RFC 4122'
RESERVED_MICROSOFT = 'reserved for Microsoft compatibility'
RESERVED_FUTURE = 'reserved for future definition'

cdef extern from "header_int128.h":
    ctypedef unsigned long long int128

from uuid import UUID as _UUID

cdef class UUID:
    cdef int128 value

    def __cinit__(self, value not None):
        if isinstance(value, _UUID):
            self.value = int(value)
        elif isinstance(value, int):
            self.value = value
        elif isinstance(value, bytes):
            self.value = int.from_bytes(value, 'big')
        elif isinstance(value, str):
            value = value.replace('urn:', '').replace('uuid:', '')
            value = value.strip('{}').replace('-', '')
            if len(value) != 32:
                raise ValueError('badly formed hexadecimal UUID string')
            self.value = int(value, 16)
        else:
            raise TypeError("Value must be int, byte, str or UUID")

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
