From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: accidently pulled to many devices, raid6 wont start.
Date: Thu, 5 Dec 2013 00:51:31 +0000
Message-ID: <BLU0-SMTP43277FF0CE64113FA97325A98D70@phx.gbl>
References: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I should also state I can put the originall pulled drive back in if that
would be of any help, and re-run the -examine if that might be more
sensible as the drive should be ok.


On Thu, 2013-12-05 at 00:30 +0000, Wilson Jonathan wrote:
> I have tried a --assemble force..
> 
> the result was it could not because the devices said it was ignored.
> 
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --assemble
> -v /dev/md5 
> mdadm: looking for devices for /dev/md5
> mdadm: no RAID superblock on /dev/md/7
> mdadm: no RAID superblock on /dev/md6
> mdadm: no RAID superblock on /dev/md/4
> mdadm: no RAID superblock on /dev/md/3
> mdadm: no RAID superblock on /dev/md/2
> mdadm: no RAID superblock on /dev/md/1
> mdadm: no RAID superblock on /dev/md/0
> mdadm: /dev/sdh7 has wrong uuid.
> mdadm: /dev/sdh6 has wrong uuid.
> mdadm: /dev/sdh5 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdh4
> mdadm: /dev/sdh3 has wrong uuid.
> mdadm: /dev/sdh2 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdh1
> mdadm: no RAID superblock on /dev/sdh
> mdadm: /dev/sdg7 has wrong uuid.
> mdadm: /dev/sdg6 has wrong uuid.
> mdadm: /dev/sdg5 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdg4
> mdadm: /dev/sdg3 has wrong uuid.
> mdadm: /dev/sdg2 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdg1
> mdadm: no RAID superblock on /dev/sdg
> mdadm: /dev/sdf1 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdf
> mdadm: /dev/sde1 has wrong uuid.
> mdadm: no RAID superblock on /dev/sde
> mdadm: /dev/sdd1 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdd
> mdadm: no RAID superblock on /dev/sdc
> mdadm: /dev/sdb5 has wrong uuid.
> mdadm: /dev/sdb4 has wrong uuid.
> mdadm: /dev/sdb3 has wrong uuid.
> mdadm: /dev/sdb2 has wrong uuid.
> mdadm: no RAID superblock on /dev/sdb1
> mdadm: no RAID superblock on /dev/sdb
> mdadm: /dev/sda1 has wrong uuid.
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sdf6 is identified as a member of /dev/md5, slot 2.
> mdadm: /dev/sde6 is identified as a member of /dev/md5, slot 1.
> mdadm: /dev/sdd6 is identified as a member of /dev/md5, slot 0.
> mdadm: /dev/sdb6 is identified as a member of /dev/md5, slot 4.
> mdadm: /dev/sda6 is identified as a member of /dev/md5, slot 3.
> mdadm: ignoring /dev/sde6 as it reports /dev/sdf6 as failed
> mdadm: ignoring /dev/sda6 as it reports /dev/sdf6 as failed
> mdadm: ignoring /dev/sdb6 as it reports /dev/sdf6 as failed
> mdadm: no uptodate device for slot 1 of /dev/md5
> mdadm: added /dev/sdf6 to /dev/md5 as 2
> mdadm: no uptodate device for slot 3 of /dev/md5
> mdadm: no uptodate device for slot 4 of /dev/md5
> mdadm: no uptodate device for slot 5 of /dev/md5
> mdadm: added /dev/sdd6 to /dev/md5 as 0
> mdadm: /dev/md5 assembled from 2 drives - not enough to start the array.
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --stop /dev/md5
> 
> 
> So i checked count:-
> 
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm
> --examine /dev/sd[a-f]6 | egrep 'Event|/dev/sd'
> /dev/sda6:
>          Events : 260321
> /dev/sdb6:
>          Events : 260321
> /dev/sdd6:
>          Events : 260321
> /dev/sde6:
>          Events : 260321
> /dev/sdf6:
>          Events : 260321
> 
> My full scan of the partiotions was:-
> 
> /dev/sda6:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 9ff95b8b:ba34ad95:aa7cb806:169246f2
>            Name : PartedMagic:6
>   Creation Time : Fri Nov 25 16:30:19 2011
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 1833569679 (874.31 GiB 938.79 GB)
>      Array Size : 3667138560 (3497.26 GiB 3755.15 GB)
>   Used Dev Size : 1833569280 (874.31 GiB 938.79 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : f773d872:8237b0f7:1a8fb43e:545ef37d
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Dec  4 23:07:34 2013
>        Checksum : 75d8e87e - correct
>          Events : 260321
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Device Role : Active device 3
>    Array State : AA.AA. ('A' == active, '.' == missing)
> /dev/sdb6:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 9ff95b8b:ba34ad95:aa7cb806:169246f2
>            Name : PartedMagic:6
>   Creation Time : Fri Nov 25 16:30:19 2011
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 1833569287 (874.31 GiB 938.79 GB)
>      Array Size : 3667138560 (3497.26 GiB 3755.15 GB)
>   Used Dev Size : 1833569280 (874.31 GiB 938.79 GB)
>     Data Offset : 1928 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : dbda8da3:0d5e0968:e732a312:88a04c2a
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Dec  4 23:15:16 2013
>        Checksum : 97305bb9 - correct
>          Events : 260321
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Device Role : Active device 4
>    Array State : AA..A. ('A' == active, '.' == missing)
> /dev/sdd6:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 9ff95b8b:ba34ad95:aa7cb806:169246f2
>            Name : PartedMagic:6
>   Creation Time : Fri Nov 25 16:30:19 2011
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 1833569679 (874.31 GiB 938.79 GB)
>      Array Size : 3667138560 (3497.26 GiB 3755.15 GB)
>   Used Dev Size : 1833569280 (874.31 GiB 938.79 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : b451254c:dbc5f0fe:5e182208:6bd93c2c
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Dec  4 23:15:16 2013
>        Checksum : ce1c5ac1 - correct
>          Events : 260321
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Device Role : Active device 0
>    Array State : AAAAA. ('A' == active, '.' == missing)
> /dev/sde6:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 9ff95b8b:ba34ad95:aa7cb806:169246f2
>            Name : PartedMagic:6
>   Creation Time : Fri Nov 25 16:30:19 2011
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 1833569679 (874.31 GiB 938.79 GB)
>      Array Size : 3667138560 (3497.26 GiB 3755.15 GB)
>   Used Dev Size : 1833569280 (874.31 GiB 938.79 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : c0200a09:fac761e5:43a54346:34597026
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Dec  4 23:15:16 2013
>        Checksum : a9c9388b - correct
>          Events : 260321
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Device Role : Active device 1
>    Array State : AA..A. ('A' == active, '.' == missing)
> /dev/sdf6:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 9ff95b8b:ba34ad95:aa7cb806:169246f2
>            Name : PartedMagic:6
>   Creation Time : Fri Nov 25 16:30:19 2011
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 1833569679 (874.31 GiB 938.79 GB)
>      Array Size : 3667138560 (3497.26 GiB 3755.15 GB)
>   Used Dev Size : 1833569280 (874.31 GiB 938.79 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 19b46e87:20182485:2f386b4e:b7f52203
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Dec  4 23:05:48 2013
>        Checksum : acc8494b - correct
>          Events : 260321
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Device Role : Active device 2
>    Array State : AAAAA. ('A' == active, '.' == missing)
> 
> I tried to do a force create:-
> 
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --create
> --assume-clean --level=6 --raid-devices=6 /dev/md5 /dev/sdd6 /dev/sde6
> missing /dev/sdf6 /dev/sda6 /dev/sdb6
> mdadm: /dev/sdd6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Fri Nov 25 16:30:19 2011
> mdadm: /dev/sde6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Fri Nov 25 16:30:19 2011
> mdadm: /dev/sdf6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Fri Nov 25 16:30:19 2011
> mdadm: /dev/sda6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Fri Nov 25 16:30:19 2011
> mdadm: /dev/sdb6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Fri Nov 25 16:30:19 2011
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md5 started.
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --stop /dev/md5
> 
> 
> but when I looked at it, it was wrongly partitioned, so stopped it...
> 
> So tried again, with a different (valid) chunk...
> 
> 
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --create
> --assume-clean --level=6 --raid-devices=6
> --chunk=64 /dev/md5 /dev/sdd6 /dev/sde6
> missing /dev/sdf6 /dev/sda6 /dev/sdb6
> mdadm: /dev/sdd6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Wed Dec  4 23:59:23 2013
> mdadm: /dev/sde6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Wed Dec  4 23:59:23 2013
> mdadm: /dev/sdf6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Wed Dec  4 23:59:23 2013
> mdadm: /dev/sda6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Wed Dec  4 23:59:23 2013
> mdadm: /dev/sdb6 appears to be part of a raid array:
>     level=raid6 devices=6 ctime=Wed Dec  4 23:59:23 2013
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md5 started.
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --stop /dev/md5
> 
> but still the partition was all wrong... it should be a single
> partition, but its showing multiple partitions... and is
> reporting /dev/md5p3 "warning miss aligned"
> 
> I think I should, and have, stop doing anything else, till I have some
> help :-/
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


