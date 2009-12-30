From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID 1 Disk added as faulty
Date: Tue, 29 Dec 2009 23:19:55 -0600
Message-ID: <49.BC.07778.103EA3B4@cdptpa-omtalb.mail.rr.com>
References: <4E.F2.01550.BF0663B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E.F2.01550.BF0663B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


	Hello?  Anyone?  Can someone tell me why mdadm won't add the PATA
drive as Write mostly, or why it claims one of the members is failed?

> 	I have another, possibly related, question.  I did a bit of snooping
> around, and all six devices that are members of one of the RAID 1 arrays
> report the same thing:
> 
>     Array Slot : 1 (failed, 1, 0)
>    Array State : Uu 1 failed
> 
> 	(The array slot of course is either 1 or 2, depending on the
> specific device.) Why does the superblock report something as being
> failed?
> All the devices and the arrays themselves all show clean.  Running a
> repair
> on the array has no effect on the status.  This same report is generated
> on
> all twelve drive partitions that are part of RAID1 arrays.  One one
> system,
> both hard drives are PATA drives.  On the other, one is PATA, the other
> SATA.  I only attempted to issue the -W directive on the mixed PATA / SATA
> system.
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Leslie Rhorer
> > Sent: Saturday, December 26, 2009 1:33 AM
> > To: 'linux-raid'
> > Subject: RAID 1 Disk added as faulty
> >
> >
> > Merry Christmas all,
> >
> > 	I have a bit of a puzzling problem.  I have a set of three
> > partitions on a SATA hard drive all set up as second members of three
> RAID
> > 1
> > arrays with the first members missing.  I have a PATA drive partitioned
> in
> > precisely the same way as the SATA drive, and I am attempting to add the
> > PATA drive's partitions to the respective existing RAID 1 arrays.  I can
> > add
> > the partitions with `mdadm /dev/mdx --add  /dev/hdax` (x = 1, 2, 3), and
> > everything works just fine.  The thing is, however, for rather obvious
> > reasons I would prefer the PATA partitions to be write-mostly.  If I add
> > the
> > partitions to the array and then try to make the PATA partitions
> > write-mostly with the command `mdadm /dev/mdx -W /dev/hdax`, mdadm
> doesn't
> > complain, but it also doesn't appear to make the hdax partitions
> > write-mostly.  (Or at least it does not report them as such.)  OTOH, if
> I
> > start with a fresh partition with no existing superblock and use the
> > command
> > `mdadm /dev/mdx --add -W /dev/hdax`, mdadm adds the partition and marks
> it
> > as write-mostly, but immediately fails the partition.  If I remove the
> > partition and re-add it without zeroing the superblock, it again adds it
> > as
> > a faulty spare:
> >
> > /dev/md1:
> >         Version : 01.00
> >   Creation Time : Wed Dec 23 23:46:28 2009
> >      Raid Level : raid1
> >      Array Size : 401580 (392.23 MiB 411.22 MB)
> >   Used Dev Size : 401580 (392.23 MiB 411.22 MB)
> >    Raid Devices : 2
> >   Total Devices : 2
> > Preferred Minor : 1
> >     Persistence : Superblock is persistent
> >
> >   Intent Bitmap : Internal
> >
> >     Update Time : Sat Dec 26 01:12:41 2009
> >           State : active, degraded
> >  Active Devices : 1
> > Working Devices : 1
> >  Failed Devices : 1
> >   Spare Devices : 0
> >
> >            Name : 'RAID-Server':1
> >            UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
> >          Events : 188
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       0        0        0      removed
> >        1       8        1        1      active sync   /dev/sda1
> >
> >        2       3        1        -      faulty writemostly spare
> > /dev/hda1
> >
> >
> > 	How can I add these partitions as write-mostly members of the RAID 1
> > arrays?
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

