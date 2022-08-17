from ldn.streams import StreamOut, StreamIn


class MiiMouth:
    _typeInfo: int
    _color: int
    _scale: int
    _aspect: int
    _y: int

    def __init__(self, type_info=0, color=0, scale=0, aspect=0, y=0):
        self._typeInfo = type_info
        self._color = color
        self._scale = scale
        self._aspect = aspect
        self._y = y

    def __len__(self):
        return 5

    def encode(self) -> bytes:
        stream = StreamOut("<")
        stream.u8(self._typeInfo)
        stream.u8(self._color)
        stream.u8(self._scale)
        stream.u8(self._aspect)
        stream.u8(self._y)
        return stream.data

    def decode(self, data: bytes):
        stream = StreamIn(data, "<")
        self._typeInfo = stream.u8()
        self._color = stream.u8()
        self._scale = stream.u8()
        self._aspect = stream.u8()
        self._y = stream.u8()
