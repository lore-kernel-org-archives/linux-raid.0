Received: from mail-oo2-f5.google.com (mail-oo2-f5.google.com [74.125.231.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E0F3B3BEF
	for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789304981; cv=none; b=Y2X+hw3HDGBNaXAnry6i4W/mCqZScYxHEQXallbV0VrKTOziO7B+CHF+g/dXuz+RYBlekRthzh92k6b6nxAPLmqNkj4tlMfzql+suW7gPiIGIpbnN6V4Z1Cl0RxPWIjPHqEpjt2WIL/BVjpbGGMuo0yO5WP+zgBQFMlYv/PJcso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789304981; c=relaxed/simple;
	bh=gaocr8UoasL6UglbmSn3uEOdpHrdNXVg8LYJh76Bhf8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hZrzFQ6UoahBMmSHWcD8+UDpmyfy5KLw/3VlB3SUrbSWMnf5OSB8mhlAxebRHYhPJZEq5xVwcwfgPAhMoUh+6NX0KCqAXYQxLp62OUpziYcKWWU9CZYX66XxYV1Ec8bJ8tgWhYk9F9m3fhihGDPSN8q+QLMg+17cMXx+OTQnf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f5.google.com with SMTP id 46e09a7af769-7f4e6693089so906314a34.0
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 06:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789304977; x=1789909777;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dQaYbYfap6O7/j9L4Qh3SfVtO+gJY/NxKbXAfMPqRrA=;
        b=kAd8nKQw6pUvPqAQ04Al0eQZ/eukvrJFqNSyoNET9Y0S/a+/Zgp3s0ANuUS8/bSzPP
         LLBfGg0kO+wI3RcfWI2rvxznvyL8QQzUN55xcf1nhh5BH9gc/6M2yQP/ovU34igDnPec
         NglXPJ8qZ+LEkUjqsoTzpEexrpZ5kyNgVJGKm/QSJCY5N28BnI0Ja5lU0I1uIozOHxsh
         KFAEOxwU+N7HiBFWhFFzaxqfwUNDlA69cL/5S86BHrM5SKyX6JsXOIHy05jDIFBjbdMc
         s7P2xnuKnoUC3mEvvAQypdpHYu6mkQ1nOTm1LTLpIkTbsbHUQUraVmoqsmUOwVO4XpYq
         qe7g==
X-Forwarded-Encrypted: i=1; AKwUvByi4JS89kYt1kwXL2S7QaZno0quQTNEAwdVa8iOzZ7TRsNXA8z8uIYw5AC+ngpaIJW+7jXIRkJwuYo5@vger.kernel.org
X-Gm-Message-State: AFuF++le+HkLfPQG0mZTV0JwBdUrZnCFAWy/Gl25p9Cga8AX2fxBMGxY
	6fBPZEw2N2EQNTZvG0PaXnPkBkDg+WdHl3t+o/cVghuJHfOZkx+W+qjxYESUrXwalzBpsuhIpTO
	B/LSFKrugyVxQSdO3GZRDO7SWdIovTP81oAvVkWDWK4RNlc8rTeBrDk5mmfI=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c452:10b0:6aa:cce3:ab61 with SMTP id
 006d021491bc7-6c0ba923c37mr10682676eaf.9.1789304977630; Sun, 13 Sep 2026
 06:09:37 -0700 (PDT)
Date: Sun, 13 Sep 2026 06:09:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa6a091.f670cee1.72fc4.0012.GAE@google.com>
Subject: [syzbot] [raid?] UBSAN: array-index-out-of-bounds in super_90_sync
From: syzbot <syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    893e11787f78 Merge tag 'x86_urgent_for_7.3-rc3' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11af7af9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7d6d05cecce7/disk-893e1178.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f4fa34852d36/vmlinux-893e1178.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5a45af623528/bzImage-893e1178.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com

md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in drivers/md/md.c:1697:17
index 124 is out of range for type 'mdp_disk_t [27]'
CPU: 1 UID: 0 PID: 10197 Comm: syz.3.1362 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xcc/0xf0 lib/ubsan.c:455
 super_90_sync+0x1eed/0x1ff0 drivers/md/md.c:1697
 sync_super drivers/md/md.c:2505 [inline]
 sync_sbs drivers/md/md.c:2747 [inline]
 md_update_sb+0xbba/0x2840 drivers/md/md.c:2923
 state_store+0x31e/0x1340 drivers/md/md.c:3245
 rdev_attr_store+0x465/0x560 drivers/md/md.c:3768
 sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6af/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f977e59e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f977f3cb028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f977e825fa0 RCX: 00007f977e59e159
RDX: 000000000000000b RSI: 0000200000000a00 RDI: 0000000000000006
RBP: 00007f977e63503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f977e826038 R14: 00007f977e825fa0 R15: 00007ffef91f5d68
 </TASK>
---[ end trace ]---


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
