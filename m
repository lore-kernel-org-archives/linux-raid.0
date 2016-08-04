From: Yi Zhang <yizhan@redhat.com>
Subject: journal disk become the first of --detail list after fail/remove
 one disk
Date: Thu, 4 Aug 2016 06:52:12 -0400 (EDT)
Message-ID: <1933083404.11265226.1470307932889.JavaMail.zimbra@redhat.com>
References: <1597878292.11264554.1470307437177.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1597878292.11264554.1470307437177.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, shli@fb.com, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

Hi folks

patch[1] has move journal to end of --detail list, but I found after fail/remove the one of the disk, 
the journal disk change to be the fisrt one, detailed steps pls refer[2]

[1]
commit 6fe4c6160399c94a15eda6092371e0ac9a38a4bc
Author: Song Liu <songliubraving@fb.com>
Date:   Mon Dec 21 11:23:41 2015 -0800

    move journal to end of --detail list

[2]
Reproduce steps
# uname -r
4.7.0
# mdadm --version
mdadm - v3.4-63-g52209d6 - 21st July 2016
# mdadm --create --run /dev/md0 --level 4 --metadata 1.2 --raid-devices 7 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6 /dev/loop7 --write-journal /dev/loop0 --bitmap=internal --bitmap-chunk=64M --chunk 512
mdadm: array /dev/md0 started.
# mdadm --wait /dev/md0 
# mdadm -D /dev/md0 
/dev/md0:
        Version : 1.2
  Creation Time : Thu Aug  4 18:42:19 2016
     Raid Level : raid4
     Array Size : 3139584 (2.99 GiB 3.21 GB)
  Used Dev Size : 523264 (511.00 MiB 535.82 MB)
   Raid Devices : 7
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Aug  4 18:42:34 2016
          State : clean 
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 512K

           Name : dhcp-12-125.nay.redhat.com:0  (local to host dhcp-12-125.nay.redhat.com)
           UUID : 29a267c2:04e91998:639e6eef:64ddbab0
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       7        1        0      active sync   /dev/loop1
       1       7        2        1      active sync   /dev/loop2
       2       7        3        2      active sync   /dev/loop3
       3       7        4        3      active sync   /dev/loop4
       4       7        5        4      active sync   /dev/loop5
       5       7        6        5      active sync   /dev/loop6
       8       7        7        6      active sync   /dev/loop7

       7       7        0        -      journal   /dev/loop0
# mdadm /dev/md0 -f /dev/loop1 
mdadm: set /dev/loop1 faulty in /dev/md0
# mdadm -D /dev/md0 
/dev/md0:
        Version : 1.2
  Creation Time : Thu Aug  4 18:42:19 2016
     Raid Level : raid4
     Array Size : 3139584 (2.99 GiB 3.21 GB)
  Used Dev Size : 523264 (511.00 MiB 535.82 MB)
   Raid Devices : 7
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Aug  4 18:43:07 2016
          State : clean, degraded 
 Active Devices : 6
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 1

     Chunk Size : 512K

           Name : dhcp-12-125.nay.redhat.com:0  (local to host dhcp-12-125.nay.redhat.com)
           UUID : 29a267c2:04e91998:639e6eef:64ddbab0
         Events : 22

    Number   Major   Minor   RaidDevice State
       7       7        0        -      journal   /dev/loop0
       1       7        2        1      active sync   /dev/loop2
       2       7        3        2      active sync   /dev/loop3
       3       7        4        3      active sync   /dev/loop4
       4       7        5        4      active sync   /dev/loop5
       5       7        6        5      active sync   /dev/loop6
       8       7        7        6      active sync   /dev/loop7

       0       7        1        -      faulty   /dev/loop1
# mdadm /dev/md0 -r /dev/loop1 
mdadm: hot removed /dev/loop1 from /dev/md0
# mdadm -D /dev/md0 
/dev/md0:
        Version : 1.2
  Creation Time : Thu Aug  4 18:42:19 2016
     Raid Level : raid4
     Array Size : 3139584 (2.99 GiB 3.21 GB)
  Used Dev Size : 523264 (511.00 MiB 535.82 MB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Aug  4 18:43:22 2016
          State : clean, degraded 
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 512K

           Name : dhcp-12-125.nay.redhat.com:0  (local to host dhcp-12-125.nay.redhat.com)
           UUID : 29a267c2:04e91998:639e6eef:64ddbab0
         Events : 23

    Number   Major   Minor   RaidDevice State
       7       7        0        -      journal   /dev/loop0
       1       7        2        1      active sync   /dev/loop2
       2       7        3        2      active sync   /dev/loop3
       3       7        4        3      active sync   /dev/loop4
       4       7        5        4      active sync   /dev/loop5
       5       7        6        5      active sync   /dev/loop6
       8       7        7        6      active sync   /dev/loop7


Best Regards,
  Yi Zhang


