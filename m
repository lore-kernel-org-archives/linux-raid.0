Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD1954EED4
	for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 16:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791994778; cv=none; b=A/Sv0H6prOBP7dmtgfo2lJhtnVf5vD6MtVmFRhuMacaox52QjHS9tUm0HEfhVoyfSLilEtscB4ySJbl2Z3N26i7Yf/OFVRWIbUOzIrcAs2JgYE9+A/TTWpAZ7ynCejbyIW4o5NAgJb7HnsQJkUi/m7WEP4Vr3q/S8tPx2kJtsJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791994778; c=relaxed/simple;
	bh=orUkk4GCp5EFHVnAmkbvBc1CnnBk7UmhzsNlrDdy0xQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ujpv8EHVaGW/X1IRM1g8Ur6rfUA1i3tcZxRT4M9trEa8u4ZDtIV89FVMkTTMutII72Xn09B56WfwqvbZ6TUWWuqqRMJ12SaQo2VNLVY1ocm/e4bATHJ4vCLy4OFn3to4AD4F3X3GmGpcc9dQkqNznm3W3C7KNLtoVPQsl4jm47w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-45952ce9ee0so5843898fac.1
        for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 09:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791994773; x=1792599573;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xXsYfHP7hwkUSYb50Vz8rNkytsVjYuskiuIUuuS/w8A=;
        b=M2Q4LUEFi1JWAUgo/y3E2LWqT8UsQunEfMg/xTE+MSHkTtH6q3VD8yuR2LRWpw5ysf
         o02FEEx+dpwIspitMLFTl9jzn4I3FezaLw9QOu0K6Fz4InncapiVxgN9qxIjOCQfrNs9
         Ojilvbyb1Xv+qYjIpugQWsn7jTNxu8jfHXQ8MprjOTdg9Wnf88xdksCwJj8tD69XXYIV
         XX4gd1DK+ZLUiF6SHtxDWImNJ5ilU0fxVu0xtDN++d6xE0lB4TkmAeap5R/O5vbli5KG
         tO6URw6a9inOI1RmnLsLyQKog6qp1lH5MdYf8Md/tQ5qiGmdvULlfM8ni3zXSXeOwnDs
         hb3g==
X-Forwarded-Encrypted: i=1; AKwUvBwtNuhylMgZ00bKhy6y/fkmAvQ1smskpsktayMgws4bpZXp8+44uTA0YBq8NNtp31IjmE3UzvbYgQ9m@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6Q/9kCOd8jdYj12V0nZXbfYp5NYkOyfX0L97ZOD5sSb4neYa3
	kz39/0X1o9k1ylLLZVIwdBYWfytwG/qNNqMYLny2SbMxPb8F5fiGmzAfHflsVcvXXSVdAF4qZNz
	+chsK8lRTRJVuth4ft0/KLWro5wPA7XyDoVTyzprDVf9Xn33sTyQzoj2r55o=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2211:b0:4f6:5279:5c6e with SMTP id
 5614622812f47-50c42170b8amr14110237b6e.8.1791994772986; Wed, 14 Oct 2026
 09:19:32 -0700 (PDT)
Date: Wed, 14 Oct 2026 09:19:32 -0700
In-Reply-To: <6a6e88a1.13bfb6d0.1ecdd5.0261.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acfab94.38256f13.2006af.0129.GAE@google.com>
Subject: Re: [syzbot] [kernel?] possible deadlock in md_start_sync
From: syzbot <syzbot+13eb8132f7693fe21d7d@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, mingo@redhat.com, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org, x86@kernel.org, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    4056b3c9d3c9 Merge tag 'nios2_update_for_v7.4' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15334e8e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d1b274ca9837366
dashboard link: https://syzkaller.appspot.com/bug?extid=13eb8132f7693fe21d7d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175a6999580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10da6999580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4056b3c9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/811a43c89106/vmlinux-4056b3c9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2bb4f3abea76/bzImage-4056b3c9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13eb8132f7693fe21d7d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kworker/0:5/5422 is trying to acquire lock:
ffff8880133d8358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_lock_nointr drivers/md/md.h:734 [inline]
ffff8880133d8358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: md_start_sync+0x179/0x1010 drivers/md/md.c:10275

but task is already holding lock:
ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}:
       process_one_work kernel/workqueue.c:3372 [inline]
       process_scheduled_works+0xc03/0x1630 kernel/workqueue.c:3479
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 ((wq_completion)md_misc){+.+.}-{0:0}:
       touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:4111
       __flush_workqueue+0x148/0x1470 kernel/workqueue.c:4153
       md_alloc+0x32/0xf20 drivers/md/md.c:6334
       md_alloc_and_put+0x1a/0x1f0 drivers/md/md.c:6423
       blk_probe_dev block/genhd.c:888 [inline]
       blk_request_module+0x27d/0x2a0 block/genhd.c:-1
       blkdev_get_no_open+0x3f/0xe0 block/bdev.c:870
       blkdev_open+0x1d7/0x600 block/fops.c:670
       do_dentry_open+0x816/0x1380 fs/open.c:996
       vfs_open+0x3b/0x340 fs/open.c:1101
       do_open fs/namei.c:4866 [inline]
       path_openat+0x1443/0x1d60 fs/namei.c:5029
       do_file_open+0x23e/0x4a0 fs/namei.c:5058
       do_sys_openat2+0x115/0x200 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (major_names_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       blk_probe_dev block/genhd.c:885 [inline]
       blk_request_module+0x35/0x2a0 block/genhd.c:901
       blkdev_get_no_open+0x3f/0xe0 block/bdev.c:870
       bdev_file_open_by_dev+0xa0/0x240 block/bdev.c:1091
       md_import_device+0x2e9/0x650 drivers/md/md.c:3847
       md_add_new_disk+0x280/0x1850 drivers/md/md.c:7546
       md_ioctl+0x200a/0x2610 drivers/md/md.c:8499
       blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&mddev->reconfig_mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       mddev_lock_nointr drivers/md/md.h:734 [inline]
       md_start_sync+0x179/0x1010 drivers/md/md.c:10275
       process_one_work kernel/workqueue.c:3396 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  &mddev->reconfig_mutex --> (wq_completion)md_misc --> (work_completion)(&mddev->sync_work)

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&mddev->sync_work));
                               lock((wq_completion)md_misc);
                               lock((work_completion)(&mddev->sync_work));
  lock(&mddev->reconfig_mutex);

 *** DEADLOCK ***

locks held by kworker/0:5/5422: 2, last CPU#0:
 #0: ffff888031699d40 ((wq_completion)md_misc){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff888031699d40 ((wq_completion)md_misc){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff888031699d40 ((wq_completion)md_misc){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff888031699d40 ((wq_completion)md_misc){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc9000293fc40 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479

stack backtrace:
CPU: 0 UID: 0 PID: 5422 Comm: kworker/0:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: md_misc md_start_sync
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
 __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
 mddev_lock_nointr drivers/md/md.h:734 [inline]
 md_start_sync+0x179/0x1010 drivers/md/md.c:10275
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
