from unittest import TestCase
import unittest
from uuid import UUID as _UUID
from cyuuid import UUID

class TestUUIDCompat(TestCase):
    def setUp(self):
        self._uuid = _UUID("a8098c1a-f86e-11da-bd1a-00112444be1e")
        self._cyuuid = UUID("a8098c1a-f86e-11da-bd1a-00112444be1e")

    def test_int(self):
        self.assertEqual(int(self._cyuuid), int(self._uuid))

    def test_hash(self):
        self.assertEqual(hash(self._cyuuid), hash(self._uuid))

    def test_str(self):
        self.assertEqual(str(self._cyuuid), str(self._uuid))

    def test_bytes(self):
        self.assertEqual(self._cyuuid.bytes, self._uuid.bytes)

    def test_bytes_le(self):
        self.assertEqual(self._cyuuid.bytes_le, self._uuid.bytes_le)

    def test_fields(self):
        self.assertEqual(self._cyuuid.fields, self._uuid.fields)

    def test_time_low(self):
        self.assertEqual(self._cyuuid.time_low, self._uuid.time_low)

    def test_time_mid(self):
        self.assertEqual(self._cyuuid.time_mid, self._uuid.time_mid)

    def test_time_hi_version(self):
        self.assertEqual(self._cyuuid.time_hi_version, self._uuid.time_hi_version)

    def test_clock_seq_hi_variant(self):
        self.assertEqual(self._cyuuid.clock_seq_hi_variant, self._uuid.clock_seq_hi_variant)

    def test_clock_seq_low(self):
        self.assertEqual(self._cyuuid.clock_seq_low, self._uuid.clock_seq_low)

    def test_time(self):
        self.assertEqual(self._cyuuid.time, self._uuid.time)

    def test_clock_seq(self):
        self.assertEqual(self._cyuuid.clock_seq, self._uuid.clock_seq)

    def test_node(self):
        self.assertEqual(self._cyuuid.node, self._uuid.node)

    def test_hex(self):
        self.assertEqual(self._cyuuid.hex, self._uuid.hex)

    def test_urn(self):
        self.assertEqual(self._cyuuid.urn, self._uuid.urn)

    def test_variant(self):
        self.assertEqual(self._cyuuid.variant, self._uuid.variant)

    def test_version(self):
        self.assertEqual(self._cyuuid.version, self._uuid.version)

