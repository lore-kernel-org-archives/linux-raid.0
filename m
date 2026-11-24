Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483712;
	b=qussaVCI/SLXesGhpaNU7jTYlQmV1Bv6/tRLVFISVKJimYGtNmcl5Wdq5rYAIDfKblDk
	 n4qq37MnUZDBu0YFGUAAdat3WVz9sKQlZGOH1Dlh2lrAykc6K9CJCatnnSlUC/n6pezrP
	 IprHUNTwacAG+Mg6Sn0DMEwKZTnAPkRtApxzhRhq8YlheyrE1AjeoA0WpS7I649u1tLQ2
	 2GpO7K+Gg27wevXWivvCpCt07vLadTWF3pEPaNRVTt0Q/zk0tDQWahzSdvTIm985qsSag
	 a+YYQczOkTJcQYTMEFRi91An42S52TtfX0CdjmTuibf6XVRrgwO+5QFLB3N+q+U5Jpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483712;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=8Ny/ZC2pZ67oXfaYEmRl2IqwvxZB+uhMYs3VW0ASUro=;
	b=tkxAIWPF4WQDswOTP8sslgsJqFJgSA5ofgP7QkVx6u4/xBf+5jePTb6bYJl/3Aq0aX0x
	 w+abdiNCgnTW2KIk41AknvAk7MW6MiOi0VymygFbbqB6X7eVWFE8gnswQcSacSkhWpmvr
	 PGYZDz7g7/7LXCAW6ug/9MZv2trr/V2gafXCqMAbmls2kECavejUHO1vGEK5xYD6wHiId
	 bHOtyDncxhGUqs5+u+evWjoyoFWFFtt9zX/cub7myvxns3HJU3l8djAY82MjCVEaQzGN5
	 YcTWW6V2W2iIVaR9qjLdvDC7rgpnlPx21YL6q0oM+sT1uPzJCz48p+76/af6a8hUuYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EAF606A32E
	for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2026 01:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41EAF606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-55bf11583d9so4145607b6e.1
        for <linux-raid@vger.kernel.org>; Mon, 23 Nov 2026 17:28:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795483711; x=1796088511;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Ny/ZC2pZ67oXfaYEmRl2IqwvxZB+uhMYs3VW0ASUro=;
        b=dzTlMJh9iWDZpipbx4Z/ckv+ZgvbbL7N+MtHPMV7CFx4N610ls2O7z5XcFNqXOuCEV
         jtEPX6CIBU2KjtLkDIm7zPhptAUnrHyg0ygcFsm/f+GVWf9vAyevDNcstok31rBVP3LV
         vmjS8GUiWeUHQQnwlxsHdmrsTvFACA73tGblJ3O+o3q8NAUol1FrYReCkN/u7bXchVLM
         HmpnLfFG76jiO/iA1Sqs9rliIBoMPyFRU73rGAz4OdLuyP2dci/01mxuxdxLfbP/qiIJ
         74WHq7wot25l4TfDr51+X4dajXe5x50tGkcb94TPafpbEdCIzlsJV7RhBw5BAArnhva4
         o9Hg==
X-Forwarded-Encrypted: i=1; AL+hErGzx1LUDRfPfTz+AIEQB2/M0wWvgaIxHTIORW/lkkqw3UEDFq7xQ6eLNqaL7DREZIuzSLjMvunqQZeU@vger.kernel.org
X-Gm-Message-State: APuU4Z8IrmU0mxDIoty6yzFmfTAzYOcPY6cayZRV8bSJCmY0beuNeyWm
	TWrgO+zKjUWWI7QUsKape0hTMXQjB4S0y8DEKuvMz0Sk8/QVYpDmVTxMQcZ3Cflcw4Nfa2NiOSu
	FE0S07IPR77TXyienQTa04JvboouX/udSeP6qbPrgUe8FAPpuPa5mpR6Ckdc=
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6b8e:b0:521:561a:8e8c with SMTP id
 5614622812f47-5797d6add74mr10123744b6e.33.1795483711216; Mon, 23 Nov 2026
 17:28:31 -0800 (PST)
Date: Mon, 23 Nov 2026 17:28:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b04e83f.9a2182b0.37b108.0036.GAE@google.com>
Subject: [syzbot] [raid?] KASAN: slab-use-after-free Read in mddev_unlock
From: syzbot <syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	magiclinan@didiglobal.com, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	xiao@kernel.org, xni@redhat.com, yukuai3@huawei.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4405c18c95d2 Merge tag 'mm-nonmm-hotfixes-stable-2026-11-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1346e803580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=58beac388fb46ea52592
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fadfa8ddb6dc/disk-4405c18c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b709babe0a48/vmlinux-4405c18c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a837f4b1ee01/bzImage-4405c18c.xz

The issue was bisected by AI to:

commit db5e653d7c9fae8ed61da58ab5e9a8db2cd61a2b
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Fri Aug 25 03:16:18 2023 +0000

    md: delay choosing sync action to md_start_sync()

