From: Neil Brown <neilb@suse.de>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 6 Feb 2008 21:43:12 +1100
Message-ID: <18345.36672.51070.986289@notabene.brown>
References: <200802051142.19625.admin@domeny.pl>
	<18344.49968.584648.904844@notabene.brown>
	<200802061055.03979.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marcin Krol on Wednesday February 6
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 6, admin@domeny.pl wrote:
> 
> > Maybe the kernel has  been told to forget about the partitions of
> > /dev/sdb.
> 
> But fdisk/cfdisk has no problem whatsoever finding the partitions .

It is looking at the partition table on disk.  Not at the kernel's
idea of partitions, which is initialised from that table...

What does

  cat /proc/partitions

say?

> 
> > mdadm will sometimes tell it to do that, but only if you try to
> > assemble arrays out of whole components.
> 
> > If that is the problem, then
> >    blockdev --rereadpt /dev/sdb
> 
> I deleted LVM devices that were sitting on top of RAID and reinstalled mdadm.
> 
> % blockdev --rereadpt /dev/sdf
> BLKRRPART: Device or resource busy
> 

Implies that some partition is in use.

> % mdadm /dev/md2 --fail /dev/sdf1
> mdadm: set /dev/sdf1 faulty in /dev/md2
> 
> % blockdev --rereadpt /dev/sdf
> BLKRRPART: Device or resource busy
> 
> % mdadm /dev/md2 --remove /dev/sdf1
> mdadm: hot remove failed for /dev/sdf1: Device or resource busy

OK, that's weird.  If sdf1 is faulty, then you should be able to
remove it.  What does
  cat /proc/mdstat
  dmesg | tail

say at this point?

NeilBrown
