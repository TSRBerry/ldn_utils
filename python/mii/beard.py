from ldn.streams import StreamOut, StreamIn


class MiiBeard:
    _color: int
    _typeInfo: int

    def __init__(self, color=0, type_info=0):
        self._color = color
        self._typeInfo = type_info

    def __len__(self):
        return 2

    def encode(self) -> bytes:
        stream = StreamOut("<")
        stream.u8(self._color)
        stream.u8(self._typeInfo)
        return stream.data

    def decode(self, data: bytes):
        stream = StreamIn(data, "<")
        self._color = stream.u8()
        self._typeInfo = stream.u8()
