Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D9B13C908;
	Thu, 17 Sep 2026 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789607913; cv=none; b=abLTguxqOe0/rtU6867zLdzl0y96mDkdfZsD/pE4OtaxEsxpBMVTTllV20hjx8+TxiINff6m0JHob3hf2Sx4jB7UdY36B89bapM2pvs4JC7/9d8TyN2SWiEdawfyIrASwTwwwBkM2SBuII3IjHKvpjtSjruvD/qLJE38975UcVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789607913; c=relaxed/simple;
	bh=gz4eDZeYsS0AUO9Nh/ssbeMhDMNBc1y4w4GcrVsbEfI=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:In-Reply-To; b=lb5zctKY++BLGmLwnOE65xrJekrZh0LOhLwkRkGlVMN07dWdSUyL7PAsxwW7VMbn2eRJjiVu0UcVUQS7x3eiEWY7gSBrhyvuan4Q7s+YDwQbSpGArGxz98RI1lyKsnfwcYuhMyEJc/4ErOdWCI1mYm7Ns6BFQt4Hjbj27ibyf5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hldDF2hcdzKHMRm;
	Thu, 17 Sep 2026 09:18:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 97B024058D;
	Thu, 17 Sep 2026 09:18:20 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xyrWP6tqFepYAg--.18365S3;
	Thu, 17 Sep 2026 09:18:17 +0800 (CST)
Content-Type: multipart/mixed; boundary="------------0TbVc74WCPylTs0L87bUxMfY"
Message-ID: <fd79a199-9af9-42b1-af08-1e7df169c681@huaweicloud.com>
Date: Thu, 17 Sep 2026 09:18:13 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [raid?] kernel BUG in find_zone
To: syzbot <syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com,
 xiao@kernel.org, yukuai@fnnas.com, yukuai@fygo.io
References: <6aaa9243.e91c2013.3bdb06.0000.GAE@google.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <6aaa9243.e91c2013.3bdb06.0000.GAE@google.com>
X-CM-TRANSID:gCh0CgD3xyrWP6tqFepYAg--.18365S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtrW7uFyUAF1rAryfKw1DAwb_yoWxtrWxpr
	W5Kr4UCr40gF1UJF1UZFy7Jr1rGr1UAayUXrZ7Jr18A3W5u3WUJr10yrWUJryDJrySvFya
	qFn8Jw1ktr18uaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21le4C267I2x7xF54xIwI1l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFcxC0VAYjxAxZF0E
	x2IqxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_Gr1l6VACY4xI67
	k04243AbIYCTnIWIevJa73UjIFyTuYvjxUFBT5DUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

This is a multi-part message in MIME format.
--------------0TbVc74WCPylTs0L87bUxMfY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

#syz test: 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

Please test the attached patch.

Thanks,
Zizhi Wo

