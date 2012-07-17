From: Brian Downing <bdowning@lavos.net>
Subject: v3.5 regression in IMSM support
Date: Tue, 17 Jul 2012 04:05:26 -0500
Message-ID: <20120717090526.GF23042@glaurung.lavos.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've noticed a regression in IMSM metadata support in v3.5-rc kernels.
I have a two-disk laptop that I run an IMSM RAID0 on so I can dual-boot
Windows:

:; sudo mdadm --detail-platform
       Platform : Intel(R) Matrix Storage Manager
        Version : 8.0.0.1039
    RAID Levels : raid0 raid1
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : not supported
      2TB disks : not supported
      Max Disks : 4
    Max Volumes : 2 per array, 2 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)

:; cat /proc/mdstat 
Personalities : [raid0] 
md126 : active raid0 sda[1] sdb[0]
      625137664 blocks super external:/md127/0 128k chunks
      
md127 : inactive sdb[1](S) sda[0](S)
      4520 blocks super external:imsm
       
unused devices: <none>

What's happened in v3.5 is that it's no longer possible to incrementally
assemble this array, as for example udev rules do.  This breaks my
initramfs, and I wind up at a recovery prompt.  'mdadm --assemble --scan'
is still able to bring up the array enough to get lvm going, though I
think it's still a little messed up; note the 0 length metadata partition
reported here:

:; cat mdstat.bad 
Personalities : [raid0] 
md126 : active raid0 sda[1] sdb[0]
      625137664 blocks super external:/md127/0 128k chunks
      
md127 : inactive sdb[1](S) sda[0](S)
      0 blocks super external:imsm
       
unused devices: <none>

Manually running the incremental mdadm looks like this:

# mdadm -I /dev/sda
[   22.514509] md: bind<sda>
mdadm: failed to add /dev/sda to /dev/md/imsm0: Invalid argument.
[   22.516151] md: md127 stopped.
[   22.516234] md: unbind<sda>
[   22.536399] md: export_rdev(sda)

The same "mdadm: ... Invalid argument." messages print out from the
--assemble --scan, yet the array comes up (enough to mount, anyway).

I bisected down to this commit:

    commit c6563a8c38fde3c1c7fc925a10bde3ca20799301
    Author: NeilBrown <neilb@suse.de>
    Date:   Mon May 21 09:27:00 2012 +1000

        md: add possibility to change data-offset for devices.

Heres the relevant dmesg sections for the good and bad case.  Please let
me know if there's anything else I can provide to help fix this.

Good dmesg:

[    0.000000] Linux version 3.4.0-rc5-ARCH-00006-g2c810cd (bdowning@saphira) (gcc version 4.7.1 (GCC) ) #16 SMP PREEMPT Tue Jul 17 03:19:00 CDT 2012
[    0.000000] Command line: root=UUID=89ccd806-db3e-49d2-a338-5efb0c5829dc ro initrd=../initramfs-linux-git.img BOOT_IMAGE=../vmlinuz-linux-git 
...
[    2.311681] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 
GiB)
[    2.311686] sd 4:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 
GiB)
[    2.311775] sd 4:0:0:0: [sdb] Write Protect is off
[    2.311777] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.311814] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.312150] sd 0:0:0:0: [sda] Write Protect is off
[    2.312232] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.312269] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.390450]  sda: sda1 sda2 < >
[    2.391245] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.407136]  sdb: sdb1 < > sdb2
[    2.407629] sd 4:0:0:0: [sdb] Attached SCSI disk
[    2.449061] md: bind<sda>
[    2.516626] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.516736] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.517189] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.655174] md: bind<sdb>
[    2.662552] md: bind<sdb>
[    2.662919] md: bind<sda>
[    2.664551] md: raid0 personality registered for level 0
[    2.664915] bio: create slab <bio-1> at 1
[    2.665005] md/raid0:md126: md_size is 1250275328 sectors.
[    2.665086] md: RAID0 configuration for md126 - 1 zone
[    2.665165] md: zone0=[sda/sdb]
[    2.665419]       zone-offset=         0KB, device-offset=         0KB, size= 625137920KB
[    2.665515] 
[    2.665632] md126: detected capacity change from 0 to 640140967936
[    2.800386]  md126: p1 p2 < p5 p6 >

