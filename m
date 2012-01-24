From: Marc MERLIN <marc@merlins.org>
Subject: Re: kernel watchdog: EIP: [<f85d42fa>] handle_stripe+0x24b/0x18d7 [raid456] SS:ESP 0068:ef189e54
Date: Tue, 24 Jan 2012 08:58:20 -0800
Message-ID: <20120124165820.GI30665@merlins.org>
References: <20120123164627.GH589@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120123164627.GH589@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 23, 2012 at 08:46:27AM -0800, Marc MERLIN wrote:
> Pid: 6112, comm: md5_raid5 Not tainted 3.1.0-core2-volpreempt-noide-hm64-20111109 #1 System manufacturer System Product Name/P8H67-M PRO
> EIP: 0060:[<f85d42fa>] EFLAGS: 00010002 CPU: 2
> EIP is at handle_stripe+0x24b/0x18d7 [raid456]
> EAX: 00008301 EBX: eed48ccc ECX: f0e0b128 EDX: 00008301
> ESI: 00000000 EDI: eed48aa0 EBP: ef189f18 ESP: ef189e54
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process md5_raid5 (pid: 6112, ti=ef188000 task=f1888c80 task.ti=ef188000)
> Stack:
>  f59eac40 b07a6112 c06018e4 000454a9 c01f286f eed48ac8 f146a2a0 00008c3b
>  ef189e88 00000010 ef6e2ab0 f0e0b000 ef189ea4 00000005 00000004 f0e0b000
>  00000000 00000000 00000000 00000000 00000001 00000000 00000000 00000000
> Call Trace:
>  [<c01f286f>] ? release_sysfs_dirent+0x82/0x99
>  [<f85d1573>] ? release_stripe+0x31/0x37 [raid456]
>  [<f85d5d22>] raid5d+0x39c/0x3e7 [raid456]
>  [<c0430a4d>] ? schedule+0x48/0x4a
>  [<c0430cf2>] ? schedule_timeout+0x23/0x182
>  [<c014504b>] ? finish_wait+0x44/0x49
>  [<c03845ba>] md_thread+0xcf/0xe6
>  [<c0144f96>] ? abort_exclusive_wait+0x61/0x61
>  [<c03844eb>] ? md_register_thread+0xa6/0xa6
>  [<c0144b2f>] kthread+0x62/0x67
>  [<c0144acd>] ? kthread_worker_fn+0x10b/0x10b
>  [<c043357e>] kernel_thread_helper+0x6/0xd
> Code: 1c 83 c0 08 83 d2 00 3b 96 94 00 00 00 77 0f 72 08 3b 86 90 00 00 00 77 05 f0 80 4b 74 08 8b 43 74 f6 c4 80 74 21 f0 80 63 74 f7 <8b> 46 70 a8 02 75 10 c7 45 d0 01 00 00 00 f0 ff 86 98 00 00 00 
> EIP: [<f85d42fa>] handle_stripe+0x24b/0x18d7 [raid456] SS:ESP 0068:ef189e54
> CR2: 0000000000000070
> ---[ end trace 37fd70c74aeaa6d1 ]---
> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0

Mmmh, this one is weird, I had one drive burp on my 2nd md5 array while
rebuilding the first md5 array.
This caused an ooops, and soon after the kernel locked up and rebooted.

Ok, 3.1.0 is a bit old now, maybe the bug is fixed already so I'll upgrade.

Crash logs are below if they are useful.

ata10.01: device reported invalid CHS sector 0
sd 9:1:0:0: [sdi]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 9:1:0:0: [sdi]  Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        00 00 00 00 
sd 9:1:0:0: [sdi]  Add. Sense: No additional sense information
sd 9:1:0:0: [sdi] CDB: Read(10): 28 00 05 71 d4 2f 00 00 48 00
end_request: I/O error, dev sdi, sector 91345967
ata10: EH complete
ata10.01: detaching (SCSI 9:1:0:0)
sd 9:1:0:0: [sdi] Synchronizing SCSI cache
sd 9:1:0:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 9:1:0:0: [sdi] Stopping disk
sd 9:1:0:0: [sdi] START_STOP FAILED
sd 9:1:0:0: [sdi]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
md/raid:md7: Disk failure on sdi1, disabling device.
md/raid:md7: Operation continuing on 4 devices.
RAID conf printout:
 --- level:5 rd:5 wd:4
 disk 0, o:1, dev:sdh1
 disk 1, o:1, dev:sdl1
 disk 2, o:1, dev:sdk1
 disk 3, o:1, dev:sdj1
 disk 4, o:0, dev:sdi1
