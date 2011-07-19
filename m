From: "Sandra Escandor" <sescandor@evertz.com>
Subject: maybe a raid10 module issue?
Date: Tue, 19 Jul 2011 08:40:19 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFADCEAC7@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Question:
I've been looking at this issue for several days now. I think I might
have it narrowed down, so I would like to confirm if I am interpreting
the kernel log correctly. The situation is that there was I/O going on
to the RAID and then one of the disks drop out (due to some
communication error, which starts at the ata layer) - then the whole
system completely hangs after recovery finishes (after doing a cat
/proc/mdstat, the whole system hangs and a reboot was needed). 

So, to get more specific with my question: If the raid10 module has
disabled sdc (according to kernel log snippets below), why is there a
kernel log message after recovery that still involves sdc - no one
should be talking to sdc, correct? I can post more kernel log snippets
if needed.

I thought that the RAID would still be usable with 3 out of 4 disks
(since it's in RAID10 configuration) and no reboot would be needed.
Also, is this a known issue?

My interpretation is the following:
1. There was a RAID member disk communication error with device sdc
(starts from ata layer).
2. The raid10 module handles this and disables sdc, then says that it
will continue working with 3 out of 4 devices.
3. md driver starts a recovery of the RAID (all four disks are still
physically in, but one has been disabled by the raid10 module according
to the kernel log).
4. After md driver says that the recovery is done, a kernel log message
shows that there is an unhandled error code from sdc (but sdc was
supposed to have been removed by the raid10 module, right?).

System info:
Kernel 2.6.32-5-amd64
mdadm 3.1.4
four member disk raid10 - using imsm metadata container

Kernel Log snippet:

Jul  8 14:48:06 ecs-1u kernel: [ 8200.901003] ata3.00: exception Emask
0x0 SAct 0x1ffc0 SErr 0x0 action 0x6 frozen Jul  8 14:48:06 ecs-1u
kernel: [ 8200.901052] ata3.00: failed command: WRITE FPDMA QUEUED Jul
8 14:48:06 ecs-1u kernel: [ 8200.901082] ata3.00: cmd
61/00:30:80:37:3f/04:00:44:00:00/40 tag 6 ncq 524288 out
Jul  8 14:48:06 ecs-1u kernel: [ 8200.901083]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jul  8 14:48:06 ecs-1u kernel: [ 8200.901163] ata3.00: status: { DRDY }
Jul  8 14:48:06 ecs-1u kernel: [ 8200.901183] ata3.00: failed command:
WRITE FPDMA QUEUED Jul  8 14:48:06 ecs-1u kernel: [ 8200.901207]
ata3.00: cmd 61/00:38:80:3b:3f/04:00:44:00:00/40 tag 7 ncq 524288 out
Jul  8 14:48:06 ecs-1u kernel: [ 8200.901208]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jul  8 14:48:06 ecs-1u kernel: [ 8200.901282] ata3.00: status: { DRDY }

repeats...

Jul  8 14:57:19 ecs-1u kernel: [ 8753.699104] sd 2:0:0:0: [sdc]
Unhandled error code Jul  8 14:57:19 ecs-1u kernel: [ 8753.699107] sd
2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT Jul  8
14:57:19 ecs-1u kernel: [ 8753.699110] sd 2:0:0:0: [sdc] CDB: Write(10):
2a 00 3e cf 18 00 00 04 00 00 Jul  8 14:57:19 ecs-1u kernel: [
8753.699117] end_request: I/O error, dev sdc, sector 1053759488 Jul  8
14:57:19 ecs-1u kernel: [ 8753.699144] raid10: Disk failure on sdc,
disabling device.
Jul  8 14:57:19 ecs-1u kernel: [ 8753.699144] raid10: Operation
continuing on 3 devices.
Jul  8 14:57:19 ecs-1u kernel: [ 8753.699301] sd 2:0:0:0: [sdc]
Unhandled error code Jul  8 14:57:19 ecs-1u kernel: [ 8753.699303] sd
2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT Jul  8
14:57:19 ecs-1u kernel: [ 8753.699306] sd 2:0:0:0: [sdc] CDB: Write(10):
2a 00 3e cf 1c 00 00 04 00 00 Jul  8 14:57:19 ecs-1u kernel: [
8753.699311] end_request: I/O error, dev sdc, sector 1053760512 Jul  8
14:57:19 ecs-1u kernel: [ 8753.699430] sd 2:0:0:0: [sdc] Unhandled error
code Jul  8 14:57:19 ecs-1u kernel: [ 8753.699431] sd 2:0:0:0: [sdc]
Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT Jul  8 14:57:19 ecs-1u
kernel: [ 8753.699434] sd 2:0:0:0: [sdc] CDB: Write(10): 2a 00 3e cf 20
00 00 04 00 00 Jul  8 14:57:19 ecs-1u kernel: [ 8753.699439]
end_request: I/O error, dev sdc, sector 1053761536

repeats...

Jul  8 14:57:23 ecs-1u kernel: [ 8758.163655] md: recovery of RAID array
md126 Jul  8 14:57:23 ecs-1u kernel: [ 8758.163660] md: minimum
_guaranteed_  speed: 1000 KB/sec/disk.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163662] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163672] md: using 128k window,
over a total of 732572288 blocks.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163675] md: resuming recovery of
md126 from checkpoint.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.163677] md: md126: recovery done.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296414] RAID10 conf printout:
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296416]  --- wd:3 rd:4 Jul  8
14:57:23 ecs-1u kernel: [ 8758.296417]  disk 0, wo:0, o:1, dev:sdb Jul
8 14:57:23 ecs-1u kernel: [ 8758.296419]  disk 1, wo:1, o:0, dev:sdc Jul
8 14:57:23 ecs-1u kernel: [ 8758.296420]  disk 2, wo:0, o:1, dev:sdd Jul
8 14:57:23 ecs-1u kernel: [ 8758.296421]  disk 3, wo:0, o:1, dev:sde Jul
8 14:57:23 ecs-1u kernel: [ 8758.296673] md: recovery of RAID array
md126 Jul  8 14:57:23 ecs-1u kernel: [ 8758.296676] md: minimum
_guaranteed_  speed: 1000 KB/sec/disk.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296679] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296686] md: using 128k window,
over a total of 732572288 blocks.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296689] md: resuming recovery of
md126 from checkpoint.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.296691] md: md126: recovery done.
Jul  8 14:57:23 ecs-1u kernel: [ 8758.429448] RAID10 conf printout:
Jul  8 14:57:23 ecs-1u kernel: [ 8758.429450]  --- wd:3 rd:4 Jul  8
14:57:23 ecs-1u kernel: [ 8758.429452]  disk 0, wo:0, o:1, dev:sdb Jul
8 14:57:23 ecs-1u kernel: [ 8758.429453]  disk 1, wo:1, o:0, dev:sdc Jul
8 14:57:23 ecs-1u kernel: [ 8758.429454]  disk 2, wo:0, o:1, dev:sdd Jul
8 14:57:23 ecs-1u kernel: [ 8758.429455]  disk 3, wo:0, o:1, dev:sde

