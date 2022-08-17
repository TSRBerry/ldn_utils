from ldn.streams import StreamOut, StreamIn


class MiiHair:
    _typeInfo: int
    _color: int
    _isHairFlip: bool

    def __init__(self, type_info=0, color=0, is_hair_flip=False):
        self._typeInfo = type_info
        self._color = color
        self._isHairFlip = is_hair_flip

    def __len__(self):
        return 3

    def encode(self) -> bytes:
        stream = StreamOut("<")
        stream.u8(self._typeInfo)
        stream.u8(self._typeInfo)
        stream.bool(self._isHairFlip)
        return stream.data

    def decode(self, data: bytes):
        stream = StreamIn(data, "<")
        self._typeInfo = stream.u8()
        self._color = stream.u8()
        self._isHairFlip = stream.bool()
