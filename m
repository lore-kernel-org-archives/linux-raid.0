From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: md2 won't mount at boot time, and array missing one spare
Date: Sun, 19 Jul 2009 00:10:20 +0300
Message-ID: <4A623A3C.90808@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been having a few problems on recent reboots that, I think, is 
caused by a recent update - I always apply updates.

The problem is that my raid5+2 device doesn't get automatically mounted 
at boot.

If I do a 'sudo mount -av', it works fine :

$ sudo mount -av
[sudo] password for davidmaxwaterman:
mount: proc already mounted on /proc
mount: /dev/sda1 already mounted on /mnt/backup
/dev/md2 on /mnt/array type xfs (rw,noatime,nobarrier)

Also, I wonder why there are only 6+1 devices in md2, when there should 
be 6+2.

Advice on how to fix?

Details below.

Thanks,

Max.

If I look in /var/log/messages to see why it might not be doing it at 
boot time, I see a few suspect messages, the 'latest' of which is :

md2: unknown partition table

but there is also (cherry picking relevant looking lines, but 
maintaining chronological order):

=====================
   sdd: unknown partition table
ata7: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 21
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: EH complete
ata7: hard resetting link
   sde: unknown partition table
md: bind<sdc>
md: bind<sde>
md: bind<sdd>
  sdf: unknown partition table
  sdg: unknown partition table
  sdi: unknown partition table
md: bind<sdg>
md: bind<sdf>
md: bind<sdh>
md: export_rdev(sdi)
md: unbind<sdh>
md: export_rdev(sdh)
md: bind<sdi>
ata7: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 21
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: EH complete
ata7: hard resetting link
md: export_rdev(sdh)
md: export_rdev(sdh)
Jul 18 22:13:58 jeeves kernel: [   36.706215] WARNING: at 
/build/buildd/linux-2.6.28/arch/x86/mm/ioremap.c:226 
__ioremap_caller+0x2d1/0x320()
Jul 18 22:13:58 jeeves kernel: [   36.706217] Modules linked in: 
ck804xrom(+) mtd chipreg psmouse nvidia(P+) ppdev soundcore i2c_nforce2 
map_funcs serio_raw pcspkr agpgart parport_pc snd_page_alloc k8temp 
parport btusb ohci1394 ieee1394 pata_hpt37x forcedeth usbhid raid10 
raid456 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear 
fbcon tileblit font bitblit softcursor
  Pid: 1142, comm: modprobe Tainted: P           2.6.28-14-server #46-Ubuntu
  Call Trace:
   [<c050a300>] ? printk+0x2/0x1a
   [<c0141344>] warn_on_slowpath+0x54/0x80
   [<c050c358>] ? _spin_trylock+0x8/0x20
   [<c034cb00>] ? vt_console_print+0x230/0x320
   [<c02d4888>] ? string+0x28/0xd0
   [<c050a316>] ? printk+0x18/0x1a
   [<c01477bf>] ? iomem_map_sanity_check+0x14f/0x170
   [<f915c27f>] ? ck804xrom_init_one+0x17f/0x505 [ck804xrom]
   [<c012a511>] __ioremap_caller+0x2d1/0x320
   [<c042e9da>] ? raw_pci_write+0x7a/0x80
   [<c02ded73>] ? pci_bus_write_config_byte+0x53/0x70
   [<f915c27f>] ? ck804xrom_init_one+0x17f/0x505 [ck804xrom]
   [<c012a69a>] ioremap_nocache+0x1a/0x20
   [<f915c27f>] ? ck804xrom_init_one+0x17f/0x505 [ck804xrom]
   [<f915c27f>] ck804xrom_init_one+0x17f/0x505 [ck804xrom]
   [<f9162035>] init_ck804xrom+0x35/0x4b [ck804xrom]
   [<f9162000>] ? init_ck804xrom+0x0/0x4b [ck804xrom]
   [<c010302d>] do_one_initcall+0x2d/0x170
   [<c0214be5>] ? sysfs_addrm_finish+0x15/0xf0
   [<c02143c3>] ? sysfs_add_one+0x13/0x50
   [<c021443f>] ? sysfs_addrm_start+0x3f/0xa0
   [<c01b1abc>] ? __vunmap+0x9c/0xe0
   [<c01b1abc>] ? __vunmap+0x9c/0xe0
   [<c01b1b51>] ? vfree+0x21/0x30
   [<c016bb5b>] ? load_module+0x103b/0x1040
   [<c016bbe8>] sys_init_module+0x88/0x1b0
   [<c0109eef>] sysenter_do_call+0x12/0x2f
  ---[ end trace a942f3e82d615663 ]---
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: SATA link down (SStatus 101 SControl 300)
ata7: hard resetting link
ata7: reset failed (errno=-32), retrying in 8 secs
ata7: limiting SATA link speed to 1.5 Gbps
ata7: hard resetting link
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: ATA-6: WDC WD2000JD-00HBB0, 08.02D08, max UDMA/133
ata7.00: 390721968 sectors, multi 16: LBA48
ata7.00: configured for UDMA/133
  sdj: unknown partition table
md: bind<sdj>
raid5: device sdj operational as raid disk 3
raid5: device sdf operational as raid disk 0
raid5: device sdg operational as raid disk 1
raid5: device sdd operational as raid disk 4
raid5: device sde operational as raid disk 5
raid5: device sdc operational as raid disk 2
raid5: allocated 6305kB for md2
raid5: raid level 5 set md2 active with 6 out of 6 devices, algorithm 2
RAID5 conf printout:
  --- rd:6 wd:6
   disk 0, o:1, dev:sdf
   disk 1, o:1, dev:sdg
   disk 2, o:1, dev:sdc
   disk 3, o:1, dev:sdj
   disk 4, o:1, dev:sdd
   disk 5, o:1, dev:sde
   md2: unknown partition table
  md: export_rdev(sdh)
  md: export_rdev(sdh)

===========================

My mdadm.conf contains (among some other lines) :

DEVICE /dev/sd[cdefghij]

ARRAY /dev/md2 level=raid5 num-devices=6 metadata=0.90 spares=2 
UUID=15bfec75:595ac793:0914f8ee:862effd8
