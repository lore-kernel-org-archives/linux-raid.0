Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7E4A386D
	for <linux-raid@vger.kernel.org>; Fri, 25 Sep 2026 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359368; cv=none; b=FTujhrGFcgh9KO8XYJhnrzZO0MTqq2M44gA/c6gLBFZ532S5Llv2zC4vP8FTdk2ymQWXzRTfOB1N1EdSiheIyUFtZ5DbMGjIC5iOPr+dtOl34qhiV6FbHBGr9TTX+k1QyT0Tqw0QujySIoBOPqMcjduZ8tcRMBOhc/QjQ1IanHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359368; c=relaxed/simple;
	bh=AehR+KT6RlixjqCpwwt4zzkZFGjHtQHX61t3LkMFnm0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UQTIbSrx5W32cVBCDZ6fS7QkEmG9pnXGmHuSOw2VABhv9VJRnfE8alcXkOeamdWhhfDrpLArgO64TQM3c68l0qwSVF7hzaVmbblMr9HkR1HJO+6sEjvmXp+IG7STgXQzKHExJpSj6ahIBNy4yGn43ANG3yJnSAN5bMKtz6IspmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-8076c66efc6so1860791a34.3
        for <linux-raid@vger.kernel.org>; Fri, 25 Sep 2026 11:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790359364; x=1790964164;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LR0wdHvXGant0DLEmMLmd0j5kClzG8NqhN2waw//8YE=;
        b=FNDZR4NmGPKcUTk4HFA5RUHS5pkTqUtqdBAi1MGFV99FNWv+EaitDBd/PKZsjPDJ1A
         7sR44DKieLIRgvmKC9H8oR5g9C20hRtDCYbDJ6H6vi5iDWnakTkQ6fbzJHmh7gAzHz7O
         PBu+MI/nikek5sQExkzJiwrByR4b7Yk7hYKxNUYQ3GE0NyeJ+dl0DuOoUqdZZKHCsce7
         lofDIlk0V240XxKQXetlLu1KfwcfNgXBsBUQ87hj2wOe5HYfUA/bzV72JkIbvfI/l1+7
         wTbKrHqjkCM390xzTFlkJADpzNxenXJ/C4SJKJclvYBDiR0KsuvbpKh9ns6vbchU/InU
         12fg==
X-Forwarded-Encrypted: i=1; AKwUvBxvbrnt2CZLjop0g4gHKpeGtZmX2mZn6a2+hBaKDlmiSjJWfabzhFLFw+0/vX6ksaUZNH5AccQYZa8z@vger.kernel.org
X-Gm-Message-State: AFuF++nJtId2FIMdfdBJxRBL3MfHPFVDmgtPZ+/FToXmxDIJztsMiJEN
	HG2Ujwd/XmA/rwX/1JEsxq0NyFoiYABsIHBEUy8BBuyLylkALXsvqoL9F2VTT046p4onLTYvuVV
	VK7Wz7+6w98eZRxv0C0mnLjaf1ryw5dLI5r3I7nObLDUX8lRnSqHfKdViL1M=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a03:b0:4cb:f21c:a795 with SMTP id
 5614622812f47-4d72982efa6mr6484733b6e.29.1790359363567; Fri, 25 Sep 2026
 11:02:43 -0700 (PDT)
Date: Fri, 25 Sep 2026 11:02:43 -0700
In-Reply-To: <6ab10ffa.a6af0033.177e91.0014.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab6b743.7eec07f4.c25c.0006.GAE@google.com>
Subject: Re: [syzbot] [raid?] WARNING in free_conf
From: syzbot <syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    165768bb7026 Merge tag 'firewire-fixes-7.3-rc5' of git://g..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=15160205580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d4242cb1c54cdf7
dashboard link: https://syzkaller.appspot.com/bug?extid=6a132745caefcf42cb0d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1039d205580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com

Object 0xffff8880541a09b0 @offset=2480
Object 0xffff8880541a0e88 @offset=3720
Object 0xffff8880541a1360 @offset=4960
Object 0xffff8880541a1838 @offset=6200
Object 0xffff8880541a1d10 @offset=7440
Object 0xffff8880541a21e8 @offset=8680
Object 0xffff8880541a26c0 @offset=9920
Slab 0xffffea0001506800 objects=13 used=7 fp=0xffff8880541a0000 flags=0xfff00000000240(workingset|head|node=0|zone=1|lastcpupid=0x7ff)
Disabling lock debugging due to kernel taint
------------[ cut here ]------------
1
WARNING: mm/slub.c:1268 at __slab_err+0x15/0x20 mm/slub.c:1268, CPU#1: syz-executor938/6015
Modules linked in:
CPU: 1 UID: 0 PID: 6015 Comm: syz-executor938 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
RIP: 0010:__slab_err+0x15/0x20 mm/slub.c:1268
Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 e8 2b 00 00 00 bf 05 00 00 00 be 01 00 00 00 e8 9c 0f 5f 00 90 <0f> 0b 90 e9 5e 04 e8 ff cc 66 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc900036ff840 EFLAGS: 00010093
RAX: ffffffff81874cda RBX: ffff888028866280 RCX: ffff888030b89f40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff9399d0a7 R09: 1ffffffff2733a14
R10: dffffc0000000000 R11: fffffbfff2733a15 R12: ffffea000158e510
R13: ffffea0001506800 R14: ffffc900036ff858 R15: ffff8880333cf3c0
FS:  000055555e3d3400(0000) GS:ffff888124dca000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2017871ac0 CR3: 000000007c35a000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 free_partial mm/slub.c:8122 [inline]
 __kmem_cache_shutdown+0x1a5/0x2b0 mm/slub.c:8165
 kmem_cache_destroy+0x9d/0x180 mm/slab_common.c:576
 shrink_stripes drivers/md/raid5.c:2719 [inline]
 free_conf+0x1fc/0x5d0 drivers/md/raid5.c:7553
 setup_conf+0x1720/0x2ad0 drivers/md/raid5.c:7885
 raid5_takeover_raid1 drivers/md/raid5.c:8934 [inline]
 raid5_takeover+0x641/0x8d0 drivers/md/raid5.c:9045
 level_store+0x83b/0x1d10 drivers/md/md.c:4134
 md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fadcdd27cb7
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffef54c24b0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000055555e3d3400 RCX: 00007fadcdd27cb7
RDX: 0000000000000005 RSI: 00007fadcdd610f1 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
R13: 00000000000000c8 R14: 00007ffef54c2500 R15: 00007ffef54c2520
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