repeats resuming recovery of md126 message...then finally:

Jul  8 14:57:38 ecs-1u kernel: [ 8773.184362] md: recovery of RAID array
md126 Jul  8 14:57:38 ecs-1u kernel: [ 8773.184366] md: minimum
_guaranteed_  speed: 1000 KB/sec/disk.
Jul  8 14:57:38 ecs-1u kernel: [ 8773.184369] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
recovery.
Jul  8 14:57:38 ecs-1u kernel: [ 8773.184379] md: using 128k window,
over a total of 732572288 blocks.
Jul  8 14:57:38 ecs-1u kernel: [ 8773.184381] md: resuming recovery of
md126 from checkpoint.
Jul  8 14:57:38 ecs-1u kernel: [ 8773.184384] md: md126: recovery done.
Jul  8 14:57:38 ecs-1u kernel: [ 8773.340104] RAID10 conf printout:
Jul  8 14:57:38 ecs-1u kernel: [ 8773.340106]  --- wd:3 rd:4 Jul  8
14:57:38 ecs-1u kernel: [ 8773.340107]  disk 0, wo:0, o:1, dev:sdb Jul
8 14:57:38 ecs-1u kernel: [ 8773.340109]  disk 1, wo:1, o:0, dev:sdc Jul
8 14:57:38 ecs-1u kernel: [ 8773.340110]  disk 2, wo:0, o:1, dev:sdd Jul
8 14:57:38 ecs-1u kernel: [ 8773.340111]  disk 3, wo:0, o:1, dev:sde

The following is repeated:

Jul  8 14:58:17 ecs-1u kernel: [ 8812.088705] sd 2:0:0:0: [sdc]
Unhandled error code Jul  8 14:58:17 ecs-1u kernel: [ 8812.088710] sd
2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT Jul  8
14:58:17 ecs-1u kernel: [ 8812.088714] sd 2:0:0:0: [sdc] CDB: Write(10):
2a 00 3e cf 63 00 00 04 00 00 Jul  8 14:58:17 ecs-1u kernel: [
8812.088723] end_request: I/O error, dev sdc, sector 1053778688

Then:

Jul  8 15:01:22 ecs-1u kernel: [ 8997.041839] INFO: task kthreadd:2
blocked for more than 120 seconds.

A call trace follows this.

