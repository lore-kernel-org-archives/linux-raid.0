From: Craig Hollabaugh <craig@hollabaugh.com>
Subject: Re: RAID5 kicks non-fresh drives
Date: Thu, 25 May 2006 16:30:37 -0600
Message-ID: <1148596237.4957.4.camel@hendrix.hollabaugh.com>
References: <1148571503.2772.35.camel@hendrix.hollabaugh.com>
	 <17526.7947.129968.287311@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17526.7947.129968.287311@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2006-05-26 at 07:18 +1000, Neil Brown wrote:
> And the partition types of sdj1 and sdk1 are ???

Neil,

That did it! I set the partition FS Types from 'Linux' to 'Linux raid
autodetect' after my last re-sync completed. Manually stopped and
started the array. Things looked good, so I crossed my fingers and
rebooted. The kernel found all the drives and all is happy here in
Colorado.

Thanks ever so much for your comment!!

Craig


After the reboot

root@vaughan[501]: mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu Jan 16 09:10:52 2003
     Raid Level : raid5
     Array Size : 1289056384 (1229.34 GiB 1319.99 GB)
    Device Size : 117186944 (111.76 GiB 120.00 GB)
   Raid Devices : 12
  Total Devices : 13
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 25 16:21:28 2006
          State : clean
 Active Devices : 12
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 4d862825:91140f1a:eb97e7f2:9bfa2403
         Events : 0.2684360

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8      129        3      active sync   /dev/sdi1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
       8       8       49        8      active sync   /dev/sdd1
       9       8      161        9      active sync   /dev/sdk1
      10      22        1       10      active sync   /dev/hdc1
      11       8      177       11      active sync   /dev/sdl1

      12       8      145        -      spare   /dev/sdj1





