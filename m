From: Marc MERLIN <marc@merlins.org>
Subject: kernel watchdog: EIP: [<f85d42fa>] handle_stripe+0x24b/0x18d7 [raid456] SS:ESP 0068:ef189e54
Date: Mon, 23 Jan 2012 08:46:27 -0800
Message-ID: <20120123164627.GH589@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

I had swraid 5 crash on my server (3.1.0).

I cannot reproduce this, and I know I don't have the very latest kernel, but
the report might be useful, so here it is:

I removed /dev/sde without setting the drive faulty first.
Because I wasn't using the array, swraid didn't notice.

When I tried to do mdadm --set-faulty, I couldn't quite because my /dev/sde1
device was gone.
So, I figured I'd just access the array and let swraid figure out the device
was gone.

When I did so, this is what happened (captured on serial console):

Did kernel watchdog trigger too quickly?
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0                                       

Thanks,
Marc

sd 8:2:0:0: rejecting I/O to offline device
end_request: I/O error, dev sde, sector 2656224
Buffer I/O error on device sde, logical block 332028
Buffer I/O error on device sde, logical block 332029
Buffer I/O error on device sde, logical block 332030
Buffer I/O error on device sde, logical block 332031
Buffer I/O error on device sde, logical block 332032
Buffer I/O error on device sde, logical block 332033
Buffer I/O error on device sde, logical block 332034
Buffer I/O error on device sde, logical block 332035
sd 8:2:0:0: rejecting I/O to offline device
ata9.02: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0xf
ata9.02: SError: { PHYRdyChg CommWake DevExch }
ata9.00: revalidation failed (errno=-5)
ata9.03: revalidation failed (errno=-5)
md/raid:md5: Disk failure on sde1, disabling device.
md/raid:md5: Operation continuing on 4 devices.
BUG: unable to handle kernel NULL pointer dereference at 00000070
IP: [<f85d42fa>] handle_stripe+0x24b/0x18d7 [raid456]
*pdpt = 0000000012dd3001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 
Modules linked in: ppdev lp tun autofs4 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx sata_mv kl5kusb105 ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipt_REJECT xt_state xt_tcpudp ipt_LOG iptable_mangle iptable_filter ipv6 deflate zlib_deflate ctr twofish_generic twofish_i586 twofish_common camellia serpent cast5 des_generic cryptd aes_i586 aes_generic xcbc rmd160 sha512_generic sha256_generic crypto_null af_key isofs fuse blowfish cbc dm_crypt dm_mirror dm_region_hash dm_log lm85 hwmon_vid dm_snapshot dm_mod iptable_nat ip_tables nf_conntrack_ftp ipt_MASQUERADE nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 x_tables nf_conntrack sg st snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_cmipci snd_opl3_lib snd_ens1371 sn
 d_hwdep gameport snd_mpu401_uart snd_seq_midi snd_rawmidi snd_pcm_oss snd_ac97_codec ac97_bus snd_mixer_oss snd_pcm eeepc_wmi asus_wmi snd_seq_dummy rfkill snd_seq_oss snd_seq_midi_event snd_seq video pl2303 ati_remote usbserial pci_hotplug backlight snd_timer snd_seq_device wmi pcspkr processor parport_pc thermal_sys r8169 hwmon parport evdev button xhci_hcd intel_agp ehci_hcd sata_sil24 intel_gtt agpgart snd rtc_cmos i2c_i801 tpm_tis usbcore soundcore snd_page_alloc [last unloaded: kl5kusb105]

Pid: 6112, comm: md5_raid5 Not tainted 3.1.0-core2-volpreempt-noide-hm64-20111109 #1 System manufacturer System Product Name/P8H67-M PRO
EIP: 0060:[<f85d42fa>] EFLAGS: 00010002 CPU: 2
EIP is at handle_stripe+0x24b/0x18d7 [raid456]
EAX: 00008301 EBX: eed48ccc ECX: f0e0b128 EDX: 00008301
ESI: 00000000 EDI: eed48aa0 EBP: ef189f18 ESP: ef189e54
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process md5_raid5 (pid: 6112, ti=ef188000 task=f1888c80 task.ti=ef188000)
Stack:
 f59eac40 b07a6112 c06018e4 000454a9 c01f286f eed48ac8 f146a2a0 00008c3b
 ef189e88 00000010 ef6e2ab0 f0e0b000 ef189ea4 00000005 00000004 f0e0b000
 00000000 00000000 00000000 00000000 00000001 00000000 00000000 00000000
