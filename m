From: "NeilBrown" <neilb@suse.de>
Subject: Re: Advice on reassembling after hard crash
Date: Sat, 5 Sep 2009 09:17:21 +1000 (EST)
Message-ID: <5acabfd260b57b2e93e9a50ff83f80a9.squirrel@neil.brown.name>
References: <d39ad6430909041533u7ed61ca4re076d9e44d5f0827@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d39ad6430909041533u7ed61ca4re076d9e44d5f0827@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erich Newell <erich.newell@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, September 5, 2009 8:33 am, Erich Newell wrote:
> I had a bad crash on my RAID6 box, which seems to have dropped 2 disks
> simultaneously...which has me nervous for obvious reasons. I have the
> details from mdadm --examine for each raid member. I also included the
> pertinent dmesg snippet.
>
> My question is: Based on the Events (1197409 on /dev/sdb5 vs 1197411
> for /dev/sdc thru sdf) and checksums...should I force reassemble/start
> just sdc5/sdd5/sde5/sdf5, leave sda out altogether to start with and
> sync in sdb? or can I safely start with 5 drives sdb/sdc/sdd/sde/sdf
> and add sda back in right off?
>
> Advice? Specific commands? New options?

Just add --force to the --assemble command that you are using,
it will do the right thing.

e.g.
  mdadm --assemble --force /dev/md3 /dev/sd[abcdef]5

A difference of 2 is almost nothing, it is very unlikely that there
is any inconsistency among your devices except for the superblock.

NeilBrown


