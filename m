From: Petr Janecek <janecek@ucw.cz>
Subject: WARNING: at kernel/sched/core.c:7331 __might_sleep+0xa6/0xb0()
 during boot
Date: Fri, 17 Apr 2015 09:56:32 +0200
Message-ID: <20150417075631.GA5386@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hello,
      I'm getting these warnings once during boot since 3.19.0. The fs
is on lvm on md raid1.

[   57.217167] ------------[ cut here ]------------
[   57.221800] WARNING: CPU: 4 PID: 1071 at kernel/sched/core.c:7331 __might_sleep+0xa6/0xb0()
[   57.230184] do not call blocking ops when !TASK_RUNNING; state=2 set at [<ffffffff81085d1b>] prepare_to_wait+0x2b/0xa0
[   57.240886] Modules linked in: xt_multiport iptable_filter ip_tables x_tables cn dummy bridge stp llc xfs libcrc32c coretemp kvm_intel kvm iTCO_wdt microcode evdev iTCO_vendor_support psmouse serio_raw tpm_infineon tpm_tis tpm i7core_edac edac_core i2c_i801 button lpc_ich mfd_core i2c_core acpi_cpufreq processor thermal_sys hwmon_vid loop ipmi_watchdog ipmi_si ipmi_poweroff ipmi_devintf ipmi_msghandler fuse autofs4 btrfs xor raid6_pq dm_mod raid1 md_mod sg sd_mod hid_generic usbhid hid e1000e ptp crc32c_intel ahci libahci libata ehci_pci ehci_hcd scsi_mod pps_core usbcore usb_common
[   57.274503] CPU: 4 PID: 1071 Comm: freshclam Not tainted 3.19.4 #72
[   57.274503] Hardware name: Supermicro X8SIL/X8SIL, BIOS 1.1 05/27/2010
[   57.274504]  ffffffff8179723f ffff88022fedb2a8 ffffffff814f70f3 ffffffff81089bf9
[   57.274507]  ffff88022fedb2f8 ffff88022fedb2e8 ffffffff81049bc5 ffff88023466e540
[   57.274509]  ffffffff817af863 00000000000006f6 0000000000000000 ffff88023625d800
[   57.274511] Call Trace:
[   57.274512]  [<ffffffff814f70f3>] dump_stack+0x4c/0x65
[   57.274518]  [<ffffffff81089bf9>] ? down_trylock+0x29/0x40
[   57.274521]  [<ffffffff81049bc5>] warn_slowpath_common+0x85/0xc0
[   57.274524]  [<ffffffff81049c41>] warn_slowpath_fmt+0x41/0x50
[   57.274526]  [<ffffffff81085d1b>] ? prepare_to_wait+0x2b/0xa0
[   57.274527]  [<ffffffff81085d1b>] ? prepare_to_wait+0x2b/0xa0
[   57.274529]  [<ffffffff8106df86>] __might_sleep+0xa6/0xb0
[   57.274532]  [<ffffffff81282beb>] generic_make_request_checks+0x2b/0x400
[   57.274534]  [<ffffffff8108eb6d>] ? trace_hardirqs_on_caller+0x15d/0x200
[   57.274537]  [<ffffffff8108ec1d>] ? trace_hardirqs_on+0xd/0x10
[   57.274539]  [<ffffffff81282fd3>] generic_make_request+0x13/0x120
[   57.274541]  [<ffffffffa02f95e8>] raid1_unplug+0x108/0x160 [raid1]
[   57.274544]  [<ffffffff812878d2>] blk_flush_plug_list+0xa2/0x240
[   57.274546]  [<ffffffff8108ec1d>] ? trace_hardirqs_on+0xd/0x10
[   57.274548]  [<ffffffff814f9510>] ? bit_wait_timeout+0x80/0x80
[   57.274550]  [<ffffffff814f8cad>] io_schedule+0x7d/0x150
[   57.274552]  [<ffffffff814f953f>] bit_wait_io+0x2f/0x50
[   57.274553]  [<ffffffff814f90cf>] __wait_on_bit+0x5f/0x90
[   57.274555]  [<ffffffff814f9510>] ? bit_wait_timeout+0x80/0x80
[   57.274556]  [<ffffffff814f916d>] out_of_line_wait_on_bit+0x6d/0x80
[   57.274558]  [<ffffffff810860e0>] ? autoremove_wake_function+0x40/0x40
[   57.274559]  [<ffffffff811b0b2f>] __wait_on_buffer+0x3f/0x50
[   57.274562]  [<ffffffff811f64e0>] ext4_wait_block_bitmap.part.10+0xc0/0xd0
[   57.274566]  [<ffffffff811f6509>] ext4_wait_block_bitmap+0x19/0x20
[   57.274567]  [<ffffffff81230ef3>] ext4_mb_init_cache+0x203/0x780
[   57.274570]  [<ffffffff811207e9>] ? lru_cache_add+0x9/0x10
[   57.274574]  [<ffffffff8123158e>] ext4_mb_init_group+0x11e/0x210
[   57.274575]  [<ffffffff812317ab>] ext4_mb_good_group+0x12b/0x1a0
[   57.274577]  [<ffffffff81234b38>] ext4_mb_regular_allocator+0x1b8/0x460
[   57.274579]  [<ffffffff8122ffe0>] ? ext4_mb_use_preallocated.constprop.27+0x40/0x350
[   57.274580]  [<ffffffff8122f6fd>] ? ext4_mb_initialize_context+0x6d/0x1b0
[   57.274582]  [<ffffffff81236830>] ext4_mb_new_blocks+0x480/0x600
[   57.274584]  [<ffffffff8122b27d>] ext4_ext_map_blocks+0x62d/0xeb0
[   57.274586]  [<ffffffff811feb53>] ext4_map_blocks+0x133/0x560
[   57.274588]  [<ffffffff81201ed0>] ext4_writepages+0x560/0xdb0
[   57.274590]  [<ffffffff8111e3ac>] do_writepages+0x1c/0x30
[   57.274592]  [<ffffffff811128d1>] __filemap_fdatawrite_range+0x51/0x60
[   57.274595]  [<ffffffff81112977>] filemap_flush+0x17/0x20
[   57.274597]  [<ffffffff811ff851>] ext4_alloc_da_blocks+0x41/0x90
[   57.274598]  [<ffffffff8120ce0c>] ext4_rename+0x62c/0x880
[   57.274601]  [<ffffffff8108e9e1>] ? mark_held_locks+0x71/0xa0
[   57.274603]  [<ffffffff814faa3e>] ? mutex_lock_nested+0x22e/0x3b0
[   57.274605]  [<ffffffff8120d078>] ext4_rename2+0x18/0x40
[   57.274606]  [<ffffffff811897c2>] vfs_rename+0x3a2/0x7e0
[   57.274609]  [<ffffffff8118c8b0>] SYSC_renameat2+0x5b0/0x620
[   57.274610]  [<ffffffff814fe3e1>] ? _raw_spin_unlock_irqrestore+0x31/0x50
[   57.274613]  [<ffffffff81085bd8>] ? remove_wait_queue+0x48/0x50
[   57.274615]  [<ffffffff8104cb98>] ? do_wait+0x198/0x2c0
[   57.274617]  [<ffffffff8108eb6d>] ? trace_hardirqs_on_caller+0x15d/0x200
[   57.274618]  [<ffffffff812b7b1b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   57.274621]  [<ffffffff8118dba9>] SyS_rename+0x19/0x20
[   57.274623]  [<ffffffff814fecb2>] system_call_fastpath+0x12/0x17
[   57.274626] ---[ end trace b4ab91b16fa597a6 ]---


Thanks,

Petr Janecek
