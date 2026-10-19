Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC5C3F23BD
	for <linux-raid@vger.kernel.org>; Mon, 19 Oct 2026 05:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792386693; cv=none; b=tKGpE+RD4wDS78SeTnH4BS6P8IxOry11Ql2YOisV5YddQp4/R3Qf2kjAuAkbnlRCsBXlZ3lIdJboj/P6ffTP2BNBWs0SdUikktAaO7P1mGb5KaU0qqwI/QTEOMt2Z5UPNGGApCBVBE9vRdl7sxN3/oQDxXVlrOauOzcRuojcS+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792386693; c=relaxed/simple;
	bh=nVj/bgdC1Ohyocal4Il0FqAeW/5QWOV4GQ6Q+DQv2f0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=a0FUyLtjfb2LLyKrsqVdQ50VBK0fOb2jeUXX070t2k00vHm6jtgacG+e72dE4TDCKKQAlyOaTLQoH9ZBFDm7eMXSzaJZcJBXNSAalTobq4Dy5CGCr1NRbnPMc/JccDc/gNJrF0VihMa0pMionAkl14w6K9tGiNvxjeFlBSEPSqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-5384e381fbbso1741394b6e.2
        for <linux-raid@vger.kernel.org>; Sun, 18 Oct 2026 22:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792386687; x=1792991487;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0+8zT4mGy6dcRx9KTjqk/ppPsWRxCzDh9ncX9YEziZE=;
        b=piUVZsmL36NXaHOXWHdgorSxdfJ6FGdQmeHaMTFN5b/NxyK35jQLdYpNhk4HVfD0KF
         gjF8s+ZKXEpabGVA7PldQfR550VNJV/1VHEES3A9BOV3dHnLT6cD+39mnodxT1K4h6oh
         qkJvpZSet12CFlus0+WAq6s37JbvMI5fjxPlJgqHz/1Ve0EPaixmg83ECDbDLh8TMyza
         nHR1HhitXKeu5Y9bx5zV0PmiGQpij2PoRvNZs/5bWrBfD9U2/pCk2OODyTk3udg38aCe
         ojvEKMaBn5xzw7qbDnxSHuOM7IZQTvRi1lurDkkLom4J1Z9FeRHV3Le4fL1NDNyGP/Fk
         cepw==
X-Forwarded-Encrypted: i=1; AKwUvBwqnkrICMCnw+VYKi/G8FuGj/ZG5H7s5tbvhLaeQDaY+vywUWUaddk6J7b2VuozCiBXBFQWFzQwwiT8@vger.kernel.org
X-Gm-Message-State: AFq9FYInzfnuA1bUwzIDHQjQn5sWwAQeTre+xkdwFc7WIESlTeQd5/Qe
	l3uY/0xpV0BT7A78M2Zt+FlG73Y5P5ih8tz0M5Pc60aPT69T40egEl4mCKma/hiJCfVE3NY8wbN
	pqs83Myxd3eYdVnemoFhC9Oh5hYkOGMA/jG4hNWV8T7lfvnPWJr39NdY/DIQ=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4e82:b0:53f:4cb6:cdc1 with SMTP id
 5614622812f47-53f4cb6d286mr3228740b6e.34.1792386687530; Sun, 18 Oct 2026
 22:11:27 -0700 (PDT)
Date: Sun, 18 Oct 2026 22:11:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad5a67f.6814cce4.34c49f.0162.GAE@google.com>
Subject: [syzbot] [raid?] general protection fault in raid5_quiesce
From: syzbot <syzbot+0b672810a475890d3636@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f909e534f5e3 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1307b13e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b38d39c45202f4fa
dashboard link: https://syzkaller.appspot.com/bug?extid=0b672810a475890d3636
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1707b13e580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0b672810a475890d3636@syzkaller.appspotmail.com

md/raid:md0: not enough operational devices (1/3 failed)
md/raid:md0: failed to run raid set.
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
CPU: 0 UID: 0 PID: 5902 Comm: syz-executor169 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
RIP: 0010:kasan_byte_accessible+0x12/0x30 mm/kasan/generic.c:210
Code: 79 ff ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c 08 0f 92 c0 e9 90 e7 2a 09 cc 66 66 66 66 66 66 2e
RSP: 0018:ffffc9000544f708 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffffff8b5cf203 RCX: 8000000000000001
RDX: 0000000000000000 RSI: ffffffff8b5cf203 RDI: 000000000000000c
RBP: ffffc9000544f870 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff87ff0a50 R12: 0000000000000060
R13: 0000000000000000 R14: 0000000000000060 R15: 0000000000000001
FS:  000055556c882400(0000) GS:ffff8881249b9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d585e02cd0 CR3: 0000000044162000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __kasan_check_byte+0x12/0x40 mm/kasan/common.c:584
 kasan_check_byte include/linux/kasan.h:402 [inline]
 lock_acquire+0x7d/0x350 kernel/locking/lockdep.c:5916
 rt_spin_lock+0x83/0x400 kernel/locking/spinlock_rt.c:56
 spin_lock_irq include/linux/spinlock_rt.h:96 [inline]
 lock_all_device_hash_locks_irq drivers/md/raid5.c:107 [inline]
 raid5_quiesce+0xc2/0x8a0 drivers/md/raid5.c:-1
 __md_stop_writes+0xeb/0x4b0 drivers/md/md.c:7038
 md_set_readonly+0x330/0x560 drivers/md/md.c:7138
 array_state_store+0x584/0xe90 drivers/md/md.c:4720
 md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
 kernfs_fop_write_iter+0x3a5/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb4d4570f77
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffcae126a10 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000055556c882400 RCX: 00007fb4d4570f77
RDX: 0000000000000008 RSI: 00007fb4d45aa11f RDI: 0000000000000005
RBP: 000055556c8823d8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000006
R13: ffffffffffffffff R14: 0000000000000005 R15: 00000000ffffffff
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kasan_byte_accessible+0x12/0x30 mm/kasan/generic.c:210
Code: 79 ff ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c 08 0f 92 c0 e9 90 e7 2a 09 cc 66 66 66 66 66 66 2e
RSP: 0018:ffffc9000544f708 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffffff8b5cf203 RCX: 8000000000000001
RDX: 0000000000000000 RSI: ffffffff8b5cf203 RDI: 000000000000000c
RBP: ffffc9000544f870 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff87ff0a50 R12: 0000000000000060
R13: 0000000000000000 R14: 0000000000000060 R15: 0000000000000001
FS:  000055556c882400(0000) GS:ffff8881249b9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d585e02cd0 CR3: 0000000044162000 CR4: 00000000003526f0
----------------
Code disassembly (best guess), 4 bytes skipped:
   0:	0f 1f 40 00          	nopl   0x0(%rax)
   4:	90                   	nop
   5:	90                   	nop
   6:	90                   	nop
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	0f 1f 40 d6          	nopl   -0x2a(%rax)
  18:	48 c1 ef 03          	shr    $0x3,%rdi
  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  23:	fc ff df
* 26:	0f b6 04 07          	movzbl (%rdi,%rax,1),%eax <-- trapping instruction
  2a:	3c 08                	cmp    $0x8,%al
  2c:	0f 92 c0             	setb   %al
  2f:	e9 90 e7 2a 09       	jmp    0x92ae7c4
  34:	cc                   	int3
  35:	66                   	data16
  36:	66                   	data16
  37:	66                   	data16
  38:	66                   	data16
  39:	66                   	data16
  3a:	66                   	data16
  3b:	2e                   	cs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
