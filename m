From: yizhan <yizhan@redhat.com>
Subject: Re: WARNING: CPU: 4 PID: 10512 at drivers/md/raid5-cache.c:728
 r5l_do_reclaim+0x415/0x430 [raid456]
Date: Tue, 2 Aug 2016 21:31:56 +0800
Message-ID: <bd2bb3a9-f970-7726-00b7-1956d2223ef1@redhat.com>
References: <2099656990.9407283.1469619529240.JavaMail.zimbra@redhat.com>
 <579F0E52.8090704@suse.com> <7d0acb42-1209-0722-7740-0fa03d44106b@redhat.com>
 <57A05B70.9060500@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57A05B70.9060500@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I tried with latest Linus's tree 
> (731c7d3a205ba89b475b2aa71b5f13dd6ae3de56), but still can't find the 
> warning.
>
> linux241:~ # uname -r
> 4.7.0-11-default+
> linux241:~ # mdadm --version
> mdadm - v3.4-41-gf96b130 - 30th March 2016
>
> The biggest difference is that I am using VM machine while you were 
> testing with real hardware, though I am not
> sure it was caused by hardware or not. Do you always see the "couldn't 
> update array info" info during test? If so,
> pls try to make it disappear.
>
> Thanks,
> Guoqing
May be it's env related, I have tried on another PC which with the same 
kernel/mdadm version and cannot reproduce it.

