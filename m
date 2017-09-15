From: Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: Oops with 4.12.6 while syncing and writing to array
Date: Fri, 15 Sep 2017 10:23:26 +0200
Message-ID: <20170915102326.3e54017c@yaise-pc1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I set up a new raid-1 with 2 x 6 TB disks and during the initial sync
and while writing to the ext4fs on the newly created array I got an
Oops (attached).

Before posting a bug-report I wanted to make sure that I didn't do
anything wrong. But even though I should not have received an Oops.

Here is what I did/have: 

1) I have a degraded RAID-1 (due to disk failure, data is safe! thanks
to raid-mirroring) on /dev/md0.

2) I got two new disks with 6GB each (Seagate Ironwolf and WD Red). I
created a partition on each of these disks and ran:

  mdadm --create --verbose /dev/md1 --level=1 \
        --raid-devices=2 /dev/sdc1 /dev/sdd1

3) I observed in /proc/mdstat that it started resyncing.

4) I ran 

  mkfs.ext4 -m 0 /dev/md1

it finished immediately. 

5) I mounted the filesystem

  mount /dev/md1 /mnt

6) I started to rsync some data from /dev/md0 to the new array

  rsync -a --info=progress2 /some/dirs/from/md0/mount /mnt 

7) I went to bed

---

8) I woke up, the HDD-activity LEDs were off. After turning on the
screen and I saw an Oops all over my terminal.

9) rsync had stalled after 45 minutes, /proc/mdstat told me that
syncing had progress to 4.6 % and was stalled.

10) I saved the oops and rebooted

11) I tried to mount the /dev/md1 (now md127) partition, ext4 tried to
recover the journal and failed with 

  mount: /dev/md127: can't read superblock

I'm there now, it is currently syncing. I'm not sure what to do now.

  $ cat /proc/mdstat 
  Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10] 
  md0 : active raid1 sdb1[3]
       1953510841 blocks super 1.2 [2/1] [U_]
      
  md127 : active raid1 sdc1[0] sdd1[1]
      5860390464 blocks super 1.2 [2/2] [UU]
      [=======>.............]  resync = 37.9% (2221340160/5860390464) finish=386.5min speed=156889K/sec
      bitmap: 28/44 pages [112KB], 65536KB chunk

  unused devices: <none>

Could the reason be a memory/cpu/disk-problem? 

What else can I do to investigate the problem? Did I do any mistakes?

Thanks,
--
Patrick.

The Oops:

