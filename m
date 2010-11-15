From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Suggestion for rebuilding my raids?
Date: Mon, 15 Nov 2010 10:34:22 +0100
Message-ID: <4CE0FE9E.2000009@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Greetings!

Please have a look at the RAIDs in one of my servers.

The story:

Initially it came with 4x500 GB ( /dev/sd[a-d] ).

I started with md1 for boot, a raid5+s md3 for root and a raid5+s md4 as
the one and only physical volume in the LVM volume group "VG01".

Classic stuff ;-)

As usual the server was used and got filled up.

The box has 8 hdd-slots so we bought 4 x 1 TB to add them. But
unfortunately the SATA-controller onboard only has 6 channels!

*sigh*

So I was only able to add 2x1TB at first.

At this point I should have planned better and maybe start off with a
degraded RAID6 or so :-(

I created /dev/md5 as a mirror only ....

Now lately I added another SATA-controller and /dev/sdg and sdh, built a
mirror /dev/md6 and added this as the second PV to the VG "pipe"

"pipe" now consists of 2 mirrors, each containing 2x1TB ...

As you may understand I am not so happy with this.

I would like to rebuild things now, heading for RAID6 or so, as there is
quite important data stored on this box.

I perfectly know that I should have planned things better, YES!

-

So what I now have is 4x ~472 GB in the partitions /dev/sd[a-d]4 and 4x
~980 GB in the partitions /dev/sd[e-h]1 ...

For sure we now have data on the box ...

Any good suggestions how to proceed?

Should I head for building a RAID6 out of [a-d] and [e-h] each ... ?

What would be the recommended setup here in your opinion?

Thanks for any thoughts on this, Stefan


----------> info from here

mdadm 3.1.4 available

Currently kernel 2.6.27, but 2.6.34 ready to boot (I have to attach that
KVM before I do that).


# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md6 : active raid1 sdh1[1] sdg1[0]
      976759936 blocks [2/2] [UU]

md1 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

md4 : active raid5 sdd4[2] sdc4[3](S) sdb4[1] sda4[0]
      944300544 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md5 : active raid1 sdf1[1] sde1[0]
      976759936 blocks [2/2] [UU]

md3 : active raid5 sdd3[3](S) sdc3[2] sdb3[1] sda3[0]
      31262336 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]


# pvdisplay
  --- Physical volume ---
  PV Name               /dev/md5
  VG Name               pipe
  PV Size               931.51 GiB / not usable 3.12 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              238466
  Free PE               0
  Allocated PE          238466
  PV UUID               OWAXnx-Lhxo-91kY-x7Pq-8riP-OMga-qP09dn

  --- Physical volume ---
  PV Name               /dev/md6
  VG Name               pipe
  PV Size               931.51 GiB / not usable 3.12 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              238466
  Free PE               123652
  Allocated PE          114814
  PV UUID               yqpOBG-PSP1-kjKg-hK9l-xOWA-Gku6-Flxqo0

  --- Physical volume ---
  PV Name               /dev/md4
  VG Name               VG01
  PV Size               900.56 GiB / not usable 512.00 KiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              230542
  Free PE               5120
  Allocated PE          225422
  PV UUID               7rjtme-VisO-n2FH-fLH5-WGCs-KqD1-B7A6eu



# fdisk -l /dev/sd?

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          13      104391   fd  Linux raid
autodetect
/dev/sda2              14          75      498015   82  Linux swap /
Solaris
/dev/sda3              76        2021    15631245   fd  Linux raid
autodetect
/dev/sda4            2022       60801   472150350   fd  Linux raid
autodetect

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1          13      104391   fd  Linux raid
autodetect
/dev/sdb2              14          75      498015   82  Linux swap /
Solaris
/dev/sdb3              76        2021    15631245   fd  Linux raid
autodetect
/dev/sdb4            2022       60801   472150350   fd  Linux raid
autodetect

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1          13      104391   fd  Linux raid
autodetect
/dev/sdc2              14          75      498015   82  Linux swap /
Solaris
/dev/sdc3              76        2021    15631245   fd  Linux raid
autodetect
/dev/sdc4            2022       60801   472150350   fd  Linux raid
autodetect

Disk /dev/sdd: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1          13      104391   fd  Linux raid
autodetect
/dev/sdd2              14          75      498015   82  Linux swap /
Solaris
/dev/sdd3              76        2021    15631245   fd  Linux raid
autodetect
/dev/sdd4            2022       60801   472150350   fd  Linux raid
autodetect

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x1188d9cb

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xa2f780d9

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdg: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x7e846a1d

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1               1      121601   976760001   fd  Linux raid
autodetect

Disk /dev/sdh: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x264cbf63

   Device Boot      Start         End      Blocks   Id  System
/dev/sdh1               1      121601   976760001   fd  Linux raid
autodetect