AI reasoning:   https://syzkaller.appspot.com/ai_job?id=bc5d8ea1-cd26-4470-b538-405195b1bbbf

AI-generated root cause summary:
In `drivers/md/md.c`, `md_check_recovery()` queues `mddev->sync_work`
(`md_start_sync()`) on `md_misc_wq` without taking a reference on `mddev`, and
`mddev` teardown fails to wait for `md_start_sync()` to finish before freeing
`mddev`. Specifically, `stop_sync_thread()` skips flushing `sync_work` when
`MD_RECOVERY_RUNNING` is already cleared or when `md_start_sync()` is already
running (`work_pending(&mddev->sync_work)` returns false), and `md_start_sync()`
clears `MD_RECOVERY_RUNNING` before calling `mddev_unlock()`. Once
`mddev_unlock()` releases `mddev->reconfig_mutex`, `do_md_stop()` can
immediately proceed to stop and clean the array, allowing `mddev_put()` ->
`mddev_delayed_delete()` -> `md_kobj_release()` -> `disk_release()` ->
`mddev_free()` to `kfree(mddev)` concurrently while `md_start_sync()` is still
inside `mddev_unlock()`, causing a slab-use-after-free when reading
`mddev->thread`.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=58beac388fb46ea52592

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com

The cause commit was identified by AI and may be wrong.
If you agree with it, please also add:
Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")

==================================================================
BUG: KASAN: slab-use-after-free in mddev_unlock+0x909/0x9e0 drivers/md/md.c:977
Read of size 8 at addr ffff8880367b21e8 by task kworker/1:2/1568

