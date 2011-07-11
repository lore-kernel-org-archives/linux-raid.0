From: "Sandra Escandor" <sescandor@evertz.com>
Subject: mdadm 3.1.4 - hanging on cat /proc/mdstat
Date: Mon, 11 Jul 2011 14:41:21 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD8CD18@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I'm facing an issue where it appears that only one RAID disk (on a
RAID10) is failing, but the whole RAID becomes unusable - when issuing a
cat /proc/mdstat, the system hangs. We actually had to recover by
restarting the system - then the failed disk was listed as removed in
output of "mdadm --detail /dev/md126". But the RAID should have still be
usable with only one disk failing - does anyone know what I should do to
work around this issue?

Some preliminary info:
RAID10 was built using Intel matrix storage manager metadata format,
using the commands:
1. "sudo mdadm -A /dev/md0 /dev/sd[b-g]" - in order to assemble the IMSM
container of the /dev/sd[b-g] devices.
2. "sudo mdadm -I /dev/md0" - in order to put the RAID member disks into
the container.
-Using mdadm 3.1.4 with kernel 2.6.32-5-amd64.

I've looked through the output of kern.log, and the following is what I
have interpreted:

1. It appears that there is some unhandled error that occurs with one of
the RAID member disks - /dev/sdc. ("I/O error, dev sdc, sector
1053765632")

Jul  8 14:57:19 ecs-1u kernel: [ 8753.699973] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:57:19 ecs-1u kernel: [ 8753.699975] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:57:19 ecs-1u kernel: [ 8753.699977] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 30 00 00 03 68 00
Jul  8 14:57:19 ecs-1u kernel: [ 8753.699982] end_request: I/O error,
dev sdc, sector 1053765632


2. md starts a recovery for the RAID array. The RAID10 conf printout
looks like the following:

Jul  8 14:57:23 ecs-1u kernel: [ 8758.163655] md: recovery of RAID array
md126
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163660] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163662] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163672] md: using 128k window,
over a total of 732572288 blocks.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163675] md: resuming recovery of
md126 from checkpoint.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163677] md: md126: recovery done.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296414] RAID10 conf printout:
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296416]  --- wd:3 rd:4
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296417]  disk 0, wo:0, o:1,
dev:sdb
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296419]  disk 1, wo:1, o:0,
dev:sdc
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296420]  disk 2, wo:0, o:1,
dev:sdd
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296421]  disk 3, wo:0, o:1,
dev:sde

3. But then another unhandled error occurs, and it looks like something
is causing the md126_raid10 task to block.