[  210.313156]  sdc: sdc1
[  213.430834]  sdc: sdc1
[  239.569345]  sdd: sdd1
[  242.949394]  sdd: sdd1
[  306.097116] md/raid1:md1: not clean -- starting background reconstruction
[  306.097120] md/raid1:md1: active with 2 out of 2 mirrors
[  306.114063] md1: detected capacity change from 0 to 6001039835136
[  306.114723] md: resync of RAID array md1
[  576.488661] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[ 2046.972949] perf: interrupt took too long (2522 > 2500), lowering kernel.perf_event_max_sample_rate to 79250
[ 2526.438844] perf: interrupt took too long (3182 > 3152), lowering kernel.perf_event_max_sample_rate to 62750
[ 3383.606878] perf: interrupt took too long (3989 > 3977), lowering kernel.perf_event_max_sample_rate to 50000
[ 3784.526950] ------------[ cut here ]------------
[ 3784.526954] kernel BUG at /build/linux-fHlJSJ/linux-4.12.6/block/blk-core.c:2054!
[ 3784.527011] invalid opcode: 0000 [#1] SMP
[ 3784.527032] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative lirc_dev rc_core xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter nf_nat nf_conntrack br_netfilter bridge stp llc overlay uinput binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_soc_skl snd_soc_skl_ipc kvm snd_soc_sst_ipc snd_soc_sst_dsp irqbypass snd_hda_ext_core snd_soc_sst_match crct10dif_pclmul crc32_pclmul snd_soc_rt286 snd_soc_rl6347a ghash_clmulni_intel intel_rapl_perf evdev pcspkr usblp snd_hda_intel snd_hda_codec snd_hda_core i915 snd_soc_core snd_hwdep snd_compress snd_pcm_oss drm_kms_helper snd_mixer_oss snd_
 pcm mei_me
[ 3784.527420]  drm lpc_ich i2c_algo_bit mfd_core mei snd_timer sg shpchp ucsi snd soundcore button battery video loop parport_pc ppdev nfsd auth_rpcgss nfs_acl lp lockd grace parport sunrpc ip_tables x_tables autofs4 ext4 crc16 jbd2 fscrypto ecb mbcache raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid0 multipath linear raid1 md_mod sd_mod hid_generic usbhid crc32c_intel ahci libahci aesni_intel aes_x86_64 crypto_simd cryptd glue_helper xhci_pci xhci_hcd usbcore i2c_i801 usb_common libata r8169 mii scsi_mod fan thermal i2c_hid hid
[ 3784.527729] CPU: 0 PID: 2033 Comm: md1_resync Not tainted 4.12.0-1-amd64 #1 Debian 4.12.6-1
[ 3784.527771] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./J4205-ITX, BIOS P1.30 04/18/2017
[ 3784.527820] task: ffff8853ebfda140 task.stack: ffffae95443f4000
[ 3784.527855] RIP: 0010:generic_make_request+0x2bf/0x2d0
[ 3784.527913] RSP: 0018:ffffae95443f7bd0 EFLAGS: 00010286
[ 3784.527940] RAX: ffff8853ebfda140 RBX: ffff885390baca00 RCX: 000000003fffffff
[ 3784.527975] RDX: 0000000000000402 RSI: 0000000000000000 RDI: ffff8853e8455db8
[ 3784.528012] RBP: ffffae95443f7c20 R08: 0000000000000010 R09: 0000000000001000
[ 3784.528048] R10: ffffae95443f7c40 R11: ffffffffc039c280 R12: 0000000000000080
[ 3784.528083] R13: 00000000ffffffff R14: 0000000000000004 R15: ffff8853476a8d00
[ 3784.528120] FS:  0000000000000000(0000) GS:ffff8853ffc00000(0000) knlGS:0000000000000000
[ 3784.528161] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3784.528191] CR2: 00007f891e227030 CR3: 000000043dc09000 CR4: 00000000003406f0
[ 3784.528227] Call Trace:
[ 3784.528250]  ? raid1_sync_request+0xa67/0xaf0 [raid1]
[ 3784.528278]  ? raid1_sync_request+0xa67/0xaf0 [raid1]
[ 3784.528312]  ? is_mddev_idle+0xa4/0x109 [md_mod]
[ 3784.528343]  ? md_do_sync+0x8a7/0xf60 [md_mod]
[ 3784.528370]  ? remove_wait_queue+0x60/0x60
[ 3784.528396]  ? md_thread+0x11f/0x160 [md_mod]
[ 3784.528423]  ? md_thread+0x11f/0x160 [md_mod]
[ 3784.528448]  ? kthread+0xfc/0x130
[ 3784.528469]  ? find_pers+0x70/0x70 [md_mod]
[ 3784.528492]  ? kthread_create_on_node+0x70/0x70
[ 3784.528517]  ? do_group_exit+0x3a/0xa0
[ 3784.528538]  ? ret_from_fork+0x25/0x30
[ 3784.528558] Code: fd ff ff 48 c7 45 b8 00 00 00 00 e9 5e ff ff ff 48 89 5d b0 e9 34 ff ff ff 4c 89 45 b0 e9 06 ff ff ff 48 89 7d b0 e9 e4 fe ff ff <0f> 0b e8 3a ea d5 ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
[ 3784.528719] RIP: generic_make_request+0x2bf/0x2d0 RSP: ffffae95443f7bd0
[ 3784.528780] ---[ end trace 7b0438208e2c2141 ]---
[ 3784.528816] ------------[ cut here ]------------
[ 3784.528843] WARNING: CPU: 0 PID: 2033 at /build/linux-fHlJSJ/linux-4.12.6/kernel/exit.c:785 do_exit+0x4f/0xb30
[ 3784.528893] Modules linked in: cpufreq_userspace cpufreq_powersave cpufreq_conservative lirc_dev rc_core xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter nf_nat nf_conntrack br_netfilter bridge stp llc overlay uinput binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_soc_skl snd_soc_skl_ipc kvm snd_soc_sst_ipc snd_soc_sst_dsp irqbypass snd_hda_ext_core snd_soc_sst_match crct10dif_pclmul crc32_pclmul snd_soc_rt286 snd_soc_rl6347a ghash_clmulni_intel intel_rapl_perf evdev pcspkr usblp snd_hda_intel snd_hda_codec snd_hda_core i915 snd_soc_core snd_hwdep snd_compress snd_pcm_oss drm_kms_helper snd_mixer_oss snd_
 pcm mei_me
