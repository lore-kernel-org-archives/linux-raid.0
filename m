Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F23DEC8740
	for <linux-raid@archiver.kernel.org>; Thu,  7 Sep 2023 16:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbjIGQBD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240601AbjIGP7E (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Sep 2023 11:59:04 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB953C34
        for <linux-raid@vger.kernel.org>; Thu,  7 Sep 2023 08:47:35 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-59234aaca15so11336277b3.3
        for <linux-raid@vger.kernel.org>; Thu, 07 Sep 2023 08:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694101571; x=1694706371; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLE995n6BWpKFzfHD+2Jlshss0TQ1epMY0Ulm50i/NM=;
        b=PdU8mYceuZmaDJBBTTLr9LbWxIrgeAbpZbfBgn6K6ct99WyyGr14A48Et6h1hpjWIE
         SmBt+9VzbL27sq4KQOVx7vTAamX3bCDlnWiUeriaLf19tbyBZaNIXnBzgyHki2HZDcB3
         Qec4e9qKgdTsx5Sw3L0TjJN79zjb0cXpNqqSVbwPsJI+YXQCQw5bIGQSmgrkijz+nzKC
         mj+sktO85HDn3B51ea/Dv9Ew7ox9dps++0jf/hlMC5pyrkS2dzTmJJy+fWiJzvlUKiKo
         t9tPejMVaWC5jVZ9Kz3V2KuScSp1So2YQ18sunT+1psFtJ61I1QyIJFpYTKXa6DwFFJ6
         QnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694101571; x=1694706371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nLE995n6BWpKFzfHD+2Jlshss0TQ1epMY0Ulm50i/NM=;
        b=BZ13UoM0NjmgFVHdTSYbmiaSEJA+B/zy+5lKomYpGATbmlSZ1mmIghz5VBvfC+7JCs
         LRQodfDDFTYVKSN7jNcKw69Gn1QxzRqbBTRIKuaprhxhz2bsyXemEUQU5gq7tdDMQ2hC
         7TbTwIOL5gSKSPdWGGPjfDxY66QA/s0U1dEyq+Kv/6M5RS+YB9T4C1GFcWm2CDOEwk41
         HFoH2LVCfQ8dDZhw750iTwcRT6Nx/1GIk8sh9kO+vsU6T2jlqHuy/hsXFQhvFbVAe9dB
         hs/Dk0F84qLV9+ps3ywXG4jzYt0BPGo1McHcHiTrrI30NhBRaPyPCDgOvhi7vSaKbp7T
         jZRA==
X-Gm-Message-State: AOJu0YxbQpDqS/brJVdWTj1zuiRJfwtIewsMCQTYp5yF++j9vDf2PM8X
        99T1VwRTpqqhATlxwDESUL0XUk58gnQL5bPTildbME+26fTx
X-Google-Smtp-Source: AGHT+IEhtmuTLg7Ai58skgq/YRwFFPEsbn2kzNBNAXv1i34WDgP4ABNKybdbNuk7n09HjkFjinX2IonKfkDvZWGnG4A=
X-Received: by 2002:a25:c702:0:b0:d0a:fa7f:2fbf with SMTP id
 w2-20020a25c702000000b00d0afa7f2fbfmr17763980ybe.48.1694067597540; Wed, 06
 Sep 2023 23:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <CA+w1tCeQw5STTQAEoTHTcpT4s_nT0zdgGSce6n-CT24BbNmukA@mail.gmail.com>
 <afb56bef-4547-d7f1-d3c2-730b7d7658f2@huaweicloud.com> <CA+w1tCeZmqreX_HRrsGRqq9-MmjNyo6VAt6sDEQgpS2R4=DxoA@mail.gmail.com>
 <0ef44108-2a81-89df-c839-0c16d9499c29@huaweicloud.com> <CA+w1tCeUZET9KCcBWb89FXNjuvA-M25yCrkF5OqcdZXLQsAhxw@mail.gmail.com>
 <34e3f81e-4f7e-4a45-3690-f1a012df6d00@huaweicloud.com> <CA+w1tCcBBLWLLLWSywRzk2d+vF6OFkeeHoyM49v4oxHC4u--jA@mail.gmail.com>
 <79aa3cf3-78d4-cfc6-8d3b-eb8704ffaba1@huaweicloud.com>
In-Reply-To: <79aa3cf3-78d4-cfc6-8d3b-eb8704ffaba1@huaweicloud.com>
From:   Jason Moss <phate408@gmail.com>
Date:   Wed, 6 Sep 2023 23:19:46 -0700
Message-ID: <CA+w1tCf0RriSXMGGKCK0J9wYhbwctEkDAAMVYtRGQ6fmJpUbXA@mail.gmail.com>
Subject: Re: Reshape Failure
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On Wed, Sep 6, 2023 at 11:13=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/09/07 13:44, Jason Moss =E5=86=99=E9=81=93:
> > Hi,
> >
> > On Wed, Sep 6, 2023 at 6:38=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/09/06 22:05, Jason Moss =E5=86=99=E9=81=93:
> >>> Hi Kuai,
> >>>
> >>> I ended up using gdb rather than addr2line, as that output didn't giv=
e
> >>> me the global offset. Maybe there's a better way, but this seems to b=
e
> >>> similar to what I expected.
> >>
> >> It's ok.
> >>>
> >>> (gdb) list *(reshape_request+0x416)
> >>> 0x11566 is in reshape_request (drivers/md/raid5.c:6396).
> >>> 6391            if ((mddev->reshape_backwards
> >>> 6392                 ? (safepos > writepos && readpos < writepos)
> >>> 6393                 : (safepos < writepos && readpos > writepos)) ||
> >>> 6394                time_after(jiffies, conf->reshape_checkpoint + 10=
*HZ)) {
> >>> 6395                    /* Cannot proceed until we've updated the
> >>> superblock... */
> >>> 6396                    wait_event(conf->wait_for_overlap,
> >>> 6397                               atomic_read(&conf->reshape_stripes=
)=3D=3D0
> >>> 6398                               || test_bit(MD_RECOVERY_INTR,
> >>
> >> If reshape is stuck here, which means:
> >>
> >> 1) Either reshape io is stuck somewhere and never complete;
> >> 2) Or the counter reshape_stripes is broken;
> >>
> >> Can you read following debugfs files to verify if io is stuck in
> >> underlying disk?
> >>
> >> /sys/kernel/debug/block/[disk]/hctx*/{sched_tags,tags,busy,dispatch}
> >>
> >
> > I'll attach this below.
> >
> >> Furthermore, echo frozen should break above wait_event() because
> >> 'MD_RECOVERY_INTR' will be set, however, based on your description,
> >> the problem still exist. Can you collect stack and addr2line result
> >> of stuck thread after echo frozen?
> >>
> >
> > I echo'd frozen to /sys/block/md0/md/sync_action, however the echo
> > call has been sitting for about 30 minutes, maybe longer, and has not
> > returned. Here's the current state:
> >
> > root         454  0.0  0.0      0     0 ?        I<   Sep05   0:00 [rai=
d5wq]
> > root         455  0.0  0.0  34680  5988 ?        D    Sep05   0:00 (ude=
v-worker)
>
> Can you also show the stack of udev-worker? And any other thread with
> 'D' state, I think above "echo frozen" is probably also stuck in D
> state.
>

As requested:

ps aux | grep D
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         455  0.0  0.0  34680  5988 ?        D    Sep05   0:00 (udev-wo=
rker)
root         457  0.0  0.0      0     0 ?        D    Sep05   0:00 [md0_res=
hape]
root       45507  0.0  0.0   8272  4736 pts/1    Ds+  Sep05   0:00 -bash
jason     279169  0.0  0.0   6976  2560 pts/0    S+   23:16   0:00
grep --color=3Dauto D

[jason@arch md]$ sudo cat /proc/455/stack
[<0>] wait_woken+0x54/0x60
[<0>] raid5_make_request+0x5fe/0x12f0 [raid456]
[<0>] md_handle_request+0x135/0x220 [md_mod]
[<0>] __submit_bio+0xb3/0x170
[<0>] submit_bio_noacct_nocheck+0x159/0x370
[<0>] block_read_full_folio+0x21c/0x340
[<0>] filemap_read_folio+0x40/0xd0
[<0>] filemap_get_pages+0x475/0x630
[<0>] filemap_read+0xd9/0x350
[<0>] blkdev_read_iter+0x6b/0x1b0
[<0>] vfs_read+0x201/0x350
[<0>] ksys_read+0x6f/0xf0
[<0>] do_syscall_64+0x60/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8


[jason@arch md]$ sudo cat /proc/45507/stack
[<0>] kthread_stop+0x6a/0x180
[<0>] md_unregister_thread+0x29/0x60 [md_mod]
[<0>] action_store+0x168/0x320 [md_mod]
[<0>] md_attr_store+0x86/0xf0 [md_mod]
[<0>] kernfs_fop_write_iter+0x136/0x1d0
[<0>] vfs_write+0x23e/0x420
[<0>] ksys_write+0x6f/0xf0
[<0>] do_syscall_64+0x60/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Please let me know if you'd like me to identify the lines for any of those.

Thanks,
Jason


> > root         456 99.9  0.0      0     0 ?        R    Sep05 1543:40 [md=
0_raid6]
> > root         457  0.0  0.0      0     0 ?        D    Sep05   0:00 [md0=
_reshape]
> >
> > [jason@arch md]$ sudo cat /proc/457/stack
> > [<0>] md_do_sync+0xef2/0x11d0 [md_mod]
> > [<0>] md_thread+0xae/0x190 [md_mod]
> > [<0>] kthread+0xe8/0x120
> > [<0>] ret_from_fork+0x34/0x50
> > [<0>] ret_from_fork_asm+0x1b/0x30
> >
> > Reading symbols from md-mod.ko...
> > (gdb) list *(md_do_sync+0xef2)
> > 0xb3a2 is in md_do_sync (drivers/md/md.c:9035).
> > 9030                    ? "interrupted" : "done");
> > 9031            /*
> > 9032             * this also signals 'finished resyncing' to md_stop
> > 9033             */
> > 9034            blk_finish_plug(&plug);
> > 9035            wait_event(mddev->recovery_wait,
> > !atomic_read(&mddev->recovery_active));
>
> That's also wait for reshape io to be done from common layer.
>
> > 9036
> > 9037            if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> > 9038                !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> > 9039                mddev->curr_resync >=3D MD_RESYNC_ACTIVE) {
> >
> >
> > The debugfs info:
> >
> > [root@arch ~]# cat
> > /sys/kernel/debug/block/sda/hctx*/{sched_tags,tags,busy,dispatch}
>
> Only sched_tags is read, sorry that I didn't mean to use this exact cmd.
>
> Perhaps you can using following cmd:
>
> find /sys/kernel/debug/block/sda/ -type f | xargs grep .
>
> > nr_tags=3D64
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D64
> > busy=3D1
>
> This means there is one IO in sda, however, I need more information to
> make sure where is this IO. And please make sure don't run any other
> thread that can read/write from sda. You can use "iostat -dmx 1" and
> observe for a while to confirm that there is no new io.
>
> Thanks,
> Kuai
>
> > cleared=3D55
> > bits_per_word=3D16
> > map_nr=3D4
> > alloc_hint=3D{40, 20, 46, 0}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D1
> > min_shallow_depth=3D48
> > nr_tags=3D32
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D32
> > busy=3D0
> > cleared=3D27
> > bits_per_word=3D8
> > map_nr=3D4
> > alloc_hint=3D{19, 26, 5, 21}
> > wake_batch=3D4
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D1
> > min_shallow_depth=3D4294967295
>
>
> >
> >
> > [root@arch ~]# cat /sys/kernel/debug/block/sdb/hctx*
> > /{sched_tags,tags,busy,dispatch}
> > nr_tags=3D64
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D64
> > busy=3D1
> > cleared=3D56
> > bits_per_word=3D16
> > map_nr=3D4
> > alloc_hint=3D{57, 43, 14, 19}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D1
> > min_shallow_depth=3D48
> > nr_tags=3D32
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D32
> > busy=3D0
> > cleared=3D24
> > bits_per_word=3D8
> > map_nr=3D4
> > alloc_hint=3D{17, 13, 23, 17}
> > wake_batch=3D4
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D1
> > min_shallow_depth=3D4294967295
> >
> >
> > [root@arch ~]# cat
> > /sys/kernel/debug/block/sdd/hctx*/{sched_tags,tags,busy,dispatch}
> > nr_tags=3D64
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D64
> > busy=3D1
> > cleared=3D51
> > bits_per_word=3D16
> > map_nr=3D4
> > alloc_hint=3D{36, 43, 15, 7}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D1
> > min_shallow_depth=3D48
> > nr_tags=3D32
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D32
> > busy=3D0
> > cleared=3D31
> > bits_per_word=3D8
> > map_nr=3D4
> > alloc_hint=3D{0, 15, 1, 22}
> > wake_batch=3D4
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D1
> > min_shallow_depth=3D4294967295
> >
> >
> > [root@arch ~]# cat
> > /sys/kernel/debug/block/sdf/hctx*/{sched_tags,tags,busy,dispatch}
> > nr_tags=3D256
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D256
> > busy=3D1
> > cleared=3D131
> > bits_per_word=3D64
> > map_nr=3D4
> > alloc_hint=3D{125, 46, 83, 205}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D192
> > nr_tags=3D10104
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D10104
> > busy=3D0
> > cleared=3D235
> > bits_per_word=3D64
> > map_nr=3D158
> > alloc_hint=3D{503, 2913, 9827, 9851}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D4294967295
> >
> >
> > [root@arch ~]# cat
> > /sys/kernel/debug/block/sdh/hctx*/{sched_tags,tags,busy,dispatch}
> > nr_tags=3D256
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D256
> > busy=3D1
> > cleared=3D97
> > bits_per_word=3D64
> > map_nr=3D4
> > alloc_hint=3D{144, 144, 127, 254}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D192
> > nr_tags=3D10104
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D10104
> > busy=3D0
> > cleared=3D235
> > bits_per_word=3D64
> > map_nr=3D158
> > alloc_hint=3D{503, 2913, 9827, 9851}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D4294967295
> >
> >
> > [root@arch ~]# cat
> > /sys/kernel/debug/block/sdi/hctx*/{sched_tags,tags,busy,dispatch}
> > nr_tags=3D256
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D256
> > busy=3D1
> > cleared=3D34
> > bits_per_word=3D64
> > map_nr=3D4
> > alloc_hint=3D{197, 20, 1, 230}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D192
> > nr_tags=3D10104
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D10104
> > busy=3D0
> > cleared=3D235
> > bits_per_word=3D64
> > map_nr=3D158
> > alloc_hint=3D{503, 2913, 9827, 9851}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D4294967295
> >
> >
> > [root@arch ~]# cat
> > /sys/kernel/debug/block/sdj/hctx*/{sched_tags,tags,busy,dispatch}
> > nr_tags=3D256
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D256
> > busy=3D1
> > cleared=3D27
> > bits_per_word=3D64
> > map_nr=3D4
> > alloc_hint=3D{132, 74, 129, 76}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D192
> > nr_tags=3D10104
> > nr_reserved_tags=3D0
> > active_queues=3D0
> >
> > bitmap_tags:
> > depth=3D10104
> > busy=3D0
> > cleared=3D235
> > bits_per_word=3D64
> > map_nr=3D158
> > alloc_hint=3D{503, 2913, 9827, 9851}
> > wake_batch=3D8
> > wake_index=3D0
> > ws_active=3D0
> > ws=3D{
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> >          {.wait=3Dinactive},
> > }
> > round_robin=3D0
> > min_shallow_depth=3D4294967295
> >
> >
> > Thanks for your continued assistance with this!
> > Jason
> >
> >
> >> Thanks,
> >> Kuai
> >>
> >>> &mddev->recovery));
> >>> 6399                    if (atomic_read(&conf->reshape_stripes) !=3D =
0)
> >>> 6400                            return 0;
> >>>
> >>> Thanks
> >>>
> >>> On Mon, Sep 4, 2023 at 6:08=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2023/09/05 0:38, Jason Moss =E5=86=99=E9=81=93:
> >>>>> Hi Kuai,
> >>>>>
> >>>>> Thank you for the suggestion, I was previously on 5.15.0. I've buil=
t
> >>>>> an environment with 6.5.0.1 now and assembled the array there, but =
the
> >>>>> same problem happens. It reshaped for 20-30 seconds, then completel=
y
> >>>>> stopped.
> >>>>>
> >>>>> Processes and /proc/<PID>/stack output:
> >>>>> root       24593  0.0  0.0      0     0 ?        I<   09:22   0:00 =
[raid5wq]
> >>>>> root       24594 96.5  0.0      0     0 ?        R    09:22   2:29 =
[md0_raid6]
> >>>>> root       24595  0.3  0.0      0     0 ?        D    09:22   0:00 =
[md0_reshape]
> >>>>>
> >>>>> [root@arch ~]# cat /proc/24593/stack
> >>>>> [<0>] rescuer_thread+0x2b0/0x3b0
> >>>>> [<0>] kthread+0xe8/0x120
> >>>>> [<0>] ret_from_fork+0x34/0x50
> >>>>> [<0>] ret_from_fork_asm+0x1b/0x30
> >>>>>
> >>>>> [root@arch ~]# cat /proc/24594/stack
> >>>>>
> >>>>> [root@arch ~]# cat /proc/24595/stack
> >>>>> [<0>] reshape_request+0x416/0x9f0 [raid456]
> >>>> Can you provide the addr2line result? Let's see where reshape_reques=
t()
> >>>> is stuck first.
> >>>>
> >>>> Thanks,
> >>>> Kuai
> >>>>
> >>>>> [<0>] raid5_sync_request+0x2fc/0x3d0 [raid456]
> >>>>> [<0>] md_do_sync+0x7d6/0x11d0 [md_mod]
> >>>>> [<0>] md_thread+0xae/0x190 [md_mod]
> >>>>> [<0>] kthread+0xe8/0x120
> >>>>> [<0>] ret_from_fork+0x34/0x50
> >>>>> [<0>] ret_from_fork_asm+0x1b/0x30
> >>>>>
> >>>>> Please let me know if there's a better way to provide the stack inf=
o.
> >>>>>
> >>>>> Thank you
> >>>>>
> >>>>> On Sun, Sep 3, 2023 at 6:41=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud=
.com> wrote:
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>> =E5=9C=A8 2023/09/04 5:39, Jason Moss =E5=86=99=E9=81=93:
> >>>>>>> Hello,
> >>>>>>>
> >>>>>>> I recently attempted to add a new drive to my 8-drive RAID 6 arra=
y,
> >>>>>>> growing it to 9 drives. I've done similar before with the same ar=
ray,
> >>>>>>> having previously grown it from 6 drives to 7 and then from 7 to =
8
> >>>>>>> with no issues. Drives are WD Reds, most older than 2019, some
> >>>>>>> (including the newest) newer, but all confirmed CMR and not SMR.
> >>>>>>>
> >>>>>>> Process used to expand the array:
> >>>>>>> mdadm --add /dev/md0 /dev/sdb1
> >>>>>>> mdadm --grow --raid-devices=3D9 --backup-file=3D/root/grow_md0.ba=
k /dev/md0
> >>>>>>>
> >>>>>>> The reshape started off fine, the process was underway, and the v=
olume
> >>>>>>> was still usable as expected. However, 15-30 minutes into the res=
hape,
> >>>>>>> I lost access to the contents of the drive. Checking /proc/mdstat=
, the
> >>>>>>> reshape was stopped at 0.6% with the counter not incrementing at =
all.
> >>>>>>> Any process accessing the array would just hang until killed. I w=
aited
> >>>>>>
> >>>>>> What kernel version are you using? And it'll be very helpful if yo=
u can
> >>>>>> collect the stack of all stuck thread. There is a known deadlock f=
or
> >>>>>> raid5 related to reshape, and it's fixed in v6.5:
> >>>>>>
> >>>>>> https://lore.kernel.org/r/20230512015610.821290-6-yukuai1@huaweicl=
oud.com
> >>>>>>
> >>>>>>> a half hour and there was still no further change to the counter.=
 At
