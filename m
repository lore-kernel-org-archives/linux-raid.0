Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DCA1D5CED
	for <linux-raid@vger.kernel.org>; Mon,  4 Aug 2025 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754324913; cv=none; b=Civ5G9L7CHgHb6v9nPK0sP4B8qqme30w6KtTHNAlszqbMKyMlPho23aF05FTLCJ8Pn2wQUzK/RWWCYFwbvDCALmHA6ufPsJL8KgVypT8DSF6fQ/zospF+y5xR8UEp0Exns7mLpFdLHrQgCtZcxPvkL3kx1/ILuot7Gl2ELFZfiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754324913; c=relaxed/simple;
	bh=bqUrQkX1+lLsk9vJJ/j9wJoBXsBggMGZpodKwZ2Sfwc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=muGtb3ZbC9g/U4SoRvVA5/JCB5Sz92x8z/5jb+XjDSZlEF729s72dqCNuEM1xxtrzP9AsZN0uGDaluPM79xZ5thoDD7oFQ+Mz96GoXeTh4Ne9Nd6qqBgWmETKQO2cCAbpC3klAGD5JJ/SKu4lBW3jVetHZXUDzuJFPp4S+/5em0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-87c13b0a7beso402593539f.1
        for <linux-raid@vger.kernel.org>; Mon, 04 Aug 2025 09:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754324911; x=1754929711;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/N8dsWnLrIdTjV8pp4G03KsPmUmFCpDXD/E9F4O7TeE=;
        b=gCrnvbmAZ30jWOffj5FzdwhAnc4/KuoCPlYkCH4ijFy5SvaSKNj2Dw91w+FarhxB6k
         WeKcJI/LweOPpCK0T+xZis0NOV0ANNc8C1KmlzH3itHJYsxi/xmBxrsGVFZFN+ZKsF/1
         n65sMu1QxAOLXSR9antUM/8c+Ta6lcDGElKJl8btNccCD2/2xzA6NZ55r7k222Jzuq1k
         hbzkl5dJeQ9mPzZfnKDTM92rBwHL9dHxot7DE2+BFLufQK2O0lDtCukjPoqvhQb7KxBn
         +LN5Asxdh74iWJdhuSd3FNiTfoGkkeLv88uwWpYsDMADyXs+mrtuL3cZSlirKAfzR8zy
         Goyw==
X-Forwarded-Encrypted: i=1; AJvYcCV0RBDI05CMcEhCLCNniFauYHZKUnoA+7hnFYAwg3ns0zWfWWCM1WFWKvaEHig3q4T3ESTzSQ05SSkP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3rLo8/VoUxcwmReOy7tY0Lb1G9vogFc3hB9Ee+WSwrKA5fU2d
	jnZynhr7PfEXAa09q1jJvvYBe1GNrjW2Taix9Xmi+xkaGSYXK3jCOrw78lNxHPRKa5fuJbtB8LR
	qCNwh0w2qnF6RUBGC6X9G+3fkdhWfOEsPAsHY1ZIGnFYQ638mcm8ifHpdRT0=
X-Google-Smtp-Source: AGHT+IGeNLJLgFud6/LGiHWw1plpg4GnmIcYPGZNMlDNkHs+oY/NT3HTBKAk/cX0ArB1DBS5uBRjRH1Si1+BRYsk9kjIQ1u1JOcI
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c0e:b0:879:66fe:8d1e with SMTP id
 ca18e2360f4ac-88168352f76mr1682656739f.8.1754324911486; Mon, 04 Aug 2025
 09:28:31 -0700 (PDT)
Date: Mon, 04 Aug 2025 09:28:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6890dfaf.050a0220.7f033.000c.GAE@google.com>
Subject: [syzbot] [raid?] WARNING: refcount bug in trace_suspend_resume
From: syzbot <syzbot+60bcc1e0853c7179dfc8@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    186f3edfdd41 Merge tag 'pinctrl-v6.17-1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=173f0042580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2830738f4a5181eb
dashboard link: https://syzkaller.appspot.com/bug?extid=60bcc1e0853c7179dfc8
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1748f834580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c8fcf0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-186f3edf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/85e73a28f18d/vmlinux-186f3edf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1cb9a6c732ea/zImage-186f3edf.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60bcc1e0853c7179dfc8@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3065 at lib/refcount.c:28 refcount_warn_saturate+0x13c/0x174 lib/refcount.c:28
refcount_t: underflow; use-after-free.
Modules linked in:
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 UID: 0 PID: 3065 Comm: kworker/0:3 Not tainted 6.16.0-syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
Workqueue: md_misc mddev_delayed_delete
Call trace: 
[<80201a24>] (dump_backtrace) from [<80201b20>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:257)
 r7:00000000 r6:8281f77c r5:00000000 r4:82260f18
