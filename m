Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98162367297;
	Thu, 17 Sep 2026 01:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789608294; cv=none; b=eQVF5EDr9oz/O6rN7cnHAiYenXxYgWNwNeyE8ErMjZKqQYbgcSp5Stdbtb39xtpGnQAskwAQ1IpqZlIHi6taiB9yEvbCc/T5TWWo74AZRdWmW8r8umFldPxlxv0rtcMuhLcEuk60ZhDckk07MFFLtNQiPA39kHh+8uVk72xsOxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789608294; c=relaxed/simple;
	bh=ZjWWSnGTXJSoReAXLfLudruoW6qr0zBo+d44h9urHhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bwuoDMtGUi/cM+8CEN9iaa/AVl1Ce1ksLc6SapX5QvftO7nwhNE2rd1YKhLY+IwXIYSQrgC5yXtXIX9RPxjN32zEKnCGdy2JT58qPlNDTJwitX7othDuIBigBnqDA74rvuJ8hcTMR5qAOYY4E5w6VvQGFrMFOwmgnAXWPygjPbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hldMs0LgrzYQtrg;
	Thu, 17 Sep 2026 09:24:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DEFAA40577;
	Thu, 17 Sep 2026 09:24:46 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBHFypbQatq431ZAg--.18058S3;
	Thu, 17 Sep 2026 09:24:44 +0800 (CST)
Message-ID: <5adf63f2-b42e-46d3-8a6f-66dd18bc9ca1@huaweicloud.com>
Date: Thu, 17 Sep 2026 09:24:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [raid?] kernel BUG in find_zone
To: syzbot <syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com>,
 wozizhi@huaweicloud.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com,
 xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
References: <6aab3fe7.71f81b7d.278072.0004.GAE@google.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <6aab3fe7.71f81b7d.278072.0004.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHFypbQatq431ZAg--.18058S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Wry3Wr1UKrWUXF1UKr43Awb_yoW3AFW3pr
	W5KF4jkr40qr1UJF1IvFy7J3Wrtr17AayUXrs7Jr18AF1jvF1UJr18tr4UG34DXr1SyFy3
	tF1DJ34vqr1UWaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/9/17 9:18, syzbot 写道:
>> #syz test:
> 
> This crash does not have a reproducer. I cannot test it.

Sorry for the noise -- I didn't realize this report has no reproducer.

I've posted a patch that I believe fixes this issue to the list:
https://lore.kernel.org/all/20260916095137.1157801-1-wozizhi@huaweicloud.com/

Since there's no syzbot reproducer, I constructed one locally and
confirmed the patch resolves the crash.

Thanks,
Zizhi Wo

> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>>
>> Please test the attached patch.
>>
>> Thanks,
>> Zizhi Wo
>>
>> 在 2026/9/16 20:57, syzbot 写道:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    50d05c7c76c9 Merge tag 'landlock-7.3-rc3' of git://git.ker..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=100769f9580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=50f9bc7ab8eb224b7629
>>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>>> userspace arch: i386
>>>
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> Downloadable assets:
>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-50d05c7c.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/303a0ade8f9e/vmlinux-50d05c7c.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/70b8ca71442b/bzImage-50d05c7c.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com
>>>
>>> ------------[ cut here ]------------
>>> kernel BUG at drivers/md/raid0.c:318!
>>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>>> CPU: 1 UID: 0 PID: 8386 Comm: syz.2.584 Tainted: G             L      syzkaller #0 PREEMPT(full)
>>> Tainted: [L]=SOFTLOCKUP
>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>>> RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
>>> RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
>>> Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
>>> RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
>>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>>> RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
>>> RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
>>> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
>>> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
>>> FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53fdb40
>>> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>>> CR2: 0000000033863fff CR3: 0000000070ae4000 CR4: 0000000000352ef0
>>> Call Trace:
>>>    <TASK>
>>>    raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
>>>    raid0_make_request+0x299/0x1660 drivers/md/raid0.c:626
>>>    md_handle_request+0x824/0x1230 drivers/md/md.c:417
>>>    md_submit_bio+0x1e9/0x350 drivers/md/md.c:458
>>>    __submit_bio block/blk-core.c:681 [inline]
>>>    __submit_bio+0x20e/0x3d0 block/blk-core.c:670
>>>    __submit_bio_noacct block/blk-core.c:724 [inline]
>>>    submit_bio_noacct_nocheck+0x736/0xc00 block/blk-core.c:792
>>>    submit_bio_noacct+0xc93/0x2130 block/blk-core.c:925
>>>    blk_crypto_submit_bio include/linux/blk-crypto.h:212 [inline]
>>>    __bh_submit+0x7ce/0xaa0 fs/buffer.c:1132
>>>    bh_submit fs/buffer.c:1146 [inline]
>>>    block_read_full_folio+0x496/0x8c0 fs/buffer.c:2373
>>>    filemap_read_folio+0xfc/0x3b0 mm/filemap.c:2520
>>>    do_read_cache_folio+0x2d7/0x6b0 mm/filemap.c:4156
>>>    read_mapping_folio include/linux/pagemap.h:1015 [inline]
>>>    read_part_sector+0xd1/0x370 block/partitions/core.c:724
>>>    adfspart_check_ICS+0x91/0x7d0 block/partitions/acorn.c:357
>>>    check_partition block/partitions/core.c:143 [inline]
>>>    blk_add_partitions block/partitions/core.c:591 [inline]
>>>    bdev_disk_changed+0x7b1/0x1260 block/partitions/core.c:695
>>>    blkdev_get_whole+0x187/0x290 block/bdev.c:793
>>>    bdev_open+0x2c7/0xe40 block/bdev.c:1002
>>>    blkdev_open+0x34e/0x4f0 block/fops.c:674
>>>    do_dentry_open+0x6ab/0x14d0 fs/open.c:996
>>>    vfs_open+0x82/0x3f0 fs/open.c:1101
>>>    do_open fs/namei.c:4837 [inline]
>>>    path_openat+0x19fa/0x2440 fs/namei.c:5000
>>>    do_file_open+0x20e/0x430 fs/namei.c:5029
>>>    do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
>>>    do_sys_open fs/open.c:1423 [inline]
>>>    __do_compat_sys_openat fs/open.c:1485 [inline]
>>>    __se_compat_sys_openat fs/open.c:1483 [inline]
>>>    __ia32_compat_sys_openat+0x12d/0x210 fs/open.c:1483
>>>    do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
>>>    __do_fast_syscall_32+0x13a/0x8b0 arch/x86/entry/syscall_32.c:291
>>>    do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:316
>>>    entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>>> RIP: 0023:0xf700efec
>>> Code: Unable to access opcode bytes at 0xf700efc2.
>>> RSP: 002b:00000000f53fd50c EFLAGS: 00000292 ORIG_RAX: 0000000000000127
>>> RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000080000300
>>> RDX: 0000000000004002 RSI: 0000000000000000 RDI: 0000000000000000
>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>> R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
>>> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>>    </TASK>
>>> Modules linked in:
>>> ---[ end trace 0000000000000000 ]---
>>> RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
>>> RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
>>> Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
>>> RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
>>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
>>> RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
>>> RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
>>> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
>>> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
>>> FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53fdb40
>>> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>>> CR2: 00000000f5315ff4 CR3: 0000000070ae4000 CR4: 0000000000352ef0
>>>
>>>
>>> ---
>>> This report is generated by a bot. It may contain errors.
>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this issue. See:
>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>>
>>> If the report is already addressed, let syzbot know by replying with:
>>> #syz fix: exact-commit-title
>>>
>>> If you want to overwrite report's subsystems, reply with:
>>> #syz set subsystems: new-subsystem
>>> (See the list of subsystem names on the web dashboard)
>>>
>>> If the report is a duplicate of another one, reply with:
>>> #syz dup: exact-subject-of-another-report
>>>
>>> If you want to undo deduplication, reply with:
>>> #syz undup
>>>
> 

