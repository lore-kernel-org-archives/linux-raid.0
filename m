Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30A039A4A4
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790185773; cv=none; b=Im25NzD46ekoNmRq86epnYTegA0/FYdmOyZZ4AH5AVf5ZEzz9Ly8vrXz2T1XZJT3ZIeQD/RlP2XGOx3Qu1awkCcNQuAUe69+bhfQvio7cJI8cdP2NV0b0umkmaoe9Nf/iKL4+8mBj/EEXOcx7EzWcA7trqplyTlw6lKfSxkI8jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790185773; c=relaxed/simple;
	bh=P1+tvHw1slpxwuQOyiakKqWUipAkZFzNjGyxkQPASA8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FbxtagzGubj+bPqrpa0OrSLklbO/5IscKoYqpKmksu+fT2nvp33ipPC+yaWj69s36ZypCTsgRSKDdOPO3OtuwCH1+tUcC0EgBcJqxcDh1cVLrxfmRHwFG9pQ3OalD4rZohOPGINLhgidukZuD0DBMF2OhBS14lb/axF/593hCO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f9.google.com with SMTP id 46e09a7af769-7f4e9ec63a7so439405a34.1
        for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 10:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790185769; x=1790790569;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIoxU7LRZ4puv9TjF5uCcIKvwIgsp8NZRHhDg/lp2NQ=;
        b=p6EteU/Q4JF+woI8OnAnmKOAOFlNn0RxT64CVfVoYplH082Egioj91lewYWstCN08H
         FuNl6oMuf4dRBToAChwm3T1/9eSKyXI976bDi4/tqSw4PgGudGlrrOBMdPE/bzIBo0BR
         R9HMwX6I798vmrxUEGQL4nMut1T6+5ThcCOIGQipxAuiSyJdnKNNh8hrkJ99CJN02+gJ
         TNp37v7PJDhmBmRk8dEHdDRcfzXCUcWFdaI3dYi6GmJvOGoggEymczJCypK8+WjLaGSO
         F22cNaYAP3niKTFK6zs+BcYCJLoeZKHL0ayI7aUeA8snv8rqXujf5sW1j5yk0PTcbGZw
         qkXA==
X-Forwarded-Encrypted: i=1; AKwUvBy9FFjJGJVn2S8u3eO46wOfkNyj4zDSouVbEkWEDhVTVVxDC+tJH1MbwJeJTtTNtrPMcxXxwGIuGMFw@vger.kernel.org
X-Gm-Message-State: AFuF++lsa8s7PO169aU4NuNaABM/JznzhI8+qc09dr3UmeE42m9Cb84d
	X2OgNpWTSLhJhSJ3s6hEuvn/KSyrFvw2q1JAGHag5OT3+08P5d3BvnK4GkpUxCf7YFMuQmDn0sz
	0MNd04jr4YqC4VUso8TTfm4YVBUIi9qCk5IiNuwstdjCVxXbyAGZ7bmh9T88=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1849:b0:6be:7d9:b14 with SMTP id
 006d021491bc7-6d2cf845d8dmr3207973eaf.4.1790185769616; Wed, 23 Sep 2026
 10:49:29 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:49:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab41129.e548f532.1ca396.001f.GAE@google.com>
Subject: [syzbot] [raid?] general protection fault in ppl_write_stripe_run
From: syzbot <syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    50d05c7c76c9 Merge tag 'landlock-7.3-rc3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17cfb4c9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
dashboard link: https://syzkaller.appspot.com/bug?extid=75d7e96ad03ac2dbbd9f
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11849405580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-50d05c7c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/303a0ade8f9e/vmlinux-50d05c7c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/70b8ca71442b/bzImage-50d05c7c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 UID: 0 PID: 6845 Comm: md0_raid5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ppl_write_stripe_run+0x60/0x1320 drivers/md/raid5-ppl.c:538
Code: 3c 02 00 0f 85 01 11 00 00 4c 8b 8b 48 09 00 00 49 8d 41 10 48 89 c2 48 89 44 24 60 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e b9 10 00 00 41 8b 59 10 31 ff
RSP: 0018:ffffc900077e7938 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888013c2c000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff888aae3d RDI: ffff888013c2c948
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888022c26000
R13: dffffc0000000000 R14: ffff888013c2c2b8 R15: ffff888013c2c000
FS:  0000000000000000(0000) GS:ffff888096a60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000fff8cec0 CR3: 000000006b079000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 log_flush_stripe_to_raid drivers/md/raid5-log.h:101 [inline]
 handle_active_stripes.isra.0+0x11e4/0x1540 drivers/md/raid5.c:6851
 raid5d+0xe00/0x17b0 drivers/md/raid5.c:6985
 md_thread+0x505/0x580 drivers/md/md.c:8706
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ppl_write_stripe_run+0x60/0x1320 drivers/md/raid5-ppl.c:538
Code: 3c 02 00 0f 85 01 11 00 00 4c 8b 8b 48 09 00 00 49 8d 41 10 48 89 c2 48 89 44 24 60 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e b9 10 00 00 41 8b 59 10 31 ff
RSP: 0018:ffffc900077e7938 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888013c2c000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff888aae3d RDI: ffff888013c2c948
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888022c26000
R13: dffffc0000000000 R14: ffff888013c2c2b8 R15: ffff888013c2c000
FS:  0000000000000000(0000) GS:ffff888096a60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000fff8cec0 CR3: 000000006b079000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	3c 02                	cmp    $0x2,%al
   2:	00 0f                	add    %cl,(%rdi)
   4:	85 01                	test   %eax,(%rcx)
   6:	11 00                	adc    %eax,(%rax)
   8:	00 4c 8b 8b          	add    %cl,-0x75(%rbx,%rcx,4)
   c:	48 09 00             	or     %rax,(%rax)
   f:	00 49 8d             	add    %cl,-0x73(%rcx)
  12:	41 10 48 89          	adc    %cl,-0x77(%r8)
  16:	c2 48 89             	ret    $0x8948
  19:	44 24 60             	rex.R and $0x60,%al
  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  23:	fc ff df
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e b9 10 00 00    	jle    0x10f3
  3a:	41 8b 59 10          	mov    0x10(%r9),%ebx
  3e:	31 ff                	xor    %edi,%edi


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
