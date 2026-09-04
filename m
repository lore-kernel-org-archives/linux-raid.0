Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976CB38398E
	for <linux-raid@vger.kernel.org>; Fri,  4 Sep 2026 20:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788554788; cv=none; b=h/Nch6PFTj4i5udeNsIDleNPyuUihoZCWjDorkfJoG3PVz90n97Zj1uvSolvyRi1M0Zy0THJ86uzrnDfw4OHg4SQhRANGqZWy6DcEIVKeDnjZHceo7ouY9khG7c6YR+7752yH4ifu5dkBO72gSR6440TcJBModmw3xRoQ0czj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788554788; c=relaxed/simple;
	bh=zHoit6yLi3fXOCiRdtBQT2k7fF7NAw0hJ+ckUM7JHuk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MZOQPyPA5bWG/Hxq83zlW0yM3YFEgoCTFTHpXhww0xRF73yNX70WGy4J9lTxjBhcnHEVFloxWEgG7mrK4AGNUykZVpJCrOWSppDaPGsc+qBZhGpscQbSdWBo9fK4aBx0vvUQmg2xlrvpdbFu2NZactgzNOhQy1HFo+lNhZpnecE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6b34c5c6de4so1733000eaf.1
        for <linux-raid@vger.kernel.org>; Fri, 04 Sep 2026 13:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788554783; x=1789159583;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pWzV16Ft4hj12P0wEeA5w+i7D224GdQ4JfXKDriSivw=;
        b=NZPs8Nf2Ru1vQqXCbiykNwg9gX17hFTy1UNBI2Bq0wt6MSJvhKjS5IlKdavOkQoCqA
         hSEmFFHn8JRWhyBvLBBn0Xz5BJST/g5/86E0aEwPiVE83qPYZVsp2V12/fqMaLBN0ME1
         xI2pI29dW560U5SDMMCSI//VQXsGoYRAjiZ7lXtLHqFol5UlTWZZJ1/H7aFvVQfLifTq
         92q0loHaZOkY4vp45HkCuLqHheKItGnMEonptXr2j3IUOVydCb5G9HwoCXVE+wzXm+UY
         CWh5IGr4de6d2ibydnEp5pnid9AOUQMug3KmmolmQ6jxi4HpkdCia8O7mgmfiORi/JTT
         r+uA==
X-Forwarded-Encrypted: i=1; AKwUvBzkkdpAS/6NC0hCBQ2ZA0GK8xN1xQvVZKuRC8tKMAD0X5MnwUexmfHj36z9nU25QMPYR27MGrqAawUi@vger.kernel.org
X-Gm-Message-State: AFuF++n3Mef5fn+1m10SuLskIHnrRXebgGFhhrrJdkB+eLAiYG2XCOKr
	28gT6Zh1pN0vnI1/yVE26AOm8P/4pAb7D+PUWRbDZekQxIB2u7LSW9dMyjXKrqdB2o+5dg2rSMY
	VbCwFi7joqkwa7U2hVAh1fI6zSVgei7kZhUemhxKSw/guKR3yKKwU2tYdTXg=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f08:b0:6b1:b23c:2142 with SMTP id
 006d021491bc7-6b6fa5e819cmr6179657eaf.1.1788554783551; Fri, 04 Sep 2026
 13:46:23 -0700 (PDT)
Date: Fri, 04 Sep 2026 13:46:23 -0700
In-Reply-To: <6a972e63.610165a0.2b3dfd.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9b2e1f.a5e650b3.363816.0001.GAE@google.com>
Subject: Re: [syzbot] [raid?] WARNING in create_strip_zones (2)
From: syzbot <syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    bc35965f6940 Merge tag 'mm-hotfixes-stable-2026-09-03-17-4..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12271215580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=a32ff75e417c0f49a8e9
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173f2b49580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com

------------[ cut here ]------------
!(flags & __GFP_NOWARN)
WARNING: mm/slub.c:7013 at __kvmalloc_node_noprof+0x646/0x9b0 mm/slub.c:7013, CPU#3: syz-executor142/6020
Modules linked in:
CPU: 3 UID: 0 PID: 6020 Comm: syz-executor142 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__kvmalloc_node_noprof+0x646/0x9b0 mm/slub.c:7013
Code: c1 e8 2e 07 ff ff 4d 85 f6 0f 85 b6 fd ff ff 48 81 fb ff ff ff 7f 0f 86 4d fd ff ff 41 81 e4 00 20 00 00 0f 85 9c fd ff ff 90 <0f> 0b 90 e9 93 fd ff ff 41 be 10 00 00 00 e9 88 fd ff ff be 42 01
RSP: 0018:ffffc900036bf948 EFLAGS: 00010246
RAX: 0000000000000001 RBX: 0000000200000000 RCX: 0000000200000000
RDX: 0000000000000000 RSI: ffffffff8c620f00 RDI: ffffffff8e6b6938
RBP: 00000000001fffff R08: 00000000000029c0 R09: 00000000ffffffff
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 00000000000029c0 R14: 0000000000000000 R15: 00000000ffffffff
FS:  0000555559921400(0000) GS:ffff8880d5e60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bcaf223cc0 CR3: 0000000055943000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 create_strip_zones+0x57f/0x1fa0 drivers/md/raid0.c:150
 raid0_run+0x341/0x410 drivers/md/raid0.c:424
 md_run+0xc2f/0x2510 drivers/md/md.c:6779
 do_md_run+0x36/0x660 drivers/md/md.c:6880
 md_ioctl+0x27eb/0x36d0 drivers/md/md.c:8515
 blkdev_ioctl+0x5ad/0x6f0 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f76d13e162b
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffc9fbd7ba0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f76d13e162b
RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f76d143a032
R13: 0000000000000002 R14: 00007f76d1464cc0 R15: 0000000000000002
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
