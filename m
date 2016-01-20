From: "Guido D'Arezzo" <gdarrezzo@gmail.com>
Subject: Re: Intel IMSM RAID 5 won't start - now jbd2 blocked for more than
 120 seconds
Date: Wed, 20 Jan 2016 09:48:28 +0000
Message-ID: <CAEUPnryP+RZ6NgCYGWqhJ+zMQZ8wjAWydoWAt-++jeu2WejZxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I hope this is of use.  After recovering the RAID, the drives were
used heavily, backing up and restoring, A while later, Arch Linux hung
for unknown reasons and after reset (Intel ME reset: as before, the
o/s was unresponsive) the RAID began a resync.  I resumed copying etc,
discs busy, and ran 'find / something', which hung.  After a while
everything resumed without apparent harm.  Here are extracts from
journalctl:



Jan 11 10:20:27 archlinux kernel: Linux version 4.2.5-1-ARCH
(builduser@tobias) (gcc version 5.2.0 (GCC) ) #1 SMP PREEMPT Tue Oct
27 08:13:28 CET 2015
...
Jan 11 10:20:27 archlinux kernel: DMI: VIGLEN DQ77MK/DQ77MK, BIOS
MKQ7710H.86A.0062.2013.0902.1328 09/02/2013
...
Jan 11 10:20:27 archlinux kernel: raid6: sse2x1   gen()  6958 MB/s
Jan 11 10:20:27 archlinux kernel: random: nonblocking pool is initialized
Jan 11 10:20:27 archlinux kernel: raid6: sse2x1   xor()  6766 MB/s
Jan 11 10:20:27 archlinux kernel: raid6: sse2x2   gen() 12676 MB/s
Jan 11 10:20:27 archlinux kernel: raid6: sse2x2   xor()  8365 MB/s
Jan 11 10:20:27 archlinux kernel: raid6: sse2x4   gen() 10430 MB/s
Jan 11 10:20:27 archlinux kernel: raid6: sse2x4   xor()  7014 MB/s
Jan 11 10:20:27 archlinux kernel: raid6: using algorithm sse2x2 gen() 12676 MB/s
Jan 11 10:20:27 archlinux kernel: raid6: .... xor() 8365 MB/s, rmw enabled
Jan 11 10:20:27 archlinux kernel: raid6: using ssse3x2 recovery algorithm
Jan 11 10:20:27 archlinux kernel: async_tx: api initialized (async)
Jan 11 10:20:27 archlinux kernel: xor: automatically using best
checksumming function:
Jan 11 10:20:27 archlinux kernel:    avx       : 27582.000 MB/sec
Jan 11 10:20:27 archlinux kernel: md: raid6 personality registered for level 6
Jan 11 10:20:27 archlinux kernel: md: raid5 personality registered for level 5
Jan 11 10:20:27 archlinux kernel: md: raid4 personality registered for level 4
Jan 11 10:20:27 archlinux kernel: md/raid:md126: device sdd
operational as raid disk 0
Jan 11 10:20:27 archlinux kernel: md/raid:md126: device sda
operational as raid disk 1
Jan 11 10:20:27 archlinux kernel: md/raid:md126: device sdc
operational as raid disk 2
Jan 11 10:20:27 archlinux kernel: md/raid:md126: device sdb
operational as raid disk 3
Jan 11 10:20:27 archlinux kernel: md/raid:md126: allocated 4366kB
Jan 11 10:20:27 archlinux kernel: md/raid:md126: raid level 5 active
with 4 out of 4 devices, algorithm 0
Jan 11 10:20:27 archlinux kernel: RAID conf printout:
Jan 11 10:20:27 archlinux kernel:  --- level:5 rd:4 wd:4
Jan 11 10:20:27 archlinux kernel:  disk 0, o:1, dev:sdd
Jan 11 10:20:27 archlinux kernel:  disk 1, o:1, dev:sda
Jan 11 10:20:27 archlinux kernel:  disk 2, o:1, dev:sdc
Jan 11 10:20:27 archlinux kernel:  disk 3, o:1, dev:sdb
Jan 11 10:20:27 archlinux kernel: md126: detected capacity change from
0 to 101494816768
Jan 11 10:20:27 archlinux kernel: md: md126 switched to read-write mode.
Jan 11 10:20:27 archlinux kernel: md: bind<sdb>
Jan 11 10:20:27 archlinux kernel: md: bind<sdc>
Jan 11 10:20:27 archlinux kernel: md: bind<sda>
Jan 11 10:20:27 archlinux kernel: md: bind<sdd>
Jan 11 10:20:27 archlinux kernel: md/raid:md125: not clean -- starting
background reconstruction
Jan 11 10:20:27 archlinux kernel: md/raid:md125: device sdd
operational as raid disk 0
Jan 11 10:20:27 archlinux kernel: md/raid:md125: device sda
operational as raid disk 1
Jan 11 10:20:27 archlinux kernel: md/raid:md125: device sdc
operational as raid disk 2
Jan 11 10:20:27 archlinux kernel: md/raid:md125: device sdb
operational as raid disk 3
Jan 11 10:20:27 archlinux kernel: md/raid:md125: allocated 4366kB
Jan 11 10:20:27 archlinux kernel: md/raid:md125: raid level 5 active
with 4 out of 4 devices, algorithm 0
Jan 11 10:20:27 archlinux kernel: RAID conf printout:
Jan 11 10:20:27 archlinux kernel:  --- level:5 rd:4 wd:4
Jan 11 10:20:27 archlinux kernel:  disk 0, o:1, dev:sdd
Jan 11 10:20:27 archlinux kernel:  disk 1, o:1, dev:sda
Jan 11 10:20:27 archlinux kernel:  disk 2, o:1, dev:sdc
Jan 11 10:20:27 archlinux kernel:  disk 3, o:1, dev:sdb
Jan 11 10:20:27 archlinux kernel: md125: detected capacity change from
0 to 2899102924800
Jan 11 10:20:27 archlinux kernel: md: md125 switched to read-write mode.
Jan 11 10:20:27 archlinux kernel: md: resync of RAID array md125
Jan 11 10:20:27 archlinux kernel: md: minimum _guaranteed_  speed:
1000 KB/sec/disk.
Jan 11 10:20:27 archlinux kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for resync.
Jan 11 10:20:27 archlinux kernel: md: using 128k window, over a total
of 943718400k.
Jan 11 10:20:27 archlinux kernel: md: resuming resync of md125 from checkpoint.
Jan 11 10:20:27 archlinux kernel:  md125: p1 p2 p3
Jan 11 10:20:27 archlinux kernel: device-mapper: uevent: version 1.0.3
Jan 11 10:20:27 archlinux kernel: device-mapper: ioctl: 4.33.0-ioctl
(2015-8-18) initialised: dm-devel@redhat.com
Jan 11 10:20:27 archlinux kernel: EXT4-fs (dm-2): mounted filesystem
with ordered data mode. Opts: (null)
...
Jan 11 10:20:27 archlinux kernel: EXT4-fs (dm-2): re-mounted. Opts:
stripe=64,data=ordered
...
Jan 11 10:35:17 archlinux systemd[1]: Starting Cleanup of Temporary
Directories...
Jan 11 10:35:18 archlinux systemd[1]: Started Cleanup of Temporary Directories.
...
Jan 11 10:40:13 archlinux kernel: INFO: task jbd2/dm-2-8:325 blocked
for more than 120 seconds.
Jan 11 10:40:13 archlinux kernel:       Not tainted 4.2.5-1-ARCH #1
Jan 11 10:40:13 archlinux kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 11 10:40:13 archlinux kernel: jbd2/dm-2-8     D ffff88042e255200
  0   325      2 0x00000000
