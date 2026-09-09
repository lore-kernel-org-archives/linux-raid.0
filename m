Received: from mail-oo2-f8.google.com (mail-oo2-f8.google.com [74.125.231.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C269747DD5D
	for <linux-raid@vger.kernel.org>; Wed,  9 Sep 2026 09:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788946828; cv=none; b=GbyJRksVSqmJ8OMk7LrUKsUtFs4awmWNc1yPMK9IHSGqRimEkdaudpfD+rBS9tTv69LMPA+FCDuqKeEKyb64aEJqR7jjJzMGpUrTYWxv+teqfoxz8nKm8v1toOJEyOmdPCWkejkhIXWufwGjFzX/0/CFoiX3bw/cpkKn0IwTmno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788946828; c=relaxed/simple;
	bh=O8Gh+PyfQ9PmDdZ1SkYgjJPzbf2Jq4ogyeohz4JQ2/Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TOWy+9kxVnkNZaUgb2KxIX5JXMUfwe5gb4WDFsaF5n3SnPmn5JO+KaTA42h/u/vUeeDwKGfwDELB9qhMznWmFGeZi4bW4Fc/nJ8yk2avRcu+i/q+FFBGpnPYLLNkhcEeVVAr9jYws+yE/xAu1SIlxurMijBy1xiPiG1ZBoVaVd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f8.google.com with SMTP id 006d021491bc7-6b1bf394d3bso773946eaf.0
        for <linux-raid@vger.kernel.org>; Wed, 09 Sep 2026 02:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788946826; x=1789551626;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jQCfiqnP03MsUE6M0/9R/CzKsFDCRp3NZC4z6ROUyo8=;
        b=V1dx5AAE3L1p0CJFOv9+AuGEHvf3Cy+GtSJtgZajeptd4Gak/sRCh/15Zdn5RhwRlV
         54f/YJt6u3Ru8UGSKpufhxsrX69DrDswSnUnXOeDIb3nTuP3bL2ZbGuDpeH88hsFX/jk
         fP7OqFY0p9oKhleFTeuXeHlSzGlVEqtLjNAyDzyC6mvlY1265M+Vc6NfFyjqshD6RhDp
         DfA6TbZDd4DecuMqV7w2OpcI2K8keIKRfArznoy1Reg5hFZVJ1Fguw0zGxrrGPi2VIZb
         AuEWKJiz28yJqHU6R3J+78v/NRPZGh+AfdHO1dzb4dQc5bFwr843W2sTFduyaQ4HRZij
         Nzyw==
X-Forwarded-Encrypted: i=1; AKwUvBxaWhddrQMDrhg462D702bfOKByYsZpRzeovkuvNKGstvJ7FsL8hwZzXPfOH2VDnl4+30cDls4dtUlV@vger.kernel.org
X-Gm-Message-State: AFuF++liB/ZqgW90ehLsIJpR4cOzbsNwK6PZp4mcUJglXxyTw/lwQPIw
	Oq40+92+athzEF1ah1WPKKNebHokp3RMMJh+vTLVrUugcLDYIENrpe1lKYxNEEgYlUu6Y0m+XBB
	E9f8ZqGt/69d3WCkT40lWh1XPRwdsSoIdvNQVb4U3cB0Oes7L/JoOCF4Wzeg=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:169f:b0:6a1:77ce:1b09 with SMTP id
 006d021491bc7-6bdc949e1f0mr4816159eaf.6.1788946825709; Wed, 09 Sep 2026
 02:40:25 -0700 (PDT)
Date: Wed, 09 Sep 2026 02:40:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa12989.f2639fcc.29487d.0000.GAE@google.com>
Subject: [syzbot] [raid?] kernel BUG in raid5_run
From: syzbot <syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    654ae5d73c05 Merge tag 'drm-fixes-2026-09-05' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1305d4f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
dashboard link: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-654ae5d7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/79c29503032d/vmlinux-654ae5d7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a650a484f62c/bzImage-654ae5d7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com

md/raid
md/raid:md0: not clean -- starting background reconstruction
------------[ cut here ]------------
kernel BUG at drivers/md/raid5.c:8117!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 2 UID: 0 PID: 25223 Comm: syz.2.6302 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
Code: 03 00 00 41 8b ae d0 01 00 00 31 ff 89 ee e8 30 51 84 f9 48 c7 44 24 10 00 00 00 00 85 ed 0f 84 44 f4 ff ff e8 aa 56 84 f9 90 <0f> 0b e8 a2 56 84 f9 49 8d 86 e0 00 00 00 48 89 c2 48 89 44 24 60
RSP: 0000:ffffc90025aef9d8 EFLAGS: 00010287
RAX: 00000000000008eb RBX: 0000000000000000 RCX: ffffc90007a8a000
RDX: 0000000000080000 RSI: ffffffff8886e586 RDI: ffff8880722aa580
RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000001 R12: 0000000000000008
R13: 0000000000000000 R14: ffff88804c9e4000 R15: ffff88804c9e4028
FS:  0000000000000000(0000) GS:ffff888096b63000(0063) knlGS:00000000f5456b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000005658921c CR3: 000000004ff23000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 md_run+0xc2f/0x2510 drivers/md/md.c:6779
 do_md_run+0x36/0x660 drivers/md/md.c:6880
 array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765
 md_attr_store+0x1c5/0x330 drivers/md/md.c:6158
 sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6af/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
 __do_fast_syscall_32+0x13a/0x8b0 arch/x86/entry/syscall_32.c:291
 do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:316
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7f97fec
Code: Unable to access opcode bytes at 0xf7f97fc2.
RSP: 002b:00000000f545650c EFLAGS: 00000292 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00000000800007c0
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
Code: 03 00 00 41 8b ae d0 01 00 00 31 ff 89 ee e8 30 51 84 f9 48 c7 44 24 10 00 00 00 00 85 ed 0f 84 44 f4 ff ff e8 aa 56 84 f9 90 <0f> 0b e8 a2 56 84 f9 49 8d 86 e0 00 00 00 48 89 c2 48 89 44 24 60
RSP: 0000:ffffc90025aef9d8 EFLAGS: 00010287
RAX: 00000000000008eb RBX: 0000000000000000 RCX: ffffc90007a8a000
RDX: 0000000000080000 RSI: ffffffff8886e586 RDI: ffff8880722aa580
RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000001 R12: 0000000000000008
R13: 0000000000000000 R14: ffff88804c9e4000 R15: ffff88804c9e4028
FS:  0000000000000000(0000) GS:ffff888096b63000(0063) knlGS:00000000f5456b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7f76ec0 CR3: 000000004ff23000 CR4: 0000000000352ef0


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
