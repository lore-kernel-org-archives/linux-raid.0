From: Randy Terbush <randy@terbush.org>
Subject: Drives re-added as spares instead of put back into array in rebuild
	mode
Date: Sun, 21 Mar 2010 08:44:25 -0600
Message-ID: <7db987b31003210744x7f5991c0y9e1bb6f94da38570@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had two drives that were dropped from this four drive array.
After going through failing, removing and re-adding the drives, I am
left with the following state. The two drives that were re-added are
sitting as spares and there is no rebuilding activity going on. Can
someone explain where I am going wrong?

mdadm --detail --scan /dev/md0
/dev/md0:
        Version : 1.01
  Creation Time : Wed Mar 17 15:27:33 2010
     Raid Level : raid5
     Array Size : 1465127424 (1397.25 GiB 1500.29 GB)
  Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Mar 21 08:26:09 2010
          State : active, degraded
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 64K

           Name : hifi:0  (local to host hifi)
           UUID : b411b304:6385f171:26f07cb1:3c2b03de
         Events : 1300

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       0        0        1      removed
       2       0        0        2      removed
       4       8       65        3      active sync   /dev/sde1

       1       8       33        -      spare   /dev/sdc1
       2       8       49        -      spare   /dev/sdd1
