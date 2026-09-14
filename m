Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB9633993
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 23:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789426832; cv=none; b=gRFG++jkJNp6o+AOqacuvxpwmeFtmONHLal3HTAUwORKAJYcON3cE3Dhe1dSBQNt4SplvVU9Dztl7HDZrgiSwZkf0UDP2lVl1NltPUbACx9ues1TR8jiHL/erIggPjqeob2zMnDvdvDDU09Kw70gIDuljI3FOX8r+3DR3urmGRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789426832; c=relaxed/simple;
	bh=Uvda3mpDZ+Q/k7LZ/3pQQ7KyTaZcRTOLWlF3hmPQjjE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=eNLX4Y0ubsSXZ9lPU2ywK0y/Bq58FFUBW6IGekJlpDU0lbXzNfOgoe8sNNqTMpnpy8HuL6gFhXBT11ESSCmug5yPFWNj7rlY4ypA7x9KxD39hkK8phlsOu3e//sygQuPJeHsHSD97nDlg/+G0Ubbs6oqZ88InbM89xO7VUANHdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6b352d9062fso5326279eaf.3
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 16:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789426829; x=1790031629;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=44Xx70pjFYQDKE7JTJq5Y/pRdejI1BJo8WjK0aWEuzw=;
        b=FFboYv6z5NHoeq2ClJKJAm/CZmCgF0enkXBAGbmgG88U2pJu93PXB8ovCJ4GaNQFAx
         IHWu6qzHMEhrwNM3pgCWxvn67U0HPlmzh3OO4OoP5esoiSO7eKAE+wmT8I2dKEnOww5Q
         z7fCnAxOuVec8LZxMwfZc0nPwp8AWRypgj+UIqbsrotkBtxVMexo1+2la/CEkkoiNR2X
         08+SDNTV5EXLN9/uSXOODrRQo3CLn1yPoxS4wgo6bxtLoRN8EkL4rLxe6pADjPWhav6g
         XOKzWNdAuHYSXmzDEgluPGGDfWzz6AswYw3scQQcELKppxn/s3z4F/dE6g1fholr5FaH
         +iAw==
X-Forwarded-Encrypted: i=1; AKwUvBx/H8Lo8OZzfLmpxPR0ihidAEVtRV316WqB7lYmoHhoLmxpeMxtR+d3oSJsDzznuu47UNEDJh4aVXoP@vger.kernel.org
X-Gm-Message-State: AFuF++mXPyo2H6rIhopGG1V7elV+s3ChL78+KGvFfYEKLRpgJmh5XDb5
	qxWcftN0fAqmqr4XwZrtMIhEO818aJBNTHJ7OuSIA4AqvWoRpV3UHH0n2PUq1lcZ/a6wDT/gRPM
	jP3BsuKAAsjgDIHIuKM7v7ztXjLcf1qukXmNyhwh0y0McNJQjbCTjAvqPuqE=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c02:b0:6be:46f4:2908 with SMTP id
 006d021491bc7-6c544dad007mr2996077eaf.55.1789426829545; Mon, 14 Sep 2026
 16:00:29 -0700 (PDT)
Date: Mon, 14 Sep 2026 16:00:29 -0700
In-Reply-To: <6a6d3cbd.6ce73036.24301b.000d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa87c8d.4c28b7d0.c1bba.0020.GAE@google.com>
Subject: Re: [syzbot] [raid?] possible deadlock in blk_probe_dev
From: syzbot <syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com>
To: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    704340f1cd0d Merge tag 'x86_urgent_for_7.3-rc4' of git://g..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12ff9905580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=68e1f51046d68329940f
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a0bc8e580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor197/4337 is trying to acquire lock:
ffff888023113d40 ((wq_completion)md_misc){+.+.}-{0:0}, at: touch_wq_lockdep_map+0x9c/0x1c0 kernel/workqueue.c:4111

