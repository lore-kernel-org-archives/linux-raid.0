Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119B13911CD
	for <linux-raid@vger.kernel.org>; Fri,  2 Oct 2026 23:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983527; cv=none; b=XRoMe2FlvkrfBDmAvkSKkuNGSFSNC0/fg7hs8GOH40+OxXufurE7ussPtgysj1Kf9NqMKKwgreuUzC6hGb8H9GGUYTmEztIVLigDAwDmr6iAIsqdqV2VAm6ovXsJ1NU1hilsf9urPaNwCZUA9mceIcpOHcImfd1S0aALmge3Rz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983527; c=relaxed/simple;
	bh=u2KMLv+tlXITwimzd/Ty9/jX3M9EHu28LToNoV9H398=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WVewBqoEiZDDXp1XuJ6Rl3ouVR5L52wdxzhHN8+Rg38+/oLr1ST9E/PioAr0NL+C/b9TFJzDI8IcWLpmMHRLLyvLmE63gObd04WJL7Nh/G7k5cv7DwYRNpCykz/R3junIJ3MzLdsRCYRlE3vof3S8VWQ/rMN8wCFsKaiw5zWjEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b37620eb73so683486b6e.1
        for <linux-raid@vger.kernel.org>; Fri, 02 Oct 2026 16:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790983525; x=1791588325;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dIjf4HqhU53sGKU8lTmxHgeawGfnk4d9WAw94g/v+Sw=;
        b=DByvdDOMwoUKMA52keF+zdSFzPLJI3/o+T1nAKc5hGExsHdkFCNpmdoeo+tnxb9LCW
         hFdDToL4K4nFV7KGc1gZDS2HgjZ0Xk+8Mw8WOrXD769xnDwtdI9GcFhwQwcC+K455Tqb
         lPMz0xhjX2vhAnVly08PJakSfHcIOf74d2yT96eiBs9gAXCPiX0A24YDrAElYnYrCCCr
         tBBgIW7t7QXHh+TrrlKriQz5LuH3YSi79p6MOP02AKUCOjSemrtz74cpDa0cPaSD1aOp
         2tIxC3gL9w9zUV4YF9YLRZ4t3amcohr6Ud3EJ0lEa/FqIY58HOcTmKacJWTHVw6z9/il
         fkhA==
X-Forwarded-Encrypted: i=1; AKwUvBzVmfOPMGrfpsVY/raRrhTDD9Yavx/ZvTzocCbEDqVu1ahpAt781TA6MSa0XRV629PfXcPbp3Ye0K5H@vger.kernel.org
X-Gm-Message-State: AFuF++ld01j+4JM+Dxt1vD6rMfpnTEePo1Mk5wAtL6Ct3rT94xgTRw5+
	MKT9/nI5ZNQ8kBxudhRCH3+OFYDcvSWBOs0OYAltr0ABxhrB5RvelP69uTT7Zxuwn7g5KrqTK6+
	B2x+g1Sh6o6+WmC4eaJ5ukxvxtaBtlE0cUhlISQu5168+x93WSmykrkx9994=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6d91:b0:4cb:f21b:6f90 with SMTP id
 5614622812f47-4f529d37106mr3399532b6e.35.1790983525067; Fri, 02 Oct 2026
 16:25:25 -0700 (PDT)
