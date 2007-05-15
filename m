From: Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 10:22:09 -0400
Message-ID: <20070515142209.GB17031@anthropohedron.net>
References: <4649760A.1060805@wpkg.org> <46497A78.6030109@rabbit.us> <46497CF4.3050807@wpkg.org>
Reply-To: gsslist+linuxraid@anthropohedron.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46497CF4.3050807@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 15, 2007 at 11:27:16AM +0200, Tomasz Chmielewski wrote:
> Peter Rabbitson schrieb:
> >Tomasz Chmielewski wrote:
> >>I have a RAID-10 setup of four 400 GB HDDs. As the data grows by several
> >>GBs a day, I want to migrate it somehow to RAID-5 on separate disks in a
> >>separate machine.
> >>
> >>Which would be easy, if I didn't have to do it online, without stopping
> >>any services.
> >>
> >>
> >
> >Your /dev/md10 - what is directly on top of it? LVM? XFS? EXT3?
> 
> Good point. I don't want to copy the whole RAID-10.
> I want to copy only one LVM-2 volume (which is like 90% of that RAID-10, 
> anyway).
> 
> So I want to synchronize /dev/LVM2/my-volume (ext3) with /dev/sdr (now 
> empty; bigger than /dev/LVM2/my-volume).
[...]

This actually makes it quite a bit easier, assuming you have some
reasonable amount of unallocated space in your LVM volume group. For the
purpose of the commands below, I'm going to call that amount <FREESPACE>.
Do the following (as root) on the machine with the LVM2 VG:

lvcreate -L <FREESPACE> -p r -n copy-me -s LVM2/my-volume

This now gives you an unchanging, read-only device /dev/LVM2/copy-me which
you can then dd over netcat or the like to an equal-sized volume on your
destination RAID. Let that finish (I'm sure it will take some time).

Once you're done with that step, run lvdisplay LVM2/copy-me and take a look
at the "Allocated to snapshot" line. That is a percentage of <FREESPACE>
that is different between the current live volume and the snapshot. Do the
multiplication and figure out how much storage is actually different, then
get rid of the snapshot with:

lvremove -f LVM2/copy-me

You should know how long you can reasonably have things down. To get an
idea of how long X amount of data will take to rsync, make another lvm
snapshot with the lvcreate commandline above and rsync between the two
actual devices (i.e. not the filesystems, but /dev/LVM2/copy-me and the
destination volume's block device). 

You now have to decide if the amount of data difference will take longer
than the downtime you can accept. If so, repeat the process of
snapshot, rsync, lvdisplay/calculate until it gets to an acceptable level
or you reach a point of diminishing returns. From there, you take down your
services and such, unmount the live LVM volume, rsync one more time, and
bring stuff up on the new RAID.

Depending on how many loops you have to go through this may take some
time and effort, but it will minimize your downtime (which, it seems, is
your goal). Be sure to lvremove the snapshot every time, since you are
reusing the space allocated to it for the next snapshot. Also note that if
you are writing to the live partition faster than you can rsync it, I see
no way to avoid significant downtime.

> Tomasz Chmielewski
--Greg

