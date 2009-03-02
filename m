From: Joe Landman <joe.landman@gmail.com>
Subject: lots of BUG: soft lockup - CPU#2 stuck for 61s! [md0_raid5:xxx] type
	messages showing up on check or under load
Date: Sun, 1 Mar 2009 22:23:40 -0500
Message-ID: <9f5edc120903011923s472e50ffu1a0a1f21775577e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A RAID6 we have built seems to toss large numbers of soft lockup messages.

This is a 2.6.28.4 kernel on Ubuntu 8.04

root@dv4:~# uname -a
Linux dv4 2.6.28.4 #1 SMP Sat Feb 7 01:03:32 EST 2009 x86_64 GNU/Linux


root@dv4:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid6 sda2[0](W) sdx2[22](W) sdw2[21](W) sdv2[20](W)
sdt2[19](W) sds2[18](W) sdr2[17](W) sdq2[16](W) sdp2[15](W)
sdo2[14](W) sdn2[13](W) sdm2[12](W) sdl2[11](W) sdk2[10](W) sdj2[9](W)
sdi2[8](W) sdh2[7](W) sdg2[6](W) sdf2[5](W) sde2[4](W) sdd2[3](W)
sdc2[2](W) sdb2[1](W)
      30636695040 blocks super 1.2 level 6, 256k chunk, algorithm 2
[23/23] [UUUUUUUUUUUUUUUUUUUUUUU]
      bitmap: 0/348 pages [0KB], 2048KB chunk

unused devices: <none>


 Mar  1 02:30:02 delta-v kernel: [1864883.391262] BUG: soft lockup -
CPU#2 stuck for 61s! [md0_raid5:4049]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265] Modules linked in:
crc32c iscsi_scst scst_vdisk scst libcrc32c ipmi_msghandler nfsd
auth_rpcgss exportfs nfs lockd nfs_acl sunrpc iptable_filter ip_tables
x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi scsi_transport_iscsi lp loop psmouse serio_raw
pcspkr cfi_cmdset_0002 shpchp pci_hotplug jedec_probe cfi_probe
gen_probe cfi_util ck804xrom mtd chipreg map_funcs i2c_nforce2
i2c_core parport_pc parport button ipv6 evdev ext3 jbd mbcache ses
enclosure sg sd_mod crc_t10dif usbhid hid ata_generic sata_nv pata_amd
mptsas mptscsih mptbase scsi_transport_sas pata_acpi ehci_hcd ohci_hcd
libata forcedeth scsi_mod usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan thermal_sys fuse
 Mar  1 02:30:02 delta-v kernel: [1864883.391265] Modules linked in:
crc32c iscsi_scst scst_vdisk scst libcrc32c ipmi_msghandler nfsd
auth_rpcgss exportfs nfs lockd nfs_acl sunrpc iptable_filter ip_tables
x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi scsi_transport_iscsi lp loop psmouse serio_raw
pcspkr cfi_cmdset_0002 shpchp pci_hotplug jedec_probe cfi_probe
gen_probe cfi_util ck804xrom mtd chipreg map_funcs i2c_nforce2
i2c_core parport_pc parport button ipv6 evdev ext3 jbd mbcache ses
enclosure sg sd_mod crc_t10dif usbhid hid ata_generic sata_nv pata_amd
mptsas mptscsih mptbase scsi_transport_sas pata_acpi ehci_hcd ohci_hcd
libata forcedeth scsi_mod usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan thermal_sys fuse
 Mar  1 02:30:02 delta-v kernel: [1864883.391265] Call Trace:
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa00b807d>] ? raid6_sse24_gen_syndrome+0x22d/0x260 [raid456]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa00b3cfe>] ? compute_parity6+0x1de/0x350 [raid456]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa00b401b>] ? compute_block_1+0x1ab/0x1d0 [raid456]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa00b5157>] ? handle_stripe+0xed7/0xf60 [raid456]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa0051810>] ? md_thread+0x0/0x100 [md_mod]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa00b5520>] ? raid5d+0x340/0x520 [raid456]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff8024c800>] ? process_timeout+0x0/0x10
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff80225a85>] ? default_spin_lock_flags+0x5/0x10
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff804c1e1e>] ? _spin_lock_irqsave+0x2e/0x40
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa0051810>] ? md_thread+0x0/0x100 [md_mod]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa005183f>] ? md_thread+0x2f/0x100 [md_mod]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff80258140>] ? autoremove_wake_function+0x0/0x30
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffffa0051810>] ? md_thread+0x0/0x100 [md_mod]
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff80257ceb>] ? kthread+0x4b/0x80
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff8020d6e9>] ? child_rip+0xa/0x11
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff80257ca0>] ? kthread+0x0/0x80
 Mar  1 02:30:02 delta-v kernel: [1864883.391265]