Then finally:

Jul  8 15:01:22 ecs-1u kernel: [ 8997.042076] INFO: task
md126_raid10:3493 blocked for more than 120 seconds.
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042101] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042138] md126_raid10  D
0000000000000000     0  3493      2 0x00000000
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042140]  ffff88033f02b880
0000000000000046 0000000000000000 0000000a00000006 Jul  8 15:01:22
ecs-1u kernel: [ 8997.042143]  0000006cffffffff ffff880006e0fa98
000000000000f9e0 ffff88033df07fd8 Jul  8 15:01:22 ecs-1u kernel: [
8997.042145]  0000000000015780 0000000000015780 ffff88033e79aa60
ffff88033e79ad58 Jul  8 15:01:22 ecs-1u kernel: [ 8997.042147] Call
Trace:
Jul  8 15:01:22 ecs-1u kernel: [ 8997.042150]  [<ffffffff811951d6>] ?
sprintf+0x51/0x59 Jul  8 15:01:22 ecs-1u kernel: [ 8997.042152]
[<ffffffff810414f5>] ? select_task_rq_fair+0x472/0x836 Jul  8 15:01:22
ecs-1u kernel: [ 8997.042154]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd Jul  8 15:01:22 ecs-1u kernel: [ 8997.042156]
[<ffffffff812fb26c>] ? wait_for_common+0xde/0x15b Jul  8 15:01:22 ecs-1u
kernel: [ 8997.042158]  [<ffffffff8104a440>] ?
default_wake_function+0x0/0x9 Jul  8 15:01:22 ecs-1u kernel: [
8997.042163]  [<ffffffff81064d7a>] ? kthread_create+0x93/0x121 Jul  8
15:01:22 ecs-1u kernel: [ 8997.042167]  [<ffffffffa0168764>] ?
md_thread+0x0/0x10f [md_mod] Jul  8 15:01:22 ecs-1u kernel: [
8997.042172]  [<ffffffff810e7fb9>] ? __kmalloc+0x12f/0x141 Jul  8
15:01:22 ecs-1u kernel: [ 8997.042175]  [<ffffffffa01686ba>] ?
md_register_thread+0x22/0xcc [md_mod] Jul  8 15:01:22 ecs-1u kernel: [
8997.042178]  [<ffffffffa0167510>] ? md_do_sync+0x0/0xaf6 [md_mod] Jul
8 15:01:22 ecs-1u kernel: [ 8997.042181]  [<ffffffffa016872e>] ?
md_register_thread+0x96/0xcc [md_mod] Jul  8 15:01:22 ecs-1u kernel: [
8997.042184]  [<ffffffffa016aee2>] ? md_check_recovery+0x3fd/0x4b9
[md_mod] Jul  8 15:01:22 ecs-1u kernel: [ 8997.042187]
[<ffffffffa018116c>] ? flush_pending_writes+0x13/0x8a [raid10] Jul  8
15:01:22 ecs-1u kernel: [ 8997.042190]  [<ffffffffa0181397>] ?
raid10d+0x42/0xade [raid10] Jul  8 15:01:22 ecs-1u kernel: [
8997.042191]  [<ffffffff812faff8>] ? thread_return+0x79/0xe0 Jul  8
15:01:22 ecs-1u kernel: [ 8997.042194]  [<ffffffff8101166e>] ?
apic_timer_interrupt+0xe/0x20 Jul  8 15:01:22 ecs-1u kernel: [
8997.042196]  [<ffffffff812fb055>] ? thread_return+0xd6/0xe0 Jul  8
15:01:22 ecs-1u kernel: [ 8997.042197]  [<ffffffff812fb3b5>] ?
schedule_timeout+0x2e/0xdd Jul  8 15:01:22 ecs-1u kernel: [ 8997.042200]
[<ffffffffa0168855>] ? md_thread+0xf1/0x10f [md_mod] Jul  8 15:01:22
ecs-1u kernel: [ 8997.042202]  [<ffffffff81064f0a>] ?
autoremove_wake_function+0x0/0x2e Jul  8 15:01:22 ecs-1u kernel: [
8997.042205]  [<ffffffffa0168764>] ? md_thread+0x0/0x10f [md_mod] Jul  8
15:01:22 ecs-1u kernel: [ 8997.042206]  [<ffffffff81064c3d>] ?
kthread+0x79/0x81 Jul  8 15:01:22 ecs-1u kernel: [ 8997.042208]
[<ffffffff81011baa>] ? child_rip+0xa/0x20 Jul  8 15:01:22 ecs-1u kernel:
[ 8997.042210]  [<ffffffff81064bc4>] ? kthread+0x0/0x81 Jul  8 15:01:22
ecs-1u kernel: [ 8997.042211]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20