Call Trace:
 [<c01f286f>] ? release_sysfs_dirent+0x82/0x99
 [<f85d1573>] ? release_stripe+0x31/0x37 [raid456]
 [<f85d5d22>] raid5d+0x39c/0x3e7 [raid456]
 [<c0430a4d>] ? schedule+0x48/0x4a
 [<c0430cf2>] ? schedule_timeout+0x23/0x182
 [<c014504b>] ? finish_wait+0x44/0x49
 [<c03845ba>] md_thread+0xcf/0xe6
 [<c0144f96>] ? abort_exclusive_wait+0x61/0x61
 [<c03844eb>] ? md_register_thread+0xa6/0xa6
 [<c0144b2f>] kthread+0x62/0x67
 [<c0144acd>] ? kthread_worker_fn+0x10b/0x10b
 [<c043357e>] kernel_thread_helper+0x6/0xd
Code: 1c 83 c0 08 83 d2 00 3b 96 94 00 00 00 77 0f 72 08 3b 86 90 00 00 00 77 05 f0 80 4b 74 08 8b 43 74 f6 c4 80 74 21 f0 80 63 74 f7 <8b> 46 70 a8 02 75 10 c7 45 d0 01 00 00 00 f0 ff 86 98 00 00 00 
EIP: [<f85d42fa>] handle_stripe+0x24b/0x18d7 [raid456] SS:ESP 0068:ef189e54
CR2: 0000000000000070
---[ end trace 37fd70c74aeaa6d1 ]---
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
Pid: 0, comm: swapper Tainted: G      D     3.1.0-core2-volpreempt-noide-hm64-20111109 #1
Call Trace:
 [<c016c223>] ? touch_nmi_watchdog+0x52/0x52
 [<c042b8ba>] panic+0x4e/0x151
 [<c016c223>] ? touch_nmi_watchdog+0x52/0x52
 [<c016c294>] watchdog_overflow_callback+0x71/0x93
 [<c01782a9>] __perf_event_overflow+0x146/0x1b4
 [<c010c1c0>] ? x86_perf_event_set_period+0x19e/0x1a9
 [<c0178858>] perf_event_overflow+0x10/0x12
 [<c010eeb0>] intel_pmu_handle_irq+0x3da/0x42d
 [<c012d23b>] ? default_wake_function+0xb/0xd
 [<c010cebb>] perf_event_nmi_handler+0x3a/0x7c
 [<c01489f9>] notifier_call_chain+0x26/0x48
 [<c0148a3d>] atomic_notifier_call_chain+0xf/0x11
 [<c0148d4d>] notify_die+0x2d/0x30
 [<c0102be0>] do_nmi+0x58/0x245
 [<c0124ecc>] ? check_preempt_curr+0x27/0x62
 [<c0432df4>] nmi_stack_correct+0x2f/0x34
 [<c0432384>] ? _raw_spin_lock_irqsave+0x24/0x2d
 [<f85d155e>] release_stripe+0x1c/0x37 [raid456]
 [<f85d288d>] raid5_end_read_request+0x2cd/0x2ef [raid456]
 [<c0123085>] ? __enqueue_entity+0x63/0x69
 [<c0125954>] ? enqueue_task_fair+0x347/0x34f
 [<c01cdad7>] bio_endio+0x25/0x27
 [<c02688c4>] req_bio_endio.isra.34+0x98/0xa0
 [<c02689fc>] blk_update_request+0x130/0x2e4
 [<c0268bc4>] blk_update_bidi_request+0x14/0x51
 [<c02693c4>] blk_end_bidi_request+0x16/0x4e
 [<c0269406>] blk_end_request+0xa/0xc
 [<c031e72d>] scsi_io_completion+0x1b5/0x450
 [<c031e32a>] ? scsi_device_unbusy+0x76/0x7c
 [<c0318788>] scsi_finish_command+0xb9/0xc1
 [<c031e4f5>] scsi_softirq_done+0xd6/0xde
 [<c026cf18>] blk_done_softirq+0x54/0x61
 [<c0135941>] __do_softirq+0x78/0xfe
 [<c01358c9>] ? remote_softirq_receive+0x2e/0x2e
 <IRQ>  [<c0135b3d>] ? irq_exit+0x40/0x93
 [<c01039e4>] ? do_IRQ+0x7a/0x8e
 [<c0433570>] ? common_interrupt+0x30/0x38
 [<c01300e0>] ? copy_process+0x7d3/0xe68
 [<c02a4b8c>] ? intel_idle+0xbb/0xdf
 [<c0390cea>] ? cpuidle_idle_call+0x7f/0xb4
 [<c010157a>] ? cpu_idle+0x88/0xac
 [<c0414d28>] ? rest_init+0x58/0x5a
 [<c062c740>] ? start_kernel+0x325/0x32a
 [<c062c0a2>] ? i386_start_kernel+0xa2/0xaa
Rebooting in 20 seconds..
ACPI MEMORY or I/O RESET_REG.




-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
