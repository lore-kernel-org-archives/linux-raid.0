From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Wed, 3 Jun 2020 12:12:52 +0200
Message-ID: <0cf6454d-a8b5-4bee-5389-94b23c077050@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com>
 <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl>
 <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
 <f9b54d87-5b81-1fa3-04d5-ea86a6c062cb@yandex.pl>
 <CAPhsuW5ZfmCowTHNum5CSeadHqqPa5049weK6bq=m+JmnDE9Vg@mail.gmail.com>
 <d0340d7b-6b3a-4fd3-e446-5f0967132ef6@yandex.pl>
 <CAPhsuW4byXUvseqoj3Pw4r5nRGu=fHekdDec8FG6vj3of1wCyg@mail.gmail.com>
 <1cb6c63f-a74c-a6f4-6875-455780f53fa1@yandex.pl>
 <CAPhsuW6HdatOPJykqYCQs_7onWL1-AQRo05TygkXdRVSwAy_gQ@mail.gmail.com>
 <7b2b2bca-c1b7-06c5-10c5-2b1cdda21607@yandex.pl>
 <48e4fa28-4d20-ba80-cd69-b17da719531a@yandex.pl>
 <CAPhsuW69VYgLBZboxvQ6-Fmm-Oa0fGOVBg3SOVkzP_UopH+_wg@mail.gmail.com>
 <1767d7aa-6c60-7efb-bf37-6506f9aaa8a2@yandex.pl>
 <CAPhsuW4oMKuCrHUU1ucsMKQbSfBQdsNEQWHA1SSbGR5nbvy21w@mail.gmail.com>
 <CAPhsuW4WBDGGLYc=f4xoThxtxuF5K74m3odJ-uA98DuPLJR4nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4WBDGGLYc=f4xoThxtxuF5K74m3odJ-uA98DuPLJR4nw@mail.gmail.com>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/29/20 11:57 PM, Song Liu wrote:
>>
>> We can stop it. It didn't really hit any data checksum error in early phase
>> of the recovery. So it did found a long long journal to recover.
> 
> Could you please try the assemble again with the attached patch?
> 
> Thanks,
> Song
> 

