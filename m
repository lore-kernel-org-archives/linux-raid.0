From: "David Lethe" <david@santools.com>
Subject: RE: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 08:50:31 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C025BF0B0@34093-C3-EVS3.exchange.rackspace.com>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com> <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com> <cccedfc60810210605w638ac471xbce0ceb616a0c141@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <cccedfc60810210605w638ac471xbce0ceb616a0c141@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, David Greaves <david@dgreaves.com>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Jon Nelson
> Sent: Tuesday, October 21, 2008 8:06 AM
> To: David Greaves
> Cc: Mario 'BitKoenig' Holbe; LinuxRaid
> Subject: Re: Proactive Drive Replacement
> 
> On Tue, Oct 21, 2008 at 3:38 AM, David Greaves <david@dgreaves.com>
> wrote:
> > Mario 'BitKoenig' Holbe wrote:
> >> Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
> >>> I was wondering about proactive drive replacement.
> >> [bitmaps, raid1 drive to replace and new drive, ...]
> >>
> >> I belive to remember a HowTo going over this list somewhere in the
> past
> >> (early bitmap times?) which was recommending exactly your way.
> >>
> >>> The problem I see with the above is the creation of the raid1
which
> >>> overwrites the superblock. Is there some way to avoid that (--
> build?)?
> >>
> >> You can build a RAID1 without superblock.
> >
> > How nice, an independent request for a feature just a few days
> later...
> >
> > See:
> >   "non-degraded component replacement was Re: Distributed spares"
> > http://marc.info/?l=linux-raid&m=122398583728320&w=2
> 
> D'oh!  I had skipped that thread before. There are differences,
however
> minor.
> 
> > It references Dean Gaudet's work which explains why the above
> scenario, although
> > it seems OK at first glance, isn't good enough.
> >
> > The main issue is that the drive being replaced almost certainly has
> a bad
> > block. This block could be recovered from the raid5 set but won't
be.
> > Worse, the mirror operation may just fail to mirror that block -
> leaving it
> > 'random' and thus corrupt the set when replaced.
> > Of course this will work in the happy path ... but raid is about
> correct
> > behaviour in the unhappy path.
> 
> In my case I was replacing a drive because I didn't like it.
> 
> --
> Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

S.M.A.R.T. does not, has not, will not, ever ... identify bad blocks.
At most, depending
on the firmware, it will trigger a bit if the disk has a bad block that
was discovered as
a result of a read already.  It will NOT trigger a bit if there is a bad
block that hasn't
been read yet by either a self-test or an I/O request from the host.

For ATA/SATA class drives, the ANSI specification for S.M.A.R.T.
provides for reading some
structures which indicate such things as cumulative errors, temperature,
and a Boolean that
says if the disk is in a degrading mode and a S.M.A.R.T. alert is
warranted.  The ANSI spec
is also clear in that everything but that single pass/fail bit is open
to interpretation by
the manufacturer (other than data format for these various registers).

SCSI/SAS/FC/SAA class devices also have this bit, but the ANSI SCSI spec
also provides for 
Log pages which are somewhat similar to the structures defined in
ATA/SATA class disks, the
Difference being that the ANSI spec formalized such things as exactly
where errors and warnings
of various types belong.  They also provided or a rich subset of
vendor-specific pages.

Both families of disks provide for some self-test commands, but these
commands do not scan the
entire surface of the disk, so they are incapable of reporting or
indicating where you have a 
new bad block.  They report if you have a bad block if one is found in
the extremely small sample
of I/O it ran.   Now some enterprise class drives support something
called BGMS (Like the Seagate
15K.5  SAS/FC/SCSI disks, but 99% of the disks out there do not have
such a mechanism.

Sorry about rant .. but it got to me finally, where people keep posting
how S.M.A.R.T. seems
to be this all-knowing mechanism that tells you what is wrong with the
disk and/or where the
bad blocks might be.  It isn't.

The poster is 100% correct in that parity-protected RAID is all about
recovering when bad things happen.
Distributing spares is about performance.   Their objectives are
mutually exclusive.   If you
Must have a RAID mechanism that is fast, safe, and efficient on rebuilds
and expansions, 
then consider either high-end hardware-based RAID or run ZFS on Solaris.
Next best thing in LINUX
world is RAID6.
David @ santools.com
  

