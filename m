From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: grub2/grub-pc install not possible on mdadm
Date: Tue, 28 Feb 2012 10:10:41 +0100
Message-ID: <4F4C9A11.9060302@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

i've configured a raid1 and i'm trying to install grub on it. But it
doesn't work.

~# grub-mkdevicemap -n
~# cat /boot/grub/device.map
(hd0)   /dev/disk/by-id/ata-INTEL_SSDSA2CW160G3_CVPR14530C6J160DGN
(hd1)   /dev/disk/by-id/ata-INTEL_SSDSA2CW160G3_CVPR145101F9160DGN

~# grub-install /dev/md127
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
/usr/sbin/grub-install: line 661: 20158 Segmentation fault
"$grub_setup" ${allow_floppy} ${setup_verbose} ${setup_force}
--directory="${grubdir}" --device-map="${device_map}" "${install_device}"

When i then add /dev/md127 to my device.map i got this:

~# grub-install /dev/md127
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
error: found two disks with the index 0 for RAID md/raidone.
error: superfluous RAID member (2 found).
Installation finished. No error reported.

But the device still does not boot. Installing grub to sda / sdb does
not work either as they do not contain any partition table. What's wrong
here?

Greets
Stefan

Raid details:
~# parted
Model: Linux Software RAID Array (md)
Disk /dev/md127: 160GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system     Name       Flags
 1      1049kB  2097kB  1049kB                  GRUB_BOOT  bios_grub
 2      2097kB  99,6MB  97,5MB  ext2            BOOT
 3      99,6MB  157GB   157GB   xfs             ROOT
 4      157GB   160GB   3056MB  linux-swap(v1)  SWAP

~# mdadm -E /dev/md127
/dev/md127:
   MBR Magic : aa55
Partition[0] :    312579615 sectors at            1 (type ee)

~# mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Tue Feb 28 09:49:58 2012
     Raid Level : raid1
     Array Size : 156289808 (149.05 GiB 160.04 GB)
  Used Dev Size : 156289808 (149.05 GiB 160.04 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue Feb 28 10:01:11 2012
          State : active, resyncing
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

 Rebuild Status : 56% complete

           Name : systembootimage:raidone  (local to host systembootimage)
           UUID : b018eac7:1a44871a:c37f9dca:80e55a6e
         Events : 23

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb

