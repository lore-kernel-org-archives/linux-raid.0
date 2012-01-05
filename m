From: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Subject: raid 1 bug with write-mostly and administrative failed disk
Date: Thu, 5 Jan 2012 22:30:23 +0100
Message-ID: <20120105213023.GB3692@telegraafnet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Please Cc: me too as I am trying to subscribe to the list.

Anyway: I found a small bug in raid1, with write-behind and
write-mostly, occuring at least on 3.1.4 and 3.2 .

This is the test setup:
mdadm --stop /dev/md5
mdadm --zero-superblock /dev/sda8
mdadm --zero-superblock /dev/sdb8
mdadm --create -l 1 -n 2 --metadata=0.90 --bitmap=internal --bitmap-chunk=1024 --write-behind=2048 /dev/md5 /dev/sdb8 -W /dev/sda8
(wait until finished)
mdadm --fail /dev/md5 /dev/sdb8
# And this to trigger the bug:
dd if=/dev/md5 of=/dev/null bs=10k count=1


Transcript of the session:
================================================================================
root@skipper:~# mdadm --zero-superblock /dev/sda8^M
root@skipper:~# mdadm --zero-superblock /dev/sdb8^M
root@skipper:~# mdadm --create -l 1 -n 2 --metadata=0.90 --bitmap=internal --bit map-chunk=1024 --write-behind=2048 /dev/md5 /dev/sdb8 -W /dev/sda8
mdadm: /dev/sdb8 appears to contain an ext2fs file system
    size=228074688K  mtime=Tue Jan  3 20:37:01 2012
mdadm: largest drive (/dev/sda8) exceeds size (228074688K) by
more than 1%
Continue creating array? yes
md: bind<sdb8>
md: bind<sda8>
md/raid1:md5: not clean -- starting background reconstruction
md/raid1:md5: active with 2 out of 2 mirrors
md5: bitmap file is out of date (0 < 1) -- forcing full
recovery
created bitmap (109 pages) for device md5
md5: bitmap file is out of date, doing full recovery
md5: bitmap initialized from disk: read 7/7 pages, set 222730 of
222730 bits^M
md5: detected capacity change from 0 to 233548480512
mdadm: array /demd: resync of RAID array md5
v/md5 started.
 md5: unknown partition table^M
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for resync.
md: using 128k window, over a total of 228074688k.


# Now waiting until raid array rebuild finishes :-(
root@skipper:~# md: md5: resync done.
# I will now paste as I got it from the serial console :-)

root@skipper:~# dd if=/dev/sda8 of=/dev/null bs=10k count=1^M
1+0 records in^M
1+0 records out^M
10240 bytes (10 kB) copied, 2.008e-05 s, 510 MB/s^M
root@skipper:~# dd if=/dev/sdb8 of=/dev/null bs=10k count=1^M
1+0 records in^M
1+0 records out^M
10240 bytes (10 kB) copied, 0.00303616 s, 3.4 MB/s^M
root@skipper:~# dd if=/dev/md5 of=/dev/null bs=10k count=1^M
1+0 records in^M
1+0 records out^M
10240 bytes (10 kB) copied, 0.00942157 s, 1.1 MB/s^M
root@skipper:~# mdadm --fail /dev/md5 /dev/sdb8^M
md/raid1:md5: Disk failure on sdb8, disabling device.^M
md/raid1:md5: Operation continuing on 1 devices.^M
mdadm: set /dev/sdb8 faulty in /dev/md5^M
root@skipper:~# dd if=/dev/sda8 of=/dev/null bs=10k count=1^M
1+0 records in^M
1+0 records out^M
10240 bytes (10 kB) copied, 3.0578e-05 s, 335 MB/s^M
root@skipper:~# dd if=/dev/sdb8 of=/dev/null bs=10k count=1^M
1+0 records in^M
1+0 records out^M
10240 bytes (10 kB) copied, 2.937e-05 s, 349 MB/s^M
root@skipper:~# dd if=/dev/md5 of=/dev/null bs=10k count=1^M
------------[ cut here ]------------^M
kernel BUG at drivers/scsi/scsi_lib.c:1153!^M
invalid opcode: 0000 [#1] SMP ^M
CPU 4 ^M
Modules linked in: 8021q bonding e1000 dcdbas bnx2 acpi_power_meter evdev hed^M
^M
Pid: 2932, comm: md5_raid1 Not tainted 3.2.0-d64-i7 #1 Dell Inc. PowerEdge M610/0V56FN^M
RIP: 0010:[<ffffffff8136f90e>]  [<ffffffff8136f90e>] scsi_setup_fs_cmnd+0xae/0xf0^M
RSP: 0018:ffff88061b1b5b70  EFLAGS: 00010046^M
RAX: 0000000000000000 RBX: ffff88061cfaa330 RCX: 0000000000000001^M
RDX: 0000000000000000 RSI: ffff88061cfaa330 RDI: ffff88031d5de000^M
RBP: ffff88031d5de000 R08: 0000000000000086 R09: 0000000000000001^M
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88061cfaa330^M
R13: ffff88031d5de000 R14: ffff88061c193400 R15: 0000000000000000^M
FS:  0000000000000000(0000) GS:ffff88062fc80000(0000) knlGS:0000000000000000^M
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b^M
CR2: 00007f0ca82304f8 CR3: 0000000001745000 CR4: 00000000000006e0^M
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M
Process md5_raid1 (pid: 2932, threadinfo ffff88061b1b4000, task ffff88061ca78280)^M
Stack:^M
 ffff88031b54d418 ffff88061cfaa330 ffff88061be4d7c8 ffffffff813bd5ec^M
 0000000008100000 000000010006aa55 01ff88061cfaa330 0000000000000000^M
 0000000000000000 ffff88031b54d418 ffff88061be6a8c8 ffff88061cfaa330^M
Call Trace:^M
 [<ffffffff813bd5ec>] ? sd_prep_fn+0x15c/0xe10^M
 [<ffffffff812a6a2f>] ? blk_peek_request+0xbf/0x220^M
 [<ffffffff8136ed50>] ? scsi_request_fn+0x60/0x570^M
 [<ffffffff812a7229>] ? queue_unplugged+0x49/0xd0^M
 [<ffffffff812a7492>] ? blk_flush_plug_list+0x1e2/0x230^M
 [<ffffffff812a74eb>] ? blk_finish_plug+0xb/0x30^M
 [<ffffffff8143e17c>] ? raid1d+0x76c/0xec0^M
 [<ffffffff81093063>] ? lock_timer_base+0x33/0x70^M
 [<ffffffff81458187>] ? md_thread+0x117/0x150^M
 [<ffffffff810a4d40>] ? wake_up_bit+0x40/0x40^M
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100^M
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100^M
 [<ffffffff810a4836>] ? kthread+0x96/0xa0^M
 [<ffffffff815750f4>] ? kernel_thread_helper+0x4/0x10^M
 [<ffffffff810a47a0>] ? kthread_worker_fn+0x180/0x180^M
 [<ffffffff815750f0>] ? gs_change+0xb/0xb^M
Code: 00 00 0f 1f 00 48 83 c4 08 5b 5d c3 90 48 89 ef be 20 00 00 00 e8 83 93 ff ff 48 89 c7 48 85 c0 74 db 48 89 83 e8 00 00 00 eb 9
1 <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 48 8b 40 50 48 ^M
RIP  [<ffffffff8136f90e>] scsi_setup_fs_cmnd+0xae/0xf0^M
 RSP <ffff88061b1b5b70>^M
---[ end trace 9e2209ca727bd89d ]---^M
^M^M
^GMessage from syslogd@localhost at Jan  5 21:59:41 ...^M^M
 kernel:------------[ cut here ]------------^M
^M^M^M
^GMessage from syslogd@localhost at Jan  5 21:59:41 ...^M^M
 kernel:invalid opcode: 0000 [#1] SMP ^M
^M^M^M
^GMessage from syslogd@localhost at Jan  5 21:59:41 ...^M^M
 kernel:Stack:^M
^M^M^M
^GMessage from syslogd@localhost at Jan  5 21:59:41 ...^M^M
 kernel:Call Trace:^M
^M^M^M
^GMessage from syslogd@localhost at Jan  5 21:59:41 ...^M^M
 kernel:Code: 00 00 0f 1f 00 48 83 c4 08 5b 5d c3 90 48 89 ef be 20 00 00 00 e8 83 93 ff ff 48 89 c7 48 85 c0 74 db 48 89 83 e8 00 00
 00 eb 91 <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 48 8b 40 50 48 ^M
^M------------[ cut here ]------------^M
WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x98/0xc0()^M
Hardware name: PowerEdge M610^M
Watchdog detected hard LOCKUP on cpu 4^M
Modules linked in: 8021q bonding e1000 dcdbas bnx2 acpi_power_meter evdev hed^M
Pid: 2932, comm: md5_raid1 Tainted: G      D      3.2.0-d64-i7 #1^M
Call Trace:^M
 <NMI>  [<ffffffff8108454b>] ? warn_slowpath_common+0x7b/0xc0^M
 [<ffffffff81084645>] ? warn_slowpath_fmt+0x45/0x50^M
 [<ffffffff810d2bf8>] ? watchdog_overflow_callback+0x98/0xc0^M
 [<ffffffff810fc99a>] ? __perf_event_overflow+0x9a/0x1f0^M
 [<ffffffff81052db9>] ? intel_pmu_handle_irq+0x149/0x280^M
 [<ffffffff81042b78>] ? do_nmi+0x108/0x360^M
 [<ffffffff8157384a>] ? nmi+0x1a/0x20^M
 [<ffffffff81573052>] ? _raw_spin_lock_irqsave+0x22/0x30^M
 <<EOE>>  [<ffffffff812b7d82>] ? cfq_exit_single_io_context+0x32/0x90^M
 [<ffffffff812b7e04>] ? cfq_exit_io_context+0x24/0x40^M
 [<ffffffff812aa7df>] ? exit_io_context+0x4f/0x70^M
 [<ffffffff81088aaa>] ? do_exit+0x58a/0x850^M
 [<ffffffff81042652>] ? oops_end+0x72/0xa0^M
 [<ffffffff810403a4>] ? do_invalid_op+0x84/0xa0^M

================================================================================

I can try variations of the test, but maybe it's easier if I add some debugging
to the kernel?
Anyway: it seems to be the same bug as:
http://marc.info/?l=linux-raid&m=132196390925943&w=2
So I guess it's a bug in handling write-mostly and not having any normal disks
in the array.

I am going to look further tommorow, now it's time to go home ;-).

Regards,
Ard van Breemen