Jan 11 10:40:13 archlinux kernel:  ffff880418d97c78 0000000000000046
ffff88041c279b80 ffff880418943700
Jan 11 10:40:13 archlinux kernel:  0000000000000001 ffff880418d98000
ffff880418d97d70 ffff880418d97d58
Jan 11 10:40:13 archlinux kernel:  ffff880418943700 ffff8804182e5400
ffff880418d97c98 ffffffff8157283e
Jan 11 10:40:13 archlinux kernel: Call Trace:
Jan 11 10:40:13 archlinux kernel:  [<ffffffff8157283e>] schedule+0x3e/0x90
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa02344e1>]
jbd2_journal_commit_transaction+0x231/0x1890 [jbd2]
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810a8239>] ?
dequeue_entity+0x149/0x690
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810a9071>] ?
put_prev_entity+0x31/0x420
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810b4c80>] ?
wake_atomic_t_function+0x60/0x60
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810dca8e>] ?
try_to_del_timer_sync+0x5e/0x90
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa023ab4a>]
kjournald2+0xca/0x250 [jbd2]
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810b4c80>] ?
wake_atomic_t_function+0x60/0x60
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa023aa80>] ?
commit_timeout+0x10/0x10 [jbd2]
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81092578>] kthread+0xd8/0xf0
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810924a0>] ?
kthread_worker_fn+0x170/0x170
Jan 11 10:40:13 archlinux kernel:  [<ffffffff8157665f>] ret_from_fork+0x3f/0x70
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810924a0>] ?
kthread_worker_fn+0x170/0x170
Jan 11 10:40:13 archlinux kernel: INFO: task find:1536 blocked for
more than 120 seconds.
Jan 11 10:40:13 archlinux kernel:       Not tainted 4.2.5-1-ARCH #1
Jan 11 10:40:13 archlinux kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 11 10:40:13 archlinux kernel: find            D 0000000000000001
  0  1536   1262 0x00000004