>
> Thanks!!!
>
> ==============================================================
>
> /dev/sda5:
>           Magic : a92b4efc
>         Version : 00.90.03
>            UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
>   Creation Time : Sun Dec  3 20:31:16 2006
>      Raid Level : raid6
>   Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
>      Array Size : 935496448 (892.16 GiB 957.95 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 3
>
>     Update Time : Fri Sep  4 03:39:01 2009
>           State : active
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 4ae55bef - correct
>          Events : 1197409
>
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     4       8        5        4      active sync   /dev/sda5
>
>    0     0       8       37        0      active sync   /dev/sdc5
>    1     1       8       53        1      active sync   /dev/sdd5
>    2     2       8       69        2      active sync   /dev/sde5
>    3     3       8       85        3      active sync   /dev/sdf5
>    4     4       8        5        4      active sync   /dev/sda5
>    5     5       8       21        5      active sync   /dev/sdb5
> /dev/sdb5:
>           Magic : a92b4efc
>         Version : 00.90.03
>            UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
>   Creation Time : Sun Dec  3 20:31:16 2006
>      Raid Level : raid6
>   Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
>      Array Size : 935496448 (892.16 GiB 957.95 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 3
>
>     Update Time : Fri Sep  4 03:39:01 2009
>           State : active
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 4ae55c01 - correct
>          Events : 1197409
>
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     5       8       21        5      active sync   /dev/sdb5
>
>    0     0       8       37        0      active sync   /dev/sdc5
>    1     1       8       53        1      active sync   /dev/sdd5
>    2     2       8       69        2      active sync   /dev/sde5
>    3     3       8       85        3      active sync   /dev/sdf5
>    4     4       8        5        4      active sync   /dev/sda5
>    5     5       8       21        5      active sync   /dev/sdb5
> /dev/sdc5:
>           Magic : a92b4efc
>         Version : 00.90.03
>            UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
>   Creation Time : Sun Dec  3 20:31:16 2006
>      Raid Level : raid6
>   Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
>      Array Size : 935496448 (892.16 GiB 957.95 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 3
>
>     Update Time : Fri Sep  4 03:54:41 2009
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 4ae55fc4 - correct
>          Events : 1197411
>
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     0       8       37        0      active sync   /dev/sdc5
>
>    0     0       8       37        0      active sync   /dev/sdc5
>    1     1       8       53        1      active sync   /dev/sdd5
>    2     2       8       69        2      active sync   /dev/sde5
>    3     3       8       85        3      active sync   /dev/sdf5
>    4     4       0        0        4      faulty removed
>    5     5       8       21        5      active sync   /dev/sdb5
> /dev/sdd5:
>           Magic : a92b4efc
>         Version : 00.90.03
>            UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
>   Creation Time : Sun Dec  3 20:31:16 2006
>      Raid Level : raid6
>   Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
>      Array Size : 935496448 (892.16 GiB 957.95 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 3
>
>     Update Time : Fri Sep  4 03:54:41 2009
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 4ae55fd6 - correct
>          Events : 1197411
>
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       53        1      active sync   /dev/sdd5
>
>    0     0       8       37        0      active sync   /dev/sdc5
>    1     1       8       53        1      active sync   /dev/sdd5
>    2     2       8       69        2      active sync   /dev/sde5
>    3     3       8       85        3      active sync   /dev/sdf5
>    4     4       0        0        4      faulty removed
>    5     5       8       21        5      active sync   /dev/sdb5
> /dev/sde5:
>           Magic : a92b4efc
>         Version : 00.90.03
>            UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
>   Creation Time : Sun Dec  3 20:31:16 2006
>      Raid Level : raid6
>   Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
>      Array Size : 935496448 (892.16 GiB 957.95 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 3
>
>     Update Time : Fri Sep  4 03:54:41 2009
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 4ae55fe8 - correct
>          Events : 1197411
>
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     2       8       69        2      active sync   /dev/sde5
>
>    0     0       8       37        0      active sync   /dev/sdc5
>    1     1       8       53        1      active sync   /dev/sdd5
>    2     2       8       69        2      active sync   /dev/sde5
>    3     3       8       85        3      active sync   /dev/sdf5
>    4     4       0        0        4      faulty removed
>    5     5       8       21        5      active sync   /dev/sdb5
> /dev/sdf5:
>           Magic : a92b4efc
>         Version : 00.90.03
>            UUID : ae3b47bd:ac100bfe:1bed3458:8d6915d8
>   Creation Time : Sun Dec  3 20:31:16 2006
>      Raid Level : raid6
>   Used Dev Size : 233874112 (223.04 GiB 239.49 GB)
>      Array Size : 935496448 (892.16 GiB 957.95 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 3
>
>     Update Time : Fri Sep  4 03:54:41 2009
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 4ae55ffa - correct
>          Events : 1197411
>
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     3       8       85        3      active sync   /dev/sdf5
>
>    0     0       8       37        0      active sync   /dev/sdc5
>    1     1       8       53        1      active sync   /dev/sdd5
>    2     2       8       69        2      active sync   /dev/sde5
>    3     3       8       85        3      active sync   /dev/sdf5
>    4     4       0        0        4      faulty removed
>    5     5       8       21        5      active sync   /dev/sdb5
>
>
> =====================================================================
>
> FROM dmesg:
>
> [37156.420224] md: kicking non-fresh sdb5 from array!
> [37156.420248] md: unbind<sdb5>
> [37156.433033] md: export_rdev(sdb5)
> [37156.433139] md: kicking non-fresh sda5 from array!
> [37156.433149] md: unbind<sda5>
> [37156.445036] md: export_rdev(sda5)
> [37156.445085] md: md3: raid array is not clean -- starting background
> reconstruction
> [37156.468427] raid5: device sdf5 operational as raid disk 3
> [37156.468434] raid5: device sdc5 operational as raid disk 0
> [37156.468438] raid5: device sde5 operational as raid disk 2
> [37156.468442] raid5: device sdd5 operational as raid disk 1
> [37156.468446] raid5: cannot start dirty degraded array for md3
> [37156.468452] RAID5 conf printout:
> [37156.468455]  --- rd:6 wd:4
> [37156.468459]  disk 0, o:1, dev:sdc5
> [37156.468462]  disk 1, o:1, dev:sdd5
> [37156.468465]  disk 2, o:1, dev:sde5
> [37156.468468]  disk 3, o:1, dev:sdf5
> [37156.468471] raid5: failed to run raid set md3
> [37156.468474] md: pers->run() failed ...
> [38522.717405] raid5: device sdf5 operational as raid disk 3
> [38522.717412] raid5: device sdc5 operational as raid disk 0
> [38522.717417] raid5: device sde5 operational as raid disk 2
> [38522.717421] raid5: device sdd5 operational as raid disk 1
> [38522.717425] raid5: cannot start dirty degraded array for md3
> [38522.717430] RAID5 conf printout:
> [38522.717432]  --- rd:6 wd:4
> [38522.717435]  disk 0, o:1, dev:sdc5
> [38522.717439]  disk 1, o:1, dev:sdd5
> [38522.717442]  disk 2, o:1, dev:sde5
> [38522.717445]  disk 3, o:1, dev:sdf5
> [38522.717449] raid5: failed to run raid set md3
> [38522.717452] md: pers->run() failed ...
>
>
>
> --
> "A man is defined by the questions that he asks; and the way he goes
> about finding the answers to those questions is the way he goes
> through life."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