Jul  8 14:58:17 ecs-1u kernel: [ 8812.088705] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088710] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088714] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 63 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088723] end_request: I/O error,
dev sdc, sector 1053778688
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088775] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088776] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088778] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 67 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088781] end_request: I/O error,
dev sdc, sector 1053779712
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088817] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088818] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088820] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 6b 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088823] end_request: I/O error,
dev sdc, sector 1053780736
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088859] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088860] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088862] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 6f 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088865] end_request: I/O error,
dev sdc, sector 1053781760
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088909] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088910] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088912] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 73 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.088916] end_request: I/O error,
dev sdc, sector 1053782784
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089014] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089015] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089017] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 77 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089020] end_request: I/O error,
dev sdc, sector 1053783808
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089121] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089122] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089124] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 7b 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089127] end_request: I/O error,
dev sdc, sector 1053784832
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089236] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089237] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089239] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 7f 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089243] end_request: I/O error,
dev sdc, sector 1053785856
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089344] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089345] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089347] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 83 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089351] end_request: I/O error,
dev sdc, sector 1053786880
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089441] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089443] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089444] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 87 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089448] end_request: I/O error,
dev sdc, sector 1053787904
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089536] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089537] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089538] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 8b 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089542] end_request: I/O error,
dev sdc, sector 1053788928
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089631] sd 2:0:0:0: [sdc]
Unhandled error code
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089632] sd 2:0:0:0: [sdc] Result:
hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089634] sd 2:0:0:0: [sdc] CDB:
Write(10): 2a 00 3e cf 8f 00 00 04 00 00
Jul  8 14:58:17 ecs-1u kernel: [ 8812.089637] end_request: I/O error,
dev sdc, sector 1053789952
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041839] INFO: task kthreadd:2
blocked for more than 120 seconds.
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041867] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041905] kthreadd      D
0000000000000000     0     2      0 0x00000000
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041908]  ffff8801bf13aa60
0000000000000046 0000000000000000 ffff8801bf11d000
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041911]  0000000000000400
0000000000003737 000000000000f9e0 ffff8801bf067fd8
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041913]  0000000000015780
0000000000015780 ffff88033f028710 ffff88033f028a08
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041915] Call Trace:
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041925]  [<ffffffff810b41ed>] ?
sync_page+0x0/0x46
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041929]  [<ffffffff812fb0d2>] ?
io_schedule+0x73/0xb7
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041931]  [<ffffffff810b422e>] ?
sync_page+0x41/0x46
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041933]  [<ffffffff812fb5df>] ?
__wait_on_bit+0x41/0x70
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041935]  [<ffffffff810b43b2>] ?
wait_on_page_bit+0x6b/0x71
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041938]  [<ffffffff81064f38>] ?
wake_bit_function+0x0/0x23
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041943]  [<ffffffff810be14a>] ?
shrink_page_list+0x14e/0x623
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041948]  [<ffffffff8105a8e1>] ?
del_timer_sync+0xc/0x16
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041953]  [<ffffffff8101657d>] ?
read_tsc+0xa/0x20
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041955]  [<ffffffff812fb434>] ?
schedule_timeout+0xad/0xdd
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041958]  [<ffffffff8106c477>] ?
ktime_get_ts+0x68/0xb2
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041961]  [<ffffffff81099d36>] ?
delayacct_end+0x74/0x7f
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041963]  [<ffffffff810bd53b>] ?
isolate_pages_global+0x1a0/0x20f
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041965]  [<ffffffff81065009>] ?
finish_wait+0x35/0x60
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041967]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041969]  [<ffffffff810bee20>] ?
shrink_list+0x528/0x767
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041971]  [<ffffffff810bf2df>] ?
shrink_zone+0x280/0x342
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041975]  [<ffffffff810c76e8>] ?
zone_statistics+0x3c/0x5d
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041977]  [<ffffffff810b8593>] ?
zone_watermark_ok+0x20/0xb1
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041979]  [<ffffffff810bf76a>] ?
zone_reclaim+0x276/0x357
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041981]  [<ffffffff810bd39b>] ?
isolate_pages_global+0x0/0x20f
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041983]  [<ffffffff810b8593>] ?
zone_watermark_ok+0x20/0xb1
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041985]  [<ffffffff810b98bc>] ?
get_page_from_freelist+0x1ff/0x760
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041987]  [<ffffffff810ba184>] ?
__alloc_pages_nodemask+0x11c/0x5f4
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041994]  [<ffffffff8118e316>] ?
cpumask_next_and+0x2a/0x3a
Jul  8 15:01:22 ecs-1u kernel: [ 8997.041998]  [<ffffffff810453c3>] ?
find_busiest_group+0x9ae/0xa1e
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042001]  [<ffffffff81062afe>] ?
alloc_pid+0x26e/0x390
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042003]  [<ffffffff810b95c0>] ?
__get_free_pages+0x9/0x46
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042005]  [<ffffffff8104c506>] ?
copy_process+0xd7/0x115f
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042007]  [<ffffffff8104d6e5>] ?
do_fork+0x157/0x31e
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042009]  [<ffffffff81048261>] ?
finish_task_switch+0x3a/0xaf
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042012]  [<ffffffff81011b42>] ?
kernel_thread+0x82/0xe0
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042014]  [<ffffffff81064bc4>] ?
kthread+0x0/0x81
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042015]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042017]  [<ffffffff81064b89>] ?
kthreadd+0xb1/0xec
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042021]  [<ffffffff814f5140>] ?
early_idt_handler+0x0/0x71
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042022]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042024]  [<ffffffff814f5140>] ?
early_idt_handler+0x0/0x71
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042028]  [<ffffffff810e01b1>] ?
do_set_mempolicy+0x128/0x13a
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042029]  [<ffffffff81064ad8>] ?
kthreadd+0x0/0xec
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042031]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042076] INFO: task
md126_raid10:3493 blocked for more than 120 seconds.
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042101] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042138] md126_raid10  D
0000000000000000     0  3493      2 0x00000000
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042140]  ffff88033f02b880
0000000000000046 0000000000000000 0000000a00000006
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042143]  0000006cffffffff
ffff880006e0fa98 000000000000f9e0 ffff88033df07fd8
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042145]  0000000000015780
0000000000015780 ffff88033e79aa60 ffff88033e79ad58
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042147] Call Trace:
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042150]  [<ffffffff811951d6>] ?
sprintf+0x51/0x59
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042152]  [<ffffffff810414f5>] ?
select_task_rq_fair+0x472/0x836
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042154]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042156]  [<ffffffff812fb26c>] ?
wait_for_common+0xde/0x15b
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042158]  [<ffffffff8104a440>] ?
default_wake_function+0x0/0x9
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042163]  [<ffffffff81064d7a>] ?
kthread_create+0x93/0x121
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042167]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042172]  [<ffffffff810e7fb9>] ?
__kmalloc+0x12f/0x141
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042175]  [<ffffffffa01686ba>] ?
md_register_thread+0x22/0xcc [md_mod]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042178]  [<ffffffffa0167510>] ?
md_do_sync+0x0/0xaf6 [md_mod]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042181]  [<ffffffffa016872e>] ?
md_register_thread+0x96/0xcc [md_mod]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042184]  [<ffffffffa016aee2>] ?
md_check_recovery+0x3fd/0x4b9 [md_mod]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042187]  [<ffffffffa018116c>] ?
flush_pending_writes+0x13/0x8a [raid10]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042190]  [<ffffffffa0181397>] ?
raid10d+0x42/0xade [raid10]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042191]  [<ffffffff812faff8>] ?
thread_return+0x79/0xe0
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042194]  [<ffffffff8101166e>] ?
apic_timer_interrupt+0xe/0x20
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042196]  [<ffffffff812fb055>] ?
thread_return+0xd6/0xe0
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042197]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042200]  [<ffffffffa0168855>] ?
md_thread+0xf1/0x10f [md_mod]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042202]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042205]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042206]  [<ffffffff81064c3d>] ?
kthread+0x79/0x81
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042208]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042210]  [<ffffffff81064bc4>] ?
kthread+0x0/0x81
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042211]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963652] INFO: task kthreadd:2
blocked for more than 120 seconds.
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963680] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963718] kthreadd      D
0000000000000000     0     2      0 0x00000000
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963721]  ffff8801bf13aa60
0000000000000046 0000000000000000 ffff8801bf11d000
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963723]  0000000000000400
0000000000003737 000000000000f9e0 ffff8801bf067fd8
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963726]  0000000000015780
0000000000015780 ffff88033f028710 ffff88033f028a08
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963728] Call Trace:
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963737]  [<ffffffff810b41ed>] ?
sync_page+0x0/0x46
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963742]  [<ffffffff812fb0d2>] ?
io_schedule+0x73/0xb7
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963744]  [<ffffffff810b422e>] ?
sync_page+0x41/0x46
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963746]  [<ffffffff812fb5df>] ?
__wait_on_bit+0x41/0x70
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963748]  [<ffffffff810b43b2>] ?
wait_on_page_bit+0x6b/0x71
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963752]  [<ffffffff81064f38>] ?
wake_bit_function+0x0/0x23
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963755]  [<ffffffff810be14a>] ?
shrink_page_list+0x14e/0x623
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963760]  [<ffffffff8105a8e1>] ?
del_timer_sync+0xc/0x16
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963765]  [<ffffffff8101657d>] ?
read_tsc+0xa/0x20
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963766]  [<ffffffff812fb434>] ?
schedule_timeout+0xad/0xdd
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963769]  [<ffffffff8106c477>] ?
ktime_get_ts+0x68/0xb2
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963772]  [<ffffffff81099d36>] ?
delayacct_end+0x74/0x7f
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963774]  [<ffffffff810bd53b>] ?
isolate_pages_global+0x1a0/0x20f
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963776]  [<ffffffff81065009>] ?
finish_wait+0x35/0x60
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963778]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963780]  [<ffffffff810bee20>] ?
shrink_list+0x528/0x767
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963783]  [<ffffffff810bf2df>] ?
shrink_zone+0x280/0x342
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963786]  [<ffffffff810c76e8>] ?
zone_statistics+0x3c/0x5d
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963788]  [<ffffffff810b8593>] ?
zone_watermark_ok+0x20/0xb1
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963790]  [<ffffffff810bf76a>] ?
zone_reclaim+0x276/0x357
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963792]  [<ffffffff810bd39b>] ?
isolate_pages_global+0x0/0x20f
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963794]  [<ffffffff810b8593>] ?
zone_watermark_ok+0x20/0xb1
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963796]  [<ffffffff810b98bc>] ?
get_page_from_freelist+0x1ff/0x760
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963798]  [<ffffffff810ba184>] ?
__alloc_pages_nodemask+0x11c/0x5f4
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963804]  [<ffffffff8118e316>] ?
cpumask_next_and+0x2a/0x3a
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963808]  [<ffffffff810453c3>] ?
find_busiest_group+0x9ae/0xa1e
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963812]  [<ffffffff81062afe>] ?
alloc_pid+0x26e/0x390
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963813]  [<ffffffff810b95c0>] ?
__get_free_pages+0x9/0x46
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963816]  [<ffffffff8104c506>] ?
copy_process+0xd7/0x115f
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963818]  [<ffffffff8104d6e5>] ?
do_fork+0x157/0x31e
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963820]  [<ffffffff81048261>] ?
finish_task_switch+0x3a/0xaf
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963822]  [<ffffffff81011b42>] ?
kernel_thread+0x82/0xe0
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963824]  [<ffffffff81064bc4>] ?
kthread+0x0/0x81
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963825]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963827]  [<ffffffff81064b89>] ?
kthreadd+0xb1/0xec
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963831]  [<ffffffff814f5140>] ?
early_idt_handler+0x0/0x71
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963833]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963835]  [<ffffffff814f5140>] ?
early_idt_handler+0x0/0x71
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963838]  [<ffffffff810e01b1>] ?
do_set_mempolicy+0x128/0x13a
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963840]  [<ffffffff81064ad8>] ?
kthreadd+0x0/0xec
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963842]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963886] INFO: task
md126_raid10:3493 blocked for more than 120 seconds.
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963911] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963949] md126_raid10  D
0000000000000000     0  3493      2 0x00000000
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963951]  ffff88033f02b880
0000000000000046 0000000000000000 0000000a00000006
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963953]  0000006cffffffff
ffff880006e0fa98 000000000000f9e0 ffff88033df07fd8
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963955]  0000000000015780
0000000000015780 ffff88033e79aa60 ffff88033e79ad58
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963957] Call Trace:
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963961]  [<ffffffff811951d6>] ?
sprintf+0x51/0x59
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963963]  [<ffffffff810414f5>] ?
select_task_rq_fair+0x472/0x836
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963965]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963967]  [<ffffffff812fb26c>] ?
wait_for_common+0xde/0x15b
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963969]  [<ffffffff8104a440>] ?
default_wake_function+0x0/0x9
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963973]  [<ffffffff81064d7a>] ?
kthread_create+0x93/0x121
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963977]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963982]  [<ffffffff810e7fb9>] ?
__kmalloc+0x12f/0x141
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963985]  [<ffffffffa01686ba>] ?
md_register_thread+0x22/0xcc [md_mod]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963988]  [<ffffffffa0167510>] ?
md_do_sync+0x0/0xaf6 [md_mod]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963991]  [<ffffffffa016872e>] ?
md_register_thread+0x96/0xcc [md_mod]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963994]  [<ffffffffa016aee2>] ?
md_check_recovery+0x3fd/0x4b9 [md_mod]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963997]  [<ffffffffa018116c>] ?
flush_pending_writes+0x13/0x8a [raid10]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.963999]  [<ffffffffa0181397>] ?
raid10d+0x42/0xade [raid10]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964001]  [<ffffffff812faff8>] ?
thread_return+0x79/0xe0
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964003]  [<ffffffff8101166e>] ?
apic_timer_interrupt+0xe/0x20
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964005]  [<ffffffff812fb055>] ?
thread_return+0xd6/0xe0
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964007]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964010]  [<ffffffffa0168855>] ?
md_thread+0xf1/0x10f [md_mod]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964012]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964014]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964016]  [<ffffffff81064c3d>] ?
kthread+0x79/0x81
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964018]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964019]  [<ffffffff81064bc4>] ?
kthread+0x0/0x81
Jul  8 15:03:22 ecs-1u kernel: [ 9116.964021]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885452] INFO: task kthreadd:2
blocked for more than 120 seconds.
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885477] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885515] kthreadd      D
0000000000000000     0     2      0 0x00000000
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885517]  ffff8801bf13aa60
0000000000000046 0000000000000000 ffff8801bf11d000
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885519]  0000000000000400
0000000000003737 000000000000f9e0 ffff8801bf067fd8
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885521]  0000000000015780
0000000000015780 ffff88033f028710 ffff88033f028a08
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885523] Call Trace:
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885527]  [<ffffffff810b41ed>] ?
sync_page+0x0/0x46
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885529]  [<ffffffff812fb0d2>] ?
io_schedule+0x73/0xb7
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885531]  [<ffffffff810b422e>] ?
sync_page+0x41/0x46
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885533]  [<ffffffff812fb5df>] ?
__wait_on_bit+0x41/0x70
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885535]  [<ffffffff810b43b2>] ?
wait_on_page_bit+0x6b/0x71
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885537]  [<ffffffff81064f38>] ?
wake_bit_function+0x0/0x23
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885539]  [<ffffffff810be14a>] ?
shrink_page_list+0x14e/0x623
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885542]  [<ffffffff8105a8e1>] ?
del_timer_sync+0xc/0x16
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885544]  [<ffffffff8101657d>] ?
read_tsc+0xa/0x20
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885545]  [<ffffffff812fb434>] ?
schedule_timeout+0xad/0xdd
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885547]  [<ffffffff8106c477>] ?
ktime_get_ts+0x68/0xb2
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885549]  [<ffffffff81099d36>] ?
delayacct_end+0x74/0x7f
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885551]  [<ffffffff810bd53b>] ?
isolate_pages_global+0x1a0/0x20f
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885553]  [<ffffffff81065009>] ?
finish_wait+0x35/0x60
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885554]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885556]  [<ffffffff810bee20>] ?
shrink_list+0x528/0x767
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885559]  [<ffffffff810bf2df>] ?
shrink_zone+0x280/0x342
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885561]  [<ffffffff810c76e8>] ?
zone_statistics+0x3c/0x5d
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885563]  [<ffffffff810b8593>] ?
zone_watermark_ok+0x20/0xb1
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885565]  [<ffffffff810bf76a>] ?
zone_reclaim+0x276/0x357
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885567]  [<ffffffff810bd39b>] ?
isolate_pages_global+0x0/0x20f
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885568]  [<ffffffff810b8593>] ?
zone_watermark_ok+0x20/0xb1
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885570]  [<ffffffff810b98bc>] ?
get_page_from_freelist+0x1ff/0x760
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885573]  [<ffffffff810ba184>] ?
__alloc_pages_nodemask+0x11c/0x5f4
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885575]  [<ffffffff8118e316>] ?
cpumask_next_and+0x2a/0x3a
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885577]  [<ffffffff810453c3>] ?
find_busiest_group+0x9ae/0xa1e
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885579]  [<ffffffff81062afe>] ?
alloc_pid+0x26e/0x390
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885581]  [<ffffffff810b95c0>] ?
__get_free_pages+0x9/0x46
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885583]  [<ffffffff8104c506>] ?
copy_process+0xd7/0x115f
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885585]  [<ffffffff8104d6e5>] ?
do_fork+0x157/0x31e
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885587]  [<ffffffff81048261>] ?
finish_task_switch+0x3a/0xaf
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885589]  [<ffffffff81011b42>] ?
kernel_thread+0x82/0xe0
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885590]  [<ffffffff81064bc4>] ?
kthread+0x0/0x81
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885592]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885594]  [<ffffffff81064b89>] ?
kthreadd+0xb1/0xec
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885596]  [<ffffffff814f5140>] ?
early_idt_handler+0x0/0x71
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885598]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885600]  [<ffffffff814f5140>] ?
early_idt_handler+0x0/0x71
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885602]  [<ffffffff810e01b1>] ?
do_set_mempolicy+0x128/0x13a
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885603]  [<ffffffff81064ad8>] ?
kthreadd+0x0/0xec
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885605]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885616] INFO: task
md126_raid10:3493 blocked for more than 120 seconds.
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885641] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885678] md126_raid10  D
0000000000000000     0  3493      2 0x00000000
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885681]  ffff88033f02b880
0000000000000046 0000000000000000 0000000a00000006
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885683]  0000006cffffffff
ffff880006e0fa98 000000000000f9e0 ffff88033df07fd8
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885685]  0000000000015780
0000000000015780 ffff88033e79aa60 ffff88033e79ad58
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885687] Call Trace:
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885689]  [<ffffffff811951d6>] ?
sprintf+0x51/0x59
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885691]  [<ffffffff810414f5>] ?
select_task_rq_fair+0x472/0x836
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885692]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885694]  [<ffffffff812fb26c>] ?
wait_for_common+0xde/0x15b
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885696]  [<ffffffff8104a440>] ?
default_wake_function+0x0/0x9
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885699]  [<ffffffff81064d7a>] ?
kthread_create+0x93/0x121
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885702]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885705]  [<ffffffff810e7fb9>] ?
__kmalloc+0x12f/0x141
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885708]  [<ffffffffa01686ba>] ?
md_register_thread+0x22/0xcc [md_mod]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885711]  [<ffffffffa0167510>] ?
md_do_sync+0x0/0xaf6 [md_mod]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885714]  [<ffffffffa016872e>] ?
md_register_thread+0x96/0xcc [md_mod]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885716]  [<ffffffffa016aee2>] ?
md_check_recovery+0x3fd/0x4b9 [md_mod]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885719]  [<ffffffffa018116c>] ?
flush_pending_writes+0x13/0x8a [raid10]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885721]  [<ffffffffa0181397>] ?
raid10d+0x42/0xade [raid10]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885723]  [<ffffffff812faff8>] ?
thread_return+0x79/0xe0
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885725]  [<ffffffff8101166e>] ?
apic_timer_interrupt+0xe/0x20
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885727]  [<ffffffff812fb055>] ?
thread_return+0xd6/0xe0
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885728]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885731]  [<ffffffffa0168855>] ?
md_thread+0xf1/0x10f [md_mod]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885733]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885736]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885738]  [<ffffffff81064c3d>] ?
kthread+0x79/0x81
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885739]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885741]  [<ffffffff81064bc4>] ?
kthread+0x0/0x81
Jul  8 15:05:22 ecs-1u kernel: [ 9236.885742]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20

