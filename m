From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 19:08:13 +1200
Message-ID: <1240902493.8040.728.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hc0axhg9.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> >
> > I was wondering if it was worth extending the md superblock to make it
> > easier for booting raided whole disks.  There are several ideas I had
> > thought of that would make this achieveable:
> 
> Or grub2 could be thought to install itself into all MBRs of all
> drives in a raid set.

Grub2 largely already does this (atleast for v0.90 superblocks), It does
need some work to make it go for whole disks, but my proposal solves
this and reduces the needed work on grub.

> 
> > A first cylinder which needs to be mirrored across all the devices.
> > This would be for the Volume/Master Boot record + Boot Sector Code.
> > Grub2 bootsector + core.img should fit in here at (or least enough of it
> > to bring grub up with the appropriate raid drivers.)
> >
> > We could include a dummy partition table with the whole disk in the 1st
> > partition labeled as something like linux-raid (0xfd) or Non-FS data
> > (0xda).
> >
> > The second cylinder has the md superblock and write intent bitmap, and
> > the raid volume starts at the beginning of the 3rd cylinder.
> >
> > This would allow for this scheme to work with booting of all whole disk
> > raid arrays of all levels using grub2, without any significant changes
> > required in grub2.
> 
> That part I really like. I'm just not sure how complicated the code
> for this would be compared to teaching grub2 to handle this case
> itself.

The biggest problem I see is with the creation/resync of devices, and
replication of the important stuff accross all the member discs (ie the
1st cylinder, sans the partition table if it exists (because the disk
geometry may differ between member disks, though I'd prefer no partition
table at all simplifying the implementation here.)  

I'm not yet sure about how much of this would be changes to mdadm or the
md kernel module.  (I assume the replication of the first cylinder would
need to be in the kernel module, and I believe this is already done for
the write intent bitmap anyway, so it shouldn't be too difficult.)

I guess the superblock location isn't even critical, and could go in
either the end of the device as it already does for v0.9/1.0 or at the
start of the device as described in my previous post.




-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

