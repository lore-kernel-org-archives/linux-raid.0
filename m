From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: best practice when using removable drives and USB enclosure?
Date: Sat, 17 Oct 2009 04:34:21 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.0910170432210.20160@p34.internal.lan>
References: <2267211f0910162234s60f52e0pbf29b93bf7141da1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0910162234s60f52e0pbf29b93bf7141da1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 16 Oct 2009, Tim Bostrom wrote:

> I have a four drive USB enclosure that is populated with two drives
> currently in RAID1 (md1).  [pay no attention to md0]
>
> mdadm.conf
> DEVICE  /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdg1 /dev/sdh1
> ARRAY   /dev/md0 level=raid5 num-devices=4
> UUID=cdaba8bd:80943c6a:ab2fedca:3ef56cfb
> devices=/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1
> ARRAY   /dev/md1 level=raid1 num-devices=2
> UUID=649526d8:828a57b4:ab2fedca:3ef56cfb devices=/dev/sdg1,/dev/sdh1
>
> fstab
> /dev/md0                /mnt/teradata           ext3    defaults       1 2
> /dev/md1                /mnt/mirror             ext3    defaults        1 2
>
>
> [Fri Oct 16-22:34:15] [tbostrom@teraserver ~]$ sudo mdadm --detail
> --scan /dev/md1
> /dev/md1:
>        Version : 0.90
>  Creation Time : Wed Oct 14 09:38:10 2009
>     Raid Level : raid1
>     Array Size : 1465135936 (1397.26 GiB 1500.30 GB)
>  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>   Raid Devices : 2
>  Total Devices : 2
> Preferred Minor : 1
>    Persistence : Superblock is persistent
>
>    Update Time : Fri Oct 16 08:11:05 2009
>          State : clean
> Active Devices : 2
> Working Devices : 2
> Failed Devices : 0
>  Spare Devices : 0
>
>           UUID : 649526d8:828a57b4:ab2fedca:3ef56cfb (local to host
> teraserver.teambostrom.com)
>         Events : 0.36
>
>    Number   Major   Minor   RaidDevice State
>       0       8       97        0      active sync   /dev/sdg1
>       1       8      113        1      active sync   /dev/sdh1
>
>
> When I created the array, I had another a third drive in the enclosure
> I was using for other work and the drive letters for the two RAID1
> drives were /dev/sdh1 and /dev/sdi1.  After I removed the disks and
> rebooted, the array drives changed to /dev/sdg1 and /dev/sdh1.  I then
> fixed my mdadm.conf and fstab to list the correct partitions.
>
> SO..... I don't anticipate changing drives in and out of the last two
> open slots of my USB enclosure, but what would be the best practice
> for making sure md1 comes up at boot all the time without having to
> manually go into mdadm.conf and modify it back to /dev/sdh1 and
> /dev/sdi1 when I put a drive in the open drive slots?
>
> I'm sure I'm missing some newbie Linux feature and this may not have
> to do with RAID.  Any ideas?
>
> Thank you.
>
> -- 
> -Tim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi,

mdadm --examine --scan > /etc/mdadm/mdadm.conf

Make sure this is started up at boot via mdadm (/etc/init.d/mdadm-raid 
start) in Debian, this will/should put the UUID of the arrays in the file 
and then it should not matter what the disks are named.

If you are plugging them in randomly you will need to setup an event based 
script to do something similar for you.

Justin.
