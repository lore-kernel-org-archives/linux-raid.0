Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDC548641A;
	Tue, 22 Sep 2026 18:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102249; cv=none; b=PkDlx6kcM4V7Zw0Zx9C5fMekebKXJQiL2fTVMPTqm8mJ2ooly6ulJnyiep62PY7g9rt03CRxZv5GceNeSpCOOMIKk2BCyW8hy54VPe/rp1nFoqnASepyxZpoqjAn3y4o7uWaWYEO62IEGh0UeTgyN1RGsJ+eGWT5RPYgXGoZYbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102249; c=relaxed/simple;
	bh=7IXylYYC6NtBWuEo6ztvLpDOlLWUcaXehhTMZiJRh8A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UdCrevbDkVfnu0NRIC5ivusdl2pzis0gWbAKcuaNageeoWZ4uOswSK9SHKvic5MrPFf7Smf+iOtUEu5iUTiqmgArALuKPTtzuSW2PkjiI9l0q78UEhqgDEIIBA8+TIHdPz+9nZ8sWwQpwludYS2e6K9OQ1g0t+F2oq0OHoVoD6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sv0bq229; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sv0bq229"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8531F000FF;
	Tue, 22 Sep 2026 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790102247;
	bh=Mu0Q0Us5oqehuvN1MkgAhz++2hs8x498+OX/TvKYCac=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Sv0bq2298nj6nPGBCihQSrJ0oYpmkFOyU8RxLXjYLyR4MWXYdp5+9SXKP6oXeLg5X
	 4w9gJru9toJU7XoWCRQn9a9mh8l6m8j74t230LFHTNJ2VrTW7sQYwDoj5xpnUEjYbv
	 oU/Yf+ziI7SHrOng48chSTms77tGwE6O0hB57S+k=
Date: Tue, 22 Sep 2026 11:37:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-raid@vger.kernel.org, magiclinan@didiglobal.com,
 matthew.brost@intel.com, rakie.kim@sk.com, song@kernel.org,
 syzkaller-bugs@googlegroups.com, xiao@kernel.org,
 ying.huang@linux.alibaba.com, yukuai@fygo.io, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in setup_conf
Message-Id: <20260922113726.0436e8d4e9e04c79b632f086@linux-foundation.org>
In-Reply-To: <6ab28beb.a6af0033.177e91.0020.GAE@google.com>
References: <6a8cdbd6.dbb3a75c.7844.0013.GAE@google.com>
	<6ab28beb.a6af0033.177e91.0020.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


tl;dr: a raid issue.

more below:

On Tue, 22 Sep 2026 07:08:43 -0700 syzbot <syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f0100363d8c3 Merge tag 'xfs-fixes-7.3-rc5' of gitolite.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17971805580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
> dashboard link: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b20c5e580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10720c5e580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f0100363.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/18fb2734cddb/vmlinux-f0100363.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5737b586e7bc/bzImage-f0100363.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com
> 
> md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
> syz.0.17 uses obsolete (PF_INET,SOCK_PACKET)
> ------------[ cut here ]------------
> 1
> WARNING: mm/page_alloc.c:5340 at alloc_order_allowed mm/page_alloc.c:5340 [inline], CPU#0: syz.0.17/5462
> WARNING: mm/page_alloc.c:5340 at __alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397, CPU#0: syz.0.17/5462
> Modules linked in:
> CPU: 0 UID: 0 PID: 5462 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:alloc_order_allowed mm/page_alloc.c:5340 [inline]
> RIP: 0010:__alloc_frozen_pages_noprof+0x425/0x5a0 mm/page_alloc.c:5397

Here, core MM is warning that it was asked to allocate a crazy amount
of memory.  By drivers/md/raid10.c:setup_conf().

It's root-only so "don't do that" is a respectable response.  But
adding some sanity check into setup_conf() would make the fuzzer emails
go away so we can concentrate on real stuff.


> Code: 90 e9 76 fe ff ff 41 81 e6 3f ff ff ff 44 89 f1 41 83 e6 f7 a9 00 00 00 10 44 0f 44 f1 e9 45 fd ff ff c6 05 2c 98 38 0e 01 90 <0f> 0b 90 e9 8b fe ff ff 48 8d 3d ac 09 54 0e 67 48 0f b9 3a e9 68
> RSP: 0018:ffffc90003b87520 EFLAGS: 00010246
> RAX: ffffc90003b87500 RBX: 1ffff92000770ea8 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 000000000000000e RDI: ffffc90003b87588
> RBP: ffffc90003b87618 R08: ffffc90003b87587 R09: 0000000000000000
> R10: ffffc90003b87560 R11: fffff52000770eb1 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000040dc0 R15: 0000000000000000
> FS:  00005555836a7500(0000) GS:ffff88808c2c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4a2c07ae9c CR3: 000000003bff7000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x21e/0x390 mm/mempolicy.c:2486
>  ___kmalloc_large_node+0x4f/0x120 mm/slub.c:5353
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5385
>  __do_kmalloc_node mm/slub.c:5402 [inline]
>  __kmalloc_noprof+0x3fb/0x720 mm/slub.c:5439
>  _kmalloc_noprof include/linux/slab.h:995 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  setup_conf+0x28b/0xd30 drivers/md/raid10.c:3855
>  raid10_run+0x1d2/0x16c0 drivers/md/raid10.c:3955
>  md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
>  do_md_run+0x35/0x720 drivers/md/md.c:6880
>  md_ioctl+0x1e2b/0x2610 drivers/md/md.c:8515
>  blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7efcb939e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd8c37e488 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007efcb9625fa0 RCX: 00007efcb939e159
> RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
> RBP: 00007efcb943506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007efcb9625fac R14: 00007efcb9625fa0 R15: 00007efcb9625fa0
>  </TASK>
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
