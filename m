From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 2 Jan 2009 07:10:20 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
 <344038.60917.qm@web30808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <344038.60917.qm@web30808.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids



On Thu, 1 Jan 2009, Mike Myers wrote:

> Ok, the bad MPT board is out, replaced by a SI3132, and I rejiggered the drives around so that all the drives are connected.  It brought me back to the main problem.  md2 is running fine, md1 cannot assemble with only 5 drives out of the 7.
>
> Here is the data you requested:
>
> (none):~ # cat /etc/mdadm.conf
> DEVICE partitions
> ARRAY /dev/md0 level=raid0 UUID=9412e7e1:fd56806c:0f9cc200:95c7ed98
> ARRAY /dev/md3 level=raid0 UUID=67999c69:4a9ca9f9:7d4d6b81:91c98b1f
> ARRAY /dev/md1 level=raid5 UUID=b737af5c:7c0a70a9:99a648a0:7f693c7d
> ARRAY /dev/md2 level=raid5 UUID=e70e0697:a10a5b75:941dd76f:196d9e4e
> #ARRAY /dev/md2 level=raid0 UUID=658369ee:23081b79:c990e3a2:15f38c70
> #ARRAY /dev/md3 level=raid0 UUID=e2c910ae:0052c38e:a5e19298:0d057e34
> MAILADDR root
>
> (md0 and md3 are old arrays that have since been removed - no disks with their uuids are in the system)
>
> (none):~> mdadm -D /dev/md1
> mdadm: md device /dev/md1 does not appear to be active.
>
>
> (none):~> mdadm -D /dev/md2
> /dev/md2:
>        Version : 00.90.03
>  Creation Time : Tue Aug 19 21:31:10 2008
>     Raid Level : raid5
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>   Raid Devices : 7
>  Total Devices : 7
> Preferred Minor : 2
>    Persistence : Superblock is persistent
>
>    Update Time : Thu Jan  1 21:59:20 2009
>          State : clean
> Active Devices : 7
> Working Devices : 7
> Failed Devices : 0
>  Spare Devices : 0
>
>         Layout : left-symmetric
>     Chunk Size : 128K
>
>           UUID : e70e0697:a10a5b75:941dd76f:196d9e4e
>         Events : 0.1438838
>
>    Number   Major   Minor   RaidDevice State
>       0       8      209        0      active sync   /dev/sdn1
>       1       8      129        1      active sync   /dev/sdi1
>       2       8      177        2      active sync   /dev/sdl1
>       3       8       17        3      active sync   /dev/sdb1
>       4       8       33        4      active sync   /dev/sdc1
>       5       8       65        5      active sync   /dev/sde1
>       6       8      193        6      active sync   /dev/sdm1
>
>
> (md1 is comprised of sdd1 sdf1 sdg1 sdh1 sdj1 sdk1 sdo1)
>

What happens if you use assemble and force with the five good drives
and one or the other of the ones that are not assembling (to assemble in
degraded mode)?

For the two disks that have 'failed' can you show their smart stats, I am
curious to see them.

Worst case which I do not recommend unless it is your last resort is re-create
the array with --assume-clean with the same options you used originally; doing
this though will cause filesystem corruption.

I recommend you switch to RAID-6 with an array that big btw :)

Justin.

