From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Is my RAID 5 array working OK?
Date: Mon, 05 Jul 2004 09:38:55 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87wu1j7374.fsf@enki.rimspace.net>
References: <1483.192.168.1.2.1088970622.squirrel@192.168.1.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 Jul 2004, Robin Bowes wrote:

[...]

> # mdadm -v --create /dev/md5 --chunk=128 --level=raid5 --raid-devices=6
> 	--spare-devices=0 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2 /dev/sde2
> 	/dev/sdf2
>
> When I look at the array to see what's happening, this is what I see:
>
> # mdadm --detail /dev/md5
> /dev/md5:
> Version : 00.90.01
> Creation Time : Sun Jul  4 20:48:07 2004
> Raid Level : raid5
> Array Size : 1218208000 (1161.77 GiB 1247.44 GB)
> Device Size : 243641600 (232.35 GiB 249.49 GB)
> Raid Devices : 6
> Total Devices : 6
> Preferred Minor : 5
> Persistence : Superblock is persistent
>
> Update Time : Sun Jul  4 20:48:07 2004
> State : clean, no-errors
> Active Devices : 5
> Working Devices : 6
> Failed Devices : 0
> Spare Devices : 1
>
> Layout : left-symmetric
> Chunk Size : 128K
>
> Rebuild Status : 2% complete
>
> Number   Major   Minor   RaidDevice State
> 0       8        2        0      active sync   /dev/sda2
> 1       8       18        1      active sync   /dev/sdb2
> 2       8       34        2      active sync   /dev/sdc2
> 3       8       50        3      active sync   /dev/sdd2
> 4       8       66        4      active sync   /dev/sde2
> 5       0        0       -1      removed
> 6       8       82        5      spare   /dev/sdf2
> UUID : 2950b4e7:893db3f0:090135ec:f9ca1574
> Events : 0.177301
>
> Why do I appear to have 7 devices? Why is device number 6 marked as
> spare? Is this normal while the array is being built? Do I just need
> to leave it working away until it finishes, or is something wrong?

As you worked out, this is part of the creation process. The reason it
is done this way is that this will apparently resync faster than just
sticking all six disks in place.

I asked the same question the first time I used the RAID-5 system. :)

  Daniel
-- 
Keep a diary and one day it'll keep you.
        -- Mae West

