From: Neil Brown <neilb@suse.de>
Subject: Re: Odd failure during reshape
Date: Wed, 2 Jun 2010 08:51:03 +1000
Message-ID: <20100602085103.5d22da69@notabene.brown>
References: <AANLkTimeH3ETfqovI2NnccHiYN152IrDhSgRdCUbYIiP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimeH3ETfqovI2NnccHiYN152IrDhSgRdCUbYIiP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Ramsey <tomoyodaidoji@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 1 Jun 2010 06:43:56 -0600
Eric Ramsey <tomoyodaidoji@gmail.com> wrote:

> My system locked up during the reshape to raid 6 and the system came
> back in a rather odd state.  2 of the original drives were knocked out
> of the array 400 GB short and all other drives indicate they are
> completley synced I would not be concerned if it was the drives I was
> expanding too.

You say "reshape to raid 6", but the "mdadm -E" information you provide says 
"reshape a RAID6 from 8 drives to 10 drives".

If you were actually reshaping to raid6 (presumably from raid5), then
something weird has gone wrong and you probably have significant data
corruption.

If you were in fact reshaping from 8 to 10 drives on a RAID6 then you are
fairly safe.  2 drives failed (at or shortly after 11:21 and 11:24 on Monday)
but RAID6 can survive that.  The reshape continued (it was nearly 90%
complete at the time anyway) and you have a fully working, though degraded,
RAID6 with 8 out of 10 drives working.

Your data should all be safe and fully accessibly, though of course if
another device dies you might lose stuff.

You should add 2 known-good drives soon.  I suggest that you do at least some
basic testing on SDD and SDE before assuming they are good and adding them
back in.
When you do add new drives, it might be best to
  echo frozen > /sys/block/md1/md/sync_action
before adding the two devices, then
  echo idle > /sys/block/md1/md/sync_action
after adding both.  That way they will both be recovered at the same time,
rather than recovering all of one, then recovering all of the other.

NeilBrown


> SDD1 and SDE1 were the drives knocked out early, and the new drives
> are SDG1 and SDH1.
> I have tried to reassemble them correctly but I get the following error:
> mdadm --assemble /dev/md1 /dev/sdd1  /dev/sde1  /dev/sdc1  /dev/sdf1
> /dev/sdg1  /dev/sdh1  /dev/sdi1  /dev/sdj1  /dev/sdk1  /dev/sdl1
> mdadm: superblock on /dev/sdc1 doesn't match others - assembly aborted
> 
> I am testing with the raid readonly to see if I lost any data, is
> there any other tips you guys can provide?
> 
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c4722 - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 10
> Preferred Minor : 1
> 
>   Reshape pos'n : 6960011264 (6637.58 GiB 7127.05 GB)
>   Delta Devices : 2 (8->10)
> 
>     Update Time : Mon May 31 11:24:20 2010
>           State : active
>  Active Devices : 9
> Working Devices : 9
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : cc00f986 - correct
>          Events : 3007985
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     6       8       49        6      active sync   /dev/sdd1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       8       49        6      active sync   /dev/sdd1
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 10
> Preferred Minor : 1
> 
>   Reshape pos'n : 6960011264 (6637.58 GiB 7127.05 GB)
>   Delta Devices : 2 (8->10)
> 
>     Update Time : Mon May 31 11:21:41 2010
>           State : active
>  Active Devices : 10
> Working Devices : 10
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : cc00f8d8 - correct
>          Events : 3007979
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     5       8       65        5      active sync   /dev/sde1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       8       65        5      active sync   /dev/sde1
>    6     6       8       49        6      active sync   /dev/sdd1
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c4756 - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8       81        3      active sync   /dev/sdf1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c4770 - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     8       8       97        8      active sync   /dev/sdg1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdh1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c4782 - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     9       8      113        9      active sync   /dev/sdh1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdi1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c478e - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     7       8      129        7      active sync   /dev/sdi1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c4798 - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     4       8      145        4      active sync   /dev/sdj1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdk1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c47a0 - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8      161        0      active sync   /dev/sdk1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> /dev/sdl1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 78e59241:4bbafd48:2109fad5:2e345672
>   Creation Time : Fri Oct 16 00:19:20 2009
>      Raid Level : raid6
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
>    Raid Devices : 10
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Tue Jun  1 06:24:19 2010
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 8e7c47b4 - correct
>          Events : 3009686
> 
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8      177        2      active sync   /dev/sdl1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8       81        3      active sync   /dev/sdf1
>    4     4       8      145        4      active sync   /dev/sdj1
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       8      129        7      active sync   /dev/sdi1
>    8     8       8       97        8      active sync   /dev/sdg1
>    9     9       8      113        9      active sync   /dev/sdh1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

