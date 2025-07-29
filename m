Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9637122F76F
	for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 21:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753826315; cv=none; b=q+1PGw+KaSOwRMr/pXChGgpD99sgJwnACkCpjvTAkPBHoQZA58dXu1GC0ttlP+cRuxe6K4zjWJSLcwf+tXKNIAogG0qWqEJSTd7MriUbQ4fGqDqZNrj3W5fnbgRwmfwbQYFUZwtX9vfk15oimJ8k/6N0ugjpeEmBNGAgiCz7JLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753826315; c=relaxed/simple;
	bh=O50tvZ9uzcqlRzDDNeFodAcq7WeDXH+IABY3xY66fjk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=brDjePnKtfbNmuqai/ECmd1dMI3EY86Z1ocd+81oT1AIcIQ7u8VfRlNkdZAoeYOXiOIKXIvK8KAzD6zpxgoSUhaCMGxdl2tvSNsuu45IYnxEl/XJhI7zOVrKjdcQHiOUVByxE+9vy8GiaBViGAL5ldxmru85vPhmM5I/YPVDsDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3e3d0bcd48fso78464295ab.2
        for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 14:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753826313; x=1754431113;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9DcDO4V4KRc215iriex9i8eYJYQg1FoSqnkmjhIQzXM=;
        b=Er+Ti4eJvp46NMnmNjttd5b673DcqZGiaSaaRWUcWGwYSCDKVJkS8k6WxLGXOczTL8
         JkB7PnQIbqRx/njxAMDt1L3afPvpl4sh8vNbgeFc8Lc3V1Q+KWv2YfQ1Ydq+LtV2JHe3
         i4ImEd5t3JZFP1nD8XmlnZF0+gh3yvlTghxzlcOl7GisU9zmk9zWWcSkXM6qH5TTI8yG
         7Aiki7bA3LOWeDUvm1s0RMthD7Wc9ybud8RQPP9MpBS/oeMSZZ6Z5y/O4r1rvOUHtASO
         yHqFZeUnvBfzUkSIrQR08OzDTAbBwxvjwGfUeaHvi6XoMXtw1cvDSEW568HhMQt+UDd9
         KHPw==
X-Forwarded-Encrypted: i=1; AJvYcCU0szNVm1RZf5i8cm1eGHpq8zbdJhrYFzUWfyKHc4WR0qDE1ySJpJ7W53g4z7gF5G/KCyuzgmFEemX7@vger.kernel.org
X-Gm-Message-State: AOJu0YzEyNcmW5D9/wkAk+aPb76TKp19eydsI6SmSxd+Qh6Py9azqiGy
	C8Tzt7PKPb4VWYMaeEPWxod4VKV5S41BuW937RYaxytH702InilJomNaRreB9FZqSbaQBdTbPAj
	DWtUEsbhjB8bq25cm98BRBXSEU9D1yM19iAqtpg8qMzuVroQGQk3A5zEfhbI=
X-Google-Smtp-Source: AGHT+IFjyuViMt8FcZdD77JfCWZH8Wa2HxqZ4ZaoIVgzAP4iwva2GhiwfyLeP/N67s+X6PF+Go1NLRdD3c1RCE8n6tD0E9Lgtcsq
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1808:b0:3e2:a12c:9c56 with SMTP id
 e9e14a558f8ab-3e3f5d8e0admr16177205ab.0.1753826312706; Tue, 29 Jul 2025
 14:58:32 -0700 (PDT)
Date: Tue, 29 Jul 2025 14:58:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68894408.a00a0220.26d0e1.0012.GAE@google.com>
Subject: [syzbot] [fuse?] WARNING: refcount bug in process_scheduled_works
From: syzbot <syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com>
To: andrew.cooper3@citrix.com, bp@alien8.de, brgerst@gmail.com, 
	dave.hansen@linux.intel.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, miklos@szeredi.hu, 
	mingo@redhat.com, peterz@infradead.org, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org, 
	xni@redhat.com, yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ced1b9e0392d Merge tag 'ata-6.17-rc1' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15c89782580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d51af648924b64c9
dashboard link: https://syzkaller.appspot.com/bug?extid=9921e319bd6168140b40
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177f7034580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165e44a2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f1495c1de592/disk-ced1b9e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/982f755305ce/vmlinux-ced1b9e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b17cd424f373/bzImage-ced1b9e0.xz

The issue was bisected to:

commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
Author: Xiao Ni <xni@redhat.com>
Date:   Wed Jun 11 07:31:06 2025 +0000

    md: call del_gendisk in control path

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ab54a2580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16ab54a2580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12ab54a2580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com
Fixes: 9e59d609763f ("md: call del_gendisk in control path")

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 24 at lib/refcount.c:28 refcount_warn_saturate+0x11a/0x1d0 lib/refcount.c:28
Modules linked in:
CPU: 1 UID: 0 PID: 24 Comm: kworker/1:0 Not tainted 6.16.0-syzkaller-00857-gced1b9e0392d #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: md_misc mddev_delayed_delete
RIP: 0010:refcount_warn_saturate+0x11a/0x1d0 lib/refcount.c:28
Code: 00 83 e2 8b e8 b7 5b bf fc 90 0f 0b 90 90 eb d7 e8 bb 6d fb fc c6 05 09 32 c7 0a 01 90 48 c7 c7 60 83 e2 8b e8 97 5b bf fc 90 <0f> 0b 90 90 eb b7 e8 9b 6d fb fc c6 05 e6 31 c7 0a 01 90 48 c7 c7
RSP: 0018:ffffc900001e7a68 EFLAGS: 00010246
RAX: 3c6a9b38a742a100 RBX: 0000000000000003 RCX: ffff88801d298000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc900001e7c70 R08: ffff8880b8724293 R09: 1ffff110170e4852
R10: dffffc0000000000 R11: ffffed10170e4853 R12: ffff8880b8739700
R13: ffff88801d2ab218 R14: ffff8880331dc130 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888125d07000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056071c71c048 CR3: 000000000df38000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
