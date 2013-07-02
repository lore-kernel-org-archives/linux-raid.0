From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: RAID1 repair GPF crash w/3.10-rc7
Date: Mon, 1 Jul 2013 21:20:26 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1307012118450.6694@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Kent & Neil,

I've hit a crash in MD during RAID1 repair while running 3.10-rc7:

CPU: 1 PID: 987 Comm: md124_raid1 Tainted: GF          O 3.10.0-rc7.sra+ #2
Hardware name: Stratus ftServer 2700/G7LAY, BIOS BIOS Version 6.2:52 04/09/2013
task: ffff880164b818a0 ti: ffff880161b1c000 task.ti: ffff880161b1c000
RIP: 0010:[<ffffffff812fd6dd>]  [<ffffffff812fd6dd>] memcpy+0xd/0x110
RSP: 0018:ffff880161b1dcd0  EFLAGS: 00010246
RAX: ffff880079e69000 RBX: ffff880161b1c000 RCX: 0000000000000200
RDX: 0000000000000000 RSI: dadfe2db46463b6b RDI: ffff880079e69000
RBP: ffff880161b1dd28 R08: 00000000000000ff R09: 0000000000000009
R10: 0000000000001000 R11: 000000000000000a R12: 0000000000000000
R13: ffff880154105040 R14: 000000006b6b6b6b R15: ffff8801541048b0
FS:  0000000000000000(0000) GS:ffff88017b220000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe775086738 CR3: 00000001764b8000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffffffff811c833a ffff880100001000 ffff880154104ec0 ffff880161b1dfd8
 ffff880154104830 ffff8801606e9598 ffff880154104830 ffff88015dd9b6d8
 ffff880174df8000 0000000000000001 ffff8801508b3738 ffff880161b1de38
Call Trace:
 [<ffffffff811c833a>] ? bio_copy_data+0x12a/0x1c0
 [<ffffffffa004535e>] raid1d+0xa8e/0xe90 [raid1]
 [<ffffffff810737cb>] ? prepare_to_wait+0x5b/0x90
 [<ffffffff814c435d>] md_thread+0x11d/0x170
 [<ffffffff81073600>] ? wake_up_bit+0x40/0x40
 [<ffffffff814c4240>] ? md_rdev_init+0x110/0x110
 [<ffffffff81073080>] kthread+0xc0/0xd0
 [<ffffffff81072fc0>] ? flush_kthread_worker+0x80/0x80
 [<ffffffff81655d9c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81072fc0>] ? flush_kthread_worker+0x80/0x80
Code: 2b 43 50 88 43 4e 48 83 c4 08 5b 5d c3 90 e8 eb fb ff ff eb e6 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 
RIP  [<ffffffff812fd6dd>] memcpy+0xd/0x110
 RSP <ffff880161b1dcd0>

Crash analysis showed the struct bio *src bi_idx was set to bi_vcnt when
the GPF occurred.  Further instrumentation of repeat incidents revealed
bi_idx was set to bi_vnct on bio_copy_data() entry.  bio_copy_data() may
handle copying from the middle of the bi_io_vec[], but it didn't cope
well when the initial bio_iovec() call pointed past the end of
bi_io_vec[].

Commit d3b45c2 "raid1: use bio_copy_data()" introduced a slight change
of behavior in process_checks(), which had been copying the entire
bi_io_vec[], regardless of the source bio bi_idx value.  Reverting this
commit appeased the MD RAID1 repair (no crashes and no mismatch_cnt
after re-checking), but did not answer the question of why
bio_copy_data() was called with a source bio bi_idx == bi_vcnt.

A few trips through git bisect found process_checks() only started
passing such bios in commit f79ea416 "block: Refactor
blk_update_request()". 

This leads me to believe that MD didn't expect the source bio bi_idx to
have moved before it called bio_copy_data().  In the commit "block:
Refactor blk_update_request()", bio_advance() increments bi_idx if
!BIO_NO_ADVANCE_ITER_MASK, but I'm not sure if that's a clue or not...
FWIW, bi_rw is set to 0.

Any ideas guys?  This is very repeatable (just create a new MD RAID1,
force data differences to both sides and kick off a repair).

Regards,

-- Joe   
