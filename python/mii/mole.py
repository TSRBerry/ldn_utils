from ldn.streams import StreamOut, StreamIn


class MiiMole:
    _hasMole: bool
    _scale: int
    _x: int
    _y: int

    def __init__(self, has_mole=False, scale=0, x=0, y=0):
        self._hasMole = has_mole
        self._scale = scale
        self._x = x
        self._y = y

    def __len__(self):
        return 4

    def encode(self) -> bytes:
        stream = StreamOut("<")
        stream.bool(self._hasMole)
        stream.u8(self._scale)
        stream.u8(self._x)
        stream.u8(self._y)
        return stream.data

    def decode(self, data: bytes):
        stream = StreamIn(data, "<")
        self._hasMole = stream.bool()
        self._scale = stream.u8()
        self._x = stream.u8()
        self._y = stream.u8()
