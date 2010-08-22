From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: raid hung due to a drive failure during reshape
Date: Sun, 22 Aug 2010 10:42:40 +0300
Message-ID: <201008221042.40326.anssi.hannula@iki.fi>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all!

First of all, this is mostly an FYI post just in case the bug can be 
identified. Rebooting the system allowed the array to be brought back up and 
continue reshaping.

I was running a reshape of a 10x 1TB device left-symmetric-6 64k chunk raid6 
array to a 11 device left-symmetric 512k chunk raid6 array (--grow --raid-
devices=11 --chunk=512 --layout=normalise).

In the middle of the reshape, I experienced some SATA link trouble and a drive 
(sde) become unavailable, causing it to be marked as failed. When I noticed 
this (a few hours later), the processes using the mounted filesystem appeared 
to be frozen, and process md2_raid6 was taking 100% CPU on one core (this is a 
quad-core system). The system remained otherwise usable.

The system is running 2.6.35.3.

Various information is below, feel free to ask for more.

=========================
The start of the reshape:
=========================
Aug 21 16:28:12 delta kernel: RAID conf printout:
Aug 21 16:28:12 delta kernel: --- level:6 rd:11 wd:11
Aug 21 16:28:12 delta kernel: disk 0, o:1, dev:sdo1
Aug 21 16:28:12 delta kernel: disk 1, o:1, dev:sdi1
Aug 21 16:28:12 delta kernel: disk 2, o:1, dev:sdf1
Aug 21 16:28:12 delta kernel: disk 3, o:1, dev:sdl1
Aug 21 16:28:12 delta kernel: disk 4, o:1, dev:sde1
Aug 21 16:28:12 delta kernel: disk 5, o:1, dev:sdn1
Aug 21 16:28:12 delta kernel: disk 6, o:1, dev:sdb1
Aug 21 16:28:12 delta kernel: disk 7, o:1, dev:sdm1
Aug 21 16:28:12 delta kernel: disk 8, o:1, dev:sdd1
Aug 21 16:28:12 delta kernel: disk 9, o:1, dev:sdh1
Aug 21 16:28:12 delta kernel: disk 10, o:1, dev:sdg1
Aug 21 16:28:12 delta kernel: md: reshape of RAID array md2
Aug 21 16:28:12 delta kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Aug 21 16:28:12 delta kernel: md: using maximum available idle IO bandwidth 
(but not more than 200000 KB/sec) for reshape.
Aug 21 16:28:12 delta kernel: md: using 128k window, over a total of 976759808 
blocks.

=========================
The failure of sde:
=========================
Aug 22 03:42:40 delta kernel: ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 
action 0x6 frozen
Aug 22 03:42:40 delta kernel: ata5.00: failed command: FLUSH CACHE EXT
Aug 22 03:42:40 delta kernel: ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 
tag 0
Aug 22 03:42:40 delta kernel:         res 40/00:0c:00:5d:3b/00:00:1e:00:00/40 
Emask 0x4 (timeout)
Aug 22 03:42:40 delta kernel: ata5.00: status: { DRDY }
Aug 22 03:42:40 delta kernel: ata5: hard resetting link
Aug 22 03:42:50 delta kernel: ata5: softreset failed (device not ready)
Aug 22 03:42:50 delta kernel: ata5: hard resetting link
Aug 22 03:43:00 delta kernel: ata5: softreset failed (device not ready)
Aug 22 03:43:00 delta kernel: ata5: hard resetting link
Aug 22 03:43:11 delta kernel: ata5: link is slow to respond, please be patient 
(ready=0)
Aug 22 03:43:35 delta kernel: ata5: softreset failed (device not ready)
Aug 22 03:43:35 delta kernel: ata5: limiting SATA link speed to 1.5 Gbps
Aug 22 03:43:35 delta kernel: ata5: hard resetting link
Aug 22 03:43:41 delta kernel: ata5: softreset failed (device not ready)
Aug 22 03:43:41 delta kernel: ata5: reset failed, giving up
Aug 22 03:43:41 delta kernel: ata5.00: disabled
Aug 22 03:43:41 delta kernel: ata5.00: device reported invalid CHS sector 0
Aug 22 03:43:41 delta kernel: ata5: EH complete
Aug 22 03:43:41 delta kernel: sd 4:0:0:0: [sde] Unhandled error code
Aug 22 03:43:41 delta kernel: sd 4:0:0:0: [sde] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Aug 22 03:43:41 delta kernel: sd 4:0:0:0: [sde] CDB: Write(10): 2a 00 74 70 98 
00 00 00 08 00
Aug 22 03:43:41 delta kernel: end_request: I/O error, dev sde, sector 
1953536000
Aug 22 03:43:41 delta kernel: end_request: I/O error, dev sde, sector 
1953536000
Aug 22 03:43:41 delta kernel: md: super_written gets error=-5, uptodate=0
Aug 22 03:43:41 delta kernel: md/raid:md2: Disk failure on sde1, disabling 
device.
Aug 22 03:43:41 delta kernel: <1>md/raid:md2: Operation continuing on 10 
devices.
Aug 22 03:43:41 delta kernel: md: md2: reshape done.

