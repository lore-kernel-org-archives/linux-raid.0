Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC211F2BAD
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 00:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785628837; cv=none; b=GakwID2o6MYDzJpI9RAZ8+qa7ILJ1FGmtk2xB/LfWQR1m3ifcf3BGB3GoHI8YnRNTwzk8glABN4RiMlp8lR9p9WIBeD7a4uO1VqMih+EBU1CHk9L1xO60EjS00vbJV2bWSPOnx5Ge+9LgBMzRe+flDMzHP3mux5zldExmPqVpRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785628837; c=relaxed/simple;
	bh=p3Z4PJiwvUXBFqf8CyA5iVzjt9/RmlwCj0Vm8QaeOhI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YcJuO1a8E9HXFzlNAT5PLKi7H/mYVaaeahCZn3zeRdfd1hIHV1xB21igpyiqQ9FSOv0Fn+WLyKlnZ5U6W8TiITwdxMTAYgLAlMzMyqAydNlsed7SY1X88ckWOIH1Mokf+7/g67rNz0Av1+UtQetzycyZZf3NJ0uri+F4mSuF7UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-451d8064053so2650119fac.0
        for <linux-raid@vger.kernel.org>; Sat, 01 Aug 2026 17:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785628834; x=1786233634;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zF40FeZFk2uPw9k3CmvQmbceM5lii+y6NfaeBS5L3iQ=;
        b=hvfx+kpb9z7RfUjgxdwC3D76Hxsb67YO+x3pX92PIPKYlDXzFY+Oi+Tb523J522eiB
         O/Z9u+UX0iR6iY27BQxTMK4hpatL2zA+/evaT3bwrRWZ2ZieWfN8GxskkZsECJMCv/Bi
         DaLBC8N6gBSyxkEztg+s/i5+bSuPIiZNVtFb/UmS1GGmnBF4ypSbomf8ylsgi0DvK0HW
         t6NXQ97KU8sq7GZKxsNhm5uj8umM0m73WeH3LZ3CWPidLsnEfXW7vsmvgCW7f1E/Ik+L
         7ousJR1uTKY7hWkVtM6PALT76sSQJkhno/ELPG0xmbfAdIgIrjBGa/XgFeuV/YyhY56Z
         4efg==
X-Forwarded-Encrypted: i=1; AHgh+RprlNf7SbJsrT8CFdDKepwDN5VNnKq3R1p95FMRsYXGaZqx2BQcGbLd9qw/d11GqLOoOQdsJf2QzjMq@vger.kernel.org
X-Gm-Message-State: AOJu0YxUa0/ehqUdYUe5Zt1R+DEOB7yCubkBNrHcyufrkTdFTQWr4HFG
	9OgAds0FJmE37LMSEILhAJnvKY+88ptZG5ecGD7q0XAMJn+6Y/uTV2JKOrANXl3KSov2I1n07kW
	YaqX12zmxVI/SnbN090aeQAlaQHh+uv0qBREsJigHZhyZkAYm4ZLGN06q7no=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:15a8:b0:4a3:eece:cbb with SMTP id
 5614622812f47-4af5e46568amr9818028b6e.21.1785628833988; Sat, 01 Aug 2026
 17:00:33 -0700 (PDT)
Date: Sat, 01 Aug 2026 17:00:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6e88a1.13bfb6d0.1ecdd5.0261.GAE@google.com>
Subject: [syzbot] [raid?] possible deadlock in md_start_sync
From: syzbot <syzbot+13eb8132f7693fe21d7d@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    62cc90241548 Merge tag 'mm-hotfixes-stable-2026-07-27-14-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1297e449580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7079b368dcec295
dashboard link: https://syzkaller.appspot.com/bug?extid=13eb8132f7693fe21d7d
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1d08b858b4e9/disk-62cc9024.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/85154cc68abb/vmlinux-62cc9024.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c7121b8e9e61/bzImage-62cc9024.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13eb8132f7693fe21d7d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
kworker/0:7/5865 is trying to acquire lock:
ffff88805a656358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_lock_nointr drivers/md/md.h:735 [inline]
ffff88805a656358 (&mddev->reconfig_mutex){+.+.}-{4:4}, at: md_start_sync+0x79/0xbe0 drivers/md/md.c:10190

