From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: help please, can't mount/recover raid 5 array
Date: Sun, 10 Feb 2013 09:36:02 +0000
Message-ID: <CAHscji1enS+Crp23kMX_6pX-bhrDNZ3-7Lbg2dAOPRtJc_nEhw@mail.gmail.com>
References: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
	<alpine.DEB.2.00.1302100728130.32644@uplift.swm.pp.se>
	<CAHscji0h5nHUssKi23BMfR=Ek+jSH+vK0odYNWkzrVDf6t18mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji0h5nHUssKi23BMfR=Ek+jSH+vK0odYNWkzrVDf6t18mw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

to the whole list this time ...

Thanks,

Daniel

On 10 February 2013 09:17, Daniel Sanabria <sanabria.d@gmail.com> wrote:
> Hi Mikael,
>
> Yes I did. Here it is:
>
> [root@lamachine ~]# mdadm --examine /dev/sd*
> /dev/sda:
>    MBR Magic : aa55
> Partition[0] :       407552 sectors at         2048 (type 83)
> Partition[1] :     61440000 sectors at       409663 (type fd)
> Partition[2] :    512000000 sectors at     61849663 (type fd)
> Partition[3] :    402918402 sectors at    573849663 (type 05)
> mdadm: No md superblock detected on /dev/sda1.
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 9af006ca:8845bbd3:bfe78010:bc810f04
>   Creation Time : Thu Dec  3 22:12:12 2009
>      Raid Level : raid10
>   Used Dev Size : 30719936 (29.30 GiB 31.46 GB)
>      Array Size : 30719936 (29.30 GiB 31.46 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 126
>
>     Update Time : Sat Feb  9 17:21:45 2013
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : e6d627b3 - correct
>          Events : 263120
>
>          Layout : near=2
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     0       8        2        0      active sync   /dev/sda2
>
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       33        1      active sync   /dev/sdc1
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 0deb6f79:aec7ed69:bfe78010:bc810f04
>   Creation Time : Thu Dec  3 22:12:24 2009
>      Raid Level : raid5
>   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
>      Array Size : 511999872 (488.28 GiB 524.29 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 2
>
>     Update Time : Sat Feb  9 16:09:20 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 8dd157e5 - correct
>          Events : 792552
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     0       8        3        0      active sync   /dev/sda3
>
>    0     0       8        3        0      active sync   /dev/sda3
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
> /dev/sda4:
>    MBR Magic : aa55
> Partition[0] :     62918679 sectors at           63 (type 83)
> Partition[1] :      7116795 sectors at     82453782 (type 05)
> /dev/sda5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : acd5374f:72628c93:6a906c4b:5f675ce5
>            Name : reading.homeunix.com:3
>   Creation Time : Tue Jul 26 19:00:28 2011
>      Raid Level : raid0
>    Raid Devices : 3
>
>  Avail Dev Size : 62916631 (30.00 GiB 32.21 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 5778cd64:0bbba183:ef3270a8:41f83aca
>
>     Update Time : Tue Jul 26 19:00:28 2011
>        Checksum : 96003cba - correct
>          Events : 0
>
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAA ('A' == active, '.' == missing)
> mdadm: No md superblock detected on /dev/sda6.
> /dev/sdb:
>    MBR Magic : aa55
> Partition[1] :    512000000 sectors at       409663 (type fd)
> Partition[2] :     16384000 sectors at    512409663 (type 82)
> Partition[3] :    447974402 sectors at    528793663 (type 05)
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 0deb6f79:aec7ed69:bfe78010:bc810f04
>   Creation Time : Thu Dec  3 22:12:24 2009
>      Raid Level : raid5
>   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
>      Array Size : 511999872 (488.28 GiB 524.29 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 2
>
>     Update Time : Sat Feb  9 16:09:20 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 8dd157f6 - correct
>          Events : 792552
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       18        1      active sync   /dev/sdb2
>
>    0     0       8        3        0      active sync   /dev/sda3
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
> mdadm: No md superblock detected on /dev/sdb3.
> /dev/sdb4:
>    MBR Magic : aa55
> Partition[0] :     62912354 sectors at           63 (type 83)
> Partition[1] :      7116795 sectors at     82447457 (type 05)
> /dev/sdb5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : acd5374f:72628c93:6a906c4b:5f675ce5
>            Name : reading.homeunix.com:3
>   Creation Time : Tue Jul 26 19:00:28 2011
>      Raid Level : raid0
>    Raid Devices : 3
>
>  Avail Dev Size : 62910306 (30.00 GiB 32.21 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 152d0202:64efb3e7:f23658c3:82a239a1
>
>     Update Time : Tue Jul 26 19:00:28 2011
>        Checksum : 892dbb61 - correct
>          Events : 0
>
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AAA ('A' == active, '.' == missing)
> mdadm: No md superblock detected on /dev/sdb6.
> /dev/sdc:
>    MBR Magic : aa55
> Partition[0] :     61440000 sectors at           63 (type fd)
> Partition[1] :    512000000 sectors at     61440063 (type fd)
> Partition[2] :    403328002 sectors at    573440063 (type 05)
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 9af006ca:8845bbd3:bfe78010:bc810f04
>   Creation Time : Thu Dec  3 22:12:12 2009
>      Raid Level : raid10
>   Used Dev Size : 30719936 (29.30 GiB 31.46 GB)
>      Array Size : 30719936 (29.30 GiB 31.46 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 126
>
>     Update Time : Sat Feb  9 17:21:45 2013
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : e6d627d4 - correct
>          Events : 263120
>
>          Layout : near=2
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
>
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       33        1      active sync   /dev/sdc1
> /dev/sdc2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 0deb6f79:aec7ed69:bfe78010:bc810f04
>   Creation Time : Thu Dec  3 22:12:24 2009
>      Raid Level : raid5
>   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
>      Array Size : 511999872 (488.28 GiB 524.29 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 2
>
>     Update Time : Sat Feb  9 16:09:20 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 8dd15808 - correct
>          Events : 792552
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     2       8       34        2      active sync   /dev/sdc2
>
>    0     0       8        3        0      active sync   /dev/sda3
>    1     1       8       18        1      active sync   /dev/sdb2
>    2     2       8       34        2      active sync   /dev/sdc2
> /dev/sdc3:
>    MBR Magic : aa55
> Partition[0] :     62910589 sectors at           63 (type 83)
> Partition[1] :      7116795 sectors at     82445692 (type 05)
> /dev/sdc5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : acd5374f:72628c93:6a906c4b:5f675ce5
>            Name : reading.homeunix.com:3
>   Creation Time : Tue Jul 26 19:00:28 2011
>      Raid Level : raid0
>    Raid Devices : 3
>
>  Avail Dev Size : 62908541 (30.00 GiB 32.21 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : a0efc1b3:94cc6eb8:deea76ca:772b2d2d
>
>     Update Time : Tue Jul 26 19:00:28 2011
>        Checksum : 9eba9119 - correct
>          Events : 0
>
>      Chunk Size : 512K
>
>    Device Role : Active device 2
>    Array State : AAA ('A' == active, '.' == missing)
> mdadm: No md superblock detected on /dev/sdc6.
> [root@lamachine ~]#
>
> Regards,
>
> Daniel
>
> On 10 February 2013 06:29, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>> On Sat, 9 Feb 2013, Daniel Sanabria wrote:
>>
>>> After the upgrade I had to assemble the array manually and didn't get any
>>> errors but I was still getting the mount problem. I went ahead and recreated
>>> it with mdadm --create --assume-clean and still the smae result.
>>
>>
>> Did you save mdadm --examine from the drives *before* you did this?
>>
>> --
>> Mikael Abrahamsson    email: swmike@swm.pp.se
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
