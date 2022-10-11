Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F14CC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 11 Oct 2022 13:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiJKNi6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Oct 2022 09:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJKNi5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Oct 2022 09:38:57 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E443E6AEA7
        for <linux-raid@vger.kernel.org>; Tue, 11 Oct 2022 06:38:53 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665495532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xvqFHvSPJEqbzktzVIgXqy9VBS+aiD6f8P/5mUCjsLQ=;
        b=bppcupAAEPQt911QaZCByFX2MnEZj2rmUgSLhprQ3NB5SDIBAeVxoE5B3rwVIDhNElMW8D
        P+8opiAh5oMtAsKazSTq38ZEpoZihEkAyd+hno5iOHqPThuDJTdRiQE8B+4AcokGAaE0A+
        E00P6g0COz1SqAtzWi14APeyukqBRpM=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: Memory leak when raid10 takeover raid0
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>
References: <CALTww2-EAeM6aKeZbZ2udTwS5RFwNWfF9uag=npewB9j0H51Hw@mail.gmail.com>
 <35f4a626-7f83-56c5-4cad-73ede197ccbf@linux.dev>
 <CALTww2_jaUVEk-zeobWSn9+yDYfkESKEX6hAKZ+-O+dMzQS+Hg@mail.gmail.com>
Message-ID: <861e6a43-40f6-a214-a72b-f641f9b6bc29@linux.dev>
Date:   Tue, 11 Oct 2022 21:38:48 +0800
MIME-Version: 1.0
In-Reply-To: <CALTww2_jaUVEk-zeobWSn9+yDYfkESKEX6hAKZ+-O+dMzQS+Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/10/22 1:48 PM, Xiao Ni wrote:
> On Mon, Oct 10, 2022 at 8:40 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
>> Hi Xiao,
>>
>> On 10/8/22 5:06 PM, Xiao Ni wrote:
>>> Hi all
>>>
>>> Sometimes it will have a memory leak problem when raid10 takeover raid0.
>>> And then panic.
>>>
>>> [ 6973.704097] BUG bio-176 (Not tainted): Objects remaining in bio-176
>>> on __kmem_cache_shutdown()
>>> [ 6973.705627] -----------------------------------------------------------------------------
>>> [ 6973.705627]
>>> [ 6973.707331] Slab 0x0000000067cd8c6c objects=21 used=1
>>> fp=0x000000005bf568c8
>>> flags=0xfffffc0000100(slab|node=0|zone=1|lastcpupid=0x1fffff)
>>> [ 6973.709498] CPU: 0 PID: 735535 Comm: mdadm Kdump: loaded Not
>>> tainted 4.18.0-423.el8.x86_64 #1
>> It is an old kernel, does it also happen to latest mainline version? Not
>> sure mdadm test suite
>> covers this case.
> Hi Guoqing
>
> I haven't tried with the latest upstream kernel. It's hard to
> reproduce this problem.
> Now it can only be triggered with our qe automatic tests. I tried to
> extract the test
> commands and put them into a script. It can't be reproduced.
>
> But from the code analysis, raid0 does have this problem.

I finally reproduced it with 6.0 kernel, and It is a NULL dereference.

