Received: from mail-oi2-f5.google.com (mail-oi2-f5.google.com [74.125.231.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905CD47ECEE
	for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 23:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032964; cv=none; b=Q9PKv6oh/qQiKk2PG0SuiNC3zcbvXUXQZpJLZvApADh0jEWexcoGH4Urk33rFXpAl+NWFnPpObn1HcuBhDr3H9CaipwhowLS7vneCrcu3dDZIrk+pcxOr4Iaf2WZaNrr9XX5fFhr5TCy9aih+8o3nJo4ipoTENmeNuE0Nuj8e+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032964; c=relaxed/simple;
	bh=ZlEvRhtLyPki3pTX07dXMGVSJhgfOrrYdBQD0WuOw2E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jX3F1VSiLiIP+oCcf8OhXG9TwUcZDBTzMlN5q4Iu7jRW+apMpjcLkRWEEBKUNln9VARJ69GLeoQVvN2BDT3K2ukKb85A8Hushfr4PPS3ds7FKV775T6Bq7MSJFeiuohgVtrQ7dXr1vIcsVhv3hv0UNM5IoXZX8dhhRt8VonJ68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f5.google.com with SMTP id 46e09a7af769-8047334328bso1579453a34.0
        for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 16:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790032959; x=1790637759;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+e/Cje/6om9LlGD3h/TqbRskTVmMJEqaJKhHlbxnYH0=;
        b=bjRK3BftlrbkNJIzOxelQ4UrtK22H6O7W0WJQnitJXF5d5SYOJiitijjEgi0zjz2WF
         l24Jx2+STxFAWIdm+I4wAAtpq/bRFG9kkrCM6xalFFcrs/rXQ8noZr0fRbUh1BZXpQ1h
         ySOGRTsmBNjmM/o4337pFjXed5q8eEM+sfl3c5yHCuwqhy5zyfoLdCTxrgAQRyroQIZZ
         eMgnCrJhlsGFFine0Iih1ZPalTv0b62bhlrGDSdfBSAZ59JWkexaxKtIliKsGrtRFwUq
         RcpltXtzA3FSp4eoftPVw0ISDKm1FBuLS78s0gkwf0TXUuifMkJZdffGW11H+ILDvuzj
         wRWA==
X-Forwarded-Encrypted: i=1; AKwUvBy1vKPIh6VtNe6pqL2dPQrFw+Ws/2rd8WGSCitd1tVmaCD6L7jwqNoC7JXCS7aypA6DmRH3DLmp5bdL@vger.kernel.org
X-Gm-Message-State: AFuF++mSvmhSqKLfJnEaPvBY5cyTS/KrZLzTLW36xRvC7Z1dF1kpn85v
	X4ia5gj8wW/EFZBX8SsMg0A5bbvTpiUQAQalzpKE6KVHTlxpTGlIuRG1IGhi0jKZvXmvt0LLHDo
	SejxBU4/nT53ah8Nctc0U6jE+IGao6PBt+oGDQn55nbAgIqb/N4ed306wLjg=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f03:b0:6b3:1874:6f21 with SMTP id
 006d021491bc7-6ca975e6949mr11117075eaf.0.1790032959503; Mon, 21 Sep 2026
 16:22:39 -0700 (PDT)
Date: Mon, 21 Sep 2026 16:22:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab1bc3f.a6af0033.177e91.001a.GAE@google.com>
Subject: [syzbot] [raid?] BUG: unable to handle kernel paging request in free_conf
From: syzbot <syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f0100363d8c3 Merge tag 'xfs-fixes-7.3-rc5' of gitolite.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133e5805580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
dashboard link: https://syzkaller.appspot.com/bug?extid=270624bb31d478afe62e
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13db8515580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1299b525580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f0100363.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/18fb2734cddb/vmlinux-f0100363.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5737b586e7bc/bzImage-f0100363.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com

 </TASK>
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:82 [inline]
BUG: KASAN: null-ptr-deref in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: null-ptr-deref in raid5_has_ppl drivers/md/raid5-log.h:54 [inline]
BUG: KASAN: null-ptr-deref in log_exit drivers/md/raid5-log.h:128 [inline]
BUG: KASAN: null-ptr-deref in free_conf+0x81/0x5d0 drivers/md/raid5.c:7549
Read of size 8 at addr 0000000000000028 by task syz.3.20/5681

CPU: 0 UID: 0 PID: 5681 Comm: syz.3.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 raid5_has_ppl drivers/md/raid5-log.h:54 [inline]
 log_exit drivers/md/raid5-log.h:128 [inline]
 free_conf+0x81/0x5d0 drivers/md/raid5.c:7549
 setup_conf+0x1720/0x2ad0 drivers/md/raid5.c:7885
 raid5_run+0x8cc/0x2560 drivers/md/raid5.c:8129
 md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
 do_md_run+0x35/0x720 drivers/md/md.c:6880
 array_state_store+0x958/0xe90 drivers/md/md.c:-1
 md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f36cfd9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9be823c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f36d0025fa0 RCX: 00007f36cfd9e159
RDX: 0000000000000006 RSI: 0000200000000a40 RDI: 0000000000000008
RBP: 00007ffe9be82430 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007f36d0025fac R14: 00007f36d0025fa0 R15: 00007f36d0025fa0
 </TASK>
==================================================================


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
