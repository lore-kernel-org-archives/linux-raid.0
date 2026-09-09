Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5C0533582
	for <linux-raid@vger.kernel.org>; Wed,  9 Sep 2026 11:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953250; cv=none; b=dZ44sR7+qALeQZNHgzoPzSo0Lzu3pS0DgzT9SELrB2eEzu5UARkXLXYx37IaAfoDBIprINjP2um7F3M9LQbBVnrdH5BXJn5zNtxBIKSHp8+xk+gomJd4UX/vRxnjgD8GN1LCuw+j4wal1zcmg4S+Bf+8zsGatdkZovYgFa5QgU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953250; c=relaxed/simple;
	bh=w9ltMKPC7FxIL2LdZjYaFQY9LYuMDWYBPJFCSHRx4Es=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=F+0a4yhRefG2WV5g/sen4jOr/rCiBYRPw3RCDqLw7DgU5kEbbSAqYKXnqYmMT+Y4gcHmG2O7tRL//DXYndKjNSE+lHJCtaRpB/PhQqiZG4N1iPM7Q6YSOzsDss9Sd5tdhMacJ6LBe4/wLye4PCQcKiKZhhSVvkjX+XMxyhiV0Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7eb6429750eso6576166a34.0
        for <linux-raid@vger.kernel.org>; Wed, 09 Sep 2026 04:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788953248; x=1789558048;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f1CvJn7NYjTtkQkEwkFRULKmMA7w0g21i7peffLilg8=;
        b=E2WGSVatJXvsLWHTK9AFPPYXhLwIHapClh2VGaAqW5zqJiAh2ii6gXoYKP2hc7Mm5J
         nnhnGNvQHUHyq2ufuwexkmwJrLo/D/i67ejsxYwdBBLUw8wqNoyWc3jhdJzcEyjSVmS7
         CoSX9QJkh8nSDzJwZYpSrpHZw7dc1QmgjvSUDopyYKBrtTVWQrucGQcmsCAKaOugB7+5
         OAI5G42HBRVs+8HNfdtKB2QWJQLyEzth2A7jNYDL+eBvHr1mqZ3YaCJwn5TquTiMu2Qj
         6ZSTULQqs9hfeQQGVECkwq1lL7RU4PMzTupD01OSTN5/bs/sTzsuxwCGC+DQgFoRrOKF
         znRw==
X-Forwarded-Encrypted: i=1; AKwUvBzUWK4GiaET15g8EEmscSq1CqtPDhKdo9t/Xz9aU41V+TFgBQvx1tob4Yjmhya6vdQwNGygTDnrylEs@vger.kernel.org
X-Gm-Message-State: AFuF++lJ6zsZFvfIm9jDV6MAzdyQlnmo/JAJ7lBO2XrVQA/DBqxpA9+b
	xloBYWdx7R5UmBTCpH9bMLY48Jql2ijX9oztCimA8FH6+yGmRGpVjl6o49c8CzOQLHM3t7dP0n2
	VfAaLQPQx2vr73Jj1/kcrMR6RRfcmCvfWo9HyL70igYmT00vbo+B6VlTWkqA=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:200f:b0:6b9:7d9e:5708 with SMTP id
 006d021491bc7-6bdc949e3b9mr5591427eaf.3.1788953247713; Wed, 09 Sep 2026
 04:27:27 -0700 (PDT)
Date: Wed, 09 Sep 2026 04:27:27 -0700
In-Reply-To: <6aa12989.f2639fcc.29487d.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa1429f.6e6c5f9e.28f11f.0024.GAE@google.com>
Subject: Re: [syzbot] [raid?] kernel BUG in raid5_run
From: syzbot <syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    5acbae5f7eb3 Merge tag 'powerpc-7.3-2' of git://git.kernel..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1574d749580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1774d749580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at drivers/md/raid5.c:8117!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 2 UID: 0 PID: 6026 Comm: syz-executor387 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
Code: 03 00 00 41 8b ae d0 01 00 00 31 ff 89 ee e8 f0 f6 82 f9 48 c7 44 24 10 00 00 00 00 85 ed 0f 84 44 f4 ff ff e8 6a fc 82 f9 90 <0f> 0b e8 62 fc 82 f9 49 8d 86 e0 00 00 00 48 89 c2 48 89 44 24 60
RSP: 0018:ffffc90003c879f8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88802bdb2580 RSI: ffffffff888914a6 RDI: ffff88802bdb2580
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000008
R13: 0000000000000000 R14: ffff88802cfb0000 R15: ffff88802cfb0028
FS:  00005555884d2400(0000) GS:ffff8880d5d5d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff95c66058 CR3: 000000005631b000 CR4: 0000000000352ef0
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
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe6b68b8a77
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffd56632d40 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00005555884d2400 RCX: 00007fe6b68b8a77
RDX: 0000000000000006 RSI: 00007fe6b68f21aa RDI: 0000000000000003
RBP: 0000000000000032 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007fe6b68f21aa
R13: 00007fe6b68f4500 R14: 0000000000000002 R15: 00007fe6b68f44b0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
Code: 03 00 00 41 8b ae d0 01 00 00 31 ff 89 ee e8 f0 f6 82 f9 48 c7 44 24 10 00 00 00 00 85 ed 0f 84 44 f4 ff ff e8 6a fc 82 f9 90 <0f> 0b e8 62 fc 82 f9 49 8d 86 e0 00 00 00 48 89 c2 48 89 44 24 60
RSP: 0018:ffffc90003c879f8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88802bdb2580 RSI: ffffffff888914a6 RDI: ffff88802bdb2580
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000008
R13: 0000000000000000 R14: ffff88802cfb0000 R15: ffff88802cfb0028
FS:  00005555884d2400(0000) GS:ffff8880d5d5d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff95c66058 CR3: 000000005631b000 CR4: 0000000000352ef0


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