在 2026/9/16 20:57, syzbot 写道:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    50d05c7c76c9 Merge tag 'landlock-7.3-rc3' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=100769f9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
> dashboard link: https://syzkaller.appspot.com/bug?extid=50f9bc7ab8eb224b7629
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-50d05c7c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/303a0ade8f9e/vmlinux-50d05c7c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/70b8ca71442b/bzImage-50d05c7c.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at drivers/md/raid0.c:318!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 1 UID: 0 PID: 8386 Comm: syz.2.584 Tainted: G             L      syzkaller #0 PREEMPT(full)
> Tainted: [L]=SOFTLOCKUP
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
> RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
> Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
> RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
> RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53fdb40
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 0000000033863fff CR3: 0000000070ae4000 CR4: 0000000000352ef0
> Call Trace:
>   <TASK>
>   raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
>   raid0_make_request+0x299/0x1660 drivers/md/raid0.c:626
>   md_handle_request+0x824/0x1230 drivers/md/md.c:417
>   md_submit_bio+0x1e9/0x350 drivers/md/md.c:458
>   __submit_bio block/blk-core.c:681 [inline]
>   __submit_bio+0x20e/0x3d0 block/blk-core.c:670
>   __submit_bio_noacct block/blk-core.c:724 [inline]
>   submit_bio_noacct_nocheck+0x736/0xc00 block/blk-core.c:792
>   submit_bio_noacct+0xc93/0x2130 block/blk-core.c:925
>   blk_crypto_submit_bio include/linux/blk-crypto.h:212 [inline]
>   __bh_submit+0x7ce/0xaa0 fs/buffer.c:1132
>   bh_submit fs/buffer.c:1146 [inline]
>   block_read_full_folio+0x496/0x8c0 fs/buffer.c:2373
>   filemap_read_folio+0xfc/0x3b0 mm/filemap.c:2520
>   do_read_cache_folio+0x2d7/0x6b0 mm/filemap.c:4156
>   read_mapping_folio include/linux/pagemap.h:1015 [inline]
>   read_part_sector+0xd1/0x370 block/partitions/core.c:724
>   adfspart_check_ICS+0x91/0x7d0 block/partitions/acorn.c:357
>   check_partition block/partitions/core.c:143 [inline]
>   blk_add_partitions block/partitions/core.c:591 [inline]
>   bdev_disk_changed+0x7b1/0x1260 block/partitions/core.c:695
>   blkdev_get_whole+0x187/0x290 block/bdev.c:793
>   bdev_open+0x2c7/0xe40 block/bdev.c:1002
>   blkdev_open+0x34e/0x4f0 block/fops.c:674
>   do_dentry_open+0x6ab/0x14d0 fs/open.c:996
>   vfs_open+0x82/0x3f0 fs/open.c:1101
>   do_open fs/namei.c:4837 [inline]
>   path_openat+0x19fa/0x2440 fs/namei.c:5000
>   do_file_open+0x20e/0x430 fs/namei.c:5029
>   do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
>   do_sys_open fs/open.c:1423 [inline]
>   __do_compat_sys_openat fs/open.c:1485 [inline]
>   __se_compat_sys_openat fs/open.c:1483 [inline]
>   __ia32_compat_sys_openat+0x12d/0x210 fs/open.c:1483
>   do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
>   __do_fast_syscall_32+0x13a/0x8b0 arch/x86/entry/syscall_32.c:291
>   do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:316
>   entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> RIP: 0023:0xf700efec
> Code: Unable to access opcode bytes at 0xf700efc2.
> RSP: 002b:00000000f53fd50c EFLAGS: 00000292 ORIG_RAX: 0000000000000127
> RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000080000300
> RDX: 0000000000004002 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
> RIP: 0010:find_zone.isra.0+0x129/0x150 drivers/md/raid0.c:305
> Code: f9 48 89 e8 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 89 ef e8 a2 00 fe f9 e9 79 ff ff ff e8 c8 bf 8b f9 90 <0f> 0b 48 8b 3c 24 e8 8c 00 fe f9 e9 04 ff ff ff 48 89 df e8 7f 00
> RSP: 0018:ffffc9000557f090 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff888022b34b00 RSI: ffffffff887fa208 RDI: ffff888022b34b00
> RBP: ffff888042790b18 R08: 0000000000000004 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff888096a60000(0063) knlGS:00000000f53fdb40
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 00000000f5315ff4 CR3: 0000000070ae4000 CR4: 0000000000352ef0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 

--------------0TbVc74WCPylTs0L87bUxMfY
Content-Type: text/plain; charset=UTF-8;
 name="0001-md-raid5-reject-a-per-device-size-smaller-than-one-c.patch"
Content-Disposition: attachment;
 filename*0="0001-md-raid5-reject-a-per-device-size-smaller-than-one-c.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBkMmUwNTA4YzlhNjZjYWQ1YjVjYzMyOTdkZTY4YTcxNmU3YmY3MjA3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBaaXpoaSBXbyA8d296aXpoaUBodWF3ZWkuY29tPgpE