> >>>>>>> this point, I restarted the server and found that when it came ba=
ck up
> >>>>>>> it would begin reshaping again, but only very briefly, under 30
> >>>>>>> seconds, but the counter would be increasing during that time.
> >>>>>>>
> >>>>>>> I searched furiously for ideas and tried stopping and reassemblin=
g the
> >>>>>>> array, assembling with an invalid-backup flag, echoing "frozen" t=
hen
> >>>>>>> "reshape" to the sync_action file, and echoing "max" to the sync_=
max
> >>>>>>> file. Nothing ever seemed to make a difference.
> >>>>>>>
> >>>>>>
> >>>>>> Don't do this before v6.5, echo "reshape" while reshape is still i=
n
> >>>>>> progress will corrupt your data:
> >>>>>>
> >>>>>> https://lore.kernel.org/r/20230512015610.821290-3-yukuai1@huaweicl=
oud.com
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Kuai
> >>>>>>
> >>>>>>> Here is where I slightly panicked, worried that I'd borked my arr=
ay,
> >>>>>>> and powered off the server again and disconnected the new drive t=
hat
> >>>>>>> was just added, assuming that since it was the change, it may be =
the
> >>>>>>> problem despite having burn-in tested it, and figuring that I'll =
rush
> >>>>>>> order a new drive, so long as the reshape continues and I can jus=
t
> >>>>>>> rebuild onto a new drive once the reshape finishes. However, this=
 made