=========================
Backtrace of all CPUs:
=========================
SysRq : Show backtrace of all active CPUs
sending NMI to all CPUs:
NMI backtrace for cpu 2
CPU 2 
Modules linked in: raid1 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc af_packet ipv6 ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables 
x_tables capi capifs kernelcapi it87 hwmon_vid binfmt_misc ext3 jbd loop 
dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave freq_table 
mperf pcspkr nvram kvm_intel kvm snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
snd_seq_device matrox_w1 snd_pcm_oss snd_pcm wire snd_timer snd_mixer_oss 
i2c_i801 cn snd joydev i2c_core ohci1394 soundcore ieee1394 iTCO_wdt 
snd_page_alloc evdev r8169 iTCO_vendor_support serio_raw mii usb_storage wmi 
button sg thermal processor ide_generic cciss pata_amd sata_sil sata_via 
ata_generic ide_pci_generic pata_acpi jmicron ide_gd_mod ide_core pata_jmicron 
ata_piix ahci libahci shpchp pci_hotplug sata_sil24 libata sd_mod scsi_mod 
crc_t10dif raid456 async_pq as
ync_xor xor async_memcpy async_raid6_recov raid6_pq async_tx ext4 jbd2 crc16 
uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]
Aug 22 07:23:27 delta kernel:
Pid: 0, comm: swapper Not tainted 2.6.35.3-desktop-1mnb #1 P55-UD5/P55-UD5
RIP: 0010:[<ffffffff81012a0f>]  [<ffffffff81012a0f>] mwait_idle+0x6f/0xd0
RSP: 0018:ffff880207113ee8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff880207113fd8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880207113fd8 RDI: 0000000000000000
RBP: ffff880207113ef8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff816e44e8
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880001a80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000ecfc34 CR3: 000000014bb97000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff880207112000, task ffff88020710ad80)
Stack:
ffff880207113ef8 ffff880207113fd8 ffff880207113f28 ffffffff81008de3
<0> ffff880207113f18 bbf2250bc84a759b 0000000000000000 0000000000000000
<0> ffff880207113f48 ffffffff813d9d92 e785e7852e782e78 f56c12bd1aa95783
Call Trace:
[<ffffffff81008de3>] cpu_idle+0xb3/0x110
[<ffffffff813d9d92>] start_secondary+0x254/0x297
Code: d2 65 48 8b 34 25 08 cc 00 00 48 89 d1 48 8d 86 38 e0 ff ff 0f 01 c8 0f 
ae f0 48 8b 86 38 e0 ff ff a8 08 75 2c 31 c0 fb 0f 01 c9 <48> 83 c4 08 5b c9 
c3 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 
Call Trace:
[<ffffffff81008de3>] cpu_idle+0xb3/0x110
[<ffffffff813d9d92>] start_secondary+0x254/0x297
Pid: 0, comm: swapper Not tainted 2.6.35.3-desktop-1mnb #1
Call Trace:
<NMI>  [<ffffffff8101279b>] ? show_regs+0x2b/0x40
[<ffffffff813e3832>] nmi_watchdog_tick+0x1b2/0x1d0
[<ffffffff813e2bd3>] do_nmi+0x1a3/0x2d0
[<ffffffff813e2480>] nmi+0x20/0x30
[<ffffffff81012a0f>] ? mwait_idle+0x6f/0xd0
<<EOE>>  [<ffffffff81008de3>] cpu_idle+0xb3/0x110
[<ffffffff813d9d92>] start_secondary+0x254/0x297
NMI backtrace for cpu 1
CPU 1 
Modules linked in: raid1 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc af_packet ipv6 ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables 
x_tables capi capifs kernelcapi it87 hwmon_vid binfmt_misc ext3 jbd loop 
dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave freq_table 
mperf pcspkr nvram kvm_intel kvm snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
snd_seq_device matrox_w1 snd_pcm_oss snd_pcm wire snd_timer snd_mixer_oss 
i2c_i801 cn snd joydev i2c_core ohci1394 soundcore ieee1394 iTCO_wdt 
snd_page_alloc evdev r8169 iTCO_vendor_support serio_raw mii usb_storage wmi 
button sg thermal processor ide_generic cciss pata_amd sata_sil sata_via 
ata_generic ide_pci_generic pata_acpi jmicron ide_gd_mod ide_core pata_jmicron 
ata_piix ahci libahci shpchp pci_hotplug sata_sil24 libata sd_mod scsi_mod 
crc_t10dif raid456 async_pq as
ync_xor xor async_memcpy async_raid6_recov raid6_pq async_tx ext4 jbd2 crc16 
uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]
Aug 22 07:23:27 delta kernel:
Pid: 990, comm: md2_raid6 Not tainted 2.6.35.3-desktop-1mnb #1 P55-UD5/P55-UD5
RIP: 0010:[<ffffffffa0159237>]  [<ffffffffa0159237>] ops_run_io+0x77/0x330 
[raid456]
RSP: 0018:ffff8801ff6a3c30  EFLAGS: 00000246
RAX: 0000000000000508 RBX: ffff8801d3ca5370 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff8801ff6a3cf0 RDI: ffff8801d3ca5370
RBP: ffff8801ff6a3ca0 R08: 0000000000000000 R09: ffff880144c2a4b0
R10: ffff8801d3ca53b1 R11: ffff8801d3ca53b8 R12: 0000000000000000
R13: ffff8801d3ca5998 R14: 0000000000000007 R15: 0000000000000007
FS:  0000000000000000(0000) GS:ffff880001a40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000ecfc34 CR3: 0000000001643000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process md2_raid6 (pid: 990, threadinfo ffff8801ff6a2000, task 
ffff880204f2ad80)
Stack:
ffff8801ff6a3d80 ffff880193601950 0000000000000000 ffff880193601c58
<0> ffff8801d3ca53b0 ffff8801ff6a3cf0 ffff880201c75800 0000000000000000
<0> 0000000000000001 ffff8801d3ca5370 0000000000000000 0000000000000000
Call Trace:
[<ffffffffa015df77>] handle_stripe+0x817/0x1280 [raid456]
[<ffffffffa015ee5e>] raid5d+0x47e/0x690 [raid456]
[<ffffffff81301e1c>] md_thread+0x5c/0x130
[<ffffffff81078c60>] ? autoremove_wake_function+0x0/0x40
[<ffffffff81301dc0>] ? md_thread+0x0/0x130
[<ffffffff81078726>] kthread+0x96/0xa0
[<ffffffff8100ade4>] kernel_thread_helper+0x4/0x10
[<ffffffff81078690>] ? kthread+0x0/0xa0
[<ffffffff8100ade0>] ? kernel_thread_helper+0x0/0x10
Code: 01 4d 63 f7 49 69 c6 b8 00 00 00 4c 8d ac 03 20 01 00 00 f0 41 0f ba 75 
00 05 19 d2 85 d2 0f 85 a0 00 00 00 f0 41 0f ba 75 00 04 <19> d2 85 d2 74 c3 
4c 8d 4c 03 70 48 8d 04 03 48 c7 80 90 00 00 
Call Trace:
[<ffffffffa015df77>] handle_stripe+0x817/0x1280 [raid456]
[<ffffffffa015ee5e>] raid5d+0x47e/0x690 [raid456]
[<ffffffff81301e1c>] md_thread+0x5c/0x130
[<ffffffff81078c60>] ? autoremove_wake_function+0x0/0x40
[<ffffffff81301dc0>] ? md_thread+0x0/0x130
[<ffffffff81078726>] kthread+0x96/0xa0
[<ffffffff8100ade4>] kernel_thread_helper+0x4/0x10
[<ffffffff81078690>] ? kthread+0x0/0xa0
[<ffffffff8100ade0>] ? kernel_thread_helper+0x0/0x10
Pid: 990, comm: md2_raid6 Not tainted 2.6.35.3-desktop-1mnb #1
Call Trace:
<NMI>  [<ffffffff8101279b>] ? show_regs+0x2b/0x40
[<ffffffff813e3832>] nmi_watchdog_tick+0x1b2/0x1d0
[<ffffffff813e2bd3>] do_nmi+0x1a3/0x2d0
[<ffffffff813e2480>] nmi+0x20/0x30
[<ffffffffa0159237>] ? ops_run_io+0x77/0x330 [raid456]
<<EOE>>  [<ffffffffa015df77>] handle_stripe+0x817/0x1280 [raid456]
[<ffffffffa015ee5e>] raid5d+0x47e/0x690 [raid456]
[<ffffffff81301e1c>] md_thread+0x5c/0x130
[<ffffffff81078c60>] ? autoremove_wake_function+0x0/0x40
[<ffffffff81301dc0>] ? md_thread+0x0/0x130
[<ffffffff81078726>] kthread+0x96/0xa0
[<ffffffff8100ade4>] kernel_thread_helper+0x4/0x10
[<ffffffff81078690>] ? kthread+0x0/0xa0
[<ffffffff8100ade0>] ? kernel_thread_helper+0x0/0x10
NMI backtrace for cpu 3
CPU 3 
Modules linked in: raid1 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc af_packet ipv6 ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables 
x_tables capi capifs kernelcapi it87 hwmon_vid binfmt_misc ext3 jbd loop 
dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave freq_table 
mperf pcspkr nvram kvm_intel kvm snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
snd_seq_device matrox_w1 snd_pcm_oss snd_pcm wire snd_timer snd_mixer_oss 
i2c_i801 cn snd joydev i2c_core ohci1394 soundcore ieee1394 iTCO_wdt 
snd_page_alloc evdev r8169 iTCO_vendor_support serio_raw mii usb_storage wmi 
button sg thermal processor ide_generic cciss pata_amd sata_sil sata_via 
ata_generic ide_pci_generic pata_acpi jmicron ide_gd_mod ide_core pata_jmicron 
ata_piix ahci libahci shpchp pci_hotplug sata_sil24 libata sd_mod scsi_mod 
crc_t10dif raid456 async_pq as
ync_xor xor async_memcpy async_raid6_recov raid6_pq async_tx ext4 jbd2 crc16 
uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]
Aug 22 07:23:27 delta kernel:
Pid: 7384, comm: bash Not tainted 2.6.35.3-desktop-1mnb #1 P55-UD5/P55-UD5
RIP: 0010:[<ffffffff8120c800>]  [<ffffffff8120c800>] delay_tsc+0x0/0x80
RSP: 0018:ffff8801c5597dd0  EFLAGS: 00000803
RAX: 00000000d05b9b80 RBX: 0000000000000001 RCX: ffff880001ac0000
RDX: 000000000029b5a6 RSI: 000000000029b592 RDI: 000000000029b5a7
RBP: ffff8801c5597dd8 R08: 0000000000092efc R09: ffffffff8142e7a0
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff81684ce0 R14: 0000000000000286 R15: 0000000000000003
FS:  00007f10be29b700(0000) GS:ffff880001ac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001832cc0 CR3: 000000012bfe6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 7384, threadinfo ffff8801c5596000, task ffff88001c3796c0)
Stack:
ffffffff8120c79f ffff8801c5597de8 ffffffff8120c7f5 ffff8801c5597e08
<0> ffffffff81028065 0000000000000000 000000000000006c ffff8801c5597e18
<0> ffffffff812aaefe ffff8801c5597e68 ffffffff812ab2f1 ffff8801c5597ef8
Call Trace:
[<ffffffff8120c79f>] ? __delay+0xf/0x20
[<ffffffff8120c7f5>] __const_udelay+0x45/0x50
[<ffffffff81028065>] arch_trigger_all_cpu_backtrace+0x55/0x70
[<ffffffff812aaefe>] sysrq_handle_showallcpus+0xe/0x10
[<ffffffff812ab2f1>] __handle_sysrq+0x131/0x1a0
[<ffffffff812ab3ae>] write_sysrq_trigger+0x4e/0x50
[<ffffffff81194665>] proc_reg_write+0x75/0xb0
[<ffffffff8113c0b8>] vfs_write+0xb8/0x1a0
[<ffffffff8113cb01>] sys_write+0x51/0x90
[<ffffffff81009fc2>] system_call_fastpath+0x16/0x1b
Code: 0c cd c0 3e 6e 81 48 8b b4 0a 98 00 00 00 48 69 d6 fa 00 00 00 f7 e2 48 
8d 7a 01 e8 9b ff ff ff c9 c3 66 0f 1f 84 00 00 00 00 00 <55> 48 89 e5 41 56 
41 55 41 54 53 0f 1f 44 00 00 65 44 8b 2c 25 
Call Trace:
[<ffffffff8120c79f>] ? __delay+0xf/0x20
[<ffffffff8120c7f5>] __const_udelay+0x45/0x50
[<ffffffff81028065>] arch_trigger_all_cpu_backtrace+0x55/0x70
[<ffffffff812aaefe>] sysrq_handle_showallcpus+0xe/0x10
[<ffffffff812ab2f1>] __handle_sysrq+0x131/0x1a0
[<ffffffff812ab3ae>] write_sysrq_trigger+0x4e/0x50
[<ffffffff81194665>] proc_reg_write+0x75/0xb0
[<ffffffff8113c0b8>] vfs_write+0xb8/0x1a0
[<ffffffff8113cb01>] sys_write+0x51/0x90
[<ffffffff81009fc2>] system_call_fastpath+0x16/0x1b
Pid: 7384, comm: bash Not tainted 2.6.35.3-desktop-1mnb #1
Call Trace:
<NMI>  [<ffffffff8101279b>] ? show_regs+0x2b/0x40
[<ffffffff813e3832>] nmi_watchdog_tick+0x1b2/0x1d0
[<ffffffff813e2bd3>] do_nmi+0x1a3/0x2d0
[<ffffffff813e2480>] nmi+0x20/0x30
[<ffffffff8120c800>] ? delay_tsc+0x0/0x80
<<EOE>>  [<ffffffff8120c79f>] ? __delay+0xf/0x20
[<ffffffff8120c7f5>] __const_udelay+0x45/0x50
[<ffffffff81028065>] arch_trigger_all_cpu_backtrace+0x55/0x70
[<ffffffff812aaefe>] sysrq_handle_showallcpus+0xe/0x10
[<ffffffff812ab2f1>] __handle_sysrq+0x131/0x1a0
[<ffffffff812ab3ae>] write_sysrq_trigger+0x4e/0x50
[<ffffffff81194665>] proc_reg_write+0x75/0xb0
[<ffffffff8113c0b8>] vfs_write+0xb8/0x1a0
[<ffffffff8113cb01>] sys_write+0x51/0x90
[<ffffffff81009fc2>] system_call_fastpath+0x16/0x1b
NMI backtrace for cpu 0
CPU 0 
Modules linked in: raid1 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss 
sunrpc af_packet ipv6 ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle xt_mac iptable_filter ip_tables 
x_tables capi capifs kernelcapi it87 hwmon_vid binfmt_misc ext3 jbd loop 
dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave freq_table 
mperf pcspkr nvram kvm_intel kvm snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
snd_seq_device matrox_w1 snd_pcm_oss snd_pcm wire snd_timer snd_mixer_oss 
i2c_i801 cn snd joydev i2c_core ohci1394 soundcore ieee1394 iTCO_wdt 
snd_page_alloc evdev r8169 iTCO_vendor_support serio_raw mii usb_storage wmi 
button sg thermal processor ide_generic cciss pata_amd sata_sil sata_via 
ata_generic ide_pci_generic pata_acpi jmicron ide_gd_mod ide_core pata_jmicron 
ata_piix ahci libahci shpchp pci_hotplug sata_sil24 libata sd_mod scsi_mod 
crc_t10dif raid456 async_pq as
ync_xor xor async_memcpy async_raid6_recov raid6_pq async_tx ext4 jbd2 crc16 
uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore [last unloaded: scsi_wait_scan]
Aug 22 07:23:27 delta kernel:
Pid: 0, comm: swapper Not tainted 2.6.35.3-desktop-1mnb #1 P55-UD5/P55-UD5
RIP: 0010:[<ffffffff81012a0f>]  [<ffffffff81012a0f>] mwait_idle+0x6f/0xd0
RSP: 0018:ffffffff815cbed8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff815cbfd8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815cbfd8 RDI: 0000000000000000
RBP: ffffffff815cbee8 R08: 0000000000000000 R09: ffff880001a10828
R10: 00005e1948df061e R11: 0000000000000001 R12: ffffffff816e44e8
R13: 0000000000000000 R14: ffffffffffffffff R15: 00000000000937c0
FS:  0000000000000000(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fa737dc9020 CR3: 00000001f3e03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff815ca000, task ffffffff8164b020)
Stack:
ffffffff815cbee8 ffffffff815cbfd8 ffffffff815cbf18 ffffffff81008de3
<0> 6db6db6db6db6db7 6ef04dfe9c317f65 0000000000000000 6db6db6db6db6db7
<0> ffffffff815cbf28 ffffffff813c900a ffffffff815cbf68 ffffffff81700e56
Call Trace:
[<ffffffff81008de3>] cpu_idle+0xb3/0x110
[<ffffffff813c900a>] rest_init+0x8a/0x90
[<ffffffff81700e56>] start_kernel+0x41b/0x427
[<ffffffff81700341>] x86_64_start_reservations+0x12c/0x130
[<ffffffff8170043f>] x86_64_start_kernel+0xfa/0x109
Code: d2 65 48 8b 34 25 08 cc 00 00 48 89 d1 48 8d 86 38 e0 ff ff 0f 01 c8 0f 
ae f0 48 8b 86 38 e0 ff ff a8 08 75 2c 31 c0 fb 0f 01 c9 <48> 83 c4 08 5b c9 
c3 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 
Call Trace:
[<ffffffff81008de3>] cpu_idle+0xb3/0x110
[<ffffffff813c900a>] rest_init+0x8a/0x90
[<ffffffff81700e56>] start_kernel+0x41b/0x427
[<ffffffff81700341>] x86_64_start_reservations+0x12c/0x130
[<ffffffff8170043f>] x86_64_start_kernel+0xfa/0x109
Pid: 0, comm: swapper Not tainted 2.6.35.3-desktop-1mnb #1
Call Trace:
<NMI>  [<ffffffff8101279b>] ? show_regs+0x2b/0x40
[<ffffffff813e3832>] nmi_watchdog_tick+0x1b2/0x1d0
[<ffffffff813e2bd3>] do_nmi+0x1a3/0x2d0
[<ffffffff813e2480>] nmi+0x20/0x30
[<ffffffff81012a0f>] ? mwait_idle+0x6f/0xd0
<<EOE>>  [<ffffffff81008de3>] cpu_idle+0xb3/0x110
[<ffffffff813c900a>] rest_init+0x8a/0x90
[<ffffffff81700e56>] start_kernel+0x41b/0x427
[<ffffffff81700341>] x86_64_start_reservations+0x12c/0x130
[<ffffffff8170043f>] x86_64_start_kernel+0xfa/0x109

