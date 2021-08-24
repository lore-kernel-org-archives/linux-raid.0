Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A325FC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 23:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D2A610A4
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 23:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhHXXNb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 19:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhHXXNb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Aug 2021 19:13:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5116461374;
        Tue, 24 Aug 2021 23:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629846766;
        bh=7Bh+sFDzeU+YYFhokJ/WUtQHFBshoD+tJjVaU2U3u1E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PmM3L0e1PxFhEMQQRgnYYaucvydt4l6GDOYMmWrFilVQOLCi1hFmYGcO47L0Ca2Fo
         X5rs2LLRDziQPaSlIqucjF5rJz84QGncxdAny34ViUtN+ZyROLVdsd2nfsfzG6qg80
         xLIFPndxdJKe6Jw17XshdmVndjTj4zAw9IOb3ccLytaewk2wYkrw4u1z0QY9lLVdgf
         A2YaKINKq3xXD3GKeUpd1P8iVVz0CcyS0ZbDXg2DGNd4hgzBrOK2CeNbsUxcqAiy5M
         QZ5QWrjYDlXWQiwpyN4bPGDVLrz8MEQ/m8JMbXT+YCcjdWDwR0yX5oBuG7nhMKyuCe
         7PfY5OnSANH3w==
Received: by mail-lf1-f44.google.com with SMTP id y34so48834712lfa.8;
        Tue, 24 Aug 2021 16:12:46 -0700 (PDT)
X-Gm-Message-State: AOAM53185hyic2GM1Myua6RvMrE8DIhE4dFcX6fbt2rYbzeGh/QKTFN0
        cTcaqoyZ+QhsLAbAENfpV2n/DoYRW9ud3OMLP1I=
X-Google-Smtp-Source: ABdhPJw/EIb9ZuUuTKuUOAagwD9XrbLZ9Ww/06qmTDQb+nMQV0H1lTNmcJzO19Sn0O9RRMVJ4VZzbMNAal0Hh9C7qVs=
X-Received: by 2002:a05:6512:11e9:: with SMTP id p9mr30837256lfs.372.1629846764708;
 Tue, 24 Aug 2021 16:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000034b9ee05ca522caa@google.com>
In-Reply-To: <00000000000034b9ee05ca522caa@google.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 24 Aug 2021 16:12:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5TLGT-jBQM_SYpYyL=qMEwxuaBHNWPf4nqhk+U5161Ow@mail.gmail.com>
Message-ID: <CAPhsuW5TLGT-jBQM_SYpYyL=qMEwxuaBHNWPf4nqhk+U5161Ow@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in md_open
To:     syzbot <syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Christoph,

On Tue, Aug 24, 2021 at 11:19 AM syzbot
<syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    372b2891c15a Add linux-next specific files for 20210824
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=124dca75300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=18ce42745c8b0dd6
> dashboard link: https://syzkaller.appspot.com/bug?extid=fadc0aaf497e6a493b9f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b10d05300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13fa60fe300000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com
>
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.14.0-rc7-next-20210824-syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor325/6558 is trying to acquire lock:
> ffff888013f90230 (&mddev->open_mutex){+.+.}-{3:3}, at: md_open+0xfd/0x2e0 drivers/md/md.c:7815
>
> but task is already holding lock:
> ffff888077ce3118 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev.part.0+0x9b/0xb60 fs/block_dev.c:1227
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&disk->open_mutex){+.+.}-{3:3}:
>        __mutex_lock_common kernel/locking/mutex.c:596 [inline]
>        __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
>        bd_register_pending_holders+0x2c/0x470 block/holder.c:160

I looked into this and found the error was triggered by

d62633873590 ("block: support delayed holder registration")

But I am not quite sure how to fix it. Do you have some suggestions on
this?

Thanks,
Song

