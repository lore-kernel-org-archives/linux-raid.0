From: "John Doe" <public_address_911@hotmail.com>
Subject: Re: Problem converting raid-5 array from 2.2.17 into 2.4.22
Date: Wed, 03 Sep 2003 01:56:29 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Law12-F448TtEvzoxJ60000b242@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>Trying to --upgrade with the correct chunk 128kb size set in
[...]

I forgot to mention the errors that occur at the boot time, when
the md driver tries to automatically detect the array; maybe they
lead to something:

Sep  2 23:47:48 galadriel kernel: md: Autodetecting RAID arrays.
Sep  2 23:47:48 galadriel kernel:  [events: 00000000]
Sep  2 23:47:48 galadriel kernel: md: invalid superblock checksum on hda3
Sep  2 23:47:48 galadriel kernel: md: hda3 has invalid sb, not importing!
Sep  2 23:47:48 galadriel kernel: md: could not import hda3!
Sep  2 23:47:48 galadriel kernel:  [events: 00000000]
Sep  2 23:47:48 galadriel kernel: md: invalid superblock checksum on hdb1
Sep  2 23:47:48 galadriel kernel: md: hdb1 has invalid sb, not importing!
Sep  2 23:47:48 galadriel kernel: md: could not import hdb1!
Sep  2 23:47:48 galadriel kernel:  [events: 00000000]
Sep  2 23:47:48 galadriel kernel: md: invalid superblock checksum on hdc1
Sep  2 23:47:48 galadriel kernel: md: hdc1 has invalid sb, not importing!
Sep  2 23:47:48 galadriel kernel: md: could not import hdc1!
Sep  2 23:47:48 galadriel kernel:  [events: 00000000]
Sep  2 23:47:48 galadriel kernel: md: invalid superblock checksum on hdd1
Sep  2 23:47:48 galadriel kernel: md: hdd1 has invalid sb, not importing!
Sep  2 23:47:48 galadriel kernel: md: could not import hdd1!

So it would seem to be a problem with somehow corrupt superblocks.
Can they somehow be fixed, if I know the correct RAID setup?

-J

_________________________________________________________________
Add photos to your messages with MSN 8. Get 2 months FREE*. 
http://join.msn.com/?page=features/featuredemail

