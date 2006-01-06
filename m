From: PFC <lists@peufeu.com>
Subject: Re: Kanotix crashed my raid...
Date: Fri, 06 Jan 2006 13:08:49 +0100
Message-ID: <op.s2yhczepcigqcu@apollo13>
References: <fd8d0180601050104x15079396h@mail.gmail.com> <fd8d0180601050106s5f5b4306o@mail.gmail.com> <87oe2r2d93.fsf@rimspace.net> <fd8d0180601050321k19f12f53r@mail.gmail.com> <43BE3C99.4050706@ieee.org> <op.s2yecmeocigqcu@apollo13> <op.s2yg1vkdcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s2yg1vkdcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	And mdstat says it's inactive ; while mdadm says it's "active,  
degraded"... what's happening ????



apollo13 ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
md1 : active raid1 hdc7[1] hda7[0]
       6248832 blocks [2/2] [UU]

md2 : inactive sda1[0] hdb1[4] sdc1[3] sdb1[1]
       978615040 blocks

md0 : active raid1 hdc6[0] hda6[1]
       72292992 blocks [2/2] [UU]

unused devices: <none>
apollo13 ~ # mdadm --detail /dev/md2
/dev/md2:
         Version : 00.90.02
   Creation Time : Sun Dec 25 17:58:00 2005
      Raid Level : raid5
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 5
   Total Devices : 4
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Fri Jan  6 06:57:15 2006
           State : active, degraded
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 55ef57eb:c153dce4:c6f9ac90:e0da3c14
          Events : 0.61952

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
    1829109784       0        0        0      removed
        3       8       33        3      active sync   /dev/sdc1
        4       3       65        4      active sync   /dev/hdb1

