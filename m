From: Daniel Reurich <daniel@centurion.net.nz>
Subject: RE: md extension to support booting from raid whole disks.
Date: Mon, 04 May 2009 15:04:43 +1200
Message-ID: <1241406283.17240.26.camel@ezra>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
	 <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> My own "ideal" would be
>  - simple boot loader in first sector of every drive that loaded a
>    'second stage' linearly off the early sectors of the disk.
>  - the 'second stage' is a linux kernel plus initramfs which finds
>    the root filesystem loads the final kernel and initramfs, and
>    uses kexec to boot into it.
> 
Why not have it boot into the real linux kernel instead of kexec from a
boot linux kernel into the real one?  This would save the maintenance of
a boot kernel as well as the real one.  Even a simple first stage
bootloader would allow for the selection of between multiple boot images
if there was enough reserved space to have multiple images available.
Of course this would require a userspace tool to emebed them.

This whole discussion seems to revolve around where the complexity of
the boot process should be best located, and the answer this in my view
atleast.

I have asked whether grub2 also has support to access disks across
multiple controllers, and the response I got was that grub2 has modules
for using scsi and ata for disk access, and these can be embedded in the
stage 1 bootimage, so access to disks across controllers may indeed be
possible.  I will run some tests myself to see if this is the reality.

> Thus the final stage of the boot loader can understand any filesystem,
> any raid level, any combination of controllers.
> 
> The area that stores the second stage would be written rarely, and
> always written as a whole - no incremental updates.  So much of the
> power of md/raid1 would not be necessary.  Having some tool that
> installed the boot loader and second stage on every bootable device would
> seem an adequate solution.

But the benefit of md/raid1 of this boot area would be that if the a
disk that is booted from is out of sync with the others for some reason,
yet has enough know how to assemble raid1 (even if it's limited to disks
that are on only 1 controller), and get it's second stage boot image and
linux kernel etc, off the raid1 volume rather than the boot disk, we
effectively remove one of the aforementioned modes of failure.


> Whether this space were kept free by traditional partitioning,
> or by the filesystem or raid or whatever "knowing" to leave the first
> few meg free is of relatively little interest to me.  I can see advantages
> both ways.
> 
I'd personally like to see the back of the MSDOS v2/v3 style partiton
tables when it's not required  (and use lvm on a raided whole disk set.
Both grub2 and linux kexec methods already could do this in theory.

> So I still plan to offer a "--reserve-space=2M" option for mdadm to
> allow the first 2M of each device to not used for raid data.  Whether
> any particular usage of this option is viable or not, is a different
> question altogether.
> 
Would it be better to allow for the creation of a metadata or superblock
that described the on disk layout ala intel matrix style, so that we
could have a whole disk raid, which appears as X number of md devices,
so that one could ask for a layout of 256M raid1 volume + 20G raid10 +
the rest of the disk as raid5 or whatever takes the users fancy.  I'd
imagine that this could just be an additional option to mdadm --create.
This may or may not need a superblock extension that defines the raid
volumes layout either in the superblock, just a metadata block like one
would expect from an intel matrix raid or similar 3rd party metadata
format that the mdadm 3 is said to support.


-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

