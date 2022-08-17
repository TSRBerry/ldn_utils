from ldn.streams import StreamOut, StreamIn


class MiiFaceline:
    _typeInfo: int
    _color: int
    _wrinkle: int
    _make: int

    def __init__(self, type_info=0, color=0, wrinkle=0, make=0):
        self._typeInfo = type_info
        self._color = color
        self._wrinkle = wrinkle
        self._make = make

    def __len__(self):
        return 4

    def encode(self) -> bytes:
        stream = StreamOut("<")
        stream.u8(self._typeInfo)
        stream.u8(self._color)
        stream.u8(self._wrinkle)
        stream.u8(self._make)
        return stream.data

    def decode(self, data: bytes):
        stream = StreamIn(data, "<")
        self._typeInfo = stream.u8()
        self._color = stream.u8()
        self._wrinkle = stream.u8()
        self._make = stream.u8()