Jan 11 10:40:13 archlinux kernel:  ffff8800b726b9e8 0000000000000082
ffff8800b10fe040 ffff8804173244c0
Jan 11 10:40:13 archlinux kernel:  ffff8800b726b9d8 ffff8800b726c000
ffff88042e255200 7fffffffffffffff
Jan 11 10:40:13 archlinux kernel:  0000000000000002 ffffffff81573110
ffff8800b726ba08 ffffffff8157283e
Jan 11 10:40:13 archlinux kernel: Call Trace:
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81573110>] ? bit_wait+0x50/0x50
Jan 11 10:40:13 archlinux kernel:  [<ffffffff8157283e>] schedule+0x3e/0x90
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81575205>]
schedule_timeout+0x1b5/0x240
Jan 11 10:40:13 archlinux kernel:  [<ffffffff8101e769>] ? read_tsc+0x9/0x10
Jan 11 10:40:13 archlinux kernel:  [<ffffffff811115e6>] ?
delayacct_end+0x56/0x60
Jan 11 10:40:13 archlinux kernel:  [<ffffffff8101e769>] ? read_tsc+0x9/0x10
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81573110>] ? bit_wait+0x50/0x50
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81571d94>]
io_schedule_timeout+0xa4/0x110
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810b4744>] ?
prepare_to_wait_exclusive+0x54/0x80
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81573145>] bit_wait_io+0x35/0x50
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81572f2b>]
__wait_on_bit_lock+0x4b/0xa0
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81573110>] ? bit_wait+0x50/0x50
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81573002>]
out_of_line_wait_on_bit_lock+0x82/0xb0
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810b4cc0>] ?
autoremove_wake_function+0x40/0x40
Jan 11 10:40:13 archlinux kernel:  [<ffffffff810b4cc0>] ?
autoremove_wake_function+0x40/0x40
Jan 11 10:40:13 archlinux kernel:  [<ffffffff81203f67>] __lock_buffer+0x27/0x30
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa0232b6c>]
do_get_write_access+0x1ec/0x510 [jbd2]
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa024a80f>] ?
ext4_htree_store_dirent+0xdf/0x120 [ext4]
Jan 11 10:40:13 archlinux kernel:  [<ffffffff812058ca>] ?
__find_get_block+0xaa/0x110
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa0232ec7>]
jbd2_journal_get_write_access+0x37/0x70 [jbd2]
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa0283391>]
__ext4_journal_get_write_access+0x31/0x70 [ext4]
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa0253de5>]
ext4_reserve_inode_write+0x75/0xa0 [ext4]
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa0257388>] ?
ext4_dirty_inode+0x48/0x70 [ext4]
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa0253e5e>]
ext4_mark_inode_dirty+0x4e/0x220 [ext4]
Jan 11 10:40:13 archlinux kernel:  [<ffffffffa0257388>]
ext4_dirty_inode+0x48/0x70 [ext4]
Jan 11 10:40:13 archlinux kernel:  [<ffffffff811fc648>]
__mark_inode_dirty+0x48/0x380
Jan 11 10:40:13 archlinux kernel:  [<ffffffff811ea579>]
generic_update_time+0x79/0xc0
Jan 11 10:40:13 archlinux kernel:  [<ffffffff811ebde6>] touch_atime+0xa6/0xd0
Jan 11 10:40:13 archlinux kernel:  [<ffffffff811e2ebb>] iterate_dir+0xdb/0x120
Jan 11 10:40:13 archlinux kernel:  [<ffffffff811e330d>] SyS_getdents+0x8d/0x100
Jan 11 10:40:13 archlinux kernel:  [<ffffffff811e2fd0>] ? fillonedir+0xd0/0xd0
Jan 11 10:40:13 archlinux kernel:  [<ffffffff8157626e>]
entry_SYSCALL_64_fastpath+0x12/0x71
...
