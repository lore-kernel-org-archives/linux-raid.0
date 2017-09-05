From: Petr Janecek <janecek@ucw.cz>
Subject: Oops on raid10 resync on v4.12.2
Date: Tue, 5 Sep 2017 02:39:12 +0200
Message-ID: <20170905003911.GA30169@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

a md resync got stuck

  # cat /proc/mdstat
  Personalities : [raid10] [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] 
  md1 : active raid10 sdo[0] sdn[4] sdd[6] sdc[5]
        7813774336 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
        [======>..............]  check = 30.7% (2403684800/7813774336)
  finish=5065414.3min speed=17K/sec
        
  unused devices: <none>

with the following BUG in dmesg.  After reboot, the array looks synced.

[215405.418478] md: data-check of RAID array md1
[216151.434963] perf: interrupt took too long (4120 > 4060), lowering kernel.perf_event_max_sample_rate to 48500
[222683.851914] BUG: unable to handle kernel paging request at ffffffffc0323a3f
[222683.859086] IP: report_bug+0x8f/0x120
[222683.862941] PGD 40280c067 
[222683.862941] P4D 40280c067 
[222683.865835] PUD 40280e067 
[222683.868729] PMD 854103067 
[222683.871624] PTE 800000085049b161

[222683.879617] Oops: 0003 [#1] SMP
[222683.882943] Modules linked in: x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass crc32_pclmul ghash_clmulni_intel xfs pcbc aesni_intel aes_x86_64 crypto_simd cryptd iTCO_wdt glue_helper pcspkr iTCO_vendor_support mei_me evdev mei sg ipmi_si ipmi_devintf battery tpm_tis ipmi_msghandler video tpm_tis_core acpi_power_meter shpchp ie31200_edac tpm button loop nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc ip_tables x_tables autofs4 btrfs raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear raid10 uas md_mod usb_storage sd_mod hid_generic usbhid hid xhci_pci ahci xhci_hcd libahci igb i2c_algo_bit mpt3sas i2c_i801 dca raid_class usbcore ptp scsi_transport_sas crc32c_intel libata i2c_core usb_common
  pps_core scsi_mod
[222683.954438]  fan thermal
[222683.957181] CPU: 1 PID: 4622 Comm: md1_resync Not tainted 4.12.2 #15
[222683.963739] Hardware name: Supermicro Super Server/X11SSL-CF, BIOS 1.0a 01/29/2016
[222683.971532] task: ffff88101728ef40 task.stack: ffffa565854b8000
[222683.977659] RIP: 0010:report_bug+0x8f/0x120
[222683.982046] RSP: 0018:ffffa565854bba40 EFLAGS: 00010202
[222683.987480] RAX: 0000000000000907 RBX: ffffffffc0321930 RCX: ffffffffc0323a35
[222683.994838] RDX: 0000000000000001 RSI: 000000000000030b RDI: 0000000000000001
[222684.002196] RBP: ffffa565854bbb78 R08: 0000000000000000 R09: 0000000000000260
[222684.009555] R10: ffffffffaa807a80 R11: ffffffffc0321930 R12: ffffffffc0323994
[222684.016913] R13: 0000000000000006 R14: 0000000000000004 R15: ffffffffaa718d16
[222684.024271] FS:  0000000000000000(0000) GS:ffff881037840000(0000) knlGS:0000000000000000
[222684.032582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[222684.038528] CR2: ffffffffc0323a3f CR3: 000000040280b000 CR4: 00000000003406e0
[222684.045885] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[222684.053244] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[222684.060605] Call Trace:
[222684.063258]  ? fixup_bug+0x20/0x40
[222684.066862]  ? do_trap+0x124/0x170
[222684.070467]  ? do_error_trap+0x6b/0xc0
[222684.074423]  ? raid10_sync_request+0x1320/0x1a70 [raid10]
[222684.080029]  ? r10buf_pool_alloc+0x110/0x340 [raid10]
[222684.085289]  ? invalid_op+0x18/0x20
[222684.088980]  ? raid10_sync_request+0x1320/0x1a70 [raid10]
[222684.094579]  ? raid10_sync_request+0x995/0x1a70 [raid10]
[222684.100091]  ? vtime_account_system+0x9/0x30
[222684.104564]  ? finish_task_switch+0xa4/0x250
[222684.109037]  ? __schedule+0x22f/0x7b0
[222684.112904]  ? is_mddev_idle+0xa2/0x107 [md_mod]
[222684.117721]  ? md_do_sync+0x85f/0xe50 [md_mod]
[222684.122369]  ? wake_atomic_t_function+0x50/0x50
[222684.127107]  ? md_thread+0x105/0x130 [md_mod]
[222684.131666]  ? md_thread+0x105/0x130 [md_mod]
[222684.136226]  ? kthread+0xf7/0x130
[222684.139745]  ? find_pers+0x60/0x60 [md_mod]
[222684.144130]  ? kthread_create_on_node+0x40/0x40
[222684.148862]  ? do_syscall_64+0x66/0x150
[222684.152900]  ? SyS_exit_group+0xb/0x10
[222684.156854]  ? ret_from_fork+0x22/0x30
[222684.160806] Code: 74 57 0f b7 41 0a 4c 63 61 04 0f b7 71 08 89 c7 49 01 cc 83 e7 01 a8 02 74 15 66 85 ff 74 10 a8 04 ba 01 00 00 00 75 26 83 c8 04 <66> 89 41 0a 66 85 ff 74 47 0f b6 49 0b 48 89 da 45 31 c9 49 89 
[222684.179935] RIP: report_bug+0x8f/0x120 RSP: ffffa565854bba40
[222684.185802] CR2: ffffffffc0323a3f
[222684.189323] ---[ end trace a40a895c82496274 ]---


Regards,

Petr Janecek
