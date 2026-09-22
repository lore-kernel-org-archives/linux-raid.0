Received: from mail-oi2-f6.google.com (mail-oi2-f6.google.com [74.125.231.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37F654857B
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 14:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086126; cv=none; b=ViKcElvqNyS6LbOIwUr2nfJB3wiJl/HTR6cyyZzwVjKgN+NLHwhuIfWCIWg3DcBno72zrB1BXge9TO6iZMOS7ETdXvML/VFGte/ohTEbIWyk3Tq0DdPiEq2cQbM3F8mAxE1y5jqA34wxqmSwEVIv/7JQ2aAqbYeq3G7ArvkJEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086126; c=relaxed/simple;
	bh=1kds8tC4BTayXiREnILf9Hh8KNywd1iA9cUHZ/a9U2c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NEC4uvHsMZorZMOfYwaIETZ17bpbVLAGcCMC3qhpGboMeDoP9WrA7CZL3yzzZDclVjb8uGS5ROuiQVvuEHzvwQ6ftz8bwGx6a5BYPq3Qug0spTRA9y5yu/kEUG7xUOLwndXefeG6t1uxJNzbDLumHunjQkvmb6W3tgN8RO2GwaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f6.google.com with SMTP id 5614622812f47-4b374c2cf2cso697115b6e.1
        for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 07:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790086124; x=1790690924;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FPxij3GIKryjcXEbmMsQS/qbe8XwIFxlkyNJU0nRpOY=;
        b=lATw6R0CJ7ZQSHHinONh2JcY5ht5nDhPOaRITNW1VIT96dFEByr3DQKDr7/1+TzTPy
         GngjWBvDduvLRjvzs15mR/1bnvHp3nWX30LzWX+Sm0iMqyCyMqekprgjecNGMZFUERUO
         06HN8om9h+4fb+fHInKedHK3dzncmx6Q6dx5eziuXLN12trIZrjO6y1YuM1vNlFTYklj
         5pCk0mOw1p6hdaI2kTJitG8d7WZimRCUmchbIFOFZvOcSEQ4pOSRcttzZZOOIlLOjvfJ
         XjZCTkjJZbapO18XOClnftOpJlCdoKDB28LKwR3SxNZAdzUJdg1i9pomukTUa5rD1vak
         +0eg==
X-Forwarded-Encrypted: i=1; AKwUvBw4oMp3BTcjJ3PE8yWtio495NWYveJnLttat1a2LU/SUDgGXzqvkv9YWMTJU4GvZyACo88Z9r3cokci@vger.kernel.org
X-Gm-Message-State: AFuF++lkKuO0uZ1X9RAnZr7CAvRb4v2VAOtiienkff5aZji+8ldsga8J
	NR7+AMk8FEI82XWJ5bZmQEmGmVA7YegF7QzzYmWV+KCR5iDI2udlb0YnoRaoUZGm4lCiM8K9XGe
	q0gpMTNFgkdXdBcSB8chzYmg9Ge9KQ3znWTiEfKncR2pb9bJ7TTQ13MddWiU=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:178e:b0:6b7:46e9:96ff with SMTP id
 006d021491bc7-6ca9c84d60dmr11904743eaf.47.1790086123743; Tue, 22 Sep 2026
 07:08:43 -0700 (PDT)
Date: Tue, 22 Sep 2026 07:08:43 -0700
In-Reply-To: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab28beb.a6af0033.177e91.0020.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in setup_conf
From: syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, matthew.brost@intel.com, rakie.kim@sk.com, 
	song@kernel.org, syzkaller-bugs@googlegroups.com, xiao@kernel.org, 
	ying.huang@linux.alibaba.com, yukuai@fygo.io, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    f0100363d8c3 Merge tag 'xfs-fixes-7.3-rc5' of gitolite.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17971805580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
dashboard link: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b20c5e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10720c5e580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f0100363.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/18fb2734cddb/vmlinux-f0100363.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5737b586e7bc/bzImage-f0100363.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com

md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.0.17/5462
WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397, CPU#0: syz.0.17/5462
Modules linked in:
CPU: 0 UID: 0 PID: 5462 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:alloc_order_allowed mm/page_alloc.c:5340 [inline]
RIP: 0010:__alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397
Code: 90 e9 76 fe ff ff 41 81 e6 3f ff ff ff 44 89 f1 41 83 e6 f7 a9 00 00 00 10 44 0f 44 f1 e9 45 fd ff ff c6 05 2c 98 38 0e 01 90 <0f> 0b 90 e9 8b fe ff ff 48 8d 3d ac 09 54 0e 67 48 0f b9 3a e9 68
RSP: 0018:ffffc90003b87520 EFLAGS: 00010246
RAX: ffffc90003b87500 RBX: 1ffff92000770ea8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000000e RDI: ffffc90003b87588
RBP: ffffc90003b87618 R08: ffffc90003b87587 R09: 0000000000000000
R10: ffffc90003b87560 R11: fffff52000770eb1 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000040dc0 R15: 0000000000000000
FS:  00005555836a7500(0000) GS:ffff88808c2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4a2c07ae9c CR3: 000000003bff7000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x21e/0x390 mm/mempolicy.c:2486
 ___kmalloc_large_node+0x4f/0x120 mm/slub.c:5353
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5385
 __do_kmalloc_node mm/slub.c:5402 [inline]
 __kmalloc_noprof+0x3fb/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 setup_conf+0x28b/0xd30 drivers/md/raid10.c:3855
 raid10_run+0x1d2/0x16c0 drivers/md/raid10.c:3955
 md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
 do_md_run+0x35/0x720 drivers/md/md.c:6880
 md_ioctl+0x1e2b/0x2610 drivers/md/md.c:8515
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efcb939e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd8c37e488 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007efcb9625fa0 RCX: 00007efcb939e159
RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
RBP: 00007efcb943506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efcb9625fac R14: 00007efcb9625fa0 R15: 00007efcb9625fa0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
