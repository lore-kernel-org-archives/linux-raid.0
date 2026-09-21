Received: from mail-oi2-f5.google.com (mail-oi2-f5.google.com [74.125.231.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F2F4854E9
	for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 11:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789988870; cv=none; b=SDjsgca5pHroOQhmMWQ/wRZWAgL1XiOVrdf3De0iKOBE+5KX0cnc4AV6B6LL9hN0dU4e92VF56egDAJJp5RV+GAW+hZj0SqZibxmgXRFESrKDCeG5rjvkQHtrM7eEI95DyMQeTqlaVnfcBYXRBS52JLdcILfdT2SQBjJbhn427g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789988870; c=relaxed/simple;
	bh=nFA1kLxPFD6DXL7JegHDVi+dyMdIf8B9BDVi9szT22o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=l8pXz4TE04ygt9EBmwdr1nQuQE5bE3W9BEK85Qmkf2OjLDj/eUDi/d0vB/CyQECKT1PAyUAFNvve19IGqviE4WaYyyJt1jX1fiwPHEGJKJMtgxxCi+Hv90BtST343ZZSzlNVJSSE+jTbxFqEqb6CxyBke3o3mVIaa+9Xxlh+RJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f5.google.com with SMTP id 46e09a7af769-80477cb33a7so1467487a34.0
        for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 04:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988858; x=1790593658;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X4NPzwFFH/PIySvIe6MuM8xYH8txyEHUbV+e+2t0RMs=;
        b=HVLLT13Psx1BUgQ0rmDJxoq7PcvcENGzIFGbKs5pJdm/g8qoJ9Fheinzk94Jkxy9ZT
         XpWKS7a6gGA7pNA34+fI9xCEUZlbF3GgFZW7+J42OzX/bm2xYhLPkWFSc0LTUTESr/pQ
         bJMlKMfAv6VwIv58thLsVmWCrfAVVWe4i9LsVOajH/ZMV0nHsY8qH1jBWsnGc3X9k1FP
         lSlk9jiI8ty4ilvom1QWz9psWxs7aI70tQQLXDyglOO58hWdnletxWYzbc1ykvtGEi8M
         MsBXxXZiCYwXxaM9u8Mbjn8I69cCN+U5J3cPX6vMuMw87KwHxli9AJttNCLuCYaSNx9n
         9xKg==
X-Forwarded-Encrypted: i=1; AKwUvByA+NUuG/m5cW0Z/qa9PQnfItCxR46WmtVvrQzJuECPWn5IhmPMuMqESWhFziUtVTtUM5cr+/tmsq1a@vger.kernel.org
X-Gm-Message-State: AFuF++lpzpQHF3/2HEjZ9hqPzj9A06lA7p2/56+uDSoDeunY+mgEr52L
	xd7pyWEvvXMwjce2mizTPwLrBZtxcHtpavw+7LDfEQrLvX2fgdVitFXhBY6EsXBgeq5lZj7g6Hb
	CoT6Ny7A4d83Q2uTAC7KbfHF9GnT9bBc+fHEn6gCAXH46mzjTKKYmpuIfl7I=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3403:20b0:6cd:3fcc:96d9 with SMTP id
 006d021491bc7-6cd3fdbde06mr4054540eaf.87.1789988858742; Mon, 21 Sep 2026
 04:07:38 -0700 (PDT)
Date: Mon, 21 Sep 2026 04:07:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab10ffa.a6af0033.177e91.0014.GAE@google.com>
Subject: [syzbot] [raid?] WARNING in free_conf
From: syzbot <syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5dd1818b15d9 Merge tag 'for-next-keys-v7.3-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1074e7f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3be6e434b07ebb6
dashboard link: https://syzkaller.appspot.com/bug?extid=6a132745caefcf42cb0d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ecb73b95440b/disk-5dd1818b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e90eba3671c9/vmlinux-5dd1818b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea031fa7db3f/bzImage-5dd1818b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com

-----------------------------------------------------------------------------
Object 0xffff88808b840000 @offset=0
Object 0xffff88808b8404d8 @offset=1240
Object 0xffff88808b8409b0 @offset=2480
Object 0xffff88808b840e88 @offset=3720
Slab 0xffffea00022e1000 objects=13 used=4 fp=0xffff88808b841360 flags=0xfff00000000240(workingset|head|node=0|zone=1|lastcpupid=0x7ff)
Disabling lock debugging due to kernel taint
------------[ cut here ]------------
1
WARNING: mm/slub.c:1268 at __slab_err+0x15/0x20 mm/slub.c:1268, CPU#0: syz.5.636/7760
Modules linked in:
CPU: 0 UID: 0 PID: 7760 Comm: syz.5.636 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2026
RIP: 0010:__slab_err+0x15/0x20 mm/slub.c:1268
Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 e8 2b 00 00 00 bf 05 00 00 00 be 01 00 00 00 e8 7c 0f 5f 00 90 <0f> 0b 90 e9 5e 04 e8 ff cc 66 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000527f840 EFLAGS: 00010083
RAX: ffffffff81874cba RBX: ffff88801f7fb280 RCX: 0000000000080000
RDX: ffffc9000ddd2000 RSI: 000000000000eef7 RDI: 000000000000eef8
RBP: 0000000000000000 R08: ffffffff939990a7 R09: 1ffffffff2733214
R10: dffffc0000000000 R11: fffffbfff2733215 R12: ffffea00022e8c10
R13: ffffea00022e1000 R14: ffffc9000527f858 R15: ffff88805445e3c0
FS:  00007f088e6396c0(0000) GS:ffff888124cce000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffca4261db0 CR3: 000000003121e000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 free_partial mm/slub.c:8122 [inline]
 __kmem_cache_shutdown+0x1a5/0x2b0 mm/slub.c:8165
 kmem_cache_destroy+0x9d/0x180 mm/slab_common.c:576
 shrink_stripes drivers/md/raid5.c:2719 [inline]
 free_conf+0x1fc/0x5d0 drivers/md/raid5.c:7553
 setup_conf+0x1720/0x2ad0 drivers/md/raid5.c:7885
 raid5_takeover_raid1 drivers/md/raid5.c:8934 [inline]
 raid5_takeover+0x641/0x8d0 drivers/md/raid5.c:9045
 level_store+0x83b/0x1d10 drivers/md/md.c:4134
 md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f088d79e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f088e639028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f088da25fa0 RCX: 00007f088d79e159
RDX: 0000000000000005 RSI: 0000200000000300 RDI: 0000000000000004
RBP: 00007f088d83506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f088da26038 R14: 00007f088da25fa0 R15: 00007ffc30f7c868
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
