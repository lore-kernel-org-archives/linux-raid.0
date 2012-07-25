From: Scott Johnson <scottej23@gmail.com>
Subject: Does mdadm require udev/sysfs to create imsm RAID1?
Date: Tue, 24 Jul 2012 17:54:08 -0700
Message-ID: <CABxOMqwmk8TBaj9KXz9X12PmFx5mRnUe-xv+DsP5pmqojK3Dng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The question may seem strange but here's the problem I'm trying to solve.

I have setup all the servers in my environment to PXE boot and nfs
mount an older root filesystem that is a bit aged and predates udev
and sysfs.  It just has the /dev/ device tree.

This worked well for installing proprietary PCI highpoint 1720 raid
drivers that aren't included in the kernel.  Then I would write my OS
images to the drives after installing the raid driver.  However, now
my latest hardware comes with the Intel IMSM and I don't need to use
the pci raid anymore if I can get this on-board imsm raid to work.

I built the latest mdadm (3.2.5) and added it to my root filesystem.
The mdadm --examine /dev/sda seems to see that the drives are
configured but mdadm create fails and the mdadm --assemble --scan does
nothing.  I did configure the RAID1 array in the bios.

I'm currently using an older 2.6.30 kernel, but should be new enough
for imsm via mdadm.  If mdadm requires udev and sysfs info then I'll
have to figure out how to include that into my root filesystem.

-bash-3.1# uname -r
2.6.30

-bash-3.1# mdadm -V
mdadm - v3.2.5 - 18th May 2012

-bash-3.1# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
unused devices: <none>

-bash-3.1# mdadm -E /dev/sda
mdadm: /dev/sda is not attached to Intel(R) RAID controller.
mdadm: /dev/sda is not attached to Intel(R) RAID controller.
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.1.00
    Orig Family : 41dddea6
         Family : 41dddea6
     Generation : 00000035
     Attributes : All supported
           UUID : 64fabbb6:c0dfc0df:dc004a9e:620cffc5
       Checksum : 242ff277 correct
    MPB Sectors : 1
          Disks : 2
   RAID Devices : 1

  Disk00 Serial : Z2AFVZJZ
          State : active
             Id : 00020000
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

[Volume0]:
           UUID : 83543199:fdb1493f:0f2af5ef:e2287504
     RAID Level : 1
        Members : 2
          Slots : [UU]
    Failed disk : none
      This Slot : 0
     Array Size : 625137664 (298.09 GiB 320.07 GB)
   Per Dev Size : 625137928 (298.09 GiB 320.07 GB)
  Sector Offset : 0
    Num Stripes : 2441944
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

  Disk01 Serial : Z2AFVZN8
          State : active
             Id : 00030000
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

-bash-3.1# mdadm --assemble --scan
mdadm main: failed to get exclusive lock on mapfile
mdadm: No arrays found in config file or automatically

-bash-3.1# mdadm --create /dev/md/imsm -e imsm -n 2 /dev/sda /dev/sdb
mdadm: /dev/sda is not attached to Intel(R) RAID controller.
mdadm: /dev/sda is not suitable for this array.
mdadm: /dev/sdb is not attached to Intel(R) RAID controller.
mdadm: /dev/sdb is not suitable for this array.

Thanks for any help you can provide.
-Scott
