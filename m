From: Neil Brown <neilb@suse.de>
Subject: Re: My Thecus RAID-0 filesystem unmountable with mdadm. Please
 help.
Date: Tue, 25 May 2010 10:33:43 +1000
Message-ID: <20100525103343.6424d6a1@notabene.brown>
References: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Reniau <david.reniau@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 May 2010 14:40:25 +0200
David Reniau <david.reniau@gmail.com> wrote:

> Hello Linux-Raid list,
> 
> 
> 
> 
> 
> ------------------------
> 
> My problem in a nutshell:
> 
> ------------------------
> 
> 
> 
> I am unable to mount a RAID-0 (EXT3?) filesystem which I previously
> assembled with mdadm under Ubuntu 9.10 32bitx. This RAID-0 array was
> originally created by my NAS Thecus N4100.
> 


As far as I can tell from all the details you provided, everything is
behaving as expected except that the filesystem looks bad.  It could be that
the Thecus NAS vendors made some incompatible change in the ext3 filesystem
format for their product.  I would rate that as fairly unlikely but
definitely possible.  I believe it has happened before.
However you say (I think) that when you put the devices back in the NAS they
still don't work.  That suggests some on-device corruption so we cannot
really blame the vendor.

The small partition at the start of each device is probably some boot
partition.  It might be raided, it might be ext3, or it might just be a raw
copy of the kernel that the bios loads directly.  It isn't really important
to you.

The RAID0 assembled from the '2' partitions is fairly clearly the correct
raid0.  mount and fsck seem to be able to read an ext3 superblock from the
start of md0 which suggests that there aren't partitions (agreeing with what
fdisk says) and that they weren't using LVM (which is a common practice).
It would hurt to run 'vgscan' to see if it can find any LVM headers though.

It might also be interesting to run "tune2fs -l /dev/md0" and report the
result.

The fact that "mdadm -E" gives confusing messages about the device identifies
is not very interesting.  The device names that it gives are the names that
the devices had the last time the array was active.  When you move devices
between machines it is very likely for the names to change.

If you can assemble md0 from the loopXp2 devices and and happy to run
possibly destructive tests on that, try
   fsck -a /dev/md0

and see if it managed to make any sense of the filesystem.

I'm afraid there is nothing else I can suggest.

NeilBrown


