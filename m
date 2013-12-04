From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?cmFpZDUgcm1tb2QgYnVnIG9vcHM=?=
Date: Wed, 04 Dec 2013 14:34:00 +0800
Message-ID: <6da697f7-5486-4b67-9957-687db9c42db2@aliyun.com>
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 I download  linux 3.10.21 source and compile system,when I  load md-mod.ko raid456.ko, Immediately rmmod raid456.ko  md-mod.ko, 
System error as follows:

Dec  4 14:00:37 host2-X8DTS kernel: [  414.981261] md: raid6 personality unregistered
Dec  4 14:00:37 host2-X8DTS kernel: [  414.981268] md: raid5 personality unregistered
Dec  4 14:00:37 host2-X8DTS kernel: [  414.981271] md: raid4 personality unregistered
Dec  4 14:00:38 host2-X8DTS kernel: [  416.422769] md: raid1 personality unregistered
Dec  4 14:00:41 host2-X8DTS kernel: [  418.632353] md: raid10 personality unregistered
Dec  4 14:00:42 host2-X8DTS kernel: [  420.577832] md: multipath personality unregistered
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574371] BUG: unable to handle kernel paging request at ffffffffa0113000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574381] IP: [<ffffffff81678fa1>] _raw_spin_lock_irqsave+0x11/0x30
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574399] PGD 1c0c067 PUD 1c0d063 PMD 2289da067 PTE 0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574404] Oops: 0002 [#1] SMP 
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574407] Modules linked in: coretemp kvm_intel kvm bnep ghash_clmulni_intel rfcomm bluetooth aesni_intel ablk_helper joydev cryptd lrw gf128mul psmouse glue_helper i7core_edac aes_x86_64 gpio_ich ioatdma serio_raw edac_core microcode lpc_ich mac_hid parport_pc ppdev lp parport async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx hid_generic usbhid hid igb mpt2sas dca scsi_transport_sas i2c_algo_bit raid_class ptp mlx4_core pps_core [last unloaded: md_mod]
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574451] CPU: 11 PID: 2497 Comm: udisks-daemon Not tainted 3.10.21 #1
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574455] Hardware name: Supermicro B8DTP/B8DTP, BIOS 080015  03/17/2010
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574457] task: ffff880228430000 ti: ffff880228db4000 task.ti: ffff880228db4000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574459] RIP: 0010:[<ffffffff81678fa1>]  [<ffffffff81678fa1>] _raw_spin_lock_irqsave+0x11/0x30
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574465] RSP: 0018:ffff880228db5ab8  EFLAGS: 00010082
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574467] RAX: 0000000000000282 RBX: ffffffffa0113000 RCX: ffff8802286258d0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574470] RDX: 0000000000010000 RSI: ffff880228db5c08 RDI: ffffffffa0113000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574473] RBP: ffff880228db5ab8 R08: ffff880227a92438 R09: 0000000000000000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574475] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880228db5c08
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574478] R13: ffff880228db5b88 R14: ffff880228db5e2c R15: 0000000000000001
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574481] FS:  00007f9042f9f7c0(0000) GS:ffff88023fce0000(0000) knlGS:0000000000000000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574484] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574486] CR2: ffffffffa0113000 CR3: 00000002331db000 CR4: 00000000000007e0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574489] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574491] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574493] Stack:
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574495]  ffff880228db5ad8 ffffffff8106a2f0 0000000000000002 ffff880228db5bf8
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574502]  ffff880228db5b28 ffffffff8118b1ee ffff880228db5af8 0000000000000000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574508]  ffff880228db5b28 0000000000771d20 0000000000000001 0000000000000001
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574515] Call Trace:
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574526]  [<ffffffff8106a2f0>] remove_wait_queue+0x20/0x70
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574535]  [<ffffffff8118b1ee>] poll_freewait+0x4e/0xe0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574541]  [<ffffffff8118c3b3>] do_sys_poll+0x163/0x4d0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574546]  [<ffffffff8118b370>] ? __pollwait+0xf0/0xf0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574551]  [<ffffffff8118b370>] ? __pollwait+0xf0/0xf0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574559]  [<ffffffff8118b370>] ? __pollwait+0xf0/0xf0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574564]  [<ffffffff8118b370>] ? __pollwait+0xf0/0xf0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574570]  [<ffffffff8118b370>] ? __pollwait+0xf0/0xf0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574578]  [<ffffffff8156b0a6>] ? verify_iovec+0x56/0xd0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574587]  [<ffffffff8155d1e2>] ? ___sys_recvmsg+0x192/0x2a0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574595]  [<ffffffff81144eb0>] ? handle_mm_fault+0x210/0x310
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574604]  [<ffffffff811c0009>] ? eventfd_ctx_read+0x59/0x200
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574612]  [<ffffffff81079470>] ? try_to_wake_up+0x2b0/0x2b0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574620]  [<ffffffff810964bc>] ? ktime_get_ts+0x4c/0xe0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574626]  [<ffffffff8118b575>] ? poll_select_set_timeout+0x85/0xa0
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574632]  [<ffffffff8118c7fb>] SyS_poll+0x6b/0x100
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574641]  [<ffffffff81681802>] system_call_fastpath+0x16/0x1b
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574644] Code: 89 d0 f0 0f b1 0f 39 d0 75 e5 b8 01 00 00 00 5d c3 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 9c 58 fa ba 00 00 01 00 <f0> 0f c1 17 89 d1 c1 e9 10 66 39 d1 74 0b 90 f3 90 0f b7 17 66 
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574679] RIP  [<ffffffff81678fa1>] _raw_spin_lock_irqsave+0x11/0x30
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574683]  RSP <ffff880228db5ab8>
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574684] CR2: ffffffffa0113000
Dec  4 14:02:03 host2-X8DTS kernel: [  501.574687] ---[ end trace 033ae58aa75ca232 ]---
Dec  4 14:09:01 host2-X8DTS kernel: [  919.511367] type=1400 audit(1386137341.577:29): apparmor="DENIED" operation="capable" parent=1 profile="/usr/sbin/cupsd" pid=1069 comm="cupsd" pid=1069 comm="cupsd" capability=36  capname="block_suspend"
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109803] BUG: unable to handle kernel paging request at ffffffffa0113000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109812] IP: [<ffffffff81678fa1>] _raw_spin_lock_irqsave+0x11/0x30
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109825] PGD 1c0c067 PUD 1c0d063 PMD 2289da067 PTE 0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109831] Oops: 0002 [#2] SMP 
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109835] Modules linked in: coretemp kvm_intel kvm bnep ghash_clmulni_intel rfcomm bluetooth aesni_intel ablk_helper joydev cryptd lrw gf128mul psmouse glue_helper i7core_edac aes_x86_64 gpio_ich ioatdma serio_raw edac_core microcode lpc_ich mac_hid parport_pc ppdev lp parport async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx hid_generic usbhid hid igb mpt2sas dca scsi_transport_sas i2c_algo_bit raid_class ptp mlx4_core pps_core [last unloaded: md_mod]
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109874] CPU: 9 PID: 1318 Comm: mdadm Tainted: G      D      3.10.21 #1
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109877] Hardware name: Supermicro B8DTP/B8DTP, BIOS 080015  03/17/2010
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109880] task: ffff8801281b5c40 ti: ffff880128fe8000 task.ti: ffff880128fe8000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109882] RIP: 0010:[<ffffffff81678fa1>]  [<ffffffff81678fa1>] _raw_spin_lock_irqsave+0x11/0x30
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109887] RSP: 0018:ffff880128fe9978  EFLAGS: 00010086
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109890] RAX: 0000000000000286 RBX: ffffffffa0113000 RCX: 0000000000000001
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109892] RDX: 0000000000010000 RSI: ffff880128fe9af8 RDI: ffffffffa0113000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109894] RBP: ffff880128fe9978 R08: 0000000000000001 R09: 0000000000000000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109895] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880128fe9af8
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109897] R13: ffff880128fe9ab8 R14: 0000000000000010 R15: ffff880228160400
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109900] FS:  00007f610504a700(0000) GS:ffff88023fca0000(0000) knlGS:0000000000000000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109902] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109904] CR2: ffffffffa0113000 CR3: 000000013abaa000 CR4: 00000000000007e0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109907] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109909] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109910] Stack:
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109912]  ffff880128fe9998 ffffffff8106a2f0 0000000000000001 ffff880128fe9ae8
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109917]  ffff880128fe99e8 ffffffff8118b1ee ffff880128fe99b8 0000000000000000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109921]  ffff880128fe99e8 0000000000000005 0000000000000005 0000000000000020
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109926] Call Trace:
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109933]  [<ffffffff8106a2f0>] remove_wait_queue+0x20/0x70
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109940]  [<ffffffff8118b1ee>] poll_freewait+0x4e/0xe0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109943]  [<ffffffff8118bba7>] do_select+0x617/0x690
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109948]  [<ffffffff8118b370>] ? __pollwait+0xf0/0xf0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109956]  [<ffffffff8112a1b4>] ? lru_cache_add_lru+0x24/0x50
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109962]  [<ffffffff8114e2c2>] ? page_add_new_anon_rmap+0x72/0xf0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109968]  [<ffffffff81143c17>] ? handle_pte_fault+0x7a7/0x920
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109973]  [<ffffffff812ae18e>] ? security_inode_alloc+0x1e/0x20
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109980]  [<ffffffff81199940>] ? seq_release+0x30/0x30
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109984]  [<ffffffff8119a0b4>] ? seq_open+0x84/0x160
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109991]  [<ffffffff8132719e>] ? radix_tree_lookup_slot+0xe/0x10
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.109997]  [<ffffffff8111cf4e>] ? find_get_page+0x1e/0x90
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110000]  [<ffffffff8111ea78>] ? filemap_fault+0xd8/0x4b0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110004]  [<ffffffff8111c1d7>] ? unlock_page+0x27/0x30
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110008]  [<ffffffff81140a29>] ? __do_fault+0x3b9/0x4a0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110012]  [<ffffffff8118bdf2>] core_sys_select+0x1d2/0x310
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110018]  [<ffffffff8167cdf4>] ? __do_page_fault+0x284/0x4e0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110022]  [<ffffffff8119a661>] ? seq_read+0x101/0x3e0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110028]  [<ffffffff810964bc>] ? ktime_get_ts+0x4c/0xe0
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110032]  [<ffffffff8118bff1>] SyS_select+0xc1/0x100
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110038]  [<ffffffff81681802>] system_call_fastpath+0x16/0x1b
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110040] Code: 89 d0 f0 0f b1 0f 39 d0 75 e5 b8 01 00 00 00 5d c3 66 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 9c 58 fa ba 00 00 01 00 <f0> 0f c1 17 89 d1 c1 e9 10 66 39 d1 74 0b 90 f3 90 0f b7 17 66 
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110073] RIP  [<ffffffff81678fa1>] _raw_spin_lock_irqsave+0x11/0x30
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110078]  RSP <ffff880128fe9978>
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110080] CR2: ffffffffa0113000
Dec  4 14:11:09 host2-X8DTS kernel: [ 1047.110083] ---[ end trace 033ae58aa75ca233 ]---

