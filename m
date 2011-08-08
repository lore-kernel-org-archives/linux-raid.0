From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: 20 drive raid-10, CentOS5.5, after reboot assemble fails - all drives
 "non-fresh"
Date: Sun, 07 Aug 2011 19:37:04 -0700
Message-ID: <4E3F4BD0.5060807@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have a 20 drive raid-10 that has been running well for over one year. 
After the most recently system boot the raid will not assemble. 
/var/log/messages shows that all of the drives are "non-fresh". 
Examining the drives show that the raid partitions are present, the 
superblocks have valid data and the Event ticker for the drives are 
equal for the data drives. The spare drives have a different Event 
ticker value.

I am reluctant to try and use the --force switch with assemble until I 
understand the problem better. There is very important data on this 
volume and it is not backed up to my knowledge. I do not know how the 
machine was brought down prior to this system boot.

With all drives being "non-fresh" I can't start a partial array and then 
re-add the remaining drives. I've unraveled some pretty messed up md 
configs and recovered the underlying filesystem but this one has me at a 
loss.

Any advice is greatly appreciated!

--Jeff

Below is the config file and output from mdadm examine commands:

/* Config file */
ARRAY /dev/md3 level=raid10 num-devices=20 
UUID=e17a29e8:ec6bce5c:f13d343c:cfba4dc4
    spares=4   
devices=/dev/sdz1,/dev/sdy1,/dev/sdx1,/dev/sdw1,/dev/sdv1,/dev/sdu1,/dev/sdt1,/dev/sd
s1,/dev/sdr1,/dev/sdq1,/dev/sdp1,/dev/sdo1,/dev/sdn1,/dev/sdm1,/dev/sdl1,/dev/sdk1,/dev/sdj1,/dev/s
di1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/sdc1

/* mdadm -E /dev/sd[cdefghijklmnopqrstuvwxyz]1 | grep Event */
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 90
          Events : 92
          Events : 92
          Events : 92
          Events : 92

/* mdadm -E /dev/sdc1 */
/dev/sdc1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : e17a29e8:ec6bce5c:f13d343c:cfba4dc4
   Creation Time : Fri Sep 24 12:06:37 2010
      Raid Level : raid10
   Used Dev Size : 99924096 (95.30 GiB 102.32 GB)
      Array Size : 999240960 (952.95 GiB 1023.22 GB)
    Raid Devices : 20
   Total Devices : 24
Preferred Minor : 3

     Update Time : Sat Aug  6 05:54:37 2011
           State : clean
  Active Devices : 20
Working Devices : 24
  Failed Devices : 0
   Spare Devices : 4
        Checksum : d8d97049 - correct
          Events : 90

          Layout : near=2
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

    0     0       8       33        0      active sync   /dev/sdc1
    1     1       8       49        1      active sync   /dev/sdd1
    2     2       8       65        2      active sync   /dev/sde1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8       97        4      active sync   /dev/sdg1
    5     5       8      113        5      active sync   /dev/sdh1
    6     6       8      129        6      active sync   /dev/sdi1
    7     7       8      145        7      active sync   /dev/sdj1
    8     8       8      161        8      active sync   /dev/sdk1
    9     9       8      177        9      active sync   /dev/sdl1
   10    10       8      193       10      active sync   /dev/sdm1
   11    11       8      209       11      active sync   /dev/sdn1
   12    12       8      225       12      active sync   /dev/sdo1
   13    13       8      241       13      active sync   /dev/sdp1
   14    14      65        1       14      active sync   /dev/sdq1
   15    15      65       17       15      active sync   /dev/sdr1
   16    16      65       33       16      active sync   /dev/sds1
   17    17      65       49       17      active sync   /dev/sdt1
   18    18      65       65       18      active sync   /dev/sdu1
   19    19      65       81       19      active sync   /dev/sdv1
   20    20      65      145       20      spare   /dev/sdz1
   21    21      65      129       21      spare   /dev/sdy1
   22    22      65      113       22      spare   /dev/sdx1
   23    23      65       97       23      spare   /dev/sdw1

-- 
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson "at" aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845

4905 Morena Boulevard, Suite 1313 - San Diego, CA 92117

