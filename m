From: "Meyer, Adrian" <adrian_meyer@med.unc.edu>
Subject: Re-creating/Fixing Raid5 from superblock Info
Date: Sun, 27 Apr 2014 14:03:43 +0000
Message-ID: <ACABA0F8A3B9A3468A3881B311B28B08586E8013@ITS-MSXMBS2F.ad.unc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am trying to re-create a raid5 after re-installing the OS. Unfortunately my initial try was not successful and I probably messed things up. I saved the original disk information (see below). What would be the mdadm --create command with the correct additional parameters?

/dev/sde:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
  Creation Time : Mon Jul  2 00:08:03 2012
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Apr 26 11:03:04 2014
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 188e511f - correct
         Events : 33568

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       96        0      active sync   /dev/sdg

   0     0       8       96        0      active sync   /dev/sdg
   1     1       8      112        1      active sync   /dev/sdh
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      160        4      active sync   /dev/sdk
root@niederhorn:/home/xbmc# mdadm --examine /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
  Creation Time : Mon Jul  2 00:08:03 2012
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Apr 26 11:03:04 2014
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 188e5131 - correct
         Events : 33568

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8      112        1      active sync   /dev/sdh

   0     0       8       96        0      active sync   /dev/sdg
   1     1       8      112        1      active sync   /dev/sdh
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      160        4      active sync   /dev/sdk
root@niederhorn:/home/xbmc# mdadm --examine /dev/sdg
/dev/sdg:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
  Creation Time : Mon Jul  2 00:08:03 2012
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Apr 26 11:03:04 2014
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 188e5143 - correct
         Events : 33568

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8      128        2      active sync   /dev/sdi

   0     0       8       96        0      active sync   /dev/sdg
   1     1       8      112        1      active sync   /dev/sdh
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      160        4      active sync   /dev/sdk
root@niederhorn:/home/xbmc# mdadm --examine /dev/sdh
/dev/sdh:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
  Creation Time : Mon Jul  2 00:08:03 2012
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Apr 26 11:03:04 2014
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 188e5155 - correct
         Events : 33568

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      144        3      active sync   /dev/sdj

   0     0       8       96        0      active sync   /dev/sdg
   1     1       8      112        1      active sync   /dev/sdh
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      160        4      active sync   /dev/sdk
root@niederhorn:/home/xbmc# mdadm --examine /dev/sdi
/dev/sdi:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 208886f0:0b0c5d65:d1ecd824:5a220e5e (local to host niederhorn)
  Creation Time : Mon Jul  2 00:08:03 2012
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 7814057984 (7452.07 GiB 8001.60 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Apr 26 11:03:04 2014
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 188e5167 - correct
         Events : 33568

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      160        4      active sync   /dev/sdk

   0     0       8       96        0      active sync   /dev/sdg
   1     1       8      112        1      active sync   /dev/sdh
   2     2       8      128        2      active sync   /dev/sdi
   3     3       8      144        3      active sync   /dev/sdj
   4     4       8      160        4      active sync   /dev/sdk