*[  238.455386] BUG: kernel NULL pointer dereference, address: 
0000000000000000
[  238.470775] #PF: supervisor write access in kernel mode
[  238.470787] #PF: error_code(0x0002) - not-present page
[  238.470795] PGD 0 P4D 0
[  238.470808] Oops: 0002 [#1] PREEMPT SMP KASAN NOPTI
[  238.470821] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G    B OE      
6.0.0-57-default #36
[  238.470834] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
[  238.470843] RIP: 0010:mempool_free+0xe7/0x170
[  238.470859] Code: 72 48 8d 7b 48 e8 49 4a 10 00 4c 89 e7 4c 8b 6b 48 
e8 9d 49 10 00 41 8d 46 01 89 43 44 4f 8d 64 f5 00 4c 89 e7 e8 c9 4a 10 
00 <49> 89 2c 24 4c 89 fe 48 89 df e8 ba 24 da 00 48 8d 7b 68 31 c9 5b
[  238.470871] RSP: 0018:ffff88805b80fe40 EFLAGS: 00010082
[  238.470883] RAX: 0000000000000001 RBX: ffff888009c54da0 RCX: 
ffffffff902fd306
[  238.470892] RDX: 0000000000000001 RSI: 0000000000000008 RDI: 
ffffffff93461a00
[  238.470900] RBP: ffff88801fa26800 R08: 0000000000000001 R09: 
ffffffff93461a07
[  238.470908] R10: fffffbfff268c340 R11: 3e4b5341542f3c20 R12: 
0000000000000000
[  238.470916] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000202
[  238.470924] FS:  0000000000000000(0000) GS:ffff88805b800000(0000) 
knlGS:0000000000000000
[  238.470934] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  238.470942] CR2: 0000000000000000 CR3: 0000000002478001 CR4: 
0000000000370ee0
[  238.470955] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  238.470962] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  238.470969] Call Trace:
[  238.470976]  <IRQ>
[  238.470993]  md_end_io_acct+0x71/0xa0 [md_mod]
[  238.471089]  blk_update_request+0x205/0x820
[  238.471110]  ? ktime_get+0x21/0xc0
[  238.471132]  blk_mq_end_request+0x2e/0x220
[  238.471152]  blk_complete_reqs+0x78/0x90
[  238.471171]  __do_softirq+0x121/0x66d
[  238.471188]  ? lock_is_held_type+0xe3/0x140
[  238.471209]  __irq_exit_rcu+0x12c/0x1a0
[  238.471224]  irq_exit_rcu+0xa/0x30
[  238.471237]  sysvec_call_function_single+0x8f/0xb0
[  238.471252]  </IRQ>
[  238.471256]  <TASK>
[  238.471263]  asm_sysvec_call_function_single+0x16/0x20
[  238.471275] RIP: 0010:native_safe_halt+0xb/0x10*

