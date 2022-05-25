Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1767C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 25 May 2022 09:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiEYJRw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 May 2022 05:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiEYJRs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 May 2022 05:17:48 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8707CB0E
        for <linux-raid@vger.kernel.org>; Wed, 25 May 2022 02:17:46 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653470264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nC0xQTz5lOIuXnMuBUbvxDMJy20a3RPV4Wh0iawdFbQ=;
        b=cjyY5JnNQE61XVZbVXi1JYEmLtgj838ZBNL9n5fefWWFunwCQGrjYg/oHiSZxhN3wt0T1j
        vF1LANk2Qc2FhJEy5lACDBEZ7bK6P/WdH7RzgQ2mVBZ10JAB5CZsNYKatUBUxtDoWvMoFS
        Uw/rJ26I71H7Oz9j4WWK5UyZV20mtu8=
To:     Donald Buczek <buczek@molgen.mpg.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <c18083ea-e2dd-a90b-8ff4-bb61250b9211@linux.dev>
Date:   Wed, 25 May 2022 17:17:41 +0800
MIME-Version: 1.0
In-Reply-To: <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/23/22 1:41 PM, Donald Buczek wrote:
>>>
>>> [   57.434064] md: md0 stopped.
>>> [   57.586951] md0: detected capacity change from 0 to 107520
>>> [   57.618454] BUG: kernel NULL pointer dereference, address: 
>>> 0000000000000094
>>> [   57.620830] #PF: supervisor read access in kernel mode
>>> [   57.622554] #PF: error_code(0x0000) - not-present page
>>> [   57.624273] PGD 800000010d5ee067 P4D 800000010d5ee067 PUD 
>>> 10df28067 PMD 0
>>> [   57.626548] Oops: 0000 [#1] PREEMPT SMP PTI
>>> [   57.627942] CPU: 3 PID: 1064 Comm: mkfs.ext3 Not tainted 
>>> 5.18.0-rc3.mx64.425-00108-g6ad84d559b8c #77
>>> [   57.630952] Hardware name: QEMU Standard PC (i440FX + PIIX, 
>>> 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
>>> [   57.635927] RIP: 0010:bfq_bio_bfqg+0x26/0x80
>>> [   57.638027] Code: 00 0f 1f 00 0f 1f 44 00 00 55 53 48 89 fd 48 8b 
>>> 56 48 48 89 f7 48 85 d2 74 32 48 63 05 53 54 1c 01 48 83 c0 16 48 8b 
>>> 5c c2 08 <80> bb 94 00 00 00 00 70
>>> [   57.645295] RSP: 0018:ffffc90001c27b38 EFLAGS: 00010006
>>> [   57.647414] RAX: 0000000000000018 RBX: 0000000000000000 RCX: 
>>> 0000000000000001
>>> [   57.650039] RDX: ffff888109297800 RSI: ffff8881032ba180 RDI: 
>>> ffff8881032ba180
>>> [   57.652541] RBP: ffff888102177800 R08: ffff88810c9004c8 R09: 
>>> ffff88810318cb00
>>> [   57.654852] R10: 0000000000000000 R11: ffff8881032ba180 R12: 
>>> ffff88810318cae0
>>> [   57.657128] R13: ffff888102177800 R14: ffffc90001c27ca8 R15: 
>>> ffffc90001c27c00
>>> [   57.659316] FS:  00007fdfce47d440(0000) GS:ffff8882b5ac0000(0000) 
>>> knlGS:0000000000000000
>>> [   57.661700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   57.663461] CR2: 0000000000000094 CR3: 000000010d438002 CR4: 
>>> 0000000000170ee0
>>> [   57.665453] Call Trace:
>>> [   57.666479]  <TASK>
>>> [   57.667382]  bfq_bic_update_cgroup+0x28/0x1b0
>>> [   57.668724]  bfq_insert_requests+0x233/0x2340
>>> [   57.670049]  ? ioc_find_get_icq+0x21c/0x2a0
>>> [   57.671315]  ? bfq_prepare_request+0x11/0x30
>>> [   57.672565]  blk_mq_sched_insert_requests+0x5c/0x150
>>> [   57.673891]  blk_mq_flush_plug_list+0xe1/0x2a0
>>> [   57.675140]  __blk_flush_plug+0xdf/0x120
>>> [   57.676259]  io_schedule_prepare+0x3d/0x50
>>> [   57.677373]  io_schedule_timeout+0xf/0x40
>>> [   57.678465]  wait_for_completion_io+0x78/0x140
>>> [   57.679578]  submit_bio_wait+0x5b/0x80
>>> [   57.680575]  blkdev_issue_discard+0x65/0xb0
>>> [   57.681640]  blkdev_common_ioctl+0x391/0x8f0
>>> [   57.682712]  blkdev_ioctl+0x216/0x2a0
>>> [   57.683648]  __x64_sys_ioctl+0x76/0xb0
>>> [   57.684607]  do_syscall_64+0x42/0x90
>>> [   57.685527]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> [   57.686645] RIP: 0033:0x7fdfce56dc17
>>> [   57.687535] Code: 48 c7 c3 ff ff ff ff 48 89 d8 5b 5d 41 5c c3 0f 
>>> 1f 40 00 48 89 e8 48 f7 d8 48 39 c3 0f 92 c0 eb 93 66 90 b8 10 00 00 
>>> 00 0f 05 <48> 3d 01 f0 ff ff 73 08
>>> [   57.691055] RSP: 002b:00007ffe24319828 EFLAGS: 00000246 ORIG_RAX: 
>>> 0000000000000010
>>> [   57.692537] RAX: ffffffffffffffda RBX: 00000000004645a0 RCX: 
>>> 00007fdfce56dc17
>>> [   57.693905] RDX: 00007ffe24319830 RSI: 0000000000001277 RDI: 
>>> 0000000000000003
>>> [   57.695288] RBP: 0000000000460960 R08: 0000000000000400 R09: 
>>> 0000000000000000
>>> [   57.696645] R10: 0000000000000000 R11: 0000000000000246 R12: 
>>> 0000000000000000
>>> [   57.697954] R13: 000000000000d200 R14: 0000000000000000 R15: 
>>> 0000000000000000
>>> [   57.699281]  </TASK>
>>> [   57.699901] Modules linked in: rpcsec_gss_krb5 nfsv4 nfs 8021q 
>>> garp stp mrp llc bochs drm_vram_helper drm_ttm_helper kvm_intel ttm 
>>> drm_kms_helper kvm drm fb_sys_fops vi4
>>> [   57.705955] CR2: 0000000000000094
>>> [   57.706710] ---[ end trace 0000000000000000 ]---
>>> [   57.707599] RIP: 0010:bfq_bio_bfqg+0x26/0x80
>>> [   57.708434] Code: 00 0f 1f 00 0f 1f 44 00 00 55 53 48 89 fd 48 8b 
>>> 56 48 48 89 f7 48 85 d2 74 32 48 63 05 53 54 1c 01 48 83 c0 16 48 8b 
>>> 5c c2 08 <80> bb 94 00 00 00 00 70
>>> [   57.711426] RSP: 0018:ffffc90001c27b38 EFLAGS: 00010006
>>> [   57.712391] RAX: 0000000000000018 RBX: 0000000000000000 RCX: 
>>> 0000000000000001
>>> [   57.713605] RDX: ffff888109297800 RSI: ffff8881032ba180 RDI: 
>>> ffff8881032ba180
>>> [   57.714811] RBP: ffff888102177800 R08: ffff88810c9004c8 R09: 
>>> ffff88810318cb00
>>> [   57.716018] R10: 0000000000000000 R11: ffff8881032ba180 R12: 
>>> ffff88810318cae0
>>> [   57.717236] R13: ffff888102177800 R14: ffffc90001c27ca8 R15: 
>>> ffffc90001c27c00
>>> [   57.718438] FS:  00007fdfce47d440(0000) GS:ffff8882b5ac0000(0000) 
>>> knlGS:0000000000000000
>>> [   57.719778] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   57.720808] CR2: 0000000000000094 CR3: 000000010d438002 CR4: 
>>> 0000000000170ee0
>>> [   57.722019] note: mkfs.ext3[1064] exited with preempt_count 1
>>> [   57.723067] ------------[ cut here ]------------
>>> [   57.723960] WARNING: CPU: 3 PID: 1064 at kernel/exit.c:741 
>>> do_exit+0x8cb/0xbc0
>>> [   57.725196] Modules linked in: rpcsec_gss_krb5 nfsv4 nfs 8021q 
>>> garp stp mrp llc bochs drm_vram_helper drm_ttm_helper kvm_intel ttm 
>>> drm_kms_helper kvm drm fb_sys_fops vi4
>>> [   57.731011] CPU: 3 PID: 1064 Comm: mkfs.ext3 Tainted: G D 
>>> 5.18.0-rc3.mx64.425-00108-g6ad84d559b8c #77
>>> [   57.732704] Hardware name: QEMU Standard PC (i440FX + PIIX, 
>>> 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
>>> [   57.734853] RIP: 0010:do_exit+0x8cb/0xbc0
>>> [   57.735711] Code: e9 13 ff ff ff 48 8b bb e0 04 00 00 31 f6 e8 4c 
>>> db ff ff e9 98 fd ff ff 4c 89 e6 bf 05 06 00 00 e8 8a c8 00 00 e9 41 
>>> f8 ff ff <0f> 0b e9 6b f7 ff ff 4b
>>> [   57.738851] RSP: 0018:ffffc90001c27ee8 EFLAGS: 00010082
>>> [   57.739899] RAX: 0000000000000000 RBX: ffff888101e48000 RCX: 
>>> 0000000000000000
>>> [   57.741196] RDX: 0000000000000001 RSI: ffffffff8220a969 RDI: 
>>> 0000000000000009
>>> [   57.742485] RBP: 0000000000000009 R08: 0000000000000000 R09: 
>>> c0000000ffffbfff
>>> [   57.743777] R10: 00007fdfce47d440 R11: ffffc90001c27d60 R12: 
>>> 0000000000000009
>>> [   57.745081] R13: 0000000000000046 R14: 0000000000000000 R15: 
>>> 0000000000000000
>>> [   57.746388] FS:  00007fdfce47d440(0000) GS:ffff8882b5ac0000(0000) 
>>> knlGS:0000000000000000
>>> [   57.747806] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   57.748931] CR2: 0000000000000094 CR3: 000000010d438002 CR4: 
>>> 0000000000170ee0
>>> [   57.750225] Call Trace:
>>> [   57.750894]  <TASK>
>>> [   57.751535]  make_task_dead+0x41/0xf0
>>> [   57.752369]  rewind_stack_and_make_dead+0x17/0x17
>>> [   57.753336] RIP: 0033:0x7fdfce56dc17
>>> [   57.754155] Code: 48 c7 c3 ff ff ff ff 48 89 d8 5b 5d 41 5c c3 0f 
>>> 1f 40 00 48 89 e8 48 f7 d8 48 39 c3 0f 92 c0 eb 93 66 90 b8 10 00 00 
>>> 00 0f 05 <48> 3d 01 f0 ff ff 73 08
>>> [   57.757318] RSP: 002b:00007ffe24319828 EFLAGS: 00000246 ORIG_RAX: 
>>> 0000000000000010
>>> [   57.758669] RAX: ffffffffffffffda RBX: 00000000004645a0 RCX: 
>>> 00007fdfce56dc17
>>> [   57.759956] RDX: 00007ffe24319830 RSI: 0000000000001277 RDI: 
>>> 0000000000000003
>>> [   57.761256] RBP: 0000000000460960 R08: 0000000000000400 R09: 
>>> 0000000000000000
>>> [   57.762531] R10: 0000000000000000 R11: 0000000000000246 R12: 
>>> 0000000000000000
>>> [   57.763806] R13: 000000000000d200 R14: 0000000000000000 R15: 
>>> 0000000000000000
>>> [   57.765177]  </TASK>
>>> [   57.765813] ---[ end trace 0000000000000000 ]---
>>> [   57.790046] md0: detected capacity change from 107520 to 0
>>> [   57.792834] md: md0 stopped.
>>> [   78.843853] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>>> [   78.845334] rcu:     10-...0: (0 ticks this GP) 
>>> idle=07b/1/0x4000000000000000 softirq=1140/1140 fqs=4805
>>> [   78.847246]     (detected by 13, t=21005 jiffies, g=9013, q=1419)
>>> [   78.848619] Sending NMI from CPU 13 to CPUs 10:
>>> [   78.849810] NMI backtrace for cpu 10
>>> [   78.849813] CPU: 10 PID: 1081 Comm: mdadm Tainted: G      D 
>>> W         5.18.0-rc3.mx64.425-00108-g6ad84d559b8c #77
>>> [   78.849816] Hardware name: QEMU Standard PC (i440FX + PIIX, 
>>> 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
>>> [   78.849817] RIP: 0010:queued_spin_lock_slowpath+0x4c/0x1d0
>>> [   78.849832] Code: 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 e4 09 d0 
>>> a9 00 01 ff ff 75 1b 85 c0 75 0f b8 01 00 00 00 66 89 07 5b 5d 41 5c 
>>> c3 f3 90 <8b> 07 84 c0 75 f8 eb e7
>>> [   78.849834] RSP: 0018:ffffc90001c9f9e0 EFLAGS: 00000002
>>> [   78.849837] RAX: 0000000000040101 RBX: ffff88810c914fc8 RCX: 
>>> 0000000000000000
>>> [   78.849838] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
>>> ffff888102177c30
>>> [   78.849840] RBP: 0000000000000000 R08: ffff88810c914fc8 R09: 
>>> ffff888106a4ed10
>>> [   78.849841] R10: ffffc90001c9fae8 R11: ffff888101b048d8 R12: 
>>> ffff888103833000
>>> [   78.849842] R13: ffff888102177800 R14: ffffc90001c9fb20 R15: 
>>> ffffc90001c9fa78
>>> [   78.849844] FS:  00007fd3d66c4340(0000) GS:ffff8882b5c80000(0000) 
>>> knlGS:0000000000000000
>>> [   78.849847] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   78.849848] CR2: 00000000004a5b58 CR3: 000000010d438001 CR4: 
>>> 0000000000170ee0
>>> [   78.849850] Call Trace:
>>> [   78.849853]  <TASK>
>>> [   78.849855]  bfq_insert_requests+0xae/0x2340
>>> [   78.849862]  ? submit_bio_noacct_nocheck+0x225/0x2b0
>>> [   78.849868]  blk_mq_sched_insert_requests+0x5c/0x150
>>> [   78.849872]  blk_mq_flush_plug_list+0xe1/0x2a0
>>> [   78.849876]  __blk_flush_plug+0xdf/0x120
>>> [   78.849879]  blk_finish_plug+0x27/0x40
>>> [   78.849882]  read_pages+0x15b/0x360
>>> [   78.849891]  page_cache_ra_unbounded+0x120/0x170
>>> [   78.849894]  filemap_get_pages+0xdd/0x5f0
>>> [   78.849899]  filemap_read+0xbf/0x350
>>> [   78.849902]  ? __mod_memcg_lruvec_state+0x72/0xc0
>>> [   78.849907]  ? __mod_lruvec_page_state+0xb4/0x160
>>> [   78.849909]  ? folio_add_lru+0x51/0x80
>>> [   78.849912]  ? _raw_spin_unlock+0x12/0x30
>>> [   78.849916]  ? __handle_mm_fault+0xdee/0x14d0
>>> [   78.849921]  blkdev_read_iter+0xa9/0x180
>>> [   78.849924]  new_sync_read+0x109/0x180
>>> [   78.849929]  vfs_read+0x187/0x1b0
>>> [   78.849932]  ksys_read+0xa1/0xe0
>>> [   78.849935]  do_syscall_64+0x42/0x90
>>> [   78.849938]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> [   78.849941] RIP: 0033:0x7fd3d6322f8e
>>> [   78.849944] Code: c0 e9 c6 fe ff ff 48 8d 3d a7 07 0a 00 48 83 ec 
>>> 08 e8 b6 e1 01 00 66 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 
>>> 14 0f 05 <48> 3d 00 f0 ff ff 77 59
>>> [   78.849945] RSP: 002b:00007ffe92d46ea8 EFLAGS: 00000246 ORIG_RAX: 
>>> 0000000000000000
>>> [   78.849948] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
>>> 00007fd3d6322f8e
>>> [   78.849949] RDX: 0000000000001000 RSI: 00000000004a3000 RDI: 
>>> 0000000000000003
>>> [   78.849950] RBP: 0000000000000003 R08: 00000000004a3000 R09: 
>>> 0000000000000003
>>> [   78.849951] R10: 00007fd3d623d0a8 R11: 0000000000000246 R12: 
>>> 00000000004a2a60
>>> [   78.849952] R13: 0000000000000000 R14: 00000000004a3000 R15: 
>>> 000000000048a4a0
>>> [   78.849954]  </TASK>
>>
>> Looks like bfq or block issue, will try it from my side.

Hmm, it could be md specific issue because I find below stack after 
similar call trace happened

vm79:~> ps aux|grep "\[md"|grep D|awk '{print $2}'
2087
vm79:~> sudo cat /proc/2087/stack
[<0>] raid1_sync_request+0x65e/0xb60 [raid1]
[<0>] md_do_sync+0xa13/0xf50 [md_mod]
[<0>] md_thread+0x131/0x180 [md_mod]
[<0>] kthread+0xe8/0x110
[<0>] ret_from_fork+0x22/0x30

Donald, could you share the md process stack when you see the call trace?

Thanks,
Guoqing
