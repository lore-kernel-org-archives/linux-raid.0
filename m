Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFD9C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 10 Nov 2022 03:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiKJDYv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKJDYt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Nov 2022 22:24:49 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB74713F5A
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 19:24:47 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q71so517334pgq.8
        for <linux-raid@vger.kernel.org>; Wed, 09 Nov 2022 19:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qZnS66QO0bta6Qni0AmhGGD3UWexkoC9MvTYVjx5Pe4=;
        b=kbbXNXrfsiECSiLuWVpq818rgwNJSA/4OZxDOxVe+MJ15+NfCj+fR64ToKDvn8oMM1
         h9sVrx4QjZ1rR1jdXMGXmT4GUqd6h1RdvIzY51Q4CpECGn38IWnyryKEW8TZ4rM4LP1z
         pqUOz2q/M9gGCeaR5l/Dupp6cgzzU4mcFwRdt2ivfLfsSi6SdBgyXPjiSmmbbibGy+0M
         BwJZczW/W6wiLRE8E/C2xZqn+GESQWh4nNCqhhtx3yOJ/QbunAvktUIAxSOb+GGmXas0
         G92DwKJoQhNhJTQW1iRoZk3dLib8X6cMioZmbOex2pSGEAOxiBWX6bgRgu7Q7K6nefyz
         JHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qZnS66QO0bta6Qni0AmhGGD3UWexkoC9MvTYVjx5Pe4=;
        b=MIFMvAinsR85+NAe+p/U4/FBNM/4zPrVAZu4+JsmFIo696KnVKILGJwOVhD42CpdL1
         uQkNNllbWAGMWzZmIpmSfMT4HKAUchjly9C7Wnj0ZL0klb4FcQLK/1TE5k8FlBFrv1VT
         hd4ZB9CE1glpv3M9ekqrC0lhz6J+rWZvoubw8eIrGY6o8D33leDMUdWbVppD8pBfSlrA
         cNPo2Cn/2dgPVCTAq5zUe1cMRlL+Xx10afvS8PKgH93ljtvHtUV5PSJrFJV47dMe0zyj
         PV/NXnmjmQhLAtpDzPFFMVIx2xIAcVxWs2fXOSnoHHH4cXq502RNYLX601dBSU/1J/gK
         61+g==
X-Gm-Message-State: ACrzQf3HY1j8E8rLOgUb2LUPQ7HZnzQtwYlV9j6B89ZuUTc7AcOqEGVz
        Rb4UyZQ6wFnpOgoOtOQHS3rVT1Aue8/T3TPzVYd5Jw==
X-Google-Smtp-Source: AMsMyM7EQcOQRYBFSy5ZHdYlIQXpkIQlRlWw+N/HAYxecBmWzeOjK17KJ0j/zCC98SAUXn8YCL7iT6k2fvFP6z5Yflo=
X-Received: by 2002:a05:6a00:cd6:b0:56d:9a94:4075 with SMTP id
 b22-20020a056a000cd600b0056d9a944075mr50895880pfv.67.1668050687416; Wed, 09
 Nov 2022 19:24:47 -0800 (PST)
MIME-Version: 1.0
References: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
 <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com>
In-Reply-To: <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com>
From:   Zhang Tianci <zhangtianci.1997@bytedance.com>
Date:   Thu, 10 Nov 2022 11:24:36 +0800
Message-ID: <CAP4dvsewcMPgTkx2R97J88xUi+NKVhn=cNC1cDFjRyi7suBBKA@mail.gmail.com>
Subject: Re: [External] Re: raid5 deadlock issue
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

Thanks for your quick reply.

On Thu, Nov 10, 2022 at 6:37 AM Song Liu <song@kernel.org> wrote:
>
>  Hi Tianci,
>
> Thanks for the report.
>
>
> On Tue, Nov 8, 2022 at 10:50 PM Zhang Tianci
> <zhangtianci.1997@bytedance.com> wrote:
> >
> > Hi Song,
> >
> > I am tracking down a deadlock in Linux-5.4.56.
> >
> [...]
> >
> > $ cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md10 : active raid5 nvme9n1p1[9] nvme8n1p1[7] nvme7n1p1[6]
> > nvme6n1p1[5] nvme5n1p1[4] nvme4n1p1[3] nvme3n1p1[2] nvme2n1p1[1]
> > nvme1n1p1[0]
> >       15001927680 blocks super 1.2 level 5, 512k chunk, algorithm 2
> > [9/9] [UUUUUUUUU]
> >       [====>................]  check = 21.0% (394239024/1875240960)
> > finish=1059475.2min speed=23K/sec
> >       bitmap: 1/14 pages [4KB], 65536KB chunk
>
> How many instances of this issue do we have? If more than one, I wonder
> they are all running the raid5 check (as this one is).