>>> [ 6973.711027] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>> [ 6973.712068] Call Trace:
>>> [ 6973.712550]  dump_stack+0x41/0x60
>>> [ 6973.713185]  slab_err.cold.117+0x53/0x67
>>> [ 6973.713878]  ? __unfreeze_partials+0x1a0/0x1a0
>>> [ 6973.714659]  ? cpumask_next+0x17/0x20
>>> [ 6973.715309]  __kmem_cache_shutdown+0x16e/0x300
>>> [ 6973.716097]  kmem_cache_destroy+0x4d/0x120
>>> [ 6973.716843]  bioset_exit+0xb0/0x100
>>> [ 6973.717486]  level_store+0x280/0x650
>>> [ 6973.718147]  ? security_capable+0x38/0x60
>>> [ 6973.718856]  md_attr_store+0x7c/0xc0
>>> [ 6973.719489]  kernfs_fop_write+0x11e/0x1a0
>>> [ 6973.720200]  vfs_write+0xa5/0x1b0
>>> [ 6973.720785]  ksys_write+0x4f/0xb0
>>> [ 6973.721374]  do_syscall_64+0x5b/0x1b0
>>> [ 6973.722028]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
>>> [ 6973.723005] RIP: 0033:0x7fb15d2b5bc8
>>> [ 6973.723660] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00
>>> 00 00 f3 0f 1e fa 48 8d 05 55 4b 2a 00 8b 00 85 c0 75 17 b8 01 00 00
>>> 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89
>>> d4 55
>>> [ 6973.726926] RSP: 002b:00007ffed8ebc8a8 EFLAGS: 00000246 ORIG_RAX:
>>> 0000000000000001
>>> [ 6973.728278] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fb15d2b5bc8
>>> [ 6973.729515] RDX: 0000000000000006 RSI: 0000560330046dd7 RDI: 0000000000000004
>>> [ 6973.730748] RBP: 0000560330046dd7 R08: 000056033003b927 R09: 00007fb15d315d40
>>> [ 6973.731986] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>> [ 6973.733240] R13: 00007ffed8ebcc80 R14: 00007ffed8ebe8ee R15: 0000000000000000
>>> [ 6973.734520] Disabling lock debugging due to kernel taint
>>> [ 6973.735452] Object 0x000000000923869f @offset=3264
>>> [ 6973.736317] kmem_cache_destroy bio-176: Slab cache still has objects
>>> [ 6973.737479] CPU: 0 PID: 735535 Comm: mdadm Kdump: loaded Tainted: G
>>>      B            --------- -  - 4.18.0-423.el8.x86_64 #1
>>> [ 6973.739438] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>> [ 6973.740437] Call Trace:
>>> [ 6973.740877]  dump_stack+0x41/0x60
>>> [ 6973.741473]  kmem_cache_destroy+0x116/0x120
>>> [ 6973.742209]  bioset_exit+0xb0/0x100
>>> [ 6973.742824]  level_store+0x280/0x650
>>> [ 6973.743463]  ? security_capable+0x38/0x60
>>> [ 6973.744177]  md_attr_store+0x7c/0xc0
>>> [ 6973.744807]  kernfs_fop_write+0x11e/0x1a0
>>> [ 6973.745516]  vfs_write+0xa5/0x1b0
>>> [ 6973.746112]  ksys_write+0x4f/0xb0
>>> [ 6973.746695]  do_syscall_64+0x5b/0x1b0
>>> [ 6973.747373]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
>>> [ 6973.748293] RIP: 0033:0x7fb15d2b5bc8
>>> [ 6973.748929] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00
>>> 00 00 f3 0f 1e fa 48 8d 05 55 4b 2a 00 8b 00 85 c0 75 17 b8 01 00 00
>>> 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89
>>> d4 55
>>> [ 6973.752255] RSP: 002b:00007ffed8ebc8a8 EFLAGS: 00000246 ORIG_RAX:
>>> 0000000000000001
>>> [ 6973.753628] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fb15d2b5bc8
>>> [ 6973.754900] RDX: 0000000000000006 RSI: 0000560330046dd7 RDI: 0000000000000004
>>> [ 6973.756142] RBP: 0000560330046dd7 R08: 000056033003b927 R09: 00007fb15d315d40
>>> [ 6973.757420] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>> [ 6973.758702] R13: 00007ffed8ebcc80 R14: 00007ffed8ebe8ee R15: 0000000000000000
>>> [ 6973.762429] BUG: unable to handle kernel NULL pointer dereference
>>> at 0000000000000000
>>> [ 6973.763818] PGD 0 P4D 0
>>> [ 6973.764277] Oops: 0002 [#1] SMP PTI
>>> [ 6973.764896] CPU: 0 PID: 12 Comm: ksoftirqd/0 Kdump: loaded Tainted:
>>> G    B            --------- -  - 4.18.0-423.el8.x86_64 #1
>>> [ 69 it73.766944] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>> [ 6973.767999] RIP: 0010:mempool_free+0x52/0x80
>>> [ 6973.768779] Code: e4 6f 96 00 e9 0f 72 96 00 48 89 f7 e8 a7 5e 75
>>> 00 48 63 53 08 3b 53 04 7d 30 48 8b 4b 10 8d 72 01 48 89 df 89 73 08
>>> 48 89 c6 <48> 89 2c d1 e8 f5 5e 75 00 48 8d 7b 30 31 c9 5b ba 01 00 00
>>> 00 be
>>> [ 6973.772088] RSP: 0018:ffffbc6c4068fdf8 EFLAGS: 00010093
>>> [ 6973.773026] RAX: 0000000000000293 RBX: ffff9b5844fed7d8 RCX: 0000000000000000
>>> [ 6973.774318] RDX: 0000000000000000 RSI: 0000000000000293 RDI: ffff9b5844fed7d8
>>> [ 6973.775560] RBP: ffff9b5759046cc0 R08: 000000000000003d R09: ffff9b57420e62a0
>>> [ 6973.776794] R10: 0000000000000008 R11: ffff9b574a602a00 R12: ffff9b5845004ed0
>>> [ 6973.778096] R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000000000
>>> [ 6973.779357] FS:  0000000000000000(0000) GS:ffff9b5870000000(0000)
>>> knlGS:0000000000000000
>>> [ 6973.780757] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 6973.781806] CR2: 0000000000000000 CR3: 0000000043410002 CR4: 00000000007706f0
>>> [ 6973.783076] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [ 6973.784313] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> [ 6973.785593] PKRU: 55555554
>>> [ 6973.786098] Call Trace:
>>> [ 6973.786549]  md_end_io_acct+0x31/0x40
>>> [ 6973.787227]  blk_update_request+0x224/0x380
>>> [ 6973.787994]  blk_mq_end_request+0x1a/0x130
>>> [ 6973.788739]  blk_complete_reqs+0x35/0x50
>>> [ 6973.789456]  __do_softirq+0xd7/0x2c8
>>> [ 6973.790114]  ? sort_range+0x20/0x20
>>> [ 6973.790763]  run_ksoftirqd+0x2a/0x40
>>> [ 6973.791400]  smpboot_thread_fn+0xb5/0x150
>>> [ 6973.792114]  kthread+0x10b/0x130
>>> [ 6973.792724]  ? set_kthread_struct+0x50/0x50
>>> [ 6973.793491]  ret_from_fork+0x1f/0x40
>>>
>>> The reason is that raid0 doesn't do anything in raid0_quiesce. During
>>> the level change in level_store, it needs
>>> to make sure all inflight bios to finish.  We can add a count to do
>>> this in raid0. Is it a good way?
>>>
>>> There is a count mddev->active_io in mddev. But it's decreased in
>>> md_handle_request rather than in the callback
>>> endio function. Is it right to decrease active_io in callbcak endio function?
>>>
>> I think it is a race between ios and takeover action, since
>> mddev_suspend called by
>> level_store should ensure no io is submitted to array at that time by below.
>>
>>       wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0)
>>
>> However it can't guarantee new io comes after mddev_suspend because the
>> empty raid0 quiesce.  Maybe we can do something like this.

