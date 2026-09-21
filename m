Received: from mail-oo2-f5.google.com (mail-oo2-f5.google.com [74.125.231.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9801C84DC
	for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789954537; cv=none; b=T4FYxA/oHLOlxSc3p9DxqH+f1z6ca2OEIojrLUzjjH1zTCzWZLRlW4kkS26MuUnpSeqHY32QV652YpdSzdwgXKUx/UOjgfS8GBh2dG8m+vESUf4pFBJPbI6d/6Ax/RaEmZH5g1OHTGm+15nT4JJ0dc+LuKC7szAh+bNq9t6u4TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789954537; c=relaxed/simple;
	bh=tIc0L4VaedDVfkkGk1dxwSJaF4Vkhb+egtorqa23Iwg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gFoN1XUJAkm8TTXsy1vz1Ytlilu+RRVIfv3OMXjr3EQp+sE1eQN/g8PcRZTdTQQHgclWm0YJb/fvI5vd7cGAsM3ey1a27GlUL1outa9VKMEeYg3eoqNQUWv7m5zl6rlCFIaYirn0CmU9QUg8fEfDM5FSO+nYpY7q2sIyh8DZIak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f5.google.com with SMTP id 006d021491bc7-6c17d3bdc70so953054eaf.1
        for <linux-raid@vger.kernel.org>; Sun, 20 Sep 2026 18:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789954534; x=1790559334;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ru/fRZECG068TddYjsJjm7ioZJCNSezyI9G2SCw1baQ=;
        b=2U6H/wCU+xRSehFmj3LAZHw/CrO8A6MJKyBbTfsMQVvHAuFY57kRuy1qwDtAwHRo3h
         ewx/SwRWGTEufGXDIGD4W0T+RPkLvLv6So0VdaSMJXnoLBnfSkN8ZxlbzuhR/9eS2BUr
         KnSWxP+08SbpNhLtLoUhAy17hTz3zZ9M6dZQVvkcSnTOToWy8eixeXK/ICMx5dYc2AbI
         IsWaQ7X9/+4xof5FFxUlPLJaW//8jQd3U3UILTaj/7V50tXcdAI70i89JKEVJbspznJ8
         B9GLqO6ujyoj6v11BaspjoWHNRo+4BD9S/o7lDRSi4Vg4C0iweU1RnBQtkKkrYXVHiJg
         XMPQ==
X-Forwarded-Encrypted: i=1; AKwUvBwD5sVJb+O4Kbf+x7gLXvyi08x0JLxhf2m+N8UeNNsWhnVBUq/GJSc/cP+H0z8qez/5sQT8TDnadj5P@vger.kernel.org
X-Gm-Message-State: AFuF++mgZPm00bIt8J1I2ZrsPWFm1WG0tgvfiNrP6Mr0C7q3K2KHoxYM
	ZzHSF9sIy+9rjeca6emQep9Zf16nlpSje69O8UQ9vPVGb4yb4QI46hlXYVFFTvowF2cvAcF/xLx
	hs7AencOkiVJ+6dTeo1IzcqhwfQuLGY39rrMb1+YhoCmePyXCUkU2hWOMjuE=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2006:b0:6b1:4a71:775a with SMTP id
 006d021491bc7-6ca9aa41fbemr8933720eaf.19.1789954534534; Sun, 20 Sep 2026
 18:35:34 -0700 (PDT)
Date: Sun, 20 Sep 2026 18:35:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab089e6.514bccd6.255447.0008.GAE@google.com>
Subject: [syzbot] [raid?] kernel BUG in raid0_make_request
From: syzbot <syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9b87fdc9af2f Merge tag 'sched_ext-for-7.3-rc3-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f4ebf9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=422b372cabfbaa528725
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9ef5fdad4028/disk-9b87fdc9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a024ff7c3227/vmlinux-9b87fdc9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/45d8bf4a87d7/bzImage-9b87fdc9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at drivers/md/raid0.c:318!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 8394 Comm: syz.5.1013 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
RIP: 0010:raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
RIP: 0010:raid0_make_request+0xf17/0x10b0 drivers/md/raid0.c:626
Code: b6 f9 e9 8c fb ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 04 fc ff ff 48 89 df e8 94 a6 b6 f9 e9 f7 fb ff ff e8 ea 9d 46 f9 90 <0f> 0b e8 e2 9d 46 f9 90 0f 0b 89 f9 80 e1 07 38 c1 0f 8c b6 fc ff
RSP: 0018:ffffc9000e2a6fe0 EFLAGS: 00010287
RAX: ffffffff88813476 RBX: 0000000000000000 RCX: 0000000000080000
RDX: ffffc90018cee000 RSI: 0000000000001010 RDI: 0000000000001011
RBP: ffffc9000e2a70f0 R08: ffff88802388dc33 R09: 1ffff11004711b86
R10: dffffc0000000000 R11: ffffed1004711b87 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f90513f76c0(0000) GS:ffff888124cd1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c46e8aa CR3: 0000000074f3c000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 md_handle_request+0xb0a/0xe60 drivers/md/md.c:417
 __submit_bio+0x27f/0x340 block/blk-core.c:681
 __submit_bio_noacct block/blk-core.c:724 [inline]
 submit_bio_noacct_nocheck+0x4e8/0xa40 block/blk-core.c:792
 bh_submit fs/buffer.c:1146 [inline]
 block_read_full_folio+0x7a6/0x810 fs/buffer.c:2373
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2520
 do_read_cache_folio+0x354/0x590 mm/filemap.c:4156
 read_mapping_folio include/linux/pagemap.h:1015 [inline]
 read_part_sector+0xb6/0x2b0 block/partitions/core.c:724
 adfspart_check_ICS+0xb1/0x960 block/partitions/acorn.c:357
 check_partition block/partitions/core.c:143 [inline]
 blk_add_partitions block/partitions/core.c:591 [inline]
 bdev_disk_changed+0x851/0x17a0 block/partitions/core.c:695
 blkdev_get_whole+0x372/0x510 block/bdev.c:793
 bdev_open+0x324/0xd70 block/bdev.c:1002
 blkdev_open+0x461/0x600 block/fops.c:674
 do_dentry_open+0x816/0x1380 fs/open.c:996
 vfs_open+0x3b/0x340 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x1443/0x1d60 fs/namei.c:5000
 do_file_open+0x23e/0x4a0 fs/namei.c:5029
 do_sys_openat2+0x115/0x200 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f905059e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f90513f7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f9050826450 RCX: 00007f905059e159
RDX: 0000000000004002 RSI: 0000200000000300 RDI: ffffffffffffff9c
RBP: 00007f905063506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f90508264e8 R14: 00007f9050826450 R15: 00007ffd8ae5b478
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
RIP: 0010:raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
RIP: 0010:raid0_make_request+0xf17/0x10b0 drivers/md/raid0.c:626
Code: b6 f9 e9 8c fb ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 04 fc ff ff 48 89 df e8 94 a6 b6 f9 e9 f7 fb ff ff e8 ea 9d 46 f9 90 <0f> 0b e8 e2 9d 46 f9 90 0f 0b 89 f9 80 e1 07 38 c1 0f 8c b6 fc ff
RSP: 0018:ffffc9000e2a6fe0 EFLAGS: 00010287
RAX: ffffffff88813476 RBX: 0000000000000000 RCX: 0000000000080000
RDX: ffffc90018cee000 RSI: 0000000000001010 RDI: 0000000000001011
RBP: ffffc9000e2a70f0 R08: ffff88802388dc33 R09: 1ffff11004711b86
R10: dffffc0000000000 R11: ffffed1004711b87 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f90513f76c0(0000) GS:ffff888124dd1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 0000000074f3c000 CR4: 0000000000350ef0


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
