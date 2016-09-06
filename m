From: Coly Li <colyli@suse.de>
Subject: Re: a hard lockup in md raid5 sequential write (v4.7-rc7)
Date: Wed, 7 Sep 2016 00:46:34 +0800
Message-ID: <ee565318-2e2c-c895-158f-5401950bbc62@suse.de>
References: <cd2e1d88-683c-81f7-c1e7-674d04ccdda1@suse.de>
 <20160719233556.GC79792@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160719233556.GC79792@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ÔÚ 16/7/20 ÉÏÎç7:35, Shaohua Li Ð´µÀ:
> On Mon, Jul 18, 2016 at 04:55:04PM +0800, Coly Li wrote:
>> Hi,
>>
>> These days I observe a hard lockup in md raid5. This issue can be easily
>> reproduced in kernel v4.7-rc7 (up to commit:
>> 47ef4ad2684d380dd6d596140fb79395115c3950) by this fio job file:
>>
>> [global]
>> direct=1
>> thread=1
>> [job]
>> filename=/dev/md0
>> blocksize=8m
>> rw=write
>> name=raid5
>> lockmem=1
>> numjobs=40
>> write_bw_log=example
>> group_reporting=1
>> norandommap=1
>> log_avg_msec=0
>> runtime=600.0
>> iodepth=64
>> write_lat_log=example
>>
>> Where md0 is a raid5 target assembled by 3 Memblaze (PBlaze3) PCIe SSDs.
>> This test runs on a dual 10-core processors Dell T7910 machine.
>>
>> From the crash dump, dmesg of the panic by nmi watchdog timeout is,
>>
>> [ 2330.544036] NMI watchdog: Watchdog detected hard LOCKUP on cpu
>> 18.dModules linked in: raid456 async_raid6_recov async_memcpy libcrc32c
>> async_pq async_xor async_tx joydev st memdisk(O) memcon(O) af_packet
>> iscsi_ibft iscsi_boot_sysfs msr snd_hda_codec_hdmi intel_rapl sb_edac
>> raid1 edac_core x86_pkg_temp_thermal intel_powerclamp coretemp raid0
>> md_mod snd_hda_codec_realtek snd_hda_codec_generic kvm_intel kvm
>> snd_hda_intel irqbypass snd_hda_codec crct10dif_pclmul snd_hda_core
>> crc32_pclmul ghash_clmulni_intel snd_hwdep dm_mod aesni_intel aes_x86_64
>> snd_pcm mei_wdt e1000e igb iTCO_wdt lrw dcdbas iTCO_vendor_support
>> snd_timer gf128mul mei_me dell_smm_hwmon glue_helper serio_raw
>> ablk_helper cryptd snd lpc_ich pcspkr ptp i2c_i801 mei mptctl dca
>> mfd_core pps_core soundcore mptbase shpchp fjes tpm_tis tpm btrfs xor
>> raid6_pq hid_generic usbhid crc32c_intel nouveau video mxm_wmi
>> i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt xhci_pci
>> fb_sys_fops ehci_pci xhci_hcd ehci_hcd sr_mod ttm cd
>> [ 2330.544036] CPU: 18 PID: 30308 Comm: kworker/u42:4 Tainted: G
>>   O    4.7.0-rc7-vanilla #1
>> [ 2330.544036] Hardware name: Dell Inc. Precision Tower 7910/0215PR,
>> BIOS A07 04/14/2015
>> [ 2330.544036] Workqueue: raid5wq raid5_do_work [raid456]
>> [ 2330.544036]  0000000000000000 ffff88103f405bb0 ffffffff813a6eea
>> 0000000000000000
>> [ 2330.544036]  0000000000000000 ffff88103f405bc8 ffffffff8113c3e8
>> ffff8808dc7d8800
>> [ 2330.544036]  ffff88103f405c00 ffffffff81180f8c 0000000000000001
>> ffff88103f40a440
>> [ 2330.544036] Call Trace:
>> [ 2330.544036]  <NMI>  [<ffffffff813a6eea>] dump_stack+0x63/0x89
>> [ 2330.544036]  [<ffffffff8113c3e8>] watchdog_overflow_callback+0xc8/0xf0
>> [ 2330.544036]  [<ffffffff81180f8c>] __perf_event_overflow+0x7c/0x1b0
>> [ 2330.544036]  [<ffffffff8118b644>] perf_event_overflow+0x14/0x20
>> [ 2330.544036]  [<ffffffff8100bf57>] intel_pmu_handle_irq+0x1c7/0x460
>> [ 2330.544036]  [<ffffffff810053ad>] perf_event_nmi_handler+0x2d/0x50
>> [ 2330.544036]  [<ffffffff810312e1>] nmi_handle+0x61/0x140
>> [ 2330.544036]  [<ffffffff81031888>] default_do_nmi+0x48/0x130
>> [ 2330.544036]  [<ffffffff81031a5b>] do_nmi+0xeb/0x160
>> [ 2330.544036]  [<ffffffff816e5c71>] end_repeat_nmi+0x1a/0x1e
>> [ 2330.544036]  [<ffffffff810cbcc7>] ?
>> native_queued_spin_lock_slowpath+0x117/0x1a0
>> [ 2330.544036]  [<ffffffff810cbcc7>] ?
>> native_queued_spin_lock_slowpath+0x117/0x1a0
>> [ 2330.544036]  [<ffffffff810cbcc7>] ?
>> native_queued_spin_lock_slowpath+0x117/0x1a0
>> [ 2330.544036]  <<EOE>>  [<ffffffff81193bbf>]
>> queued_spin_lock_slowpath+0xb/0xf
>> [ 2330.544036]  [<ffffffff816e31ff>] _raw_spin_lock_irq+0x2f/0x40
>> [ 2330.544036]  [<ffffffffa084c5d8>]
>> handle_active_stripes.isra.51+0x378/0x4f0 [raid456]
>> [ 2330.544036]  [<ffffffffa083f1a6>] ?
>> raid5_wakeup_stripe_thread+0x96/0x1b0 [raid456]
>> [ 2330.544036]  [<ffffffffa084cf1d>] raid5_do_work+0x8d/0x120 [raid456]
>> [ 2330.544036]  [<ffffffff8109b5bb>] process_one_work+0x14b/0x450
>> [ 2330.544036]  [<ffffffff8109b9eb>] worker_thread+0x12b/0x490
>> [ 2330.544036]  [<ffffffff8109b8c0>] ? process_one_work+0x450/0x450
>> [ 2330.544036]  [<ffffffff810a1599>] kthread+0xc9/0xe0
>> [ 2330.544036]  [<ffffffff816e3a9f>] ret_from_fork+0x1f/0x40
>> [ 2330.544036]  [<ffffffff810a14d0>] ? kthread_create_on_node+0x180/0x180
>> [ 2330.544036] Kernel panic - not syncing: Hard LOCKUP
>> [ 2330.544036] CPU: 18 PID: 30308 Comm: kworker/u42:4 Tainted: G
>>   O    4.7.0-rc7-vanilla #1
>> [ 2330.544036] Hardware name: Dell Inc. Precision Tower 7910/0215PR,
>> BIOS A07 04/14/2015
>> [ 2330.544036] Workqueue: raid5wq raid5_do_work [raid456]
>> [ 2330.544036]  0000000000000000 ffff88103f405b28 ffffffff813a6eea
>> ffffffff81a45241
>> [ 2330.544036]  0000000000000000 ffff88103f405ba0 ffffffff81193642
>> 0000000000000010
>> [ 2330.544036]  ffff88103f405bb0 ffff88103f405b50 0000000000000086
>> ffffffff81a2a2e2
>> [ 2330.544036] Call Trace:
>> [ 2330.544036]  <NMI>  [<ffffffff813a6eea>] dump_stack+0x63/0x89
>> [ 2330.544036]  [<ffffffff81193642>] panic+0xd2/0x223
>> [ 2330.544036]  [<ffffffff810823af>] nmi_panic+0x3f/0x40
>> [ 2330.544036]  [<ffffffff8113c401>] watchdog_overflow_callback+0xe1/0xf0
>> [ 2330.544036]  [<ffffffff81180f8c>] __perf_event_overflow+0x7c/0x1b0
>> [ 2330.544036]  [<ffffffff8118b644>] perf_event_overflow+0x14/0x20
>> [ 2330.544036]  [<ffffffff8100bf57>] intel_pmu_handle_irq+0x1c7/0x460
>> [ 2330.544036]  [<ffffffff810053ad>] perf_event_nmi_handler+0x2d/0x50
>> [ 2330.544036]  [<ffffffff810312e1>] nmi_handle+0x61/0x140
>> [ 2330.544036]  [<ffffffff81031888>] default_do_nmi+0x48/0x130
>> [ 2330.544036]  [<ffffffff81031a5b>] do_nmi+0xeb/0x160
>> [ 2330.544036]  [<ffffffff816e5c71>] end_repeat_nmi+0x1a/0x1e
>> [ 2330.544036]  [<ffffffff810cbcc7>] ?
>> native_queued_spin_lock_slowpath+0x117/0x1a0
>> [ 2330.544036]  [<ffffffff810cbcc7>] ?
>> native_queued_spin_lock_slowpath+0x117/0x1a0
>> [ 2330.544036]  [<ffffffff810cbcc7>] ?
>> native_queued_spin_lock_slowpath+0x117/0x1a0
>> [ 2330.544036]  <<EOE>>  [<ffffffff81193bbf>]
>> queued_spin_lock_slowpath+0xb/0xf
>> [ 2330.544036]  [<ffffffff816e31ff>] _raw_spin_lock_irq+0x2f/0x40
>> [ 2330.544036]  [<ffffffffa084c5d8>]
>> handle_active_stripes.isra.51+0x378/0x4f0 [raid456]
>> [ 2330.544036]  [<ffffffffa083f1a6>] ?
>> raid5_wakeup_stripe_thread+0x96/0x1b0 [raid456]
>> [ 2330.544036]  [<ffffffffa084cf1d>] raid5_do_work+0x8d/0x120 [raid456]
>> [ 2330.544036]  [<ffffffff8109b5bb>] process_one_work+0x14b/0x450
>> [ 2330.544036]  [<ffffffff8109b9eb>] worker_thread+0x12b/0x490
>> [ 2330.544036]  [<ffffffff8109b8c0>] ? process_one_work+0x450/0x450
>> [ 2330.544036]  [<ffffffff810a1599>] kthread+0xc9/0xe0
>> [ 2330.544036]  [<ffffffff816e3a9f>] ret_from_fork+0x1f/0x40
>> [ 2330.544036]  [<ffffffff810a14d0>] ? kthread_create_on_node+0x180/0x180
>>
>> The crash dump file is quite big (124MB), I need to find a method to
>> share, if anyone of you wants it, please let me know.
>>
>> IMHO, this hard lockup seems related to bitmap allocation, because it
>> can be easily reproduced on a new-created md raid5 target, with 40+
>> processes doing big size (8MB+) writing.
> 
> Hi,
> 
> Sounds like a deadlock. Can you enable lockdep and run the test again and see
> if lockdep gives any hint?

