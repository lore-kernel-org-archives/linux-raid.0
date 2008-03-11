From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: problem with JBOD mode on MegaRAID
Date: Tue, 11 Mar 2008 17:26:05 +0100
Message-ID: <20080311162605.GB28927@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Here is a thread I started on linux-poweredge@dell.com, do you have an 
idea how to solve that problem?

On Tue, Mar 11, 2008 at 03:06:11PM +0000, Tom Brown wrote:
> 
> >
> > I just got my shiny new PE 2900 and would like to use its 8 disks in 
> > JBOD mode. I tried deleting all disk groups on the bios config panel 
> > but no disks are detected from within Linux (grml64 2.6.23).
> >
> > What is the right way to configure the MegaRAID card for JBOD operation?
> 
> create 8 RAID zero's

I just tried transfering my 4 x 1TB sata raid5 array from a PE 840 to 
the PE 2900 and now this disks seem to have shrunk:

- PE 840:

	pyrrhus:~# fdisk -l /dev/sda

	Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
	255 heads, 63 sectors/track, 121601 cylinders
	Units = cylinders of 16065 * 512 = 8225280 bytes
	Disk identifier: 0x4605adf0

- PE 2900:

	zenon:~# fdisk -l /dev/sda

	Disk /dev/sda: 999.6 GB, 999653638144 bytes
	255 heads, 63 sectors/track, 121534 cylinders
	Units = cylinders of 16065 * 512 = 8225280 bytes
	Disk identifier: 0x00000083

But they are the exact same models.

And this prevents me from initializing the third raid5 array made from 
each disk's last partition. Fortunately the system partition is the 
second one.

Here is the boot message:

	Mar 11 17:15:21 zenon kernel: md: md2 stopped.
	Mar 11 17:15:21 zenon kernel: attempt to access beyond end of device
	Mar 11 17:15:21 zenon kernel: sda: rw=0, want=1953519829, limit=1952448512
	Mar 11 17:15:21 zenon kernel: printk: 330 messages suppressed.
	Mar 11 17:15:21 zenon kernel: Buffer I/O error on device sda3, logical block 1752707328

Is the Megaraid "raid0" mode eating up part of the disk's end?

Thanks for any insight on that problem,
