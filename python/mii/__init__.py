from mii.font_region import FontRegion
from mii.favorite_color import FavoriteColor
from mii.faceline import MiiFaceline
from mii.hair import MiiHair
from mii.eye import MiiEye
from mii.eyebrow import MiiEyebrow
from mii.nose import MiiNose
from mii.mouth import MiiMouth
from mii.beard import MiiBeard
from mii.mustache import MiiMustache
from mii.glass import MiiGlass
from mii.mole import MiiMole

from ldn.streams import StreamOut, StreamIn


class Mii:
    _createId: bytes
    _name: str
    _fontRegion: FontRegion
    _favoriteColor: FavoriteColor
    _gender: int
    _height: int
    _build: int
    _isSpecial: bool
    _regionMove: int
    _faceline: MiiFaceline
    _hair: MiiHair
    _eye: MiiEye
    _eyebrow: MiiEyebrow
    _nose: MiiNose
    _mouth: MiiMouth
    _beard: MiiBeard
    _mustache: MiiMustache
    _glass: MiiGlass
    _mole: MiiMole

    def _resize(self):
        if len(self._createId) < 16:
            self._createId += bytes(16 - len(self._createId))
        if len(self._name) < 11:
            self._name += "\0" * (11 - len(self._name))

    def __init__(self,
                 create_id=bytes(16), name="\0" * 11, font_region=FontRegion.Standard, favorite_color=FavoriteColor.Red,
                 gender=0, height=0, build=0,
                 is_special=False, region_move=0, faceline=MiiFaceline(), hair=MiiHair(), eye=MiiEye(),
                 eyebrow=MiiEyebrow(),
                 nose=MiiNose(), mouth=MiiMouth(), beard=MiiBeard(), mustache=MiiMustache(), glass=MiiGlass(),
                 mole=MiiMole()):
        self._createId = create_id
        self._name = name
        self._fontRegion = font_region
        self._favoriteColor = favorite_color
        self._gender = gender
        self._height = height
        self._build = build
        self._isSpecial = is_special
        self._regionMove = region_move
        self._faceline = faceline
        self._hair = hair
        self._eye = eye
        self._eyebrow = eyebrow
        self._nose = nose
        self._mouth = mouth
        self._beard = beard
        self._mustache = mustache
        self._glass = glass
        self._mole = mole

        self.check()

    def __len__(self):
        return 0x58

    def check(self) -> bool:
        if len(self._createId) > 16:
            return False
        if len(self._name) > 11:
            return False
        return True

    def encode(self) -> bytes:
        self._resize()
        stream = StreamOut("<")
        stream.write(self._createId)
        stream.wchars(self._name)
        stream.u8(self._fontRegion)
        stream.u8(self._favoriteColor)
        stream.u8(self._gender)
        stream.u8(self._height)
        stream.u8(self._build)
        stream.bool(self._isSpecial)
        stream.u8(self._regionMove)
        stream.write(self._faceline.encode())
        stream.write(self._hair.encode())
        stream.write(self._eye.encode())
        stream.write(self._eyebrow.encode())
        stream.write(self._nose.encode())
        stream.write(self._mouth.encode())
        stream.write(self._beard.encode())
        stream.write(self._mustache.encode())
        stream.write(self._glass.encode())
        stream.write(self._mole.encode())
        stream.pad(1)
        return stream.data

    def decode(self, data: bytes):
        stream = StreamIn(data, "<")
        self._createId = stream.read(16)
        self._name = stream.wchars(11)
        self._favoriteColor = stream.u8()
        self._fontRegion = stream.u8()
        self._gender = stream.u8()
        self._height = stream.u8()
        self._build = stream.u8()
        self._isSpecial = stream.bool()
        self._regionMove = stream.u8()
        self._faceline.decode(stream.read(len(self._faceline)))
        self._hair.decode(stream.read(len(self._hair)))
        self._eye.decode(stream.read(len(self._eye)))
        self._eyebrow.decode(stream.read(len(self._eyebrow)))
        self._nose.decode(stream.read(len(self._nose)))
        self._mouth.decode(stream.read(len(self._mouth)))
        self._beard.decode(stream.read(len(self._beard)))
        self._mustache.decode(stream.read(len(self._mustache)))
        self._glass.decode(stream.read(len(self._glass)))
        self._mole.decode(stream.read(len(self._mole)))
        stream.pad(1)
