From: Coly Li <colyli@suse.de>
Subject: a hard lockup in md raid5 sequential write (v4.7-rc7)
Date: Mon, 18 Jul 2016 16:55:04 +0800
Message-ID: <cd2e1d88-683c-81f7-c1e7-674d04ccdda1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

These days I observe a hard lockup in md raid5. This issue can be easily
reproduced in kernel v4.7-rc7 (up to commit:
47ef4ad2684d380dd6d596140fb79395115c3950) by this fio job file:

[global]
direct=1
thread=1
[job]
filename=/dev/md0
blocksize=8m
rw=write
name=raid5
lockmem=1
numjobs=40
write_bw_log=example
group_reporting=1
norandommap=1
log_avg_msec=0
runtime=600.0
iodepth=64
write_lat_log=example

Where md0 is a raid5 target assembled by 3 Memblaze (PBlaze3) PCIe SSDs.
This test runs on a dual 10-core processors Dell T7910 machine.

From the crash dump, dmesg of the panic by nmi watchdog timeout is,

[ 2330.544036] NMI watchdog: Watchdog detected hard LOCKUP on cpu
18.dModules linked in: raid456 async_raid6_recov async_memcpy libcrc32c
async_pq async_xor async_tx joydev st memdisk(O) memcon(O) af_packet
iscsi_ibft iscsi_boot_sysfs msr snd_hda_codec_hdmi intel_rapl sb_edac
raid1 edac_core x86_pkg_temp_thermal intel_powerclamp coretemp raid0
md_mod snd_hda_codec_realtek snd_hda_codec_generic kvm_intel kvm
snd_hda_intel irqbypass snd_hda_codec crct10dif_pclmul snd_hda_core
crc32_pclmul ghash_clmulni_intel snd_hwdep dm_mod aesni_intel aes_x86_64
snd_pcm mei_wdt e1000e igb iTCO_wdt lrw dcdbas iTCO_vendor_support
snd_timer gf128mul mei_me dell_smm_hwmon glue_helper serio_raw
ablk_helper cryptd snd lpc_ich pcspkr ptp i2c_i801 mei mptctl dca
mfd_core pps_core soundcore mptbase shpchp fjes tpm_tis tpm btrfs xor
raid6_pq hid_generic usbhid crc32c_intel nouveau video mxm_wmi
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt xhci_pci
fb_sys_fops ehci_pci xhci_hcd ehci_hcd sr_mod ttm cd
[ 2330.544036] CPU: 18 PID: 30308 Comm: kworker/u42:4 Tainted: G
  O    4.7.0-rc7-vanilla #1
[ 2330.544036] Hardware name: Dell Inc. Precision Tower 7910/0215PR,
BIOS A07 04/14/2015
[ 2330.544036] Workqueue: raid5wq raid5_do_work [raid456]
[ 2330.544036]  0000000000000000 ffff88103f405bb0 ffffffff813a6eea
0000000000000000
[ 2330.544036]  0000000000000000 ffff88103f405bc8 ffffffff8113c3e8
ffff8808dc7d8800
[ 2330.544036]  ffff88103f405c00 ffffffff81180f8c 0000000000000001
ffff88103f40a440
[ 2330.544036] Call Trace:
[ 2330.544036]  <NMI>  [<ffffffff813a6eea>] dump_stack+0x63/0x89
[ 2330.544036]  [<ffffffff8113c3e8>] watchdog_overflow_callback+0xc8/0xf0
[ 2330.544036]  [<ffffffff81180f8c>] __perf_event_overflow+0x7c/0x1b0
[ 2330.544036]  [<ffffffff8118b644>] perf_event_overflow+0x14/0x20
[ 2330.544036]  [<ffffffff8100bf57>] intel_pmu_handle_irq+0x1c7/0x460
[ 2330.544036]  [<ffffffff810053ad>] perf_event_nmi_handler+0x2d/0x50
[ 2330.544036]  [<ffffffff810312e1>] nmi_handle+0x61/0x140
[ 2330.544036]  [<ffffffff81031888>] default_do_nmi+0x48/0x130
[ 2330.544036]  [<ffffffff81031a5b>] do_nmi+0xeb/0x160
[ 2330.544036]  [<ffffffff816e5c71>] end_repeat_nmi+0x1a/0x1e
[ 2330.544036]  [<ffffffff810cbcc7>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 2330.544036]  [<ffffffff810cbcc7>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 2330.544036]  [<ffffffff810cbcc7>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 2330.544036]  <<EOE>>  [<ffffffff81193bbf>]
queued_spin_lock_slowpath+0xb/0xf
[ 2330.544036]  [<ffffffff816e31ff>] _raw_spin_lock_irq+0x2f/0x40
[ 2330.544036]  [<ffffffffa084c5d8>]
handle_active_stripes.isra.51+0x378/0x4f0 [raid456]
[ 2330.544036]  [<ffffffffa083f1a6>] ?
raid5_wakeup_stripe_thread+0x96/0x1b0 [raid456]
[ 2330.544036]  [<ffffffffa084cf1d>] raid5_do_work+0x8d/0x120 [raid456]
[ 2330.544036]  [<ffffffff8109b5bb>] process_one_work+0x14b/0x450
[ 2330.544036]  [<ffffffff8109b9eb>] worker_thread+0x12b/0x490
[ 2330.544036]  [<ffffffff8109b8c0>] ? process_one_work+0x450/0x450
[ 2330.544036]  [<ffffffff810a1599>] kthread+0xc9/0xe0
[ 2330.544036]  [<ffffffff816e3a9f>] ret_from_fork+0x1f/0x40
[ 2330.544036]  [<ffffffff810a14d0>] ? kthread_create_on_node+0x180/0x180
[ 2330.544036] Kernel panic - not syncing: Hard LOCKUP
[ 2330.544036] CPU: 18 PID: 30308 Comm: kworker/u42:4 Tainted: G
  O    4.7.0-rc7-vanilla #1
