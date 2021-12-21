Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0503C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 08:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhLUIOL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 03:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhLUIOL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 03:14:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ACBC061574
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 00:14:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9232B80E74
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 08:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D96C36AE7
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 08:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640074447;
        bh=tCxQapeA4JzACQRY66nJEojbvJZ/McB6Zq7YxwqqkXI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GdreYmD4sj5mfnXDXzChnABP4pk7lty/do4mjjJY+61l4TtXBQQgrcfS26712PveW
         +kkvD0RsgO1Ql8SsK9pGuihWFE6CkiNdFnAFu1+D5W7vbgCg5NgT8YfVtTDSsNp7hQ
         khKdtrEgE4LflxMgYTdTq9LZ8foDsaHlD9E+dKZFfgzy9tc7C5kzAWM+Lrjic8Y22f
         PBK1QMnNvGfEN4o0Uik3QUpmslT7HYBrNN+CdK1bJoKXxJQxNQ5qQiyBkUe0rGqKFP
         DO4tRGqSXveuh8fk+eEN+6s5201HiTRERXqSKBJYz0u/ocwTaWeQ4uKxmIQFridzBb
         Bu3oAY72E6FjQ==
Received: by mail-yb1-f176.google.com with SMTP id g17so36313827ybe.13
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 00:14:07 -0800 (PST)
X-Gm-Message-State: AOAM5314y51P+rCci+4KM+jMXi9HYUF6lBhFoK5NlDisPpZf5bstwjKl
        q8ZAvtW6+9VsbtEp5lhEEXDxtIN3r7GcC2udblE=
X-Google-Smtp-Source: ABdhPJxlhS4hkUlHh2+iwqWrf7Tkpw9sPcJ1XgZed4EKK7dJWmL/+X8eho4iUGwX51zQ+oF/9IlVz8Q2bXFlj8Ggy8M=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr2089923ybq.47.1640074446672;
 Tue, 21 Dec 2021 00:14:06 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW7OY+5-F6Vk6z=ngSMXEayz3si=Sdf69r4vexRo202X_Q@mail.gmail.com>
 <20211215060906.3230-1-vverma@digitalocean.com> <20211215060906.3230-3-vverma@digitalocean.com>
 <CAPhsuW5=GLRW9g2QxgBfcx_OKq08x5GqGO4iC86x6YzDHRz8fA@mail.gmail.com>
 <9a85af03-a551-6650-3807-c177659cd17b@digitalocean.com> <7592d323-a07f-e333-220c-e9a7321a16f3@digitalocean.com>
 <4d246589-2184-91ec-613c-a3e8926a2b92@kernel.dk> <d93019e5-1669-0eb6-1e8e-73768aa6f917@digitalocean.com>
 <051b25ce-3b6b-b156-f6fa-2da36bbd9144@kernel.dk> <dbd77650-7a27-1a7b-935c-aba1057d385b@digitalocean.com>
 <CAPhsuW44Y-Lw01yEzVJH4J=JvBLbcKBOyva-75ivT2mdfsS2fg@mail.gmail.com>
 <50e23aee-af38-4da2-0f2f-da16af4fc477@digitalocean.com> <CAPhsuW5X7T67odWhZ=AqQMGvZATmHrxNeGOuLH-fmhy_L1r+Ag@mail.gmail.com>
 <bd90d6e6-adb4-2696-3110-fad0b1ee00dc@digitalocean.com>
