From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: raid md126, md127 problem after reboot, howto fix?
Date: Mon, 09 Feb 2015 10:55:06 +0100
Message-ID: <54D883FA.8080401@profitbricks.com>
References: <54D7B317.5010809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D7B317.5010809@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Widmer <metafor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08.02.2015 20:03, Marc Widmer wrote:
> Hi List
> 
> I have no deep unterstand about raids, beside setting them up initially and
> replacing disks if needed. So this error has never happened to me before:
> 
> After a reboot i have a really strange behaviour on my server. Disks are
> not marked faulty, but raid is "fallend apart".
> 
> /proc/mdstat shows me:
> 
> md126 : active raid1 sda1[0]
>       10485696 blocks [2/1] [U_]
> 
> md127 : active raid1 sda2[0]
>       721558464 blocks [2/1] [U_]
> 
> md1 : active raid1 sdb1[1]
>       10485696 blocks [2/1] [_U]
> 
> md2 : active raid1 sdb2[1]
>       721558464 blocks [2/1] [_U]
> 
> wished would be something similar to:
> md1 : active raid1 sdb1[1] sda1[0]
>       10238912 blocks [2/2] [UU]
> 
> md2 : active raid1 sdb2[1] sda2[0]
>       1942746048 blocks [2/2] [UU]
> 
> Currently only md1, md2 are running. nmon shows me, that only disks sdb is
> active, sda is not doing anything.
> 
> I run debian squeeze.
> 
> I am a bit concerned what to do, because at the moment i run on one disk
> only and if things go wrong i end up with a server not running (downtime)
> and possible data loss (beside backups).
> 
> Any ideas what i should do? Howto put the raid back together, possibly in
> live mode, without rebooting in rescue mode and risk long downtime?

Just stop all arrays which aren't in use at the moment and assemble them
manually. If they are already running degraded, then add the now
unassociated disks to their respective running arrays.

$ mdadm --stop /dev/md126
$ mdadm --stop /dev/md127
$ mdadm /dev/md1 --add /dev/sda1
$ mdadm /dev/md2 --add /dev/sda2

This could require some syncing but then everything should be normal again.

Cheers,
Sebastian