[ 3784.529277]  drm lpc_ich i2c_algo_bit mfd_core mei snd_timer sg shpchp ucsi snd soundcore button battery video loop parport_pc ppdev nfsd auth_rpcgss nfs_acl lp lockd grace parport sunrpc ip_tables x_tables autofs4 ext4 crc16 jbd2 fscrypto ecb mbcache raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid0 multipath linear raid1 md_mod sd_mod hid_generic usbhid crc32c_intel ahci libahci aesni_intel aes_x86_64 crypto_simd cryptd glue_helper xhci_pci xhci_hcd usbcore i2c_i801 usb_common libata r8169 mii scsi_mod fan thermal i2c_hid hid
[ 3784.529612] CPU: 0 PID: 2033 Comm: md1_resync Tainted: G      D         4.12.0-1-amd64 #1 Debian 4.12.6-1
[ 3784.529660] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./J4205-ITX, BIOS P1.30 04/18/2017
[ 3784.529708] task: ffff8853ebfda140 task.stack: ffffae95443f4000
[ 3784.529740] RIP: 0010:do_exit+0x4f/0xb30
[ 3784.529760] RSP: 0018:ffffae95443f7ee0 EFLAGS: 00010206
[ 3784.529787] RAX: ffffae95443f7d90 RBX: ffff8853ebfda140 RCX: 00000000ffffffff
[ 3784.529823] RDX: ffff8853481ef000 RSI: 0000000000000000 RDI: ffffffff96a54b20
[ 3784.529858] RBP: 000000000000000b R08: 0000000000000000 R09: 000000000000031d
[ 3784.529896] R10: ffffffff96a06a80 R11: 0000000000000001 R12: ffffae95443f7b28
[ 3784.529932] R13: 0000000000000006 R14: 0000000000000004 R15: ffffffff967eed10
[ 3784.533046] FS:  0000000000000000(0000) GS:ffff8853ffc00000(0000) knlGS:0000000000000000
[ 3784.536156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3784.539192] CR2: 00007f891e227030 CR3: 000000043dc09000 CR4: 00000000003406f0
[ 3784.542221] Call Trace:
[ 3784.545142]  ? kthread+0xfc/0x130
[ 3784.548031]  ? rewind_stack_do_exit+0x17/0x20
[ 3784.550893] Code: 8b 04 25 28 00 00 00 48 89 44 24 38 31 c0 e8 59 8e 06 00 48 8b 83 48 07 00 00 48 85 c0 74 0e 48 8b 10 48 39 d0 0f 84 47 07 00 00 <0f> ff 65 44 8b 25 d7 3a 19 6a 41 81 e4 00 ff 1f 00 44 89 64 24
[ 3784.556711] ---[ end trace 7b0438208e2c2142 ]---
[ 9841.308830] perf: interrupt took too long (4990 > 4986), lowering kernel.perf_event_max_sample_rate to 40000
[26489.888679] perf: interrupt took too long (6253 > 6237), lowering kernel.perf_event_max_sample_rate to 31750