RAID conf printout:
 --- level:5 rd:5 wd:4
 disk 0, o:1, dev:sdh1
 disk 1, o:1, dev:sdl1
 disk 2, o:1, dev:sdk1
 disk 3, o:1, dev:sdj1
BUG: unable to handle kernel NULL pointer dereference at 00000070
IP: [<f854d2fa>] handle_stripe+0x24b/0x18d7 [raid456]
*pdpt = 0000000000000000 *pde = f000eef3f000eef3 
Oops: 0000 [#1] SMP 
Modules linked in: ppdev lp tun autofs4 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx sata_mv kl5kusb105 ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipt_REJECT xt_state xt_tcpudp ipt_LOG iptable_mangle iptable_filter ipv6 deflate zlib_deflate ctr twofish_generic twofish_i586 twofish_common camellia serpent cast5 des_generic cryptd aes_i586 aes_generic xcbc rmd160 sha512_generic sha256_generic crypto_null af_key isofs fuse blowfish cbc dm_crypt dm_mirror dm_region_hash dm_log lm85 hwmon_vid dm_snapshot dm_mod iptable_nat ip_tables nf_conntrack_ftp ipt_MASQUERADE nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 x_tables nf_conntrack sg st snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_cmipci snd_opl3_lib ati_remote snd
 _hwdep snd_mpu401_uart snd_pcm_oss pl2303 snd_mixer_oss usbserial snd_ens1371 gameport snd_seq_midi snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device eeepc_wmi asus_wmi rfkill video snd backlight xhci_hcd pci_hotplug soundcore processor thermal_sys wmi snd_page_alloc parport_pc hwmon parport evdev button ehci_hcd rtc_cmos pcspkr usbcore i2c_i801 sata_sil24 tpm_tis intel_agp intel_gtt agpgart r8169 [last unloaded: ftdi_sio]

Pid: 6351, comm: md7_raid5 Not tainted 3.1.0-core2-volpreempt-noide-hm64-20111109 #1 System manufacturer System Product Name/P8H67-M PRO
EIP: 0060:[<f854d2fa>] EFLAGS: 00010002 CPU: 2
EIP is at handle_stripe+0x24b/0x18d7 [raid456]
EAX: 00008301 EBX: f15064b4 ECX: f2791b28 EDX: 00008301
ESI: 00000000 EDI: f1506288 EBP: edd45f18 ESP: edd45e54
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process md7_raid5 (pid: 6351, ti=edd44000 task=f253cb00 task.ti=edd44000)
Stack:
 f3844700 f231ca80 000e1f01 00000001 00000010 f15062b0 00000002 00000002
 c05fb19c 00000010 eeb24b00 f2791a00 eeb24b00 00000005 00000004 f2791a00
 00000000 00000000 00000000 00000000 00000001 00000000 00000000 00000000
Call Trace:
 [<f854a573>] ? release_stripe+0x31/0x37 [raid456]
 [<f854ed22>] raid5d+0x39c/0x3e7 [raid456]
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
EIP: [<f854d2fa>] handle_stripe+0x24b/0x18d7 [raid456] SS:ESP 0068:edd45e54
CR2: 0000000000000070
---[ end trace a521ee24ae7292e4 ]---

Then, soon later, soon after the server crashed with:
Pid: 6351, comm: md7_raid5 Not tainted 3.1.0-core2-volpreempt-noide-hm64-20111109 #1 System manufacturer System Pr oduct Name/P8H67-M PRO
EIP is at handle_stripe+0x24b/0x18d7 [raid456]
EAX: 00008301 EBX: f15064b4 ECX: f2791b28 EDX: 00008301
ESI: 00000000 EDI: f1506288 EBP: edd45f18 ESP: edd45e54
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process md7_raid5 (pid: 6351, ti=edd44000 task=f253cb00 task.ti=edd44000)
Stack:
 f3844700 f231ca80 000e1f01 00000001 00000010 f15062b0 00000002 00000002
 c05fb19c 00000010 eeb24b00 f2791a00 eeb24b00 00000005 00000004 f2791a00
 00000000 00000000 00000000 00000000 00000001 00000000 00000000 00000000
Call Trace:
 [<f854a573>] ? release_stripe+0x31/0x37 [raid456]
 [<f854ed22>] raid5d+0x39c/0x3e7 [raid456]
 [<c0430a4d>] ? schedule+0x48/0x4a
 [<c0430cf2>] ? schedule_timeout+0x23/0x182
 [<c014504b>] ? finish_wait+0x44/0x49
 [<c03845ba>] md_thread+0xcf/0xe6
 [<c0144f96>] ? abort_exclusive_wait+0x61/0x61
 [<c03844eb>] ? md_register_thread+0xa6/0xa6
 [<c0144b2f>] kthread+0x62/0x67
 [<c0144acd>] ? kthread_worker_fn+0x10b/0x10b
 [<c043357e>] kernel_thread_helper+0x6/0xd
Code: 1c 83 c0 08 83 d2 00 3b 96 94 00 00 00 77 0f 72 08 3b 86 90 00 00 00 77 05 f0 80 4b 74 08 8b 43 74 f6 c4 80 
74 21 f0 80 63 74 f7 <8b> 46 70 a8 02 75 10 c7 45 d0 01 00 00 00 f0 ff 86 98 00 00 00
EIP: [<f854d2fa>] handle_stripe+0x24b/0x18d7 [raid456] SS:ESP 0068:edd45e54
CR2: 0000000000000070
---[ end trace a521ee24ae7292e4 ]---
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
Pid: 1305, comm: nfsd Tainted: G      D     3.1.0-core2-volpreempt-noide-hm64-20111109 #1
Call Trace:
 [<c016c223>] ? touch_nmi_watchdog+0x52/0x52
 [<c042b8ba>] panic+0x4e/0x151
 [<c016c223>] ? touch_nmi_watchdog+0x52/0x52
 [<c016c294>] watchdog_overflow_callback+0x71/0x93
 [<c01782a9>] __perf_event_overflow+0x146/0x1b4
 [<c010c1c0>] ? x86_perf_event_set_period+0x19e/0x1a9
 [<c0178858>] perf_event_overflow+0x10/0x12
 [<c010eeb0>] intel_pmu_handle_irq+0x3da/0x42d
 [<c039c932>] ? kfree_skb+0x25/0x27
 [<c03a5a34>] ? dev_hard_start_xmit+0x36f/0x441
 [<c010cebb>] perf_event_nmi_handler+0x3a/0x7c
 [<c01489f9>] notifier_call_chain+0x26/0x48
 [<c0148a3d>] atomic_notifier_call_chain+0xf/0x11
 [<c0148d4d>] notify_die+0x2d/0x30
 [<c0102be0>] do_nmi+0x58/0x245
 [<c0432df4>] nmi_stack_correct+0x2f/0x34
 [<c017007b>] ? __rcu_process_callbacks+0x57/0x24b
 [<c04323a6>] ? _raw_spin_lock_irq+0x19/0x21
 [<f8549a13>] get_active_stripe+0x1d/0x463 [raid456]                        
 [<f854caf8>] make_request+0x3f7/0x613 [raid456]                            
 [<c0144f96>] ? abort_exclusive_wait+0x61/0x61                              
 [<c0383b45>] md_make_request+0xb0/0x16a                                    
 [<f89666e2>] ? dm_request+0x109/0x110 [dm_mod]                             
 [<c0268678>] generic_make_request+0x261/0x2d4                              
 [<c017ddbb>] ? mempool_alloc_slab+0xe/0x10                                 
 [<c017df8d>] ? mempool_alloc+0x3a/0xd5                                     
 [<c02687a1>] submit_bio+0xb6/0xcf                                          
 [<c01ce773>] ? bio_alloc_bioset+0x37/0x96                                  
 [<c01cac85>] submit_bh+0xc1/0xdb                                           
 [<c01cb08f>] ll_rw_block+0x5a/0x6f                                         
 [<c021433d>] ext4_bread+0x34/0x66                                          
 [<c02198f1>] htree_dirblock_to_tree+0x1e/0x108                             
 [<c021afdb>] ext4_htree_fill_tree+0x59/0x184 
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
