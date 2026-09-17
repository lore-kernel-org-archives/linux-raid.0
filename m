Received: from mail-oi2-f6.google.com (mail-oi2-f6.google.com [74.125.231.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193CD2857F0
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 01:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789607914; cv=none; b=esXR6D0dhi0LLTYrtrd7y5jMSpaMqDmPvc8HMFQp2CGfIghf0IY/JjzBtCFn/4cfP4acbaDVAsJbIA70QTr5nl/Spf2umMk0u04kVehKI0ZeAR9fsLSUeMRHlHDfSg8VVZqGNSUmUyvDojguYsLa9jlF5ZTQi+GCiLJOIYWNfVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789607914; c=relaxed/simple;
	bh=pf14TofstAXLbTuVvmcKUFxji4E7btSHimL4GRxJUD8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=IaLvEp5WXpvmpYOF9uznvKRJoD9SjLIhWXpBvjOJvjCHp4w59kthj+xtNR0Ow1AAeBLo3dwtS5f9hUt2vZGWtQ79m3TrtYrCoxAkK5wZBeiKoy7dBWQZyhlolIGLb4Wbp0kzg6EaKfQ//FjVCeF9RYTVDbG/lyXxSLyJhb9LEOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f6.google.com with SMTP id 46e09a7af769-8069d92e182so116569a34.0
        for <linux-raid@vger.kernel.org>; Wed, 16 Sep 2026 18:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789607912; x=1790212712;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:in-reply-to:date:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LtOlAYWsyy7u4ditOZknWwKzPI078uu3FpDpGPC7wwo=;
        b=IjWUW9t8cF9cNJ0gJcFA2bpX9pG7kssJlDQ7BpjrZHOD8x4GtcsJi+Ev8GRLyxjnxU
         VxqHP/hy7cw9AgCiglxMGMEeejXbPvyw8NRmsNSUsEOySnxUM2lakpJrlu9jjHFp5rBF
         CrPxMXTN4igbUCsrHainy8JJUNh9Ik9ZSKnknoDNaVjdqyq0PxF88v4xjEoxBiGLdQS3
         I38ZqAOX+ioMekrmYed0v1O0LB7mxkDddPXU59sQbEq8IjBNDUQjVM8fITiKmdrm3Hhx
         /cQgiFEG7+fMG46ngoFGES6Pb0CxYsSLLV0jalxiwbO/6kW5/DZ8Blec62mSIP0C4vq4
         tAVw==
X-Forwarded-Encrypted: i=1; AKwUvByQ0Li2zj4MoTBc7uHLSAmbE8xspOZC4h338z71hXEgzeuJpDvp6ihAeBtHjPmcx8ij/XehDk574QPN@vger.kernel.org
X-Gm-Message-State: AFuF++kQjvEzLSUzUPiYmS1xy2RuV8PdoF5C/JonrzTXtuOcd2QEMZ+Q
	S+zN9ydU2Z411jRw9gHPl9arb/be4v4Y5yI9muY4Il2KVR8HeRhRQQssb1mv/31Op4DiF+nG83O
	c3HvPCuGqKzlj2sZft/oNn/mYsQG2inoPgHVJVYm9BCu1mrFqmnR8kUx26zY=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81c5:b0:6b3:506e:b484 with SMTP id
 006d021491bc7-6c7d1bc844dmr4478041eaf.16.1789607911986; Wed, 16 Sep 2026
 18:18:31 -0700 (PDT)
Date: Wed, 16 Sep 2026 18:18:31 -0700
In-Reply-To: <fd79a199-9af9-42b1-af08-1e7df169c681@huaweicloud.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aab3fe7.71f81b7d.278072.0004.GAE@google.com>
Subject: Re: [syzbot] [raid?] kernel BUG in find_zone
From: syzbot <syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com>
To: wozizhi@huaweicloud.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	wozizhi@huaweicloud.com, xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> #syz test:=20

This crash does not have a reproducer. I cannot test it.

> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> Please test the attached patch.
>
> Thanks,
> Zizhi Wo
>
> =E5=9C=A8 2026/9/16 20:57, syzbot =E5=86=99=E9=81=93:
>> Hello,
>>=20
>> syzbot found the following issue on:
>>=20
>> HEAD commit:    50d05c7c76c9 Merge tag 'landlock-7.3-rc3' of git://git.k=
er..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D100769f95800=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D85bc5cc2fc73=
94d9
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D50f9bc7ab8eb22=
4b7629
>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for =
Debian) 2.44
>> userspace arch: i386
>>=20
>> Unfortunately, I don't have any reproducer for this issue yet.
>>=20
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/=
d900f083ada3/non_bootable_disk-50d05c7c.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/303a0ade8f9e/vmlin=
ux-50d05c7c.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/70b8ca71442b/=
bzImage-50d05c7c.xz
>>=20
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com
>>=20
>> ------------[ cut here ]------------
>> kernel BUG at drivers/md/raid0.c:318!
>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>> CPU: 1 UID: 0 PID: 8386 Comm: syz.2.584 Tainted: G             L      sy=
zkaller #0 PREEMPT(full)
>> Tainted: [L]=3DSOFTLOCKUP
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1=
.16.3-2 04/01/2014
>> RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
>> RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
>> Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc =
cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3=
c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
>> RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>> RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
>> RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
>> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
>> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
>> FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53f=
db40
>> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>> CR2: 0000000033863fff CR3: 0000000070ae4000 CR4: 0000000000352ef0
>> Call Trace:
>>   <TASK>
>>   raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
>>   raid0_make_request+0x299/0x1660 drivers/md/raid0.c:626
>>   md_handle_request+0x824/0x1230 drivers/md/md.c:417
>>   md_submit_bio+0x1e9/0x350 drivers/md/md.c:458
>>   __submit_bio block/blk-core.c:681 [inline]
>>   __submit_bio+0x20e/0x3d0 block/blk-core.c:670
>>   __submit_bio_noacct block/blk-core.c:724 [inline]
>>   submit_bio_noacct_nocheck+0x736/0xc00 block/blk-core.c:792
>>   submit_bio_noacct+0xc93/0x2130 block/blk-core.c:925
>>   blk_crypto_submit_bio include/linux/blk-crypto.h:212 [inline]
>>   __bh_submit+0x7ce/0xaa0 fs/buffer.c:1132
>>   bh_submit fs/buffer.c:1146 [inline]
>>   block_read_full_folio+0x496/0x8c0 fs/buffer.c:2373
>>   filemap_read_folio+0xfc/0x3b0 mm/filemap.c:2520
>>   do_read_cache_folio+0x2d7/0x6b0 mm/filemap.c:4156
>>   read_mapping_folio include/linux/pagemap.h:1015 [inline]
>>   read_part_sector+0xd1/0x370 block/partitions/core.c:724
>>   adfspart_check_ICS+0x91/0x7d0 block/partitions/acorn.c:357
>>   check_partition block/partitions/core.c:143 [inline]
>>   blk_add_partitions block/partitions/core.c:591 [inline]
>>   bdev_disk_changed+0x7b1/0x1260 block/partitions/core.c:695
>>   blkdev_get_whole+0x187/0x290 block/bdev.c:793
>>   bdev_open+0x2c7/0xe40 block/bdev.c:1002
>>   blkdev_open+0x34e/0x4f0 block/fops.c:674
>>   do_dentry_open+0x6ab/0x14d0 fs/open.c:996
>>   vfs_open+0x82/0x3f0 fs/open.c:1101
>>   do_open fs/namei.c:4837 [inline]
>>   path_openat+0x19fa/0x2440 fs/namei.c:5000
>>   do_file_open+0x20e/0x430 fs/namei.c:5029
>>   do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
>>   do_sys_open fs/open.c:1423 [inline]
>>   __do_compat_sys_openat fs/open.c:1485 [inline]
>>   __se_compat_sys_openat fs/open.c:1483 [inline]
>>   __ia32_compat_sys_openat+0x12d/0x210 fs/open.c:1483
>>   do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
>>   __do_fast_syscall_32+0x13a/0x8b0 arch/x86/entry/syscall_32.c:291
>>   do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:316
>>   entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>> RIP: 0023:0xf700efec
>> Code: Unable to access opcode bytes at 0xf700efc2.
>> RSP: 002b:00000000f53fd50c EFLAGS: 00000292 ORIG_RAX: 0000000000000127
>> RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000080000300
>> RDX: 0000000000004002 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
>> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>   </TASK>
>> Modules linked in:
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
>> RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
>> Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc =
cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3=
c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
>> RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>> RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
>> RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
>> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
>> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
>> FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53f=
db40
>> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>> CR2: 00000000f5315ff4 CR3: 0000000070ae4000 CR4: 0000000000352ef0
>>=20
>>=20
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>=20
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>=20
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>>=20
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>>=20
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>>=20
>> If you want to undo deduplication, reply with:
>> #syz undup
>>=20
