From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Inactive arrays
Date: Tue, 2 Aug 2016 11:17:41 +0100
Message-ID: <57A07345.4040708@youngman.org.uk>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a quick first response. I see md128 and md129 are both down, and
are both listed as one drive, raid0. Bit odd, that ...

What version of mdadm are you using? One of them had a bug (3.2.3 era?)
that would split an array in two. Is it possible that you should have
one raid0 array with sdf1 and sdf2? But that's a bit of a weird setup...

I notice also that md126 is raid10 across two drives. That's odd, too.

How much do you know about what the setup should be, and why it was set
up that way?

Download lspci by Phil Turmel (it requires python2.7, if your machine is
python3 a quick fix to the shebang at the start should get it to work).
Post the output from that here.

Cheers,
Wol

On 02/08/16 08:36, Daniel Sanabria wrote:
> Hi All,
> 
> I have a box that I believe was not powered down correctly and after
> transporting it to a different location it doesn't boot anymore
> stopping at BIOS check "Verifying DMI Pool Data".
> 
> The box have 6 drives and after instructing the BIOS to boot from the
> first drive I managed to boot the OS (Fedora 23) after commenting out
> 2 /etc/fstab entries , output for "uname -a; cat /etc/fstab" follows:
> 
> [root@lamachine ~]# uname -a; cat /etc/fstab
> Linux lamachine 4.3.3-303.fc23.x86_64 #1 SMP Tue Jan 19 18:31:55 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
> #
> # /etc/fstab
> # Created by anaconda on Tue Mar 24 19:31:21 2015
> #
> # Accessible filesystems, by reference, are maintained under '/dev/disk'
> # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
> #
> /dev/mapper/vg_bigblackbox-LogVol_root /                       ext4
> defaults        1 1
> UUID=4e51f903-37ca-4479-9197-fac7b2280557 /boot                   ext4
>    defaults        1 2
> /dev/mapper/vg_bigblackbox-LogVol_opt /opt                    ext4
> defaults        1 2
> /dev/mapper/vg_bigblackbox-LogVol_tmp /tmp                    ext4
> defaults        1 2
> /dev/mapper/vg_bigblackbox-LogVol_var /var                    ext4
> defaults        1 2
> UUID=9194f492-881a-4fc3-ac09-ca4e1cc2985a swap                    swap
>    defaults        0 0
> /dev/md2 /home          ext4    defaults        1 2
> #/dev/vg_media/lv_media  /mnt/media      ext4    defaults        1 2
> #/dev/vg_virt_dir/lv_virt_dir1 /mnt/guest_images/ ext4 defaults 1 2
> [root@lamachine ~]#
> 
> When checking mdstat I can see that 2 of the arrays are showing up as
> inactive, but not sure how to safely activate these so looking for
> some knowledgeable advice on how to proceed here.
> 
> Thanks in advance,
> 
> Daniel
> 
> Below some more relevant outputs:
> 
> [root@lamachine ~]# cat /proc/mdstat
> Personalities : [raid10] [raid6] [raid5] [raid4] [raid0]
> md127 : active raid0 sda5[0] sdc5[2] sdb5[1]
>       94367232 blocks super 1.2 512k chunks
> 
> md2 : active raid5 sda3[0] sdc2[2] sdb2[1]
>       511999872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> md128 : inactive sdf1[3](S)
>       2147352576 blocks super 1.2
> 
> md129 : inactive sdf2[2](S)
>       524156928 blocks super 1.2
> 
> md126 : active raid10 sda2[0] sdc1[1]
>       30719936 blocks 2 near-copies [2/2] [UU]
> 
> unused devices: <none>
> [root@lamachine ~]# cat /etc/mdadm.conf
> # mdadm.conf written out by anaconda
> MAILADDR root
> AUTO +imsm +1.x -all
> ARRAY /dev/md2 level=raid5 num-devices=3
> UUID=2cff15d1:e411447b:fd5d4721:03e44022
> ARRAY /dev/md126 level=raid10 num-devices=2
> UUID=9af006ca:8845bbd3:bfe78010:bc810f04
> ARRAY /dev/md127 level=raid0 num-devices=3
> UUID=acd5374f:72628c93:6a906c4b:5f675ce5
> ARRAY /dev/md128 metadata=1.2 spares=1 name=lamachine:128
> UUID=f2372cb9:d3816fd6:ce86d826:882ec82e
> ARRAY /dev/md129 metadata=1.2 name=lamachine:129
> UUID=895dae98:d1a496de:4f590b8b:cb8ac12a
> [root@lamachine ~]# mdadm --detail /dev/md1*
> /dev/md126:
>         Version : 0.90
>   Creation Time : Thu Dec  3 22:12:12 2009
>      Raid Level : raid10
>      Array Size : 30719936 (29.30 GiB 31.46 GB)
>   Used Dev Size : 30719936 (29.30 GiB 31.46 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 126
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Aug  2 07:46:39 2016
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : near=2
>      Chunk Size : 64K
> 
>            UUID : 9af006ca:8845bbd3:bfe78010:bc810f04
>          Events : 0.264152
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync set-A   /dev/sda2
>        1       8       33        1      active sync set-B   /dev/sdc1
> /dev/md127:
>         Version : 1.2
>   Creation Time : Tue Jul 26 19:00:28 2011
>      Raid Level : raid0
>      Array Size : 94367232 (90.00 GiB 96.63 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Jul 26 19:00:28 2011
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 512K
> 
>            Name : reading.homeunix.com:3
>            UUID : acd5374f:72628c93:6a906c4b:5f675ce5
>          Events : 0
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        5        0      active sync   /dev/sda5
>        1       8       21        1      active sync   /dev/sdb5
>        2       8       37        2      active sync   /dev/sdc5
> /dev/md128:
>         Version : 1.2
>      Raid Level : raid0
>   Total Devices : 1
>     Persistence : Superblock is persistent
> 
>           State : inactive
> 
>            Name : lamachine:128  (local to host lamachine)
>            UUID : f2372cb9:d3816fd6:ce86d826:882ec82e
>          Events : 4154
> 
>     Number   Major   Minor   RaidDevice
> 
>        -       8       81        -        /dev/sdf1
> /dev/md129:
>         Version : 1.2
>      Raid Level : raid0
>   Total Devices : 1
>     Persistence : Superblock is persistent
> 
>           State : inactive
> 
>            Name : lamachine:129  (local to host lamachine)
>            UUID : 895dae98:d1a496de:4f590b8b:cb8ac12a
>          Events : 0
> 
>     Number   Major   Minor   RaidDevice
> 
>        -       8       82        -        /dev/sdf2
> [root@lamachine ~]# mdadm --detail /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Mon Feb 11 07:54:36 2013
>      Raid Level : raid5
>      Array Size : 511999872 (488.28 GiB 524.29 GB)
>   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Aug  1 20:24:23 2016
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : 2cff15d1:e411447b:fd5d4721:03e44022 (local to host lamachine)
>          Events : 0.611
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        3        0      active sync   /dev/sda3
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
> [root@lamachine ~]#
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

