From: Durval Menezes <durval.menezes@gmail.com>
Subject: reiserfsck Segfaulting om md readonly raid6 array, dmesg shows "kernel BUG at drivers/md/md.c:5790"
Date: Mon, 1 Apr 2013 17:26:22 -0300
Message-ID: <20130401172929.W24136@tmp.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello folks,

First a little background: I'm in the process of recovering a 5-disk RAID6
array where 3 devices failed :-/ What happened is that one device died,
then we inserted a new device and during rebuild two others were kicked
from the array, separated by a few minutes, due to them having bad sectors
too and taking too long to return failure to md (TLER was not set). This
was on a EL4-based system running kernel 2.6.27.

I've rebooted from a recovery CD (gentoo mini with kernel  2.6.29), then
managed to reassemble the array with the two intact disks and one of the
kicked-out ones. I then set it to readonly (md --readonly   /dev/md0) for
safety while checking everything out, and then checked it with vgscan,
which found all three LVM volumes (good sign, and IMO demonstrates that my
data could have survived). Then I set those volumes active (with vgchange
-a y) and tried to run "reiserfsck --check" on the first of them, with the
following result:

     reiserfsck --check /dev/VolGroup00/Main
         [...]
         Replaying journal..
         Trans replayed: mountid 47, transid 11403219, desc 197, len 1, commit 199, next trans offset 182
         Segmentation fault

I then checked dmesg and got the "kernel BUG at drivers/md/md.c" message
block copied below.

I wonder whether this is related to the fsync bug on md0 arrays recently
reported here on the list (it makes sense for reiserfsck to call fsync
after each critical recovery point, even though not much sense if the
filesystem is in read-only mode... but anyway IMHO the request should have
been just ignored).

Also, what would you suggest in order to recover from this? Should I just
reset the array to readwrite mode and hope for the best? Hope I don't need
a new kernel for recovery, because it will not be viable to upgrade to a
more recent kernel, nor change from reiserfs to something else in the
middle of this (specially in the middle recovering my data).

Thanks in advance,
-- 
   Durval.


------------[ cut here ]------------
kernel BUG at drivers/md/md.c:5790!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/block/sda/sda2/uevent
Modules linked in: video backlight output ac battery button fan thermal
processor thermal_sys e100 e1000e rtc tg3 libphy e1000 fuse jfs raid10
raid456 async_memcpy async_xor
 xor async_tx raid1 raid0 dm_bbr dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394 sl811_hcd usbhid
ohci_hcd uhci_hcd usb_storage ehci
_hcd usbcore lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid
aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc
scsi_transport_fc scsi_tgt
 mptspi mptscsih mptbase atp870u dc395x sim710 53c700 qla1280 dmx3191d
sym53c8xx qlogicfas408 gdth aha1740 advansys initio BusLogic arcmsr aic7xxx
aic79xx scsi_transport_spi
 sg pdc_adma sata_inic162x sata_mv ata_piix ahci sata_qstor sata_vsc
sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil
sata_promise pata_sl82c105 pata
_cs5535 pata_cs5530 pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis
pata_netcell pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp
pata_opti pata_amd pata_ali p
ata_it8213 pata_isapnp pata_pcmcia pcmcia firmware_class pcmcia_core
pata_ns87415 pata_ns87410 pata_serverworks pata_artop pata_it821x
pata_optidma pata_hpt3x2n pata_hpt3x3
pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 pata_sil680
pata_radisys pata_pdc2027x pata_mpiix libata

Pid: 23506, comm: reiserfsck Not tainted (2.6.29-gentoo-r5 #1) S3210SH
EIP: 0060:[<c03739b0>] EFLAGS: 00010246 CPU: 0
EIP is at md_write_start+0x1b/0x13c
EAX: 00000001 EBX: f6e9b800 ECX: f3a72240 EDX: f3a72240
ESI: 0138ea88 EDI: 0138ea88 EBP: f3a72240 ESP: f3cadcfc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process reiserfsck (pid: 23506, ti=f3cac000 task=f6d92280 task.ti=f3cac000)
Stack:
 00000000 00001000 c0174bf2 f578ccc0 f578ccc0 f67d8068 0138ea88 0138ea88
 f3a72240 f805c8ef f5a0d48c 00001000 f69e5384 f3a72240 f6e9b800 f6134c80
 f7e79080 c1675da0 00000000 00271d21 00000001 00000000 00000000 0138e908
Call Trace:
 [<c0174bf2>] set_bh_page+0x4e/0x56
 [<f805c8ef>] make_request+0x48/0x5fd [raid456]
 [<c02c0456>] generic_make_request+0x28a/0x2cd
 [<c0179f4a>] blkdev_write_end+0x30/0x38
 [<c013fd88>] mempool_alloc+0x27/0xcb
 [<c02c0526>] submit_bio+0x8d/0x95
 [<c0177f03>] bio_alloc_bioset+0x1e/0xf2
 [<c017498e>] submit_bh+0xc7/0xe3
 [<c0176e61>] __block_write_full_page+0x20c/0x2e1
 [<c0178d3e>] blkdev_get_block+0x0/0xc0
 [<c0176ff7>] block_write_full_page+0xc1/0xca
 [<c0178d3e>] blkdev_get_block+0x0/0xc0
 [<c0142c1c>] __writepage+0x8/0x22
 [<c0143233>] write_cache_pages+0x1ae/0x29e
 [<c0142c14>] __writepage+0x0/0x22
 [<c013f875>] generic_file_aio_write_nolock+0x3b/0x84
 [<c0143323>] generic_writepages+0x0/0x21
 [<c014333d>] generic_writepages+0x1a/0x21
 [<c0143364>] do_writepages+0x20/0x30
 [<c013e894>] __filemap_fdatawrite_range+0x54/0x60
 [<c013f76e>] filemap_fdatawrite+0x12/0x16
 [<c0173b15>] vfs_fsync+0x40/0x85
 [<c0173b79>] do_fsync+0x1f/0x2e
 [<c0102c42>] syscall_call+0x7/0xb
Code: f0 80 8a 34 01 00 00 20 83 c4 1c 5b 5e 5f 5d c3 55 57 56 53 89 c3 83
ec 14 f6 42 14 01 0f 84 21 01 00 00 8b 40 1c 83 f8 01 75 04 <0f> 0b eb fe
31 ff 83 f8 02 75 30 c7 43 1c 00 00 00 00 8d 83 34
EIP: [<c03739b0>] md_write_start+0x1b/0x13c SS:ESP 0068:f3cadcfc
---[ end trace 6d3a980df51f2517 ]---
