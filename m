Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E2647C11A
	for <linux-raid@vger.kernel.org>; Thu, 15 Oct 2026 20:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094907; cv=none; b=pYcToYwgIoPM+3UGfVzvV4L3SKYj14PJ77RaCjm0dG8LrsYEdGulehnZTflFNt1Yoq5h6DzOzW/ezTRIGiqACZDJgsmq/hdpnSoAf37+Ue+LFn6OlwF2qtCqyQHlQslohA4QrFOWyXLQqlgYyI6EW0r1/2xJjgDE7SPCjt9BuLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094907; c=relaxed/simple;
	bh=ED1gm+c2yjRgo3ZjglC07WWj28Qok/A2UygBtfgJDUk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GLxRvFluA2z3EfvCHbVEfXTdh33hGkHBCn968e4+u6gJYsCDZvudOaxZ0EB9jMcjzLzsKAvvaLs4SQGs5+ADoux24WZAzckpWpgnQkbcl3LgtV1keNubaqwpQzABZGYzsSNlz1x25rRIeFYLSqqxTZUIvRsDBHa1XYhA3iOLU+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4e937c5bd4fso6357485b6e.2
        for <linux-raid@vger.kernel.org>; Thu, 15 Oct 2026 13:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094904; x=1792699704;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qm71JmZWxtpXYyHUlS66VKW1M7sAeUMO5tdhCY0EqIg=;
        b=Gewmo1QUF8ZkmLsY17iKgl48zzUbVrjoBdWsSW+rmaUvrRUu0ZwRUZEhYPq2alLaLU
         2MNyAPezxK9Gr7F4VjmGaFOyyXedz505jutYgWwe8Rh0fN5QJm3n0DwEGNXHnRMbw1KN
         ub3ExiafodhKgSIJ+vKTlZU6fflGw4WwgxGHHegE9WJbIS06C+4CjI9rTc/PjTZnhFZ9
         /Mnx9Ly4fCGhFS+DIVCfWZNP8GdcOHBJuEJwX5W+ozCB4FXtMG+VDZuW6NvamPaHAQSc
         r9bUFlt0DJ6mWSYF0kxJsHpP40gQf7Vq+CTb+N1Ogp2mQO3jm4xp6rX9QeA9QD/OPGh4
         rYAQ==
X-Forwarded-Encrypted: i=1; AKwUvBw5UWN6T/4Fq9MQeRktawFRpW6xfhIIUjO1U9n3j19vJ2sl+Tycl60cG7I1M7lUXVCnM3TzVvSOo8wq@vger.kernel.org
X-Gm-Message-State: AFq9FYJe3FdtRvoS0W6rHptbN+6/bf/Nv17qDG9vUowar8eNqm9pIXxr
	zNUr1pWfdNcI68sglY/hBBivfmuqr0OF0I4pPgsJLOGMNT3yseJPkC5jp+jeMLy/19plVjfWOr7
	wlfkLVlxF4pn9UjgFZbmRdai/5gZVP8itDbmNB+OOYfbZCPK0y0bjmlLtpPU=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:10c7:b0:4f1:5068:b95a with SMTP id
 5614622812f47-50c4ed40b02mr19529086b6e.23.1792094903787; Thu, 15 Oct 2026
 13:08:23 -0700 (PDT)
Date: Thu, 15 Oct 2026 13:08:23 -0700
In-Reply-To: <6a14aff8.050a0220.2385e8.0019.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad132b7.7952420f.283480.00dc.GAE@google.com>
Subject: Re: [syzbot] [raid?] [block?] possible deadlock in blk_request_module (2)
From: syzbot <syzbot+fb0ff9bfe34ad282ebd4@syzkaller.appspotmail.com>
To: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    b810335a0699 Add linux-next specific files for 20261015
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1605ffd1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1b8bbfb3c8b8bab9
dashboard link: https://syzkaller.appspot.com/bug?extid=fb0ff9bfe34ad282ebd4
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1505ffd1580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fb0ff9bfe34ad282ebd4@syzkaller.appspotmail.com

