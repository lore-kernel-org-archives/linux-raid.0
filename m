Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81E249D588
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 19:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789673437; cv=none; b=CGCrg8sFd4dUfRjQyg3VqbMAiTYKgYAZ4FpLMOAwye0/rVIw5vHRc1vTUNHa26acrWEPYpYxzd3q3D78WcBUguG7zqDl9XhfJhn3dGZqGcKCAJ7evEYXRd1KGQ13x2CE0hoyv8/yTEQEoraIUSNxsCOlfPQUKu36po3sJTjWbyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789673437; c=relaxed/simple;
	bh=eMaq8RLV8quYoQsiaB8eCxVRfk+jd+94+wshSktzVnQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Yl2KdkmgLhU1Fi7SYP96PcWc8IWb6fqWekzUsvChPWKs8/uO2/PpqhFPLJaH1IPjtOHNmeCbiWehXUxcppLK7NrxpL2IR9xohpHr1U5F//q++K0bHx6ODDpUDhwQQC2g0Z1l9Fb0LL6JqXTeI9vvtmDN/obIj35ItqCdUyGP4Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-4a49b13b745so18061b6e.0
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 12:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789673433; x=1790278233;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QxfZm777yiB3GOiVhcaZHS4Wrc/4+22T9DdmmcwZ2XQ=;
        b=Z/Qq+waZyY2a/BFIZIMy7plM28imglVFvGe9Xzi6WJanCno6ZNfzAeFclBGLikqwqT
         7+s5cLXTADrmQxHOCMb+R8/AZkp0jPQhYN2OZcV2eoMwj/0MVV5w9v/8kAiKxwlthzzU
         6Hb1rL03qjTVL6M0z/QuzkSqpcICWlVFLh/R6DIQhoBi6S01rZ0KZOizFWqmBU9QmdXK
         ZUqIdLdE7EBxjVswK/92VmT5moUBzA0I5m7LWTN+I4LyGF3nVLPvFt8mj4FnAP5S4SIF
         0sEUAgUQ70MKlsd4bXOMp3PQytQq9QW8qcr9mjukcKGbbMr8bQLQwPT4aw4Kc26mu+cM
         xGEg==
X-Forwarded-Encrypted: i=1; AKwUvBzeA4JZVnzWmn5IhERBrbUz1LtVyJEt/rQoFxv61gPWZklVjuV39oPrU4r7og0jJ0V3ZpcRUPRP9D2P@vger.kernel.org
X-Gm-Message-State: AFuF++mngQrcwB3GzT+nrpub89H8YPxEBJSST6UQw6KWhrXsz6/bzfel
	sZ7xZSFcM5U71xMRy+OPK8mYDtEvicqkKMCe3yLw5yAuzSV2ox06t+4+fQTp7CHtYyfbJaL9RQF
	FGnHEelX3YLXK+8s7kYSN7K3mdBTXeQ1lDYa1NlZ1fmAYcVnPQrCfGijAYYU=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c162:b0:4c9:90bf:5f5d with SMTP id
 5614622812f47-4ccf6e6dfe3mr329110b6e.11.1789673433779; Thu, 17 Sep 2026
 12:30:33 -0700 (PDT)
Date: Thu, 17 Sep 2026 12:30:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aac3fd9.b398a7c9.1f86be.0022.GAE@google.com>
Subject: [syzbot] [raid?] WARNING in ppl_init_log
From: syzbot <syzbot+2ef75c54d0b2ac5d00ba@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    238650ef6c7c Merge tag 'powerpc-7.3-4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107c7925580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=2ef75c54d0b2ac5d00ba
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/35551601d170/disk-238650ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/62ad5ac38086/vmlinux-238650ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bd8d0f191876/bzImage-238650ef.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2ef75c54d0b2ac5d00ba@syzkaller.appspotmail.com

md/raid:md0: raid level 5 active with 2 out of 2 devices, algorithm 2
------------[ cut here ]------------
kmem_cache of name 'ppl_io_unit' already exists
WARNING: mm/slab_common.c:112 at kmem_cache_sanity_check mm/slab_common.c:111 [inline], CPU#1: syz.0.52/6045
WARNING: mm/slab_common.c:112 at __kmem_cache_create_args+0xae/0x460 mm/slab_common.c:352, CPU#1: syz.0.52/6045
Modules linked in:
CPU: 1 UID: 0 PID: 6045 Comm: syz.0.52 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
RIP: 0010:kmem_cache_sanity_check mm/slab_common.c:111 [inline]
RIP: 0010:__kmem_cache_create_args+0xb1/0x460 mm/slab_common.c:352
Code: e7 8e 4d 8b 24 24 49 81 fc 68 2e e7 8e 74 20 49 8b 7c 24 f8 48 89 de e8 ad fe c8 09 85 c0 75 e2 48 8d 3d 52 cc 66 0e 48 89 de <67> 48 0f b9 3a 48 89 df be 20 00 00 00 e8 4d 00 c9 09 48 85 c0 0f
RSP: 0018:ffffc9000555f9a0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff8cf7a820 RCX: 0000000000000004
RDX: 000000008cf7a803 RSI: ffffffff8cf7a820 RDI: ffffffff907ec6e0
RBP: 0000000000000000 R08: ffffffff907a3e7f R09: 1ffffffff20f47cf
R10: dffffc0000000000 R11: fffffbfff20f47d0 R12: ffff88801d79d2e0
R13: 0000000000000000 R14: 00000000000002d8 R15: ffffc9000555fa80
FS:  00007faf490c56c0(0000) GS:ffff888124dd1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fab21a7a010 CR3: 000000007a880000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ppl_init_log+0x285/0x1310 drivers/md/raid5-ppl.c:1363
 log_init drivers/md/raid5-log.h:138 [inline]
 raid5_change_consistency_policy+0x255/0x740 drivers/md/raid5.c:9141
 consistency_policy_store+0x7f/0x230 drivers/md/md.c:5883
 md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faf4819e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faf490c5028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007faf48425fa0 RCX: 00007faf4819e159
RDX: 0000000000000004 RSI: 0000200000000500 RDI: 0000000000000009
RBP: 00007faf4823506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007faf48426038 R14: 00007faf48425fa0 R15: 00007ffc85c60718
 </TASK>
----------------
Code disassembly (best guess):
   0:	e7 8e                	out    %eax,$0x8e
   2:	4d 8b 24 24          	mov    (%r12),%r12
   6:	49 81 fc 68 2e e7 8e 	cmp    $0xffffffff8ee72e68,%r12
   d:	74 20                	je     0x2f
   f:	49 8b 7c 24 f8       	mov    -0x8(%r12),%rdi
  14:	48 89 de             	mov    %rbx,%rsi
  17:	e8 ad fe c8 09       	call   0x9c8fec9
  1c:	85 c0                	test   %eax,%eax
  1e:	75 e2                	jne    0x2
  20:	48 8d 3d 52 cc 66 0e 	lea    0xe66cc52(%rip),%rdi        # 0xe66cc79
  27:	48 89 de             	mov    %rbx,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	48 89 df             	mov    %rbx,%rdi
  32:	be 20 00 00 00       	mov    $0x20,%esi
  37:	e8 4d 00 c9 09       	call   0x9c90089
  3c:	48 85 c0             	test   %rax,%rax
  3f:	0f                   	.byte 0xf


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