We have three instances, but reboot one machine, so we have two machines now.

And you are right, they are all running the raid5 check, but because I
have debugged
this problem for almost three weeks, and I remember they were not
doing sync when
I first checked /proc/mdstat.

Now their raid5_resync threads backtrace are all:

#0 [ffffa8d15fedfb90] __schedule at ffffffffa0d93b2d
 #1 [ffffa8d15fedfc20] schedule at ffffffffa0d93eaa
 #2 [ffffa8d15fedfc38] md_bitmap_cond_end_sync at ffffffffc045758e [md_mod]
 #3 [ffffa8d15fedfc90] raid5_sync_request at ffffffffc0637e2f [raid456]
 #4 [ffffa8d15fedfcf8] md_do_sync at ffffffffc044bd1c [md_mod]
 #5 [ffffa8d15fedfe98] md_thread at ffffffffc0448e50 [md_mod]
 #6 [ffffa8d15fedff10] kthread at ffffffffa06b0d76
 #7 [ffffa8d15fedff50] ret_from_fork at ffffffffa0e001cf

So I guess the resync thread is just a victim.

>
> >
> > $ mdadm -D /dev/md10
> > /dev/md10:
> >         Version : 1.2
> >   Creation Time : Fri Sep 23 11:47:03 2022
> >      Raid Level : raid5
> >      Array Size : 15001927680 (14306.95 GiB 15361.97 GB)
> >   Used Dev Size : 1875240960 (1788.37 GiB 1920.25 GB)
> >    Raid Devices : 9
> >   Total Devices : 9
> >     Persistence : Superblock is persistent
> >
> >   Intent Bitmap : Internal
> >
> >     Update Time : Sun Nov  6 01:29:49 2022
> >           State : active, checking
> >  Active Devices : 9
> > Working Devices : 9
> >  Failed Devices : 0
> >   Spare Devices : 0
> >
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >
> >    Check Status : 21% complete
> >
> >            Name : dc02-pd-t8-n021:10  (local to host dc02-pd-t8-n021)
> >            UUID : 089300e1:45b54872:31a11457:a41ad66a
> >          Events : 3968
> >
> >     Number   Major   Minor   RaidDevice State
> >        0     259        8        0      active sync   /dev/nvme1n1p1
> >        1     259        6        1      active sync   /dev/nvme2n1p1
> >        2     259        7        2      active sync   /dev/nvme3n1p1
> >        3     259       12        3      active sync   /dev/nvme4n1p1
> >        4     259       11        4      active sync   /dev/nvme5n1p1
> >        5     259       14        5      active sync   /dev/nvme6n1p1
> >        6     259       13        6      active sync   /dev/nvme7n1p1
> >        7     259       21        7      active sync   /dev/nvme8n1p1
> >        9     259       20        8      active sync   /dev/nvme9n1p1
> >
> > And some internal state of the raid5 by crash or sysfs:
> >
> > $ cat /sys/block/md10/md/stripe_cache_active
> > 4430               # There are so many active stripe_head
> >
> > crash > foreach UN bt | grep md_bitmap_startwrite | wc -l
> > 48                    # So there are only 48 stripe_head blocked by
> > the bitmap counter.
> > crash > list -o stripe_head.lru -s stripe_head.state -O
> > r5conf.delayed_list -h 0xffff90c1951d5000
> > .... # There are so many stripe_head, and the number is 4382.
> >
> > There are 4430 active stripe_head, and 4382 are in delayed_list, the
> > last 48 blocked by the bitmap counter.
> > So I guess this is the second deadlock.
> >
> > Then I reviewed the changelog after the commit 391b5d39faea "md/raid5:
> > Fix Force reconstruct-write io stuck in degraded raid5" date
> > 2020-07-31, and found no related fixup commit. And I'm not sure my
> > understanding of raid5 is right. So I wondering if you can help
> > confirm whether my thoughts are right or not.
>
> Have you tried to reproduce this with the latest kernel? There are a few fixes
> after 2020, for example
>
>   commit 3312e6c887fe7539f0adb5756ab9020282aaa3d4
>
Thanks for your commit, I tried to understand this commit, and I think
it is an optimization
of the batch list but not a fixup?

I have not tried to reproduce this with the latest kernel, because the
max bitmap counter
(1 << 14) is so large that I think it is difficult to reproduce. So I
create a special
environment by hacking kernel(base on 5.4.56) that changes the bitmap counter
max number(COUNTER_MAX) to 4. Then I could get a deadlock by this command:

fio -filename=testfile -ioengine=libaio -bs=16M -size=10G -numjobs=100
-iodepth=1 -runtime=60
-rw=write -group_reporting -name="test"

Then I found the first deadlock state, but it is not the real reason.

I will do a test with the latest kernel. I will report to you the result later.

Thanks,
Tianci
