From: "John Stilson" <john9601@gmail.com>
Subject: RAID 10 resync leading to attempt to access beyond end of device
Date: Wed, 14 Feb 2007 17:08:56 -0500
Message-ID: <e1e9d81a0702141408k4f42887by4d4c4c9aa9d536c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

    I'm experiencing what appears to be a kernel bug in the raid10 driver,
where immediately after a resync completes an access beyond the end of the
rebuilt disk is attempted which causes the disk to be failed.

    The system is a single-processor dual-core Xeon 3000 at 1.86GHz. It has
four 250GB drives, two each on two channels of an Intel ICH7. It's running
Fedora Core 4 with a custom compiled unpatched 2.6.20 kernel. I can provide
the kernel itself, config, etc on request.

    Here is a full dmesg output from where the /dev/sdc1, part of /dev/md0
was intentionally failed using mdadm /dev/md0 -f /dev/sdc1, mdadm /dev/md0
-r /dev/sdc1, mdadm /dev/md0 -a /dev/sdc1.

Feb 14 16:20:18 testsvr kernel: raid10: Disk failure on sdc1, disabling
device.
Feb 14 16:20:18 testsvr kernel:      Operation continuing on 3 devices
Feb 14 16:20:18 testsvr kernel: RAID10 conf printout:
Feb 14 16:20:18 testsvr kernel:  --- wd:3 rd:4
Feb 14 16:20:18 testsvr kernel:  disk 0, wo:0, o:1, dev:sda9
Feb 14 16:20:18 testsvr kernel:  disk 1, wo:0, o:1, dev:sdb1
Feb 14 16:20:18 testsvr kernel:  disk 2, wo:1, o:0, dev:sdc1
Feb 14 16:20:18 testsvr kernel:  disk 3, wo:0, o:1, dev:sdd1
Feb 14 16:20:18 testsvr kernel: RAID10 conf printout:
Feb 14 16:20:18 testsvr kernel:  --- wd:3 rd:4
Feb 14 16:20:18 testsvr kernel:  disk 0, wo:0, o:1, dev:sda9
Feb 14 16:20:18 testsvr kernel:  disk 1, wo:0, o:1, dev:sdb1
Feb 14 16:20:18 testsvr kernel:  disk 3, wo:0, o:1, dev:sdd1
Feb 14 16:20:20 testsvr kernel: md: unbind<sdc1>
Feb 14 16:20:20 testsvr kernel: md: export_rdev(sdc1)
Feb 14 16:20:23 testsvr kernel: md: bind<sdc1>
Feb 14 16:20:23 testsvr kernel: RAID10 conf printout:
Feb 14 16:20:23 testsvr kernel:  --- wd:3 rd:4
Feb 14 16:20:23 testsvr kernel:  disk 0, wo:0, o:1, dev:sda9
Feb 14 16:20:23 testsvr kernel:  disk 1, wo:0, o:1, dev:sdb1
Feb 14 16:20:23 testsvr kernel:  disk 2, wo:1, o:1, dev:sdc1
Feb 14 16:20:23 testsvr kernel:  disk 3, wo:0, o:1, dev:sdd1
Feb 14 16:20:23 testsvr kernel: md: recovery of RAID array md0
Feb 14 16:20:23 testsvr kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Feb 14 16:20:23 testsvr kernel: md: using maximum available idle IO
bandwidth (but not more than 40000 KB/sec) for recovery.
Feb 14 16:20:23 testsvr kernel: md: using 128k window, over a total of
8040320 blocks.
Feb 14 16:23:45 testsvr kernel: md: md0: recovery done.
Feb 14 16:23:45 testsvr kernel: attempt to access beyond end of device
Feb 14 16:23:45 testsvr kernel: sdc1: rw=1, want=901904331651136,
limit=16081002
Feb 14 16:23:45 testsvr kernel: raid10: Disk failure on sdc1, disabling
device.
Feb 14 16:23:45 testsvr kernel:      Operation continuing on 3 devices
Feb 14 16:23:45 testsvr kernel: RAID10 conf printout:
Feb 14 16:23:45 testsvr kernel:  --- wd:3 rd:4
Feb 14 16:23:45 testsvr kernel:  disk 0, wo:0, o:1, dev:sda9
Feb 14 16:23:45 testsvr kernel:  disk 1, wo:0, o:1, dev:sdb1
Feb 14 16:23:45 testsvr kernel:  disk 2, wo:1, o:0, dev:sdc1
Feb 14 16:23:45 testsvr kernel:  disk 3, wo:0, o:1, dev:sdd1
Feb 14 16:23:45 testsvr kernel: RAID10 conf printout:
Feb 14 16:23:45 testsvr kernel:  --- wd:3 rd:4
Feb 14 16:23:45 testsvr kernel:  disk 0, wo:0, o:1, dev:sda9
Feb 14 16:23:45 testsvr kernel:  disk 1, wo:0, o:1, dev:sdb1
Feb 14 16:23:45 testsvr kernel:  disk 3, wo:0, o:1, dev:sdd1

    I made the kernel OOPS during handle_bad_sector in ll_rw_blk.c to try
