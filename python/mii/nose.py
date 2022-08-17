from ldn.streams import StreamOut, StreamIn


class MiiNose:
    _typeInfo: int
    _scale: int
    _y: int

    def __init__(self, type_info=0, scale=0, y=0):
        self._typeInfo = type_info
        self._scale = scale
        self._y = y

    def __len__(self):
        return 3

    def encode(self) -> bytes:
        stream = StreamOut("<")
        stream.u8(self._typeInfo)
        stream.u8(self._scale)
        stream.u8(self._y)
        return stream.data

    def decode(self, data: bytes):
        stream = StreamIn(data, "<")
        self._typeInfo = stream.u8()
        self._scale = stream.u8()
        self._y = stream.u8()
