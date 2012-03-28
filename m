From: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Subject: RE: mdadm raid6 recovery status
Date: Wed, 28 Mar 2012 12:49:18 +0000
Message-ID: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>,<20120328151148.035bd737@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120328151148.035bd737@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[root@in-rady-neuro9 ~]# df -kl /myarray
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md2             11537161976    162432 10950945196   1% /myarray
Should be 7TB of used space.

[root@in-rady-neuro9 ~]# cat /proc/partitions
major minor  #blocks  name

   8        0  438960128 sda
   8        1     512000 sda1
   8        2   51200000 sda2
   8        3  387247104 sda3
   8       16 1953514584 sdb
   8       32 1953514584 sdc
   8       48 1953514584 sdd
   8       64 1953514584 sde
   8       80 1953514584 sdf
   8       96 1953514584 sdg
   8      112 1953514584 sdh
   8      128 1953514584 sdi
 253        0  346226688 dm-0
 253        1   40992768 dm-1

sd[b-i] are raid devices

[root@in-rady-neuro9 ~]# mdadm --detail /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Fri Dec 16 17:56:14 2011
     Raid Level : raid6
     Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)  <<<====== Wrong! Should be 7TB of used array space.
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Mar 27 14:58:01 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 4fcdcafa:fea0c196:4d5dd1d0:da2b21e5
         Events : 0.220864

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi
[root@in-rady-neuro9 ~]#


________________________________________
From: NeilBrown [neilb@suse.de]
Sent: Wednesday, March 28, 2012 12:11 AM
To: Paramasivam, Meenakshisundaram
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm raid6 recovery status

On Wed, 28 Mar 2012 02:22:33 +0000 "Paramasivam, Meenakshisundaram"
<mparamas@iupui.edu> wrote:


> #mount   /dev/md2   /myarray
> mounts fine, however, I now see only 2TB instead of 7 TB for /myarray. I need to get all of the data back and I am stuck here.

What exactly do you mean by "see only 2TB"??
The md array is reporting that it is 12TB in size (12000 GB).

What reports 2TB?  /proc/partitions? df? du? ?/

NeilBrown
