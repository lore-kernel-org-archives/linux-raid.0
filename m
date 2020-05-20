From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Wed, 20 May 2020 14:08:38 +0200
Message-ID: <f395b710-cfd0-065b-de38-382abc52b358@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl>
 <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl>
 <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl>
 <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl>
 <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/19/20 1:55 AM, Song Liu wrote:
> 
> Thanks for these information.
> 
> It looks like the kernel had some issue in recovery. Could you please
> try the following:
> 
> 1. check dmesg, we should see one of the following at some point:
>      pr_info("md/raid:%s: starting from clean shutdown\n",
> or
>      pr_info("md/raid:%s: recovering %d data-only stripes and %d
> data-parity stripes\n",
> 
> 2. try use bcc/bpftrace to trace r5l_recovery_read_page(),
> specifically, the 4th argument.
> With bcc, it is something like:
> 
>      trace.py -M 100 'r5l_recovery_read_page() "%llx", arg4'
> 
> -M above limits the number of outputs to 100 lines. We may need to
> increase the limit or
> remove the constraint. If the system doesn't have bcc/bpftrace. You
> can also try with
> kprobe.
> 
> Thanks,
> Song
> 

Will do the above tests in coming days.

As for dmesg, it was always clean after mdadm's invocation (that's why I 
never noticed it), but today I found on the machine that the following 
popped around *19* hours after mdadm assembly was started:

Note - since the last dmesg entry yesterday, nothing new showed up in 
dmesg, and the mdadm is still running.

ps a -o command,lstart | grep mdadm
strace -f -o mdadm.strace.l Mon May 18 13:25:45 2020
mdadm -A /dev/md/r5_big /de Mon May 18 13:25:45 2020



[May19 09:53] md/raid:md124: recovering 24667 data-only stripes and 
50212 data-parity stripes
[May19 09:57] INFO: task mdadm:4698 blocked for more than 120 seconds.
[  +0.007114]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.007881] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.008754] mdadm           D    0  4698   4695 0x00004003
[  +0.006128] Call Trace:
[  +0.002599]  ? __schedule+0x2e6/0x6f0
[  +0.004222]  schedule+0x2f/0xa0
[  +0.003519]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.005560]  ? finish_wait+0x80/0x80
[  +0.003901]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.005175]  do_md_run+0x64/0x100 [md_mod]
[  +0.004582]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.004675]  blkdev_ioctl+0x4d0/0xa00
[  +0.004104]  block_ioctl+0x39/0x40
[  +0.003806]  do_vfs_ioctl+0xa4/0x630
[  +0.004004]  ksys_ioctl+0x60/0x90
[  +0.003697]  __x64_sys_ioctl+0x16/0x20
[  +0.003966]  do_syscall_64+0x52/0x160
[  +0.004100]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.005658] RIP: 0033:0x7efcb9969427
[  +0.004118] Code: Bad RIP value.
[  +0.003611] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.008461] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.007964] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.007965] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.007968] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.008034] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 09:59] INFO: task mdadm:4698 blocked for more than 241 seconds.
[  +0.007113]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.031011] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.032417] mdadm           D    0  4698   4695 0x00004003
[  +0.030883] Call Trace:
[  +0.027037]  ? __schedule+0x2e6/0x6f0
[  +0.027109]  schedule+0x2f/0xa0
[  +0.026651]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.028842]  ? finish_wait+0x80/0x80
[  +0.026646]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.027846]  do_md_run+0x64/0x100 [md_mod]
[  +0.027423]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027029]  blkdev_ioctl+0x4d0/0xa00
[  +0.027716]  block_ioctl+0x39/0x40
[  +0.028195]  do_vfs_ioctl+0xa4/0x630
[  +0.028868]  ksys_ioctl+0x60/0x90
[  +0.028845]  __x64_sys_ioctl+0x16/0x20
[  +0.030159]  do_syscall_64+0x52/0x160
[  +0.029944]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.029988] RIP: 0033:0x7efcb9969427
[  +0.027728] Code: Bad RIP value.
[  +0.025732] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.028386] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.028462] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.028854] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.027692] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028838] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:01] INFO: task mdadm:4698 blocked for more than 362 seconds.
[  +0.027842]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.028293] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.029933] mdadm           D    0  4698   4695 0x00004003
[  +0.027836] Call Trace:
[  +0.025804]  ? __schedule+0x2e6/0x6f0
[  +0.025857]  schedule+0x2f/0xa0
[  +0.025504]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.026469]  ? finish_wait+0x80/0x80
[  +0.026253]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.026693]  do_md_run+0x64/0x100 [md_mod]
[  +0.027043]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027063]  blkdev_ioctl+0x4d0/0xa00
[  +0.025390]  block_ioctl+0x39/0x40
[  +0.026334]  do_vfs_ioctl+0xa4/0x630
[  +0.025508]  ksys_ioctl+0x60/0x90
[  +0.024969]  __x64_sys_ioctl+0x16/0x20
[  +0.024461]  do_syscall_64+0x52/0x160
[  +0.025266]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.025898] RIP: 0033:0x7efcb9969427
[  +0.025336] Code: Bad RIP value.
[  +0.023623] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.029437] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.028688] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.028993] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.028810] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028715] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:03] INFO: task mdadm:4698 blocked for more than 483 seconds.
[  +0.028312]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.029922] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.029811] mdadm           D    0  4698   4695 0x00004003
[  +0.028094] Call Trace:
[  +0.024963]  ? __schedule+0x2e6/0x6f0
[  +0.025823]  schedule+0x2f/0xa0
[  +0.029291]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.031421]  ? finish_wait+0x80/0x80
[  +0.028282]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.026902]  do_md_run+0x64/0x100 [md_mod]
[  +0.026903]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.026249]  blkdev_ioctl+0x4d0/0xa00
[  +0.026441]  block_ioctl+0x39/0x40
[  +0.026720]  do_vfs_ioctl+0xa4/0x630
[  +0.025734]  ksys_ioctl+0x60/0x90
[  +0.025040]  __x64_sys_ioctl+0x16/0x20
[  +0.025255]  do_syscall_64+0x52/0x160
[  +0.024974]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026676] RIP: 0033:0x7efcb9969427
[  +0.025491] Code: Bad RIP value.
[  +0.023661] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.029253] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.027865] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.029299] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.028662] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028661] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:05] INFO: task mdadm:4698 blocked for more than 604 seconds.
[  +0.028120]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.028921] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.030050] mdadm           D    0  4698   4695 0x00004003
[  +0.028201] Call Trace:
[  +0.025739]  ? __schedule+0x2e6/0x6f0
[  +0.025130]  schedule+0x2f/0xa0
[  +0.025862]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.026863]  ? finish_wait+0x80/0x80
[  +0.026362]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.028033]  do_md_run+0x64/0x100 [md_mod]
[  +0.026302]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027130]  blkdev_ioctl+0x4d0/0xa00
[  +0.025276]  block_ioctl+0x39/0x40
[  +0.025804]  do_vfs_ioctl+0xa4/0x630
[  +0.025543]  ksys_ioctl+0x60/0x90
[  +0.025133]  __x64_sys_ioctl+0x16/0x20
[  +0.025289]  do_syscall_64+0x52/0x160
[  +0.025019]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.027423] RIP: 0033:0x7efcb9969427
[  +0.025241] Code: Bad RIP value.
[  +0.024188] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.029330] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.028777] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.029321] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.030312] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028756] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:07] INFO: task mdadm:4698 blocked for more than 724 seconds.
[  +0.028161]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.029025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.029438] mdadm           D    0  4698   4695 0x00004003
[  +0.027906] Call Trace:
[  +0.024749]  ? __schedule+0x2e6/0x6f0
[  +0.025400]  schedule+0x2f/0xa0
[  +0.027335]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.030223]  ? finish_wait+0x80/0x80
[  +0.028959]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.029618]  do_md_run+0x64/0x100 [md_mod]
[  +0.026927]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.026187]  blkdev_ioctl+0x4d0/0xa00
[  +0.026722]  block_ioctl+0x39/0x40
[  +0.026070]  do_vfs_ioctl+0xa4/0x630
[  +0.026268]  ksys_ioctl+0x60/0x90
[  +0.025397]  __x64_sys_ioctl+0x16/0x20
[  +0.025492]  do_syscall_64+0x52/0x160
[  +0.025293]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026295] RIP: 0033:0x7efcb9969427
[  +0.025152] Code: Bad RIP value.
[  +0.023763] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.029591] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.027850] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.028603] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.028714] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028870] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:09] INFO: task mdadm:4698 blocked for more than 845 seconds.
[  +0.028077]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.029226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.029321] mdadm           D    0  4698   4695 0x00004003
[May19 10:10] Call Trace:
[  +0.025422]  ? __schedule+0x2e6/0x6f0
[  +0.025490]  schedule+0x2f/0xa0
[  +0.026722]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.026858]  ? finish_wait+0x80/0x80
[  +0.026399]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.027444]  do_md_run+0x64/0x100 [md_mod]
[  +0.026228]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027008]  blkdev_ioctl+0x4d0/0xa00
[  +0.025656]  block_ioctl+0x39/0x40
[  +0.026068]  do_vfs_ioctl+0xa4/0x630
[  +0.025899]  ksys_ioctl+0x60/0x90
[  +0.025539]  __x64_sys_ioctl+0x16/0x20
[  +0.025885]  do_syscall_64+0x52/0x160
[  +0.025075]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026798] RIP: 0033:0x7efcb9969427
[  +0.024981] Code: Bad RIP value.
[  +0.024604] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.028628] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.028698] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.028732] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.027649] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.029800] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:12] INFO: task mdadm:4698 blocked for more than 966 seconds.
[  +0.030285]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.032412] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.033870] mdadm           D    0  4698   4695 0x00004003
[  +0.031620] Call Trace:
[  +0.028343]  ? __schedule+0x2e6/0x6f0
[  +0.028456]  schedule+0x2f/0xa0
[  +0.025514]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.028027]  ? finish_wait+0x80/0x80
[  +0.025278]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.028173]  do_md_run+0x64/0x100 [md_mod]
[  +0.027243]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.026750]  blkdev_ioctl+0x4d0/0xa00
[  +0.026450]  block_ioctl+0x39/0x40
[  +0.025187]  do_vfs_ioctl+0xa4/0x630
[  +0.025689]  ksys_ioctl+0x60/0x90
[  +0.024076]  __x64_sys_ioctl+0x16/0x20
[  +0.025253]  do_syscall_64+0x52/0x160
[  +0.024310]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.027527] RIP: 0033:0x7efcb9969427
[  +0.024193] Code: Bad RIP value.
[  +0.024483] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.028585] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.029009] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.028403] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.027510] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028629] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:14] INFO: task mdadm:4698 blocked for more than 1087 seconds.
[  +0.028117]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.029008] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.030891] mdadm           D    0  4698   4695 0x00004003
[  +0.027018] Call Trace:
[  +0.024698]  ? __schedule+0x2e6/0x6f0
[  +0.025217]  schedule+0x2f/0xa0
[  +0.025613]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.027065]  ? finish_wait+0x80/0x80
[  +0.026013]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.027664]  do_md_run+0x64/0x100 [md_mod]
[  +0.026160]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027902]  blkdev_ioctl+0x4d0/0xa00
[  +0.026085]  block_ioctl+0x39/0x40
[  +0.026057]  do_vfs_ioctl+0xa4/0x630
[  +0.025886]  ksys_ioctl+0x60/0x90
[  +0.024539]  __x64_sys_ioctl+0x16/0x20
[  +0.025231]  do_syscall_64+0x52/0x160
[  +0.025571]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026934] RIP: 0033:0x7efcb9969427
[  +0.024585] Code: Bad RIP value.
[  +0.024635] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.029237] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.031792] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.031758] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.031567] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028862] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
[May19 10:16] INFO: task mdadm:4698 blocked for more than 1208 seconds.
[  +0.028273]       Not tainted 5.4.0-0.bpo.4-amd64 #1 Debian 
5.4.19-1~bpo10+1
[  +0.029463] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  +0.031789] mdadm           D    0  4698   4695 0x00004003
[  +0.028022] Call Trace:
[  +0.024606]  ? __schedule+0x2e6/0x6f0
[  +0.026123]  schedule+0x2f/0xa0
[  +0.024892]  r5l_start.cold.43+0x544/0x549 [raid456]
[  +0.027620]  ? finish_wait+0x80/0x80
[  +0.025492]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.027706]  do_md_run+0x64/0x100 [md_mod]
[  +0.026976]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.026705]  blkdev_ioctl+0x4d0/0xa00
[  +0.027531]  block_ioctl+0x39/0x40
[  +0.024963]  do_vfs_ioctl+0xa4/0x630
[  +0.025568]  ksys_ioctl+0x60/0x90
[  +0.024137]  __x64_sys_ioctl+0x16/0x20
[  +0.025538]  do_syscall_64+0x52/0x160
[  +0.024200]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026633] RIP: 0033:0x7efcb9969427
[  +0.024619] Code: Bad RIP value.
[  +0.024698] RSP: 002b:00007ffd902f2508 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  +0.029381] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007efcb9969427
[  +0.028794] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 
0000000000000004
[  +0.028724] RBP: 00007ffd902f2680 R08: 0000561686dc6f40 R09: 
00005616858b9b60
[  +0.028828] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000002
[  +0.028030] R13: 0000000000000000 R14: 00007ffd902f2e30 R15: 
0000000000000004
