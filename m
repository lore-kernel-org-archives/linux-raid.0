From: Shaohua Li <shli@kernel.org>
Subject: Re: WARNING: CPU: 4 PID: 10512 at drivers/md/raid5-cache.c:728
 r5l_do_reclaim+0x415/0x430 [raid456]
Date: Wed, 27 Jul 2016 18:13:08 -0700
Message-ID: <20160728011308.GA48473@kernel.org>
References: <1382969797.9407100.1469619450040.JavaMail.zimbra@redhat.com>
 <2099656990.9407283.1469619529240.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2099656990.9407283.1469619529240.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yi Zhang <yizhan@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 27, 2016 at 07:38:49AM -0400, Yi Zhang wrote:
> 
> Hello everyone
> 
> I'm testing raid5-cache recently and found below issue on 4.7.0-rc7.
> 
> [  902.701162] md: bind<sdb1>
> [  902.701248] md: bind<sdd1>
> [  902.702566] md: bind<sde1>
> [  902.702625] md: bind<sdf1>
> [  902.703306] md: bind<sdc1>
> [  902.705899] md/raid:md0: not clean -- starting background reconstruction
> [  902.705972] md/raid:md0: device sdf1 operational as raid disk 3
> [  902.705974] md/raid:md0: device sde1 operational as raid disk 2
> [  902.705975] md/raid:md0: device sdd1 operational as raid disk 1
> [  902.705976] md/raid:md0: device sdb1 operational as raid disk 0
> [  902.706312] md/raid:md0: allocated 4374kB
> [  902.706371] md/raid:md0: raid level 6 active with 4 out of 4 devices, algorithm 2
> [  902.706372] RAID conf printout:
> [  902.706380]  --- level:6 rd:4 wd:4
> [  902.706381]  disk 0, o:1, dev:sdb1
> [  902.706382]  disk 1, o:1, dev:sdd1
> [  902.706383]  disk 2, o:1, dev:sde1
> [  902.706384]  disk 3, o:1, dev:sdf1
> [  902.706393] md/raid456: discard support disabled due to uncertainty.
> [  902.706394] Set raid456.devices_handle_discard_safely=Y to override.
> [  902.706396] md/raid:md0: using device sdc1 as journal
> [  902.707354] created bitmap (1 pages) for device md0
> [  902.707401] md0: bitmap initialized from disk: read 1 pages, set 8 of 8 bits
> [  902.781331] md0: detected capacity change from 0 to 1071644672
> [  902.781465] md: resync of RAID array md0
> [  902.781468] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  902.781469] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
> [  902.781475] md: using 128k window, over a total of 523264k.
> [  902.829618] md: couldn't update array info. -22
> [  902.876797] md: couldn't update array info. -22
> [  902.896926] md: couldn't update array info. -22
> [  909.185914] md: md0: resync done.
> [  909.262779] RAID conf printout:
> [  909.262782]  --- level:6 rd:4 wd:4
> [  909.262783]  disk 0, o:1, dev:sdb1
> [  909.262784]  disk 1, o:1, dev:sdd1
> [  909.262785]  disk 2, o:1, dev:sde1
> [  909.262786]  disk 3, o:1, dev:sdf1
> [  912.795104] md/raid:md0: Disk failure on sdb1, disabling device.
> md/raid:md0: Operation continuing on 3 devices.
> [  912.851893] RAID conf printout:
> [  912.851895]  --- level:6 rd:4 wd:3
> [  912.851897]  disk 0, o:0, dev:sdb1
> [  912.851898]  disk 1, o:1, dev:sdd1
> [  912.851899]  disk 2, o:1, dev:sde1
> [  912.851900]  disk 3, o:1, dev:sdf1
> [  912.855130] RAID conf printout:
> [  912.855133]  --- level:6 rd:4 wd:3
> [  912.855135]  disk 1, o:1, dev:sdd1
> [  912.855136]  disk 2, o:1, dev:sde1
> [  912.855137]  disk 3, o:1, dev:sdf1
> [  912.885778] md: unbind<sdb1>
> [  912.894205] md: export_rdev(sdb1)
> [ 1548.098231] md: bind<sdb1>
> [ 1548.452714] RAID conf printout:
> [ 1548.452717]  --- level:6 rd:4 wd:3
> [ 1548.452718]  disk 0, o:1, dev:sdb1
> [ 1548.452719]  disk 1, o:1, dev:sdd1
> [ 1548.452720]  disk 2, o:1, dev:sde1
> [ 1548.452721]  disk 3, o:1, dev:sdf1
> [ 1548.486067] ------------[ cut here ]------------
> [ 1548.486076] WARNING: CPU: 4 PID: 10512 at drivers/md/raid5-cache.c:728 r5l_do_reclaim+0x415/0x430 [raid456]
> [ 1548.486077] Modules linked in: fuse btrfs vfat msdos fat ext4 jbd2 mbcache binfmt_misc raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ipt_REJECT nf_reject_ipv4 ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter sb_edac edac_core snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic x86_pkg_temp_thermal snd_hda_intel intel_powerclamp coretemp s
 nd_hda_codec
