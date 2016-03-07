From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Kernel BUG on RAID1 resize with external bitmap.
Date: Mon, 7 Mar 2016 03:14:19 -0600
Message-ID: <201603070914.u279EJjv021257@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids

Good morning, I hope the week is starting out well for everyone.

We had a production storage server generate a kernel BUG and kill an
mdadm process which was executing a size extension of a RAID1 array
with an external persistent bitmap.  The kernel trace for the event is
included just before my .sig below.

Since the BUG killed the mdadm process there was nothing left to walk
out the active locks.  This left active the spinlock which protects
the variable holding the Hamming weight of the persistent bitmap.  In
addition the MD reconfiguration mutex lock on the device itself was
left active.

There were around 25 RAID1 arrays active on this server and the
incident technically took out I/O only to the RAID1 array which was
being resized.  This was secondary to the stuck lock on the Hamming
weight variable blocking the read/write path for that device.
Unfortunately, the stuck reconfiguration lock on the device itself
ended up blocking any references to /proc/mdstat.

Since any type of logical volume management ends up opening the
supporting physical volumes, any attempt to manage the logical volume
system resulted in processes hung in 'D' state.  So we had to
remediate the problem by scheduling an outage for the server which has
expected uptimes of a year or more.

Given the reliability requirements for this storage server we
simulated the error condition in a virtual machine environment to see
if we could somehow work around the problem.  We were able to
demonstrate the ability to forcibly evict the constituent block
devices but the presence of the 'dead' device in the mddev list was
just too much of an insurmountable obstacle to triage.

The kernel in question is a member of the 3.10.x longterm maintenance
series so we certainly appreciate the reluctance of anyone to look at
this report.  As I noted, we measure these server uptimes in multiples
of years, that is simply the reality of production systems of these
types.

The codepaths involved have seen little development activity so if
this isn't a random hardware/memory corruption issue the problem is
still lurking.  If nothing else we wanted to get this issue documented
in public in case anyone else searches for something similar.

Any thoughts or reflections are always appreciated.

Best wishes for a productive week to everyone.

Greg

---------------------------------------------------------------------------
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: ------------[ cut here ]------------
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: kernel BUG at drivers/md/bitmap.c:274!
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: invalid opcode: 0000 [#1] SMP 
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: CPU: 4 PID: 20377 Comm: mdadm Not tainted 3.10.79 #1
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: task: ffff8803678534e0 ti: ffff880362d3a000 task.ti: ffff880362d3a000
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: RIP: 0010:[<ffffffff8129be69>]  [<ffffffff8129be69>] write_page+0x20d/0x2f3
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: RSP: 0018:ffff880362d3ba78  EFLAGS: 00010246
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: RAX: 0200000000000000 RBX: ffff880367988000 RCX: 00000000ffffffff
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: RDX: 0000000000000000 RSI: ffffea000797d500 RDI: ffff880367988000
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: RBP: 0000000000000000 R08: 0000000000000ee0 R09: ffff880367988000
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: R10: ffffffff8129b1f4 R11: 0000000000010b20 R12: ffff880367988000
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: R13: ffffea000797d500 R14: 000000000000ef90 R15: 00000001dd1f8000
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: FS:  0000000000000000(0000) GS:ffff8801e9d00000(0063) knlGS:00000000f763d6b0
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: CR2: 000000000805b9d2 CR3: 00000001e63f3000 CR4: 00000000000007e0
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: Stack:
Mar  1 01:15:35 fc-iacc1-prox1-s kernel:  000000000000000f 0000000080080008 ffffea00079fc158 ffffea00079fc150
Mar  1 01:15:35 fc-iacc1-prox1-s kernel:  ffff880367988000 ffff8803685b7c98 0000000000000000 ffff88036fff9c00
Mar  1 01:15:35 fc-iacc1-prox1-s kernel:  ffff880367988000 ffff880362d3bbf8 0000000000008010 ffff880367988000
Mar  1 01:15:35 fc-iacc1-prox1-s kernel: Call Trace:
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff8129c48a>] ? bitmap_unplug+0x7a/0x124
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff8129b1ff>] ? bitmap_get_counter+0x7c/0x139
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff8129ca59>] ? bitmap_resize+0x525/0x551
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff81073259>] ? get_page_from_freelist+0x59b/0x682
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff8126cb95>] ? raid1_resize+0x48/0xaf
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff8128ed0b>] ? update_size+0x6c/0x86
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff81299a0a>] ? md_ioctl+0xac8/0x1775
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff8106d7f4>] ? filemap_fault+0x5f/0x335
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff8112877c>] ? compat_blkdev_ioctl+0x4ec/0x1368
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff81085c9e>] ? handle_mm_fault+0x18e/0x19e
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff810201fa>] ? do_page_fault+0x3bf/0x40c
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff810d7257>] ? compat_sys_ioctl+0x1a7/0xf18
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff810a558b>] ? vfs_fstat+0x35/0x51
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff81024a68>] ? sys32_fstat64+0x20/0x29
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  [<ffffffff813832df>] ? sysenter_dispatch+0x7/0x1e
Mar  1 01:15:36 fc-iacc1-prox1-s kernel: Code: 84 ec 00 00 00 48 89 ef e8 8d 5a ff ff e9 df 00 00 00 49 8d 44 24 78 f0 41 80 4c 24 78 04 e9 ce 00 00 00 48 8b 06 f6 c4 08 75 04 <0f> 0b eb fe 48 8b 5e 30 48 8d af a0 00 00 00 eb 1d f0 ff 45 00 
Mar  1 01:15:36 fc-iacc1-prox1-s kernel: RIP  [<ffffffff8129be69>] write_page+0x20d/0x2f3
Mar  1 01:15:36 fc-iacc1-prox1-s kernel:  RSP <ffff880362d3ba78>
Mar  1 01:15:36 fc-iacc1-prox1-s kernel: ---[ end trace e97bde0b0a8c45a8 ]---
---------------------------------------------------------------------------

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"We can't solve today's problems by using the same thinking we used in
 creating them."
                                -- Einstein

-- 