but task is already holding lock:
ffffffff8f9b98e0 (major_names_lock){+.+.}-{4:4}, at: blk_probe_dev+0x28/0x1e0 block/genhd.c:885

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (major_names_lock){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       blk_probe_dev+0x28/0x1e0 block/genhd.c:885
       blk_request_module+0x16/0xc0 block/genhd.c:901
       blkdev_get_no_open+0x9b/0xf0 block/bdev.c:870
       bdev_file_open_by_dev block/bdev.c:1091 [inline]
       bdev_file_open_by_dev+0x70/0x210 block/bdev.c:1079
       md_import_device+0x120/0x360 drivers/md/md.c:3847
       md_add_new_disk+0xdbf/0x1820 drivers/md/md.c:7656
       md_ioctl+0x2bec/0x36d0 drivers/md/md.c:8499
       blkdev_ioctl+0x5ad/0x6f0 block/ioctl.c:798
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&mddev->reconfig_mutex){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       mddev_lock_nointr drivers/md/md.h:734 [inline]
       md_start_sync+0xc4/0xea0 drivers/md/md.c:10275
       process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
       process_scheduled_works kernel/workqueue.c:3479 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
       kthread+0x373/0x450 kernel/kthread.c:436
       ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       process_one_work+0xa32/0x1b10 kernel/workqueue.c:3372
       process_scheduled_works kernel/workqueue.c:3479 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
       kthread+0x373/0x450 kernel/kthread.c:436
       ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 ((wq_completion)md_misc){+.+.}-{0:0}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       touch_wq_lockdep_map+0xad/0x1c0 kernel/workqueue.c:4111
       __flush_workqueue+0x131/0x1200 kernel/workqueue.c:4153
       md_alloc+0x30/0x10a0 drivers/md/md.c:6334
       md_alloc_and_put drivers/md/md.c:6423 [inline]
       md_probe drivers/md/md.c:6439 [inline]
       md_probe+0x73/0xf0 drivers/md/md.c:6434
       blk_probe_dev+0x149/0x1e0 block/genhd.c:888
       blk_request_module+0x16/0xc0 block/genhd.c:901
       blkdev_get_no_open+0x9b/0xf0 block/bdev.c:870
       blkdev_open+0x141/0x4f0 block/fops.c:665
       do_dentry_open+0x6ab/0x14d0 fs/open.c:996
       vfs_open+0x82/0x3f0 fs/open.c:1101
       do_open fs/namei.c:4837 [inline]
       path_openat+0x19fa/0x2440 fs/namei.c:5000
       do_file_open+0x20e/0x430 fs/namei.c:5029
       do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x12d/0x210 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  (wq_completion)md_misc --> &mddev->reconfig_mutex --> major_names_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(major_names_lock);
                               lock(&mddev->reconfig_mutex);
                               lock(major_names_lock);
  lock((wq_completion)md_misc);

 *** DEADLOCK ***

locks held by syz-executor197/4337: 1, last CPU#2:
 #0: ffffffff8f9b98e0 (major_names_lock){+.+.}-{4:4}, at: blk_probe_dev+0x28/0x1e0 block/genhd.c:885

stack backtrace:
CPU: 2 UID: 0 PID: 4337 Comm: syz-executor197 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1be kernel/locking/lockdep.c:2087
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2219
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
 lock_acquire kernel/locking/lockdep.c:5942 [inline]
 lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
 touch_wq_lockdep_map+0xad/0x1c0 kernel/workqueue.c:4111
 __flush_workqueue+0x131/0x1200 kernel/workqueue.c:4153
 md_alloc+0x30/0x10a0 drivers/md/md.c:6334
 md_alloc_and_put drivers/md/md.c:6423 [inline]
 md_probe drivers/md/md.c:6439 [inline]
 md_probe+0x73/0xf0 drivers/md/md.c:6434
 blk_probe_dev+0x149/0x1e0 block/genhd.c:888
 blk_request_module+0x16/0xc0 block/genhd.c:901
 blkdev_get_no_open+0x9b/0xf0 block/bdev.c:870
 blkdev_open+0x141/0x4f0 block/fops.c:665
 do_dentry_open+0x6ab/0x14d0 fs/open.c:996
 vfs_open+0x82/0x3f0 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x19fa/0x2440 fs/namei.c:5000
 do_file_open+0x20e/0x430 fs/namei.c:5029
 do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x12d/0x210 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc5b6fe4b37
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffd92e81700 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000055557809b400 RCX: 00007fc5b6fe4b37
RDX: 0000000000000002 RSI: 00007ffd92e81810 RDI: ffffffffffffff9c
RBP: 00007ffd92e81810 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000004
R13: 0000000000000005 R14: 00007fc5b7049ca0 R15: 0000000000000002
 </TASK>
md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
block device autoloading is deprecated and will be removed.
md: could not open device unknown-block(0,0).
md: md_import_device returned -6
md/raid1:md127: not clean -- starting background reconstruction
md/raid1:md127: active with 2 out of 2 mirrors
md127: detected capacity change from 0 to 20480
md127: detected capacity change from 20480 to 0
md: md127 stopped.


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
