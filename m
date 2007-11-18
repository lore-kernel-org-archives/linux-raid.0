From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: raid6 resync blocks the entire system
Date: Sun, 18 Nov 2007 21:06:42 +0100
Message-ID: <fhq60j$an9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

on raid-initialization or later on a re-sync our systems become 
unresponsive. Ping still works, ssh won't succeed until the re-sync has 
finished, on a serial or local connection one can still type, as with ssh, 
whatever you request from the system won't be done until the raid-sync is 
done.

This is with 2.6.22, but as far as I remember we also observed this with 
2.6.23. Also, the higher the stripe cache size, the higher the 
probability the system will go into this state.

The system is booted diskles over nfs, so absolutely no i/o to the disks.

[ 3017.702688] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks
[ 3017.742667] SysRq : Show Blocked State
[ 3017.746617]
[ 3017.746618]                                  free                        sibling
[ 3017.755846]   task                 PC        stack   pid father child younger older
[ 3017.763830] md0_resync    D 000002bea0dece63     0  8909      2 (L-TLB)
[ 3017.770737]  ffff810123905ba0 0000000000000046 0000000000000000 0000000000000000
[ 3017.778424]  0000000300000000 ffff81012467bc10 000000010009bbd1 ffff810129e25050
[ 3017.786078]  00000000000001dc ffff81012b59f570 ffff810129e24ea0 0000000000000000
[ 3017.793523] Call Trace:
[ 3017.796270]  [<ffffffff881ed509>] :raid456:get_active_stripe+0x459/0x540
[ 3017.803190]  [<ffffffff881f2f71>] :raid456:sync_request+0x831/0x850
[ 3017.809607]  [<ffffffff8817ba19>] :md_mod:md_do_sync+0x539/0x930
[ 3017.815745]  [<ffffffff88177fc9>] :md_mod:md_thread+0x49/0x140
[ 3017.821705]  [<ffffffff80249adc>] kthread+0x6c/0xa0
[ 3017.826712]  [<ffffffff8020a888>] child_rip+0xa/0x12
[ 3017.831793]
[ 3017.833331] md1_resync    D 000002be9f6f1c7d     0  8917      2 (L-TLB)
[ 3017.840276]  ffff810123cffba0 0000000000000046 0000000000000000 0000000000000000
[ 3017.847955]  0000000300000000 ffff81012946c490 000000010009bbc8 ffff810129dfdaa0
[ 3017.855721]  000000000000073b ffff81012b59e100 ffff810129dfd8f0 0000000000000000
[ 3017.863225] Call Trace:
[ 3017.865915]  [<ffffffff881ed50e>] :raid456:get_active_stripe+0x45e/0x540
[ 3017.872946]  [<ffffffff881f2f71>] :raid456:sync_request+0x831/0x850
[ 3017.879510]  [<ffffffff8817ba19>] :md_mod:md_do_sync+0x539/0x930
[ 3017.885775]  [<ffffffff88177fc9>] :md_mod:md_thread+0x49/0x140
[ 3017.891865]  [<ffffffff80249adc>] kthread+0x6c/0xa0
[ 3017.896957]  [<ffffffff8020a888>] child_rip+0xa/0x12
[ 3017.902135]
[ 3017.903685] md2_resync    D 000002be9e4bded5     0  8925      2 (L-TLB)
[ 3017.910662]  ffff81012279dba0 0000000000000046 0000000000000000 0000000000000000
[ 3017.918227]  0000000000000000 0000000000000000 000000010009bbc2 ffff810129dfd3d0
[ 3017.925785]  000000000000024c ffff81012b510750 ffff810129dfd220 0000000000000000
[ 3017.933137] Call Trace:
[ 3017.935825]  [<ffffffff881ed50e>] :raid456:get_active_stripe+0x45e/0x540
[ 3017.942613]  [<ffffffff881f2f71>] :raid456:sync_request+0x831/0x850
[ 3017.948972]  [<ffffffff8817ba19>] :md_mod:md_do_sync+0x539/0x930
[ 3017.955071]  [<ffffffff88177fc9>] :md_mod:md_thread+0x49/0x140
[ 3017.960960]  [<ffffffff80249adc>] kthread+0x6c/0xa0
[ 3017.965883]  [<ffffffff8020a888>] child_rip+0xa/0x12
[ 3017.970894]
[ 3017.972417] mcelog        D 000002bae6ba88a2     0  9005   9003 (NOTLB)
[ 3017.979169]  ffff810115b09dd8 0000000000000082 0000000000000000 0000000000000000
[ 3017.986753]  ffff81012fd7b9e0 ffffffff80265bc5 000000010009ac27 ffff81012a84a3f0
[ 3017.994312]  0000000000001438 ffff81012b5f8810 ffff81012a84a240 0000000000000000
[ 3018.001671] Call Trace:
[ 3018.004341]  [<ffffffff804ed69e>] wait_for_completion+0x9e/0xf0
[ 3018.010347]  [<ffffffff8024783c>] synchronize_rcu+0x3c/0x50
[ 3018.015985]  [<ffffffff80213fb8>] mce_read+0x118/0x240
[ 3018.021189]  [<ffffffff8028e265>] vfs_read+0xb5/0x170
[ 3018.026287]  [<ffffffff8028e623>] sys_read+0x53/0x90
[ 3018.031325]  [<ffffffff80209a6e>] system_call+0x7e/0x83
[ 3018.036619]  [<00002b32d97b9cd0>]
[ 3018.039963]

Any ideas?

Thanks in advance,
Bernd