I was wrong given md_end_io_acct could happen after raid0_make_request, 
so it could
be the previous io not finished before mddev_suspend, which means we 
need to find a
way to drain member disk somehow but I doubt it is reasonable.

Also change personality from raid0 seems doesn't obey the second rule.

        /* request to change the personality.  Need to ensure:
          *  - array is not engaged in resync/recovery/reshape
          *  - *old personality can be suspended*
          *  - new personality will access other array.
          */

And I don't like the idea to add another clone during io path for the 
special case which
hurts performance. I would just warn user don't change personality from 
raid0 unless
QUEUE_FLAG_IO_STAT flag is cleared for a while. Or do something like.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 729be2c5296c..55e975233f66 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3979,6 +3979,12 @@ level_store(struct mddev *mddev, const char *buf, 
size_t len)
                 goto out_unlock;
         }

+       if (blk_queue_io_stat(mddev->queue)) {
+               blk_queue_flag_clear(QUEUE_FLAG_IO_STAT, mddev->queue);
+               /* We want the previous bio is finished */
+               msleep(1000);
+       }
+
         /* Looks like we have a winner */
         mddev_suspend(mddev);
         mddev_detach(mddev);
@@ -4067,6 +4073,7 @@ level_store(struct mddev *mddev, const char *buf, 
size_t len)
         pers->run(mddev);
         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
         mddev_resume(mddev);
+       blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue);

If you really want to fix it, maybe we have to ensure all inflight IOs 
is finished by increase
inflight num in md_account_bio, then decrease it in md_end_io_acct after 
add a new
inflight_num in mddev and also add "struct mddev *mddev" in md_io_acct, 
just FYI.

Thanks,
Guoqing