[ 2330.544036] Hardware name: Dell Inc. Precision Tower 7910/0215PR,
BIOS A07 04/14/2015
[ 2330.544036] Workqueue: raid5wq raid5_do_work [raid456]
[ 2330.544036]  0000000000000000 ffff88103f405b28 ffffffff813a6eea
ffffffff81a45241
[ 2330.544036]  0000000000000000 ffff88103f405ba0 ffffffff81193642
0000000000000010
[ 2330.544036]  ffff88103f405bb0 ffff88103f405b50 0000000000000086
ffffffff81a2a2e2
[ 2330.544036] Call Trace:
[ 2330.544036]  <NMI>  [<ffffffff813a6eea>] dump_stack+0x63/0x89
[ 2330.544036]  [<ffffffff81193642>] panic+0xd2/0x223
[ 2330.544036]  [<ffffffff810823af>] nmi_panic+0x3f/0x40
[ 2330.544036]  [<ffffffff8113c401>] watchdog_overflow_callback+0xe1/0xf0
[ 2330.544036]  [<ffffffff81180f8c>] __perf_event_overflow+0x7c/0x1b0
[ 2330.544036]  [<ffffffff8118b644>] perf_event_overflow+0x14/0x20
[ 2330.544036]  [<ffffffff8100bf57>] intel_pmu_handle_irq+0x1c7/0x460
[ 2330.544036]  [<ffffffff810053ad>] perf_event_nmi_handler+0x2d/0x50
[ 2330.544036]  [<ffffffff810312e1>] nmi_handle+0x61/0x140
[ 2330.544036]  [<ffffffff81031888>] default_do_nmi+0x48/0x130
[ 2330.544036]  [<ffffffff81031a5b>] do_nmi+0xeb/0x160
[ 2330.544036]  [<ffffffff816e5c71>] end_repeat_nmi+0x1a/0x1e
[ 2330.544036]  [<ffffffff810cbcc7>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 2330.544036]  [<ffffffff810cbcc7>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 2330.544036]  [<ffffffff810cbcc7>] ?
native_queued_spin_lock_slowpath+0x117/0x1a0
[ 2330.544036]  <<EOE>>  [<ffffffff81193bbf>]
queued_spin_lock_slowpath+0xb/0xf
[ 2330.544036]  [<ffffffff816e31ff>] _raw_spin_lock_irq+0x2f/0x40
[ 2330.544036]  [<ffffffffa084c5d8>]
handle_active_stripes.isra.51+0x378/0x4f0 [raid456]
[ 2330.544036]  [<ffffffffa083f1a6>] ?
raid5_wakeup_stripe_thread+0x96/0x1b0 [raid456]
[ 2330.544036]  [<ffffffffa084cf1d>] raid5_do_work+0x8d/0x120 [raid456]
[ 2330.544036]  [<ffffffff8109b5bb>] process_one_work+0x14b/0x450
[ 2330.544036]  [<ffffffff8109b9eb>] worker_thread+0x12b/0x490
[ 2330.544036]  [<ffffffff8109b8c0>] ? process_one_work+0x450/0x450
[ 2330.544036]  [<ffffffff810a1599>] kthread+0xc9/0xe0
[ 2330.544036]  [<ffffffff816e3a9f>] ret_from_fork+0x1f/0x40
[ 2330.544036]  [<ffffffff810a14d0>] ? kthread_create_on_node+0x180/0x180

The crash dump file is quite big (124MB), I need to find a method to
share, if anyone of you wants it, please let me know.

IMHO, this hard lockup seems related to bitmap allocation, because it
can be easily reproduced on a new-created md raid5 target, with 40+
processes doing big size (8MB+) writing.

Thanks.

Coly