Bad dmesg:
[    0.000000] Linux version 3.4.0-rc5-ARCH-00007-gc6563a8 (bdowning@saphira) (gcc version 4.7.1 (GCC) ) #15 SMP PREEMPT Tue Jul 17 03:12:25 CDT 2012
[    0.000000] Command line: root=UUID=89ccd806-db3e-49d2-a338-5efb0c5829dc ro initrd=../initramfs-linux-git.img BOOT_IMAGE=../vmlinuz-linux-git 
...
[    2.307932] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 
GiB)
[    2.308116] sd 0:0:0:0: [sda] Write Protect is off
[    2.308197] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.308234] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, does
n't support DPO or FUA
[    2.308869] sd 4:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 
GiB)
[    2.309063] sd 4:0:0:0: [sdb] Write Protect is off
[    2.309144] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.309182] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, does
n't support DPO or FUA
[    2.390455]  sda: sda1 sda2 < >
[    2.391122] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.400433]  sdb: sdb1 < > sdb2
[    2.400913] sd 4:0:0:0: [sdb] Attached SCSI disk
[    2.465423] md: bind<sdb>
[    2.465723] md: md127 stopped.
[    2.465810] md: unbind<sdb>
[    2.466955] md: export_rdev(sdb)
[    2.472482] md: bind<sda>
[    2.472678] md: md127 stopped.
[    2.472759] md: unbind<sda>
[    2.474539] mdadm: sending ioctl 800c0910 to a partition!
[    2.474620] mdadm: sending ioctl 800c0910 to a partition!
[    2.474796] mdadm: sending ioctl 1261 to a partition!
[    2.474875] mdadm: sending ioctl 1261 to a partition!
[    2.502748] md: export_rdev(sda)
[    2.513095] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.513193] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.513664] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.536404] mdadm: sending ioctl 800c0910 to a partition!
[    2.536503] mdadm: sending ioctl 800c0910 to a partition!
[    2.536696] mdadm: sending ioctl 1261 to a partition!
[    2.536794] mdadm: sending ioctl 1261 to a partition!
[    2.537177] mdadm: sending ioctl 1261 to a partition!
[    2.537257] mdadm: sending ioctl 1261 to a partition!
(I type in 'mdadm --assemble --scan' here)
[   18.807584] scsi_verify_blk_ioctl: 16 callbacks suppressed
[   18.807666] mdadm: sending ioctl 800c0910 to a partition!
[   18.807746] mdadm: sending ioctl 800c0910 to a partition!
[   18.807836] mdadm: sending ioctl 1261 to a partition!
[   18.807916] mdadm: sending ioctl 1261 to a partition!
[   18.808241] mdadm: sending ioctl 1261 to a partition!
[   18.808322] mdadm: sending ioctl 1261 to a partition!
[   18.808632] mdadm: sending ioctl 1261 to a partition!
[   18.808712] mdadm: sending ioctl 1261 to a partition!
[   18.808973] mdadm: sending ioctl 1261 to a partition!
[   18.809053] mdadm: sending ioctl 1261 to a partition!
[   18.820428] md: md127 stopped.
[   18.826492] md: bind<sda>
[   18.827345] md: bind<sdb>
[   19.058251] md: md126 stopped.
[   19.059035] md: bind<sdb>
[   19.059421] md: bind<sda>
[   19.060988] md: raid0 personality registered for level 0
[   19.061282] bio: create slab <bio-1> at 1
[   19.061371] md/raid0:md126: md_size is 1250275328 sectors.
[   19.061452] md: RAID0 configuration for md126 - 1 zone
[   19.061531] md: zone0=[sda/sdb]
[   19.061785]       zone-offset=         0KB, device-offset=         0KB, size= 625137920KB
[   19.061881] 
[   19.061995] md126: detected capacity change from 0 to 640140967936
[   19.553668]  md126: p1 p2 < p5 p6 >

Thanks,
-bcd
