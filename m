From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: RE: lilo fails on root raid 1 on 2.6.4
Date: Tue, 13 Apr 2004 10:56:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0C8098CA7F09CE419F0C2B68EB8358761EB886@exchange.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org, debian-testing@lists.debian.org
List-Id: linux-raid.ids

Hi Michael,
Thanks for the sugestions.  
> >>>
> >>>I've struck an issue attempting to run lilo when booting 
> to a raid 1
> >>>system using a stock Debain 2.6.4-1-686 unstable release 
> kernel image.
> >>>After sucecssfully booting into the raid filesystem, 
> attempts to run 
> >>>lilo give me the error...
> >>>
> >>>Fatal: Trying to map files from unnamed device 0x0000
> >>(NFS/RAID mirror down ?)
> >>
> >>You probably need a "raid-extra-boot=" option in lilo.conf 
> Just list 
> >>the partition(s) that are currently active and it might work.
> > 
> > I've been able to apply the "raid-extra-boot=" option on an 
> alternate 
> > system and did a bit of toying around with the syntax to 
> see what was 
> > required and possible. All was well on the test machine, 
> running the 
> > same 2.6.4-1 kernel, however the problems persist....
> [snip]
> 
> Quite some time ago I discovered the "ultimate solution" for 
> this lilo/raid stuff (even back when LILO wasn't aware of 
> raid), and I mentioned it on this (linux-raid) list several times.
> 
> Instead of using LILO to install to raid devices, use 
> standard MBR (comes in `mbr' debian package, install-mbr 
> /dev/sda etc, and LILO itself may ), mark your boot raid 
> partitions active and use "boot=/dev/md.." in lilo.conf. For 
> this to work, you should have your boot partitions at exactly 
> the same place on all disks, but this isn't a problem in most 
> cases (after all, boot partition shouldn't be large and it's 
> easy to place it somewhere at the beginning of the disk, on 
> the same partition).

I installed mbr using install-mbr to both devices, still comes back to
the issue of...

Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror
down ?)

The active partitions are both the second partition, however their
location on the disks do vary. The first partition on the first drive is
2G swap, while the first partition of the second drive is 750Mb.  Once
I'd installed lilo I intended on replicating the layout of the second
drive to the first.  I'm reluctant to do this until I'm sure I don't
need to go back to the original filesystem. 

> > With raid-extra-boot=/dev/hdc,hda  (hda being marked as failed)...
> > 
> > Fatal: Unable to open dev/hda
> > 
> > With raid-extra-boot=/dev/hdc ...
> > Fatal: Trying to map files from unnamed device 0x0000 
> (NFS/RAID mirror 
> > down ?)
> 
> Hmm... this is a bug somewhere in lilo it seems...
> 

The crazy thing is that even after altering lilo.conf with
boot=/dev/hda & root=/dev/hda and removing any reference to /dev/md0...
The result is the same.... Fatal: ....
When I am in the original filesystem I can install lilo to the mbr on
both drives.  It's only once in the raid filesystem (copied from the
original) that we get the error.

I created the raid device and did some testing in another machine prior
to moving the device into place, could this be the source of the issue?



Cheers,

Lewis