and get a backtrace, however the backtrace looks mildly suspicious, so I
think it may not be a good indicator. Here it is anyway:

Feb 13 14:25:23 testsvr kernel: Oops: 0000 [#1]
Feb 13 14:25:23 testsvr kernel: SMP
Feb 13 14:25:23 testsvr kernel: CPU:    0
Feb 13 14:25:23 testsvr kernel: EIP:    0060:[<c022b55a>]    Not tainted VLI

Feb 13 14:25:23 testsvr kernel: EFLAGS: 00010296   (2.6.19.1 #3)
Feb 13 14:25:23 testsvr kernel: EIP is at handle_bad_sector+0x96/0xf0
Feb 13 14:25:23 testsvr kernel: eax: 00000039   ebx: 00000001   ecx:
f6a7c9c0   edx: 00000082
Feb 13 14:25:23 testsvr kernel: esi: 00000000   edi: f6a7c9c0   ebp:
f7451e58   esp: f7451df4
Feb 13 14:25:23 testsvr kernel: ds: 007b   es: 007b   ss: 0068
Feb 13 14:25:23 testsvr kernel: Process md0_raid10 (pid: 2267, ti=f7450000
task=f6ed2550 task.ti=f7450000)
Feb 13 14:25:23 testsvr kernel: Stack: c044c950 f7451e2c 00000001 00000102
f7ee0208 00f5606a 00000000 00000002
Feb 13 14:25:23 testsvr kernel:        f7fb0408 eac0d400 00000001 00000102
f7ee0208 00000001 31646473 00000000
Feb 13 14:25:23 testsvr kernel:        f6e80000 00000086 c0124ce1 00000086
f6e81bc0 f7fb0408 f7ee0208 f6a7c9c0
Feb 13 14:25:23 testsvr kernel: Call Trace:
Feb 13 14:25:23 testsvr kernel:  [<c0124ce1>] __mod_timer+0x8e/0xa5
Feb 13 14:25:23 testsvr kernel:  [<c022b618>]
generic_make_request+0x64/0x21e
Feb 13 14:25:23 testsvr kernel:  [<c0238369>] kobject_release+0x0/0x17
Feb 13 14:25:23 testsvr kernel:  [<c02de475>] scsi_request_fn+0x15b/0x36e
Feb 13 14:25:23 testsvr kernel:  [<c022c421>]
generic_unplug_device+0x1b/0x2a
Feb 13 14:25:23 testsvr kernel:  [<c03315d7>] unplug_slaves+0x5c/0xa2
Feb 13 14:25:23 testsvr kernel:  [<c033341f>] raid10d+0x564/0xc79
Feb 13 14:25:23 testsvr kernel:  [<c040616a>] schedule+0x31e/0x8ed
Feb 13 14:25:23 testsvr kernel:  [<c0406ae1>] schedule_timeout+0x72/0xb0
Feb 13 14:25:23 testsvr kernel:  [<c0406ae1>] schedule_timeout+0x72/0xb0
Feb 13 14:25:23 testsvr kernel:  [<c034416e>] md_thread+0x40/0x103
Feb 13 14:25:23 testsvr kernel:  [<c012f47c>]
autoremove_wake_function+0x0/0x4b
Feb 13 14:25:23 testsvr kernel:  [<c034412e>] md_thread+0x0/0x103
Feb 13 14:25:23 testsvr kernel:  [<c012f397>] kthread+0xfc/0x100
Feb 13 14:25:23 testsvr kernel:  [<c012f29b>] kthread+0x0/0x100
Feb 13 14:25:23 testsvr kernel:  [<c0103997>] kernel_thread_helper+0x7/0x10

Any help would be appreciated. I'm available to try any test -- this is a
test server that I can perform any kind of wild test on.

-John
