From: Terry Hardie <thardie@instartlogic.com>
Subject: raid5 hard lockup
Date: Thu, 8 Jan 2015 12:02:17 -0800
Message-ID: <CANHB05smA-HA6wEyXu3MKdMUQC10TJ7zAfNCcMneg5YiZgU4Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm still trying to get discard on ext4 and RAID5 to work reliably. I
got a new hard lockup today:

[506487.336582] ------------[ cut here ]------------
[506487.336591] WARNING: CPU: 4 PID: 22829 at
/usr/local/src/linux-lts-trusty-3.13.0/kernel/watchdog.c:245
watchdog_overflow_callback+0x9a/0xc0()
[506487.336592] Watchdog detected hard LOCKUP on cpu 4
[506487.336593] Modules linked in: ast gpio_ich ttm drm_kms_helper drm
sysimgblt sysfillrect syscopyarea mei_me lpc_ich shpchp mei joydev
ioatdma wmi ipmi_si acpi_power_meter acpi_pad mac_hid lp parport
raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov
hid_generic usbhid hid igb mpt3sas(OX) dca configfs i2c_algo_bit
scsi_transport_sas ptp ahci libahci pps_core raid_class raid6_pq
async_tx raid1 raid0 multipath linear
[506487.336624] CPU: 4 PID: 22829 Comm: md3_raid5 Tainted: G
IOX 3.13.0-43-generic #72~precise1
[506487.336626] Hardware name: Supermicro SYS-2028TP-HC1R/X10DRT-P,
BIOS 1.0a 08/28/2014
[506487.336627]  00000000000000f5 ffff88103fc86ba8 ffffffff81757f91
0000000000000007
[506487.336631]  ffff88103fc86bf8 ffff88103fc86be8 ffffffff8106afcc
0000000000000000
[506487.336634]  ffff881028ca8000 0000000000000000 ffff88103fc86d18
0000000000000000
[506487.336637] Call Trace:
[506487.336638]  <NMI>  [<ffffffff81757f91>] dump_stack+0x46/0x58
[506487.336649]  [<ffffffff8106afcc>] warn_slowpath_common+0x8c/0xc0
[506487.336652]  [<ffffffff8106b0b6>] warn_slowpath_fmt+0x46/0x50
[506487.336654]  [<ffffffff811142aa>] watchdog_overflow_callback+0x9a/0xc0
[506487.336659]  [<ffffffff8114ed08>] __perf_event_overflow+0x98/0x230
[506487.336664]  [<ffffffff8102b188>] ? x86_perf_event_set_period+0xd8/0x150
[506487.336667]  [<ffffffff8114f604>] perf_event_overflow+0x14/0x20
[506487.336671]  [<ffffffff81032bc9>] intel_pmu_handle_irq+0x1d9/0x2d0
[506487.336675]  [<ffffffff81193711>] ? unmap_kernel_range_noflush+0x11/0x20
[506487.336681]  [<ffffffff8143df34>] ? ghes_copy_tofrom_phys+0x114/0x210
[506487.336685]  [<ffffffff81766674>] perf_event_nmi_handler+0x34/0x60
[506487.336688]  [<ffffffff81765dca>] nmi_handle.isra.3+0x8a/0x1a0
[506487.336690]  [<ffffffff8143eff0>] ?
ghes_print_estatus.constprop.10+0x70/0x70
[506487.336692]  [<ffffffff81765fc8>] default_do_nmi+0x58/0x240
[506487.336695]  [<ffffffff81766240>] do_nmi+0x90/0xd0
[506487.336697]  [<ffffffff817651e1>] end_repeat_nmi+0x1e/0x2e
[506487.336700]  [<ffffffff817644c9>] ? _raw_spin_lock_irqsave+0x49/0x60
[506487.336702]  [<ffffffff817644c9>] ? _raw_spin_lock_irqsave+0x49/0x60
[506487.336704]  [<ffffffff817644c9>] ? _raw_spin_lock_irqsave+0x49/0x60
[506487.336705]  <<EOE>>  [<ffffffffa0142890>]
release_inactive_stripe_list+0x50/0x160 [raid456]
[506487.336714]  [<ffffffffa014b12f>]
handle_active_stripes.isra.38+0x7f/0x190 [raid456]
[506487.336718]  [<ffffffffa014b758>] raid5d+0x198/0x2f0 [raid456]
[506487.336722]  [<ffffffff815d30a7>] md_thread+0x117/0x150
[506487.336727]  [<ffffffff810affe0>] ? __wake_up_sync+0x20/0x20
[506487.336729]  [<ffffffff815d2f90>] ? md_rdev_init+0x110/0x110
[506487.336732]  [<ffffffff8108fb59>] kthread+0xc9/0xe0
[506487.336735]  [<ffffffff8108fa90>] ? flush_kthread_worker+0xb0/0xb0
[506487.336737]  [<ffffffff8176d5bc>] ret_from_fork+0x7c/0xb0
[506487.336740]  [<ffffffff8108fa90>] ? flush_kthread_worker+0xb0/0xb0
[506487.336741] ---[ end trace 4423aa98b23bcd0f ]---
