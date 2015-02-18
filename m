From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Potential Bug in "echo 0 > /dev/md0"
Date: Wed, 18 Feb 2015 11:19:14 -0500
Message-ID: <wrfjtwyjb3b1.fsf@redhat.com>
References: <CAB-428mj-P-+M0MnKhmojRe9ZQQzsSTBfCSS91ZK5KRy5p1mSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428mj-P-+M0MnKhmojRe9ZQQzsSTBfCSS91ZK5KRy5p1mSg@mail.gmail.com>
	(Alireza Haghdoost's message of "Wed, 18 Feb 2015 10:11:20 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Alireza Haghdoost <alireza@cs.umn.edu> writes:
> I understand this is not the right way to talk with md device but my
> understanding is that if some one run this command by mistake (or
> vandalism) , it should not results a kernel crash:
>
> [root] [ /home/arh ]
>  # echo 0 > /dev/md0

It shouldn't, however before anyone can debug this, you need to provide
a proper bug report with information about the kernel version you are
running, the configuration of /dev/md0 etc.

Please include 'cat /proc/mdstat' output with it.

JEs

>
> [root] [ /home/arh ]
>  # dmesg
> [1463111.320277] BUG: soft lockup - CPU#4 stuck for 22s! [whoopsie:1829]
> [1463111.320284] Modules linked in: ib_iser rdma_cm ib_addr iw_cm
> ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi bnep rfcomm
> bluetooth intel_rapl x86_pkg_temp_thermal intel_powerclamp nfsd
> coretemp kvm_intel kvm joydev auth_rpcgss crct10dif_pclmul
> crc32_pclmul gpio_ich mei_me ghash_clmulni_intel nfs_acl
> acpi_power_meter aesni_intel aes_x86_64 nfs glue_helper mei lrw
> gf128mul lpc_ich ablk_helper cryptd sb_edac dcdbas edac_core shpchp
> wmi mac_hid lockd sunrpc parport_pc ppdev ipmi_si ipmi_devintf fscache
> lp parport hid_generic ixgbe tg3 usbhid dca ahci mdio hid libahci ptp
> pps_core
> [1463111.320326] CPU: 4 PID: 1829 Comm: whoopsie Tainted: G      D W
>  3.13.0Write-Hole-Monitor #47
> [1463111.320328] Hardware name: Dell Inc. PowerEdge R420/0JD6X3, BIOS
> 2.1.3 05/21/2014
> [1463111.320329] task: ffff8801a425c7d0 ti: ffff8801a3e04000 task.ti:
> ffff8801a3e04000
> [1463111.320331] RIP: 0010:[<ffffffff810d8446>]  [<ffffffff810d8446>]
> smp_call_function_single+0xc6/0x190
> [1463111.320335] RSP: 0000:ffff8801a3e05a60  EFLAGS: 00000202
> [1463111.320336] RAX: 0000000000000001 RBX: ffffffff813624f4 RCX:
> 0000000000000000
> [1463111.320338] RDX: ffff8801a3e05ad8 RSI: ffff8801a9a54e80 RDI:
> 0000000000000001
> [1463111.320339] RBP: ffff8801a3e05ac8 R08: ffff8801a3e05b70 R09:
> 0000000000000000
> [1463111.320341] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff88031e6bec80
> [1463111.320342] R13: ffff880035d70700 R14: ffff8801a9a54400 R15:
> ffff88031e6bec80
> [1463111.320344] FS:  00007f9ae4924840(0000) GS:ffff8801a9a40000(0000)
> knlGS:0000000000000000
> [1463111.320346] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1463111.320347] CR2: 00007f9ae43bc280 CR3: 00000001a3adc000 CR4:
> 00000000000407e0
> [1463111.320349] Stack:
> [1463111.320350]  ffff8801a3e05af8 ffffffff8178f5ae 0000000000000000
> 0000000000000000
> [1463111.320353]  0000000000000000 0000000000000000 0000000000000000
> ffff8801a9a54480
> [1463111.320357]  0000000000000002 0000000000000001 ffff8801a3e05b70
> 0000000000000004
> [1463111.320360] Call Trace:
> [1463111.320364]  [<ffffffff8178f5ae>] ?
> schedule_hrtimeout_range_clock+0xce/0x170
> [1463111.320367]  [<ffffffff810f1e8c>] stop_two_cpus+0x14c/0x1a0
> [1463111.320369]  [<ffffffff810f18a0>] ? cpu_stop_should_run+0x50/0x50
> [1463111.320372]  [<ffffffff810f18a0>] ? cpu_stop_should_run+0x50/0x50
> [1463111.320375]  [<ffffffff81095e80>] ? __migrate_swap_task.part.68+0x80/0x80
> [1463111.320378]  [<ffffffff8109624a>] migrate_swap+0x8a/0xa0
> [1463111.320381]  [<ffffffff8109e133>] task_numa_migrate+0x1d3/0x480
> [1463111.320384]  [<ffffffff8109e433>] numa_migrate_preferred+0x53/0x60
> [1463111.320386]  [<ffffffff8109f8ef>] task_numa_fault+0x26f/0x890
> [1463111.320390]  [<ffffffff8117269e>] do_numa_page+0x13e/0x1a0
> [1463111.320394]  [<ffffffff81173823>] handle_mm_fault+0x5e3/0xe30
> [1463111.320396]  [<ffffffff8117bc30>] ? change_protection+0x690/0x720
> [1463111.320399]  [<ffffffff81797ac4>] __do_page_fault+0x154/0x570
> [1463111.320403]  [<ffffffff81191b0b>] ? change_prot_numa+0x1b/0x40
> [1463111.320405]  [<ffffffff8109c806>] ? task_numa_work+0x266/0x300
> [1463111.320408]  [<ffffffff81797efa>] do_page_fault+0x1a/0x70
> [1463111.320412]  [<ffffffff81012e67>] ? do_notify_resume+0x97/0xb0
> [1463111.320414]  [<ffffffff81794348>] page_fault+0x28/0x30
> [1463111.320415] Code: 00 00 00 85 c9 48 8d 74 24 10 75 1b 48 c7 c6 80
> 4e 01 00 65 48 03 34 25 c8 dc 00 00 0f b7 46 20 a8 01 74 0b 90 f3 90
> 0f b7 46 20 <a8> 01 75 f6 83 c8 01 66 89 46 20 0f ae f0 48 89 56 18 4c
> 89 76
> [1463111.344253] BUG: soft lockup - CPU#6 stuck for 22s! [Xorg:1842]
> [1463111.344254] Modules linked in: ib_iser rdma_cm ib_addr iw_cm
> ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi bnep rfcomm
> bluetooth intel_rapl x86_pkg_temp_thermal intel_powerclamp nfsd
> coretemp kvm_intel kvm joydev auth_rpcgss crct10dif_pclmul
> crc32_pclmul gpio_ich mei_me ghash_clmulni_intel nfs_acl
> acpi_power_meter aesni_intel aes_x86_64 nfs glue_helper mei lrw
> gf128mul lpc_ich ablk_helper cryptd sb_edac dcdbas edac_core shpchp
> wmi mac_hid lockd sunrpc parport_pc ppdev ipmi_si ipmi_devintf fscache
> lp parport hid_generic ixgbe tg3 usbhid dca ahci mdio hid libahci ptp
> pps_core
> [1463111.344298] CPU: 6 PID: 1842 Comm: Xorg Tainted: G      D W
> 3.13.0Write-Hole-Monitor #47
> [1463111.344299] Hardware name: Dell Inc. PowerEdge R420/0JD6X3, BIOS
> 2.1.3 05/21/2014
> [1463111.344302] task: ffff8800367b8000 ti: ffff880035f9e000 task.ti:
> ffff880035f9e000
> [1463111.344303] RIP: 0010:[<ffffffff810d8446>]  [<ffffffff810d8446>]
> smp_call_function_single+0xc6/0x190
> [1463111.344306] RSP: 0000:ffff880035f9fa60  EFLAGS: 00003202
> [1463111.344308] RAX: 0000000000000001 RBX: 0000000000400000 RCX:
> 0000000000000000
> [1463111.344309] RDX: ffff880035f9fad8 RSI: ffff8801a9a74e80 RDI:
> 0000000000000003
> [1463111.344311] RBP: ffff880035f9fac8 R08: ffff880035f9fb70 R09:
> 0000000000000000
> [1463111.344312] R10: 0000000000000000 R11: 0000000000000000 R12:
> 00000000003fc02a
> [1463111.344313] R13: ffffffff811ca5fc R14: ffff880035f9f9f0 R15:
> ffffffff81150fa3
> [1463111.344315] FS:  00007f2f338019c0(0000) GS:ffff8801a9a60000(0000)
> knlGS:0000000000000000
> [1463111.344317] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1463111.344318] CR2: 00007f2f344fdedc CR3: 000000031dd2b000 CR4:
> 00000000000407e0
> [1463111.344320] Stack:
> [1463111.344321]  ffff880035f9fdf8 ffff880035f9fdf0 0000000000000000
> 0000000000000000
> [1463111.344324]  0000000000000000 0000000000000000 0000000000000000
> ffff8801a9a74480
> [1463111.344327]  0000000000000002 0000000000000003 ffff880035f9fb70
> 0000000000000006
> [1463111.344330] Call Trace:
> [1463111.344334]  [<ffffffff810f1e8c>] stop_two_cpus+0x14c/0x1a0
> [1463111.344336]  [<ffffffff810f18a0>] ? cpu_stop_should_run+0x50/0x50
> [1463111.344339]  [<ffffffff810f18a0>] ? cpu_stop_should_run+0x50/0x50
> [1463111.344342]  [<ffffffff81095e80>] ? __migrate_swap_task.part.68+0x80/0x80
> [1463111.344345]  [<ffffffff8109624a>] migrate_swap+0x8a/0xa0
> [1463111.344347]  [<ffffffff8109e133>] task_numa_migrate+0x1d3/0x480
> [1463111.344351]  [<ffffffff811ca500>] ? poll_select_copy_remaining+0x130/0x130
> [1463111.344354]  [<ffffffff8109e433>] numa_migrate_preferred+0x53/0x60
> [1463111.344356]  [<ffffffff8109fd00>] task_numa_fault+0x680/0x890
> [1463111.344360]  [<ffffffff8117269e>] do_numa_page+0x13e/0x1a0
> [1463111.344363]  [<ffffffff81173823>] handle_mm_fault+0x5e3/0xe30
> [1463111.344366]  [<ffffffff81797ac4>] __do_page_fault+0x154/0x570
> [1463111.344368]  [<ffffffff811b7579>] ? do_readv_writev+0x169/0x220
> [1463111.344371]  [<ffffffff813624f4>] ? timerqueue_del+0x24/0x70
> [1463111.344374]  [<ffffffff8108baa6>] ? __remove_hrtimer+0x46/0xa0
> [1463111.344377]  [<ffffffff8108bec8>] ? hrtimer_try_to_cancel+0x48/0xe0
> [1463111.344380]  [<ffffffff81068b53>] ? do_setitimer+0xe3/0x2a0
> [1463111.344382]  [<ffffffff81797efa>] do_page_fault+0x1a/0x70
> [1463111.344385]  [<ffffffff81794348>] page_fault+0x28/0x30
> [1463111.344386] Code: 00 00 00 85 c9 48 8d 74 24 10 75 1b 48 c7 c6 80
> 4e 01 00 65 48 03 34 25 c8 dc 00 00 0f b7 46 20 a8 01 74 0b 90 f3 90
> 0f b7 46 20 <a8> 01 75 f6 83 c8 01 66 89 46 20 0f ae f0 48 89 56 18 4c
> 89 76
> [root] [ /home/arh ]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
