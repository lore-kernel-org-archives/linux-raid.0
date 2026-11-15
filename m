Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794780393;
	b=ycVAPYDCVD4iwy0LOKeIBENxoAwobQBaFpGjDEglXYQiPqn3UVCDCMuboSxtxK84kigk
	 1MlZRtezSqWTRMalW9O5WC4JJDoeCBW17O1dq/7+Dj8M9bCJLCPpWhXIT4k+ucDigsV9L
	 LEXxQzGMj7GKNjhyzyUEbmoe7elAsYSmYT30Sx3meEdQU5GlHpJgIYA6Jq6VGvBfOMF1K
	 wGzj2nACy2hfBDuGiY3/u0PdKwYtihFH04g6iLqyzwohSPEwz8huPR292Fk0icBi9W+4n
	 gNRLUCc4397FytryF3zfJFglgEYbAlZe7IR3GwKd/xfE4a5zpeXMVc6jZS4Y0GCxn6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794780393;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=DvLJmcl7VLDEt19dwLQxbmMUIFAq46s6dA6QGAbxaI8=;
	b=mT1hjXQgjTwJUaQdudN2biqnnb5UhY9svbChBW81Bxd/o+o2oc92/+ZpFbnhEJTSnBHC
	 mFvkP2/6TKRJzAuRDMt10myM3xRaWxHkHHOAqEpvM70en+lmmJ0nW48wzGK+f2KPlBpgl
	 RkQBpT4lHvxMvCIfSkwr0PgUNqa0MwzA1vbvA69w1mgD7I4RE1k7nJQsbW4AlaW94GnCR
	 USta8iXzzZotGua38L1RWQ4ZjOvQ6nKVHIYkVuSEmGU/kj9lgYCrJ5xXsjpb1Wr4gfInO
	 qf1BG2Divv0c/+JsmJF8xrplh3a3AUTCBvFkmSjiCpNRq2zZoAmwmoSy5A2VSHIrhHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342A5606A31F
	for <linux-raid@vger.kernel.org>; Sun, 15 Nov 2026 22:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 342A5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4dab94dc3e7so5748626b6e.0
        for <linux-raid@vger.kernel.org>; Sun, 15 Nov 2026 14:06:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794780392; x=1795385192;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DvLJmcl7VLDEt19dwLQxbmMUIFAq46s6dA6QGAbxaI8=;
        b=CIr3zeu3A8gkH/ixnw/gKH7p2etHH9BY0vCAWZmPgVefBwYT6axzJ7KiYa3oeiLW+T
         WCIiBpBZ4dtuQFq3zrS2I9j56PvoTIkdi7tqdW0xT3MB+HyM1tgifTalx1sH7o1gvr4t
         t5XNamlADtiOMSIcSKIgmPNmj8Ry1BHbRIkOEMBxc7faz1D2mgco9FTpn33sCTNIpHfq
         jaTH4viDoUnQI+TSQXy37QUG2dRVvLHjdVDe3XBD90d6IvFEFTRZiMZjKeiL+MqZy7vE
         RVmI9lSsQ1HNEVXH97JawVHWOfAld65Nd1dIKgii/VixkUqzaCGH9bXQPY0gMQuL8rF5
         2aJg==
X-Forwarded-Encrypted: i=1; AL+hErF+sfS6T2ULfdrAcAJBwzXadBzjkJAUq7N9hFQFZ0Sa2xdhldz8sqf2TXN9X+CbB86zwAz9+FHZ7zoT@vger.kernel.org
X-Gm-Message-State: APuU4Z+kYksJmz6LHSWbBcHcmm/MJY5wND9zDNOeViS5EP0vTktGBhZJ
	lohzZsVi7ePPonNuPiK1N116SGCPVqjsfXpc/LUwTZ22Ma5IwuVX44UTabkGCCv9AOwWOG4+0oh
	LVLIVEfcYpkS8DgoewxM523zMJYMeEE4KI3MekNq1sfw+8iyIPqPluvoi27E=
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1310:b0:539:a2c2:aba3 with SMTP id
 5614622812f47-56e65f64f62mr7251247b6e.52.1794780392359; Sun, 15 Nov 2026
 14:06:32 -0800 (PST)
Date: Sun, 15 Nov 2026 14:06:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afa2ce8.920b2b3a.148c65.0040.GAE@google.com>
Subject: [syzbot] [raid?] KASAN: slab-out-of-bounds Read in super_90_validate
From: syzbot <syzbot+c5969d7e0a934b384fd6@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2800868f6322 Merge tag 'sound-7.4-rc3' of git://git.kernel..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=17a6353d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=c5969d7e0a934b384fd6
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159fc9ad580000

