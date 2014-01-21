From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Disappointing performance: 5-disk RAID6, 3.11.6
Date: Tue, 21 Jan 2014 17:55:43 +0100
Message-ID: <CADNH=7HpRJRDQ9PUmKDOVs=Pbbj2Z50AZi9XdFrhUBQKR7A-Dg@mail.gmail.com>
References: <CAKuK5J34CvTwZ5S6uyBUdEft2SkwrycXvYfNvQATit8GbdZcuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J34CvTwZ5S6uyBUdEft2SkwrycXvYfNvQATit8GbdZcuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21 January 2014 17:42, Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
>
> I have a 5-disk RAID6 using (5) 320GB SATA drives.
> I rarely see even sequential I/O approaching that of a single drive's
> performance.
> Example: (Rarely!) I'll see an aggregate 250MB/s read or write, but
> that translates to 50MB/s read or write per-drive. I was hoping for
> more.
>
> The partition layout looks like this:
>
> /dev/sda1 : start=     2048, size=  1024000, Id=83, bootable
> /dev/sda2 : start=  1026048, size=  1024000, Id=82
> /dev/sda3 : start=  2050048, size=623091712, Id=fd
> /dev/sda4 : start=        0, size=        0, Id= 0
>
> on all 5 disks, and sd{whatever}3 is used to assemble the raid,
> specifically, /dev/md2.
>
> mdadm -D /dev/md2:
>
> /dev/md2:
>         Version : 1.2
>   Creation Time : Fri Nov  1 11:13:07 2013
>      Raid Level : raid6
>      Array Size : 934242816 (890.96 GiB 956.66 GB)
>   Used Dev Size : 311414272 (296.99 GiB 318.89 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Tue Jan 21 10:33:52 2014
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            Name : turnip:2  (local to host turnip)
>            UUID : bece804d:eaaeb280:38d2d7f3:1e493146
>          Events : 21788
>
>     Number   Major   Minor   RaidDevice State
>        0       8       51        0      active sync   /dev/sdd3
>        1       8       35        1      active sync   /dev/sdc3
>        2       8        3        2      active sync   /dev/sda3
>        3       8       19        3      active sync   /dev/sdb3
>        4       8       67        4      active sync   /dev/sde3
>
> The filesystem is ext4, and debugfs says:
>
> RAID stride:              16
> RAID stripe width:        48
>
>
> The processor is an AMD Phenom 9150e (quad-core, x86_64) and the O/S
> is openSUSE 13.1, kernel 3.11.6. Some of the hardware looks like this:
>
> 00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] RS780 Host Bridge
> 00:01.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI
> to PCI bridge (int gfx)
> 00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI
> to PCI bridge (PCIE port 3)
> 00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
>
>
> Settings:
> The stripe_cache_size is 4096 (see
> http://blog.jamponi.net/2013/12/sw-raid6-performance-influenced-by.html
> )
> readahead is 16384
> scheduler is deadline
> queue depth per-drive is 1.
> nr_requests is 256.
>
> Does this seem out of line? Thoughts?
>
> --
> Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Does enabling NCQ help? (I see "queue depth per-drive is 1")

Mathias