Hi Shaohua,

I reproduce the hard lockup on 4.8-rc5£¬this time I add lockdep but
information is very limited, here is the panic information,

[  616.690899] NMI watchdog: Watchdog detected hard LOCKUP on cpu
16.dModules linked in: af_packet iscsi_ibft iscsi_boot_sysfs msr
ipmi_ssif intel_rapl cdc_ether usbnet mii edac_core x86_pkg_temp_thermal
intel_powerclamp coretemp raid456 async_raid6_recov async_memcpy
libcrc32c async_pq async_xor async_tx kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64
ipmi_devintf lrw md_mod glue_helper ablk_helper cryptd pcspkr tg3
iTCO_wdt ptp iTCO_vendor_support pps_core i2c_i801 libphy i2c_smbus
mei_me lpc_ich mxm_wmi mfd_core mei shpchp ipmi_si ipmi_msghandler fjes
wmi tpm_tis tpm_tis_core acpi_pad button tpm hid_generic usbhid btrfs
xor zlib_deflate raid6_pq crc32c_intel megaraid_sas xhci_pci xhci_hcd
mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ttm drm ehci_pci ehci_hcd nvme usbcore usb_common nvme_core
sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua
[  616.690899] irq event stamp: 27052
[  616.690900] hardirqs last  enabled at (27051): [<ffffffff81104a15>]
vprintk_emit+0x1d5/0x550
[  616.690900] hardirqs last disabled at (27052): [<ffffffff817cbb5f>]
_raw_spin_lock_irq+0x1f/0x90
[  616.690901] softirqs last  enabled at (26668): [<ffffffff817cf857>]
__do_softirq+0x1f7/0x4b7
[  616.690901] softirqs last disabled at (26659): [<ffffffff8109803b>]
irq_exit+0xab/0xc0
[  616.690901] CPU: 16 PID: 11681 Comm: fio Not tainted 4.8.0-rc4-vanilla #2
[  616.690902] Hardware name: LENOVO System x3650 M5
-[546225Z]-/XXXXXXX, BIOS -[TCE123M-2.10]- 06/23/2016
[  616.690902]  0000000000000000 ffff880256c05ba8 ffffffff81438dec
0000000000000000
[  616.690903]  0000000000000010 ffff880256c05bc8 ffffffff8117ea7f
ffff88017dc4e800
[  616.690903]  0000000000000000 ffff880256c05c00 ffffffff811c6b5b
0000000000000001
[  616.690903] Call Trace:
[  616.690904]  <NMI>  [<ffffffff81438dec>] dump_stack+0x85/0xc9
[  616.690904]  [<ffffffff8117ea7f>] watchdog_overflow_callback+0x13f/0x160
[  616.690904]  [<ffffffff811c6b5b>] __perf_event_overflow+0x8b/0x1d0
[  616.690905]  [<ffffffff811d3f94>] perf_event_overflow+0x14/0x20
[  616.690905]  [<ffffffff8100c631>] intel_pmu_handle_irq+0x1d1/0x4a0
[  616.690906]  [<ffffffff8100582d>] perf_event_nmi_handler+0x2d/0x50
[  616.690906]  [<ffffffff810391ae>] nmi_handle+0x9e/0x2d0
[  616.690906]  [<ffffffff81039115>] ? nmi_handle+0x5/0x2d0
[  616.690906]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690907]  [<ffffffff81039631>] default_do_nmi+0x71/0x1b0
[  616.690907]  [<ffffffff8103988c>] do_nmi+0x11c/0x190
[  616.690907]  [<ffffffff817cdf91>] end_repeat_nmi+0x1a/0x1e
[  616.690908]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690908]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690909]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690909]  <<EOE>>  [<ffffffff81458d87>]
debug_smp_processor_id+0x17/0x20
[  616.690909]  [<ffffffff814465f2>] delay_tsc+0x22/0xc0
[  616.690910]  [<ffffffff8144650f>] __delay+0xf/0x20
[  616.690910]  [<ffffffff810f5626>] do_raw_spin_lock+0x86/0x130
[  616.690910]  [<ffffffff817cbbac>] _raw_spin_lock_irq+0x6c/0x90
[  616.690911]  [<ffffffffa083623b>] ?
raid5_get_active_stripe+0x6b/0x8c0 [raid456]
[  616.690911]  [<ffffffffa083623b>] raid5_get_active_stripe+0x6b/0x8c0
[raid456]
[  616.690911]  [<ffffffff817cbcaa>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[  616.690912]  [<ffffffff810e1352>] ? prepare_to_wait+0x62/0x90
[  616.690912]  [<ffffffffa0836c6a>] raid5_make_request+0x1da/0xb50
[raid456]
[  616.690912]  [<ffffffffa05082aa>] ? md_make_request+0x1fa/0x4f0 [md_mod]
[  616.690913]  [<ffffffff810e1810>] ? prepare_to_wait_event+0x100/0x100
[  616.690913]  [<ffffffffa05082aa>] md_make_request+0x1fa/0x4f0 [md_mod]
[  616.690914]  [<ffffffffa0508107>] ? md_make_request+0x57/0x4f0 [md_mod]
[  616.690914]  [<ffffffff814043f9>] generic_make_request+0x159/0x2c0
[  616.690914]  [<ffffffff810ea809>] ? get_lock_stats+0x19/0x60
[  616.690915]  [<ffffffff814045cd>] submit_bio+0x6d/0x150
[  616.690915]  [<ffffffff810ed69d>] ? trace_hardirqs_on+0xd/0x10
[  616.690915]  [<ffffffff812c28aa>] do_blockdev_direct_IO+0x163a/0x2630
[  616.690916]  [<ffffffff812bd780>] ? I_BDEV+0x20/0x20
[  616.690916]  [<ffffffff812c38da>] __blockdev_direct_IO+0x3a/0x40
[  616.690916]  [<ffffffff812bde7c>] blkdev_direct_IO+0x4c/0x70
[  616.690917]  [<ffffffff811e39a7>] generic_file_direct_write+0xa7/0x160
[  616.690917]  [<ffffffff811e3b1d>] __generic_file_write_iter+0xbd/0x1e0
[  616.690917]  [<ffffffff812be7b0>] ? bd_acquire+0xb0/0xb0
[  616.690918]  [<ffffffff812be822>] blkdev_write_iter+0x72/0xd0
[  616.690918]  [<ffffffff813dd648>] ? apparmor_file_permission+0x18/0x20
[  616.690918]  [<ffffffff813a38ed>] ? security_file_permission+0x3d/0xc0
[  616.690919]  [<ffffffff812d4549>] aio_run_iocb+0x239/0x2c0
[  616.690919]  [<ffffffff812d5703>] do_io_submit+0x233/0x860
[  616.690919]  [<ffffffff812d58aa>] ? do_io_submit+0x3da/0x860
[  616.690920]  [<ffffffff812d5d40>] SyS_io_submit+0x10/0x20
[  616.690920]  [<ffffffff817cc6c0>] entry_SYSCALL_64_fastpath+0x23/0xc1
[  616.690920]  [<ffffffff81458da3>] ? __this_cpu_preempt_check+0x13/0x20
[  616.690921] Kernel panic - not syncing: Hard LOCKUP
[  616.690921] CPU: 16 PID: 11681 Comm: fio Not tainted 4.8.0-rc4-vanilla #2
[  616.690921] Hardware name: LENOVO System x3650 M5
-[546225Z]-/XXXXXXX, BIOS -[TCE123M-2.10]- 06/23/2016
[  616.690922]  0000000000000000 ffff880256c05b20 ffffffff81438dec
0000000000000000
[  616.690922]  ffffffff81a69c3f ffff880256c05b98 ffffffff811dd399
0000000000000010
[  616.690922]  ffff880256c05ba8 ffff880256c05b48 0000000000000086
ffffffff81a4bcbe
[  616.690923] Call Trace:
[  616.690923]  <NMI>  [<ffffffff81438dec>] dump_stack+0x85/0xc9
[  616.690923]  [<ffffffff811dd399>] panic+0xe0/0x22c
[  616.690924]  [<ffffffff810905af>] nmi_panic+0x3f/0x40
[  616.690924]  [<ffffffff8117ea91>] watchdog_overflow_callback+0x151/0x160
[  616.690924]  [<ffffffff811c6b5b>] __perf_event_overflow+0x8b/0x1d0
[  616.690925]  [<ffffffff811d3f94>] perf_event_overflow+0x14/0x20
[  616.690925]  [<ffffffff8100c631>] intel_pmu_handle_irq+0x1d1/0x4a0
[  616.690925]  [<ffffffff8100582d>] perf_event_nmi_handler+0x2d/0x50
[  616.690926]  [<ffffffff810391ae>] nmi_handle+0x9e/0x2d0
[  616.690926]  [<ffffffff81039115>] ? nmi_handle+0x5/0x2d0
[  616.690926]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690927]  [<ffffffff81039631>] default_do_nmi+0x71/0x1b0
[  616.690927]  [<ffffffff8103988c>] do_nmi+0x11c/0x190
[  616.690927]  [<ffffffff817cdf91>] end_repeat_nmi+0x1a/0x1e
[  616.690928]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690928]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690929]  [<ffffffff81458ca3>] ? check_preemption_disabled+0x23/0xf0
[  616.690929]  <<EOE>>  [<ffffffff81458d87>]
debug_smp_processor_id+0x17/0x20
[  616.690929]  [<ffffffff814465f2>] delay_tsc+0x22/0xc0
[  616.690929]  [<ffffffff8144650f>] __delay+0xf/0x20
[  616.690930]  [<ffffffff810f5626>] do_raw_spin_lock+0x86/0x130
[  616.690930]  [<ffffffff817cbbac>] _raw_spin_lock_irq+0x6c/0x90
[  616.690931]  [<ffffffffa083623b>] ?
raid5_get_active_stripe+0x6b/0x8c0 [raid456]
[  616.690931]  [<ffffffffa083623b>] raid5_get_active_stripe+0x6b/0x8c0
[raid456]
[  616.690931]  [<ffffffff817cbcaa>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[  616.690932]  [<ffffffff810e1352>] ? prepare_to_wait+0x62/0x90
[  616.690932]  [<ffffffffa0836c6a>] raid5_make_request+0x1da/0xb50
[raid456]
[  616.690932]  [<ffffffffa05082aa>] ? md_make_request+0x1fa/0x4f0 [md_mod]
[  616.690933]  [<ffffffff810e1810>] ? prepare_to_wait_event+0x100/0x100
[  616.690933]  [<ffffffffa05082aa>] md_make_request+0x1fa/0x4f0 [md_mod]
[  616.690934]  [<ffffffffa0508107>] ? md_make_request+0x57/0x4f0 [md_mod]
[  616.690934]  [<ffffffff814043f9>] generic_make_request+0x159/0x2c0
[  616.690934]  [<ffffffff810ea809>] ? get_lock_stats+0x19/0x60
[  616.690935]  [<ffffffff814045cd>] submit_bio+0x6d/0x150
[  616.690935]  [<ffffffff810ed69d>] ? trace_hardirqs_on+0xd/0x10
[  616.690935]  [<ffffffff812c28aa>] do_blockdev_direct_IO+0x163a/0x2630
[  616.690936]  [<ffffffff812bd780>] ? I_BDEV+0x20/0x20
[  616.690936]  [<ffffffff812c38da>] __blockdev_direct_IO+0x3a/0x40
[  616.690936]  [<ffffffff812bde7c>] blkdev_direct_IO+0x4c/0x70
[  616.690937]  [<ffffffff811e39a7>] generic_file_direct_write+0xa7/0x160
[  616.690937]  [<ffffffff811e3b1d>] __generic_file_write_iter+0xbd/0x1e0
[  616.690937]  [<ffffffff812be7b0>] ? bd_acquire+0xb0/0xb0
[  616.690938]  [<ffffffff812be822>] blkdev_write_iter+0x72/0xd0
[  616.690938]  [<ffffffff813dd648>] ? apparmor_file_permission+0x18/0x20
[  616.690938]  [<ffffffff813a38ed>] ? security_file_permission+0x3d/0xc0
[  616.690939]  [<ffffffff812d4549>] aio_run_iocb+0x239/0x2c0
[  616.690939]  [<ffffffff812d5703>] do_io_submit+0x233/0x860
[  616.690939]  [<ffffffff812d58aa>] ? do_io_submit+0x3da/0x860
[  616.690940]  [<ffffffff812d5d40>] SyS_io_submit+0x10/0x20
[  616.690940]  [<ffffffff817cc6c0>] entry_SYSCALL_64_fastpath+0x23/0xc1
[  616.690940]  [<ffffffff81458da3>] ? __this_cpu_preempt_check+0x13/0x20

Only these 4 lines about irq stamps can be found,
[  616.690899] irq event stamp: 27052
[  616.690900] hardirqs last  enabled at (27051): [<ffffffff81104a15>]
vprintk_emit+0x1d5/0x550
[  616.690900] hardirqs last disabled at (27052): [<ffffffff817cbb5f>]
_raw_spin_lock_irq+0x1f/0x90
[  616.690901] softirqs last  enabled at (26668): [<ffffffff817cf857>]
__do_softirq+0x1f7/0x4b7
[  616.690901] softirqs last disabled at (26659): [<ffffffff8109803b>]
irq_exit+0xab/0xc0

I suspect this panic is introduced by r5conf->hash_locks[]. I have a
kdump image, I try to do some analyze, here is what I get,
from conf->hash_locks[], I see hash_locks[0] and hash_locks[7] have
rlock.raw_lock.val.count being 1, here is the crash output of each spin
lock,

hash_locks[0]:
{
        rlock = {
          raw_lock = {
            val = {
              counter = 1
            }
          },
          magic = 3735899821,
          owner_cpu = 13,
          owner = 0xffff880244ff80c0,
          dep_map = {
            key = 0xffffffffa0845bd0 <__key.47065>,
            class_cache = {0xffffffff828e6e70 <lock_classes+640336>, 0x0},
            name = 0xffffffffa083ec5f "&(conf->hash_locks)->rlock",
            cpu = 13,
            ip = 18446744072107549243
          }
        },
        {
          __padding =
"\001\000\000\000\255N\255\336\r\000\000\000\000\000\000\000\300\200\377D\002\210\377\377",

          dep_map = {
            key = 0xffffffffa0845bd0 <__key.47065>,
            class_cache = {0xffffffff828e6e70 <lock_classes+640336>, 0x0},
            name = 0xffffffffa083ec5f "&(conf->hash_locks)->rlock",
            cpu = 13,
            ip = 18446744072107549243
          }
        }
      }
    }


