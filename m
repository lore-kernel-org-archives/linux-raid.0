From: "Neil ." <neil.perrie@gmail.com>
Subject: Lost raid 5 volume
Date: Sat, 13 Dec 2014 11:48:38 +1100
Message-ID: <CADhQzuraHNZ1MaMw4OP0-3+vxRcB_TAN-_R2_eaTOQcEfUv8+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am looking for some help in trying to recover a raid 5 volume. Is
this the right place? What data should I provide to get the ball
rolling?

The back story is its 4 x 6tb drives in raid 5. Was created on a WD
EX4 NAS box. The NAS reported 2 simultaneous drive failures on wake up
from standby mode. On reboot both drives appear fine. No SMART errors
etc but the raid 5 volume is gone.

It's the second time the NAS box has lost data like this. Previous
time it was a mix of 2 and 3 tb drives with a 6 tb raid 5 and a 1 tb
mirror. mdadm on the nas is from 2006 (don't have the exact version to
hand).

I was thinking to put the drives into a PC, boot to a recent distro on
usb stick and see if I can recover the data there. Then setup it up
more or less permanently (and ditch the NAS). Not sure of the best way
to proceed.

I'd be really grateful for any assistance or guidance.

Cheers