[<ffffffff8020d6df>] ? child_rip+0x0/0x11
 Mar  1 02:31:08 delta-v kernel: [1864948.891256] BUG: soft lockup -
CPU#2 stuck for 61s! [md0_raid5:4049]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260] Modules linked in:
crc32c iscsi_scst scst_vdisk scst libcrc32c ipmi_msghandler nfsd
auth_rpcgss exportfs nfs lockd nfs_acl sunrpc iptable_filter ip_tables
x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi scsi_transport_iscsi lp loop psmouse serio_raw
pcspkr cfi_cmdset_0002 shpchp pci_hotplug jedec_probe cfi_probe
gen_probe cfi_util ck804xrom mtd chipreg map_funcs i2c_nforce2
i2c_core parport_pc parport button ipv6 evdev ext3 jbd mbcache ses
enclosure sg sd_mod crc_t10dif usbhid hid ata_generic sata_nv pata_amd
mptsas mptscsih mptbase scsi_transport_sas pata_acpi ehci_hcd ohci_hcd
libata forcedeth scsi_mod usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan thermal_sys fuse
 Mar  1 02:31:08 delta-v kernel: [1864948.891260] Modules linked in:
crc32c iscsi_scst scst_vdisk scst libcrc32c ipmi_msghandler nfsd
auth_rpcgss exportfs nfs lockd nfs_acl sunrpc iptable_filter ip_tables
x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr
iscsi_tcp libiscsi scsi_transport_iscsi lp loop psmouse serio_raw
pcspkr cfi_cmdset_0002 shpchp pci_hotplug jedec_probe cfi_probe
gen_probe cfi_util ck804xrom mtd chipreg map_funcs i2c_nforce2
i2c_core parport_pc parport button ipv6 evdev ext3 jbd mbcache ses
enclosure sg sd_mod crc_t10dif usbhid hid ata_generic sata_nv pata_amd
mptsas mptscsih mptbase scsi_transport_sas pata_acpi ehci_hcd ohci_hcd
libata forcedeth scsi_mod usbcore raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan thermal_sys fuse
 Mar  1 02:31:08 delta-v kernel: [1864948.891260] Call Trace:
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa00b807d>] ? raid6_sse24_gen_syndrome+0x22d/0x260 [raid456]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa00b3cfe>] ? compute_parity6+0x1de/0x350 [raid456]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa008d000>] ? xor_sse_2+0x0/0x1f0 [xor]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa00b5157>] ? handle_stripe+0xed7/0xf60 [raid456]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa0051810>] ? md_thread+0x0/0x100 [md_mod]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa00b5520>] ? raid5d+0x340/0x520 [raid456]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff8024c800>] ? process_timeout+0x0/0x10
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff80225a85>] ? default_spin_lock_flags+0x5/0x10
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff804c1e1e>] ? _spin_lock_irqsave+0x2e/0x40
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa0051810>] ? md_thread+0x0/0x100 [md_mod]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa005183f>] ? md_thread+0x2f/0x100 [md_mod]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff80258140>] ? autoremove_wake_function+0x0/0x30
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffffa0051810>] ? md_thread+0x0/0x100 [md_mod]
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff80257ceb>] ? kthread+0x4b/0x80
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff8020d6e9>] ? child_rip+0xa/0x11
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff80257ca0>] ? kthread+0x0/0x80
 Mar  1 02:31:08 delta-v kernel: [1864948.891260]
[<ffffffff8020d6df>] ? child_rip+0x0/0x11


Other distros seem to see it as well (http://bugs.gentoo.org/198215)

Any thoughts?