....

Jul  8 15:07:22 ecs-1u kernel: [ 9356.807402] INFO: task
md126_raid10:3493 blocked for more than 120 seconds.
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807427] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807465] md126_raid10  D
0000000000000000     0  3493      2 0x00000000
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807467]  ffff88033f02b880
0000000000000046 0000000000000000 0000000a00000006
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807469]  0000006cffffffff
ffff880006e0fa98 000000000000f9e0 ffff88033df07fd8
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807471]  0000000000015780
0000000000015780 ffff88033e79aa60 ffff88033e79ad58
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807473] Call Trace:
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807475]  [<ffffffff811951d6>] ?
sprintf+0x51/0x59
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807477]  [<ffffffff810414f5>] ?
select_task_rq_fair+0x472/0x836
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807479]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807481]  [<ffffffff812fb26c>] ?
wait_for_common+0xde/0x15b
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807483]  [<ffffffff8104a440>] ?
default_wake_function+0x0/0x9
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807485]  [<ffffffff81064d7a>] ?
kthread_create+0x93/0x121
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807488]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807491]  [<ffffffff810e7fb9>] ?
__kmalloc+0x12f/0x141
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807494]  [<ffffffffa01686ba>] ?
md_register_thread+0x22/0xcc [md_mod]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807497]  [<ffffffffa0167510>] ?
md_do_sync+0x0/0xaf6 [md_mod]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807500]  [<ffffffffa016872e>] ?
md_register_thread+0x96/0xcc [md_mod]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807503]  [<ffffffffa016aee2>] ?
md_check_recovery+0x3fd/0x4b9 [md_mod]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807506]  [<ffffffffa018116c>] ?
flush_pending_writes+0x13/0x8a [raid10]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807508]  [<ffffffffa0181397>] ?
raid10d+0x42/0xade [raid10]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807510]  [<ffffffff812faff8>] ?
thread_return+0x79/0xe0
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807511]  [<ffffffff8101166e>] ?
apic_timer_interrupt+0xe/0x20
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807513]  [<ffffffff812fb055>] ?
thread_return+0xd6/0xe0
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807515]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807518]  [<ffffffffa0168855>] ?
md_thread+0xf1/0x10f [md_mod]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807520]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807522]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod]
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807524]  [<ffffffff81064c3d>] ?
kthread+0x79/0x81
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807526]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807527]  [<ffffffff81064bc4>] ?
kthread+0x0/0x81
Jul  8 15:07:22 ecs-1u kernel: [ 9356.807529]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20

4. Eventually, the server is restarted because it's just hanging on cat
/proc/mdstat

Jul 12 00:11:06 ecs-1u kernel: [300990.576353] md: ioctl lock
interrupted, reason -4, cmd -2142762735
Jul 12 00:15:16 ecs-1u kernel: [301240.301494] md: ioctl lock
interrupted, reason -4, cmd -2142762735
Jul 12 00:17:35 ecs-1u kernel: [301379.418775] md: ioctl lock
interrupted, reason -4, cmd -2142762735