> [ 1548.486117]  kvm_intel kvm snd_hda_core irqbypass crct10dif_pclmul crc32_pclmul snd_hwdep ghash_clmulni_intel snd_seq aesni_intel lrw snd_seq_device gf128mul glue_helper snd_pcm ablk_helper hp_wmi iTCO_wdt snd_timer sparse_keymap rfkill cryptd iTCO_vendor_support mei_me ioatdma snd mei shpchp pcspkr sg soundcore i2c_i801 tpm_infineon lpc_ich mfd_core dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod nouveau video mxm_wmi i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm isci e1000e ata_generic libsas pata_acpi ahci libahci scsi_transport_sas firewire_ohci libata firewire_core ptp crc32c_intel serio_raw pps_core i2c_core crc_itu_t wmi fjes dm_mirror dm_region_hash dm_log dm_mod
> [ 1548.486152] CPU: 4 PID: 10512 Comm: md0_resync Tainted: G        W       4.7.0-rc7 #1
> [ 1548.486153] Hardware name: Hewlett-Packard HP Z620 Workstation/158A, BIOS J61 v03.69 03/25/2014
> [ 1548.486155]  0000000000000286 000000002369dfe1 ffff88079d713b40 ffffffff8134caec
> [ 1548.486157]  0000000000000000 0000000000000000 ffff88079d713b80 ffffffff8108c351
> [ 1548.486159]  000002d8a6ae4d80 000000008f0c904f ffff8807f64b0000 ffff8807c4ab6888
> [ 1548.486161] Call Trace:
> [ 1548.486166]  [<ffffffff8134caec>] dump_stack+0x63/0x87
> [ 1548.486169]  [<ffffffff8108c351>] __warn+0xd1/0xf0
> [ 1548.486172]  [<ffffffff8108c48d>] warn_slowpath_null+0x1d/0x20
> [ 1548.486175]  [<ffffffffa097d805>] r5l_do_reclaim+0x415/0x430 [raid456]
> [ 1548.486178]  [<ffffffff811f9c50>] ? kfree+0x120/0x170
> [ 1548.486181]  [<ffffffffa097e33b>] r5l_quiesce+0x7b/0xa0 [raid456]
> [ 1548.486183]  [<ffffffffa0970da0>] raid5_quiesce+0x50/0x2a0 [raid456]
> [ 1548.486186]  [<ffffffff810d0250>] ? prepare_to_wait_event+0xf0/0xf0
> [ 1548.486189]  [<ffffffff8156d00e>] md_do_sync+0xe7e/0xf60
> [ 1548.486192]  [<ffffffff810c4370>] ? enqueue_entity+0x2a0/0xcc0
> [ 1548.486194]  [<ffffffff810c201d>] ? update_curr+0xed/0x180
> [ 1548.486196]  [<ffffffff810c026e>] ? account_entity_dequeue+0xae/0xd0
> [ 1548.486197]  [<ffffffff810c27f6>] ? dequeue_entity+0x266/0x980
> [ 1548.486200]  [<ffffffff810b5ef5>] ? check_preempt_curr+0x75/0x90
> [ 1548.486202]  [<ffffffff810b5f29>] ? ttwu_do_wakeup+0x19/0xe0
> [ 1548.486204]  [<ffffffff810c2fce>] ? dequeue_task_fair+0xbe/0x830
> [ 1548.486206]  [<ffffffff810c3995>] ? put_prev_entity+0x35/0x730
> [ 1548.486209]  [<ffffffff8102c6d9>] ? __switch_to+0x219/0x5c0
> [ 1548.486211]  [<ffffffff81098d43>] ? kernel_sigaction+0x43/0xe0
> [ 1548.486214]  [<ffffffff81566aa6>] md_thread+0x136/0x150
> [ 1548.486216]  [<ffffffff81566970>] ? find_pers+0x70/0x70
> [ 1548.486219]  [<ffffffff810ab698>] kthread+0xd8/0xf0
> [ 1548.486221]  [<ffffffff816e873f>] ret_from_fork+0x1f/0x40
> [ 1548.486223]  [<ffffffff810ab5c0>] ? kthread_park+0x60/0x60
> [ 1548.486224] ---[ end trace 242e9516e36acb1e ]---
> [ 1548.543855] md: recovery of RAID array md0
> [ 1548.543857] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [ 1548.543859] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> [ 1548.543864] md: using 128k window, over a total of 523264k.
> [ 1548.543868] md: md0: recovery done.
> [ 1548.574961] RAID conf printout:
> [ 1548.574964]  --- level:6 rd:4 wd:4
> [ 1548.574966]  disk 0, o:1, dev:sdb1
> [ 1548.574967]  disk 1, o:1, dev:sdd1
> [ 1548.574968]  disk 2, o:1, dev:sde1
> [ 1548.574969]  disk 3, o:1, dev:sdf1
> 
> Steps I used:
> 
> mdadm --create --run /dev/md0 --level 4 --metadata 1.2 --raid-devices 4 
> /dev/sdb1 /dev/sd[d-f]1 --write-journal /dev/sdc1 --bitmap=internal 
> --bitmap-chunk=64M --chunk 512
> mdadm --wait /dev/md0
> mkfs.ext4 /dev/md0
> mdadm /dev/md0 -f /dev/sdb1
> mdadm /dev/md0 -r /dev/sdb1
> mdadm /dev/md0 -a /dev/sdb1

Thanks for the reporting. Looks the assumption .quiesce is called with
reconfig_mutex locked is incorrect. I'll work out a fix.

Thanks,
Shaohua
