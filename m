From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Recovering a RAID6 after all disks were disconnected
Date: Wed, 7 Dec 2016 09:59:46 +0100
Message-ID: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

my situation is the following: I have a small 4-disk JBOD that I use
to hold a RAID6 software raid setup controlled by mdraid (currently
Debian version 3.4-4 on Linux kernel 4.7.8-1

I've had sporadic resets of the JBOD due to a variety of reasons
(power failures or disk failures =E2=80=94the JBOD has the bad habit of
resetting when one disk has an I/O error, which causes all of the
disks to go offline temporarily).

 When this happens, all the disks get kicked from the RAID, as md
fails to find them until the reset of the JBOD is complete. When the
disks come back online, even if it's just a few seconds later, the
RAID remains in the failed configuration with all 4 disks missing, of
course.

Normally, the way I would proceed in this case is to unmount the
filesystem sitting on top of the RAID, stop the RAID, and then try to
start it again, which works reasonably well (aside from the obvious
filesystem check that is often needed).

The thing happened again a couple of days ago, but this time I tried
re-adding the disks directly when they came back online, using mdadm
-a and confident that since they _had_ been recently part of the
array, the array would actually go back to work fine =E2=80=94except that t=
his
is not the case when ALL disks were kicked out of the array! Instead,
what happened was that all the disks were marked as 'spare' and the
RAID would not assemble anymore.

At this point I stopped everything and made a full copy of the RAID
disks (lucky me, I had just bought a new JBOD for an upgrade, and a
bunch of new disks, even if one of them is apparently defective so I
have only been able to backup 3 of the 4 disks) and I have been toying
around with ways to recover the array by playing on the copies I've
made (I've set the original disks to readonly at the kernel level just
to be sure).

So now my situation is this, and I would like to know if there is
something I can try to recover the RAID (I've made a few tests that I
will describe momentarily). (I would like to know if there is any
possibility for md to handle these kind of issue =E2=80=94all disks in a RA=
ID
going temporarily offline=E2=80=94 more gracefully, which is likely needed =
for
a lot of home setup where SATA is used instead of SAS).

So one thing that I've done is to hack around the superblock in the
disks (copies) to put back the device roles as they were (getting the
information from the pre-failure dmesg output). (By the way, I've been
using Andy's Binary Editor for the superblock editing, so if anyone is
interested in a be.ini for mdraid v1 superblocks, including checksum
verification, I'd be happy to share). Specifically, I've left the
device number untouched, but I have edited the dev_roles array so that
the slots corresponding to the dev_number from all the disks map to
appropriate device roles.

I can then assemble the array with only 3 of 4 disks (because I do not
have a copy of the fourth, essentially) and force-run it. However,
when I do this, I get two things:

(1) a complaint about the bitmap being out of date (number of events
too low by 3) and
(2) I/O errors on logical block 0 (and the RAID data thus completely
inaccessible)

I'm now wondering about what I should try next. Prevent a resync by
matching the event count with that of the bitmap (or conversely)? Try
a different permutation of the roles? (I have triple-checked but who
knows)? Try a different subset of disks? Try and recreate the array?

Thanks in advance for any suggestion you may have,

--=20
Giuseppe "Oblomov" Bilotta