md/raid1:md125: active with 1 out of 1 mirrors
md125: detected capacity change from 0 to 8192
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor123/5954 is trying to acquire lock:
ffffffff90960c40 (major_names_lock){+.+.}-{4:4}, at: blk_probe_dev block/genhd.c:885 [inline]
ffffffff90960c40 (major_names_lock){+.+.}-{4:4}, at: blk_request_module+0x35/0x2a0 block/genhd.c:901

but task is already holding lock:
ffff8880236d8358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_lock drivers/md/md.h:713 [inline]
ffff8880236d8358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_suspend_and_lock+0x48/0xf0 drivers/md/md.h:1019

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&mddev->reconfig_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       mddev_lock_nointr drivers/md/md.h:734 [inline]
       md_start_sync+0x179/0x1010 drivers/md/md.c:10275
       process_one_work kernel/workqueue.c:3495 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}:
       process_one_work kernel/workqueue.c:3471 [inline]
       process_scheduled_works+0xc03/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 ((wq_completion)md_misc){+.+.}-{0:0}:
       touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:4272
       __flush_workqueue+0x148/0x10b0 kernel/workqueue.c:4314
       md_alloc+0x32/0xf20 drivers/md/md.c:6334
       md_alloc_and_put+0x1a/0x1f0 drivers/md/md.c:6423
       blk_probe_dev block/genhd.c:888 [inline]
       blk_request_module+0x27d/0x2a0 block/genhd.c:-1
       blkdev_get_no_open+0x3f/0xe0 block/bdev.c:870
       blkdev_open+0x1d7/0x600 block/fops.c:677
       do_dentry_open+0x80e/0x1360 fs/open.c:1000
       vfs_open_consume+0x4a/0x350 fs/open.c:1131
       do_open fs/namei.c:4892 [inline]
       path_openat+0x16fc/0x20f0 fs/namei.c:5057
       do_file_open+0x23e/0x4a0 fs/namei.c:5086
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1788 [inline]
       __se_sys_openat fs/open.c:1783 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1783
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (major_names_lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       blk_probe_dev block/genhd.c:885 [inline]
       blk_request_module+0x35/0x2a0 block/genhd.c:901
       blkdev_get_no_open+0x3f/0xe0 block/bdev.c:870
       bdev_file_open_by_dev+0xa0/0x240 block/bdev.c:1091
       md_import_device+0x2e9/0x650 drivers/md/md.c:3847
       md_add_new_disk+0x669/0x1850 drivers/md/md.c:7549
       md_ioctl+0x2005/0x2610 drivers/md/md.c:8499
       blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  major_names_lock --> (work_completion)(&mddev->sync_work) --> &mddev->reconfig_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&mddev->reconfig_mutex);
                               lock((work_completion)(&mddev->sync_work));
                               lock(&mddev->reconfig_mutex);
  lock(major_names_lock);

 *** DEADLOCK ***

locks held by syz-executor123/5954: 1, last CPU#0:
 #0: ffff8880236d8358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_lock drivers/md/md.h:713 [inline]
 #0: ffff8880236d8358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_suspend_and_lock+0x48/0xf0 drivers/md/md.h:1019

stack backtrace:
CPU: 0 UID: 0 PID: 5954 Comm: syz-executor123 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
 blk_probe_dev block/genhd.c:885 [inline]
 blk_request_module+0x35/0x2a0 block/genhd.c:901
 blkdev_get_no_open+0x3f/0xe0 block/bdev.c:870
 bdev_file_open_by_dev+0xa0/0x240 block/bdev.c:1091
 md_import_device+0x2e9/0x650 drivers/md/md.c:3847
 md_add_new_disk+0x669/0x1850 drivers/md/md.c:7549
 md_ioctl+0x2005/0x2610 drivers/md/md.c:8499
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4e137daefb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffea3973750 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f4e137daefb
RDX: 00007ffea39737d0 RSI: 0000000040140921 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
R13: 00007ffea3973830 R14: 00007f4e1385fcc0 R15: 0000000000000002
 </TASK>
md: could not open device unknown-block(0,0).
md: md_import_device returned -6


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