but task is already holding lock:
ffffc900044bfd08 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_one_work+0x988/0x1940 kernel/workqueue.c:3298

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       process_one_work+0x98e/0x1940 kernel/workqueue.c:3298
       process_scheduled_works kernel/workqueue.c:3405 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
       kthread+0x370/0x450 kernel/kthread.c:436
       ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 ((wq_completion)md_misc){+.+.}-{0:0}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       touch_wq_lockdep_map+0xad/0x1c0 kernel/workqueue.c:4037
       __flush_workqueue+0x131/0x1200 kernel/workqueue.c:4079
       md_alloc+0x30/0x10a0 drivers/md/md.c:6313
       md_alloc_and_put drivers/md/md.c:6402 [inline]
       md_probe drivers/md/md.c:6418 [inline]
       md_probe+0x73/0xf0 drivers/md/md.c:6413
       blk_probe_dev+0x149/0x1e0 block/genhd.c:880
       blk_request_module+0x16/0xc0 block/genhd.c:893
       blkdev_get_no_open+0x9b/0xf0 block/bdev.c:828
       blkdev_open+0x141/0x4f0 block/fops.c:663
       do_dentry_open+0x6ab/0x14d0 fs/open.c:947
       vfs_open+0x82/0x3f0 fs/open.c:1052
       do_open fs/namei.c:4700 [inline]
       path_openat+0x2873/0x4280 fs/namei.c:4863
       do_file_open+0x20e/0x430 fs/namei.c:4892
       do_sys_openat2+0x10f/0x1e0 fs/open.c:1368
       do_sys_open fs/open.c:1374 [inline]
       __do_sys_openat fs/open.c:1390 [inline]
       __se_sys_openat fs/open.c:1385 [inline]
       __x64_sys_openat+0x12d/0x210 fs/open.c:1385
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (major_names_lock){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       blk_probe_dev+0x28/0x1e0 block/genhd.c:877
       blk_request_module+0x16/0xc0 block/genhd.c:893
       blkdev_get_no_open+0x9b/0xf0 block/bdev.c:828
       bdev_file_open_by_dev block/bdev.c:1049 [inline]
       bdev_file_open_by_dev+0x70/0x210 block/bdev.c:1037
       md_import_device+0x120/0x360 drivers/md/md.c:3845
       md_add_new_disk+0xdbf/0x1820 drivers/md/md.c:7637
       md_ioctl+0x2b28/0x36b0 drivers/md/md.c:8476
       blkdev_ioctl+0x5ad/0x6f0 block/ioctl.c:797
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&mddev->reconfig_mutex){+.+.}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       mddev_lock_nointr drivers/md/md.h:735 [inline]
       md_start_sync+0x79/0xbe0 drivers/md/md.c:10190
       process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
       process_scheduled_works kernel/workqueue.c:3405 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
       kthread+0x370/0x450 kernel/kthread.c:436
       ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
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

2 locks held by kworker/0:7/5865:
 #0: ffff888020ee8d40 ((wq_completion)md_misc){+.+.}-{0:0}, at: process_one_work+0x12b1/0x1940 kernel/workqueue.c:3297
 #1: ffffc900044bfd08 ((work_completion)(&mddev->sync_work)){+.+.}-{0:0}, at: process_one_work+0x988/0x1940 kernel/workqueue.c:3298

stack backtrace:
CPU: 0 UID: 0 PID: 5865 Comm: kworker/0:7 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Workqueue: md_misc md_start_sync
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
 mddev_lock_nointr drivers/md/md.h:735 [inline]
 md_start_sync+0x79/0xbe0 drivers/md/md.c:10190
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
