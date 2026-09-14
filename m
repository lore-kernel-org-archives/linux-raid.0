Received: from mail-oi2-f11.google.com (mail-oi2-f11.google.com [74.125.231.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2EF412BF6
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 21:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789420904; cv=none; b=TFVfeczcu0CCY5yOjQ7piTir9PtkPaIXV1p1VVCGP0kxKQEmi4wZ4jDX09mX/2t8s8jycMg0IVQGdALQJUBgfiAlqgLmN/e7fTiLeAb8MBC0Nan/nLBEo5saDHpIGjipIYZg+seMizeSl/uML/Tahtb77pmOMV/SziCwUFJXaI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789420904; c=relaxed/simple;
	bh=7AipFZiuIX6H9VaRrR5s6pZahTpna7iGdA2XXv+rnLI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GQtf40Dg+v4qyX2s6edVBB9w1LkSLSCfYgmG6ydkoOoZz4r/kQNamb+ENTQAGaqOb0NaTf+kDe6nr+llb6AzwA0uBlIqg8zRMDyfKznKP6wtzRBXbt1unXmwAW/EqaG7WamZp0InygUnuU+H9KN/mkAr3AYUXiJidVACeFN6jrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f11.google.com with SMTP id 5614622812f47-4bfec71901fso1428120b6e.1
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 14:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789420902; x=1790025702;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9VeItKbl45Jm7bqObM1L7eopLnqU0YHTMZpvnbTuOzc=;
        b=eK7iGsC84g32g50suL6+eSLsNKQnHrpV/lzcIpWYNW5Icp/QzyrhnJzyk5QvwMcPC8
         5+UyCVE5zotkX/HysusWDaBPzmVF88LiA2bRurbIkyE33qD2nLLDbh2w2A4i1I+3pRyl
         imiUAzRnCa3qaGwsuhKry/suZezfyP8iyNoEA38L3aOzs/KQIPenYMH6lY1VisKTavoe
         EBZ5hH7s13kFDHxrz/Sl95fO5Y+XwwuV8h3kTOKSWl0GxKTArpS8odJ4/LhZfv/sXnlJ
         /g6hex6iNFxU/Ba92lVvdWYzlSXWKyFU4cerslJKGHS9vXfL6UO4biNmDJYZ0nIDYIT1
         G2AA==
X-Forwarded-Encrypted: i=1; AKwUvBwQJjcfgzM64NDCdPZWB7haeX2raXBFLJh8xf81FYJ7quyxS5SPz4i6hBJr/rW1fLonqrSD8u+kDSvR@vger.kernel.org
X-Gm-Message-State: AFuF++lCB14GXM0Rc6egepLhDr+jopBN/vCHAFFInokHV5KaWS3LWQne
	i1X+h7UwkpADC5OJh3wnpi1U8LRc0KE5BGIetyLkN4fbDAofpNAeEP5Hr2uqorBpRZi1rC8NCCY
	6qV0y4gRj/nWH99s3DHZwGPUN91rHr41KQF1fPU+ZBu/6AMI1+v+d3tG3PQA=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1988:b0:6b1:b31f:132e with SMTP id
 006d021491bc7-6c540088804mr2643760eaf.6.1789420901903; Mon, 14 Sep 2026
 14:21:41 -0700 (PDT)
Date: Mon, 14 Sep 2026 14:21:41 -0700
In-Reply-To: <6a6e88a1.13bfb6d0.1ecdd5.0261.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa86565.f670cee1.72fc4.0021.GAE@google.com>
Subject: Re: [syzbot] [kernel?] possible deadlock in md_start_sync
From: syzbot <syzbot+13eb8132f7693fe21d7d@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, mingo@redhat.com, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org, x86@kernel.org, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    704340f1cd0d Merge tag 'x86_urgent_for_7.3-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14051925580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=13eb8132f7693fe21d7d
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a5bdf9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/192c594c6096/disk-704340f1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/79d1488deb4b/vmlinux-704340f1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fd108c2b8ca0/bzImage-704340f1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13eb8132f7693fe21d7d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kworker/0:0/9 is trying to acquire lock:
ffff888026076358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_lock_nointr drivers/md/md.h:734 [inline]
ffff888026076358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: md_start_sync+0xc4/0xea0 drivers/md/md.c:10275

but task is already holding lock:
ffffc900000e7d08 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_one_work+0xa2c/0x1b10 kernel/workqueue.c:3372

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       process_one_work+0xa32/0x1b10 kernel/workqueue.c:3372
       process_scheduled_works kernel/workqueue.c:3479 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
       kthread+0x373/0x450 kernel/kthread.c:436
       ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 ((wq_completion)md_misc){+.+.}-{0:0}:
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

-> #1 (major_names_lock){+.+.}-{4:4}:
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

-> #0 (&mddev->reconfig_mutex){+.+.}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
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

locks held by kworker/0:0/9: 2, last CPU#0:
 #0: ffff88801fadf140 ((wq_completion)md_misc){+.+.}-{0:0}, at: process_one_work+0x1466/0x1b10 kernel/workqueue.c:3371
 #1: ffffc900000e7d08 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_one_work+0xa2c/0x1b10 kernel/workqueue.c:3372

stack backtrace:
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Workqueue: md_misc md_start_sync
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
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
