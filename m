Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9571E5B9F
	for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789320878; cv=none; b=mqRFAkEFKqQIc5T9i/AWpcGnzG52Elc1ie7GvzDh5OLFOoaQon164PGg099EOejEQxZDsD2jqHsMk3Y8GzPp9LIaKdpMxPxTLsBTlLt9iBePDTiYwbyOfpO8WH+5wDm+UzrnQAQq0z5i5y7rlWBbX02v/4zlrQtEjiGWSyxzNao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789320878; c=relaxed/simple;
	bh=JHMzTYc7xnB9zR6xsWPnUDoHDmX0Io39tZbvpflxwCw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=TNnxweKq71W7IjIi8lbrWsZ0FvAmAayDBsUukTPMwSh38CoTmGTwcVF4F5Wp6WSAwt8tgjyjFNl4JGw7uIcnTjFDqKr5KQi6hTq64PjWbdwmX0A3k2A4hGIe5UNnu4UD51cMTFdxHGgySa3jZPRw3B5JAyUTx3cSyxb80X/00Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab4dd46ddeso1548237b6e.3
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 10:34:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789320876; x=1789925676;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=F1FCP5X1xegelBdBRFJWgucE9l3lpvEosm7PW1WQ55o=;
        b=Vvl3IqyRoWUILCGQj1eAHyfCMnhDodU64EUkthw+oNMv77erUSvf6f+N5rJe8kmcDY
         WBOfLtfuuiM1m3rX4wlvM0ATNkBA8gHEoMSVJAVM+jkWAV82WSTmhPWRLCdpfWktMwej
         2HvcDxbjHax1eGi0g4ifrf1lhQ2jmlPgXT5dd45eVJrj53e0mmHZTWtxkGjjFd8YTPDN
         bF4GKQ2f+zGl1xX/xwJov5ItpE9Pr4VvxJHTtjmKbK6/cTkc2FmVNdmxgZG5ZKIbjep/
         t+xA5YDbaJeFpZLg74nRGhq+DgxsyBTUisg+c1rOPrE1Ywb4gdkL1k08YV67EDhRYrE+
         xR1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwXz6NbTVo/5xfkHsCqnEiQbNAY8DyfyyvDJZcYYH4tYqzb7nIbIV0Un/iwgZrFflZAvKeL1rtvsSus@vger.kernel.org
X-Gm-Message-State: AFuF++kGz50AKyuKuAMijxjEmenGOSLLtN8ht+dVsQHK4c14QS2o1t1d
	/8xWYr7/+UMeYVXFeemMSGbxAu16KVBBOWQJiXbpLT/p+oFc1PPgbDUOCKxkpJiYNsxDwnAaLur
	vFMcVdHl/95GYqfXikCEZSpEVmwFdVGLpaqAGZVvQGAzysUIg3QdLghTOXbw=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1988:b0:6b1:4b76:1c18 with SMTP id
 006d021491bc7-6c24d399401mr3976271eaf.24.1789320876397; Sun, 13 Sep 2026
 10:34:36 -0700 (PDT)
Date: Sun, 13 Sep 2026 10:34:36 -0700
In-Reply-To: <6aa6a091.f670cee1.72fc4.0012.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa6deac.f670cee1.72fc4.0013.GAE@google.com>
Subject: Re: [syzbot] [raid?] UBSAN: array-index-out-of-bounds in super_90_sync
From: syzbot <syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2f0c1cf72f46 Merge tag 's390-7.3-3' of git://git.kernel.or..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=14afd5f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12afd5f9580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in drivers/md/md.c:1697:17
index 124 is out of range for type 'mdp_disk_t [27]'
CPU: 1 UID: 0 PID: 6018 Comm: syz-executor186 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xcc/0xf0 lib/ubsan.c:455
 super_90_sync+0x1eed/0x1ff0 drivers/md/md.c:1697
 sync_super drivers/md/md.c:2505 [inline]
 sync_sbs drivers/md/md.c:2747 [inline]
 md_update_sb+0xbba/0x2840 drivers/md/md.c:2923
 state_store+0x31e/0x1340 drivers/md/md.c:3245
 rdev_attr_store+0x1d9/0x560 drivers/md/md.c:3768
 sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6af/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f84634ad6f7
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007fff04c70ef0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00005555934c5400 RCX: 00007f84634ad6f7
RDX: 0000000000000008 RSI: 00007f84634e9c12 RDI: 0000000000000003
RBP: 00007f84634e9c12 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff04c70fc0
R13: 00007f84634e9b5f R14: 00007fff04c710d0 R15: 0000000000000002
 </TASK>
---[ end trace ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
