Received: from mail-oi2-f5.google.com (mail-oi2-f5.google.com [74.125.231.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2831837AA9F
	for <linux-raid@vger.kernel.org>; Wed, 16 Sep 2026 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563464; cv=none; b=QqzqMZ+9CFnHoQDrsbH9IjpBFGkm475aiMtN+V55J0mOG3Un8S8aIgofCW3IwuSieqdFJNW6mi04elXbHJN+rgdtBbd6rLxYC54uqIDAvFW0EgTOXwjNqW6iKoYkGVgyMOv/MCsZ4BCzoDysmyTljkTrFreESARqvslrqxX+h2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563464; c=relaxed/simple;
	bh=ALAoBp10WosS6M5BF145iCAdsHTQ4UWOwIDk/B+VOE4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sR7dUBzvZHfi9wyzLNFTJSMmaye/goienhX2qeGEUybQKgniI9LiyM7iiZbI7euPa4pPbvxtWMNeW9hnxh87PD6vKfMitMb9pnjlKPHjNfBb1Ag6nwRv7PR5R0t+w2CoxMB+88fhUw8Tu4jFGOG5I9LVZtkojS1gFWBywmPWtzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f5.google.com with SMTP id 5614622812f47-4b3759b7ff0so3014853b6e.1
        for <linux-raid@vger.kernel.org>; Wed, 16 Sep 2026 05:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789563460; x=1790168260;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qqOXltCLzmrKhZdKgvPqkXCy5qiS/WnyKMpTb+33Ndk=;
        b=ghyyRpQElwTBi4FH5gFfeNi4DubssWPu7mm0SYB73ZG5/fH+mUTYAKcmM94h+4GlgR
         ZLZwRxyrDlQo8iSKHwLk3WAghDesitsVMrz3fWF/yB0eskEJ0tItUClKzJhzjQdK9jCZ
         AO0FfMUFgyZNApR4zJlMbdtW1j1CUyjxu5dHWHr4nMefSq8KToClWPsvk13Kug4YI6U8
         dmIe1me256aBFcNPpggMjWQi5HfBakMRTKsO2XedNIhwvHDFDSITLuDEOg7DV94ouKof
         MSDshh1JsvTTbtUedSABUzOwJGaTLoAD0nZtFnuFwzTqX4QKaju3VoreXsx+hmSV/ZfJ
         F0Zg==
X-Forwarded-Encrypted: i=1; AKwUvBx0vbzHKXyvrWISiRLX+CdFbpCWuty54bt4QM/cB+7Sj5GHVc6Osoltou/AjBZeWxz7W0N/GAnMHpO0@vger.kernel.org
X-Gm-Message-State: AFuF++nF810SgPP4+g95CaMQljVTMhzYwe4XU/Tv/oRhjT1FaD0r2v+c
	E0UJq+Naq4btF9MVZVwO0Mnx8sUuAAPf1GABPS6fMKeULCrnUPO1jDirgSZHtBHjNhVt7hlBWFi
	opjxsTzvxXE71CN0Uea1/xw5XhlHChrSa4rHzUEUZ/WW/RXAc+79adigonQA=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1488:b0:4c4:3997:ef2f with SMTP id
 5614622812f47-4ca4a3fe0dbmr2789797b6e.17.1789563459887; Wed, 16 Sep 2026
 05:57:39 -0700 (PDT)
Date: Wed, 16 Sep 2026 05:57:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaa9243.e91c2013.3bdb06.0000.GAE@google.com>
Subject: [syzbot] [raid?] kernel BUG in find_zone
From: syzbot <syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    50d05c7c76c9 Merge tag 'landlock-7.3-rc3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100769f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
dashboard link: https://syzkaller.appspot.com/bug?extid=50f9bc7ab8eb224b7629
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-50d05c7c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/303a0ade8f9e/vmlinux-50d05c7c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/70b8ca71442b/bzImage-50d05c7c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at drivers/md/raid0.c:318!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 8386 Comm: syz.2.584 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53fdb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000033863fff CR3: 0000000070ae4000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
 raid0_make_request+0x299/0x1660 drivers/md/raid0.c:626
 md_handle_request+0x824/0x1230 drivers/md/md.c:417
 md_submit_bio+0x1e9/0x350 drivers/md/md.c:458
 __submit_bio block/blk-core.c:681 [inline]
 __submit_bio+0x20e/0x3d0 block/blk-core.c:670
 __submit_bio_noacct block/blk-core.c:724 [inline]
 submit_bio_noacct_nocheck+0x736/0xc00 block/blk-core.c:792
 submit_bio_noacct+0xc93/0x2130 block/blk-core.c:925
 blk_crypto_submit_bio include/linux/blk-crypto.h:212 [inline]
 __bh_submit+0x7ce/0xaa0 fs/buffer.c:1132
 bh_submit fs/buffer.c:1146 [inline]
 block_read_full_folio+0x496/0x8c0 fs/buffer.c:2373
 filemap_read_folio+0xfc/0x3b0 mm/filemap.c:2520
 do_read_cache_folio+0x2d7/0x6b0 mm/filemap.c:4156
 read_mapping_folio include/linux/pagemap.h:1015 [inline]
 read_part_sector+0xd1/0x370 block/partitions/core.c:724
 adfspart_check_ICS+0x91/0x7d0 block/partitions/acorn.c:357
 check_partition block/partitions/core.c:143 [inline]
 blk_add_partitions block/partitions/core.c:591 [inline]
 bdev_disk_changed+0x7b1/0x1260 block/partitions/core.c:695
 blkdev_get_whole+0x187/0x290 block/bdev.c:793
 bdev_open+0x2c7/0xe40 block/bdev.c:1002
 blkdev_open+0x34e/0x4f0 block/fops.c:674
 do_dentry_open+0x6ab/0x14d0 fs/open.c:996
 vfs_open+0x82/0x3f0 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x19fa/0x2440 fs/namei.c:5000
 do_file_open+0x20e/0x430 fs/namei.c:5029
 do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_compat_sys_openat fs/open.c:1485 [inline]
 __se_compat_sys_openat fs/open.c:1483 [inline]
 __ia32_compat_sys_openat+0x12d/0x210 fs/open.c:1483
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
 __do_fast_syscall_32+0x13a/0x8b0 arch/x86/entry/syscall_32.c:291
 do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:316
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf700efec
Code: Unable to access opcode bytes at 0xf700efc2.
RSP: 002b:00000000f53fd50c EFLAGS: 00000292 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000080000300
RDX: 0000000000004002 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53fdb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f5315ff4 CR3: 0000000070ae4000 CR4: 0000000000352ef0


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
