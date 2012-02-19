From: jlcenter@comcast.net
Subject: Install grub2 to /dev/md126 fails, revisited
Date: Sun, 19 Feb 2012 04:31:16 +0000 (UTC)
Message-ID: <532076747.1058788.1329625876453.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <1751918581.1056981.1329617801303.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1751918581.1056981.1329617801303.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was able to eventually to create the imsm raid1 array (/dev/md/V1) using whole disks (sdc & sdd), then partition the array itself using gdisk.  I reinstalled Ubuntu 11.10 on a btrfs-formatted partition, which failed again at the last step when the installer tried to install grub.  I was able to install grub manually by chrooting the root partition (partition 3) & adding a device map.  But, to get it to boot, I had to also add /etc/group for mdadm.conf in the initramfs & add the raid & mdraid1x modules to grub.conf.  (I also installed an mdadm post-3.2.3 snapshot because the one with Ubuntu 11.10 was v3.1.4 & I saw a number of imsm patches were added to 3.2.3.)

Now it's booted, but it appears to be in a strange state.  The imsm container activated, but the array didn't assemble.  Instead, it booted off one of the drives (sdd3).  I ran mdadm -Asv by hand & got the following:

# mdadm -Asv
mdadm: looking for devices for further assembly
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/md127 is a container, but we are looking for components
mdadm: looking for devices for /dev/md/V1
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: looking in container /dev/md127
mdadm: found match on member /md127/0 in /dev/md127
mdadm: Started /dev/md/V1 with 1 device
mdadm: looking for devices for further assembly
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/md127 is a container, but we are looking for components

# cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md126 : active raid1 sdc[0]
      976758784 blocks super external:/md127/0 [2/1] [U_]
      
md127 : inactive sdc[0](S)
      3153 blocks super external:imsm

# ls -l /dev/md*
brw-rw---- 1 root disk   9, 126 2012-02-18 16:41 /dev/md126
brw-rw---- 1 root disk 259,   0 2012-02-18 16:41 /dev/md126p1
brw-rw---- 1 root disk 259,   1 2012-02-18 16:41 /dev/md126p2
brw-rw---- 1 root disk 259,   2 2012-02-18 16:41 /dev/md126p3
brw-rw---- 1 root disk 259,   3 2012-02-18 16:41 /dev/md126p4
brw-rw---- 1 root disk 259,   4 2012-02-18 16:41 /dev/md126p5
brw-rw---- 1 root disk   9, 127 2012-02-18 16:33 /dev/md127

/dev/md:
total 0
lrwxrwxrwx 1 root root  8 2012-02-18 16:33 imsm0 -> ../md127
lrwxrwxrwx 1 root root  8 2012-02-18 16:41 V1 -> ../md126
lrwxrwxrwx 1 root root 10 2012-02-18 16:41 V1p1 -> ../md126p1
lrwxrwxrwx 1 root root 10 2012-02-18 16:41 V1p2 -> ../md126p2
lrwxrwxrwx 1 root root 10 2012-02-18 16:41 V1p3 -> ../md126p3
lrwxrwxrwx 1 root root 10 2012-02-18 16:41 V1p4 -> ../md126p4
lrwxrwxrwx 1 root root 10 2012-02-18 16:41 V1p5 -> ../md126p5

# mdadm --detail /dev/md126
/dev/md126:
      Container : /dev/md/imsm0, member 0
     Raid Level : raid1
     Array Size : 976758784 (931.51 GiB 1000.20 GB)
  Used Dev Size : 976759424 (931.51 GiB 1000.20 GB)
   Raid Devices : 2
  Total Devices : 1

          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


           UUID : ef4af6fc:b0115ffa:97718fcf:086edcb3
    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       0        0        1      removed


I expected the array to be in a degraded state, but what I didn't expect was what happened when I mounted /dev/md/V1p3.  I was going to change the /etc/default/mdadm VERBOSE setting to true on both the boot device (sdd3) & the V1p3 array which should only have /dev/sdc3, then change BOOT_DEGRADED=false to true.  I made the change to the first setting on the boot device, but when I went to change it on the array, I found it was already changed.  I then checked the /etc/initramfs-tools/conf.d/mdadm setting, saw that both were false & changed the one on the array to true.  The BOOT_DEGRADED setting was now true on the boot device!

