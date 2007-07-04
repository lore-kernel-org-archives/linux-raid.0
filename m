From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Wed, 4 Jul 2007 18:31:13 +0200
Message-ID: <200707041831.13393.infomails@tronserver.dyndns.org>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <200707032129.10787.infomails@tronserver.dyndns.org> <468B5E22.7080805@dgreaves.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Rt8iGcVd2EAGr9v"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <468B5E22.7080805@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Boundary-00=_Rt8iGcVd2EAGr9v
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 04 July 2007 10:45:22 David Greaves wrote:

> mdadm --examine /dev/hd[abc]3

I'll attach that as a file as it's quite lenghty. It is of the reassembled 
array - if it helps, I can reboot again and provide the same with the 
degraded array that exists after reboot.

> And could you share an "fdisk -l" output

fdisk shows nothing unusual:

Disk /dev/hdc: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdc1               1           4       32098+  83  Linux
/dev/hdc2               5          68      514080   fd  Linux raid autodetect
/dev/hdc3              69        1374    10490445   fd  Linux raid autodetect
/dev/hdc4            1375       24321   184321777+  fd  Linux raid autodetect

yes, the last partition does not extend to the end of the drive due to the 
fact that hda is only a 200GB drive:

Disk /dev/hda: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1           4       32098+  83  Linux
/dev/hda2               5          68      514080   fd  Linux raid autodetect
/dev/hda3              69        1374    10490445   fd  Linux raid autodetect
/dev/hda4            1375       24321   184321777+  fd  Linux raid autodetect

Thanks for the help everyone!
-- 
YT,
Michael

--Boundary-00=_Rt8iGcVd2EAGr9v
Content-Type: text/plain;
  charset="iso-8859-1";
  name="md3-array.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="md3-array.txt"

/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 36bbe21d:f49e8b5d:f504154c:a6f12a51
  Creation Time : Sun Jan 14 21:17:53 2007
     Raid Level : raid5
    Device Size : 10490368 (10.00 GiB 10.74 GB)
     Array Size : 20980736 (20.01 GiB 21.48 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3

    Update Time : Wed Jul  4 18:24:59 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : fe26fd74 - correct
         Events : 0.6996556

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     0       3        3        0      active sync   /dev/hda3

   0     0       3        3        0      active sync   /dev/hda3
   1     1       3       67        1      active sync   /dev/hdb3
   2     2      22        3        2      active sync   /dev/hdc3
/dev/hdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 36bbe21d:f49e8b5d:f504154c:a6f12a51
  Creation Time : Sun Jan 14 21:17:53 2007
     Raid Level : raid5
    Device Size : 10490368 (10.00 GiB 10.74 GB)
     Array Size : 20980736 (20.01 GiB 21.48 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3

    Update Time : Wed Jul  4 18:25:02 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : fe26fdb9 - correct
         Events : 0.6996556

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     1       3       67        1      active sync   /dev/hdb3

   0     0       3        3        0      active sync   /dev/hda3
   1     1       3       67        1      active sync   /dev/hdb3
   2     2      22        3        2      active sync   /dev/hdc3
/dev/hdc3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 36bbe21d:f49e8b5d:f504154c:a6f12a51
  Creation Time : Sun Jan 14 21:17:53 2007
     Raid Level : raid5
    Device Size : 10490368 (10.00 GiB 10.74 GB)
     Array Size : 20980736 (20.01 GiB 21.48 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3

    Update Time : Wed Jul  4 18:25:02 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : fe26fd8e - correct
         Events : 0.6996556

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     2      22        3        2      active sync   /dev/hdc3

   0     0       3        3        0      active sync   /dev/hda3
   1     1       3       67        1      active sync   /dev/hdb3
   2     2      22        3        2      active sync   /dev/hdc3

--Boundary-00=_Rt8iGcVd2EAGr9v--
