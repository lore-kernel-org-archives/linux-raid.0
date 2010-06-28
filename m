From: wiebittewas <wiebittewas@googlemail.com>
Subject: raid5 crashes on mke2fs ...
Date: Mon, 28 Jun 2010 10:31:31 +0000
Message-ID: <4C287A03.2000502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


maybe someone can explain, what is happened here?

the kernel is compiled by myself and running without such problems
on another Board of the same type (but other CPU) with multiple raid5.

it happens while trying to create a ext4-fs on it...

the dmesg-output follows:


[47271.211393] BUG: unable to handle kernel paging request at
0000080000000008
[47271.212262] IP: [<ffffffff810e50eb>] find_get_page+0x6b/0x100
[47271.212262] PGD 0
[47271.212262] Oops: 0000 [#1] SMP
[47271.212262] last sysfs file:
/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host13/target13:0:0/13:0:0:0/queue_depth
[47271.212262] CPU 2
[47271.212262] Modules linked in: af_packet ipv6 softdog e1000
via_rhine r8169 mii forcedeth lp parport sata_sil msr ext4 crc16
jbd2 aufs exportfs raid456 md_mod async_raid6_recov async_pq
async_xor xor async_memcpy async_tx raid6_pq ext3 jbd sata_mv
sata_sil24 ahci unix rtc_cmos rtc_core rtc_lib sd_mod ext2 mbcache
pata_amd pata_atiixp libata scsi_mod
[47271.386019]
[47271.386019] Pid: 8343, comm: mke2fs Not tainted 2.6.34x1_64 #9
A780GM-A Ultra/A780GM-A Ultra
[47271.386019] RIP: 0010:[<ffffffff810e50eb>]  [<ffffffff810e50eb>]
find_get_page+0x6b/0x100
[47271.386019] RSP: 0018:ffff8803161d1ab8  EFLAGS: 00010203
[47271.386019] RAX: 000007ffffffffff RBX: 0000000007c00095 RCX:
ffff88017d4c37c8
[47271.386019] RDX: 0000000000000000 RSI: 0000000007c00095 RDI:
0000080000000000
[47271.386019] RBP: ffff8803161d1af8 R08: 0000000000000001 R09:
0000000000000000
[47271.386019] R10: 0000000000000000 R11: ffff88017d4c3920 R12:
ffff880404c18d00
[47271.386019] R13: 0000080000000000 R14: 0000000007c00095 R15:
00000000000000d0
[47271.386019] FS:  00007f69bfc09750(0000) GS:ffff880015600000(0000)
knlGS:00000000f76752a0
[47271.386019] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[47271.386019] CR2: 0000080000000008 CR3: 00000003161d7000 CR4:
00000000000006e0
[47271.386019] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[47271.386019] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[47271.386019] Process mke2fs (pid: 8343, threadinfo
ffff8803161d0000, task ffff880383152480)
[47271.386019] Stack:
[47271.386019]  ffffffff810e5080 ffffffff81151b4b ffff88017d4c6818
0000000000001000
[47271.386019] <0> 0000000000001000 ffff880404c18cf8
0000000007c00095 ffff880404c18cf8
[47271.386019] <0> ffff8803161d1b28 ffffffff810e5446
ffff8803161d1b68 ffffffff81151ca7
[47271.386019] Call Trace:
[47271.386019]  [<ffffffff810e5080>] ? find_get_page+0x0/0x100
[47271.386019]  [<ffffffff81151b4b>] ? __set_page_dirty+0x7b/0xd0
[47271.386019]  [<ffffffff810e5446>] find_lock_page+0x26/0x80
[47271.386019]  [<ffffffff81151ca7>] ? __block_commit_write+0x67/0xd0
[47271.386019]  [<ffffffff810e57fa>]
grab_cache_page_write_begin+0x4a/0xd0
[47271.386019]  [<ffffffff81153931>] block_write_begin+0x91/0x100
[47271.386019]  [<ffffffff810e5417>] ? unlock_page+0x27/0x30
[47271.386019]  [<ffffffff81157f9a>] blkdev_write_begin+0x2a/0x30
[47271.386019]  [<ffffffff81156c30>] ? blkdev_get_block+0x0/0x70
[47271.386019]  [<ffffffff810e42f2>] generic_perform_write+0xc2/0x1d0
[47271.386019]  [<ffffffff81147f63>] ? xattr_getsecurity+0x83/0xa0
[47271.386019]  [<ffffffff8103bbd8>] ? task_rq_lock+0x48/0xa0
[47271.386019]  [<ffffffff810e4464>]
generic_file_buffered_write+0x64/0xa0
[47271.386019]  [<ffffffff8103bb3b>] ? __wake_up+0x4b/0x60
[47271.386019]  [<ffffffff810e6690>]
__generic_file_aio_write+0x240/0x460
[47271.386019]  [<ffffffff810811df>] ? __lock_acquired+0xff/0x420
[47271.386019]  [<ffffffff810811df>] ? __lock_acquired+0xff/0x420
[47271.386019]  [<ffffffff81157236>] blkdev_aio_write+0x36/0x90
[47271.386019]  [<ffffffff81127c2a>] do_sync_write+0xda/0x120
[47271.386019]  [<ffffffff8140d6de>] ? mutex_unlock+0xe/0x10
[47271.386019]  [<ffffffff811abb56>] ?
security_file_permission+0x16/0x20
[47271.386019]  [<ffffffff811287a8>] vfs_write+0xb8/0x1a0
[47271.386019]  [<ffffffff81128971>] sys_write+0x51/0x90
[47271.386019]  [<ffffffff81002f9b>] system_call_fastpath+0x16/0x1b
[47271.386019] Code: f9 ff 48 89 de 4c 89 e7 e8 93 47 12 00 48 85 c0
48 89 c1 74 6b 48 8b 38 40 f6 c7 01 75 e4 48 8d 47 ff 49 89 fd 48 83
f8 fd 77 d7 <8b> 57 08 85 d2 74 d0 8d 42 01 89 55 d8 4c 8d 47 08 89
45 d4 8b
[47271.386019] RIP  [<ffffffff810e50eb>] find_get_page+0x6b/0x100
[47271.386019]  RSP <ffff8803161d1ab8>
[47271.386019] CR2: 0000080000000008
[47271.260126] BUG: unable to handle kernel paging request at
ffffa8017c4c09f0
[47271.260126] IP: [<ffffffffa01b6ecd>] async_copy_data+0xad/0x130
[raid456]
[47271.386684] ---[ end trace 0488213f1af9d515 ]---
[47271.260126] PGD 0
[47271.260126] Oops: 0000 [#2] SMP
[47271.260126] last sysfs file:
/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host13/target13:0:0/13:0:0:0/queue_depth
[47271.260126] CPU 1
[47271.260126] Modules linked in: af_packet ipv6 softdog e1000
via_rhine r8169 mii forcedeth lp parport sata_sil msr ext4 crc16
jbd2 aufs exportfs raid456 md_mod async_raid6_recov async_pq
async_xor xor async_memcpy async_tx raid6_pq ext3 jbd sata_mv
sata_sil24 ahci unix rtc_cmos rtc_core rtc_lib sd_mod ext2 mbcache
pata_amd pata_atiixp libata scsi_mod
[47271.260126]
[47271.260126] Pid: 2394, comm: md1_raid5 Tainted: G      D
2.6.34x1_64 #9 A780GM-A Ultra/A780GM-A Ultra
[47271.260126] RIP: 0010:[<ffffffffa01b6ecd>]  [<ffffffffa01b6ecd>]
async_copy_data+0xad/0x130 [raid456]
[47271.260126] RSP: 0018:ffff880403a0db50  EFLAGS: 00010246
[47271.260126] RAX: 0000000000000000 RBX: ffff88017c4c0980 RCX:
ffffa8017c4c09e8
[47271.260126] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000001
[47271.260126] RBP: ffff880403a0dbc0 R08: 0000000000000000 R09:
0000000000000000
[47271.260126] R10: 0000000000000001 R11: 0000000000000000 R12:
0000000000000000
[47271.260126] R13: ffffe8ffff800d58 R14: 0000000000000003 R15:
ffff88017c4c0980
[47271.260126] FS:  00007f3960c3b6f0(0000) GS:ffff880015400000(0000)
knlGS:00000000f766a080
[47271.260126] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[47271.260126] CR2: ffffa8017c4c09f0 CR3: 0000000001757000 CR4:
00000000000006e0
[47271.260126] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[47271.260126] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[47271.260126] Process md1_raid5 (pid: 2394, threadinfo
ffff880403a0c000, task ffff880403a0a680)
[47271.260126] Stack:
[47271.260126]  ffffea000d287ae0 0000000100000246 ffff880400000008
0000000000000000
[47271.260126] <0> 0000000000000000 0000000000000000
0000000000000000 ffffe8ffff800d58
[47271.260126] <0> 0000000000000003 ffff88017c4c0980
ffff8803c26cd4f8 ffffe8ffff800d58
[47271.260126] Call Trace:
[47271.260126]  [<ffffffffa01b73b2>] __raid_run_ops+0x3a2/0xc00
[raid456]
[47271.260126]  [<ffffffffa01b8fc2>] ? handle_stripe+0x202/0x1b30
[raid456]
[47271.260126]  [<ffffffffa01b94e9>] handle_stripe+0x729/0x1b30
[raid456]
[47271.260126]  [<ffffffffa01b8dec>] ? handle_stripe+0x2c/0x1b30
[raid456]
[47271.260126]  [<ffffffff810811df>] ? __lock_acquired+0xff/0x420
[47271.260126]  [<ffffffffa01bac65>] raid5d+0x375/0x4e0 [raid456]
[47271.260126]  [<ffffffffa01982dc>] md_thread+0x5c/0x130 [md_mod]
[47271.260126]  [<ffffffff8106e1d0>] ? autoremove_wake_function+0x0/0x40
[47271.260126]  [<ffffffffa0198280>] ? md_thread+0x0/0x130 [md_mod]
[47271.260126]  [<ffffffff8106dc9e>] kthread+0xae/0xc0
[47271.260126]  [<ffffffff81003d94>] kernel_thread_helper+0x4/0x10
[47271.260126]  [<ffffffff8106dbf0>] ? kthread+0x0/0xc0
[47271.260126]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10
[47271.260126] Code: 41 f0 ff 44 39 eb 7f 74 48 89 45 a8 41 0f b7 7f
28 41 ff c4 44 39 e7 7e 63 44 89 f2 49 63 cc 31 f6 48 c1 e1 04 49 03
4f 48 85 d2 <8b> 59 08 78 6e 85 db 7e 5a 44 8d 34 13 41 89 dd 41 81
fe 00 10
[47271.260126] RIP  [<ffffffffa01b6ecd>] async_copy_data+0xad/0x130
[raid456]
[47271.260126]  RSP <ffff880403a0db50>
[47271.260126] CR2: ffffa8017c4c09f0
[47271.260126] ---[ end trace 0488213f1af9d516 ]---
