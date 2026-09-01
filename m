Received: from mail-oi2-f7.google.com (mail-oi2-f7.google.com [74.125.231.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F3644A3F4
	for <linux-raid@vger.kernel.org>; Tue,  1 Sep 2026 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292710; cv=none; b=nRYg5gmS0wP/4GkY8HI0HFODMZ9tT1Nc2d+VYtA5JoqYCAU5bKub8QtnBJBGjUIDBgybx0msxt8OR17pxqUC/Lqouz/ucXWQZFovGZqqFjB0ULJFeAOWAo0ZmTY096zxRGre5Rf8Q0vPszA2B/k9Wjno5pak9XqcS2b4IDgd2Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292710; c=relaxed/simple;
	bh=8YkzD8ARuX0vYO1367jGODTXnnUTuCYssGwFJZqv9wM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ou+NjCbVM+SiVBujeyFfP1uCNMzE41x0o0+rxziYxkRUycktny7yUAuiLUqE3IF5OwGIrLhIuNXWEkDfK1pUVlY+NRxQIO2E7oHMYlsyV6EXZXug4pqjjKY/+mXcEpI0K8bPzasA95+8wXktT6x/s2YV1GiYgSC1mtIzgckfpBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f7.google.com with SMTP id 5614622812f47-4b39374fab5so59993b6e.1
        for <linux-raid@vger.kernel.org>; Tue, 01 Sep 2026 12:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788292707; x=1788897507;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c7h/zJKghNpqnowb2E2GhH8KGrsNsXaWvN5Fli5UPXU=;
        b=PdUnj6zsoBQYEb22gw1GV+/56NLuLIl9lrhlpgDHU5P+SnSulN/CxNn+jne9XE0vxo
         0A4HWY6XBxyjC+J/LCtczt8RnuEnZEXxmosVqaZmQSpI3bC775LUgxy0Ds58m4Km7nQ1
         7KiAHZ+QYHRfi/yE3VgSBJ0wONKEAhWwgVB+MtpyyOLazvJlaUOchcbbOpNarTCpyzPo
         Knm9g9XkSpAxNT2f9/fMtsNlDRm6hwwIvgKX7LyRsDHgvocG/h/5jq4GlGiei5Q6Akcg
         1uIyMh/x8pVfupkuUQ7mP2j1E7IlALcy2h8lW7faG0mWhv8mNf37On00b1XaonpmZkyX
         zbDw==
X-Forwarded-Encrypted: i=1; AHgh+Rof/1j0+bfnbhA7X/uRoYflENPO/jOIprFlNVjq6vzyzKJn+mOQec5xRzktq3xZI9HttDwpkllBzMR4@vger.kernel.org
X-Gm-Message-State: AFuF++nGzZ6mKNX4hRoyQiP0751DGos0hRnvKLqLDRDE3meLgHnpQYeE
	1cXt3C1GWHWUHWuD1QR1w4TNwrjvRO0GcRhNs1GeLCdltvcBN5oODZ6kJlwWx8qITjKy5mprhOR
	jQgt9WMIQVAnz2P1GKuy5v+v3ryXpzTZIucTnbtLNbJLtXYDaCsZBnNC0Qo8=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:30a6:b0:48a:ddd4:d36f with SMTP id
 5614622812f47-4b5b8064ab9mr10831910b6e.8.1788292707462; Tue, 01 Sep 2026
 12:58:27 -0700 (PDT)
Date: Tue, 01 Sep 2026 12:58:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a972e63.610165a0.2b3dfd.0001.GAE@google.com>
Subject: [syzbot] [raid?] WARNING in create_strip_zones (2)
From: syzbot <syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13cb6d79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c35c7e43de75adb
dashboard link: https://syzkaller.appspot.com/bug?extid=a32ff75e417c0f49a8e9
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9adea981957f/vmlinux-818bebeb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6676075cd03e/bzImage-818bebeb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
xfs: Deprecated parameter 'noattr2'
XFS: noattr2 mount option is deprecated.
XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+
md0: Warning: Device ram1 is misaligned
------------[ cut here ]------------
!(flags & __GFP_NOWARN)
WARNING: mm/slub.c:6908 at __kvmalloc_node_noprof+0x7de/0x870 mm/slub.c:6908, CPU#0: syz.0.0/5312
Modules linked in:
CPU: 0 UID: 0 PID: 5312 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__kvmalloc_node_noprof+0x7de/0x870 mm/slub.c:6908
Code: ff 48 c7 c7 b0 5c e9 8e 48 89 de e8 5c eb ea 02 e9 fd fb ff ff 48 c7 c7 f0 5c e9 8e 48 89 de e8 48 eb ea 02 e9 32 fc ff ff 90 <0f> 0b 90 45 31 f6 e9 ef fd ff ff 90 0f 0b 90 e9 46 ff ff ff 49 83
RSP: 0018:ffffc9000ee9f550 EFLAGS: 00010246
RAX: 00000001ffffffff RBX: 00000000000029c0 RCX: 8000000000000001
RDX: ffffffffffffffff RSI: ffffffff8c6d1560 RDI: ffffffff8c6d1520
RBP: ffffffffffffffff R08: 00000000000029c0 R09: 00000000ffffffff
R10: 0000000000000006 R11: 0000000000000002 R12: 00000000ffffffff
R13: ffffffff887a930f R14: 0000000000000000 R15: 0000000000000200
FS:  00007f8f049f86c0(0000) GS:ffff88808c30a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f70c37ede9c CR3: 0000000042c8f000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 create_strip_zones+0xb6f/0x2170 drivers/md/raid0.c:150
 raid0_run+0x3de/0xed0 drivers/md/raid0.c:424
 md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
 do_md_run+0x35/0x720 drivers/md/md.c:6880
 md_ioctl+0x1e2b/0x2610 drivers/md/md.c:8515
 blkdev_ioctl+0x5e3/0x740 block/ioctl.c:798
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8f03b9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8f049f7fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f8f03e25fa0 RCX: 00007f8f03b9e159
RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 000000000000000a
RBP: 00007f8f03c35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8f03e26038 R14: 00007f8f03e25fa0 R15: 00007ffdcdc958c8
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
