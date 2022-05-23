Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F32AC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 05:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355678AbiEWFlR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 01:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355659AbiEWFlE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 01:41:04 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1553CBBE
        for <linux-raid@vger.kernel.org>; Sun, 22 May 2022 22:41:02 -0700 (PDT)
Received: from [192.168.0.175] (ip5f5aecf9.dynamic.kabel-deutschland.de [95.90.236.249])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8202061EA1928;
        Mon, 23 May 2022 07:41:00 +0200 (CEST)
Message-ID: <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
Date:   Mon, 23 May 2022 07:41:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
From:   Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23.05.22 03:08, Guoqing Jiang wrote:
> 
> 
> On 5/22/22 2:23 AM, Donald Buczek wrote:
>> On 20.05.22 20:27, Logan Gunthorpe wrote:
>>>
>>> Hi,
>>>
>>> On 2022-05-10 00:44, Song Liu wrote:
>>>> On Mon, May 9, 2022 at 1:09 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>>>> On 5/9/22 2:37 PM, Song Liu wrote:
>>>>>> On Fri, May 6, 2022 at 4:37 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
>>>>>>> From: Guoqing Jiang<guoqing.jiang@cloud.ionos.com>
>>>>>>>
>>>>>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>>>>>>> doesn't reconfigure array.
>>>>>>>
>>>>>>> And it could cause deadlock problem for raid5 as follows:
>>>>>>>
>>>>>>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>>>>>>>      idle to sync_action.
>>>>>>> 2. raid5 sync thread was blocked if there were too many active stripes.
>>>>>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>>>>>>>      which causes the number of active stripes can't be decreased.
>>>>>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>>>>>>>      to hold reconfig_mutex.
>>>>>>>
>>>>>>> More details in the link:
>>>>>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>>>>>>>
>>>>>>> Let's call unregister thread between mddev_unlock and mddev_lock_nointr
>>>>>>> (thanks for the report from kernel test robot<lkp@intel.com>) if the
>>>>>>> reconfig_mutex is held, and mddev_is_locked is introduced accordingly.
>>>>>> mddev_is_locked() feels really hacky to me. It cannot tell whether
>>>>>> mddev is locked
>>>>>> by current thread. So technically, we can unlock reconfigure_mutex for
>>>>>> other thread
>>>>>> by accident, no?
>>>>>
>>>>> I can switch back to V2 if you think that is the correct way to do though no
>>>>> one comment about the change in dm-raid.
>>>>
>>>> I guess v2 is the best at the moment. I pushed a slightly modified v2 to
>>>> md-next.
>>>>
>>>
>>> I noticed a clear regression with mdadm tests with this patch in md-next
>>> (7e6ba434cc6080).
>>>
>>> Before the patch, tests 07reshape5intr and 07revert-grow would fail
>>> fairly infrequently (about 1 in 4 runs for the former and 1 in 30 runs
>>> for the latter).
>>>
>>> After this patch, both tests always fail.
>>>
>>> I don't have time to dig into why this is, but it would be nice if
>>> someone can at least fix the regression. It is hard to make any progress
>>> on these tests if we are continuing to further break them.
>>
>> Hmmm. I wanted to try to help a bit by reproducing and digging into this.
>>
>> But it seems that more or less ALL tests hang my system one way or another.
>>
>> I've used a qemu/kvm machine with md-next and mdraid master.
>>
>> Is this supposed to work?
>>
>> I can investigate the bugs I see, but probably that is a waste of time because I'm doing something wrong fundamentally?
>>
>> This is an example from 00raid0:
>>
>> [   57.434064] md: md0 stopped.
>> [   57.586951] md0: detected capacity change from 0 to 107520
>> [   57.618454] BUG: kernel NULL pointer dereference, address: 0000000000000094
>> [   57.620830] #PF: supervisor read access in kernel mode
>> [   57.622554] #PF: error_code(0x0000) - not-present page
>> [   57.624273] PGD 800000010d5ee067 P4D 800000010d5ee067 PUD 10df28067 PMD 0
>> [   57.626548] Oops: 0000 [#1] PREEMPT SMP PTI
>> [   57.627942] CPU: 3 PID: 1064 Comm: mkfs.ext3 Not tainted 5.18.0-rc3.mx64.425-00108-g6ad84d559b8c #77
>> [   57.630952] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
>> [   57.635927] RIP: 0010:bfq_bio_bfqg+0x26/0x80
>> [   57.638027] Code: 00 0f 1f 00 0f 1f 44 00 00 55 53 48 89 fd 48 8b 56 48 48 89 f7 48 85 d2 74 32 48 63 05 53 54 1c 01 48 83 c0 16 48 8b 5c c2 08 <80> bb 94 00 00 00 00 70
>> [   57.645295] RSP: 0018:ffffc90001c27b38 EFLAGS: 00010006
>> [   57.647414] RAX: 0000000000000018 RBX: 0000000000000000 RCX: 0000000000000001
>> [   57.650039] RDX: ffff888109297800 RSI: ffff8881032ba180 RDI: ffff8881032ba180
>> [   57.652541] RBP: ffff888102177800 R08: ffff88810c9004c8 R09: ffff88810318cb00
>> [   57.654852] R10: 0000000000000000 R11: ffff8881032ba180 R12: ffff88810318cae0
>> [   57.657128] R13: ffff888102177800 R14: ffffc90001c27ca8 R15: ffffc90001c27c00
>> [   57.659316] FS:  00007fdfce47d440(0000) GS:ffff8882b5ac0000(0000) knlGS:0000000000000000
>> [   57.661700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   57.663461] CR2: 0000000000000094 CR3: 000000010d438002 CR4: 0000000000170ee0
>> [   57.665453] Call Trace:
>> [   57.666479]  <TASK>
>> [   57.667382]  bfq_bic_update_cgroup+0x28/0x1b0
>> [   57.668724]  bfq_insert_requests+0x233/0x2340
>> [   57.670049]  ? ioc_find_get_icq+0x21c/0x2a0
>> [   57.671315]  ? bfq_prepare_request+0x11/0x30
>> [   57.672565]  blk_mq_sched_insert_requests+0x5c/0x150
>> [   57.673891]  blk_mq_flush_plug_list+0xe1/0x2a0
>> [   57.675140]  __blk_flush_plug+0xdf/0x120
>> [   57.676259]  io_schedule_prepare+0x3d/0x50
>> [   57.677373]  io_schedule_timeout+0xf/0x40
>> [   57.678465]  wait_for_completion_io+0x78/0x140
>> [   57.679578]  submit_bio_wait+0x5b/0x80
>> [   57.680575]  blkdev_issue_discard+0x65/0xb0
>> [   57.681640]  blkdev_common_ioctl+0x391/0x8f0
>> [   57.682712]  blkdev_ioctl+0x216/0x2a0
>> [   57.683648]  __x64_sys_ioctl+0x76/0xb0
>> [   57.684607]  do_syscall_64+0x42/0x90
>> [   57.685527]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [   57.686645] RIP: 0033:0x7fdfce56dc17
>> [   57.687535] Code: 48 c7 c3 ff ff ff ff 48 89 d8 5b 5d 41 5c c3 0f 1f 40 00 48 89 e8 48 f7 d8 48 39 c3 0f 92 c0 eb 93 66 90 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 08
>> [   57.691055] RSP: 002b:00007ffe24319828 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> [   57.692537] RAX: ffffffffffffffda RBX: 00000000004645a0 RCX: 00007fdfce56dc17
>> [   57.693905] RDX: 00007ffe24319830 RSI: 0000000000001277 RDI: 0000000000000003
>> [   57.695288] RBP: 0000000000460960 R08: 0000000000000400 R09: 0000000000000000
>> [   57.696645] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> [   57.697954] R13: 000000000000d200 R14: 0000000000000000 R15: 0000000000000000
>> [   57.699281]  </TASK>
>> [   57.699901] Modules linked in: rpcsec_gss_krb5 nfsv4 nfs 8021q garp stp mrp llc bochs drm_vram_helper drm_ttm_helper kvm_intel ttm drm_kms_helper kvm drm fb_sys_fops vi4
>> [   57.705955] CR2: 0000000000000094
>> [   57.706710] ---[ end trace 0000000000000000 ]---
>> [   57.707599] RIP: 0010:bfq_bio_bfqg+0x26/0x80
>> [   57.708434] Code: 00 0f 1f 00 0f 1f 44 00 00 55 53 48 89 fd 48 8b 56 48 48 89 f7 48 85 d2 74 32 48 63 05 53 54 1c 01 48 83 c0 16 48 8b 5c c2 08 <80> bb 94 00 00 00 00 70
>> [   57.711426] RSP: 0018:ffffc90001c27b38 EFLAGS: 00010006
>> [   57.712391] RAX: 0000000000000018 RBX: 0000000000000000 RCX: 0000000000000001
>> [   57.713605] RDX: ffff888109297800 RSI: ffff8881032ba180 RDI: ffff8881032ba180
>> [   57.714811] RBP: ffff888102177800 R08: ffff88810c9004c8 R09: ffff88810318cb00
>> [   57.716018] R10: 0000000000000000 R11: ffff8881032ba180 R12: ffff88810318cae0
>> [   57.717236] R13: ffff888102177800 R14: ffffc90001c27ca8 R15: ffffc90001c27c00
>> [   57.718438] FS:  00007fdfce47d440(0000) GS:ffff8882b5ac0000(0000) knlGS:0000000000000000
>> [   57.719778] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   57.720808] CR2: 0000000000000094 CR3: 000000010d438002 CR4: 0000000000170ee0
>> [   57.722019] note: mkfs.ext3[1064] exited with preempt_count 1
>> [   57.723067] ------------[ cut here ]------------
>> [   57.723960] WARNING: CPU: 3 PID: 1064 at kernel/exit.c:741 do_exit+0x8cb/0xbc0
>> [   57.725196] Modules linked in: rpcsec_gss_krb5 nfsv4 nfs 8021q garp stp mrp llc bochs drm_vram_helper drm_ttm_helper kvm_intel ttm drm_kms_helper kvm drm fb_sys_fops vi4
>> [   57.731011] CPU: 3 PID: 1064 Comm: mkfs.ext3 Tainted: G D 5.18.0-rc3.mx64.425-00108-g6ad84d559b8c #77
>> [   57.732704] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
>> [   57.734853] RIP: 0010:do_exit+0x8cb/0xbc0
>> [   57.735711] Code: e9 13 ff ff ff 48 8b bb e0 04 00 00 31 f6 e8 4c db ff ff e9 98 fd ff ff 4c 89 e6 bf 05 06 00 00 e8 8a c8 00 00 e9 41 f8 ff ff <0f> 0b e9 6b f7 ff ff 4b
>> [   57.738851] RSP: 0018:ffffc90001c27ee8 EFLAGS: 00010082
>> [   57.739899] RAX: 0000000000000000 RBX: ffff888101e48000 RCX: 0000000000000000
>> [   57.741196] RDX: 0000000000000001 RSI: ffffffff8220a969 RDI: 0000000000000009
>> [   57.742485] RBP: 0000000000000009 R08: 0000000000000000 R09: c0000000ffffbfff
>> [   57.743777] R10: 00007fdfce47d440 R11: ffffc90001c27d60 R12: 0000000000000009
>> [   57.745081] R13: 0000000000000046 R14: 0000000000000000 R15: 0000000000000000
>> [   57.746388] FS:  00007fdfce47d440(0000) GS:ffff8882b5ac0000(0000) knlGS:0000000000000000
>> [   57.747806] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   57.748931] CR2: 0000000000000094 CR3: 000000010d438002 CR4: 0000000000170ee0
>> [   57.750225] Call Trace:
>> [   57.750894]  <TASK>
>> [   57.751535]  make_task_dead+0x41/0xf0
>> [   57.752369]  rewind_stack_and_make_dead+0x17/0x17
>> [   57.753336] RIP: 0033:0x7fdfce56dc17
>> [   57.754155] Code: 48 c7 c3 ff ff ff ff 48 89 d8 5b 5d 41 5c c3 0f 1f 40 00 48 89 e8 48 f7 d8 48 39 c3 0f 92 c0 eb 93 66 90 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 08
>> [   57.757318] RSP: 002b:00007ffe24319828 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> [   57.758669] RAX: ffffffffffffffda RBX: 00000000004645a0 RCX: 00007fdfce56dc17
>> [   57.759956] RDX: 00007ffe24319830 RSI: 0000000000001277 RDI: 0000000000000003
>> [   57.761256] RBP: 0000000000460960 R08: 0000000000000400 R09: 0000000000000000
>> [   57.762531] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> [   57.763806] R13: 000000000000d200 R14: 0000000000000000 R15: 0000000000000000
>> [   57.765177]  </TASK>
>> [   57.765813] ---[ end trace 0000000000000000 ]---
>> [   57.790046] md0: detected capacity change from 107520 to 0
>> [   57.792834] md: md0 stopped.
>> [   78.843853] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>> [   78.845334] rcu:     10-...0: (0 ticks this GP) idle=07b/1/0x4000000000000000 softirq=1140/1140 fqs=4805
>> [   78.847246]     (detected by 13, t=21005 jiffies, g=9013, q=1419)
>> [   78.848619] Sending NMI from CPU 13 to CPUs 10:
>> [   78.849810] NMI backtrace for cpu 10
>> [   78.849813] CPU: 10 PID: 1081 Comm: mdadm Tainted: G      D W         5.18.0-rc3.mx64.425-00108-g6ad84d559b8c #77
>> [   78.849816] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
>> [   78.849817] RIP: 0010:queued_spin_lock_slowpath+0x4c/0x1d0
>> [   78.849832] Code: 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 e4 09 d0 a9 00 01 ff ff 75 1b 85 c0 75 0f b8 01 00 00 00 66 89 07 5b 5d 41 5c c3 f3 90 <8b> 07 84 c0 75 f8 eb e7
>> [   78.849834] RSP: 0018:ffffc90001c9f9e0 EFLAGS: 00000002
>> [   78.849837] RAX: 0000000000040101 RBX: ffff88810c914fc8 RCX: 0000000000000000
>> [   78.849838] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888102177c30
>> [   78.849840] RBP: 0000000000000000 R08: ffff88810c914fc8 R09: ffff888106a4ed10
>> [   78.849841] R10: ffffc90001c9fae8 R11: ffff888101b048d8 R12: ffff888103833000
>> [   78.849842] R13: ffff888102177800 R14: ffffc90001c9fb20 R15: ffffc90001c9fa78
>> [   78.849844] FS:  00007fd3d66c4340(0000) GS:ffff8882b5c80000(0000) knlGS:0000000000000000
>> [   78.849847] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   78.849848] CR2: 00000000004a5b58 CR3: 000000010d438001 CR4: 0000000000170ee0
>> [   78.849850] Call Trace:
>> [   78.849853]  <TASK>
>> [   78.849855]  bfq_insert_requests+0xae/0x2340
>> [   78.849862]  ? submit_bio_noacct_nocheck+0x225/0x2b0
>> [   78.849868]  blk_mq_sched_insert_requests+0x5c/0x150
>> [   78.849872]  blk_mq_flush_plug_list+0xe1/0x2a0
>> [   78.849876]  __blk_flush_plug+0xdf/0x120
>> [   78.849879]  blk_finish_plug+0x27/0x40
>> [   78.849882]  read_pages+0x15b/0x360
>> [   78.849891]  page_cache_ra_unbounded+0x120/0x170
>> [   78.849894]  filemap_get_pages+0xdd/0x5f0
>> [   78.849899]  filemap_read+0xbf/0x350
>> [   78.849902]  ? __mod_memcg_lruvec_state+0x72/0xc0
>> [   78.849907]  ? __mod_lruvec_page_state+0xb4/0x160
>> [   78.849909]  ? folio_add_lru+0x51/0x80
>> [   78.849912]  ? _raw_spin_unlock+0x12/0x30
>> [   78.849916]  ? __handle_mm_fault+0xdee/0x14d0
>> [   78.849921]  blkdev_read_iter+0xa9/0x180
>> [   78.849924]  new_sync_read+0x109/0x180
>> [   78.849929]  vfs_read+0x187/0x1b0
>> [   78.849932]  ksys_read+0xa1/0xe0
>> [   78.849935]  do_syscall_64+0x42/0x90
>> [   78.849938]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [   78.849941] RIP: 0033:0x7fd3d6322f8e
>> [   78.849944] Code: c0 e9 c6 fe ff ff 48 8d 3d a7 07 0a 00 48 83 ec 08 e8 b6 e1 01 00 66 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00 f0 ff ff 77 59
>> [   78.849945] RSP: 002b:00007ffe92d46ea8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>> [   78.849948] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd3d6322f8e
>> [   78.849949] RDX: 0000000000001000 RSI: 00000000004a3000 RDI: 0000000000000003
>> [   78.849950] RBP: 0000000000000003 R08: 00000000004a3000 R09: 0000000000000003
>> [   78.849951] R10: 00007fd3d623d0a8 R11: 0000000000000246 R12: 00000000004a2a60
>> [   78.849952] R13: 0000000000000000 R14: 00000000004a3000 R15: 000000000048a4a0
>> [   78.849954]  </TASK>
> 
> Looks like bfq or block issue, will try it from my side.

FYI: I've used loop devices on a virtio disk.

I later discovered Logans patches [1], which I were not aware of, as I'm not subscribed to the lists.

[1]: https://lore.kernel.org/linux-raid/20220519191311.17119-6-logang@deltatee.com/T/#u

The series seems to acknowledge that there are open problems and tries to fix them.
So I've used his md-bug branch from https://github.com/sbates130272/linux-p2pmem but it didn't look better.

So I understand, the mdadm tests *are* supposed to work and every bug I see here is worth analyzing? Or is Logan hunting down everything anyway?

Best
   Donald
-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