> >>>>>>> no difference and the array continued to not rebuild.
> >>>>>>>
> >>>>>>> Much searching later, I'd found nothing substantially different t=
hen
> >>>>>>> I'd already tried and one of the common threads in other people's
> >>>>>>> issues was bad drives, so I ran a self-test against each of the
> >>>>>>> existing drives and found one drive that failed the read test.
> >>>>>>> Thinking I had the culprit now, I dropped that drive out of the a=
rray
> >>>>>>> and assembled the array again, but the same behavior persists. Th=
e
> >>>>>>> array reshapes very briefly, then completely stops.
> >>>>>>>
> >>>>>>> Down to 0 drives of redundancy (in the reshaped section at least)=
, not
> >>>>>>> finding any new ideas on any of the forums, mailing list, wiki, e=
tc,
> >>>>>>> and very frustrated, I took a break, bought all new drives to bui=
ld a
> >>>>>>> new array in another server and restored from a backup. However, =
there
> >>>>>>> is still some data not captured by the most recent backup that I =
would
> >>>>>>> like to recover, and I'd also like to solve the problem purely to
> >>>>>>> understand what happened and how to recover in the future.
> >>>>>>>
> >>>>>>> Is there anything else I should try to recover this array, or is =
this
> >>>>>>> a lost cause?
> >>>>>>>
> >>>>>>> Details requested by the wiki to follow and I'm happy to collect =
any
> >>>>>>> further data that would assist. /dev/sdb is the new drive that wa=
s
> >>>>>>> added, then disconnected. /dev/sdh is the drive that failed a
> >>>>>>> self-test and was removed from the array.
> >>>>>>>
> >>>>>>> Thank you in advance for any help provided!
> >>>>>>>
> >>>>>>>
> >>>>>>> $ uname -a
> >>>>>>> Linux Blyth 5.15.0-76-generic #83-Ubuntu SMP Thu Jun 15 19:16:32 =
UTC
> >>>>>>> 2023 x86_64 x86_64 x86_64 GNU/Linux
> >>>>>>>
> >>>>>>> $ mdadm --version
> >>>>>>> mdadm - v4.2 - 2021-12-30
> >>>>>>>
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sda
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68EUZN0
> >>>>>>> Serial Number:    WD-WCC4N7AT7R7X
> >>>>>>> LU WWN Device Id: 5 0014ee 268545f93
> >>>>>>> Firmware Version: 82.00A82
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:27:55 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sda
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68EUZN0
> >>>>>>> Serial Number:    WD-WCC4N7AT7R7X
> >>>>>>> LU WWN Device Id: 5 0014ee 268545f93
> >>>>>>> Firmware Version: 82.00A82
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:16 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sdb
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68EUZN0
> >>>>>>> Serial Number:    WD-WXG1A8UGLS42
> >>>>>>> LU WWN Device Id: 5 0014ee 2b75ef53b
> >>>>>>> Firmware Version: 80.00A80
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:19 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sdc
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68EUZN0
> >>>>>>> Serial Number:    WD-WCC4N4HYL32Y
> >>>>>>> LU WWN Device Id: 5 0014ee 2630752f8
> >>>>>>> Firmware Version: 82.00A82
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:20 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sdd
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68N32N0
> >>>>>>> Serial Number:    WD-WCC7K1FF6DYK
> >>>>>>> LU WWN Device Id: 5 0014ee 2ba952a30
> >>>>>>> Firmware Version: 82.00A82
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Form Factor:      3.5 inches
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-3 T13/2161-D revision 5
> >>>>>>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:21 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sde
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68EUZN0
> >>>>>>> Serial Number:    WD-WCC4N5ZHTRJF
> >>>>>>> LU WWN Device Id: 5 0014ee 2b88b83bb
> >>>>>>> Firmware Version: 82.00A82
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:22 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sdf
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68AX9N0
> >>>>>>> Serial Number:    WD-WMC1T3804790
> >>>>>>> LU WWN Device Id: 5 0014ee 6036b6826
> >>>>>>> Firmware Version: 80.00A80
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:23 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sdg
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68EUZN0
> >>>>>>> Serial Number:    WD-WMC4N0H692Z9
> >>>>>>> LU WWN Device Id: 5 0014ee 65af39740
> >>>>>>> Firmware Version: 82.00A82
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:24 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sdh
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68EUZN0
> >>>>>>> Serial Number:    WD-WMC4N0K5S750
> >>>>>>> LU WWN Device Id: 5 0014ee 6b048d9ca
> >>>>>>> Firmware Version: 82.00A82
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Rotation Rate:    5400 rpm
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:24 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>> $ sudo smartctl -H -i -l scterc /dev/sdi
> >>>>>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (l=
ocal build)
> >>>>>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmo=
ntools.org
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >>>>>>> Model Family:     Western Digital Red
> >>>>>>> Device Model:     WDC WD30EFRX-68AX9N0
> >>>>>>> Serial Number:    WD-WMC1T1502475
> >>>>>>> LU WWN Device Id: 5 0014ee 058d2e5cb
> >>>>>>> Firmware Version: 80.00A80
> >>>>>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> >>>>>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
> >>>>>>> Device is:        In smartctl database [for details use: -P show]
> >>>>>>> ATA Version is:   ACS-2 (minor revision not indicated)
> >>>>>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> >>>>>>> Local Time is:    Sun Sep  3 13:28:27 2023 PDT
> >>>>>>> SMART support is: Available - device has SMART capability.
> >>>>>>> SMART support is: Enabled
> >>>>>>>
> >>>>>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> >>>>>>> SMART overall-health self-assessment test result: PASSED
> >>>>>>>
> >>>>>>> SCT Error Recovery Control:
> >>>>>>>                Read:     70 (7.0 seconds)
> >>>>>>>               Write:     70 (7.0 seconds)
> >>>>>>>
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sda
> >>>>>>> /dev/sda:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sda1
> >>>>>>> /dev/sda1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0xd
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247728 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : 8ca60ad5:60d19333:11b24820:91453532
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 23:12:08 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 24 sectors =
- bad
> >>>>>>> blocks present.
> >>>>>>>            Checksum : b6d8f4d1 - correct
> >>>>>>>              Events : 181105
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 7
> >>>>>>>        Array State : AA.AAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sdb
> >>>>>>> /dev/sdb:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sdb1
> >>>>>>> /dev/sdb1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0x5
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247728 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : 386d3001:16447e43:4d2a5459:85618d11
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124207104 (118.45 GiB 127.19 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 00:02:59 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 24 sectors
> >>>>>>>            Checksum : b544a39 - correct
> >>>>>>>              Events : 181077
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 8
> >>>>>>>        Array State : AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sdc
> >>>>>>> /dev/sdc:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sdc1
> >>>>>>> /dev/sdc1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0xd
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247720 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : 1798ec4f:72c56905:4e74ea61:2468db75
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 23:12:08 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 72 sectors =
- bad
> >>>>>>> blocks present.
> >>>>>>>            Checksum : 88d8b8fc - correct
> >>>>>>>              Events : 181105
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 4
> >>>>>>>        Array State : AA.AAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sdd
> >>>>>>> /dev/sdd:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sdd1
> >>>>>>> /dev/sdd1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0x5
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247728 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : a198095b:f54d26a9:deb3be8f:d6de9be1
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 23:12:08 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 24 sectors
> >>>>>>>            Checksum : d1471d9d - correct
> >>>>>>>              Events : 181105
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 6
> >>>>>>>        Array State : AA.AAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sde
> >>>>>>> /dev/sde:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sde1
> >>>>>>> /dev/sde1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0x5
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247720 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : acf7ba2e:35d2fa91:6b12b0ce:33a73af5
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 23:12:08 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 72 sectors
> >>>>>>>            Checksum : e05d0278 - correct
> >>>>>>>              Events : 181105
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 5
> >>>>>>>        Array State : AA.AAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sdf
> >>>>>>> /dev/sdf:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sdf1
> >>>>>>> /dev/sdf1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0x5
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247720 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : 31e7b86d:c274ff45:aa6dab50:2ff058c6
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 23:12:08 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 72 sectors
> >>>>>>>            Checksum : 26792cc0 - correct
> >>>>>>>              Events : 181105
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 0
> >>>>>>>        Array State : AA.AAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sdg
> >>>>>>> /dev/sdg:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sdg1
> >>>>>>> /dev/sdg1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0x5
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247720 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : 74476ce7:4edc23f6:08120711:ba281425
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 23:12:08 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 72 sectors
> >>>>>>>            Checksum : 6f67d179 - correct
> >>>>>>>              Events : 181105
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 1
> >>>>>>>        Array State : AA.AAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sdh
> >>>>>>> /dev/sdh:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sdh1
> >>>>>>> /dev/sdh1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0xd
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247720 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : 31c08263:b135f0f5:763bc86b:f81d7296
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124207104 (118.45 GiB 127.19 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 20:09:14 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 72 sectors =
- bad
> >>>>>>> blocks present.
> >>>>>>>            Checksum : b7696b68 - correct
> >>>>>>>              Events : 181089
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 2
> >>>>>>>        Array State : AAAAAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --examine /dev/sdi
> >>>>>>> /dev/sdi:
> >>>>>>>        MBR Magic : aa55
> >>>>>>> Partition[0] :   4294967295 sectors at            1 (type ee)
> >>>>>>> $ sudo mdadm --examine /dev/sdi1
> >>>>>>> /dev/sdi1:
> >>>>>>>               Magic : a92b4efc
> >>>>>>>             Version : 1.2
> >>>>>>>         Feature Map : 0x5
> >>>>>>>          Array UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                Name : Blyth:0  (local to host Blyth)
> >>>>>>>       Creation Time : Tue Aug  4 23:47:57 2015
> >>>>>>>          Raid Level : raid6
> >>>>>>>        Raid Devices : 9
> >>>>>>>
> >>>>>>>      Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
> >>>>>>>          Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
> >>>>>>>       Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
> >>>>>>>         Data Offset : 247808 sectors
> >>>>>>>        Super Offset : 8 sectors
> >>>>>>>        Unused Space : before=3D247720 sectors, after=3D14336 sect=
ors
> >>>>>>>               State : clean
> >>>>>>>         Device UUID : ac1063fc:d9d66e6d:f3de33da:b396f483
> >>>>>>>
> >>>>>>> Internal Bitmap : 8 sectors from superblock
> >>>>>>>       Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
> >>>>>>>       Delta Devices : 1 (8->9)
> >>>>>>>
> >>>>>>>         Update Time : Tue Jul 11 23:12:08 2023
> >>>>>>>       Bad Block Log : 512 entries available at offset 72 sectors
> >>>>>>>            Checksum : 23b6d024 - correct
> >>>>>>>              Events : 181105
> >>>>>>>
> >>>>>>>              Layout : left-symmetric
> >>>>>>>          Chunk Size : 512K
> >>>>>>>
> >>>>>>>        Device Role : Active device 3
> >>>>>>>        Array State : AA.AAAAA. ('A' =3D=3D active, '.' =3D=3D mis=
sing, 'R' =3D=3D replacing)
> >>>>>>>
> >>>>>>> $ sudo mdadm --detail /dev/md0
> >>>>>>> /dev/md0:
> >>>>>>>                Version : 1.2
> >>>>>>>             Raid Level : raid6
> >>>>>>>          Total Devices : 9
> >>>>>>>            Persistence : Superblock is persistent
> >>>>>>>
> >>>>>>>                  State : inactive
> >>>>>>>        Working Devices : 9
> >>>>>>>
> >>>>>>>          Delta Devices : 1, (-1->0)
> >>>>>>>              New Level : raid6
> >>>>>>>             New Layout : left-symmetric
> >>>>>>>          New Chunksize : 512K
> >>>>>>>
> >>>>>>>                   Name : Blyth:0  (local to host Blyth)
> >>>>>>>                   UUID : 440dc11e:079308b1:131eda79:9a74c670
> >>>>>>>                 Events : 181105
> >>>>>>>
> >>>>>>>         Number   Major   Minor   RaidDevice
> >>>>>>>
> >>>>>>>            -       8        1        -        /dev/sda1
> >>>>>>>            -       8      129        -        /dev/sdi1
> >>>>>>>            -       8      113        -        /dev/sdh1
> >>>>>>>            -       8       97        -        /dev/sdg1
> >>>>>>>            -       8       81        -        /dev/sdf1
> >>>>>>>            -       8       65        -        /dev/sde1
> >>>>>>>            -       8       49        -        /dev/sdd1
> >>>>>>>            -       8       33        -        /dev/sdc1
> >>>>>>>            -       8       17        -        /dev/sdb1
> >>>>>>>
> >>>>>>> $ cat /proc/mdstat
> >>>>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [rai=
d5]
> >>>>>>> [raid4] [raid10]
> >>>>>>> md0 : inactive sdb1[9](S) sdi1[4](S) sdf1[0](S) sdg1[1](S) sdh1[3=
](S)
> >>>>>>> sda1[8](S) sdd1[7](S) sdc1[6](S) sde1[5](S)
> >>>>>>>           26353689600 blocks super 1.2
> >>>>>>>
> >>>>>>> unused devices: <none>
> >>>>>>>
> >>>>>>> .
> >>>>>>>
> >>>>>>
> >>>>>
> >>>>> .
> >>>>>
> >>>>
> >>>
> >>> .
> >>>
> >>
> >
> > .
> >
>
