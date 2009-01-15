From: "Jason Weber" <baboon.imonk@gmail.com>
Subject: raid6 recovery
Date: Thu, 15 Jan 2009 07:24:12 -0800
Message-ID: <3eceea760901150724p28f8e717y2e968ee9d48a0073@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Before I cause to much damage, I really need expert help.

Early this morning, machine locked up and my 4x500Gb raid6 did not
recover on reboot.
A smaller 2x18Gb raid came up as normal.

/var/log/messages has:

Jan 15 01:12:22 wildfire Pid: 6056, comm: mdadm Tainted: P
2.6.19-gentoo-r5 #3

with some codes and a lot of others like it when it went down. And then,

Jan 15 01:16:37 wildfire mdadm: DeviceDisappeared event detected on md
device /dev/md1

I tried simple readds:

# mdadm /dev/md1 --add /dev/sdd /dev/sde
mdadm: cannot get array info for /dev/md1

Eventually I noticed that the drives had a different UUID than mdadm.conf;
one byte had changed.  I have a backup of mdadm.conf so I know that
was the same.

So, I changed mdadm.conf to match the drives and started an assemble

# mdadm --assemble --verbose /dev/md1
mdadm: looking for devices for /dev/md1
mdadm: cannot open device
/dev/disk/by-uuid/d7a08e91-0a49-4e91-91d7-d9d1e9e6cda1: Device or
resource busy
mdadm: /dev/disk/by-uuid/d7a08e91-0a49-4e91-91d7-d9d1e9e6cda1 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdg1
mdadm: /dev/sdg1 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: cannot open device /dev/sdi2: Device or resource busy
mdadm: /dev/sdi2 has wrong uuid.
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has wrong uuid.
mdadm: cannot open device /dev/sdi: Device or resource busy
mdadm: /dev/sdi has wrong uuid.
mdadm: cannot open device /dev/sdh1: Device or resource busy
mdadm: /dev/sdh1 has wrong uuid.
mdadm: cannot open device /dev/sdh: Device or resource busy
mdadm: /dev/sdh has wrong uuid.
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda4: Device or resource busy
mdadm: /dev/sda4 has wrong uuid.
mdadm: cannot open device /dev/sda3: Device or resource busy
mdadm: /dev/sda3 has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdf is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sde is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdd is identified as a member of /dev/md1, slot 3.

which has been sitting there for about four hours, full CPU, and as
far as I can tell not much drive
activity (how can I tell?  they're not very loud relative to the
overall machine noise).

As for "damage" I've done, first of all, one typo added /dev/sdc, once
of md1, to the md0 array
so now it thinks it is 18Gb according to mdadm -E, but hopefully it
was only set to spare so
maybe it didn't get scrambled:

# mdadm -E /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 96a4204f:7b6211e6:34105f4c:9857a351
  Creation Time : Tue May 17 23:03:53 2005
     Raid Level : raid1
  Used Dev Size : 17952512 (17.12 GiB 18.38 GB)
     Array Size : 17952512 (17.12 GiB 18.38 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Jan 15 01:52:42 2009
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 195f64d3 - correct
         Events : 0.39649024


      Number   Major   Minor   RaidDevice State
this     2       8       32        2      spare   /dev/sdc

   0     0       8      113        0      active sync   /dev/sdh1
   1     1       8      129        1      active sync   /dev/sdi1
   2     2       8       32        2      spare   /dev/sdc

Here's the others:

# mdadm -E /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : f92d43a8:5ab3f411:26e606b2:3c378a67
  Creation Time : Sat Oct 13 00:23:51 2007
     Raid Level : raid6
  Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
     Array Size : 976772992 (931.52 GiB 1000.22 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 9223371671782555647

    Update Time : Thu Jan 15 01:12:21 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : dca29b4 - correct
         Events : 0.79926

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       48        3      active sync   /dev/sdd

   0     0       8       64        0      active sync   /dev/sde
   1     1       8       80        1      active sync   /dev/sdf
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd

# mdadm -E /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : f92d43a8:5ab3f411:26e606b2:3c378a67
  Creation Time : Sat Oct 13 00:23:51 2007
     Raid Level : raid6
  Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
     Array Size : 976772992 (931.52 GiB 1000.22 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 9223371671782555647

    Update Time : Thu Jan 15 01:12:21 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : dca29be - correct
         Events : 0.79926

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       64        0      active sync   /dev/sde

   0     0       8       64        0      active sync   /dev/sde
   1     1       8       80        1      active sync   /dev/sdf
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd

# mdadm -E /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : f92d43a8:5ab3f411:26e606b2:3c378a67
  Creation Time : Sat Oct 13 00:23:51 2007
     Raid Level : raid6
  Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
     Array Size : 976772992 (931.52 GiB 1000.22 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 9223371671782555647

    Update Time : Thu Jan 15 01:12:21 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : dca29d0 - correct
         Events : 0.79926

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       80        1      active sync   /dev/sdf

   0     0       8       64        0      active sync   /dev/sde
   1     1       8       80        1      active sync   /dev/sdf
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd

/etc/mdadm.conf:
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md1 level=raid6 num-devices=4
UUID=f92d43a8:5ab3f411:26e606b2:3c378a67
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=96a4204f:7b6211e6:34105f4c:9857a351

# This file was auto-generated on Tue, 11 Mar 2008 00:10:35 -0700
# by mkconf $Id: mkconf 324 2007-05-05 18:49:44Z madduck $

It previously said:
UUID=f92d43a8:5ab3f491:26e606b2:3c378a67

with a ...491.. instead of ...411...

Is mdadm --assemble supposed to take a long time or should it almost
immediately come back
and let me watch /proc/mdstat, which currently just says:

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid1 sdh1[0] sdi1[1]
      17952512 blocks [2/2] [UU]

unused devices: <none>

Also, I did modprobe raid456 manually before the assemble since I
noticed it was only saying raid1.
Maybe it would have been automatic at the right moment anyhow.

Should I just wait for the assemble or is it doing nothing?
Can I recover /dev/sdc as well or is that unimportant since I can
clear it and readd if the other three
(or even two) sync up and become available.

This md1 has been trouble since inception a couple years ago.  I get
corrupt files every week or
so it seems.  My little U320 scsi md0 raid1 has been nearly uneventful
for a much longer time.
Is raid6 less stable or maybe by sata_sil24 card is a bad choice?
Maybe sata doesn't measure
up to scsi.  So please point out any obvious foolishness on my part.

I do have a five day old single non-raid partial backup which is now
the only container of the data.
I'm very nervous about critical loss.  If I absolutely need to start
over, I'd like to get some redundancy
in my data as soon as possible.  Perhaps breaking it into a pair of
raid1 arrays is smarter anyhow.

-- Jason P Weber