So, I'm puzzled, to say the least.  If I understand this correctly, it appears the array is some what assembled, but is in an incomplete state.  I'm not sure where to go from here to fix this.  Any help would be greatly appreciated.  (I've included some additional info below on my configuration.)

Thanks.

    -John




/boot/grub/device.map:
(hd0)	/dev/disk/by-id/ata-Hitachi_HDS721010CLA332_JP2921HQ0D1AYA
(hd1)	/dev/disk/by-id/ata-Hitachi_HDS721010CLA332_JP2921HQ0K0J3A
(hd2)	/dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900458
(hd3)	/dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900448
(md126)	/dev/disk/by-id/md-uuid-ef4af6fc:b0115ffa:97718fcf:086edcb3

/etc/mdadm/mdadm.conf:
DEVICE containers
DEVICE /dev/sd[cd]
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY metadata=imsm UUID=f2c4646a:f34fb336:f0814af3:161e6117
ARRAY /dev/md/V1 container=f2c4646a:f34fb336:f0814af3:161e6117 member=0 UUID=ef4af6fc:b0115ffa:97718fcf:086edcb3

# blkid
/dev/zram0: UUID="cbb031d1-3c39-4d35-af37-0d9667ab5702" TYPE="swap" 
/dev/sdc3: UUID="6cda127a-2aa5-4602-8a35-a7e74ff23524" UUID_SUB="dbd0fffd-61c8-4dde-91e3-60f433809df0" TYPE="btrfs" 
/dev/sdc4: UUID="57ce773e-b4b5-4483-b444-b337e507cc19" TYPE="swap" 
/dev/sdc5: UUID="0e91873c-432d-441b-95ac-bb6085dccab0" UUID_SUB="727d4527-4c1b-4b6c-899d-50ff481e4a63" TYPE="btrfs" 
/dev/sdd3: UUID="6cda127a-2aa5-4602-8a35-a7e74ff23524" UUID_SUB="dbd0fffd-61c8-4dde-91e3-60f433809df0" TYPE="btrfs" 
/dev/sdd4: UUID="57ce773e-b4b5-4483-b444-b337e507cc19" TYPE="swap" 
/dev/sdd5: UUID="0e91873c-432d-441b-95ac-bb6085dccab0" UUID_SUB="727d4527-4c1b-4b6c-899d-50ff481e4a63" TYPE="btrfs" 

/etc/fstab:
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    nodev,noexec,nosuid 0       0
# / was on /dev/md126p3 during installation
UUID=6cda127a-2aa5-4602-8a35-a7e74ff23524 /               btrfs   defaults,subvol=@ 0       1
# /home was on /dev/md126p3 during installation
UUID=6cda127a-2aa5-4602-8a35-a7e74ff23524 /home           btrfs   defaults,subvol=@home 0       2
# /opt was on /dev/md126p5 during installation
UUID=0e91873c-432d-441b-95ac-bb6085dccab0 /opt            btrfs   defaults        0       2
# swap was on /dev/md126p4 during installation
UUID=57ce773e-b4b5-4483-b444-b337e507cc19 none            swap    sw              0       0

# ls -l /dev/disk/by-id/*
lrwxrwxrwx 1 root root  9 2012-02-18 16:33 /dev/disk/by-id/ata-HL-DT-ST_BD-RE_WH10LS30_K95A8C51822 -> ../../sr0
lrwxrwxrwx 1 root root  9 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900448 -> ../../sdd
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900448-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900448-part2 -> ../../sdd2
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900448-part3 -> ../../sdd3
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900448-part4 -> ../../sdd4
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900448-part5 -> ../../sdd5
lrwxrwxrwx 1 root root  9 2012-02-18 23:05 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900458 -> ../../sdc
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900458-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900458-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900458-part3 -> ../../sdc3
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900458-part4 -> ../../sdc4
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/ata-SAMSUNG_HE103SJ_S2JBJ90Z900458-part5 -> ../../sdc5
lrwxrwxrwx 1 root root 11 2012-02-18 16:41 /dev/disk/by-id/md-uuid-ef4af6fc:b0115ffa:97718fcf:086edcb3 -> ../../md126
lrwxrwxrwx 1 root root 13 2012-02-18 16:41 /dev/disk/by-id/md-uuid-ef4af6fc:b0115ffa:97718fcf:086edcb3-part1 -> ../../md126p1
lrwxrwxrwx 1 root root 13 2012-02-18 16:41 /dev/disk/by-id/md-uuid-ef4af6fc:b0115ffa:97718fcf:086edcb3-part2 -> ../../md126p2
lrwxrwxrwx 1 root root 13 2012-02-18 16:41 /dev/disk/by-id/md-uuid-ef4af6fc:b0115ffa:97718fcf:086edcb3-part3 -> ../../md126p3
lrwxrwxrwx 1 root root 13 2012-02-18 16:41 /dev/disk/by-id/md-uuid-ef4af6fc:b0115ffa:97718fcf:086edcb3-part4 -> ../../md126p4
lrwxrwxrwx 1 root root 13 2012-02-18 16:41 /dev/disk/by-id/md-uuid-ef4af6fc:b0115ffa:97718fcf:086edcb3-part5 -> ../../md126p5
lrwxrwxrwx 1 root root 11 2012-02-18 16:33 /dev/disk/by-id/md-uuid-f2c4646a:f34fb336:f0814af3:161e6117 -> ../../md127
lrwxrwxrwx 1 root root  9 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900448 -> ../../sdd
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900448-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900448-part2 -> ../../sdd2
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900448-part3 -> ../../sdd3
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900448-part4 -> ../../sdd4
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900448-part5 -> ../../sdd5
lrwxrwxrwx 1 root root  9 2012-02-18 23:05 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900458 -> ../../sdc
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900458-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900458-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900458-part3 -> ../../sdc3
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900458-part4 -> ../../sdc4
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/scsi-SATA_SAMSUNG_HE103SJS2JBJ90Z900458-part5 -> ../../sdc5
lrwxrwxrwx 1 root root  9 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d6f9 -> ../../sdd
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d6f9-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d6f9-part2 -> ../../sdd2
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d6f9-part3 -> ../../sdd3
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d6f9-part4 -> ../../sdd4
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d6f9-part5 -> ../../sdd5
lrwxrwxrwx 1 root root  9 2012-02-18 23:05 /dev/disk/by-id/wwn-0x50024e920375d703 -> ../../sdc
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d703-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d703-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d703-part3 -> ../../sdc3
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d703-part4 -> ../../sdc4
lrwxrwxrwx 1 root root 10 2012-02-18 16:33 /dev/disk/by-id/wwn-0x50024e920375d703-part5 -> ../../sdc5
