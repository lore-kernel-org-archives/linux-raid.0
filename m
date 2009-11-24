From: Andrew Burgess <aab@cichlid.com>
Subject: grow raid 6: different errors with mdadm 3.0.3 and 3.1
Date: Tue, 24 Nov 2009 10:21:39 -0800
Message-ID: <1259086899.4139.4@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


mdadm 3.0.3:

# mdadm -v /dev/md1 --grow --raid-devices=15
mdadm: Need to backup 19968K of critical section..
mdadm: /dev/md1: failed to save critical region

mdadm 3.1:

sudo ./mdadm -G /dev/md1 --raid-devices=15
mdadm: this change will reduce the size of the array.
        use --grow --array-size first to truncate array.
        e.g. mdadm --grow /dev/md1 --array-size 928142080

Hmmm. Can I just echo something into /proc to make this happen?
(assuming these are both mdadm bugs)

Or should I try another mdadm? I googled and a problem like #1
occured to someone using 3.0 and they worked around by using
2.6.7. But I'm starting to get nervous that mdadm may really be
trying to stop me from doing something dumb...

New fc12 upgrade, kernel 2.6.31.5-127.fc12.x86_64

Thanks for any help

------------------------------

sudo ./mdadm -D /dev/md1
/dev/md1:
         Version : 1.02
   Creation Time : Tue Sep 11 13:49:50 2007
      Raid Level : raid6
      Array Size : 8785916928 (8378.90 GiB 8996.78 GB)
   Used Dev Size : 732159744 (698.24 GiB 749.73 GB)
    Raid Devices : 14
   Total Devices : 15
     Persistence : Superblock is persistent

     Update Time : Tue Nov 24 10:05:31 2009
           State : clean
  Active Devices : 14
Working Devices : 15
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

            Name : 5
            UUID : 5211e02e:19f8718e:8feeb699:03a4879f
          Events : 9329236

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
       10       8      113        1      active sync   /dev/sdh1
        2       8       65        2      active sync   /dev/sde1
        8       8      161        3      active sync   /dev/sdk1
        4       8       81        4      active sync   /dev/sdf1
       13       8      129        5      active sync   /dev/sdi1
        9       8       97        6      active sync   /dev/sdg1
       11       8       33        7      active sync   /dev/sdc1
       12       8      177        8      active sync   /dev/sdl1
        7       8      145        9      active sync   /dev/sdj1
       15      65       49       10      active sync   /dev/sdt1
       14       8       49       11      active sync   /dev/sdd1
       17       9        4       12      active sync   /dev/md4
       16       9        3       13      active sync   /dev/md3

       18      65        1        -      spare   /dev/sdq1
