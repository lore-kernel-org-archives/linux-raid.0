From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: md: badblocks(pid 1216) used obsolete MD ioctl
Date: Tue, 2 Jul 2002 13:29:17 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNACEBFDBAA.kc130iseo@coastalnet.com>
References: <5.1.0.14.2.20020701141931.035aa4e0@mail.harddata.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20020701141931.035aa4e0@mail.harddata.com>
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Maurice Hilarius [mailto:maurice@harddata.com]
> Sent: Monday, July 01, 2002 2:26 PM
> To: cwebster@ec.rr.com
> Subject: RE: md: badblocks(pid 1216) used obsolete MD ioctl
>
> I missed that. Always the same drive and sectors?

That's right: single drive, one bad sector.

> It might be worthwhile to run a SCSI (low level) format on this drive, so
> that any bad sectors get marked bad and are not used.

The tools at my disposal relevant to this task are fdisk, mke2fs, e2fsck,
and badblocks. I don't believe that the "surface analysis" done by most SCSI
BIOS utilities on Intel machines does much more than these tools.

> It never hurts to have device close to the terminator ALSO providing term
> power. By the time the current gets from the host, all the way to
> the other
> end of the cabling, especially with an external cabinet, the voltage may
> drop quite a bit.
> It does no harm to enable it on the drives as well, and makes sure the
> attenuation is not a problem.

I appreciate what you're saying, especially since I did not indicate the
proximity of the RAID array to the host computer. However, the length of
wire between this on-board interface connector and the last device in the
external array is less than 8 feet total, so I would expect zero benefit. To
the contrary, in our situation all it would do is make the drives run hotter
in an already warm environment. I've never found this (current drain) to be
a factor with cable lengths under 8-feet, even with single-ended segments.
As I'm sure you are aware, differential SCSI has substantially extended the
range of SCSI signals on longer cables.

> >Please note that this is an UltraSparc IIi, not in Intel box. It does not
> >load a separate SCSI BIOS on startup the way Intel machines do.
>
> True, but lots of people put Adaptec PCI controllers in SPARCS, Macs, etc.
> If so, it may be necessary to temporarily plug it into a PC to
> check/adjust
> these settings.
> There are likely to be SPARC specific utilities which can do the
> same thing of course..

Okay, I've got to ask now. What benefit could I expect from pulling a drive
from my array and plugging it into a PC? What could I do on the PC that I
could not do with one of the utilities mentioned above?

> >That's my point. At most, I'm willing to concede that there is a
> bad sector,
> >(32772736 as reported in the system log). Even so, e2fsck should
> be able to
> >"mark" these "bad blocks", adding them to the list for the device. Once
> >marked, these blocks will not be written to again.
> You are right, it should, assuming that it sees the sector is bad
> on a read.
> However, if you want to make sure, format the filesystem with option to
> write to all sectors and verify.
> In mke2fs for example, using the "-c" flag.

You may have hit on it here. If you look at my original post, you'll see
that I did specify the "-c" flag to e2fsck. The "-c" flag to mke2fs does
exactly the same as the same flag on e2fsck. It starts a "badblocks"
read-only test. To accomplish a thorough, non-destructive, read-write test,
I'd have to run "badblocks" by itself, specifying this option (i.e.
badblocks -svn -o badblks.md0 /dev/md0). I could then use the output of this
test to mark the bad sectors with either e2fsck or mke2fs (using the "-l"
flag).

I still think there is a problem with e2fsck and fdisk, though, or possibly
with the libraries upon which they depend. I monitored the system log while
working on this problem. The following errors coincided with the
command/event shown. I'll be updating most of this stuff to the latest
versions with Aurora 0.3 (Equivalent to RHL 7.3). Hopefully, some of these
problems will be fixed then.

=======================
[root@winggear root]# e2fsck -c /dev/md0
e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
Checking for bad blocks (read-only test):     81504/ 30942912
-----------------------
From /var/log/messages:
-----------------------
Jul  2 10:17:27 winggear kernel: md: badblocks(pid 1175) used obsolete MD
ioctl, upgrade your software to use new ictls.
=======================

=======================
[root@winggear samba]# fdisk /dev/sdi

Command (m for help):

-----------------------
From /var/log/messages:
-----------------------
Jul  2 09:08:56 winggear kernel: sys32_ioctl(fdisk:1588): Unknown cmd fd(3)
cmd(00000330) arg(effffb10)
=======================


> Still, if you suspect bad sectors, a low level format is the
> first order of
> the day.
> If this marks MANY sectors as bad, it is likely the drive is
> either dying,
> or a head skip occurred in the past.

Whatever the term "low-level format" means to you, I certainly agree that
multiple bad blocks could be signal of impending doom, especially if there
are a growing number of them. Even if the drive was formatted with "spare"
cylinders, the inevitable can only be delayed.


--Cal Webster

