From: Larkin Lowrey <llowrey@gmail.com>
Subject: raid6 replace spewing WARNING to console, system now frozen
Date: Wed, 6 Dec 2017 16:59:27 -0500
Message-ID: <70213474-ec3a-f66e-adef-084c5f0a6f72@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

One drive in a 8 drive raid6 array developed pending sectors so I 
plugged in a replacement drive, added it to the array, then used the 
--replace option to replace the failing drive.

Mid way into the operation the following WARNING stack trace started 
spewing to the console. The system is now completely unresponsive. A 
final mdstat capture showed the bad drive as (F) so the resync must have 
reached those pending sectors.

I suspect that the warning is probably not terribly bad if there is no 
serial console, but since the serial port is limited to 115,200 baud... 
the warning takes WAY too much time and also whatever buffer there is 
for the console fills up and the system is rendered inoperable.

Maybe this warning isn't such a good idea.

--Larkin

> [20962.940086] WARNING: CPU: 23 PID: 1258 at drivers/md/raid5.c:4893 
> handle_stripe+0x1df4/0x2160 [raid456]
> [20962.949932] Modules linked in: binfmt_misc xt_nat veth 8021q garp 
> mrp xfs xt_addrtype br_netfilter vhost_net vhost macvtap macvlan tap 
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 
> iptable_nat nf_nat_ipv4 nf_nat tun bridge stp llc ebtable_filter 
> ebtables bonding cfg80211 rfkill ip6t_REJECT nf_reject_ipv6 
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 
> xt_conntrack nf_conntrack ip6table_filter ip6_tables jc42 joydev 
> ipmi_si amd64_edac_mod edac_mce_amd kvm_amd kvm irqbypass 
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ipmi_devintf 
> ipmi_msghandler sp5100_tco fam15h_power k10temp i2c_piix4 tpm_tis 
> shpchp tpm_tis_core tpm acpi_cpufreq dm_thin_pool dm_persistent_data 
> dm_bio_prison raid456 libcrc32c async_raid6_recov async_memcpy 
> async_pq async_xor async_tx btrfs
> [20963.023029]  xor raid6_pq bcache raid10 igb drm_kms_helper ttm 
> mvsas ptp drm crc32c_intel libsas serio_raw mpt3sas pps_core be2net 
> raid_class dca scsi_transport_sas i2c_algo_bit
> [20963.039563] CPU: 23 PID: 1258 Comm: md2_raid6 Tainted: G W       
> 4.13.15-100.fc25.x86_64 #1
> [20963.048959] Hardware name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 
> 3.0a       07/26/2013
> [20963.057600] task: ffff88180aa7a640 task.stack: ffff9ad948254000
> [20963.063811] RIP: 0010:handle_stripe+0x1df4/0x2160 [raid456]
> [20963.069638] RSP: 0018:ffff9ad948257bc8 EFLAGS: 00010246
> [20963.075159] RAX: 0000000000200100 RBX: 00000000ffffffff RCX: 
> 0000000000000001
> [20963.082592] RDX: 0000000000000001 RSI: 0000000000200100 RDI: 
> 0000000000000000
> [20963.089976] RBP: ffff9ad948257cd8 R08: 0000000000000001 R09: 
> 0000000000000000
> [20963.097405] R10: 0000000000000000 R11: 0000000000000000 R12: 
> 0000000000000007
> [20963.104823] R13: ffff8805caa51940 R14: 0000000000000007 R15: 
> ffff88120a856000
> [20963.112235] FS:  0000000000000000(0000) GS:ffff88120fdc0000(0000) 
> knlGS:0000000000000000
> [20963.120777] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [20963.126806] CR2: 00007f878e68e000 CR3: 000000111be09000 CR4: 
> 00000000000406e0
> [20963.134219] Call Trace:
> [20963.136906]  ? default_wake_function+0x12/0x20
> [20963.141630]  ? autoremove_wake_function+0x33/0x60
> [20963.146606]  ? __wake_up_common+0x70/0x90
> [20963.150905]  handle_active_stripes.isra.57+0x3b6/0x5e0 [raid456]
> [20963.157160]  raid5d+0x4db/0x730 [raid456]
> [20963.161429]  ? del_timer_sync+0x39/0x40
> [20963.165554]  ? prepare_to_wait_event+0x75/0x170
> [20963.170360]  md_thread+0x12e/0x170
> [20963.174030]  ? md_thread+0x12e/0x170
> [20963.177897]  ? remove_wait_queue+0x70/0x70
> [20963.182250]  kthread+0x109/0x140
> [20963.185713]  ? state_show+0x320/0x320
> [20963.189614]  ? kthread_park+0x60/0x60
> [20963.193584]  ? do_syscall_64+0x67/0x150
> [20963.197651]  ret_from_fork+0x25/0x30
> [20963.201479] Code: 02 00 00 f0 0f ba 30 07 0f 83 03 ed ff ff 49 8d 
> bf b8 02 00 00 31 c9 ba 01 00 00 00 be 03 00 00 00 e8 e1 55 96 f9 e9 
> e6 ec ff ff <0f> ff e9 6c ec ff ff 0f 0b 45 85 e4 0f 88 1e fd ff ff 0f 
> 1f 44
> [20963.221066] ---[ end trace f4ae42a7bfec8d28 ]---
> [20963.225987] ------------[ cut here ]------------
> [20963.230891] WARNING: CPU: 23 PID: 1258 at drivers/md/raid5.c:4893 
> handle_stripe+0x1df4/0x2160 [raid456]
> [20963.240764] Modules linked in: binfmt_misc xt_nat veth 8021q garp 
> mrp xfs xt_addrtype br_netfilter vhost_net vhost macvtap macvlan tap 
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 
> iptable_nat nf_nat_ipv4 nf_nat tun bridge stp llc ebtable_filter 
> ebtables bonding cfg80211 rfkill ip6t_REJECT nf_reject_ipv6 
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 
> xt_conntrack nf_conntrack ip6table_filter ip6_tables jc42 joydev 
> ipmi_si amd64_edac_mod edac_mce_amd kvm_amd kvm irqbypass 
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ipmi_devintf 
> ipmi_msghandler sp5100_tco fam15h_power k10temp i2c_piix4 tpm_tis 
> shpchp tpm_tis_core tpm acpi_cpufreq dm_thin_pool dm_persistent_data 
> dm_bio_prison raid456 libcrc32c async_raid6_recov async_memcpy 
> async_pq async_xor async_tx btrfs
> [20963.313845]  xor raid6_pq bcache raid10 igb drm_kms_helper ttm 
> mvsas ptp drm crc32c_intel libsas serio_raw mpt3sas pps_core be2net 
> raid_class dca scsi_transport_sas i2c_algo_bit
> [20963.330317] CPU: 23 PID: 1258 Comm: md2_raid6 Tainted: G W       
> 4.13.15-100.fc25.x86_64 #1
> [20963.339703] Hardware name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 
> 3.0a       07/26/2013
> [20963.348345] task: ffff88180aa7a640 task.stack: ffff9ad948254000
> [20963.354546] RIP: 0010:handle_stripe+0x1df4/0x2160 [raid456]
> [20963.360391] RSP: 0018:ffff9ad948257bc8 EFLAGS: 00010246
> [20963.365904] RAX: 0000000000200100 RBX: 00000000ffffffff RCX: 
> 0000000000000001
> [20963.373334] RDX: 0000000000000001 RSI: 0000000000200100 RDI: 
> 0000000000000000
> [20963.380745] RBP: ffff9ad948257cd8 R08: 0000000000000001 R09: 
> 0000000000000000
> [20963.388147] R10: 0000000000000000 R11: 0000000000000000 R12: 
> 0000000000000007
> [20963.395564] R13: ffff8805c8dd8ca0 R14: 0000000000000007 R15: 
> ffff88120a856000
> [20963.402990] FS:  0000000000000000(0000) GS:ffff88120fdc0000(0000) 
> knlGS:0000000000000000
> [20963.411522] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [20963.417550] CR2: 00007f878e68e000 CR3: 000000111be09000 CR4: 
> 00000000000406e0
> [20963.424961] Call Trace:
> [20963.427652]  ? default_wake_function+0x12/0x20
> [20963.432373]  ? autoremove_wake_function+0x33/0x60
> [20963.437358]  ? __wake_up_common+0x70/0x90
> [20963.441652]  handle_active_stripes.isra.57+0x3b6/0x5e0 [raid456]
> [20963.447913]  raid5d+0x4db/0x730 [raid456]
> [20963.452175]  ? del_timer_sync+0x39/0x40
> [20963.456301]  ? prepare_to_wait_event+0x75/0x170
> [20963.461113]  md_thread+0x12e/0x170
> [20963.464785]  ? md_thread+0x12e/0x170
> [20963.468659]  ? remove_wait_queue+0x70/0x70
> [20963.473034]  kthread+0x109/0x140
> [20963.476518]  ? state_show+0x320/0x320
> [20963.480447]  ? kthread_park+0x60/0x60
> [20963.484398]  ? do_syscall_64+0x67/0x150
> [20963.488471]  ret_from_fork+0x25/0x30
> [20963.492308] Code: 02 00 00 f0 0f ba 30 07 0f 83 03 ed ff ff 49 8d 
> bf b8 02 00 00 31 c9 ba 01 00 00 00 be 03 00 00 00 e8 e1 55 96 f9 e9 
> e6 ec ff ff <0f> ff e9 6c ec ff ff 0f 0b 45 85 e4 0f 88 1e fd ff ff 0f 
> 1f 44
