From: dean gaudet <dean@arctic.org>
Subject: Re: Updating superblock to reflect new disc locations
Date: Wed, 11 Jan 2006 19:49:31 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0601111942110.1824@twinlark.arctic.org>
References: <43C495BA.9070502@mm.quex.org> <17349.50814.993086.189022@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17349.50814.993086.189022@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 12 Jan 2006, Neil Brown wrote:

> On Wednesday January 11, linux-raid@mm.quex.org wrote:
> > 
> > 
> > Any suggestions would be greatly appreciated. The system's new and not 
> > yet in production, so I can reinstall it if I have to, but I'd prefer to 
> > be able to fix something as simple as this.
> 
> Debian's installer - the mkinitrd part in particular - is broken.
> If you look in the "initrd" (it is just a compressed CPIO file) you
> will find the mdadm command used to start the root array explicitly
> lists the devices to use.  As soon as you change the devices, it stops
> working :-(  Someone should tell them about uuids.

actually i did tell them 
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=338200> ...

however (a) i sent the bug report well after the freeze point for the last 
stable release and (b) i think initrd-tools is on its way out... folks in 
the unstable branch are forced to use yaird or initramfs-tools for kernels 
2.6.14 and beyond.  so i'm guessing the bug report will go nowhere -- but 
i haven't looked at either of those tools yet to see if they handle md 
root well.


> I think you can probably fix you situation by:
>   Booting up and having a degraded array
>   hot-add the missing device and wait for it to rebuilt
>   rerun mkinitrd
> 
> The last bit might require some learning on your part.  I don't know
> in Debian's mkinitrd requires and command line args, or where it puts
> the result, or whether you have to tell lilo/grub about the new files.

basically run something like this:

	dpkg-reconfigure linux-image-`uname -r`

(or possibly kernel-image-`uname -r` if you're on unstable branch prior to 
the renaming of the kernel packages.)

you really want to do that for all of your linux-image-* or kernel-image-* 
packages so they all get the new root locations.

another option without the rebuild is to boot a live-cd like knoppix and 
then hand-edit and repack the cramfs image from /boot... there's a script 
in the root or otherwise easy to find which has the mdadm command for 
assembling your root partition.  i'll skip the details though... i'd 
rather not try to get them all correct in a quick email.

-dean
