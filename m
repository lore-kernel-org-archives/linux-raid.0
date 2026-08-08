Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BBA39B971
	for <linux-raid@vger.kernel.org>; Sat,  8 Aug 2026 20:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786219653; cv=none; b=WrGo3U6lbqau4pWcUX19R1dY7wD+APVLlpJAqWdmmOR89A8HJQhcUm4eF14gaLSDEEg7IMRmJl0MGxJVQCUZvByyfjG3F9j+4vtfdpYsLykP3WFac4yNDK+yhhiZnggpSGQT0BT+fjhfc/XAfEJ3WL8od2/Y8/UEw2ParZiiXvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786219653; c=relaxed/simple;
	bh=ds0DMpOHTX7r7r0hJ3SQaDUyY7WmKteGrHqB9nxzHXU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ArYE0ldBVaqdO6dLp8B/jb+4jfkvSI8y5sgsZx3R9ZIjKOn1dZc9/GrWbAkdFN7Mc40ulC5Ram2lG4gids5r4pZimkmX6rjf8Cg/Ut6l9JkapTA6FsYMDrBcsVEcvZoZYr9Zc/3fAARYB2IesUj/J7nW/LwstLQmdE8fcn+4kso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7eb6a8c61deso537060a34.3
        for <linux-raid@vger.kernel.org>; Sat, 08 Aug 2026 13:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786219651; x=1786824451;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0/JkjoGGyPJznaRyWwHiOVmef5C3xdrAklDlk0jAF8o=;
        b=SbXnoEeSwBpqEHnW6b3j5uBXdGXIxguwsHGfThZeZLD6dAjz3bVn7YyIIxqAPg8ik4
         7jRrSCYC+cY4phGrXY/sy6LToSu9BXtnnEwvfH/0SFFiORZvkBi4NsQCDoy9IHP19mTL
         LFaRldz/y6tWZNH2gORTbHnRwc+bWmGpJ6s2G2O10bUWA2et67JbIcQ4ejfJlRGcnlZ/
         blTXgXF0iArhYJMY0412gZpxoReNaFiYbTYKx8jKYgOcHlq/REuuU6PWH3agmvB/8MFR
         jSJH8cnwxZnPe1asI8Y5vhkGxLHKFowz54KnF3au5NoUjQslzucbFsofOn6GRKS7gh8J
         EJTA==
X-Forwarded-Encrypted: i=1; AHgh+RrKcDgNUO27u/SolH9hss3lcSxkJYVLTYfDwB74o0VyjHeXXcUrVVRbBtGuuzEsMP0FtkkR7XXYVGD2@vger.kernel.org
X-Gm-Message-State: AOJu0YxZnmibOCc21CvkFmJRZkWakc7vbHPOak4qJs/HY7j3GCx7Ut+x
	ur2F8MihMs6mmtEM7pF7NNQ7lPUyl2VSd+ADMLW6HlJnKHSVCE8ZEfbl8qH8dwKDP6v3F4ragbO
	TfwuCNWzt2JB2bjvwdeCyio1kFSDtcHCHbvxaQkL6UTuU2iaOt820ZBsUr2Y=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a0d:b0:4a3:fb6b:bcb8 with SMTP id
 5614622812f47-4b1ab96cf6dmr4594909b6e.10.1786219650800; Sat, 08 Aug 2026
 13:07:30 -0700 (PDT)
Date: Sat, 08 Aug 2026 13:07:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a778c82.01d0871a.3a0d52.006a.GAE@google.com>
Subject: [syzbot] [raid?] UBSAN: shift-out-of-bounds in raid5_set_limits
From: syzbot <syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7235a3e71949 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=169f0e49580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccf4bea59f67007
dashboard link: https://syzkaller.appspot.com/bug?extid=de94ddbfff0c9e6fe030
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143b0132580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114717b9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fd45635beaae/disk-7235a3e7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d7d2e6507223/vmlinux-7235a3e7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b5b5d8de4cea/Image-7235a3e7.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com

md/raid:md0: not clean -- starting background reconstruction
md/raid:md0: device ram0 operational as raid disk 0
md/raid:md0: raid level 5 active with 1 out of 1 devices, algorithm 0
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
shift exponent 64 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 4920 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/02/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 ubsan_epilogue+0x14/0x48 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x224/0x264 lib/ubsan.c:494
 __roundup_pow_of_two include/linux/log2.h:57 [inline]
 raid5_set_limits+0x470/0x510 drivers/md/raid5.c:7835
 raid5_run+0x1554/0x1b68 drivers/md/raid5.c:8133
 md_run+0xb9c/0x1a6c drivers/md/md.c:6760
 do_md_run+0x4c/0x4e4 drivers/md/md.c:6861
 array_state_store+0x7a8/0xce8 drivers/md/md.c:-1
 md_attr_store+0x304/0x438 drivers/md/md.c:6137
 sysfs_kf_write+0xe0/0x108 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x260/0x3b8 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x51c/0xa0c fs/read_write.c:687
 ksys_write+0x12c/0x228 fs/read_write.c:739
 __do_sys_write fs/read_write.c:750 [inline]
 __se_sys_write fs/read_write.c:747 [inline]
 __arm64_sys_write+0x84/0x98 fs/read_write.c:747
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
---[ end trace ]---


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