YXRlOiBXZWQsIDE2IFNlcCAyMDI2IDE2OjQ5OjQwICswODAwClN1YmplY3Q6IFtQQVRDSF0g
bWQvcmFpZDU6IHJlamVjdCBhIHBlci1kZXZpY2Ugc2l6ZSBzbWFsbGVyIHRoYW4gb25lIGNo
dW5rCgpCb3RoIHJhaWQ1X3J1bigpIGFuZCByYWlkNV9yZXNpemUoKSBhbGlnbiB0aGUgcGVy
LWRldmljZSBzaXplIGRvd24gdG8gYQp3aG9sZSBtdWx0aXBsZSBvZiB0aGUgY2h1bmsgc2l6
ZToKCgltZGRldi0+ZGV2X3NlY3RvcnMgJj0gfihjaHVua19zZWN0b3JzIC0gMSk7CgpOZWl0
aGVyIGNoZWNrcyB0aGUgcmVzdWx0LCBzbyBhIHNpemUgc21hbGxlciB0aGFuIG9uZSBjaHVu
ayBzaWxlbnRseQpiZWNvbWVzIHplcm8uCgpJbiByYWlkNV9ydW4oKSB0aGF0IGlzIGhhcm1s
ZXNzOiB0aGUgYXJyYXkgc2l6ZSBpcyBkZXJpdmVkIGZyb20gdGhlIHNhbWUKemVybywgc28g
dGhlIGRpc2sganVzdCBlbmRzIHVwIHdpdGggbm8gY2FwYWNpdHkuCgpJbiByYWlkNV9yZXNp
emUoKSBpdCBsZWF2ZXMgdGhlIGFycmF5IGluY29uc2lzdGVudCAtLSBtZGRldi0+ZGV2X3Nl
Y3RvcnMKYmVjb21lcyB6ZXJvLCB3aGlsZSBtZGRldi0+YXJyYXlfc2VjdG9ycyBhbmQgdGhl
IGdlbmRpc2sgY2FwYWNpdHkga2VlcCB0aGUKcHJldmlvdXMuIEEgbGF0ZXIgcmFpZDQvcmFp
ZDUgLT4gcmFpZDAgdGFrZW92ZXIgY29waWVzIHRoZSB6ZXJvIGludG8gZXZlcnkKcmRldi0+
c2VjdG9ycyAocmFpZDBfdGFrZW92ZXJfcmFpZDQ1KCkpLCBzbyBjcmVhdGVfc3RyaXBfem9u
ZXMoKSBidWlsZHMgYQpzdHJpcCB6b25lIHRhYmxlIHdob3NlIHpvbmVfZW5kIGlzIHplcm8u
IEFueSByZWFkIHRoZW4gcGFzc2VzCmJpb19jaGVja19lb2QoKSBhZ2FpbnN0IHRoZSBzdGFs
ZSBjYXBhY2l0eSBhbmQgaGl0cyB0aGUgQlVHKCkgaW4KZmluZF96b25lKCk6Cgoga2VybmVs
IEJVRyBhdCBkcml2ZXJzL21kL3JhaWQwLmM6MzE4IQogT29wczogaW52YWxpZCBvcGNvZGU6
IDAwMDAgWyMxXSBTTVAgS0FTQU4gTk9QVEkKIENQVTogNDUgVUlEOiAwIFBJRDogMTMwMCBD
b21tOiBtZGFkbSBOb3QgdGFpbnRlZCA3LjMuMC1yYzMrICMxMDYgUFJFRU1QVChmdWxsKQog
SGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5Niks
IEJJT1MgMS4xNy4wLTQuZmM0MSAwNC8wMS8yMDE0CiBSSVA6IDAwMTA6cmFpZDBfbWFrZV9y
ZXF1ZXN0KzB4MTBjYi8weDE2YTAKIENhbGwgVHJhY2U6CiAgIDxUQVNLPgogICBtZF9oYW5k
bGVfcmVxdWVzdCsweDU2Ni8weGI0MAogICBfX3N1Ym1pdF9iaW8rMHgyYjIvMHg2MDAKICAg
c3VibWl0X2Jpb19ub2FjY3Rfbm9jaGVjaysweDUwOS8weGIzMAogICBibG9ja19yZWFkX2Z1
bGxfZm9saW8rMHgzNjQvMHg2ZDAKICAgZmlsZW1hcF9yZWFkX2ZvbGlvKzB4YTIvMHgyMDAK
ICAgZG9fcmVhZF9jYWNoZV9mb2xpbysweDFiNi8weDMzMAogICByZWFkX3BhcnRfc2VjdG9y
KzB4YjYvMHgyYTAKICAgcmVhZF9sYmErMHgxN2QvMHgyODAKICAgZWZpX3BhcnRpdGlvbisw
eDJhNi8weDI1MjAKICAgYmRldl9kaXNrX2NoYW5nZWQrMHg2ZTAvMHhmYTAKICAgLi4uLi4u
CiAgIGJkZXZfb3BlbisweDIxNC8weGM0MAoKUmVqZWN0IGEgc2l6ZSBzbWFsbGVyIHRoYW4g
b25lIGNodW5rIGluIGJvdGggZnVuY3Rpb25zLCBzbyB0aGF0IGEgcnVubmluZwpyYWlkNC9y
YWlkNSBhcnJheSBhbHdheXMgaGFzIG1kZGV2LT5kZXZfc2VjdG9ycyA+PSBvbmUgY2h1bmsu
CgpUaGUgY2hlY2sgaXMgZG9uZSB3aGVyZSB0aGUgdmFsdWUgdGFrZXMgZWZmZWN0LCBub3Qg
d2hlcmUgaXQgaXMgYXNzaWduZWQuCm1kZGV2LT5kZXZfc2VjdG9ycyBpcyB3cml0dGVuIGZy
b20gc2V2ZXJhbCBwbGFjZXMsIGFuZCBub25lIG9mIHRoZW0gY2FuCnRlbGwgd2hldGhlciB0
aGUgdmFsdWUgaXMgdXNhYmxlOiB0aGUgY2h1bmsgc2l6ZSBtYXkgc3RpbGwgY2hhbmdlIGxh
dGVyLgpyYWlkNV9ydW4oKSBhbmQgcmFpZDVfcmVzaXplKCkgYXJlIHdoZXJlIGV2ZXJ5IGlu
cHV0IGlzIGZpbmFsLCBzbyBvbmUgY2hlY2sKaW4gZWFjaCBjb3ZlcnMgdGhlbSBhbGwuCgpG
aXhlczogZWVhMTM2ZDY5ZjlmICgibWQ6IGZpeCBidWdsZXQgaW4gUkFJRDUgLT4gUkFJRDAg
Y29udmVyc2lvbi4iKQpTaWduZWQtb2ZmLWJ5OiBaaXpoaSBXbyA8d296aXpoaUBodWF3ZWku
Y29tPgotLS0KIGRyaXZlcnMvbWQvcmFpZDUuYyB8IDggKysrKysrKysKIDEgZmlsZSBjaGFu
Z2VkLCA4IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL3JhaWQ1LmMg
Yi9kcml2ZXJzL21kL3JhaWQ1LmMKaW5kZXggYjkxNTQ1Y2UwOTBkLi5lMGYxYThlN2JkM2Eg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvcmFpZDUuYworKysgYi9kcml2ZXJzL21kL3JhaWQ1
LmMKQEAgLTgyMDEsMTAgKzgyMDEsMTYgQEAgc3RhdGljIGludCByYWlkNV9ydW4oc3RydWN0
IG1kZGV2ICptZGRldikKIAkJZ290byBhYm9ydDsKIAl9CiAKIAkvKiBkZXZpY2Ugc2l6ZSBt
dXN0IGJlIGEgbXVsdGlwbGUgb2YgY2h1bmsgc2l6ZSAqLwogCW1kZGV2LT5kZXZfc2VjdG9y
cyAmPSB+KChzZWN0b3JfdCltZGRldi0+Y2h1bmtfc2VjdG9ycyAtIDEpOworCWlmICghbWRk
ZXYtPmRldl9zZWN0b3JzKSB7CisJCXByX3dhcm4oIm1kL3JhaWQ6JXM6IGRldmljZSBzaXpl
IGlzIHNtYWxsZXIgdGhhbiBvbmUgY2h1bmtcbiIsCisJCQltZG5hbWUobWRkZXYpKTsKKwkJ
cmV0ID0gLUVJTlZBTDsKKwkJZ290byBhYm9ydDsKKwl9CiAJbWRkZXYtPnJlc3luY19tYXhf
c2VjdG9ycyA9IG1kZGV2LT5kZXZfc2VjdG9yczsKIAogCWlmIChtZGRldi0+ZGVncmFkZWQg
PiBkaXJ0eV9wYXJpdHlfZGlza3MgJiYKIAkgICAgbWRkZXYtPnJlc3luY19vZmZzZXQgIT0g
TWF4U2VjdG9yKSB7CiAJCWlmICh0ZXN0X2JpdChNRF9IQVNfUFBMLCAmbWRkZXYtPmZsYWdz
KSkKQEAgLTg1MzQsMTAgKzg1NDAsMTIgQEAgc3RhdGljIGludCByYWlkNV9yZXNpemUoc3Ry
dWN0IG1kZGV2ICptZGRldiwgc2VjdG9yX3Qgc2VjdG9ycykKIAlzdHJ1Y3QgcjVjb25mICpj
b25mID0gbWRkZXYtPnByaXZhdGU7CiAKIAlpZiAocmFpZDVfaGFzX2xvZyhjb25mKSB8fCBy
YWlkNV9oYXNfcHBsKGNvbmYpKQogCQlyZXR1cm4gLUVJTlZBTDsKIAlzZWN0b3JzICY9IH4o
KHNlY3Rvcl90KWNvbmYtPmNodW5rX3NlY3RvcnMgLSAxKTsKKwlpZiAoIXNlY3RvcnMpCisJ
CXJldHVybiAtRUlOVkFMOwogCW5ld3NpemUgPSByYWlkNV9zaXplKG1kZGV2LCBzZWN0b3Jz
LCBtZGRldi0+cmFpZF9kaXNrcyk7CiAJaWYgKG1kZGV2LT5leHRlcm5hbF9zaXplICYmCiAJ
ICAgIG1kZGV2LT5hcnJheV9zZWN0b3JzID4gbmV3c2l6ZSkKIAkJcmV0dXJuIC1FSU5WQUw7
CiAKLS0gCjIuNTIuMAoK

--------------0TbVc74WCPylTs0L87bUxMfY--