====================
Backtrace of one of the frozen processes:
====================
tar           D 00000000ffffffff     0 18737  20174 0x00000004
ffff8801e01f3a08 0000000000000082 ffffea0003c9a680 0000000000015400
ffff8801e01f3fd8 0000000000015400 ffff8801e01f3fd8 ffff880205c95b00
0000000000015400 0000000000015400 ffff8801e01f3fd8 0000000000015400
Call Trace:
[<ffffffff81078f70>] ? prepare_to_wait+0x60/0x90
[<ffffffffa009a845>] do_get_write_access+0x2a5/0x500 [jbd2]
[<ffffffff81078ca0>] ? wake_bit_function+0x0/0x40
[<ffffffffa009abf1>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
[<ffffffffa00e1678>] __ext4_journal_get_write_access+0x38/0x70 [ext4]
[<ffffffffa00bff83>] ext4_reserve_inode_write+0x73/0x90 [ext4]
[<ffffffffa009b175>] ? jbd2_journal_start+0xb5/0x100 [jbd2]
[<ffffffffa00bffec>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
[<ffffffffa00d3208>] ? ext4_journal_start_sb+0xf8/0x130 [ext4]
[<ffffffffa00c02e0>] ext4_dirty_inode+0x40/0x60 [ext4]
[<ffffffff8115dacb>] __mark_inode_dirty+0x3b/0x170
[<ffffffff81151ea2>] file_update_time+0xf2/0x170
[<ffffffff810ed020>] __generic_file_aio_write+0x210/0x470
[<ffffffff8113a837>] ? __dentry_open+0x217/0x330
[<ffffffff810ed2e5>] generic_file_aio_write+0x65/0xd0
[<ffffffffa00b9fa9>] ext4_file_write+0x39/0xb0 [ext4]
[<ffffffff8113bdda>] do_sync_write+0xda/0x120
[<ffffffff811ce006>] ? security_file_permission+0x16/0x20
[<ffffffff8113c0b8>] vfs_write+0xb8/0x1a0
[<ffffffff8113cb01>] sys_write+0x51/0x90
[<ffffffff813e251e>] ? do_device_not_available+0xe/0x10
[<ffffffff81009fc2>] system_call_fastpath+0x16/0x1b

====================
/proc/mdstat and --detail during the hang
====================
md2 : active raid6 sdg1[10] sdh1[9] sdo1[0] sdd1[8] sdm1[7] sdb1[6] sdn1[5] 
sde1[11](F) sdl1[3] sdf1[2] sdi1[1]
      7814078464 blocks super 0.91 level 6, 64k chunk, algorithm 18 [11/10] 
[UUUU_UUUUUU]

/dev/md2:
        Version : 0.91
  Creation Time : Mon Jan  4 19:38:35 2010
     Raid Level : raid6
     Array Size : 7814078464 (7452.09 GiB 8001.62 GB)
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
   Raid Devices : 11
  Total Devices : 11
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sun Aug 22 03:42:08 2010
          State : active, degraded
 Active Devices : 10
Working Devices : 10
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric-6
     Chunk Size : 64K

  Delta Devices : 1, (10->11)
     New Layout : left-symmetric
  New Chunksize : 512K

           UUID : c085660f:582b100d:7042cf93:6586d9b0 (local to host 
delta.onse.fi)
         Events : 0.1913300

    Number   Major   Minor   RaidDevice State
       0       8      225        0      active sync   /dev/sdo1
       1       8      129        1      active sync   /dev/sdi1
       2       8       81        2      active sync   /dev/sdf1
       3       8      177        3      active sync   /dev/sdl1
      11       8       65        4      faulty spare rebuilding   /dev/sde1
       5       8      209        5      active sync   /dev/sdn1
       6       8       17        6      active sync   /dev/sdb1
       7       8      193        7      active sync   /dev/sdm1
       8       8       49        8      active sync   /dev/sdd1
       9       8      113        9      active sync   /dev/sdh1
      10       8       97       10      active sync   /dev/sdg1


-- 
Anssi Hannula
