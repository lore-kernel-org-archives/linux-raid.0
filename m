From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Can md/mdadm deal with non-standard size of internal bitmap?
Date: Tue, 8 Sep 2009 15:44:38 +0200
Message-ID: <slrnhacnu6.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello (most likely Hello Neil :)),

are md and mdadm able to deal correctly with internal bitmaps of
non-standard size, i.e. a 132k internal bitmap?

As far as I can see from the code it should be possible. v1 superblocks
store the offset and size of data, bitmap superblocks store the bitmap
chunk size, which, in turn, is used to determine the number of blocks to
read as bitmap data.
Modifying mdadm to set up a non-standard bitmap size would also be easy:
change choose_bm_space(), recompile, create array, done. This would just
increase sb->data_offset or decrease sb->data_size a little.

However, I'm not sure, if really everything in md and mdadm is able to
deal with such a "non-standard" superblock and what would happen on
subsequent operations like mdadm --grow using an unpatched mdadm?


The reason for me to ask is:

When using a chunking RAID level ([0456], 10), there is usually some
space cut at the end of component devices which remains unusable because
it is too small to contain a chunk. For example, by using unpartitioned
1.5T = 1465138584k component devices and v1.1 superblocks there is a
space cut of 20k with 32k-256k chunk size (even 276k with 512k chunks).

When using internal bitmaps, depending on the device size more or less
of the available bitmap space is really used. For example, the internal
bitmap of a 3*1.5T RAID gets 8192KB chunks and uses 536550 bits out of
the 1048576 available (if my calculations are correct :)) - 51%.

If it would be possible to add some of the space cut from RAID chunking
to the internal bitmap, one could optimize the bitmap chunk size. In the
above example, by adding 4k to the internal bitmap the bitmap chunk size
could be decreased to 4096KB and 1073100 of the then 1081344 available
bits would be used - 99%.

Of course, this is not always possible, i.e. a 4*1.5T RAID has a bitmap
usage/available ratio of 68% - the 20k space cut wouldn't be enough here
to optimize it.

I'm not sure if it's worth the effort to automate such optimizations,
but being able to do them manually at least would be great.


regards
   Mario
-- 
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

