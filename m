From: d tbsky <tbskyd@gmail.com>
Subject: Re: mdadm goes crazy after changing chunk size
Date: Thu, 22 Jun 2017 16:08:19 +0800
Message-ID: <CAC6SzHJwyD07OZxPEJUD7BUKJDXA9OvpVTGeJW7PhxYz2EUS2w@mail.gmail.com>
References: <CAC6SzHLu35=V88phP_X_OO472NbPXhjzGzraFUMEabSXgz1N0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC6SzHLu35=V88phP_X_OO472NbPXhjzGzraFUMEabSXgz1N0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi:
    I know why mdadm refuse to grow. when I change chunk size, the
disk data-offset increase. how can I recover the space?
I tried "mdadm --grow  --data-offset=128M /dev/md2", but get response
"mdadm: --data-offset too small on /dev/sde1"

data-offset result like below:

 mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5b2c25fc:b4ccc860:ba8685fe:5e0433f7
           Name : love-1:3  (local to host love-1)
  Creation Time : Tue Jun 13 15:21:32 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 5263812239 (2509.98 GiB 2695.07 GB)
     Array Size : 5263812224 (5019.96 GiB 5390.14 GB)
  Used Dev Size : 5263812224 (2509.98 GiB 2695.07 GB)
    Data Offset : 2550222848 sectors
   Super Offset : 8 sectors
   Unused Space : before=2550222760 sectors, after=15 sectors
          State : clean
    Device UUID : 26d406ad:9dd2dcc1:d37a3d36:edb8431e

    Update Time : Thu Jun 22 15:54:33 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3dceb21f - correct
         Events : 5183

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)



2017-06-21 11:31 GMT+08:00 d tbsky <tbskyd@gmail.com>:
> Hi:
>     I want to test the performance of different chunk size, so I
> create a small raid (about 20G~200G) and use command like "mdadm
> --grow -c 64 /dev/md2) to change the chunk size.
>
>   after changing chunk size, I found almost every time the raid can
> not re-assemble after reboot.
> the error message shows like "xxx does not have a valid v1.2
> superblock, not importing!".
>
>    I found I can use "mdadm --assemble --update=devicesize ....." to
> correct it. so I just continue my testing.
>
>    now testing is done, so I want to grow the small raid to full size,
> but I am surprised that the " Used Dev Size" stocked at some stage and
> can not grow to full size. maybe I miss some command parameter?
>
>    I think I need to re-create the raid. but maybe someone is
> interested to see what happened. my environment is rhel 7.3 (but
> redhat backport kernel 4.x softwareraid stack to their 3.10 kernel).
>
>   I have several testing raidset. below is a 4disk raid6:
> ==========================================================================================
> command "mdadm --detail /dev/md1":
>
> /dev/md1:
>         Version : 1.2
>   Creation Time : Mon Jun  5 17:58:52 2017
>      Raid Level : raid6
>      Array Size : 4116416128 (3925.72 GiB 4215.21 GB)
>   Used Dev Size : 2058208064 (1962.86 GiB 2107.61 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>
>     Update Time : Wed Jun 21 11:06:32 2017
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            Name : localhost.localdomain:pv00
>            UUID : cc6a6b68:3d066e91:8bac3ba0:96448f78
>          Events : 8180
>
>     Number   Major   Minor   RaidDevice State
>        0       8        3        0      active sync   /dev/sda3
>        1       8       19        1      active sync   /dev/sdb3
>        5       8       51        2      active sync   /dev/sdd3
>        4       8       35        3      active sync   /dev/sdc3
> ==========================================================================================
> ==========================================================================================
> command "fdisk -lu /dev/sda /dev/sdb /dev/sdc /dev/sdd":
>
> Disk /dev/sda: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
>
>
> #         Start          End    Size  Type            Name
>  1         2048         4095      1M  BIOS boot parti
>  2         4096       620543    301M  Linux RAID
>  3       620544   7814037134    3.7T  Linux RAID
>
> Disk /dev/sdb: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
>
>
> #         Start          End    Size  Type            Name
>  1         2048         4095      1M  BIOS boot parti
>  2         4096       620543    301M  Linux RAID
>  3       620544   7814037134    3.7T  Linux RAID
>
> Disk /dev/sdc: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
>
>
> #         Start          End    Size  Type            Name
>  1         2048         4095      1M  BIOS boot parti
>  2         4096       620543    301M  Linux RAID
>  3       620544   7814037134    3.7T  Linux RAID
>
> Disk /dev/sdd: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
>
>
> #         Start          End    Size  Type            Name
>  1         2048         4095      1M  BIOS boot parti
>  2         4096       620543    301M  Linux RAID
>  3       620544   7814037134    3.7T  Linux RAID
> ==========================================================================================
> ==========================================================================================
> command "mdadm --grow --size=max /dev/md1":
>
> mdadm: component size of /dev/md1 unchanged at 2058208064K
> ==========================================================================================
>
>
> another raid5 is more strange. it assemble correctly after change
> chunk size (this is unusual in my testing environment without
> "--update=devicesize").
> the strange part is the md2 huge bitmap chunk:
> ==========================================================================================
> command "cat /proc/mdstat"
>
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md2 : active raid5 sde1[0] sdf1[1] sdg1[3]
>       5263812224 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 0/1 pages [0KB], 18014398507384832KB chunk
>
> md0 : active raid1 sdc2[4] sdb2[1] sda2[0] sdd2[5]
>       308160 blocks super 1.0 [4/4] [UUUU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> md1 : active raid6 sdd3[5] sdb3[1] sdc3[4] sda3[0]
>       4116416128 blocks super 1.2 level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>
> unused devices: <none>
> ==========================================================================================
>
>
> the raid5 device also can not grow to full size:
> ==========================================================================================
> command "mdadm --detail /dev/md2"
>
> /dev/md2:
>         Version : 1.2
>   Creation Time : Tue Jun 13 15:21:32 2017
>      Raid Level : raid5
>      Array Size : 5263812224 (5019.96 GiB 5390.14 GB)
>   Used Dev Size : 2631906112 (2509.98 GiB 2695.07 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Wed Jun 21 10:45:39 2017
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            Name : love-1:3  (local to host love-1)
>            UUID : 5b2c25fc:b4ccc860:ba8685fe:5e0433f7
>          Events : 5176
>
>     Number   Major   Minor   RaidDevice State
>        0       8       65        0      active sync   /dev/sde1
>        1       8       81        1      active sync   /dev/sdf1
>        3       8       97        2      active sync   /dev/sdg1
> ==========================================================================================
> ==========================================================================================
> command "fdisk -lu /dev/sde /dev/sdf /dev/sdg":
>
> Disk /dev/sde: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
>
>
> #         Start          End    Size  Type            Name
>  1         2048   7814037134    3.7T  Linux RAID
>
> Disk /dev/sdf: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
>
>
> #         Start          End    Size  Type            Name
>  1         2048   7814037134    3.7T  Linux RAID
>
> Disk /dev/sdg: 4000.8 GB, 4000787030016 bytes, 7814037168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk label type: gpt
>
>
> #         Start          End    Size  Type            Name
>  1         2048   7814037134    3.7T  Linux RAID
> ==========================================================================================
> ==========================================================================================
> command "mdadm --grow --size=max /dev/md2"
> mdadm: component size of /dev/md2 unchanged at 2631906112K
> ==========================================================================================
