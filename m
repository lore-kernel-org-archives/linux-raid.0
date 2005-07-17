From: "Francisco Zafra" <fzafra@gmail.com>
Subject: Recovery raid5 after sata cable failure.
Date: Sun, 17 Jul 2005 13:34:34 +0200
Message-ID: <42da427a.2e075618.7fea.2c30@mx.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
 
    I have raid5 array working without problem for some months. A SATA cable
failed and de raid5 works fine keeping the superblock persistent, but now, I
can't get the old device inserted into the array.
    This is the array just now:
 
root@Torero-2:/mnt/raid5 # mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Tue May 31 19:37:37 2005
     Raid Level : raid5
     Array Size : 1367507456 (1304.16 GiB 1400.33 GB)
    Device Size : 195358208 (186.31 GiB 200.05 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent
 
    Update Time : Sun Jul 17 13:06:17 2005
          State : clean, degraded
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
 
         Layout : left-symmetric
     Chunk Size : 512K
 
           UUID : c4ed8e45:2a036953:92bff479:7cf5bac9
         Events : 0.162797
 
    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       0        0        -      removed


	And I try to re-add the old disk in this way:

root@Torero-2:/mnt/raid5 # mdadm /dev/md0 -a /dev/sdh1   
mdadm: Cannot open /dev/sdh1: Device or resource busy

	What is wrong? What I am doing bad? Sdh1 is absolutely unused, so I
don't understand the error "resource busy"

	Thanks,

	Paco Zafra.

