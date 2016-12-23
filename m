From: MasterPrenium <masterprenium.lkml@gmail.com>
Subject: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD - invalid opcode
Date: Fri, 23 Dec 2016 19:25:56 +0100
Message-ID: <585D6C34.2020908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, xen-users@lists.xen.org
Cc: linux-raid@vger.kernel.org, shli@kernel.org, "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>, xen-devel@lists.xenproject.org
List-Id: linux-raid.ids

Hello Guys,

I've having some trouble on a new system I'm setting up. I'm getting a kernel BUG message, seems to be related with the use of Xen (when I boot the system _without_ Xen, I don't get any crash).
Here is configuration :
- 3x Hard Drives running on RAID 5 Software raid created by mdadm
- On top of it, DRBD for replication over another node (Active/passive cluster)
- On top of it, a BTRFS FileSystem with a few subvolumes
- On top of it, XEN VMs running.

The BUG is happening when I'm making "huge" I/O (20MB/s with a rsync for example) on the RAID5 stack.
I've to reset system to make it work again.

Reproducible : ALWAYS (making the i/o, it crash in 2-5mins). Also reproducible on another system with the same hardware.

Kernel versions impacted (at least): kernel-4.4.26, kernel-4.8.15, kernel-4.9.0

Here dmesg errors :
[  937.123220] ------------[ cut here ]------------
[  937.127549] kernel BUG at drivers/md/raid5.c:527!
[  937.131891] invalid opcode: 0000 [#1] SMP
[  937.136216] Modules linked in: x86_pkg_temp_thermal coretemp crc32c_intel aesni_intel aes_x86_64 ablk_helper mei_me mei mpt3sas
[  937.145665] CPU: 2 PID: 9704 Comm: kworker/u16:8 Not tainted 4.9.0-gentoo #2
[  937.150293] Hardware name: Supermicro Super Server/X10SDV-4C-7TP4F, BIOS 1.0b 11/21/2016
[  937.155531] Workqueue: drbd0_submit do_submit
[  937.160506] task: ffff88026b0b2940 task.stack: ffffc9000a66c000
[  937.164115] RIP: e030:[<ffffffff819e1fc1>]  [<ffffffff819e1fc1>] raid5_get_active_stripe+0x5e1/0x670
[  937.169584] RSP: e02b:ffffc9000a66fa58  EFLAGS: 00010086
[  937.175070] RAX: 0000000000000000 RBX: ffff880249d50000 RCX: ffff8802648bb5d0
[  937.180640] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff880249d50000
[  937.185505] RBP: ffffc9000a66faf0 R08: ffff8801f4813288 R09: 0000000000000000
[  937.190631] R10: 0000000000000288 R11: 0000000000000000 R12: 0000000000000000
[  937.196030] R13: 000000001e773e88 R14: ffff880249d50000 R15: ffff8802648bb400
[  937.202011] FS:  0000000000000000(0000) GS:ffff880270c80000(0000) knlGS:ffff880270c80000
[  937.206628] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  937.212372] CR2: 00007f68a101b520 CR3: 0000000257875000 CR4: 0000000000042660
[  937.217538] Stack:
[  937.223361]  ffff8802648bb400 ffff880269550b40 0000000000000000 0000000166cf3800
[  937.229103]  000000001e773e88 ffff8802648bb5d0 0000000000000001 0000000000000000
[  937.233707]  ffff8802648bb40c 0000000000000001 ffffc9000a66faf0 ffff880047cba958
[  937.239736] Call Trace:
[  937.244406]  [<ffffffff819e21cd>] raid5_make_request+0x17d/0xdf0
[  937.250345]  [<ffffffff810bcfb0>] ? wake_up_atomic_t+0x30/0x30
[  937.256173]  [<ffffffff81a09c03>] md_make_request+0xe3/0x220
[  937.261031]  [<ffffffff81483e9b>] generic_make_request+0xcb/0x1a0
[  937.265615]  [<ffffffff81732537>] drbd_send_and_submit+0x497/0x1310
[  937.271605]  [<ffffffff810bcfb0>] ? wake_up_atomic_t+0x30/0x30
[  937.276726]  [<ffffffff817339ba>] send_and_submit_pending+0x6a/0x90
[  937.282292]  [<ffffffff81733e43>] do_submit+0x463/0x550
[  937.288333]  [<ffffffff810bcfb0>] ? wake_up_atomic_t+0x30/0x30
[  937.293205]  [<ffffffff81095400>] process_one_work+0x170/0x420
[  937.298982]  [<ffffffff810957d3>] worker_thread+0x123/0x500
[  937.304154]  [<ffffffff810956b0>] ? process_one_work+0x420/0x420
[  937.310314]  [<ffffffff810956b0>] ? process_one_work+0x420/0x420
[  937.316013]  [<ffffffff8109b135>] kthread+0xc5/0xe0
[  937.320918]  [<ffffffff8102c815>] ? __switch_to+0x355/0x7a0
[  937.327029]  [<ffffffff8109b070>] ? kthread_park+0x60/0x60
[  937.331994]  [<ffffffff81ccbbc5>] ret_from_fork+0x25/0x30
[  937.338068] Code: 85 d0 fb ff ff f0 41 80 8f 98 02 00 00 04 e9 c2 fb ff ff f3 90 41 8b 47 70 a8 01 75 f6 89 45 a4 e9 e2 fd ff ff 0f 0b 0f 0b 0f 0b <0f> 0b 49 89 d6 e9 e1 fa ff ff 49 8b 82 e8 01 00 00 4d 8b 8a e0
[  937.349579] RIP  [<ffffffff819e1fc1>] raid5_get_active_stripe+0x5e1/0x670
[  937.355290]  RSP <ffffc9000a66fa58>
[  937.386587] ---[ end trace b870be01f61065a5 ]---
[  941.931453] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  941.937139] IP: [<ffffffff810bcaa6>] __wake_up_common+0x26/0x80
[  941.943106] PGD 252dde067
[  941.943219] PUD 252ee7067
[  941.950107] PMD 0

