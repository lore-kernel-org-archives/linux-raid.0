From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: Problem with mdadm 2.6.7
Date: Sun, 27 Jul 2008 17:26:33 +0300
Message-ID: <488C8599.4090503@mandriva.org>
References: <488C531B.5060005@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <488C531B.5060005@mandriva.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
(please cc me as I'm not subscribed)

I have hit a bug with mdadm 2.6.7

It rebuilds my raid5 array on every boot
(raid0 and raid1 arrays are not affected)

This didn't happend with 2.6.4

kernels tested are 2.6.24.7 and 2.6.25.12

Arch is x86_64
Distro Mandriva 2008.1, but I've tested wich kernel.org kernels and 
upstream mdadm 2.6.7 and have the same problem

Now I could try to bisect it, but every raid5 rebuild takes 6-7 hours, 
so I thought about asking for pointers before...

Any ideas where to start looking ?

here is the info on the array that gets rebuilt...


[root@tmb ~]# mdadm --detail /dev/md8
/dev/md8:
         Version : 00.90
   Creation Time : Fri Feb  1 17:44:23 2008
      Raid Level : raid5
      Array Size : 1465143808 (1397.27 GiB 1500.31 GB)
   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 8
     Persistence : Superblock is persistent

     Update Time : Sun Jul 27 13:32:30 2008
           State : clean, degraded, recovering
  Active Devices : 2
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

  Rebuild Status : 1% complete

            UUID : dc482f3f:ad67b9ef:bb6636b8:e9392071
          Events : 0.16162

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        3       8       65        2      spare rebuilding   /dev/sde1