>        device_add_disk+0x75e/0xfd0 block/genhd.c:505
>        add_disk include/linux/genhd.h:221 [inline]
>        md_alloc+0x91d/0x1150 drivers/md/md.c:5707
>        md_probe+0x69/0x70 drivers/md/md.c:5738
>        blk_request_module+0x111/0x1d0 block/genhd.c:667
>        blkdev_get_no_open+0x178/0x1e0 fs/block_dev.c:1150
>        blkdev_get_by_dev.part.0+0x22/0xb60 fs/block_dev.c:1214
>        blkdev_get_by_dev+0x6b/0x80 fs/block_dev.c:1267
>        swsusp_check+0x4d/0x270 kernel/power/swap.c:1525
>        software_resume.part.0+0x102/0x1f0 kernel/power/hibernate.c:977
>        software_resume kernel/power/hibernate.c:86 [inline]
>        resume_store+0x161/0x190 kernel/power/hibernate.c:1179
>        kobj_attr_store+0x50/0x80 lib/kobject.c:856
>        sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
>        kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
>        call_write_iter include/linux/fs.h:2163 [inline]
>        new_sync_write+0x429/0x660 fs/read_write.c:511
>        vfs_write+0x7cf/0xae0 fs/read_write.c:598
>        ksys_write+0x12d/0x250 fs/read_write.c:651
>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>        do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> -> #0 (&mddev->open_mutex){+.+.}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3051 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3174 [inline]
>        validate_chain kernel/locking/lockdep.c:3789 [inline]
>        __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
>        lock_acquire kernel/locking/lockdep.c:5625 [inline]
>        lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>        __mutex_lock_common kernel/locking/mutex.c:596 [inline]
>        __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
>        md_open+0xfd/0x2e0 drivers/md/md.c:7815
>        blkdev_get_whole+0x99/0x2a0 fs/block_dev.c:1079
>        blkdev_get_by_dev.part.0+0x354/0xb60 fs/block_dev.c:1234
>        blkdev_get_by_dev+0x6b/0x80 fs/block_dev.c:1267
>        swsusp_check+0x4d/0x270 kernel/power/swap.c:1525
>        software_resume.part.0+0x102/0x1f0 kernel/power/hibernate.c:977
>        software_resume kernel/power/hibernate.c:86 [inline]
>        resume_store+0x161/0x190 kernel/power/hibernate.c:1179
>        kobj_attr_store+0x50/0x80 lib/kobject.c:856
>        sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
>        kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
>        call_write_iter include/linux/fs.h:2163 [inline]
>        new_sync_write+0x429/0x660 fs/read_write.c:511
>        vfs_write+0x7cf/0xae0 fs/read_write.c:598
>        ksys_write+0x12d/0x250 fs/read_write.c:651
>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>        do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&disk->open_mutex);
>                                lock(&mddev->open_mutex);
>                                lock(&disk->open_mutex);
>   lock(&mddev->open_mutex);
>
>  *** DEADLOCK ***
>
> 5 locks held by syz-executor325/6558:
>  #0: ffff88807f6bc460 (sb_writers#6){.+.+}-{0:0}, at: ksys_write+0x12d/0x250 fs/read_write.c:651
>  #1: ffff88801a6a3488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x287/0x500 fs/kernfs/file.c:287
>  #2: ffff8881441a6830 (kn->active#90){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2ab/0x500 fs/kernfs/file.c:288
>  #3: ffffffff8b84fc68 (system_transition_mutex/1){+.+.}-{3:3}, at: software_resume.part.0+0x19/0x1f0 kernel/power/hibernate.c:932
>  #4: ffff888077ce3118 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev.part.0+0x9b/0xb60 fs/block_dev.c:1227
>
> stack backtrace:
> CPU: 1 PID: 6558 Comm: syz-executor325 Not tainted 5.14.0-rc7-next-20210824-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
>  check_prev_add kernel/locking/lockdep.c:3051 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3174 [inline]
>  validate_chain kernel/locking/lockdep.c:3789 [inline]
>  __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
>  lock_acquire kernel/locking/lockdep.c:5625 [inline]
>  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>  __mutex_lock_common kernel/locking/mutex.c:596 [inline]
>  __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
>  md_open+0xfd/0x2e0 drivers/md/md.c:7815
>  blkdev_get_whole+0x99/0x2a0 fs/block_dev.c:1079
>  blkdev_get_by_dev.part.0+0x354/0xb60 fs/block_dev.c:1234
>  blkdev_get_by_dev+0x6b/0x80 fs/block_dev.c:1267
>  swsusp_check+0x4d/0x270 kernel/power/swap.c:1525
>  software_resume.part.0+0x102/0x1f0 kernel/power/hibernate.c:977
>  software_resume kernel/power/hibernate.c:86 [inline]
>  resume_store+0x161/0x190 kernel/power/hibernate.c:1179
>  kobj_attr_store+0x50/0x80 lib/kobject.c:856
>  sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
>  kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
>  call_write_iter include/linux/fs.h:2163 [inline]
>  new_sync_write+0x429/0x660 fs/read_write.c:511
>  vfs_write+0x7cf/0xae0 fs/read_write.c:598
>  ksys_write+0x12d/0x250 fs/read_write.c:651
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f0e9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd59408358 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f0e9
> RDX: 000000000000fdef RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 0000000000402e40 R08: 0000000000000012 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ed0
> R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
