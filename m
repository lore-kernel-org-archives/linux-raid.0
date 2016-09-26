From: Yi Zhang <yizhan@redhat.com>
Subject: kernel BUG at block/bio.c:1785! observed on 4.8.0-rc6
Date: Mon, 26 Sep 2016 01:17:37 -0400 (EDT)
Message-ID: <1653300934.1741807.1474867057556.JavaMail.zimbra@redhat.com>
References: <2021001709.1741646.1474866867952.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2021001709.1741646.1474866867952.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Xiaotian Zhang <xiaotzha@redhat.com>
List-Id: linux-raid.ids

Hello 

I observed below bug during my MD RAID testing on 4.8.0-rc6, anyone could help check it? Thanks.

[22535.847193] md: bind<loop0>
[22535.850414] md: bind<loop1>
[22535.853638] md: bind<loop2>
[22535.856861] md: bind<loop3>
[22535.860056] md: bind<loop5>
[22535.863278] md: bind<loop4>
[22535.872061] md/raid:md0: device loop3 operational as raid disk 3
[22535.878783] md/raid:md0: device loop2 operational as raid disk 2
[22535.885495] md/raid:md0: device loop1 operational as raid disk 1
[22535.892206] md/raid:md0: device loop0 operational as raid disk 0
[22535.899761] md/raid:md0: allocated 5432kB
[22535.904381] md/raid:md0: raid level 5 active with 4 out of 5 devices, algorithm 2
[22535.912785] md/raid456: discard support disabled due to uncertainty.
[22535.919885] Set raid456.devices_handle_discard_safely=Y to override.
[22535.927016] md0: detected capacity change from 0 to 8384413696
[22535.933796] md: recovery of RAID array md0
[22535.938386] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[22535.944906] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[22535.955670] md: using 128k window, over a total of 2046976k.
[22565.627129] md: md0: recovery done.
[22569.183047] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
[22570.376773] md: bind<loop7>
[22570.508870] md: reshape of RAID array md0
[22570.513358] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[22570.519874] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
[22570.530545] md: using 128k window, over a total of 2046976k.
[22691.448933] md: md0: reshape done.
[22709.108706] md0: detected capacity change from 8384413696 to 10480517120
[22709.144385] VFS: busy inodes on changed media or resized disk md0
[22709.312043] ------------[ cut here ]------------
[22709.317198] kernel BUG at block/bio.c:1785!
[22709.321866] invalid opcode: 0000 [#1] SMP
[22709.326337] Modules linked in: ext4 jbd2 mbcache loop rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp raid456 kvm_intel async_raid6_recov kvm async_memcpy async_pq async_xor xor async_tx irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel raid6_pq aesni_intel lrw iTCO_wdt gf128mul iTCO_vendor_support glue_helper ablk_helper ipmi_devintf ipmi_ssif cryptd dcdbas mei_me sg pcspkr mei lpc_ich ipmi_si ipmi_msghandler shpchp wmi acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c mlx4_en sd_mod mgag200 i2c_algo_bit drm_kms_help
 er syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci drm mlx4_core libahci tg3 crc32c_intel libata ptp i2c_core megaraid_sas devlink fjes pps_core dm_mirror dm_region_hash dm_log dm_mod
[22709.423707] CPU: 4 PID: 11012 Comm: md0_raid5 Not tainted 4.8.0-rc6 #2
[22709.430990] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.0.4 08/28/2014
[22709.439342] task: ffff8810f8850000 task.stack: ffff88102379c000
[22709.445947] RIP: 0010:[<ffffffff81328a8a>]  [<ffffffff81328a8a>] bio_split+0x8a/0x90
[22709.454607] RSP: 0018:ffff88102379f930  EFLAGS: 00010246
[22709.460527] RAX: 0000000000000080 RBX: 0000000000001000 RCX: ffff8810386bfd00
[22709.468489] RDX: 0000000002400000 RSI: 0000000000000000 RDI: ffff88203a604178
[22709.476452] RBP: ffff88102379f948 R08: 0000000000000000 R09: ffff88203a604178
[22709.484413] R10: 00058000ffffffff R11: 0000000000000000 R12: 0000000000000000
[22709.492376] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000080
[22709.500339] FS:  0000000000000000(0000) GS:ffff88103ec80000(0000) knlGS:0000000000000000
[22709.509574] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22709.515987] CR2: 00007f1460629000 CR3: 0000000001c06000 CR4: 00000000001406e0
[22709.523951] Stack:
[22709.526193]  0000000000001000 0000000000000000 0000000000000000 ffff88102379f9f0
[22709.534489]  ffffffff81335ca0 ffff88103ecd9000 0000000000000001 ffff8810386bfd00
[22709.542776]  0000000000000000 ffff8810372b2c60 ffff88102379fa28 00000080810c6dac
[22709.551074] Call Trace:
[22709.553808]  [<ffffffff81335ca0>] blk_queue_split+0x480/0x640
[22709.560223]  [<ffffffff8133b9d5>] blk_sq_make_request+0x95/0x490
[22709.566922]  [<ffffffff8132cec4>] ? generic_make_request_checks+0x234/0x4f0
[22709.574698]  [<ffffffffa04e51c3>] ? async_xor+0x1c3/0x5b0 [async_xor]
[22709.581888]  [<ffffffff8132f903>] generic_make_request+0x103/0x1d0
[22709.588788]  [<ffffffffa0998286>] ops_run_io+0x376/0x960 [raid456]
[22709.595678]  [<ffffffffa09a0e3b>] handle_stripe+0xbdb/0x23f0 [raid456]
[22709.602967]  [<ffffffffa09a2a3c>] handle_active_stripes.isra.52+0x3ec/0x4c0 [raid456]
[22709.611708]  [<ffffffffa0995f69>] ? do_release_stripe+0x99/0x180 [raid456]
[22709.619382]  [<ffffffffa0996065>] ? __release_stripe+0x15/0x20 [raid456]
[22709.626862]  [<ffffffffa09a2fb8>] raid5d+0x4a8/0x750 [raid456]
[22709.633381]  [<ffffffff815756c6>] md_thread+0x136/0x150
[22709.639218]  [<ffffffff810d2330>] ? prepare_to_wait_event+0xf0/0xf0
[22709.646214]  [<ffffffff81575590>] ? find_pers+0x70/0x70
[22709.652045]  [<ffffffff810acca8>] kthread+0xd8/0xf0
[22709.657490]  [<ffffffff810b515f>] ? finish_task_switch+0x7f/0x240
[22709.664292]  [<ffffffff816ff13f>] ret_from_fork+0x1f/0x40
[22709.670309]  [<ffffffff810acbd0>] ? kthread_park+0x60/0x60
[22709.676430] Code: df e8 eb 29 03 00 8b 73 28 4c 89 e7 e8 80 de ff ff 48 89 d8 5b 41 5c 41 5d 5d c3 e8 61 fc ff ff 48 89 c3 eb b9 31 c0 eb eb 0f 0b <0f> 0b 0f 1f 40 00 0f 1f 44 00 00 48 8b 07 55 48 89 e5 48 85 c0 
[22709.698111] RIP  [<ffffffff81328a8a>] bio_split+0x8a/0x90
[22709.704146]  RSP <ffff88102379f930>
[22709.714624] ---[ end trace 47f4294978ff2bd0 ]---
[22709.788366] Kernel panic - not syncing: Fatal exception
[22709.794278] Kernel Offset: disabled
[22709.867270] ---[ end Kernel panic - not syncing: Fatal exception
[22709.873997] ------------[ cut here ]------------
[22709.879159] WARNING: CPU: 4 PID: 11012 at arch/x86/kernel/smp.c:125 native_smp_send_reschedule+0x3f/0x50
[22709.889740] Modules linked in: ext4 jbd2 mbcache loop rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp raid456 kvm_intel async_raid6_recov kvm async_memcpy async_pq async_xor xor async_tx irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel raid6_pq aesni_intel lrw iTCO_wdt gf128mul iTCO_vendor_support glue_helper ablk_helper ipmi_devintf ipmi_ssif cryptd dcdbas mei_me sg pcspkr mei lpc_ich ipmi_si ipmi_msghandler shpchp wmi acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c mlx4_en sd_mod mgag200 i2c_algo_bit drm_kms_help
 er syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci drm mlx4_core libahci tg3 crc32c_intel libata ptp i2c_core megaraid_sas devlink fjes pps_core dm_mirror dm_region_hash dm_log dm_mod
[22709.987252] CPU: 4 PID: 11012 Comm: md0_raid5 Tainted: G      D         4.8.0-rc6 #2
[22709.995894] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.0.4 08/28/2014
[22710.004469]  0000000000000086 0000000003b679dd ffff88103ec83bb0 ffffffff8135ce3c
[22710.012757]  0000000000000000 0000000000000000 ffff88103ec83bf0 ffffffff8108d7a1
[22710.021051]  0000007d3ec190c0 0000000000000000 ffff88203903da00 ffff88103ec190c0
[22710.029344] Call Trace:
[22710.032072]  <IRQ>  [<ffffffff8135ce3c>] dump_stack+0x63/0x87
[22710.038505]  [<ffffffff8108d7a1>] __warn+0xd1/0xf0
[22710.043851]  [<ffffffff8108d8dd>] warn_slowpath_null+0x1d/0x20
[22710.050357]  [<ffffffff81050c2f>] native_smp_send_reschedule+0x3f/0x50
[22710.057647]  [<ffffffff810b6928>] resched_curr+0xa8/0xd0
[22710.063573]  [<ffffffff810b7685>] check_preempt_curr+0x75/0x90
[22710.070080]  [<ffffffff810b76b9>] ttwu_do_wakeup+0x19/0xe0
[22710.076201]  [<ffffffff810b77ef>] ttwu_do_activate+0x6f/0x80
[22710.082515]  [<ffffffff810b841e>] try_to_wake_up+0x1ae/0x3c0
[22710.088830]  [<ffffffff810b86e2>] default_wake_function+0x12/0x20
[22710.095630]  [<ffffffff810d1be5>] __wake_up_common+0x55/0x90
[22710.101944]  [<ffffffff810d1c33>] __wake_up_locked+0x13/0x20
[22710.108263]  [<ffffffff81275419>] ep_poll_callback+0xb9/0x200
[22710.114672]  [<ffffffff810d1be5>] __wake_up_common+0x55/0x90
[22710.120986]  [<ffffffff810d1d39>] __wake_up+0x39/0x50
[22710.126626]  [<ffffffff810e9470>] wake_up_klogd_work_func+0x40/0x60
[22710.133624]  [<ffffffff8118101d>] irq_work_run_list+0x4d/0x70
[22710.140040]  [<ffffffff8110de30>] ? tick_sched_do_timer+0x50/0x50
[22710.146837]  [<ffffffff811811d0>] irq_work_tick+0x40/0x50
[22710.152867]  [<ffffffff810fdca2>] update_process_times+0x42/0x60
[22710.159567]  [<ffffffff8110d775>] tick_sched_handle.isra.16+0x25/0x60
[22710.166756]  [<ffffffff8110de6d>] tick_sched_timer+0x3d/0x70
[22710.173072]  [<ffffffff810fe9c3>] __hrtimer_run_queues+0xf3/0x280
[22710.179869]  [<ffffffff810feea8>] hrtimer_interrupt+0xa8/0x1a0
[22710.186380]  [<ffffffff810535d5>] local_apic_timer_interrupt+0x35/0x60
[22710.193669]  [<ffffffff81701aad>] smp_apic_timer_interrupt+0x3d/0x50
[22710.200761]  [<ffffffff81700c6c>] apic_timer_interrupt+0x8c/0xa0
[22710.207461]  <EOI>  [<ffffffff811987da>] ? panic+0x1f1/0x232
[22710.213786]  [<ffffffff81030ba8>] oops_end+0xb8/0xd0
[22710.219331]  [<ffffffff8103110b>] die+0x4b/0x70
[22710.224384]  [<ffffffff8102df20>] do_trap+0x140/0x150
[22710.230017]  [<ffffffff8102e2a9>] do_error_trap+0x89/0x110
[22710.236142]  [<ffffffff81328a8a>] ? bio_split+0x8a/0x90
[22710.241970]  [<ffffffff810b7692>] ? check_preempt_curr+0x82/0x90
[22710.248671]  [<ffffffff810b76b9>] ? ttwu_do_wakeup+0x19/0xe0
[22710.254989]  [<ffffffff810c0cc3>] ? update_cfs_rq_load_avg+0x233/0x440
[22710.262272]  [<ffffffff8102e7e0>] do_invalid_op+0x20/0x30
[22710.268297]  [<ffffffff816ffd3e>] invalid_op+0x1e/0x30
[22710.274029]  [<ffffffff81328a8a>] ? bio_split+0x8a/0x90
[22710.279861]  [<ffffffff81335ca0>] blk_queue_split+0x480/0x640
[22710.286273]  [<ffffffff8133b9d5>] blk_sq_make_request+0x95/0x490
[22710.292976]  [<ffffffff8132cec4>] ? generic_make_request_checks+0x234/0x4f0
[22710.300750]  [<ffffffffa04e51c3>] ? async_xor+0x1c3/0x5b0 [async_xor]
[22710.307939]  [<ffffffff8132f903>] generic_make_request+0x103/0x1d0
[22710.314839]  [<ffffffffa0998286>] ops_run_io+0x376/0x960 [raid456]
[22710.321737]  [<ffffffffa09a0e3b>] handle_stripe+0xbdb/0x23f0 [raid456]
[22710.329021]  [<ffffffffa09a2a3c>] handle_active_stripes.isra.52+0x3ec/0x4c0 [raid456]
[22710.337759]  [<ffffffffa0995f69>] ? do_release_stripe+0x99/0x180 [raid456]
[22710.345429]  [<ffffffffa0996065>] ? __release_stripe+0x15/0x20 [raid456]
[22710.352907]  [<ffffffffa09a2fb8>] raid5d+0x4a8/0x750 [raid456]
[22710.359418]  [<ffffffff815756c6>] md_thread+0x136/0x150
[22710.365248]  [<ffffffff810d2330>] ? prepare_to_wait_event+0xf0/0xf0
[22710.372240]  [<ffffffff81575590>] ? find_pers+0x70/0x70
[22710.378071]  [<ffffffff810acca8>] kthread+0xd8/0xf0
[22710.383513]  [<ffffffff810b515f>] ? finish_task_switch+0x7f/0x240
[22710.390314]  [<ffffffff816ff13f>] ret_from_fork+0x1f/0x40
[22710.396337]  [<ffffffff810acbd0>] ? kthread_park+0x60/0x60
[22710.402457] ---[ end trace 47f4294978ff2bd1 ]---

Best Regards,
  Yi Zhang


