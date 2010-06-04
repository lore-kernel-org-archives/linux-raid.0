From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Call Trace / Kernel Panic with mdadm 2.6.9 on Ubuntu Hardy 8.04.3 LTS
Date: Thu, 3 Jun 2010 23:44:39 -0700
Message-ID: <AANLkTine86MYYfZSE3f0HhkP5vtepmNeFI8CPX51mOCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, fibre raid <fibreraid@gmail.com>
List-Id: linux-raid.ids

Hi All,

I am facing a kernel panic situation on Ubuntu 8.04.3 (Hardy) 64-bit
related to mdadm.

Hardware:
Dual Processor Xeon 2.8 GHz
2GB RAM
12 SATA 7200 rpm Seagate 500GB hard drives
LSI SAS 3G HBAs for connectivity (3442X-R and 3080X-R)

Software:
Ubuntu Hardy 8.04.3 64-bit
mdadm 2.6.9

I want to create the equivalent of a RAID 50 group. To do so:
1. I create md0 with 5 drives and 1 hot-spare using RAID 5
2. I create md1 with 5 drives and 1 hot-spare using RAID 5
3. I create md2 with md0 and md1 as the drives using RAID 0

This works without any issues. The md0 and md1 begin to sync in the
background, and md2 is available. Here is the mdadm.conf file:

ARRAY /dev/md0 level=raid5 num-devices=5 metadata=1.2 spares=1 name=0
UUID=0e79b34e:0534d8c1:24f952c6:a0cd0720
ARRAY /dev/md1 level=raid5 num-devices=5 metadata=1.2 spares=1 name=1
UUID=2cdf5f12:414dfe1e:7a43ec05:7a04ced4
ARRAY /dev/md2 level=raid0 num-devices=2 metadata=1.2 name=2
UUID=a0ef7393:4ab50ba3:ec684ed5:9552e7ff

I then reboot the system using shutdown -r command BEFORE either md0
and md1 are fully synchronized. When the system comes back up, I see a
Call Trace related to mdadm. Upon further inspection, I find the
following in /var/log/messages:

Jun  3 23:23:39 SERVER kernel: [  660.131032] RIP:
0010:[raid456:handle_stripe5+0x196/0x16b0]
[raid456:handle_stripe5+0x196/0x16b0]
:raid456:handle_stripe5+0x196/0x16b0
Jun  3 23:23:39 SERVER kernel: [  660.131049] RSP:
0018:ffff81007989fc40  EFLAGS: 00000207
Jun  3 23:23:39 SERVER kernel: [  660.131051] RAX: 00000000000002c0
RBX: ffff810037842200 RCX: ffff8100737a2b08
Jun  3 23:23:39 SERVER kernel: [  660.131055] RDX: ffff8100737a2b00
RSI: 0000000000000004 RDI: 0000000000000004
Jun  3 23:23:39 SERVER kernel: [  660.131057] RBP: ffffffff88187f9f
R08: 0000000000000020 R09: ffff810068fd4000
Jun  3 23:23:39 SERVER kernel: [  660.131059] R10: ffff810068fd7000
R11: 000000008005003b R12: 0000000000000000
Jun  3 23:23:39 SERVER kernel: [  660.131062] R13: 0000000000000005
R14: 0000000000000001 R15: ffff810068fd2000
Jun  3 23:23:39 SERVER kernel: [  660.131066] FS:
0000000000000000(0000) GS:ffff81007dc01d00(0000)
knlGS:0000000000000000
Jun  3 23:23:39 SERVER kernel: [  660.131069] CS:  0010 DS: 0018 ES:
0018 CR0: 000000008005003b
Jun  3 23:23:39 SERVER kernel: [  660.131071] CR2: 00007f59464810e0
CR3: 0000000000201000 CR4: 00000000000006e0
Jun  3 23:23:39 SERVER kernel: [  660.131074] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jun  3 23:23:39 SERVER kernel: [  660.131076] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  3 23:23:39 SERVER kernel: [  660.131078]
Jun  3 23:23:39 SERVER kernel: [  660.131079] Call Trace:
Jun  3 23:23:39 SERVER kernel: [  660.131107]
[enqueue_task+0x13/0x30] enqueue_task+0x13/0x30
Jun  3 23:23:39 SERVER kernel: [  660.131117]
[task_rq_lock+0x4c/0x90] task_rq_lock+0x4c/0x90
Jun  3 23:23:39 SERVER kernel: [  660.131184]
[md_mod:md_thread+0x0/0x100] :md_mod:md_thread+0x0/0x100
Jun  3 23:23:39 SERVER kernel: [  660.131205]
[raid456:handle_stripe+0x2d/0x1030] :raid456:handle_stripe+0x2d/0x1030
Jun  3 23:23:39 SERVER kernel: [  660.131267]
[nfs:__wake_up+0x43/0x1d50] __wake_up+0x43/0x70
Jun  3 23:23:39 SERVER kernel: [  660.131312]
[md_mod:md_thread+0x0/0x100] :md_mod:md_thread+0x0/0x100
Jun  3 23:23:39 SERVER kernel: [  660.131334]
[raid456:raid5d+0x320/0x400] :raid456:raid5d+0x320/0x400
Jun  3 23:23:39 SERVER kernel: [  660.131357]
[md_mod:md_thread+0x0/0x100] :md_mod:md_thread+0x0/0x100
Jun  3 23:23:39 SERVER kernel: [  660.131418]
[md_mod:md_thread+0x0/0x100] :md_mod:md_thread+0x0/0x100
Jun  3 23:23:39 SERVER kernel: [  660.131446]
[md_mod:md_thread+0x30/0x100] :md_mod:md_thread+0x30/0x100
Jun  3 23:23:39 SERVER kernel: [  660.131462]  [<ffffffff80254350>]
autoremove_wake_function+0x0/0x30
Jun  3 23:23:39 SERVER kernel: [  660.131495]
[md_mod:md_thread+0x0/0x100] :md_mod:md_thread+0x0/0x100
Jun  3 23:23:39 SERVER kernel: [  660.131508]  [kthread+0x4b/0x80]
kthread+0x4b/0x80
Jun  3 23:23:39 SERVER kernel: [  660.131525]  [child_rip+0xa/0x12]
child_rip+0xa/0x12
Jun  3 23:23:39 SERVER kernel: [  660.131580]  [kthread+0x0/0x80]
kthread+0x0/0x80
Jun  3 23:23:39 SERVER kernel: [  660.131590]  [child_rip+0x0/0x12]
child_rip+0x0/0x12
Jun  3 23:23:39 SERVER kernel: [  660.131608]

As a test, I renamed the mdadm.conf file so that the arrays would not
start up during the boot process. Then, Ubuntu had no problem booting.
But if I renamed the mdadm.conf back to mdadm.conf, and ran "mdadm
--assemble --scan", I once again got the kernel panic. So, clearly
mdadm seems to be causing the panic when it is trying to bring up
these arrays. I checked dmesg and found no other evidence that any
other modules are having problems (besides mdadm).

Any suggestions on what is causing this or recommended fixes? Thanks!

Best regards,
-Thomas
