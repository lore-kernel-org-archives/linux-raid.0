From: Bob Glamm <glamm@a-s-i.com>
Subject: Re: RAID migration from 2.4 -> 2.6
Date: Mon, 16 Aug 2004 17:35:41 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040816223541.GA1197@romulus.a-s-i.com>
References: <20040812152939.GD5326@romulus.a-s-i.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040812152939.GD5326@romulus.a-s-i.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As a follow-up, I tried using md=10,/dev/sda1,/dev/sdf1 as a kernel
parameter.  Still no luck:

Loading md10: /dev/sda1
could not lock sda1
md_import_device returned -6
could not lock sdf1
md_import_device returned -6
bug in file drivers/md/md.c, line 1513.

But apparently this error is misleading (-6 == ENXIO, no such device).
I traced the code all the way back to do_open in fs/block_dev.c
which is where it appears to be coming from.

I'm not sure why the devices can't be found: the Adaptec driver appears
to go through its initialization routines just fine and find all the
disks.

Anyone have any ideas here?

-Bob

> At the moment I'm stumped, so I wonder if someone might be able
> to give me a hand.
> 
> First, my RAID setup: I have a pair of Adaptec 7899 controllers
> with five 9GB SCSI disks on each.  The first disks on each controller
> are allocated in a RAID 1 configuration for boot, swap, /usr, etc.,
> while the next three disks on each controller are allocated in
> a RAID 5 configuration to our running services and data.  The last
> disk on each controller is designated as a spare disk for each RAID.
> 
> These RAIDs work well with 2.4.  I've got them configured
> for autodetect, so the system brings them up at startup in 2.4.
> 
> Now I'm trying to migrate to 2.6.7, and autodetection basically
> ignores all my SCSI disks.  I get three lines:
> 
>   Autodetecting RAID arrays:
>     ..  autodetecting
>   Done.
> 
> when I try to boot 2.6.7.  (Additional note: all SCSI controllers
> and disks are discovered just fine, although I am using the new
> Adaptec driver in 2.6.)
