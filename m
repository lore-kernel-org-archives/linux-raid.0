From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: LVM performance (was: Re: RAID5 to RAID6 reshape?)
Date: Tue, 19 Feb 2008 20:41:19 +0100
Message-ID: <47BB30DF.1080006@student.tuwien.ac.at>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com> <20080218154203.6e2d1483@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080218154203.6e2d1483@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki schrieb:
> hold on. This might be related to raid chunk positioning with respect
> to LVM chunk positioning. If they interfere there indeed may be some
> performance drop. Best to make sure that those chunks are aligned together.

Interesting. I'm seeing a 20% performance drop too, with default RAID 
and LVM chunk sizes of 64K and 4M, respectively. Since 64K divides 4M 
evenly, I'd think there shouldn't be such a big performance penalty.
It's not like I care that much, I only have 100 Mbps ethernet anyway. 
I'm just wondering...

$ hdparm -t /dev/md0

/dev/md0:
  Timing buffered disk reads:  148 MB in  3.01 seconds =  49.13 MB/sec

$ hdparm -t /dev/dm-0

/dev/dm-0:
  Timing buffered disk reads:  116 MB in  3.04 seconds =  38.20 MB/sec

dm doesn't do anything fancy to justify the drop (encryption etc). In 
fact, it doesn't do much at all yet - I intend to use it to join 
multiple arrays in the future when I have drives of different sizes, but 
right now, I only have 500GB drives. So it's just one PV in one VG in 
one LV.

Here's some more info:

$ mdadm -D /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Sat Nov 24 12:15:48 2007
      Raid Level : raid5
      Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Feb 19 01:18:26 2008
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : d41fe8a6:84b0f97a:8ac8b21a:819833c6 (local to host 
quassel)
          Events : 0.330016

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8       81        2      active sync   /dev/sdf1

$ pvdisplay
   --- Physical volume ---
   PV Name               /dev/md0
   VG Name               raid
   PV Size               931,52 GB / not usable 2,69 MB
   Allocatable           yes (but full)
   PE Size (KByte)       4096
   Total PE              238468
   Free PE               0
   Allocated PE          238468
   PV UUID               KadH5k-9Cie-dn5Y-eNow-g4It-lfuI-XqNIet

$ vgdisplay
   --- Volume group ---
   VG Name               raid
   System ID
   Format                lvm2
   Metadata Areas        1
   Metadata Sequence No  4
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                1
   Open LV               1
   Max PV                0
   Cur PV                1
   Act PV                1
   VG Size               931,52 GB
   PE Size               4,00 MB
   Total PE              238468
   Alloc PE / Size       238468 / 931,52 GB
   Free  PE / Size       0 / 0
   VG UUID               AW9yaV-B3EM-pRLN-RTIK-LEOd-bfae-3Vx3BC

$ lvdisplay
   --- Logical volume ---
   LV Name                /dev/raid/raid
   VG Name                raid
   LV UUID                eWIRs8-SFyv-lnix-Gk72-Lu9E-Ku7j-iMIv92
   LV Write Access        read/write
   LV Status              available
   # open                 1
   LV Size                931,52 GB
   Current LE             238468
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     256
   Block device           253:0

-- 
Oliver
