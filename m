From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: md: badblocks(pid 1216) used obsolete MD ioctl
Date: Tue, 2 Jul 2002 15:30:37 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAGEBHDBAA.kc130iseo@coastalnet.com>
References: <5.1.0.14.2.20020702113532.035e0ec0@mail.harddata.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20020702113532.035e0ec0@mail.harddata.com>
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Maurice Hilarius [mailto:maurice@harddata.com]
> Sent: Tuesday, July 02, 2002 11:42 AM
> To: cwebster@ec.rr.com
> Subject: RE: md: badblocks(pid 1216) used obsolete MD ioctl
>
>
[snip]
> These commands are SCSI command set mode commands, and after the drive
> receives the instruction it performs the format itself.
> mke2fs and so on only do high level filesystem formats.

Of course, most storage people know that the "CHS" value vendors assign to a
drive almost never represent the physical geometry. The drive and/or
controller must be capable of translating to "physical" locations for
read/write operations. I assume that the "low-level" format you refer to
operates at this level.

A crude overview (my understanding): During a "low-level" format the
controller, activating machine instructions stored on the drive, will scan
for defects then re-write BOT (Beginning Of Track) markers and sector
addresses on the media, skipping the bad spots it found and storing them for
future reference in some non-volatile medium (often it will do more).
"fdisk" and the tools in the e2fsprogs package merely overlay partition,
sector, and block data atop this low-level framework to create and manage
the filesystems.

> > > It does no harm to enable it on the drives as well, and makes sure the
> > > attenuation is not a problem.
[snip]
> >in an already warm environment. I've never found this (current
> >drain) to be a factor with cable lengths under 8-feet, even
> >with single-ended segments. As I'm sure you are aware,
> >differential SCSI has substantially extended the range of SCSI
> >signals on longer cables.
>
> True. Still, I have seen many cases where this helped.

Thanks, I'll keep that in mind. I know from my own experience that there are
times when a certain action fixes a problem even though it doesn't seem to
make sense at the time.

Often it is more expedient to just try something that might work, rather
than to enter an in-depth analysis. I cannot let things like this go
indefinitely, though. I've got to know "why". When encountering these
situations, I usually make time later to conduct a forensic analysis. Over
the years I've found that there is usually a contributing factor, often
related to the "interim fix" I was forced to employ.

> >Okay, I've got to ask now. What benefit could I expect from
> pulling a drive
> >from my array and plugging it into a PC? What could I do on the PC that I
> >could not do with one of the utilities mentioned above?
>
> Low level SCSI format command.
> This marks bad all defective sectors ON THE DRIVE.
> SCSI drives have factory and "grown" defect tables in their firmware, and
> this is more effective and reliable than filesystem tools ability to mark
> bad sectors.

Okay, I've used low-level SCSI format for that purpose many times on
"Windoze" PC's. In fact, I've searched in vain for utilities that do this on
a Sparc Linux machine. Admittedly, having the bad sectors stored on the
drive itself prevents losing track of them, making it more reliable.
However, I still don't see how it is more effective than Linux e2fsprogs at
detecting and marking them.

I suppose that, if there were many of these bad spots to manage, there may
be some performance gain by relieving the filesystem/kernel drivers of the
burden. I don't see how physically re-mapping a few bad areas is
significantly more efficient that simply allowing the filesystem to avoid
them. To low-level format drives on my Sparc Linux machines I would have to
disconnect and remove the chassis from the 19-inch rack, extract the drive,
open SCSI capable PC and install the drive, power it up and run the format,
then re-install everything. This is way too much trouble for the expected
benefit, at least for my situation.

--Cal Webster

P.S. Why don't you post to the list?