CPU: 1 UID: 0 PID: 1568 Comm: kworker/1:2 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
Workqueue: md_misc md_start_sync
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 mddev_unlock+0x909/0x9e0 drivers/md/md.c:977
 md_start_sync+0x681/0xea0 drivers/md/md.c:10373
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 9718:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x40 mm/kasan/common.c:79
 poison_kmalloc_redzone mm/kasan/common.c:412 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:429
 kasan_kmalloc include/linux/kasan.h:267 [inline]
 __kmalloc_cache_noprof+0x2f8/0x6d0 mm/slub.c:5680
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 mddev_alloc drivers/md/md.c:877 [inline]
 md_alloc+0xae/0x10c0 drivers/md/md.c:6356
 md_alloc_and_put drivers/md/md.c:6452 [inline]
 md_probe drivers/md/md.c:6468 [inline]
 md_probe+0x73/0xf0 drivers/md/md.c:6463
 blk_probe_dev+0x149/0x1e0 block/genhd.c:888
 blk_request_module+0x16/0xc0 block/genhd.c:901
 blkdev_get_no_open+0x9b/0xf0 block/bdev.c:870
 blkdev_open+0x141/0x4f0 block/fops.c:673
 do_dentry_open+0x674/0x1470 fs/open.c:1000
 vfs_open_consume+0xcc/0x460 fs/open.c:1131
 do_open fs/namei.c:4851 [inline]
 path_openat+0x1547/0x23f0 fs/namei.c:5016
 do_file_open+0x20e/0x430 fs/namei.c:5045
 do_sys_openat2+0x163/0x1d0 fs/open.c:1443
 do_sys_open fs/open.c:1449 [inline]
 __do_sys_openat fs/open.c:1465 [inline]
 __se_sys_openat fs/open.c:1460 [inline]
 __x64_sys_openat+0x12d/0x210 fs/open.c:1460
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x7b0 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5627:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x40 mm/kasan/common.c:79
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:599
 poison_slab_object mm/kasan/common.c:267 [inline]
 __kasan_slab_free+0x73/0x90 mm/kasan/common.c:299
 kasan_slab_free include/linux/kasan.h:239 [inline]
 slab_free_hook mm/slub.c:2780 [inline]
 slab_free mm/slub.c:6637 [inline]
 kfree+0x22d/0x6d0 mm/slub.c:6930
 disk_release+0x2ad/0x490 block/genhd.c:1319
 device_release+0xd2/0x270 drivers/base/core.c:2640
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1f7/0x640 lib/kobject.c:737
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Last potentially related work creation:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 __kasan_record_aux_stack+0xba/0xd0 mm/kasan/generic.c:561
 insert_work+0x36/0x230 kernel/workqueue.c:2356
 __queue_work+0xac1/0x16f0 kernel/workqueue.c:2546
 queue_work_on+0x180/0x1e0 kernel/workqueue.c:2599
 queue_work include/linux/workqueue.h:700 [inline]
 __mddev_put drivers/md/md.c:668 [inline]
 __mddev_put drivers/md/md.c:652 [inline]
 mddev_put.part.0+0x132/0x160 drivers/md/md.c:682
 mddev_put drivers/md/md.c:8659 [inline]
 md_release+0x90/0xb0 drivers/md/md.c:8658
 blkdev_put_whole+0xb0/0xf0 block/bdev.c:766
 bdev_release+0x485/0x6e0 block/bdev.c:1189
 blkdev_release+0x15/0x20 block/fops.c:690
 __fput+0x3fb/0xb50 fs/file_table.c:512
 fput_close_sync+0x118/0x250 fs/file_table.c:618
 filp_close_sync+0x75/0xa0 fs/open.c:1574
 __range_close+0x4a6/0x8b0 fs/file.c:919
 __do_sys_close_range fs/file.c:1003 [inline]
 __se_sys_close_range fs/file.c:954 [inline]
 __x64_sys_close_range+0x1f8/0x430 fs/file.c:954
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x7b0 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Second to last potentially related work creation:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 __kasan_record_aux_stack+0xba/0xd0 mm/kasan/generic.c:561
 insert_work+0x36/0x230 kernel/workqueue.c:2356
 __queue_work+0xac1/0x16f0 kernel/workqueue.c:2546
 queue_work_on+0x180/0x1e0 kernel/workqueue.c:2599
 queue_work include/linux/workqueue.h:700 [inline]
 md_check_recovery+0xbb9/0x1100 drivers/md/md.c:10583
 raid1d+0x114/0x7040 drivers/md/raid1.c:2617
 md_thread+0x550/0x5d0 drivers/md/md.c:8732
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff8880367b2000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 488 bytes inside of
 freed 4096-byte region [ffff8880367b2000, ffff8880367b3000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x367b0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88813ff0e140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88813ff0e140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 144, tgid 144 (kworker/u8:5), ts 201563767110
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1873
 prep_new_page mm/page_alloc.c:1881 [inline]
 get_page_from_freelist+0xdae/0x2c80 mm/page_alloc.c:3963
 __alloc_frozen_pages_noprof+0x2ad/0x31e0 mm/page_alloc.c:5505
 alloc_slab_page mm/slub.c:3384 [inline]
 allocate_slab mm/slub.c:3499 [inline]
 new_slab+0xb1/0x6d0 mm/slub.c:3550
 refill_objects+0xe3/0x410 mm/slub.c:7546
 refill_sheaf mm/slub.c:2917 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4811
 alloc_from_pcs mm/slub.c:4887 [inline]
 slab_alloc_node mm/slub.c:5021 [inline]
 __do_kmalloc_node mm/slub.c:5530 [inline]
 __kmalloc_node_track_caller_noprof+0x6a3/0x870 mm/slub.c:5662
 kmalloc_reserve+0xe8/0x350 net/core/skbuff.c:638
 __alloc_skb+0x185/0x710 net/core/skbuff.c:716
 alloc_skb include/linux/skbuff.h:1390 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:744 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:801 [inline]
 nsim_dev_trap_report_work+0x2af/0xd20 drivers/net/netdevsim/dev.c:847
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
page last free pid 9267 tgid 9267 ts 195396699479 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1415 [inline]
 __free_frozen_pages+0x7b1/0x10f0 mm/page_alloc.c:2971
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x47/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:364
 kasan_slab_alloc include/linux/kasan.h:257 [inline]
 slab_post_alloc_hook mm/slub.c:4720 [inline]
 slab_alloc_node mm/slub.c:5033 [inline]
 kmem_cache_alloc_noprof+0x269/0x6a0 mm/slub.c:5047
 new_handle fs/jbd2/transaction.c:457 [inline]
 jbd2__journal_start+0x194/0x6b0 fs/jbd2/transaction.c:485
 __ext4_journal_start_sb+0x314/0x610 fs/ext4/ext4_jbd2.c:126
 __ext4_journal_start fs/ext4/ext4_jbd2.h:238 [inline]
 ext4_dirty_inode+0xa1/0x130 fs/ext4/inode.c:7650
 __mark_inode_dirty+0x1f3/0x16e0 fs/fs-writeback.c:2751
 generic_update_time fs/inode.c:2274 [inline]
 file_update_time_flags+0x49c/0x520 fs/inode.c:2504
 ext4_page_mkwrite+0x30e/0x19e0 fs/ext4/inode.c:7838
 do_page_mkwrite+0x17a/0x430 mm/memory.c:3908
 do_shared_fault mm/memory.c:6212 [inline]
 do_fault+0x5f8/0x1780 mm/memory.c:6274
 do_pte_missing mm/memory.c:4797 [inline]
 handle_pte_fault mm/memory.c:6689 [inline]
 __handle_mm_fault+0x1858/0x2f40 mm/memory.c:6841
 handle_mm_fault+0x363/0xa30 mm/memory.c:7008
 do_user_addr_fault+0x59c/0x12f0 arch/x86/mm/fault.c:1343

Memory state around the buggy address:
 ffff8880367b2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880367b2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880367b2180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff8880367b2200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880367b2280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about AI bisection see: https://goo.gl/tpsmEJ#ai-bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
