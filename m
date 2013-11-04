From: Kevin Wilson <kevin@digitalarchitects.co.za>
Subject: Seagate black armour recovery
Date: Mon, 4 Nov 2013 15:51:57 +0200
Message-ID: <CAHwiqHszJWNRZqWuarzJZO8cYqQitUoJ+SeLUco64Po=FA3doQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Morne Botha <bothamb@gmail.com>
List-Id: linux-raid.ids

Good day All,

I have a current problem for which I would love some advice regarding
mdadm and raid superblock information. Suffice to say that we have
been busy for a while with the recovery of a 4 disk raid pack that was
installed in a Seagate Black Armour. It seems from various posts to be
a common issue, but the 4th drive has after numerous power failures
decided to show up as a 4GB drive instead of the 2TB it should be.

Although Seagate will assist with replacement, recovery is not
supported. They suggested transposing the disks into an HP micro
server and using Ubuntu to recover the raid config and backup the
data, however they do not officially support this process.

We have done just that and although the utility seemed to sync the
timestamps and event counts of the first three disks, it will not
assemble the raid as disk 2 says disk1 is faulty and disk three says
disk 1 & 2 are faulty. We tried the --update summaries but the return
message indicated this was not supported on this version of the
superblock information.

My research on the internet has pointed to the following solutions:

1. Hexedit the drive status information in the superblocks and set it
to what we require to assemble

2. Run the create option of mdadm with precisely the original
configuration of the pack to overwrite the superblock information

Our position currently:

4 x SATA Seagate 2Tb Hard drives in RAID 5 configuration from Seagate
Black armour NAS device which seems to be running a version of
Busybox.

RAID set failed after numerous power outages in short succession of
one another. Seagate seems to partition each drive into 4 partitions,
three small partitions for mirrored boot, root and swap, and a raid 5
set from the 4 large partitions. We can still see all 4 partitions on
the first three drives.



We prefer option 2 as hex editing anything seems very complex and the
risk of losing data may be increased.

Mdadm examine scan verbose:(please note we are only interested in /dev/md/3)
ARRAY /dev/md0 level=raid1 num-devices=4
UUID=e5c4f833:10499bfb:f0bc667a:ab5d5655
   devices=/dev/sdb1,/dev/sdc1,/dev/sda1
ARRAY /dev/md1 level=raid1 num-devices=4
UUID=dd1a58c7:b4a1d054:6ac96c1f:9e4e75f3
   devices=/dev/sdb2,/dev/sdc2,/dev/sda2
ARRAY /dev/md0 level=raid1 num-devices=4
UUID=88c4cd7b:2f2c33f9:98147519:0af53b03
   devices=/dev/sdb3,/dev/sdc3,/dev/sda3
ARRAY /dev/md/3 level=raid5 metadata=1.2 num-devices=4
UUID=32dded91:8cfe88ca:765df125:42fef71b name=3
   devices=/dev/sdb4,/dev/sdc4,/dev/sda4

Mdadm examine for each drive:
/dev/sda4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 32dded91:8cfe88ca:765df125:42fef71b
           Name : 3
  Creation Time : Wed Jun 29 18:19:40 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3901415744 (1860.34 GiB 1997.52 GB)
     Array Size : 11704247040 (5581.02 GiB 5992.57 GB)
  Used Dev Size : 3901415680 (1860.34 GiB 1997.52 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bfb2c355:6c62cbca:027b51ae:efa6d0cf

    Update Time : Mon Oct 14 08:22:08 2013
       Checksum : 57bae206 - correct
         Events : 18538

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAA. ('A' == active, '.' == missing)

/dev/sdb4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 32dded91:8cfe88ca:765df125:42fef71b
           Name : 3
  Creation Time : Wed Jun 29 18:19:40 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3901415744 (1860.34 GiB 1997.52 GB)
     Array Size : 11704247040 (5581.02 GiB 5992.57 GB)
  Used Dev Size : 3901415680 (1860.34 GiB 1997.52 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b56364ca:41cc4eef:f1df5dc3:2f8ca60f

    Update Time : Mon Oct 14 08:23:06 2013
       Checksum : 45bf4737 - correct
         Events : 18538

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : .AA. ('A' == active, '.' == missing)

/dev/sdc4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 32dded91:8cfe88ca:765df125:42fef71b
           Name : 3
  Creation Time : Wed Jun 29 18:19:40 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3901415744 (1860.34 GiB 1997.52 GB)
     Array Size : 11704247040 (5581.02 GiB 5992.57 GB)
  Used Dev Size : 3901415680 (1860.34 GiB 1997.52 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 762c0464:cb7baf42:590e39ba:8685f4a8

    Update Time : Mon Oct 14 08:24:13 2013
       Checksum : c2e5e785 - correct
         Events : 18538

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : ..A. ('A' == active, '.' == missing)

/dev/sdd4 is the faulty drive that now shows up as 4GB.

I presume we are looking for the right way to get the Array State
corrected or ignored on the assemble.

regards,

Kevin