AI-generated root cause summary:
When creating a non-persistent RAID array (`not_persistent = 1`) via
`SET_ARRAY_INFO` (`md_set_array_info()`), `mddev->max_disks` is left
uninitialized as 0. When a new disk is added via `md_add_new_disk()`
(`ADD_NEW_DISK`), `mddev->persistent == 0` causes `md_import_device()` to
allocate an uninitialized `rdev->sb_page` without loading superblock data, and
`bind_rdev_to_array()` assigns `rdev->desc_nr` from `mddev->raid_disks` without
enforcing `MD_SB_DISKS` (since `max_disks == 0`). For array personalities
lacking `hot_remove_disk` (such as `md-linear`) or when journal devices are
added, `add_bound_rdev()` unconditionally calls
`super_types[mddev->major_version].validate_super()`, executing
`super_90_validate()` without checking `mddev->persistent`. In
`super_90_validate()`, `desc = sb->disks + rdev->desc_nr` is accessed without
checking that `rdev->desc_nr < MD_SB_DISKS` (27), leading to an out-of-bounds
read beyond the 4KB superblock page into adjacent kernel memory.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=c5969d7e0a934b384fd6

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c5969d7e0a934b384fd6@syzkaller.appspotmail.com

md: md0 stopped.
md/raid1:md0: active with 1 out of 35 mirrors
md0: detected capacity change from 0 to 4096
=========================
==================================================================
BUG: KASAN: use-after-free in super_90_validate+0x178b/0x18c0 drivers/md/md.c:1592
Read of size 4 at addr ffff888073d36390 by task syz-executor291/6009

CPU: 1 UID: 0 PID: 6009 Comm: syz-executor291 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 super_90_validate+0x178b/0x18c0 drivers/md/md.c:1592
 add_bound_rdev+0x274/0x390 drivers/md/md.c:3012
 md_add_new_disk+0xca1/0x1820 drivers/md/md.c:7666
 md_ioctl+0x2c1d/0x3700 drivers/md/md.c:8525
 blkdev_ioctl+0x5ad/0x6f0 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:52 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl fs/ioctl.c:584 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x7b0 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f27a95100ab
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffd4383a800 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f27a95100ab
RDX: 00007ffd4383a890 RSI: 0000000040140921 RDI: 0000000000000003
RBP: 00007ffd4383a890 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f27a956cfc7
R13: 0000000000000002 R14: 00007f27a9594cc0 R15: 0000000000000002
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x73d36
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f0(buddy)
raw: 00fff00000000000 ffffea0000d5ae88 ffffea0000d5af88 0000000000000000
raw: 0000000000000000 0000000000000000 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_KERNEL), pid 5639, tgid 5639 (syz-executor), ts 63888746915
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1860
 prep_new_page mm/page_alloc.c:1868 [inline]
 get_page_from_freelist+0xdae/0x2c80 mm/page_alloc.c:3950
 __alloc_frozen_pages_noprof+0x2ad/0x31e0 mm/page_alloc.c:5492
 __alloc_pages_noprof mm/page_alloc.c:5532 [inline]
 alloc_pages_bulk_noprof+0x77e/0x1420 mm/page_alloc.c:5349
 ___alloc_pages_bulk mm/kasan/shadow.c:345 [inline]
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:370 [inline]
 __kasan_populate_vmalloc+0xf0/0x210 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0x963/0x2bc0 mm/vmalloc.c:2151
 __get_vm_area_node+0x1ed/0x350 mm/vmalloc.c:3281
 __vmalloc_node_range_noprof+0x2ad/0x1440 mm/vmalloc.c:4112
 vmalloc_user_noprof+0x9e/0xe0 mm/vmalloc.c:4307
 kcov_ioctl+0x4d/0x750 kernel/kcov.c:756
 vfs_ioctl fs/ioctl.c:52 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl fs/ioctl.c:584 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x7b0 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5356 tgid 5356 ts 65501624162 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0x7b1/0x10f0 mm/page_alloc.c:2958
 kasan_depopulate_vmalloc_pte+0x5d/0x80 mm/kasan/shadow.c:484
 apply_to_pte_range mm/memory.c:3536 [inline]
 apply_to_pmd_range mm/memory.c:3580 [inline]
 apply_to_pud_range mm/memory.c:3616 [inline]
 apply_to_p4d_range mm/memory.c:3652 [inline]
 __apply_to_page_range+0xb1d/0x1520 mm/memory.c:3688
 __kasan_release_vmalloc+0xd7/0xe0 mm/kasan/shadow.c:602
 kasan_release_vmalloc include/linux/kasan.h:593 [inline]
 kasan_release_vmalloc_node mm/vmalloc.c:2312 [inline]
 purge_vmap_node+0x210/0xb40 mm/vmalloc.c:2334
 __purge_vmap_area_lazy+0x90a/0xc00 mm/vmalloc.c:2424
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2458
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888073d36280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888073d36300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888073d36380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                         ^
 ffff888073d36400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888073d36480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