[  941.956080] Oops: 0000 [#2] SMP
[  941.961919] Modules linked in: x86_pkg_temp_thermal coretemp crc32c_intel aesni_intel aes_x86_64 ablk_helper mei_me mei mpt3sas
[  941.974933] CPU: 2 PID: 9704 Comm: kworker/u16:8 Tainted: G      D         4.9.0-gentoo #2
[  941.982080] Hardware name: Supermicro Super Server/X10SDV-4C-7TP4F, BIOS 1.0b 11/21/2016
[  941.989296] task: ffff88026b0b2940 task.stack: ffffc9000a66c000
[  941.996831] RIP: e030:[<ffffffff810bcaa6>]  [<ffffffff810bcaa6>] __wake_up_common+0x26/0x80
[  942.004391] RSP: e02b:ffffc9000a66fe50  EFLAGS: 00010086
[  942.011818] RAX: 0000000000000200 RBX: ffffc9000a66ff18 RCX: 0000000000000000
[  942.019290] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffc9000a66ff18
[  942.026779] RBP: ffffc9000a66fe88 R08: 0000000000000000 R09: 0000000000000000
[  942.034246] R10: 0000000000000008 R11: 0000000000000001 R12: ffffc9000a66ff20
[  942.041693] R13: 0000000000000200 R14: 0000000000000000 R15: 0000000000000003
[  942.049166] FS:  0000000000000000(0000) GS:ffff880270c80000(0000) knlGS:ffff880270c80000
[  942.056599] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  942.063953] CR2: 0000000000000028 CR3: 0000000257875000 CR4: 0000000000042660
[  942.070841] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[  942.074862] BUG: unable to handle kernel paging request at ffffc9000234f8f8
[  942.078910] IP: [<ffffc9000234f8f8>] 0xffffc9000234f8f8
[  942.082961] PGD 1e9840067
[  942.083010] PUD 1e983f067
[  942.086963] PMD 26b42c067
[  942.086978] PTE 801000026b66c067