[Jun 2 16:08] md: md124 stopped.
[  +0.008974] md/raid:md124: device sdf1 operational as raid disk 0
[  +0.006875] md/raid:md124: device sdj1 operational as raid disk 3
[  +0.006826] md/raid:md124: device sdh1 operational as raid disk 2
[  +0.006814] md/raid:md124: device sdg1 operational as raid disk 1
[  +0.007398] md/raid:md124: raid level 5 active with 4 out of 4 devices, algorithm 2
[  +0.008562] r5l_recovery_log starting from ctx->pos 160392632 ctx->seq 860687132
[ +11.215777] r5c_recovery_flush_log processing ctx->seq 860700000
[Jun 2 16:31] r5c_recovery_flush_log processing ctx->seq 860800000
[Jun 2 16:57] r5c_recovery_flush_log processing ctx->seq 860900000
[Jun 2 17:11] r5c_recovery_flush_log processing ctx->seq 861000000
[Jun 2 17:24] r5c_recovery_flush_log processing ctx->seq 861100000
[Jun 2 17:39] r5c_recovery_flush_log processing ctx->seq 861200000
[Jun 2 17:51] r5c_recovery_flush_log processing ctx->seq 861300000
[Jun 2 18:02] r5c_recovery_flush_log processing ctx->seq 861400000
[Jun 2 18:12] r5c_recovery_flush_log processing ctx->seq 861500000
[Jun 2 18:25] r5c_recovery_flush_log processing ctx->seq 861600000
[Jun 2 18:36] r5c_recovery_flush_log processing ctx->seq 861700000
[Jun 2 18:49] r5c_recovery_flush_log processing ctx->seq 861800000
[Jun 2 19:02] r5c_recovery_flush_log processing ctx->seq 861900000
[Jun 2 19:14] r5c_recovery_flush_log processing ctx->seq 862000000
[Jun 2 19:26] r5c_recovery_flush_log processing ctx->seq 862100000
[Jun 2 19:53] r5c_recovery_flush_log processing ctx->seq 862200000
[Jun 2 20:10] r5c_recovery_flush_log processing ctx->seq 862300000
[Jun 2 20:22] r5c_recovery_flush_log processing ctx->seq 862400000
[Jun 2 20:35] r5c_recovery_flush_log processing ctx->seq 862500000
[Jun 2 20:47] r5c_recovery_flush_log processing ctx->seq 862600000
[Jun 2 21:02] r5c_recovery_flush_log processing ctx->seq 862700000
[Jun 2 21:17] r5c_recovery_flush_log processing ctx->seq 862800000
[Jun 2 21:28] r5c_recovery_flush_log processing ctx->seq 862900000
[Jun 2 21:42] r5c_recovery_flush_log processing ctx->seq 863000000
[Jun 2 21:53] r5c_recovery_flush_log processing ctx->seq 863100000
[Jun 2 22:03] r5c_recovery_flush_log processing ctx->seq 863200000
[Jun 2 22:16] r5c_recovery_flush_log processing ctx->seq 863300000
[Jun 2 22:29] r5c_recovery_flush_log processing ctx->seq 863400000
[Jun 2 22:43] r5c_recovery_flush_log processing ctx->seq 863500000
[Jun 2 22:56] r5c_recovery_flush_log processing ctx->seq 863600000
[Jun 2 23:09] r5c_recovery_flush_log processing ctx->seq 863700000
[Jun 2 23:21] r5c_recovery_flush_log processing ctx->seq 863800000
[Jun 2 23:33] r5c_recovery_flush_log processing ctx->seq 863900000
[Jun 3 00:02] r5c_recovery_flush_log processing ctx->seq 864000000
[Jun 3 00:22] r5c_recovery_flush_log processing ctx->seq 864100000
[Jun 3 00:55] r5c_recovery_flush_log processing ctx->seq 864200000
[Jun 3 01:28] r5c_recovery_flush_log processing ctx->seq 864300000
[Jun 3 02:01] r5c_recovery_flush_log processing ctx->seq 864400000
[Jun 3 02:27] r5c_recovery_flush_log processing ctx->seq 864500000
[Jun 3 02:45] r5c_recovery_flush_log processing ctx->seq 864600000
[Jun 3 02:57] r5c_recovery_flush_log processing ctx->seq 864700000
[Jun 3 03:12] r5c_recovery_flush_log processing ctx->seq 864800000
[Jun 3 03:33] r5c_recovery_flush_log processing ctx->seq 864900000
[Jun 3 03:51] r5c_recovery_flush_log processing ctx->seq 865000000
[Jun 3 04:11] r5c_recovery_flush_log processing ctx->seq 865100000
[Jun 3 04:28] r5c_recovery_flush_log processing ctx->seq 865200000
[Jun 3 04:48] r5c_recovery_flush_log processing ctx->seq 865300000
[Jun 3 05:07] r5c_recovery_flush_log processing ctx->seq 865400000
[Jun 3 05:24] r5c_recovery_flush_log processing ctx->seq 865500000
[Jun 3 05:41] r5c_recovery_flush_log processing ctx->seq 865600000
[Jun 3 06:02] r5c_recovery_flush_log processing ctx->seq 865700000
[Jun 3 06:25] r5c_recovery_flush_log processing ctx->seq 865800000
[Jun 3 06:43] r5c_recovery_flush_log processing ctx->seq 865900000
[Jun 3 07:04] r5c_recovery_flush_log processing ctx->seq 866000000
[Jun 3 07:21] r5c_recovery_flush_log processing ctx->seq 866100000
[Jun 3 07:42] r5c_recovery_flush_log processing ctx->seq 866200000
[Jun 3 08:06] r5c_recovery_flush_log processing ctx->seq 866300000
[Jun 3 08:24] r5c_recovery_flush_log processing ctx->seq 866400000
[Jun 3 08:44] r5c_recovery_flush_log processing ctx->seq 866500000
[Jun 3 08:58] r5l_recovery_log finished scanning with ctx->pos 408082848 ctx->seq 866583360
[  +0.000003] md/raid:md124: recovering 24667 data-only stripes and 50212 data-parity stripes
[  +0.037320] r5c_recovery_rewrite_data_only_stripes rewritten 1 stripes to the journal, current ctx->pos 408082864 ctx->seq 866583361
[  +0.182558] r5c_recovery_rewrite_data_only_stripes rewritten 1001 stripes to the journal, current ctx->pos 408099592 ctx->seq 866584361
[  +0.180980] r5c_recovery_rewrite_data_only_stripes rewritten 2001 stripes to the journal, current ctx->pos 408115904 ctx->seq 866585361
[  +0.196148] r5c_recovery_rewrite_data_only_stripes rewritten 3001 stripes to the journal, current ctx->pos 408133600 ctx->seq 866586361
[  +0.221433] r5c_recovery_rewrite_data_only_stripes rewritten 4001 stripes to the journal, current ctx->pos 408153680 ctx->seq 866587361
[  +0.223732] r5c_recovery_rewrite_data_only_stripes rewritten 5001 stripes to the journal, current ctx->pos 408173152 ctx->seq 866588361
[  +0.228663] r5c_recovery_rewrite_data_only_stripes rewritten 6001 stripes to the journal, current ctx->pos 408192808 ctx->seq 866589361
[  +0.234246] r5c_recovery_rewrite_data_only_stripes rewritten 7001 stripes to the journal, current ctx->pos 408212760 ctx->seq 866590361
[  +0.242665] r5c_recovery_rewrite_data_only_stripes rewritten 8001 stripes to the journal, current ctx->pos 408233176 ctx->seq 866591361
[  +0.231829] r5c_recovery_rewrite_data_only_stripes rewritten 9001 stripes to the journal, current ctx->pos 408251696 ctx->seq 866592361
[  +0.250124] r5c_recovery_rewrite_data_only_stripes rewritten 10001 stripes to the journal, current ctx->pos 408270968 ctx->seq 866593361
[  +0.240402] r5c_recovery_rewrite_data_only_stripes rewritten 11001 stripes to the journal, current ctx->pos 408289976 ctx->seq 866594361
[  +0.250681] r5c_recovery_rewrite_data_only_stripes rewritten 12001 stripes to the journal, current ctx->pos 408309784 ctx->seq 866595361
[  +0.258173] r5c_recovery_rewrite_data_only_stripes rewritten 13001 stripes to the journal, current ctx->pos 408329888 ctx->seq 866596361
[  +0.235759] r5c_recovery_rewrite_data_only_stripes rewritten 14001 stripes to the journal, current ctx->pos 408349112 ctx->seq 866597361
[  +0.255747] r5c_recovery_rewrite_data_only_stripes rewritten 15001 stripes to the journal, current ctx->pos 408368984 ctx->seq 866598361
[  +0.255252] r5c_recovery_rewrite_data_only_stripes rewritten 16001 stripes to the journal, current ctx->pos 408386768 ctx->seq 866599361
[  +0.264333] r5c_recovery_rewrite_data_only_stripes rewritten 17001 stripes to the journal, current ctx->pos 408407072 ctx->seq 866600361
[  +0.261822] r5c_recovery_rewrite_data_only_stripes rewritten 18001 stripes to the journal, current ctx->pos 408425840 ctx->seq 866601361
[  +0.270390] r5c_recovery_rewrite_data_only_stripes rewritten 19001 stripes to the journal, current ctx->pos 408443976 ctx->seq 866602361
[  +0.266591] r5c_recovery_rewrite_data_only_stripes rewritten 20001 stripes to the journal, current ctx->pos 408461384 ctx->seq 866603361
[  +0.276480] r5c_recovery_rewrite_data_only_stripes rewritten 21001 stripes to the journal, current ctx->pos 408479568 ctx->seq 866604361
[  +0.272757] r5c_recovery_rewrite_data_only_stripes rewritten 22001 stripes to the journal, current ctx->pos 408496600 ctx->seq 866605361
[  +0.290148] r5c_recovery_rewrite_data_only_stripes rewritten 23001 stripes to the journal, current ctx->pos 408515472 ctx->seq 866606361
[  +0.274369] r5c_recovery_rewrite_data_only_stripes rewritten 24001 stripes to the journal, current ctx->pos 408532112 ctx->seq 866607361
[  +0.237468] r5c_recovery_rewrite_data_only_stripes done
[  +0.062124] r5c_recovery_flush_data_only_stripes enter
[  +0.063396] r5c_recovery_flush_data_only_stripes before wait_event
[Jun 3 09:02] INFO: task mdadm:2858 blocked for more than 120 seconds.
[  +0.060545]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.062932] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.068255] mdadm           D    0  2858   2751 0x00004002
[  +0.065247] Call Trace:
[  +0.056200]  ? __schedule+0x2e6/0x6f0
[  +0.054586]  schedule+0x2f/0xa0
[  +0.052803]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.053892]  ? finish_wait+0x80/0x80
[  +0.051771]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.051705]  do_md_run+0x64/0x100 [md_mod]
[  +0.051111]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.049628]  blkdev_ioctl+0x4d0/0xa00
[  +0.048213]  block_ioctl+0x39/0x40
[  +0.047055]  do_vfs_ioctl+0xa4/0x630
[  +0.046446]  ksys_ioctl+0x60/0x90
[  +0.046983]  __x64_sys_ioctl+0x16/0x20
[  +0.045661]  do_syscall_64+0x52/0x160
[  +0.043602]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.045892] RIP: 0033:0x7f72920c3427
[  +0.043231] Code: Bad RIP value.
[  +0.040553] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.046595] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.044504] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.044056] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.043743] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.042295] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:04] INFO: task mdadm:2858 blocked for more than 243 seconds.
[  +0.040957]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.040821] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.041663] mdadm           D    0  2858   2751 0x00004002
[  +0.038191] Call Trace:
[  +0.033593]  ? __schedule+0x2e6/0x6f0
[  +0.034067]  schedule+0x2f/0xa0
[  +0.032670]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.033911]  ? finish_wait+0x80/0x80
[  +0.031274]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.032020]  do_md_run+0x64/0x100 [md_mod]
[  +0.031191]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.030522]  blkdev_ioctl+0x4d0/0xa00
[  +0.028305]  block_ioctl+0x39/0x40
[  +0.026702]  do_vfs_ioctl+0xa4/0x630
[  +0.027148]  ksys_ioctl+0x60/0x90
[  +0.024758]  __x64_sys_ioctl+0x16/0x20
[  +0.025464]  do_syscall_64+0x52/0x160
[  +0.023894]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026684] RIP: 0033:0x7f72920c3427
[  +0.024336] Code: Bad RIP value.
[  +0.024689] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.028442] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.028941] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.028573] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028022] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028933] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:06] INFO: task mdadm:2858 blocked for more than 364 seconds.
[  +0.027274]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.029471] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030418] mdadm           D    0  2858   2751 0x00004002
[  +0.028200] Call Trace:
[  +0.024432]  ? __schedule+0x2e6/0x6f0
[  +0.026054]  schedule+0x2f/0xa0
[  +0.024534]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.029208]  ? finish_wait+0x80/0x80
[  +0.025526]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.028478]  do_md_run+0x64/0x100 [md_mod]
[  +0.027473]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.026305]  blkdev_ioctl+0x4d0/0xa00
[  +0.026246]  block_ioctl+0x39/0x40
[  +0.025604]  do_vfs_ioctl+0xa4/0x630
[  +0.025801]  ksys_ioctl+0x60/0x90
[  +0.025177]  __x64_sys_ioctl+0x16/0x20
[  +0.025306]  do_syscall_64+0x52/0x160
[  +0.025793]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026747] RIP: 0033:0x7f72920c3427
[  +0.025422] Code: Bad RIP value.
[  +0.023953] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.029392] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.027915] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.028305] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028820] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.029250] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:08] INFO: task mdadm:2858 blocked for more than 485 seconds.
[  +0.026953]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.030072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030385] mdadm           D    0  2858   2751 0x00004002
[  +0.027879] Call Trace:
[  +0.023949]  ? __schedule+0x2e6/0x6f0
[  +0.025820]  schedule+0x2f/0xa0
[  +0.024656]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.027525]  ? finish_wait+0x80/0x80
[  +0.025534]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.027898]  do_md_run+0x64/0x100 [md_mod]
[  +0.027299]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.025926]  blkdev_ioctl+0x4d0/0xa00
[  +0.026269]  block_ioctl+0x39/0x40
[  +0.025262]  do_vfs_ioctl+0xa4/0x630
[  +0.025799]  ksys_ioctl+0x60/0x90
[  +0.024000]  __x64_sys_ioctl+0x16/0x20
[  +0.025950]  do_syscall_64+0x52/0x160
[  +0.024311]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026696] RIP: 0033:0x7f72920c3427
[  +0.024260] Code: Bad RIP value.
[  +0.024967] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.028541] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.028687] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.028792] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028316] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028385] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:10] INFO: task mdadm:2858 blocked for more than 606 seconds.
[  +0.026999]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.029364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030553] mdadm           D    0  2858   2751 0x00004002
[  +0.030993] Call Trace:
[  +0.024346]  ? __schedule+0x2e6/0x6f0
[  +0.025899]  schedule+0x2f/0xa0
[  +0.024906]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.027654]  ? finish_wait+0x80/0x80
[  +0.026325]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.026537]  do_md_run+0x64/0x100 [md_mod]
[  +0.027048]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027328]  blkdev_ioctl+0x4d0/0xa00
[  +0.026367]  block_ioctl+0x39/0x40
[  +0.025746]  do_vfs_ioctl+0xa4/0x630
[  +0.025654]  ksys_ioctl+0x60/0x90
[  +0.024867]  __x64_sys_ioctl+0x16/0x20
[  +0.025322]  do_syscall_64+0x52/0x160
[  +0.024934]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026441] RIP: 0033:0x7f72920c3427
[  +0.025195] Code: Bad RIP value.
[  +0.023641] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.029224] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.028522] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.028499] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028515] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028559] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:12] INFO: task mdadm:2858 blocked for more than 727 seconds.
[  +0.027689]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.029425] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030441] mdadm           D    0  2858   2751 0x00004002
[  +0.028318] Call Trace:
[  +0.024240]  ? __schedule+0x2e6/0x6f0
[  +0.026113]  schedule+0x2f/0xa0
[  +0.024594]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.027742]  ? finish_wait+0x80/0x80
[  +0.026482]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.027073]  do_md_run+0x64/0x100 [md_mod]
[  +0.026928]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.026385]  blkdev_ioctl+0x4d0/0xa00
[  +0.026621]  block_ioctl+0x39/0x40
[  +0.026416]  do_vfs_ioctl+0xa4/0x630
[  +0.026045]  ksys_ioctl+0x60/0x90
[  +0.025177]  __x64_sys_ioctl+0x16/0x20
[  +0.025337]  do_syscall_64+0x52/0x160
[  +0.025306]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026347] RIP: 0033:0x7f72920c3427
[  +0.025397] Code: Bad RIP value.
[  +0.023684] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.029548] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.028548] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.028609] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028464] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028697] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:14] INFO: task mdadm:2858 blocked for more than 847 seconds.
[  +0.027980]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.028799] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030554] mdadm           D    0  2858   2751 0x00004002
[  +0.028257] Call Trace:
[  +0.023759]  ? __schedule+0x2e6/0x6f0
[  +0.025938]  schedule+0x2f/0xa0
[  +0.025325]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.030832]  ? finish_wait+0x80/0x80
[  +0.026344]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.026746]  do_md_run+0x64/0x100 [md_mod]
[  +0.027229]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027051]  blkdev_ioctl+0x4d0/0xa00
[  +0.025505]  block_ioctl+0x39/0x40
[  +0.026085]  do_vfs_ioctl+0xa4/0x630
[  +0.025163]  ksys_ioctl+0x60/0x90
[  +0.029285]  __x64_sys_ioctl+0x16/0x20
[  +0.029185]  do_syscall_64+0x52/0x160
[  +0.027525]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.030066] RIP: 0033:0x7f72920c3427
[  +0.028916] Code: Bad RIP value.
[  +0.026674] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.029693] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.028949] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.028409] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028117] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028542] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:16] INFO: task mdadm:2858 blocked for more than 968 seconds.
[  +0.028070]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.028488] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030356] mdadm           D    0  2858   2751 0x00004002
[  +0.028778] Call Trace:
[  +0.025616]  ? __schedule+0x2e6/0x6f0
[  +0.028651]  schedule+0x2f/0xa0
[  +0.028842]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.029961]  ? finish_wait+0x80/0x80
[  +0.028681]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.030107]  do_md_run+0x64/0x100 [md_mod]
[  +0.030568]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027043]  blkdev_ioctl+0x4d0/0xa00
[  +0.026720]  block_ioctl+0x39/0x40
[  +0.025781]  do_vfs_ioctl+0xa4/0x630
[  +0.024701]  ksys_ioctl+0x60/0x90
[  +0.025065]  __x64_sys_ioctl+0x16/0x20
[  +0.024444]  do_syscall_64+0x52/0x160
[  +0.025220]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.025739] RIP: 0033:0x7f72920c3427
[  +0.025300] Code: Bad RIP value.
[  +0.023582] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.029201] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.028748] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.027968] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028481] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028766] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:18] INFO: task mdadm:2858 blocked for more than 1089 seconds.
[  +0.028054]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.028400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030904] mdadm           D    0  2858   2751 0x00004002
[  +0.028077] Call Trace:
[  +0.024791]  ? __schedule+0x2e6/0x6f0
[  +0.025875]  schedule+0x2f/0xa0
[  +0.025618]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.027710]  ? finish_wait+0x80/0x80
[  +0.026291]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.026487]  do_md_run+0x64/0x100 [md_mod]
[  +0.028776]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.027002]  blkdev_ioctl+0x4d0/0xa00
[  +0.025169]  block_ioctl+0x39/0x40
[  +0.025991]  do_vfs_ioctl+0xa4/0x630
[  +0.024424]  ksys_ioctl+0x60/0x90
[  +0.025340]  __x64_sys_ioctl+0x16/0x20
[  +0.024386]  do_syscall_64+0x52/0x160
[  +0.025086]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.025950] RIP: 0033:0x7f72920c3427
[  +0.025552] Code: Bad RIP value.
[  +0.023459] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.030089] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.028770] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.027951] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.028993] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028520] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
[Jun 3 09:20] INFO: task mdadm:2858 blocked for more than 1210 seconds.
[  +0.028171]       Tainted: G            E     5.4.19-msl-00001-gbf39596faf12 #2
[  +0.028430] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  +0.030316] mdadm           D    0  2858   2751 0x00004002
[  +0.028004] Call Trace:
[  +0.024696]  ? __schedule+0x2e6/0x6f0
[  +0.025941]  schedule+0x2f/0xa0
[  +0.025382]  r5l_start.cold.43+0xb10/0xfca [raid456]
[  +0.027699]  ? finish_wait+0x80/0x80
[  +0.027329]  md_start.part.48+0x2e/0x50 [md_mod]
[  +0.026295]  do_md_run+0x64/0x100 [md_mod]
[  +0.027274]  md_ioctl+0xe7d/0x17d0 [md_mod]
[  +0.026747]  blkdev_ioctl+0x4d0/0xa00
[  +0.025499]  block_ioctl+0x39/0x40
[  +0.025981]  do_vfs_ioctl+0xa4/0x630
[  +0.025238]  ksys_ioctl+0x60/0x90
[  +0.024917]  __x64_sys_ioctl+0x16/0x20
[  +0.025268]  do_syscall_64+0x52/0x160
[  +0.025288]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  +0.026166] RIP: 0033:0x7f72920c3427
[  +0.027251] Code: Bad RIP value.
[  +0.027211] RSP: 002b:00007ffc2d2045f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.031611] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f72920c3427
[  +0.029797] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[  +0.028235] RBP: 00007ffc2d204770 R08: 000055f715c6ef40 R09: 000055f715a7ab60
[  +0.027762] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  +0.028697] R13: 0000000000000000 R14: 00007ffc2d204f20 R15: 0000000000000004