hash_locks[7]:
{
      {
        rlock = {
          raw_lock = {
            val = {
              counter = 1
            }
          },
          magic = 3735899821,
          owner_cpu = 19,
          owner = 0xffff88024716c340,
          dep_map = {
            key = 0xffffffffa0845bc8 <__key.47066>,
            class_cache = {0xffffffff828e7440 <lock_classes+641824>, 0x0},
            name = 0xffffffffa083f800 "&(conf->hash_locks + i)->rlock",
            cpu = 19,
            ip = 18446744072107549243
          }
        },
        {
          __padding =
"\001\000\000\000\255N\255\336\023\000\000\000\000\000\000\000@\303\026G\002\210\377\377",

          dep_map = {
            key = 0xffffffffa0845bc8 <__key.47066>,
            class_cache = {0xffffffff828e7440 <lock_classes+641824>, 0x0},
            name = 0xffffffffa083f800 "&(conf->hash_locks + i)->rlock",
            cpu = 19,
            ip = 18446744072107549243
          }
        }
      }
    }

From the above information, I see both locks acquire_ip is
18446744072107549243, then I check all 'fio' processes who acquire a
lock at this address. Then I found 12 threads acquiring a spin lock at
this address, but there are 2 lock instances.

For conf->hash_locks[0], the lockdep_map instance address is
0xffff880246f60820, content is,
struct lockdep_map {
  key = 0xffffffffa0845bd0 <__key.47065>,
  class_cache = {0xffffffff828e6e70 <lock_classes+640336>, 0x0},
  name = 0xffffffffa083ec5f "&(conf->hash_locks)->rlock",
  cpu = 13,
  ip = 18446744072107549243
}
there are 7 'fio' threads has this lock in their task_struct->held_locks
list,
 PID: 11629  TASK: ffff880251ba4f80  CPU: 3   COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60820,
 PID: 11643  TASK: ffff88022d331300  CPU: 10  COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60820,
 PID: 11648  TASK: ffff88024c3a1440  CPU: 14  COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60820,
 PID: 11652  TASK: ffff88024e1b5540  CPU: 5   COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60820,
 PID: 11653  TASK: ffff880229a70000  CPU: 12  COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60820,
 PID: 11656  TASK: ffff880244ff80c0  CPU: 13  COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60820,
 PID: 11657  TASK: ffff880243220100  CPU: 7   COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60820,