[  942.094822] Oops: 0011 [#3] SMP
[  942.098734] Modules linked in: x86_pkg_temp_thermal coretemp crc32c_intel aesni_intel aes_x86_64 ablk_helper mei_me mei mpt3sas
[  942.107222] CPU: 2 PID: 9704 Comm: kworker/u16:8 Tainted: G      D         4.9.0-gentoo #2
[  942.111581] Hardware name: Supermicro Super Server/X10SDV-4C-7TP4F, BIOS 1.0b 11/21/2016
[  942.116050] task: ffff88026b0b2940 task.stack: ffffc9000a66c000
[  942.120530] RIP: e030:[<ffffc9000234f8f8>]  [<ffffc9000234f8f8>] 0xffffc9000234f8f8
[  942.125019] RSP: e02b:ffffc9000a66fb80  EFLAGS: 00010082
[  942.129534] RAX: 0000000000000041 RBX: 0000000000042660 RCX: 0000000000000006
[  942.134355] RDX: 0000000000000041 RSI: ffffffff824e00a0 RDI: ffff880270c8dd80
[  942.138921] RBP: ffffc9000a66fbe0 R08: 0000000000000000 R09: 0000000000000000
[  942.143564] R10: 0000000000000008 R11: 0000000000000001 R12: 0000000080050033
[  942.148172] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  942.152837] FS:  0000000000000000(0000) GS:ffff880270c80000(0000) knlGS:ffff880270c80000
[  942.157525] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  942.162213] CR2: 0000000000000028 CR3: 0000000257875000 CR4: 0000000000042660
[  942.166954] Stack:
[  942.171576]  0000000257875000 0000000000000028 ffff880270c80000 ffff880270c80000
[  942.176267]  0000000000000000 0000e0330a66c000 0000000000000000 ffffc9000a66fda8
[  942.180918]  0000000000000000 ffffc9000a66fda8 0000000000000000 0000000000000000
[  942.185521] Call Trace:
[  942.190043]  [<ffffffff810302ad>] show_regs+0x2d/0x180
[  942.194605]  [<ffffffff81030725>] __die+0xa5/0xf0
[  942.199050]  [<ffffffff8106041e>] no_context+0x14e/0x3d0
[  942.203562]  [<ffffffff81060798>] __bad_area_nosemaphore+0xf8/0x1c0
[  942.208002]  [<ffffffff8106086f>] bad_area_nosemaphore+0xf/0x20
[  942.212478]  [<ffffffff81061034>] __do_page_fault+0x84/0x4b0
[  942.216797]  [<ffffffff8106148c>] do_page_fault+0x2c/0x40
[  942.221021]  [<ffffffff81ccd808>] page_fault+0x28/0x30
[  942.225184]  [<ffffffff810bcaa6>] ? __wake_up_common+0x26/0x80
[  942.229287]  [<ffffffff810bcb0e>] __wake_up_locked+0xe/0x10
[  942.233366]  [<ffffffff810bd4d2>] complete+0x32/0x50
[  942.237330]  [<ffffffff8107a500>] mm_release+0xc0/0x160
[  942.241216]  [<ffffffff81080206>] do_exit+0x136/0xb50
[  942.245056]  [<ffffffff81ccdc07>] rewind_stack_do_exit+0x17/0x20
[  942.248933] Code: c9 ff ff c0 cf 74 b7 01 88 ff ff 00 30 cf 66 02 88 ff ff 00 00 00 00 00 00 00 00 40 29 57 6b 02 88 ff ff b0 cf 0b 81 ff ff ff ff <70> fb 66 0a 00 c9 ff ff 88 b6 8b 64 02 88 ff ff 00 00 00 00 01
[  942.257683] RIP  [<ffffc9000234f8f8>] 0xffffc9000234f8f8
[  942.261814]  RSP <ffffc9000a66fb80>
[  942.265860] CR2: ffffc9000234f8f8
[  942.269830] ---[ end trace b870be01f61065a6 ]---
[  942.293603] Fixing recursive fault but reboot is needed!
[  962.926746] INFO: rcu_sched detected stalls on CPUs/tasks:
[  962.930582]  4-...: (1 GPs behind) idle=deb/140000000000000/0 softirq=51234/51234 fqs=5195
[  962.934400]  (detected by 1, t=21002 jiffies, g=26732, c=26731, q=173)
[  962.938231] Task dump for CPU 4:
[  962.942054] md10_raid5      R  running task    13232  2654      2 0x00000008
[  962.945939]  ffff880270d0dcc0 ffff880270ed8ec0 000000000306bc88 0000000000000000
[  962.949899]  0000000000000220 ffff8802648bb40c 0000000000000002 ffff8802648bb708
[  962.953781]  0000000000000001 ffffc9000306bcc8 ffffffff81ccb884 ffff8802648bb400
[  962.957570] Call Trace:
[  962.961272]  [<ffffffff81ccb884>] ? _raw_spin_lock_irqsave+0x54/0x60
[  962.964943]  [<ffffffff819d87f4>] ? release_inactive_stripe_list+0x44/0x180
[  962.968604]  [<ffffffff819e5469>] ? handle_active_stripes.isra.56+0x169/0x440
[  962.972253]  [<ffffffff819e5ae1>] ? raid5d+0x3a1/0x730
[  962.975825]  [<ffffffff81a094d3>] ? md_thread+0xf3/0x100
[  962.979360]  [<ffffffff810bcfb0>] ? wake_up_atomic_t+0x30/0x30
[  962.982900]  [<ffffffff81a093e0>] ? find_pers+0x70/0x70
[  962.986392]  [<ffffffff8109b135>] ? kthread+0xc5/0xe0
[  962.989881]  [<ffffffff8102c815>] ? __switch_to+0x355/0x7a0
[  962.993382]  [<ffffffff8109b070>] ? kthread_park+0x60/0x60
[  962.996858]  [<ffffffff81ccbbc5>] ? ret_from_fork+0x25/0x30
[ 1025.932534] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1025.936027]  4-...: (1 GPs behind) idle=deb/140000000000000/0 softirq=51234/51234 fqs=20780
[ 1025.939486]  (detected by 0, t=84014 jiffies, g=26732, c=26731, q=742)
[ 1025.942969] Task dump for CPU 4:
[ 1025.946373] md10_raid5      R  running task    13232  2654      2 0x00000008
[ 1025.949909]  ffff880270d0dcc0 ffff880270ed8ec0 000000000306bc88 0000000000000000
[ 1025.953451]  0000000000000220 ffff8802648bb40c 0000000000000002 ffff8802648bb708
[ 1025.957015]  0000000000000001 ffffc9000306bcc8 ffffffff81ccb884 ffff8802648bb400
[ 1025.960601] Call Trace:
[ 1025.964139]  [<ffffffff81ccb884>] ? _raw_spin_lock_irqsave+0x54/0x60
[ 1025.967724]  [<ffffffff819d87f4>] ? release_inactive_stripe_list+0x44/0x180
[ 1025.971351]  [<ffffffff819e5469>] ? handle_active_stripes.isra.56+0x169/0x440
[ 1025.975001]  [<ffffffff819e5ae1>] ? raid5d+0x3a1/0x730
[ 1025.978598]  [<ffffffff81a094d3>] ? md_thread+0xf3/0x100
[ 1025.982255]  [<ffffffff810bcfb0>] ? wake_up_atomic_t+0x30/0x30
[ 1025.985875]  [<ffffffff81a093e0>] ? find_pers+0x70/0x70
[ 1025.989496]  [<ffffffff8109b135>] ? kthread+0xc5/0xe0
[ 1025.993117]  [<ffffffff8102c815>] ? __switch_to+0x355/0x7a0
[ 1025.996707]  [<ffffffff8109b070>] ? kthread_park+0x60/0x60
[ 1026.000354]  [<ffffffff81ccbbc5>] ? ret_from_fork+0x25/0x30
[ 1088.937436] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1088.941109]  4-...: (1 GPs behind) idle=deb/140000000000000/0 softirq=51234/51234 fqs=36280
[ 1088.944649]  (detected by 0, t=147019 jiffies, g=26732, c=26731, q=1328)
[ 1088.948180] Task dump for CPU 4:
[ 1088.951671] md10_raid5      R  running task    13232  2654      2 0x00000008
[ 1088.955296]  ffff880270d0dcc0 ffff880270ed8ec0 000000000306bc88 0000000000000000
[ 1088.958963]  0000000000000220 ffff8802648bb40c 0000000000000002 ffff8802648bb708
[ 1088.962665]  0000000000000001 ffffc9000306bcc8 ffffffff81ccb884 ffff8802648bb400
[ 1088.966301] Call Trace:
[ 1088.969868]  [<ffffffff81ccb884>] ? _raw_spin_lock_irqsave+0x54/0x60
[ 1088.973451]  [<ffffffff819d87f4>] ? release_inactive_stripe_list+0x44/0x180
[ 1088.977020]  [<ffffffff819e5469>] ? handle_active_stripes.isra.56+0x169/0x440
[ 1088.980572]  [<ffffffff819e5ae1>] ? raid5d+0x3a1/0x730
[ 1088.984066]  [<ffffffff81a094d3>] ? md_thread+0xf3/0x100
[ 1088.987549]  [<ffffffff810bcfb0>] ? wake_up_atomic_t+0x30/0x30
[ 1088.991011]  [<ffffffff81a093e0>] ? find_pers+0x70/0x70
[ 1088.994444]  [<ffffffff8109b135>] ? kthread+0xc5/0xe0
[ 1088.997815]  [<ffffffff8102c815>] ? __switch_to+0x355/0x7a0
[ 1089.001181]  [<ffffffff8109b070>] ? kthread_park+0x60/0x60
[ 1089.004534]  [<ffffffff81ccbbc5>] ? ret_from_fork+0x25/0x30