Below is one log I reproduced which without  " couldn't update array info"'
[  504.650453] md: bind<sdb1>
[  504.650539] md: bind<sdd1>
[  504.650611] md: bind<sde1>
[  504.651137] md: bind<sdc1>
[  504.651211] md: bind<sdf1>
[  504.655535] md/raid:md0: device sde1 operational as raid disk 2
[  504.655537] md/raid:md0: device sdd1 operational as raid disk 1
[  504.655538] md/raid:md0: device sdb1 operational as raid disk 0
[  504.656040] md/raid:md0: allocated 4374kB
[  504.656069] md/raid:md0: raid level 4 active with 3 out of 4 devices, 
algorithm 0
[  504.656071] RAID conf printout:
[  504.656085]  --- level:4 rd:4 wd:3
[  504.656086]  disk 0, o:1, dev:sdb1
[  504.656087]  disk 1, o:1, dev:sdd1
[  504.656088]  disk 2, o:1, dev:sde1
[  504.656107] md/raid:md0: using device sdc1 as journal
[  504.658052] created bitmap (1 pages) for device md0
[  504.658124] md0: bitmap initialized from disk: read 1 pages, set 16 
of 16 bits
[  504.667007] md0: detected capacity change from 0 to 3221225472
[  504.667032] RAID conf printout:
[  504.667035]  --- level:4 rd:4 wd:3
[  504.667037]  disk 0, o:1, dev:sdb1
[  504.667039]  disk 1, o:1, dev:sdd1
[  504.667041]  disk 2, o:1, dev:sde1
[  504.667042]  disk 3, o:1, dev:sdf1
[  504.667156] md: recovery of RAID array md0
[  504.667159] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  504.667160] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  504.667165] md: using 128k window, over a total of 1048576k.
[  516.581223] md: md0: recovery done.
[  516.678940] RAID conf printout:
[  516.678943]  --- level:4 rd:4 wd:4
[  516.678945]  disk 0, o:1, dev:sdb1
[  516.678946]  disk 1, o:1, dev:sdd1
[  516.678947]  disk 2, o:1, dev:sde1
[  516.678948]  disk 3, o:1, dev:sdf1
[  517.694241] md/raid:md0: Disk failure on sdb1, disabling device.
md/raid:md0: Operation continuing on 3 devices.
[  517.734547] RAID conf printout:
[  517.734549]  --- level:4 rd:4 wd:3
[  517.734551]  disk 0, o:0, dev:sdb1
[  517.734552]  disk 1, o:1, dev:sdd1
[  517.734553]  disk 2, o:1, dev:sde1
[  517.734554]  disk 3, o:1, dev:sdf1
[  517.737295] RAID conf printout:
[  517.737298]  --- level:4 rd:4 wd:3
[  517.737299]  disk 1, o:1, dev:sdd1
[  517.737300]  disk 2, o:1, dev:sde1
[  517.737301]  disk 3, o:1, dev:sdf1
[  522.695241] md: unbind<sdb1>
[  522.698393] md: export_rdev(sdb1)
[  523.277566] md: bind<sdb1>
[  523.333573] RAID conf printout:
[  523.333576]  --- level:4 rd:4 wd:3
[  523.333577]  disk 0, o:1, dev:sdb1
[  523.333578]  disk 1, o:1, dev:sdd1
[  523.333579]  disk 2, o:1, dev:sde1
[  523.333580]  disk 3, o:1, dev:sdf1
[  523.379453] ------------[ cut here ]------------
[  523.379462] WARNING: CPU: 0 PID: 5186 at drivers/md/raid5-cache.c:728 
r5l_do_reclaim+0x415/0x430 [raid456]
[  523.379463] Modules linked in: raid456 async_raid6_recov async_memcpy 
async_pq async_xor xor async_tx raid6_pq xt_CHECKSUM ipt_MASQUERADE 
nf_nat_masquerade_ipv4 tun ipt_REJECT nf_reject_ipv4 ip6t_rpfilter 
ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat 
ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security 
ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw 
ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter 
sb_edac edac_core snd_hda_codec_hdmi x86_pkg_temp_thermal 
snd_hda_codec_realtek intel_powerclamp coretemp snd_hda_codec_generic 
snd_hda_intel kvm_intel snd_hda_codec kvm snd_hda_core snd_hwdep snd_seq 
snd_seq_device
[  523.379488]  irqbypass snd_pcm crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper 
cryptd snd_timer iTCO_wdt hp_wmi snd sparse_keymap ioatdma rfkill 
iTCO_vendor_support sg pcspkr shpchp soundcore mei_me i2c_i801 dca mei 
lpc_ich mfd_core tpm_infineon nfsd auth_rpcgss nfs_acl lockd grace 
sunrpc ip_tables xfs libcrc32c sd_mod nouveau video mxm_wmi i2c_algo_bit 
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm isci 
drm libsas e1000e ata_generic ahci pata_acpi scsi_transport_sas libahci 
libata firewire_ohci firewire_core crc32c_intel serio_raw ptp pps_core 
crc_itu_t i2c_core wmi fjes dm_mirror dm_region_hash dm_log dm_mod
[  523.379520] CPU: 0 PID: 5186 Comm: md0_resync Tainted: G W       4.7.0 #5
[  523.379521] Hardware name: Hewlett-Packard HP Z620 Workstation/158A, 
BIOS J61 v03.69 03/25/2014
[  523.379522]  0000000000000286 00000000277f1813 ffff880801c5fb40 
ffffffff8134cd0c
[  523.379524]  0000000000000000 0000000000000000 ffff880801c5fb80 
ffffffff8108c351
[  523.379526]  000002d8c7a96d80 0000000023f0d6c6 ffff8800c6dc8000 
ffff8807f334be88
[  523.379528] Call Trace:
[  523.379533]  [<ffffffff8134cd0c>] dump_stack+0x63/0x87
[  523.379537]  [<ffffffff8108c351>] __warn+0xd1/0xf0
[  523.379539]  [<ffffffff8108c48d>] warn_slowpath_null+0x1d/0x20
[  523.379542]  [<ffffffffa0995805>] r5l_do_reclaim+0x415/0x430 [raid456]
[  523.379546]  [<ffffffff811f9d00>] ? kfree+0x120/0x170
[  523.379548]  [<ffffffffa099633b>] r5l_quiesce+0x7b/0xa0 [raid456]
[  523.379551]  [<ffffffffa0988da0>] raid5_quiesce+0x50/0x2a0 [raid456]
[  523.379553]  [<ffffffff810d0240>] ? prepare_to_wait_event+0xf0/0xf0
[  523.379556]  [<ffffffff8156d32e>] md_do_sync+0xe7e/0xf60
[  523.379560]  [<ffffffff81036bf9>] ? sched_clock+0x9/0x10
[  523.379562]  [<ffffffff810bc4b2>] ? sched_clock_cpu+0x72/0xa0
[  523.379564]  [<ffffffff810c3985>] ? put_prev_entity+0x35/0x730
[  523.379567]  [<ffffffff8102c6d9>] ? __switch_to+0x219/0x5c0
[  523.379570]  [<ffffffff81098d43>] ? kernel_sigaction+0x43/0xe0
[  523.379572]  [<ffffffff81566dc6>] md_thread+0x136/0x150
[  523.379575]  [<ffffffff81566c90>] ? find_pers+0x70/0x70
[  523.379577]  [<ffffffff810ab678>] kthread+0xd8/0xf0
[  523.379580]  [<ffffffff816e88bf>] ret_from_fork+0x1f/0x40
[  523.379582]  [<ffffffff810ab5a0>] ? kthread_park+0x60/0x60
[  523.379583] ---[ end trace 76fe4588f24ee7b5 ]---
[  523.429860] md: recovery of RAID array md0
[  523.429862] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  523.429864] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  523.429876] md: using 128k window, over a total of 1048576k.
[  523.429882] md: md0: recovery interrupted.
[  523.501621] md: md0 still in use.
[  523.501629] RAID conf printout:
[  523.501632]  --- level:4 rd:4 wd:3
[  523.501634]  disk 0, o:1, dev:sdb1
[  523.501635]  disk 1, o:1, dev:sdd1
[  523.501636]  disk 2, o:1, dev:sde1
[  523.501637]  disk 3, o:1, dev:sdf1
[  523.501638] RAID conf printout:
[  523.501638]  --- level:4 rd:4 wd:3
[  523.501639]  disk 0, o:1, dev:sdb1
[  523.501640]  disk 1, o:1, dev:sdd1
[  523.501641]  disk 2, o:1, dev:sde1
[  523.501642]  disk 3, o:1, dev:sdf1
[  523.501737] md: recovery of RAID array md0
[  523.501740] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  523.501741] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  523.501745] md: using 128k window, over a total of 1048576k.
[  523.501746] md: resuming recovery of md0 from checkpoint.
[  523.501768] md: md0: recovery done.
[  523.534961] RAID conf printout:
[  523.534964]  --- level:4 rd:4 wd:4
[  523.534966]  disk 0, o:1, dev:sdb1
[  523.534967]  disk 1, o:1, dev:sdd1
[  523.534968]  disk 2, o:1, dev:sde1
[  523.534969]  disk 3, o:1, dev:sdf1
[  523.725191] md0: detected capacity change from 3221225472 to 0
[  523.725282] md: md0 stopped.
[  523.725286] md: unbind<sdb1>
[  523.740217] md: export_rdev(sdb1)
[  523.740226] md: unbind<sdf1>
[  523.746268] md: export_rdev(sdf1)
[  523.746284] md: unbind<sdc1>
[  523.753263] md: export_rdev(sdc1)
[  523.753278] md: unbind<sde1>
[  523.759267] md: export_rdev(sde1)
[  523.759282] md: unbind<sdd1>
[  523.765299] md: export_rdev(sdd1)


