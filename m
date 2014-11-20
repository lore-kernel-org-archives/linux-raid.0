From: Phil Turmel <philip@turmel.org>
Subject: Re: degraded raid troubleshooting
Date: Thu, 20 Nov 2014 18:16:03 -0500
Message-ID: <546E7633.60702@turmel.org>
References: <CAAugdn4bp9im=hk=8qWkcxpzss-dzB-5Fq-3KnJH6y3AoqXxZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAugdn4bp9im=hk=8qWkcxpzss-dzB-5Fq-3KnJH6y3AoqXxZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Burke <steve.burke.56@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stephen,

On 11/20/2014 08:41 AM, Stephen Burke wrote:
> I woke up this morning to my pc not booting saying that my raid was in
> a degraded state.  I looked at the raid wiki and it told me to stop
> what I was doing and mail the linux-raid list before doing anything
> hasty.

:-)

> Here's all the info that I could find out about it.  Any help would be
> appreciated.
> I am running Ubuntu 12.04
> mdadm - v3.2.5 - 18th May 2012
> 
> The drive in question is /dev/sdb1 on my system.  I tried to look at
> it via fdisk but it hangs up.  What should my first steps to figure
> out if this drive is bad and if so replace it.  Thanks.

Good news: your data is still safe, and already assembled (ready to
use).  The boot failure is a one-time warning that the number of drives
available at shutdown didn't match the available drives at bootup.

> syslog
> 
> Nov 20 01:14:53 ht-pc kernel: [    2.465076]          res
> 41/40:08:09:08:00/00:00:00:00:00/00 Emask 0x409 (media error) <F>
> 
> Nov 20 01:14:53 ht-pc kernel: [    2.465078] ata2.00: status: { DRDY ERR }
> 
> Nov 20 01:14:53 ht-pc kernel: [    2.465079] ata2.00: error: { UNC }
> 
> Nov 20 01:14:53 ht-pc kernel: [    2.484536] ata2.00: configured for UDMA/133
> 
> Nov 20 01:14:53 ht-pc kernel: [    2.484543] ata2: EH complete
> 
> Nov 20 01:14:53 ht-pc kernel: [    3.131754] ata2.00: exception Emask
> 0x0 SAct 0x40 SErr 0x0 action 0x0
> 
> Nov 20 01:14:53 ht-pc kernel: [    3.131756] ata2.00: irq_stat 0x40000008
> 
> Nov 20 01:14:53 ht-pc kernel: [    3.131758] ata2.00: failed command:
> READ FPDMA QUEUED
> 
> Nov 20 01:14:53 ht-pc kernel: [    3.131762] ata2.00: cmd
> 60/08:30:08:08:00/00:00:00:00:00/40 tag 6 ncq 4096 in
> 
> Nov 20 01:14:53 ht-pc kernel: [    3.131763]          res
> 41/40:08:09:08:00/00:00:00:00:00/00 Emask 0x409 (media error) <F>

Bad news: that drive is very likely dead.  It didn't communicate at all.

If you replace the drive and the replacement works, I would count that
as definitively a bad drive.  But it could be a cable or controller
problem.  Such things happen.

Before adding the new drive, though, I would show the "mdadm -E" reports
for each of the surviving member devices.  Just in case you encounter a
problem during rebuild (ridiculously common for big drives in raid5).

Anyways, use "mdadm /dev/md0 --add /dev/sdX1" after you partition the
new drive.  That'll start the rebuild.

Phil


