From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Moving a RAID5 array
Date: Fri, 28 May 2004 15:36:08 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16566.53192.813557.80559@cse.unsw.edu.au>
References: <200405280120.05296.maarten@ultratux.net>
	<000001c44473$48f06b60$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tim Harvey on Thursday May 27
To: Tim Harvey <tharvey@alumni.calpoly.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 27, tharvey@alumni.calpoly.edu wrote:
> 
> It looks like I need to do an 'mdadm --assemble' to assemble the
> previously created array into an active array.  But I'm not clear how to
> examine the /dev/md0 device to see what partitions are available (fdisk
> didn't work in a test... I guess its not compatible with /dev/md0).
>  

/dev/md0 will not have any partitions.  It will just have a
filesystem.
You could try 'fsck -n /dev/md0'  to see if the filesystem is recognised.

> > 
> > Issue #1 Can be assured (AFAIK) by just attaching one disk less. Then
> the
> > array will be in degraded mode and cannot / will not attempt a resync.
> > In addition, this will enable you to choose another set of disks,
> should
> > the
> > outlook on the first three be less than favourable...
> > 
> 
> Does disallowing the raid to start any reconstruction mean that the
> array is not 'started' and that I cannot mount the filesystem?  I guess
> I'm not clear if there is a difference between the array being 'started'
> and 'allowing reconstruction'.  Is leaving a disk out of the RAID5 array
> the only way to force this to occur?  I noticed mdadm has a --readonly
> option but I'm not sure if it affects the assemble mode.

"starting" an array is like mounting a filesystem.  It makes it
accessible.
There is no simple way to start an array but not let it
reconstruct. '--readonly' doesn't do this (though it probably
should). 
Leaving one drive out disables reconstruction simply by making it
impossible.

> 
> > Issue #2 Should be assured by mounting read-only, without prior fsck.
> > 
> 
> Sounds like a safe bet to mount the partition read-only.  How can I
> examine /dev/md0 to see what partitions are available?  I'm fairly
> certain XFS is used.  The RAID HOWTO doesn't seem to go into detail
> regarding how to examine filesystems on an array.

There are no partition tables.  Just a filesystem.  Does xfs have a
check-and-repair tool?  Try that.

NeilBrown
