From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: Mirroring swap
Date: Wed, 25 Jun 2003 15:58:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7FD257BF8564D4119DA800508BDF07AA0B0AAA9B@usahm012.exmi01.exch.eds.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Derek Yeung' <dky@utcc.utoronto.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>I was wondering if it's a good idea to also mirror the swap partition?  

I've heard both sides of the argument, but my 2 cents says "mirror it".
Otherwise you run the risk of having your swap area become unusable
following a drive failure, which will make your system very upset if it
decides it needs to swap in (or out) data associated with that area.

>If it's a good idea, can anyone suggest how i can do it?  (mirror swap?)  

It's just another partition. :-) Assuming you have created a md device of
the appropriate size, just use "/dev/md5" [or whatever] in your mkswap
command and the first column of the swap entry in your /etc/fstab. Note that
you do *NOT* have separate partitions on the md device itself.

My preference in this situation actually is to use LVM on top of RAID so
that you don't have to mess around with so many md devices. In this
scenario, you create a much larger md device, put it into a volume group,
then create a logical volume of the desired size. That is: (very
abbreviated)

# pvcreate /dev/md5
# vgcreate myvg /dev/md5
# lvcreate --contiguous y --size 128m --name swapvol myvg
# mkswap /dev/myvg/swapvol
# swapon /dev/myvg/swapvol

I can't remember making the volume contiguous is actually a requirement for
Linux LVM or just garbage cluttering up my brain from HP-UX days. :-) 

Have fun,

	Scott
