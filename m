From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Recovering raid6 with 3 of 12 disks
Date: Wed, 14 Mar 2012 13:29:05 -0500
Message-ID: <4F60E371.20609@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks to mvsas not hanlding drives in standby (spun down) well, 9 of my
drives got kicked out of the array. Fortunately, the logical volume on
that array was not mounted so the data on the array should be fine.

Needless to say, I can't assemble the array with only 3 disks. My best
understanding is that I need to re-create the array with --assume-clean
and that I need to specify the drives in their original order (and not
use any shell globbing like /dev/sd[k-r]).

Q1: The original metadata was 0.90. I've read that it would be safe to
re-create the array with 1.0 metadata because the superblocks are stored
at the same location and are smaller than 0.90 superblocks. Please confirm.

Q2: Given the output of mdadm -E the tail of this e-mail, would the
command below be correct?

    mdadm --assemble /dev/md2 --assume-clean --level=6 --chunk=128
--raid-devices=12 --metadata=1.0 /dev/sdn2 /dev/sdk2 /dev/sdl2 /dev/sdm2
/dev/sdy1 /dev/sdp2 /dev/sdo2 /dev/sdr2 /dev/sdq2 /dev/sdw1 /dev/sdx1
/dev/sdz1

Q3: To verify that I have the drives in order I should be able to run a
'check' and watch the missmatch count. If the count is substantially
non-zero then I have the drives in the wrong order. Would it be safe to
'try again' until I get the right combo?

Thank you for your attention and any assistance you can offer.

--Larkin

/dev/sdw1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 2

    Update Time : Wed Mar 14 03:16:48 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 8
  Spare Devices : 0
       Checksum : bdaa1605 - correct
         Events : 1647040

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     9      65      113        9      active sync   /dev/sdx1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdx1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 2

    Update Time : Wed Mar 14 03:16:48 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 8
  Spare Devices : 0
       Checksum : bdaa1617 - correct
         Events : 1647040

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this    10      65      129       10      active sync   /dev/sdy1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdy1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c7df - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4      65      145        4      active sync   /dev/sdz1

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdz1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 2

    Update Time : Wed Mar 14 03:16:48 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 8
  Spare Devices : 0
       Checksum : bdaa15f9 - correct
         Events : 1647040

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this    11      65       97       11      active sync   /dev/sdw1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
   7     7       0        0        7      faulty removed
   8     8       0        0        8      faulty removed
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdk2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c7f1 - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8      226        1      active sync   /dev/sdo2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdl2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c803 - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8      242        2      active sync   /dev/sdp2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdm2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c74e - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3      65        2        3      active sync   /dev/sdq2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdn2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c758 - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0      65       18        0      active sync   /dev/sdr2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdo2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c7bb - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     6       8      162        6      active sync   /dev/sdk2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdp2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c7c9 - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     5       8      178        5      active sync   /dev/sdl2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdq2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c7df - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     8       8      194        8      active sync   /dev/sdm2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
/dev/sdr2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 08b30a7c:151f719c:e2349310:51678405
  Creation Time : Fri May  7 21:44:25 2010
     Raid Level : raid6
  Used Dev Size : 664191232 (633.42 GiB 680.13 GB)
     Array Size : 6641912320 (6334.22 GiB 6801.32 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 2

    Update Time : Tue Mar 13 21:46:30 2012
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bda9c7ed - correct
         Events : 1647037

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     7       8      210        7      active sync   /dev/sdn2

   0     0      65       18        0      active sync   /dev/sdr2
   1     1       8      226        1      active sync   /dev/sdo2
   2     2       8      242        2      active sync   /dev/sdp2
   3     3      65        2        3      active sync   /dev/sdq2
   4     4      65      145        4      active sync   /dev/sdz1
   5     5       8      178        5      active sync   /dev/sdl2
   6     6       8      162        6      active sync   /dev/sdk2
   7     7       8      210        7      active sync   /dev/sdn2
   8     8       8      194        8      active sync   /dev/sdm2
   9     9      65      113        9      active sync   /dev/sdx1
  10    10      65      129       10      active sync   /dev/sdy1
  11    11      65       97       11      active sync   /dev/sdw1
