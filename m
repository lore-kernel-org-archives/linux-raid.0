From: Danilo Godec <danci@agenda.si>
Subject: Re: just how dangerous is this??
Date: Tue, 28 May 2002 21:20:39 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205282103070.8146-100000@duplo.agenda.si>
References: <200205281055.11601.jfillman@cucbc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200205281055.11601.jfillman@cucbc.com>
To: James Fillman <jfillman@cucbc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 May 2002, James Fillman wrote:

> I've got a large number of linux server to build and I'm using SuSE's ALICE
> install program to build them. ALICE is SuSE's auto install program and has
> limited functionality. Most importantly, it doesn't do RAID. So what I'm
> doing is having ALICE partition two drives with the partitions being of type
> "FD". It installs linux just fine on "sda" and when it's all done, I boot a
> rescue disk, and do a "mkraid -c ./raidtab --really-force /dev/md[0-4]" to
> create the mirrors. I'm just trying it out now and it seems to be working but
> I've got very little experience working with SoftRAID and I thought I'd ask
> if I'm playing with fire!!

I think this shouldn't work at all - have you rebooted the machine yet?

It's not quite clear how the mirrors reconstruct if one of the disks
(partitions) already has a filesystem on it, but I'm almost sure it's not
ment to reconstruct it properly...

AFAIK making a filesystem on a Linux SW RAID array is somewhat different
from making it on a 'normal' disk, so while you may end up with a
filesystem, it will probably be full of errors.

How does your raidtab look like?

The 'right' way of doing this is:

- create a 'degraded' mirror with sda* partitions marked as 'failed'
- copy all the data from sda* partitions to the appropriate mirrors
  (/dev/md*)
- modify /etc/fstab on the mirrored filesystem to use the mirrors
- reboot, use filesystems on the mirror (root=/dev/md?)
- hot add sda* partitions to approprate mirrors (using raidhotadd or
  mdadm)
- wait for the reconstruction to finish
- make sure that both disks have the boot loader installed in MBR, so they
  can both be used for booting

This should be it. Unfortunately, this procedure is not that easy to
script.

> the mkraid command warns me that it will delete all the data on the partitions
> when creating the mirrors, but it doesn't.

I guess it doesn't delete the data, it destroys it... :)

> What sort of implications am I looking at with this? Will it be unstable?

I am no super-expert or guru, but I'd say YES. Try booting the system with
a rescue disk and run e2fsck on your mirrored filesystems. If this goes
through OK... Well, then I might be wrong and it's OK to do this with new
kernel/raidtools...

   D.


