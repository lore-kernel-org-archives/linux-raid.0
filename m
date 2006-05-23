From: Bruno Seoane <stickman@ole.com>
Subject: raid5 disaster
Date: Tue, 23 May 2006 22:45:27 +0200
Message-ID: <200605232245.27660.stickman@ole.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a working raid5 setup with 5 SATA disks, 3 attached to a Promise TX4 and 
2 more attached to the mainboard controller.

It has been working flawlessly for a long time, but I had to add a sat card to 
the machine so I also upgraded to 2.6.16.16

I don't know if there was some problem with that kernel, but CPU usage was 
almost 100% when writing to the raid, so I decided to go back to me old and 
trusty 2.6.15.1, but when shutting down the system it wouldn't finish so I 
had to power it down.

On the next reboot I saw this:

md: Autodetecting RAID arrays.
md: invalid superblock checksum on sdc1
md: sdc1 has invalid sb, not importing!
md: invalid superblock checksum on sde1
md: sde1 has invalid sb, not importing!
md: autorun ...
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: bind<sdd1>
md: running: <sdd1><sdb1><sda1>
raid5: device sdd1 operational as raid disk 1
raid5: device sdb1 operational as raid disk 0
raid5: device sda1 operational as raid disk 4
raid5: not enough operational devices for md0 (2/5 failed)
RAID5 conf printout:
 --- rd:5 wd:3 fd:2
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdd1
 disk 4, o:1, dev:sda1
raid5: failed to run raid set md0


So sdc1 and sde1 have an invalid superblock (I assume this was because there 
was some I/O activity when I switched it down).

Now, as you suppose, I'd like to access my data.

This is what I get from the faulty (and one of the working disks) with the 
'examine' parameter:

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 8e47d871:51e2f219:52b05fbf:44206fa0
  Creation Time : Sat Jan 21 00:20:33 2006
     Raid Level : raid5
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Tue May 23 19:06:48 2006
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ba51512f - correct
         Events : 0.3551144

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8        1        4      active sync   /dev/sda1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8        1        4      active sync   /dev/sda1


/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 8e47d871:00000000:00000000:260f0100
  Creation Time : Sat Jan 21 00:20:33 2006
     Raid Level : raid5
   Raid Devices : 16777216
  Total Devices : 0
Preferred Minor : 5058

    Update Time : Fri Dec 13 20:45:52 1901
          State : active
 Active Devices : -2147483648
Working Devices : -2147483648
 Failed Devices : -2147483648
  Spare Devices : -2147483648
       Checksum : 80000000 - expected 2255ae19
         Events : -2147483648.-2147483648
Floating point exception



/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 8e47d871:00000000:00000000:260f0100
  Creation Time : Sat Jan 21 00:20:33 2006
     Raid Level : raid5
   Raid Devices : 16777216
  Total Devices : 0
Preferred Minor : 5058

    Update Time : Fri Dec 13 20:45:52 1901
          State : active
 Active Devices : -2147483648
Working Devices : -2147483648
 Failed Devices : -2147483648
  Spare Devices : -2147483648
       Checksum : 80000000 - expected 2255ae37
         Events : -2147483648.-2147483648


FS on the raid is XFS.

I've been crawling through the list and noticed I could create the array again 
and data would still be there and I should be able to mount the fs. Am I 
correct?

Is this the only solution?

I've assembled this command for mdadm:

mdadm -C -l5 -n5 
-c=128 /dev/md0 /dev/sdb1 /dev/sdd1 /dev/sde1 /dev/sdc1 /dev/sda1

I took the devices order from the mdadm output on a working device. Is this 
the way it's supposed to be the command assembled?

Is there anything alse I should consider or any other valid solution to gain 
access to my data?

Thanks,


-- 
Bruno Seoane
