From: Mario 'BitKoenig' Holbe <Mario.Holbe@RZ.TU-Ilmenau.DE>
Subject: Re: bug in mdadm?
Date: Sat, 29 May 2004 15:59:48 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c9a50k$it6$1@sea.gmane.org>
References: <20040529121725.GA7259@fubini.pci.uni-heidelberg.de>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bernd Schubert <Bernd.Schubert@tc.pci.uni-heidelberg.de> wrote:
> for one of our raid1 devices 'mdadm -D' reports 3 devices and 1
> failed device, though I'm pretty sure that I specified
> '--raid-devices=2' when I created that raid-array.
[...]
>    Raid Devices : 2

You did.

>   Total Devices : 3

Plus one spare disk.

>  Active Devices : 2
> Working Devices : 2

Two mirrors up and running.

>  Failed Devices : 1
>   Spare Devices : 0

One disk failed or out-of-sync or something like that.

[moved from above]
> One another system, 'mdadm -D' reports the correct numbers.

What do you expect as 'correct'?
Did you move *all* the physical disks of the one
system to the other?
Did you also move your mdadm.conf (if you didn't
move the disk with the root-fs), if there is one?

> The data from /proc/mdstat report the correct numbers.
> Any ideas whats the reason for this? Is it a bug in mdadm or has the
> superblock really wrong data?

Well, perhaps there is any partition somewhere else
on your disks with the same UUID, which gets merged
to md0 as spare disk: Did you remove a mirror from
md0 in the past and add another one?

Another chance could be you are using mdadm's 'spare
groups'. I don't know, what mdadm does show in this
case.


regards,
   Mario
-- 
reich sein heisst nicht, einen Ferrari zu kaufen, sondern einen zu
verbrennen
                                               Dietmar Wischmeier

