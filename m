From: Michael Tokarev <mjt@tls.msk.ru>
Subject: MD uses wrong disks to assemble an array?
Date: Fri, 11 Jun 2004 07:22:17 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C92569.8070808@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A scenario happened here:

md1 (raid1) was built from 3 partitions, sd[abc]1.

Disk sdc failed, and we got a replacement, which
wasn't new, but it was a drive where I experimented
with various stuff, and it's first partition actually
was a part of another raid1 array.

Next, kernel tried to assemble the array using
START_ARRAY ioctl with /dev/sda1 as the argument.

But instead of using /dev/sda1 and /dev/sdb1, the
kernel assembled the device from /dev/sdc1 (the
replacement disk), and even assigned different
minor number to it.

And since it was root filesystem, obviously the
system was not able to boot.

I understand why it choosed the "wrong" disk:
it read superblock on the /dev/sda1, discovered
other two parts of the array, examined superblocks
there, and choosed the "freshest" component (the
one that had largest `event' counter), and next
it used all available parts of the array with
GUUID stored in that device.

Yes, START_ARRAY (used by raidtools) is deprecated,
but I understand also that mdadm in such a situation
will refuse to bring the array up, because the
GUUIDs will be different.

And I also understand that it was our mistake to
try to use disk which contained raid component on
this same partition (it was going to be repartitioned
anyway).

So the question.  What is the Right Thing (tm) to
do in such a situation?  Using the "wrong" device
as kernel did is wrong.  Refusing to run the array,
when the *specified* components are ok but other,
found by examining the superblock, component belongs
to another disk array, also seems to be wrong.  Both
ways will result in unbootable system, which is esp.
bad if a system is remote (as was in our case, and
the guy who replaced the disk was not competent
enouth to deal with this lowlevel stuff using
very limited tools available inside the initrd).
It *seems* it should be safe to bring the array
up out of the existing components, by examining
only superblocks with the same GUUID as on the
disk specified), leaving the new disk alone (if
it was the first disk which was replaced, the
system will not boot off the new disk anyway and
other existing disks should be swapped so that
the disk from current system is on sda).

Comments?

/mjt
