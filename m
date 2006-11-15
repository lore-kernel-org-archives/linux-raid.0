From: "=?gb2312?B?0+HPyNOh?=" <yu_xianyin@dahuatech.com>
Subject: How mdadm can support > 2T
Date: Wed, 15 Nov 2006 12:36:38 +0800
Message-ID: <200611151236376090234@dahuatech.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ilinux-raid want to create raid0 use mdadm 2.5.6, kernel 2.6.18-iop3 on the intel iop80331(32bit). use 5 disks, and every hard disk is 500G. But it can't beyond > 2T.  How can support >2T on the 32bit cpu ?  

command and log :
#mdadm -C /dev/md0 -l0 -n5 /dev/sd[c,d,e,f,g]
# mdadm --detail /dev/md0

root@iop:/# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu Jan  1 00:29:29 1970
     Raid Level : raid0
     Array Size : 294448832 (280.81 GiB 301.52 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jan  1 00:29:29 1970
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : ebdd57fe:8eb46fdf:884d06b0:5db18b9d
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4       8       96        4      active sync   /dev/sdg



