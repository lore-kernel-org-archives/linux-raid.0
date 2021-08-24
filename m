Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5526CC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 18:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3731B61212
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 18:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhHXSUG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 14:20:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:48855 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbhHXSUF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Aug 2021 14:20:05 -0400
Received: by mail-io1-f70.google.com with SMTP id d12-20020a6b680c000000b005b86e36a1f4so12817978ioc.15
        for <linux-raid@vger.kernel.org>; Tue, 24 Aug 2021 11:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hgW0R3Cqypzh/PaKnkXmkgTVIsdRWlaPqbcdFnM1yf4=;
        b=cgFgF6kW9ZAO8fVff6Cqx3W2xb8RgjwMnxs8Ied2qJNyQhwwfD4um0LSkbOMnKDU/r
         eRsGe7oeo7Dat4f0KXzp4ZBADFDooDD4ZG81HlGZ12n9ssOQwLZ06iEBRCVPaJPdB8E3
         Xf+bix0cp7GVt9fD2fuwJlc2t44Dz78MA8AHDMKxHVZ7C+VxowkAPDvGwlpD2BxMNn+p
         J9A6T6XkRsWxnF6YXweRy2CCTInURjMfaD9IIQ/HJYgj6duA0dVVJidbhJAP7kVk6l1i
         yDoibAzzcSX/SSsr8imyLTa1+gUWsAx+XW5RWLwbdgYPp0GLluxjy5PCxQ4xx6vSwSrx
         cOEQ==
X-Gm-Message-State: AOAM530/sr0+XVdJCg8TBuXbqfANyfwAgzXjeIl/Mfb7ctQCLpEqwZu6
        qoXPQQ+KA5gkSKIcbr19CnO9cukX0If0rh72EcV5IAEID5j6
X-Google-Smtp-Source: ABdhPJwEaTZEC/DTrCc5eemqt08KwYR9CjP3i4ycabjWdTeMxIiZUgASqsLlkpoBDLHwmm/1fGD6AXEdFEowjijLkqsY8VSeTM8R
MIME-Version: 1.0
X-Received: by 2002:a5e:a813:: with SMTP id c19mr32512644ioa.199.1629829161333;
 Tue, 24 Aug 2021 11:19:21 -0700 (PDT)
Date:   Tue, 24 Aug 2021 11:19:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034b9ee05ca522caa@google.com>
Subject: [syzbot] possible deadlock in md_open
From:   syzbot <syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        song@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    372b2891c15a Add linux-next specific files for 20210824
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=124dca75300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18ce42745c8b0dd6
dashboard link: https://syzkaller.appspot.com/bug?extid=fadc0aaf497e6a493b9f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b10d05300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13fa60fe300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc7-next-20210824-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor325/6558 is trying to acquire lock:
ffff888013f90230 (&mddev->open_mutex){+.+.}-{3:3}, at: md_open+0xfd/0x2e0 drivers/md/md.c:7815

but task is already holding lock:
ffff888077ce3118 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev.part.0+0x9b/0xb60 fs/block_dev.c:1227

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&disk->open_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       bd_register_pending_holders+0x2c/0x470 block/holder.c:160
       device_add_disk+0x75e/0xfd0 block/genhd.c:505
       add_disk include/linux/genhd.h:221 [inline]
       md_alloc+0x91d/0x1150 drivers/md/md.c:5707
       md_probe+0x69/0x70 drivers/md/md.c:5738
       blk_request_module+0x111/0x1d0 block/genhd.c:667
       blkdev_get_no_open+0x178/0x1e0 fs/block_dev.c:1150
       blkdev_get_by_dev.part.0+0x22/0xb60 fs/block_dev.c:1214
       blkdev_get_by_dev+0x6b/0x80 fs/block_dev.c:1267
       swsusp_check+0x4d/0x270 kernel/power/swap.c:1525
       software_resume.part.0+0x102/0x1f0 kernel/power/hibernate.c:977
       software_resume kernel/power/hibernate.c:86 [inline]
       resume_store+0x161/0x190 kernel/power/hibernate.c:1179
       kobj_attr_store+0x50/0x80 lib/kobject.c:856
       sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
       kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
       call_write_iter include/linux/fs.h:2163 [inline]
       new_sync_write+0x429/0x660 fs/read_write.c:511
       vfs_write+0x7cf/0xae0 fs/read_write.c:598
       ksys_write+0x12d/0x250 fs/read_write.c:651
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&mddev->open_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       md_open+0xfd/0x2e0 drivers/md/md.c:7815
       blkdev_get_whole+0x99/0x2a0 fs/block_dev.c:1079
       blkdev_get_by_dev.part.0+0x354/0xb60 fs/block_dev.c:1234
       blkdev_get_by_dev+0x6b/0x80 fs/block_dev.c:1267
       swsusp_check+0x4d/0x270 kernel/power/swap.c:1525
       software_resume.part.0+0x102/0x1f0 kernel/power/hibernate.c:977
       software_resume kernel/power/hibernate.c:86 [inline]
       resume_store+0x161/0x190 kernel/power/hibernate.c:1179
       kobj_attr_store+0x50/0x80 lib/kobject.c:856
       sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
       kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
       call_write_iter include/linux/fs.h:2163 [inline]
       new_sync_write+0x429/0x660 fs/read_write.c:511
       vfs_write+0x7cf/0xae0 fs/read_write.c:598
       ksys_write+0x12d/0x250 fs/read_write.c:651
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&disk->open_mutex);
                               lock(&mddev->open_mutex);
                               lock(&disk->open_mutex);
  lock(&mddev->open_mutex);

 *** DEADLOCK ***

5 locks held by syz-executor325/6558:
 #0: ffff88807f6bc460 (sb_writers#6){.+.+}-{0:0}, at: ksys_write+0x12d/0x250 fs/read_write.c:651
 #1: ffff88801a6a3488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x287/0x500 fs/kernfs/file.c:287
 #2: ffff8881441a6830 (kn->active#90){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x2ab/0x500 fs/kernfs/file.c:288
 #3: ffffffff8b84fc68 (system_transition_mutex/1){+.+.}-{3:3}, at: software_resume.part.0+0x19/0x1f0 kernel/power/hibernate.c:932
 #4: ffff888077ce3118 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev.part.0+0x9b/0xb60 fs/block_dev.c:1227

stack backtrace:
CPU: 1 PID: 6558 Comm: syz-executor325 Not tainted 5.14.0-rc7-next-20210824-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __mutex_lock_common kernel/locking/mutex.c:596 [inline]
 __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
 md_open+0xfd/0x2e0 drivers/md/md.c:7815
 blkdev_get_whole+0x99/0x2a0 fs/block_dev.c:1079
 blkdev_get_by_dev.part.0+0x354/0xb60 fs/block_dev.c:1234
 blkdev_get_by_dev+0x6b/0x80 fs/block_dev.c:1267
 swsusp_check+0x4d/0x270 kernel/power/swap.c:1525
 software_resume.part.0+0x102/0x1f0 kernel/power/hibernate.c:977
 software_resume kernel/power/hibernate.c:86 [inline]
 resume_store+0x161/0x190 kernel/power/hibernate.c:1179
 kobj_attr_store+0x50/0x80 lib/kobject.c:856
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:511
 vfs_write+0x7cf/0xae0 fs/read_write.c:598
 ksys_write+0x12d/0x250 fs/read_write.c:651
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f0e9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd59408358 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f0e9
RDX: 000000000000fdef RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000402e40 R08: 0000000000000012 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ed0
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