For conf->hash_lock[7], the lockdep_map instance address is
0xffff880246f60a18, content is,
struct lockdep_map {
  key = 0xffffffffa0845bc8 <__key.47066>,
  class_cache = {0xffffffff828e7440 <lock_classes+641824>, 0x0},
  name = 0xffffffffa083f800 "&(conf->hash_locks + i)->rlock",
  cpu = 19,
  ip = 18446744072107549243
}
there are 5 'fio' threads has this lock in their task_struct->held_locks
list,
 PID: 11663  TASK: ffff880242bb0280  CPU: 18  COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60a18,

 PID: 11666  TASK: ffff88024716c340  CPU: 19  COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60a18,

 PID: 11671  TASK: ffff880252504480  CPU: 1   COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60a18,

 PID: 11678  TASK: ffff88023735c640  CPU: 2   COMMAND: "fio"
       acquire_ip = 18446744072107549776,
       instance = 0xffff880246f60a18,

 PID: 11681  TASK: ffff880241a40700  CPU: 16  COMMAND: "fio"
       acquire_ip = 18446744072107549243,
       instance = 0xffff880246f60a18,

Unfortunately, I don't see the panic thread ID 11681 from the above 12
threads.

Currently I guess this hard lockup is triggered by a waiting task which
holds a spin lock. So I check all waiting list that r5conf may have,
    wait_queue_head_t wait_for_quiescent;
    wait_queue_head_t wait_for_stripe;
    wait_queue_head_t wait_for_overlap;
