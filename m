From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Wed, 27 Jun 2012 13:34:48 +0200
Message-ID: <4FEAEFD8.4070605@xunil.at>
References: <4FE9BFC1.5070607@xunil.at> <4FEADDCC.2070905@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040204010701000604010601"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEADDCC.2070905@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040204010701000604010601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 27.06.2012 12:17, schrieb Stefan G. Weichinger:
> Am 26.06.2012 15:57, schrieb Stefan G. Weichinger:
> 
>> I would really really like to avoid to rebuild that array ...
>>
>> Thanks in advance, looking forward to your hints, Stefan!
> 
> Noone any thoughts on this?
> Correction: thoughts alone wouldn't write a posting ;-)

more infos in attachment (will it get, as requested off-list.

thanks ...



--------------040204010701000604010601
Content-Type: text/plain; charset=UTF-8;
 name="report"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="report"

/dev/sda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 938aa1a7:a216603a:d46d31fa:4faee42a
  Creation Time : Thu Aug 11 21:19:43 2011
     Raid Level : raid6
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Nov  4 00:13:42 2011
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 143cd05d - correct
         Events : 0.248094

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 938aa1a7:a216603a:d46d31fa:4faee42a
  Creation Time : Thu Aug 11 21:19:43 2011
     Raid Level : raid6
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Nov  4 00:13:42 2011
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 143cd04b - correct
         Events : 0.248094

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
/dev/sdc3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 938aa1a7:a216603a:d46d31fa:4faee42a
  Creation Time : Thu Aug 11 21:19:43 2011
     Raid Level : raid6
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Jun 27 13:32:30 2012
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 15f80804 - correct
         Events : 0.4430040

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       35        2      active sync   /dev/sdc3

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
/dev/sdd3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 938aa1a7:a216603a:d46d31fa:4faee42a
  Creation Time : Thu Aug 11 21:19:43 2011
     Raid Level : raid6
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Jun 27 13:32:30 2012
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 15f80816 - correct
         Events : 0.4430040

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       51        3      active sync   /dev/sdd3

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu Aug 11 21:19:43 2011
     Raid Level : raid6
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jun 27 13:32:30 2012
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : 938aa1a7:a216603a:d46d31fa:4faee42a
         Events : 0.4430040

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       8       35        2      active sync   /dev/sdc3
       3       8       51        3      active sync   /dev/sdd3

--------------040204010701000604010601--