Date: Fri, 02 Oct 2026 16:25:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac03d65.81dddff3.363068.0002.GAE@google.com>
Subject: [syzbot] [raid?] general protection fault in md_handle_request
From: syzbot <syzbot+89a9ab2a134d092fffae@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6474fa070f2b Add linux-next specific files for 20260929
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
console output: https://syzkaller.appspot.com/x/log.txt?x=14dfe035580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3477d5a04d788556
dashboard link: https://syzkaller.appspot.com/bug?extid=89a9ab2a134d092fffae
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d876c9580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+89a9ab2a134d092fffae@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 6372 Comm: syz-executor143 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
RIP: 0010:md_handle_request+0xadd/0xe60 drivers/md/md.c:417
Code: 24 90 00 00 00 48 8b 84 24 a8 00 00 00 42 80 3c 20 00 74 08 48 89 df e8 f1 b2 93 f9 48 8b 1b 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 d4 b2 93 f9 4c 8b 1b 48 8b bc 24
RSP: 0018:ffffc9000415f5c0 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff88802b29ddc0
RDX: 0000000000000000 RSI: ffffffff8e9dafe5 RDI: ffff88802b29ddc0
RBP: ffffc9000415f778 R08: ffffffff88a749bc R09: 0000000000000000
R10: 0000000000000009 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff9200082bf70 R14: ffff88807e3680c8 R15: ffff88807e368238
FS:  000055556ca3c400(0000) GS:ffff888124723000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8a7dc59000 CR3: 000000007831e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __submit_bio+0x27f/0x340 block/blk-core.c:681
 __submit_bio_noacct block/blk-core.c:724 [inline]
 submit_bio_noacct_nocheck+0x4e8/0xa40 block/blk-core.c:792
 bio_await block/bio.c:1506 [inline]
 submit_bio_wait+0x12a/0x250 block/bio.c:1524
 __blkdev_direct_IO_simple block/fops.c:115 [inline]
 blkdev_direct_IO+0x1167/0x18e0 block/fops.c:451
 blkdev_read_iter+0x223/0x420 block/fops.c:849
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x595/0xa80 fs/read_write.c:574
 ksys_pread64 fs/read_write.c:764 [inline]
 __do_sys_pread64 fs/read_write.c:772 [inline]
 __se_sys_pread64 fs/read_write.c:769 [inline]
 __x64_sys_pread64+0x196/0x220 fs/read_write.c:769
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8a7dca9077
Code: 48 89 fa 4c 89 df e8 98 1e 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffc5a7b78d0 EFLAGS: 00000202 ORIG_RAX: 0000000000000011
RAX: ffffffffffffffda RBX: 000055556ca3c400 RCX: 00007f8a7dca9077
RDX: 0000000000001000 RSI: 000055556ca3e000 RDI: 0000000000000009
RBP: 0000000000000096 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffc5a7b79e0
R13: 00007ffc5a7b79d4 R14: 00007ffc5a7b7954 R15: 00007f8a7dc59000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:md_handle_request+0xadd/0xe60 drivers/md/md.c:417
Code: 24 90 00 00 00 48 8b 84 24 a8 00 00 00 42 80 3c 20 00 74 08 48 89 df e8 f1 b2 93 f9 48 8b 1b 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 d4 b2 93 f9 4c 8b 1b 48 8b bc 24
RSP: 0018:ffffc9000415f5c0 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff88802b29ddc0
RDX: 0000000000000000 RSI: ffffffff8e9dafe5 RDI: ffff88802b29ddc0
RBP: ffffc9000415f778 R08: ffffffff88a749bc R09: 0000000000000000
R10: 0000000000000009 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff9200082bf70 R14: ffff88807e3680c8 R15: ffff88807e368238
FS:  000055556ca3c400(0000) GS:ffff888124623000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8a7dd14100 CR3: 000000007831e000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	24 90                	and    $0x90,%al
   2:	00 00                	add    %al,(%rax)
   4:	00 48 8b             	add    %cl,-0x75(%rax)
   7:	84 24 a8             	test   %ah,(%rax,%rbp,4)
   a:	00 00                	add    %al,(%rax)
   c:	00 42 80             	add    %al,-0x80(%rdx)
   f:	3c 20                	cmp    $0x20,%al
  11:	00 74 08 48          	add    %dh,0x48(%rax,%rcx,1)
  15:	89 df                	mov    %ebx,%edi
  17:	e8 f1 b2 93 f9       	call   0xf993b30d
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	48 83 c3 18          	add    $0x18,%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 d4 b2 93 f9       	call   0xf993b30d
  39:	4c 8b 1b             	mov    (%rbx),%r11
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	bc                   	.byte 0xbc
  3f:	24                   	.byte 0x24


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
