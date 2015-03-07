From: Dave Stevens <geek@uniserve.com>
Subject: two raid issues
Date: Sat, 07 Mar 2015 14:42:56 -0800
Message-ID: <20150307144256.17321vlciup2v4kw@webmail.uniserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello the raid list,

I have inherited a server set up by people who are no longer around.  
It worked fine until recently and then after a routine update refused  
to boot. I've got the machine in my office and have been examining the  
problem, or rather problems, I think there are two.

First, the bootable partition on /dev/sda1 won't successfully boot to  
a xen kernel, kernel version is 2.6.18.something-xen. The intent is to  
boot to a raid-10 array of four 750GB drives, each partitioned into a  
small and a large partition as detailed below.

Boot proceeds normally according to on-screen messages until this:

md: md0: raid array is not clean  -- starting background reconstruction
raid10: not enough operational mirrors for md0
md: pers -> () failed

Immediately after these messages is another stating that an attempt  
has been made to kill init, kernel panic and reboot.

I've tried to give these messages verbatim but have no way (I think)  
to reproduce them other than manually.

So at first I looked around, read through the wiki and found advice to  
NOT write anything to the array, which seems reasonable. I looked at a  
live microknoppix distro called runtime live that gave me a command  
shell to run the examine command with the output below:

/dev/sda2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : a9bde90a:77abaef6:6c6fe013:77d6cdaf
   Creation Time : Sun Nov 29 15:33:50 2009
      Raid Level : raid10
   Used Dev Size : 732467456 (698.54 GiB 750.05 GB)
      Array Size : 1464934912 (1397.07 GiB 1500.09 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Wed Feb 18 19:28:22 2015
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 7c76593b - correct
          Events : 32945477

          Layout : near=2
      Chunk Size : 256K

       Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      active sync
    2     2       8       34        2      active sync   /dev/sdc2
    3     3       0        0        3      faulty removed
/dev/sdb2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : a9bde90a:77abaef6:6c6fe013:77d6cdaf
   Creation Time : Sun Nov 29 15:33:50 2009
      Raid Level : raid10
   Used Dev Size : 732467456 (698.54 GiB 750.05 GB)
      Array Size : 1464934912 (1397.07 GiB 1500.09 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sat Nov 22 13:18:12 2014
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 7d850ca4 - correct
          Events : 32945477

          Layout : near=2
      Chunk Size : 256K

       Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       8       18        1      active sync   /dev/sdb2
    2     2       8       34        2      active sync   /dev/sdc2
    3     3       0        0        3      faulty removed
/dev/sdc2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : a9bde90a:77abaef6:6c6fe013:77d6cdaf
   Creation Time : Sun Nov 29 15:33:50 2009
      Raid Level : raid10
   Used Dev Size : 732467456 (698.54 GiB 750.05 GB)
      Array Size : 1464934912 (1397.07 GiB 1500.09 GB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Wed Feb 18 19:30:13 2015
           State : active
  Active Devices : 1
Working Devices : 1
  Failed Devices : 2
   Spare Devices : 0
        Checksum : 7c7659de - correct
          Events : 32945479

          Layout : near=2
      Chunk Size : 256K

       Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8       34        2      active sync   /dev/sdc2
    3     3       0        0        3      faulty removed
/dev/sdd2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : a9bde90a:77abaef6:6c6fe013:77d6cdaf
   Creation Time : Sun Nov 29 15:33:50 2009
      Raid Level : raid10
   Used Dev Size : 732467456 (698.54 GiB 750.05 GB)
      Array Size : 1464934912 (1397.07 GiB 1500.09 GB)
    Raid Devices : 4
   Total Devices : 5
Preferred Minor : 0

     Update Time : Wed Sep  4 07:51:50 2013
           State : active
  Active Devices : 4
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 1
        Checksum : 77c1a3a7 - correct
          Events : 53

          Layout : near=2
      Chunk Size : 256K

       Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       8       18        1      active sync   /dev/sdb2
    2     2       8       34        2      active sync   /dev/sdc2
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      spare   /dev/sde2
/dev/sde2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : a9bde90a:77abaef6:6c6fe013:77d6cdaf
   Creation Time : Sun Nov 29 15:33:50 2009
      Raid Level : raid10
   Used Dev Size : 732467456 (698.54 GiB 750.05 GB)
      Array Size : 1464934912 (1397.07 GiB 1500.09 GB)
    Raid Devices : 4
   Total Devices : 5
Preferred Minor : 0

     Update Time : Sun Sep  8 13:25:42 2013
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 77c775be - correct
          Events : 7934

          Layout : near=2
      Chunk Size : 256K

       Number   Major   Minor   RaidDevice State
this     3       8       66        3      active sync   /dev/sde2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       8       18        1      active sync   /dev/sdb2
    2     2       8       34        2      active sync   /dev/sdc2
    3     3       8       66        3      active sync   /dev/sde2

This makes sense to me as far as it goes but I don't see what to do  
next. As I understand it the four partitions from sda2 to sdd2 would  
form the array with sde as hot spare. It has been my assumption that  
if a drive failed that sde would sync and take over. I don't know if  
this is in fact the case and don't see a path forward. Of course the  
backups are inadequate.

Any and all ideas welcome.

Dave

-- 
"As long as politics is the shadow cast on society by big business,
the attenuation of the shadow will not change the substance."

-- John Dewey





