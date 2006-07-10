From: Karl Voit <news@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 09:27:32 +0000 (UTC)
Message-ID: <loom.20060710T112459-261@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org> <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com> <loom.20060710T095111-275@post.gmane.org> <44B213CD.5010907@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Henrik Holst <henrik.holst <at> idgmail.se> writes:

> Karl Voit wrote:
> [snip]
> > Well this is because of the false(?) superblocks of sda-sdd in comparison
> to
> > sda1 to sdd1.
>
> I don't understand this.

Me neither *g*

This is the hint of a friend of mine, who is lot more experienced with
sw-raids.

> Do you have more than a single partion on sda?

No.

> Is sda1 occupying the entire disk?

Yes.

root@ned ~ # fdisk -l /dev/sda

Disk /dev/sda: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1       30395   244147806   fd  Linux raid autodetect
root@ned ~ #

I created the raid5 with sd[abcd]1 and not with sd[abcd].

> since the superblock is the /last/
> "128Kb" (I'm assuming 128*1024 bytes) the superblocks should be one and
> the same.

Really? Then how come that the md0 woun't start? I also upgraded my system
(kernel and md0) and now I get longer messages about the superblocks which I
already posted here in my previous posting.

root@ned ~ # date;cat /proc/mdstat
Mon Jul 10 10:56:44 CEST 2006
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] [raid10]
unused devices: <none>
root@ned ~ #


TNX so far, I appreciate your help!


