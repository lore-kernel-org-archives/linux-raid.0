From: Tobias Geiger <tobias.geiger@vido.info>
Subject: Re: RAID6 - "Invalid Argument" / "does not have a valid v1.2
 superblock" =?UTF-8?Q?=3F!?=
Date: Fri, 04 Dec 2015 18:32:22 +0100
Message-ID: <decd47bfb0705511e9d26408670ef104@vido.info>
References: <207014396.bPZ85pNCfm@t400>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <207014396.bPZ85pNCfm@t400>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Am 02.12.2015 18:04, schrieb Tobias Geiger:
> Hello,
> 
> i need help assembling my raid6 again:
> 
> root@pc:~# mdadm -A /dev/md0 -v  --force /dev/sdd2 /dev/sde2 /dev/sdg2
> /dev/sdc2 /dev/sdb2 /dev/sdf2
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdd2 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sde2 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdg2 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdc2 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdb2 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdf2 is identified as a member of /dev/md0, slot 5.
> mdadm: failed to add /dev/sde2 to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdg2 to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdc2 to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdb2 to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdf2 to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdd2 to /dev/md0: Invalid argument
> mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
> 
> 
> dmesg says to this:
> 
> [25717.423008] md: md0 stopped.
> [25717.424958] md: sde2 does not have a valid v1.2 superblock, not 
> importing!
> [25717.424989] md: md_import_device returned -22
> [25717.425266] md: sdg2 does not have a valid v1.2 superblock, not 
> importing!
> [25717.425963] md: md_import_device returned -22
> [25717.426847] md: sdc2 does not have a valid v1.2 superblock, not 
> importing!
> [25717.426880] md: md_import_device returned -22
> [25717.427908] md: sdb2 does not have a valid v1.2 superblock, not 
> importing!
> [25717.427952] md: md_import_device returned -22
> [25717.428890] md: sdf2 does not have a valid v1.2 superblock, not 
> importing!
> [25717.428938] md: md_import_device returned -22
> [25717.429668] md: sdd2 does not have a valid v1.2 superblock, not 
> importing!
> [25717.429716] md: md_import_device returned -22
> [25717.430104] md: md0 stopped.
> 
> 
> but i cant find any problems examining the devices:
> 
> 
> 
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 078883e8:30c2ebe6:87576034:e85737b8
>            Name : pc:0  (local to host pc)
>   Creation Time : Fri Sep  5 01:06:21 2014
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 7813699215 (3725.86 GiB 4000.61 GB)
>      Array Size : 15627124736 (14903.19 GiB 16002.18 GB)
>   Used Dev Size : 7813562368 (3725.80 GiB 4000.54 GB)
>     Data Offset : 198656 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=198568 sectors, after=69263 sectors
>           State : clean
>     Device UUID : 02dab3ff:6e36ebf3:2012e2a0:e8b29f3f
> 
>     Update Time : Wed Dec  2 10:13:53 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : b75c2285 - correct
>          Events : 1903827
> 
>          Layout : left-symmetric
>      Chunk Size : 4096K
> 
>    Device Role : Active device 4
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdc2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 078883e8:30c2ebe6:87576034:e85737b8
>            Name : pc:0  (local to host pc)
>   Creation Time : Fri Sep  5 01:06:21 2014
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 7813699215 (3725.86 GiB 4000.61 GB)
>      Array Size : 15627124736 (14903.19 GiB 16002.18 GB)
>   Used Dev Size : 7813562368 (3725.80 GiB 4000.54 GB)
>     Data Offset : 198656 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=198568 sectors, after=69263 sectors
>           State : clean
>     Device UUID : c9aaa3e3:00589ba5:be8fe774:362d477a
> 
>     Update Time : Wed Dec  2 10:13:53 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 5ba906b9 - correct
>          Events : 1903827
> 
>          Layout : left-symmetric
>      Chunk Size : 4096K
> 
>    Device Role : Active device 3
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdd2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 078883e8:30c2ebe6:87576034:e85737b8
>            Name : pc:0  (local to host pc)
>   Creation Time : Fri Sep  5 01:06:21 2014
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 7813699215 (3725.86 GiB 4000.61 GB)
>      Array Size : 15627124736 (14903.19 GiB 16002.18 GB)
>   Used Dev Size : 7813562368 (3725.80 GiB 4000.54 GB)
>     Data Offset : 198656 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=198568 sectors, after=69263 sectors
>           State : clean
>     Device UUID : 2b4e613e:1a7f062c:f8ba29a9:e5dcfaf8
> 
>     Update Time : Wed Dec  2 10:13:53 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : efc7b1df - correct
>          Events : 1903827
> 
>          Layout : left-symmetric
>      Chunk Size : 4096K
> 
>    Device Role : Active device 0
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sde2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 078883e8:30c2ebe6:87576034:e85737b8
>            Name : pc:0  (local to host pc)
>   Creation Time : Fri Sep  5 01:06:21 2014
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 7813699215 (3725.86 GiB 4000.61 GB)
>      Array Size : 15627124736 (14903.19 GiB 16002.18 GB)
>   Used Dev Size : 7813562368 (3725.80 GiB 4000.54 GB)
>     Data Offset : 198656 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=198568 sectors, after=69263 sectors
>           State : clean
>     Device UUID : e80ba505:cc0b9904:9288c64a:5c289e62
> 
>     Update Time : Wed Dec  2 10:13:53 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 9ade0f9a - correct
>          Events : 1903827
> 
>          Layout : left-symmetric
>      Chunk Size : 4096K
> 
>    Device Role : Active device 1
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdf2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 078883e8:30c2ebe6:87576034:e85737b8
>            Name : pc:0  (local to host pc)
>   Creation Time : Fri Sep  5 01:06:21 2014
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 7813699215 (3725.86 GiB 4000.61 GB)
>      Array Size : 15627124736 (14903.19 GiB 16002.18 GB)
>   Used Dev Size : 7813562368 (3725.80 GiB 4000.54 GB)
>     Data Offset : 198656 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=198568 sectors, after=69263 sectors
>           State : clean
>     Device UUID : f769eefd:bd202fca:50966083:39a25647
> 
>     Update Time : Wed Dec  2 10:13:53 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 76100a3c - correct
>          Events : 1903827
> 
>          Layout : left-symmetric
>      Chunk Size : 4096K
> 
>    Device Role : Active device 5
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdg2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 078883e8:30c2ebe6:87576034:e85737b8
>            Name : pc:0  (local to host pc)
>   Creation Time : Fri Sep  5 01:06:21 2014
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 7813699215 (3725.86 GiB 4000.61 GB)
>      Array Size : 15627124736 (14903.19 GiB 16002.18 GB)
>   Used Dev Size : 7813562368 (3725.80 GiB 4000.54 GB)
>     Data Offset : 198656 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=198568 sectors, after=69263 sectors
>           State : clean
>     Device UUID : 7fad3e2f:85dd6849:127d7d47:58c166dd
> 
>     Update Time : Wed Dec  2 10:13:53 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 80c71068 - correct
>          Events : 1903827
> 
>          Layout : left-symmetric
>      Chunk Size : 4096K
> 
>    Device Role : Active device 2
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> 
> 
> 
> except for the Checksum and the Device UUID the output is exactly the 
> same for
> each device...
> 
> 
> i really hesitate to "recreate" the array with "--assume-clean", 
> because of
> the Unused-Space/ArraySize, which i wouldnt know how to reassemble in a
> "mdadm --create ..." line ...
> 
> 
> do you have any thoughts on that?
> Thanks very much for your help!
> 
> Greetings
> Tobias
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I convinced myself that there is no other chance, and did:

mdadm -v --create /dev/md0 --readonly --bitmap=none --chunk=4M --level=6 
--raid-device=6 --assume-clean --data-offset 99328 /dev/sdd2 /dev/sde2 
/dev/sdg2 /dev/sdc2 /dev/sdb2 /dev/sdf2

that worked out (puh!), so it seems that "only" the data-offset (and of 
course chunk/level...) needed to match.
That is btw in "sectors" in the --examine output, so one has to convert 
it to kbytes for the --create line!

Greetings!
Tobias


