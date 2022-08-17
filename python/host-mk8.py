#!/usr/bin/env python3

# This script creates a network for Mario Kart 8: Deluxe.
import mii
import ldn
from ldn.streams import StreamOut
import trio
import random


NICKNAME = "Hello"
PASSWORD = "MarioKart8Delux" + "\0" * 17
MII_INFO = mii.Mii(
    random.randbytes(16),
    "MyMii",
    mii.FontRegion.Standard,
    mii.FavoriteColor.Purple,
    0,
    50,
    28,
    False,
    0,
    mii.MiiFaceline(),
    mii.MiiHair(20, 42, False),
    mii.eye.MiiEye(26, 11, 4, 1, 4, 4, 12),
    mii.eyebrow.MiiEyebrow(0, 5, 2, 2, 5, 2, 12),
    mii.nose.MiiNose(1, 2, 5),
    mii.mouth.MiiMouth(12, 18, 4, 4, 12),
    mii.beard.MiiBeard(8, 0),
    mii.mustache.MiiMustache(0, 2, 5),
    mii.glass.MiiGlass(0, 3, 3, 4),
    mii.mole.MiiMole(False, 3, 1, 10)
)


def make_application_data():
    # >> create 148 bytes
    stream = StreamOut("<")
    # Build the pia header (v5.6)
    stream.u32(random.randint(0, 0xFFFFFFFF))  # Session id
    stream.u32(0)  # CRC-32
    stream.u8(1)  # System communication version
    stream.pad(3)
    stream.pad(8)  # always 0, not padding?
    # --> 20 bytes

    # MK8D header
    stream.u8(1)  # Unknown
    stream.chars(NICKNAME + "\0" * (33 - len(NICKNAME)))  # playerName
    stream.pad(2)  # May not be initialized with 0
    # --> 56 bytes

    # Mii info
    stream.write(MII_INFO.encode())
    # 88 bytes
    # --> 144 bytes

    # Unknown
    stream.u32(0)

    assert stream.size() == 148
    return stream.data


async def main():
    print("Creating network.")
    param = ldn.CreateNetworkParam()
    param.local_communication_id = 0x0100152000022000
    param.game_mode = 0
    param.max_participants = 8
    param.application_data = make_application_data()
    param.name = NICKNAME
    param.app_version = 7
    param.password = PASSWORD
    async with ldn.create_network(param) as network:
        print("Listening for events.")
        while True:
            event = await network.next_event()
            if isinstance(event, ldn.JoinEvent):
                participant = event.participant
                print("%s joined the network (%s / %s)" % (participant.name,
                                                           participant.mac_address, participant.ip_address))
            elif isinstance(event, ldn.LeaveEvent):
                participant = event.participant
                print("%s left the network (%s / %s)" % (participant.name,
                                                         participant.mac_address, participant.ip_address))
trio.run(main)
