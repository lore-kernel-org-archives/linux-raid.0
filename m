From: Hank Barta <hbarta@gmail.com>
Subject: disk failed, operator error: Now can't use RAID
Date: Wed, 13 Jul 2005 19:29:32 -0500
Message-ID: <7500724905071317297f7277a7@mail.gmail.com>
References: <7500724905071314574a13d966@mail.gmail.com>
Reply-To: Hank Barta <hbarta@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7500724905071314574a13d966@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I experienced a disk failure on a raid5 array that had one 6 disks
including one spare. For reasons I couldn't determine, the spare was
not used automatically. I added the spare in using:
   mdadm -add /dev/md0 /dev/sda1
And the raid started rebuilding using the spare drive.

Not satisfied ( ;) ) I tried to remove the failed drive (/dev/hdg1)
using the command
   mdadm /dev/md0 -r /dev/sdg1

Then I realized that I had meant to type /dev/hdg1 and repeated the
command accordingly. My raid originally consisted of /dev/sd[a|b|c|d]1
and /dev/hd[e|g]1 and /dev/hde1 was the spare disk. Looking at the
status now, it appeared that there was a problem with /dev/sda1. Still
not satisfied, I decided it would be a good idea to reboot the system
and when I did, the raid did not come up.

I've fiddled some more and still not gotten the raid to work. I have
added /dev/sda1 back, but the device information in the other drives
does not seem to reflect it. I have run cfdisk on all devices to
verify that the system sees them and that seems to be the case.
Examining drive /dev/sda1 I get:
oak:~# mdadm -Q --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a7cc80af:206de849:dd30336a:6ea23e69
  Creation Time : Sun Dec 26 21:51:39 2004
     Raid Level : raid5
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Jul  9 11:27:33 2005
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 4da3ec1f - correct
         Events : 0.1271893

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/.static/dev/sda1

   0     0       8        1        0      active sync   /dev/.static/dev/sda1
   1     1       8       17        1      active sync   /dev/.static/dev/sdb1
   2     2       8       33        2      active sync   /dev/.static/dev/sdc1
   3     3       8       49        3      active sync   /dev/.static/dev/sdd1
   4     4       0        0        4      faulty removed
   5     5      33        1        5      spare   /dev/.static/dev/hde1
oak:~#

and examining /dev/sdb1 I see:
oak:~# mdadm -Q --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a7cc80af:206de849:dd30336a:6ea23e69
  Creation Time : Sun Dec 26 21:51:39 2004
     Raid Level : raid5
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Jul  9 12:22:25 2005
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 4dd319d4 - correct
         Events : 0.2816178

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/.static/dev/sdb1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/.static/dev/sdb1
   2     2       8       33        2      active sync   /dev/.static/dev/sdc1
   3     3       8       49        3      active sync   /dev/.static/dev/sdd1
   4     4       0        0        4      faulty removed
   5     5      33        1        4      spare   /dev/.static/dev/hde1
oak:~#

So it seems like /dev/sdb1 (and the other raid devices) does not list /dev/sda1.

Other "interesting files are:
oak:~# cat /etc/mdadm/mdadm.conf
DEVICE /dev/hd*[0-9] /dev/sd*[0-9]
ARRAY /dev/md0 level=raid5 num-devices=5
UUID=a7cc80af:206de849:dd30336a:6ea23e69
   devices=/dev/hde1,/dev/sdd1,/dev/sdc1,/dev/sdb1,/dev/sda1
oak:~# cat /proc/mdstat
Personalities : [raid5]
md0 : inactive sda1[0] sdb1[1] hde1[5] sdd1[3] sdc1[2]
      976791680 blocks
unused devices: <none>
oak:~#

If I try to run the raid, I get:

oak:/var/log# mdadm -R /dev/md0
mdadm: failed to run array /dev/md0: Invalid argument
oak:/var/log#

In the log I filJul 13 16:48:54 localhost kernel: raid5: device sdb1
operational as raid disk 1
Jul 13 16:48:54 localhost kernel: raid5: device sdd1 operational as raid disk 3
Jul 13 16:48:54 localhost kernel: raid5: device sdc1 operational as raid disk 2
Jul 13 16:48:54 localhost kernel: RAID5 conf printout:
Jul 13 16:48:54 localhost kernel:  --- rd:5 wd:3 fd:2
Jul 13 16:48:54 localhost kernel:  disk 0, o:1, dev:sda1
Jul 13 16:48:54 localhost kernel:  disk 1, o:1, dev:sdb1
Jul 13 16:48:54 localhost kernel:  disk 2, o:1, dev:sdc1
Jul 13 16:48:54 localhost kernel:  disk 3, o:1, dev:sdd1

Elsewhere in the log I find:
Jul 13 13:30:16 localhost kernel:  disk 2, o:1, dev:sdc1
Jul 13 13:30:16 localhost kernel:  disk 3, o:1, dev:sdd1
Jul 13 13:34:03 localhost kernel: md: error, md_import_device() returned -16
Jul 13 13:35:00 localhost kernel: md: error, md_import_device() returned -16
Jul 13 13:36:21 localhost kernel: raid5: device sdb1 operational as raid disk 1
Jul 13 13:36:21 localhost kernel: raid5: device sdd1 operational as raid disk 3
Jul 13 13:36:21 localhost kernel: raid5: device sdc1 operational as raid disk 2

I would very much appreciate suggestions on how to get the raid running again.

I have a replacement drive, but don't want to put it in until I get
this issue resolved.

I'm running Debian testing (386) with kernel 2.6.8-1-386 and mdadm
tools 1.9.0-4.1.

thanks,
hank

--
Beautiful Sunny Winfield, Illinois
