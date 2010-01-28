From: Carlos Williams <carloswill@gmail.com>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 09:58:16 -0500
Message-ID: <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
	 <1264634977.1928.13.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264634977.1928.13.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/27 Micha=C5=82 Sawicz <michal@sawicz.net>:
> See http://scotgate.org/2006/07/03/growing-a-raid5-array-mdadm/
>
> You can check the status of your arrays by 'cat /proc/mdstat'.

Thank you both for the links. The 1st one made me laugh...

I am not lazy as I did Google that but I wasn't sure about the last
two commands for expanding the file system and I didn't know how dated
that material was so I decided to ask here on the list.

Now my extra (4th disk) has been added and grown into my RAID5 array
as shown below:

[root@tuna ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Wed Jan 27 08:15:03 2010
     Raid Level : raid5
     Array Size : 720587328 (687.21 GiB 737.88 GB)
  Used Dev Size : 240195776 (229.07 GiB 245.96 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jan 28 08:35:24 2010
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : e3c1e8b3:5a1b141f:af88d4a5:584f0b5f
         Events : 0.1810

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2

Now my /dev/md0 RAID5 array is mounted to my / partition. I still need
to expand the file system to make use of the extra space, right? I
simply added the drive and empty partition table into the RAID...I
still don't have a file system on it yet, do I?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
