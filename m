Received: from mail-oi2-f5.google.com (mail-oi2-f5.google.com [74.125.231.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B3A78F3A
	for <linux-raid@vger.kernel.org>; Sun, 20 Sep 2026 01:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789866632; cv=none; b=mHgRQKR4amQx46ZJe3gE9aBQeX7JNgYMPSKPBqPoREps+a5qTJxY87wZgBe/nBv8i8XjzRDnCgNUe92ovuPYgQRbIQbFj2pqBdZhgZw2RTXE4fpl7yFqyzfs70hoNhiOkfCtrROdmR+XHC7fQTQZZ+VVqi2YAJs1xevacQJbnxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789866632; c=relaxed/simple;
	bh=J4fGPYdbU1vyqMW4j4VL0zWFiRawM4Pn+sjLC1OmvfY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=K/5Z3cutmom5PSxyTspuI67DZdrWhxECVvBm7WuitUEr4KFirvtA6icwwjGhBh0UJUil+ffT3ZeemKqe73ijkrqKIxpOZowb4R5A2kHCrAH5HTU1EZgONqeMj0aizCrqcY+ZxToXa1enL9WorrFj10DgTdLvB88E7ElZwsHsxEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f5.google.com with SMTP id 46e09a7af769-801706d7e6dso1001212a34.0
        for <linux-raid@vger.kernel.org>; Sat, 19 Sep 2026 18:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789866628; x=1790471428;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PF45CuBTojQyukx9jI6xau1zxJKpu3tO8/fDW5FRIMM=;
        b=BGFG3whog2dT8rJKB0eOamMLRPLwS5yZ8WDMinv+mElLbizUGH/ac2p4hsbvJEOfdo
         t79g0FXViyCSAwMrecTTYlKSDXF1gb32SqNA8mWUfX0MO3DMUaQeZvN5z/pSYY4VqkiD
         4X/h5z3GX4A4CM6TT1nXZpKCi12laKrG/yZ1BUklPU7KnRlbjNwrvka7o7Q5E45iV0G/
         ZjLffShce7pt08O9gYR0vQija3LngrFdtYZhw4tpo+O9G4vtxdI+Y5YXRMuVEsQztGma
         /A4/El70CAFSQnauymtFN3YkXG0VH8xwv45NEVahcS2N8wWsPxUENT8j8bfTxUw6Len8
         A4lA==
X-Forwarded-Encrypted: i=1; AKwUvByJ1e3Yg8Rm8koEy+JZAS5mh3XHY0v+raSGLPVM5LscrqbJKXltkFvxe7avxlI3QDo3m8pGgo6iKnKG@vger.kernel.org
X-Gm-Message-State: AFuF++m8UmP+k3zV1rqe1oILvOAS5cKmvmDPsm3HgjRVJw/lq49jev4D
	8YJz9mdweTaCjFCEvk73h9NQ0eBsi0CWrEqEAMrhoLQq5NoKDOpumn0iadM8nuWXF6tliJy/TVH
	3gNnwuWbAb1i22jZs4lhEiKMLwp7kqB0B7hpzlDUozI39QEDTHa8KpMEI5A4=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7093:10b0:6cd:3ffc:ad08 with SMTP id
 006d021491bc7-6cd3ffcb687mr2390033eaf.88.1789866628349; Sat, 19 Sep 2026
 18:10:28 -0700 (PDT)
Date: Sat, 19 Sep 2026 18:10:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaf3284.514bccd6.255447.0003.GAE@google.com>
Subject: [syzbot] [raid?] WARNING: kobject bug in bind_rdev_to_array
From: syzbot <syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    518e5b794c06 Merge tag 'for-7.3-rc3-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12345ff9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3bddd52b22c2498
dashboard link: https://syzkaller.appspot.com/bug?extid=95eeb4ada2349a2170ea
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-518e5b79.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5307a29f916b/vmlinux-518e5b79.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7d4c698a99b1/bzImage-518e5b79.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com

------------[ cut here ]------------
kobject: '(null)' (ffff8880120640f0): is not initialized, yet kobject_get() is being called.
WARNING: lib/kobject.c:642 at kobject_get lib/kobject.c:640 [inline], CPU#0: syz.0.0/5330
WARNING: lib/kobject.c:642 at kobject_add_internal+0xea/0xcd0 lib/kobject.c:225, CPU#0: syz.0.0/5330
Modules linked in:
CPU: 0 UID: 0 PID: 5330 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:kobject_get lib/kobject.c:640 [inline]
RIP: 0010:kobject_add_internal+0x113/0xcd0 lib/kobject.c:225
Code: 04 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 4c 89 e7 e8 57 11 5b f6 49 8b 34 24 4c 89 f7 4c 89 e2 <67> 48 0f b9 3a e9 e4 00 00 00 e8 fe 6a e9 f5 b8 fe ff ff ff e9 fb
RSP: 0018:ffffc9000f1f78a8 EFLAGS: 00010246
RAX: 1ffff1100240c81e RBX: ffff888052836080 RCX: dffffc0000000000
RDX: ffff8880120640f0 RSI: 0000000000000000 RDI: ffffffff908d7cc0
RBP: 0000000000000000 R08: ffff888000b14b00 R09: 0000000000000008
R10: 0000000000000007 R11: 0000000000000002 R12: ffff8880120640f0
R13: dffffc0000000000 R14: ffffffff908d7cc0 R15: dffffc0000000000
FS:  00007ffbef2886c0(0000) GS:ffff88808c2c2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f208abad1bc CR3: 000000000e910000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kobject_add_varg lib/kobject.c:374 [inline]
 kobject_add+0x163/0x240 lib/kobject.c:426
 bind_rdev_to_array+0x80c/0xdd0 drivers/md/md.c:2621
 md_add_new_disk+0xe3b/0x1850 drivers/md/md.c:7684
 md_ioctl+0x200a/0x2610 drivers/md/md.c:8499
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffbee39e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffbef287fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffbee626090 RCX: 00007ffbee39e159
RDX: 0000200000000420 RSI: 0000000040140921 RDI: 0000000000000004
RBP: 00007ffbee43506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffbee626128 R14: 00007ffbee626090 R15: 00007ffe703ff368
 </TASK>
----------------
Code disassembly (best guess):
   0:	04 4c                	add    $0x4c,%al
   2:	89 e0                	mov    %esp,%eax
   4:	48 c1 e8 03          	shr    $0x3,%rax
   8:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
   f:	fc ff df
  12:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1)
  16:	74 08                	je     0x20
  18:	4c 89 e7             	mov    %r12,%rdi
  1b:	e8 57 11 5b f6       	call   0xf65b1177
  20:	49 8b 34 24          	mov    (%r12),%rsi
  24:	4c 89 f7             	mov    %r14,%rdi
  27:	4c 89 e2             	mov    %r12,%rdx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 e4 00 00 00       	jmp    0x118
  34:	e8 fe 6a e9 f5       	call   0xf5e96b37
  39:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  3e:	e9                   	.byte 0xe9
  3f:	fb                   	sti


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