In-Reply-To: <bd90d6e6-adb4-2696-3110-fad0b1ee00dc@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 21 Dec 2021 00:13:55 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5kLZ=jQQWQwRG8-XnLihQ1R30s9CdLjm3s40J7axTU8Q@mail.gmail.com>
Message-ID: <CAPhsuW5kLZ=jQQWQwRG8-XnLihQ1R30s9CdLjm3s40J7axTU8Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] md: raid10 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Dec 20, 2021 at 6:22 AM Vishal Verma <vverma@digitalocean.com> wrote:
>
>
> On 12/16/21 4:50 PM, Song Liu wrote:
>
> On Thu, Dec 16, 2021 at 12:38 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
> [...]
>
> [  740.106431] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
>
> What's the exact command line that triggers this? I am not able to
> trigger it with
> either fio or t/io_uring.
>
> Song
>
> I only had 1 nvme so was creating 4 partitions on it and creating a
> raid10 and doing:
>
> mdadm -C /dev/md10 -l 10 -n 4 /dev/nvme4n1p1 /dev/nvme4n1p2
> /dev/nvme4n1p3 /dev/nvme4n1p4
> ./t/io_uring /dev/md10-d 256 -p 0 -a 0 -r 100
>
> on top of commit: c14704e1cb556 (md-next branch) + "md: add support for
> REQ_NOWAIT" patch
> Also, applied the commit (75feae73a28) Jens pointed earlier today.
>
> I am able to trigger the following error. I will look into it.
>
> Thanks,
> Song
>
> [ 1583.149004] ==================================================================
> [ 1583.150100] BUG: KASAN: use-after-free in raid10_end_read_request+0x91/0x310
> [ 1583.151042] Read of size 8 at addr ffff888160a1c928 by task io_uring/1165
> [ 1583.152016]
> [ 1583.152247] CPU: 0 PID: 1165 Comm: io_uring Not tainted 5.16.0-rc3+ #660
> [ 1583.153159] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.13.0-2.module_el8.4.0+547+a85d02ba 04/01/2014
> [ 1583.154572] Call Trace:
> [ 1583.155005]  <IRQ>
> [ 1583.155338]  dump_stack_lvl+0x44/0x57
> [ 1583.155950]  print_address_description.constprop.8.cold.17+0x12/0x339
> [ 1583.156969]  ? raid10_end_read_request+0x91/0x310
> [ 1583.157578]  ? raid10_end_read_request+0x91/0x310
> [ 1583.158272]  kasan_report.cold.18+0x83/0xdf
> [ 1583.158889]  ? raid10_end_read_request+0x91/0x310
> [ 1583.159554]  raid10_end_read_request+0x91/0x310
> [ 1583.160201]  ? raid10_resize+0x270/0x270
> [ 1583.160724]  ? bio_uninit+0xc7/0x1e0
> [ 1583.161274]  blk_update_request+0x21f/0x810
> [ 1583.161893]  blk_mq_end_request_batch+0x11c/0xa70
> [ 1583.162497]  ? blk_mq_end_request+0x460/0x460
> [ 1583.163204]  ? nvme_complete_batch_req+0x12/0x30
> [ 1583.163888]  nvme_irq+0x6ad/0x6f0
> [ 1583.164354]  ? io_queue_count_set+0xe0/0xe0
> [ 1583.164980]  ? nvme_unmap_data+0x1e0/0x1e0
> [ 1583.165504]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [ 1583.166149]  ? io_queue_count_set+0xe0/0xe0
> [ 1583.166721]  __handle_irq_event_percpu+0x79/0x440
> [ 1583.167446]  handle_irq_event_percpu+0x6f/0xe0
> [ 1583.168101]  ? __handle_irq_event_percpu+0x440/0x440
> [ 1583.168734]  ? lock_contended+0x6e0/0x6e0
> [ 1583.169349]  ? do_raw_spin_unlock+0xa2/0x130
> [ 1583.169961]  handle_irq_event+0x54/0x90
> [ 1583.170442]  handle_edge_irq+0x121/0x300
> [ 1583.171012]  __common_interrupt+0x7d/0x170
> [ 1583.171538]  common_interrupt+0xa0/0xc0
> [ 1583.172103]  </IRQ>
> [ 1583.172389]  <TASK>
>
> When running t/io_uring on a raid1 array, I get following:
>
> [  189.863726] RIP: 0010:__kmalloc+0xfa/0x430
> [  189.867825] Code: 05 4b 9a 35 43 48 8b 50 08 48 83 78 10 00 4c 8b 20 0f 84 fa 02 00 00 4d 85 e4 0f 84 f1 02 00 00 41 8b 47 28 49 8b 3f 4c 01 e0 <48> 8b 18 48 89 c1 49 33 9f b8 00 00 00 4c 89 e0 48 0f c9 48 31 cb
> [  189.886573] RSP: 0018:ffffaf09e28b7828 EFLAGS: 00010286
> [  189.891799] RAX: a0fa1099d2b0fff3 RBX: 0000000000092900 RCX: 0000000000000000
> [  189.898930] RDX: 00000002ba79600b RSI: 0000000000092900 RDI: 00000000000340e0
> [  189.906062] RBP: ffffaf09e28b7860 R08: ffff90fb8b6ea560 R09: ffff90fba7205f60
> [  189.913195] R10: ffffaf09e28b7c18 R11: 0000000000000000 R12: a0fa1099d2b0ffb3
> [  189.920329] R13: 0000000000000000 R14: ffffffffc074c277 R15: ffff90bc00044700
> [  189.927461] FS:  00007fd6209d7700(0000) GS:ffff913a6e140000(0000) knlGS:0000000000000000
> [  189.935549] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  189.941295] CR2: 00007f16998bebf0 CR3: 00000040be512005 CR4: 0000000000770ee0
> [  189.948426] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  189.955560] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  189.962691] PKRU: 55555554
> [  189.965403] Call Trace:
> [  189.967857]  <TASK>
> [  189.969966]  0xffffffffc074c277
> [  189.973110]  mempool_alloc+0x61/0x180
> [  189.976777]  ? bio_associate_blkg_from_css+0xf5/0x2c0
> [  189.981829]  ? __bio_clone_fast+0xa9/0xf0
> [  189.985842]  ? __sbitmap_get_word+0x36/0x80
> [  189.990027]  0xffffffffc074ac50
> [  189.993174]  ? __sbitmap_queue_get+0x9/0x10
> [  189.997359]  ? blk_mq_get_tag+0x241/0x270
> [  190.001373]  ? ktime_get+0x3b/0xa0
> [  190.004776]  ? blk_mq_rq_ctx_init.isra.0+0x1a5/0x1c0
> [  190.009743]  0xffffffffc074efb3
> [  190.012891]  md_handle_request+0x134/0x1b0
> [  190.016989]  ? ktime_get+0x3b/0xa0
> [  190.020395]  md_submit_bio+0x6d/0xa0
> [  190.023976]  __submit_bio+0x94/0x140
> [  190.027555]  submit_bio_noacct+0xe1/0x2a0
> [  190.031566]  submit_bio+0x48/0x120
> [  190.034972]  blkdev_direct_IO+0x19b/0x540
> [  190.038987]  ? __fsnotify_parent+0xff/0x330
> [  190.043172]  ? __fsnotify_parent+0x10f/0x330
> [  190.047445]  generic_file_read_iter+0xa5/0x160
> [  190.051889]  blkdev_read_iter+0x38/0x70
> [  190.055731]  io_read+0x119/0x420
> [  190.058963]  ? blk_queue_exit+0x23/0x50
> [  190.062801]  ? __blk_mq_free_request+0x86/0xc0
> [  190.067247]  io_issue_sqe+0x7ec/0x19c0
> [  190.071002]  ? io_req_prep+0x6a9/0xe60
> [  190.074754]  io_submit_sqes+0x2a0/0x9f0
> [  190.078594]  ? __fget_files+0x6a/0x90
> [  190.082259]  __x64_sys_io_uring_enter+0x1da/0x8c0
> [  190.086965]  ? debug_smp_processor_id+0x17/0x20
> [  190.091498]  ? fpregs_assert_state_consistent+0x23/0x50
> [  190.096723]  ? exit_to_user_mode_prepare+0x4b/0x1e0
> [  190.101602]  do_syscall_64+0x38/0x90
> [  190.105182]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  190.110236] RIP: 0033:0x7fd620af589d
> [  190.113815] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
> [  190.132563] RSP: 002b:00007fd6209d6e98 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> [  190.140126] RAX: ffffffffffffffda RBX: 00007fd620d4bfc0 RCX: 00007fd620af589d
> [  190.147261] RDX: 0000000000000000 RSI: 0000000000000020 RDI: 0000000000000004
> [  190.154391] RBP: 0000000000000020 R08: 0000000000000000 R09: 0000000000000000
> [  190.161524] R10: 0000000000000000 R11: 0000000000000246 R12: 0000561889c472a0
> [  190.168657] R13: 0000000000000020 R14: 0000000000000000 R15: 0000000000000020
> [  190.175793]  </TASK>
>
> It seems this issue is getting triggered with the following commit:
>
> commit 5b13bc8a3fd519d86e5b1a0b1d1b996cace62f3f
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Nov 24 07:28:56 2021 +0100
>
>     blk-mq: cleanup request allocation

Good finding. I am not able to repro these issues after reverting this commit.

Vishal, how does it work in your tests?

Song