(Another log here : http://pastebin.com/maxGFc1z)

Xen versions affected (at least): xen-4.6, xen-4.7, xen-4.8
xen-tools same version

Userland is a gentoo linux box.

Kernel .config : http://pastebin.com/p0EcHjbu

All buit with : gcc (Gentoo 4.9.3 p1.5, pie-0.6.4) 4.9.3

-> scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux Node_1 4.9.0-gentoo #2 SMP Fri Dec 23 16:37:48 CET 2016 x86_64 Intel(R) Xeon(R) CPU D-1518 @ 2.20GHz GenuineIntel GNU/Linux

GNU C                   4.9.3
GNU Make                4.1
Binutils                2.25.1
Util-linux              2.26.2
Mount                   2.26.2
Module-init-tools       22
E2fsprogs               1.43.3
Linux C Library         2.22
Dynamic linker (ldd)    2.22
Linux C++ Library       6.0.20
Procps                  3.3.12
Net-tools               1.60
Kbd                     2.0.3
Console-tools           2.0.3
Sh-utils                8.25
Udev                    220
Modules Loaded          ablk_helper aesni_intel aes_x86_64 coretemp crc32c_intel mei mei_me mpt3sas x86_pkg_temp_thermal

-> System is a SuperMicro Motherboard X10SDV-4C-7TP4F with 8GB of DDR 4 ECC Registered memory


Any help would be greatly appreciated !

Thanks,
