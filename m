From: "Tim Harvey" <tharvey@alumni.calpoly.edu>
Subject: RE: Moving a RAID5 array
Date: Thu, 27 May 2004 22:18:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c44473$48f06b60$7001a8c0@darwin>
References: <200405280120.05296.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405280120.05296.maarten@ultratux.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of maarten van den Berg
> Sent: Thursday, May 27, 2004 4:20 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: Moving a RAID5 array
> 
> On Friday 28 May 2004 00:04, Tim Harvey wrote:
> 
> Disclaimer: I'm not a real expert, but have had my share of raid5
> experiences.
> 
> > My question is that, not being very familiar with Linux raid or
mdadm,
> > I'm wondering if I can mount the array on my Linux system when the
> > devices are other than described above (they would likely be
/dev/hdc1,
> > /dev/hdd1, etc as my boot/root drives use hda/hdb).  Additionally,
how
> 
> I did shuffle my disks at several points in time, and it figures that
out
> by
> itself somehow (there must be something in the superblock identifying
> which
> drive it is).
> 
> > should I go about mounting this array in a way that if anything
doesn't
> > work right, it doesn't trash the array.  I'm a little paranoid that
I
> > may do something wrong and the raidutils will start reconstructing
or
> > otherwise altering the information on the array.
> 
> There are several things to note. You want to disallow the raid to
start
> any
> reconstruction, and you need to skip any fsck at mount, as well as
> replaying
> of journals if they are journaling filesystems.

It looks like I need to do an 'mdadm --assemble' to assemble the
previously created array into an active array.  But I'm not clear how to
examine the /dev/md0 device to see what partitions are available (fdisk
didn't work in a test... I guess its not compatible with /dev/md0).
 
> 
> Issue #1 Can be assured (AFAIK) by just attaching one disk less. Then
the
> array will be in degraded mode and cannot / will not attempt a resync.
> In addition, this will enable you to choose another set of disks,
should
> the
> outlook on the first three be less than favourable...
> 

Does disallowing the raid to start any reconstruction mean that the
array is not 'started' and that I cannot mount the filesystem?  I guess
I'm not clear if there is a difference between the array being 'started'
and 'allowing reconstruction'.  Is leaving a disk out of the RAID5 array
the only way to force this to occur?  I noticed mdadm has a --readonly
option but I'm not sure if it affects the assemble mode.

> Issue #2 Should be assured by mounting read-only, without prior fsck.
> 

Sounds like a safe bet to mount the partition read-only.  How can I
examine /dev/md0 to see what partitions are available?  I'm fairly
certain XFS is used.  The RAID HOWTO doesn't seem to go into detail
regarding how to examine filesystems on an array.

> Issue #3 I'm not sure about. Consult the manualpage detailing your
> specific
> filesystem...  Maybe instead of mounting you could run an fsck with an
> option
> to do only a test-run / dry-run i.e. allow no writes whatsoever during
> fsck.
> If that fsck succeeds, chances are very good that all is in order.

Is this to ensure no writing occurs in case something didn't work
correctly?  If everything looks ok in a dry-run I'll want to mount and
allow fsck and journaling to complete I assume.  Again, can the
--readonly option be used to keep the device from being written at the
device level for a dry-run?

> 
> Anyway, my guess is, you'll have no trouble at all.  A power-loss is
not
> the
> very worst that can happen to an array. In my humble opinion...
> 
> > Thanks for any help.  I've read over the Linux RAID FAQ and looked
> > through the man pages for mdadm, but I'm pretty paranoid about
loosing
> > the data and want to consult the experts here.
> 
> <Grin> No backups huh ?  Been there,  done that,  still got my data
back.
> :)

I guess I've been educated :)  Ironically the power outages occurred due
to my own blunders while hooking up a 2nd device to use as a backup.

Thanks for your help!

Tim

> 
> Well, good luck with your endeavors !
> 
> Maarten
> 
> > -
> > To unsubscribe from this list: send the line "unsubscribe
linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> When I answered where I wanted to go today, they just hung up --
Unknown
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