From crash output,
- conf->wait_for_quiescent is empty.
- conf->wait_for_stripe has 6 threads on it,
  PID: 11641  TASK: ffff880219a89280  CPU: 0   COMMAND: "fio"
  PID: 11685  TASK: ffff880228f6c800  CPU: 2   COMMAND: "fio"
  PID: 11628  TASK: ffff88017e0d8f40  CPU: 1   COMMAND: "fio"
  PID: 11672  TASK: ffff8802525fc4c0  CPU: 10  COMMAND: "fio"
  PID: 11638  TASK: ffff8801d27911c0  CPU: 1   COMMAND: "fio"
  PID: 11632  TASK: ffff88024cfc1040  CPU: 10  COMMAND: "fio"
- conf->wait_for_overlap has 5 threads on it,
  PID: 11657  TASK: ffff880243220100  CPU: 7   COMMAND: "fio"
  PID: 11629  TASK: ffff880251ba4f80  CPU: 3   COMMAND: "fio"
  PID: 11644  TASK: ffff88017e219340  CPU: 3   COMMAND: "fio"
  PID: 11636  TASK: ffff8802199e9140  CPU: 3   COMMAND: "fio"
  PID: 11630  TASK: ffff880250724fc0  CPU: 17  COMMAND: "fio"

What I find that might be interesting is, I see 2 threads (pid 11657,
pid 11629) are on conf->wait_for_overlap list, but they are also threads
which has conf->hash_locks[0] in their task->held_locks list.

I am not sure where this is the reason that IRQ is disabled too much time.

This hard lockup issue is very easy to be reproduced on fast storage
devices (e.g. NVMe SSDs), what I have are Memblaze Pblaze3 PCIe SSD. For
any debug information or testing, I am gald to do that. Currently I am
looking at this issue for a while, but progress is little.

Thanks in advance for taking a look on it.

Coly














