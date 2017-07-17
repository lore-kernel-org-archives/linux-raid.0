From: pg@lxraid2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Advice please re failed Raid6
Date: Mon, 17 Jul 2017 01:19:21 +0100
Message-ID: <22892.649.826246.644975@tree.ty.sabi.co.uk>
References: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> mdadm --create --assume-clean [ ... ]

That's a very dangerous recovery method that you need to get
exactly right or it will cause trouble.

Also it should be used in very rare cases, not routinely to
recover from one missing disk.

> root@keruru:/var/log# mdadm --examine /dev/sd[bedc] >> raid.status
> root@keruru:/var/log# cat raid.status 
> /dev/sdb:
>      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
>      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>     Device UUID : 79e4933f:dfe5923f:5ba03ae7:3efe38eb
>          Events : 119
>      Chunk Size : 512K
>    Device Role : Active device 0
>    Array State : AAAA ('A' == active, '.' == missing)
> /dev/sdc:
>      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
>      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>     Device UUID : f1e1a946:711886a6:2604780f:8eba4a2d
>          Events : 119
>      Chunk Size : 512K
>    Device Role : Active device 1
> /dev/sdd:
>      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
>      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>     Device UUID : cf3bc8a7:9feed87d:945d8e77:08f7f32d
>          Events : 119
>      Chunk Size : 512K
>    Device Role : Active device 2
> /dev/sde:
>      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
>      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>          Events : 119
>      Chunk Size : 512K
>    Device Role : Active device 3

That AAAA meant that the array was fine. The important field of
'--examine' confirm that. The "dirty degraded array" meant most
likely some slight event count difference, usually one just
forces assembly in that case.

The line that worries a bit is this:

  Jul 5 21:06:18 keruru mdadm[2497]: RebuildFinished event
  detected on md  device /dev/md0, component device mismatches
  found: 1847058224 (on raid  level 6)

That seems to indicate that pretty much every block was a
mismatch. Which would have happened if you put in a blank drive
and then used '--create --assume-clean' instead of '--assemble
--force'. But '--assume-clean" explicitly skips a rebuild, and I
wonder whether you omitted that yoiu have triggered a "repair"
in 'sync_action'. Also the message is reported by 'mdadm', and
it may be that 'mdadm' was running in daemon mode and triggering
a periodic "repair". I can't remember the defaults.

HOWEVER there is a very subtle detail: the order of the devices
from '--examine' is: 0: 'sdb', 1: 'sdc', 2: 'sdd', 3: 'sde' but
you recreated the set in a different order. The order of the
devices does not matter if they have MD superblocks,.but here
you are using '--create' to make new superblocks, and they order
must match exactly the original order.

> root@keruru:/var/log# mdadm --create --assume-clean --level=6 --raid-devices=4 --size=1953382912 /dev/md0 /dev/sdb /dev/sde /dev/sdd /dev/sdc

Probably the best thing you can do is to rerun this with members
"missing /dev/sdc /dev/sdd /dev/sde". and then use 'blkid /dev/md0'
to check whether the data in it is recognized again. If so add
'/dev/sdb'. I did a quick test here of something close to that
and it worked...
