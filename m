Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCA41B87C9;
	Tue, 25 Aug 2026 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787620927; cv=none; b=FlwQ3eYtNxeJ7I7mqidWS8TV1TavWAjCMI6r2rWleu4l3XvXbYRovdJwZa+GswGQpvtlzE+SNW0x03n8A42uXXiIREZnVwjk1GXcndmqNBooFPwRITdqBhe07eDBw9kLU8ABeNwfMPsEQN8lVnoKL8EEbZm7CLumVs1IH0MITR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787620927; c=relaxed/simple;
	bh=pEFnD+Gyi31IoiG8WB/lUKSvDDDtOtudT4ZPiLcQEZ4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=VMKeCJ1uZvm+7+9OSRJpQ98r7AvouqIek8ITkPgzAz6Uc5bEs3ZOpNeyqXqNG2Re0e4MRMgevrOLKjY3mG4dkR9ef0tBuRzAOwdhydBl8WGlE8SqqpD6ZpZQsd6SLPs+TIQVtUaRrOy9tYoDf4INE4MezPoM5pSLXJ2PmkqEluE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MsuVrxeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MsuVrxeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8611F000E9;
	Tue, 25 Aug 2026 01:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787620925;
	bh=dMf+k1qYoElhLjeGeyt6xhyjktXku4L4R9ADFGRmYsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MsuVrxeFVLYM73ColyjiKkUoy+ki29rSdaEx1WqTJHMdb/zwFuO48VaWGncnwEfpc
	 F63Lys22NC2ZrGRn1ItwS5tP/uRUg2P2IigZEMJ24tSvI+IFj4HuMifoyebue6J6wr
	 jxRs5hk6lMywbJib5Ra37MeZCxnECF1TKh5tFZiw=
Date: Mon, 24 Aug 2026 18:22:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, Li
 Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 linux-raid@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in setup_conf
Message-Id: <20260824182204.d73425f7abbf90cfeae1580c@linux-foundation.org>
In-Reply-To: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
References: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Aug 2026 17:03:34 -0700 syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9d2ed026f031 Merge tag 'sysctl-7.03-rc1' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1124919e580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6e414d6e0a79e71d
> dashboard link: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9d2ed026.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/89c0c0c0f535/vmlinux-9d2ed026.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/80d7adeb0e7d/bzImage-9d2ed026.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com

Thanks.  drivers/md/raid10.c lacks some sanity checking.

In setup_conf():

	/* FIXME calc properly */
	conf->mirrors = kzalloc_objs(struct raid10_info,
				     mddev->raid_disks + max(0, -mddev->delta_disks));

passed a crazy large number into kzalloc_objs(), causing
__alloc_frozen_pages_noprof() to hit

	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
		return NULL;


> tipc: Started in network mode
> tipc: Node identity 2007ff, cluster identity 4711
> tipc: Node number set to 2099199
> md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
> ------------[ cut here ]------------
> 1
> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5310
> Modules linked in:
> CPU: 0 UID: 0 PID: 5310 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
> Code: 74 10 4c 89 e7 89 54 24 0c e8 8e 2d 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 74 6e 18 0e 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> RSP: 0018:ffffc9000d50f520 EFLAGS: 00010246
> RAX: ffffc9000d50f500 RBX: 0000000000000015 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000d50f588
> RBP: ffffc9000d50f610 R08: ffffc9000d50f587 R09: 0000000000000000
> R10: ffffc9000d50f560 R11: fffff52001aa1eb1 R12: 0000000000000000
> R13: 1ffff92001aa1ea8 R14: 0000000000040dc0 R15: dffffc0000000000
> FS:  00007fe2b9aac6c0(0000) GS:ffff88808c519000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffc93d2c090 CR3: 0000000044100000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x212/0x390 mm/mempolicy.c:2490
>  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5274
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5305
>  __do_kmalloc_node mm/slub.c:5322 [inline]
>  __kmalloc_noprof+0x409/0x720 mm/slub.c:5359
>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>  _kzalloc_noprof include/linux/slab.h:1309 [inline]
>  setup_conf+0x28b/0xce0 drivers/md/raid10.c:3883
>  raid10_run+0x1d2/0x16c0 drivers/md/raid10.c:3984
>  md_run+0xdbd/0x1e00 drivers/md/md.c:6760
>  do_md_run+0x35/0x720 drivers/md/md.c:6861
>  md_ioctl+0x1c58/0x2580 drivers/md/md.c:8492
>  blkdev_ioctl+0x5e3/0x740 block/ioctl.c:797
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe2b8b9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe2b9aabfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fe2b8e25fa0 RCX: 00007fe2b8b9e0d9
> RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000009
> RBP: 00007fe2b8c35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe2b8e26038 R14: 00007fe2b8e25fa0 R15: 00007ffe1ca65d58
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