[<80201b08>] (show_stack) from [<8021fbf4>] (__dump_stack lib/dump_stack.c:94 [inline])
[<80201b08>] (show_stack) from [<8021fbf4>] (dump_stack_lvl+0x54/0x7c lib/dump_stack.c:120)
[<8021fba0>] (dump_stack_lvl) from [<8021fc34>] (dump_stack+0x18/0x1c lib/dump_stack.c:129)
 r5:00000000 r4:82a77d18
[<8021fc1c>] (dump_stack) from [<80202624>] (vpanic+0x10c/0x360 kernel/panic.c:440)
[<80202518>] (vpanic) from [<802028ac>] (trace_suspend_resume+0x0/0xd8 kernel/panic.c:574)
 r7:808bb0e8
[<80202878>] (panic) from [<802548cc>] (check_panic_on_warn kernel/panic.c:333 [inline])
[<80202878>] (panic) from [<802548cc>] (get_taint+0x0/0x1c kernel/panic.c:328)
 r3:8280c684 r2:00000001 r1:822479f0 r0:8224f3b8
[<80254858>] (check_panic_on_warn) from [<80254a30>] (__warn+0x80/0x188 kernel/panic.c:845)
[<802549b0>] (__warn) from [<80254d20>] (warn_slowpath_fmt+0x1e8/0x1f4 kernel/panic.c:880)
 r8:00000009 r7:822b98e4 r6:ec1cde54 r5:848eec00 r4:00000000
[<80254b3c>] (warn_slowpath_fmt) from [<808bb0e8>] (refcount_warn_saturate+0x13c/0x174 lib/refcount.c:28)
 r10:83811e70 r9:8339f225 r8:848eec00 r7:dddced40 r6:8339f200 r5:84ccfa1c
 r4:84ccf850
[<808bafac>] (refcount_warn_saturate) from [<81a11768>] (__refcount_sub_and_test include/linux/refcount.h:400 [inline])
[<808bafac>] (refcount_warn_saturate) from [<81a11768>] (__refcount_dec_and_test include/linux/refcount.h:432 [inline])
[<808bafac>] (refcount_warn_saturate) from [<81a11768>] (refcount_dec_and_test include/linux/refcount.h:450 [inline])
[<808bafac>] (refcount_warn_saturate) from [<81a11768>] (kref_put include/linux/kref.h:64 [inline])
[<808bafac>] (refcount_warn_saturate) from [<81a11768>] (kobject_put+0x158/0x1f4 lib/kobject.c:737)
[<81a11610>] (kobject_put) from [<81169718>] (mddev_delayed_delete+0x14/0x18 drivers/md/md.c:5893)
 r7:dddced40 r6:8339f200 r5:84ccfa1c r4:84b39d00
[<81169704>] (mddev_delayed_delete) from [<8027a32c>] (process_one_work+0x1b4/0x4f4 kernel/workqueue.c:3236)
[<8027a178>] (process_one_work) from [<8027af74>] (process_scheduled_works kernel/workqueue.c:3319 [inline])
[<8027a178>] (process_one_work) from [<8027af74>] (worker_thread+0x1fc/0x3d8 kernel/workqueue.c:3400)
 r10:61c88647 r9:848eec00 r8:84b39d2c r7:82804d40 r6:dddced40 r5:dddced60
 r4:84b39d00
[<8027ad78>] (worker_thread) from [<80281f5c>] (kthread+0x12c/0x280 kernel/kthread.c:464)
 r10:00000000 r9:84b39d00 r8:8027ad78 r7:df83de60 r6:84ae1980 r5:848eec00
 r4:00000001
[<80281e30>] (kthread) from [<80200114>] (ret_from_fork+0x14/0x20 arch/arm/kernel/entry-common.S:137)
Exception stack(0xec1cdfb0 to 0xec1cdff8)
dfa0:                                     00000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
 r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:80281e30
 r4:84b57fc0
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
