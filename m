Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F1EC43219
	for <linux-raid@archiver.kernel.org>; Thu, 10 Nov 2022 16:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiKJQZP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Nov 2022 11:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiKJQZN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Nov 2022 11:25:13 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5968C1EEE8
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 08:25:11 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id m6so2693581pfb.0
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 08:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wSIpqJ5G9/GYxcuyRCV5UZf+mT0CAlNIcgIn3a4tJ50=;
        b=uQANVpMu2E+KZ/BxSIvAYgkdXcAHPmLyzJODNDn5ylsFbUjugdPY8qfEFxULcCiN4p
         eFxvdZCiScT/QfbSS+7PA9PA/iyOqBh6G6HdOErNCZiXRhMpONEnH1S4nhSxXAPlLPOW
         f3eMvhtaG5GDsNbln2BmJA2WS7DO6MAS5LL0G9O33qhZy7gup62dquYUuUo+ci+l5v6q
         wiRzoqtleOasJFGpVqXFU381wWxmwfLTb3YPfXddGmEZx9CS/tPGSeOYjRYGqK16TLnD
         Lb6NKpcH1ZUTjNLnDm3r8E+UIytoAM4zoRAlAsTbELYShZkYoIsB+nUDhwAK4fyJ8Bhy
         k0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSIpqJ5G9/GYxcuyRCV5UZf+mT0CAlNIcgIn3a4tJ50=;
        b=qXGgvcy+SuEKaahtzwWCD9GAmYD61D+RKWsk6AJy8h6AYb51tJHwe/5EuvQVQQm/WO
         wHmxqbnNTtX5BKtUG3+ae4Yg6MyeC3Dv4nfId2iM6CJa/nJL+ReikSSLrLbI8Go83sm7
         bWY2HQfa0w6RusTmT0qMsxwcO/ibjl9yLluqXgt3QrZgMcl75YNkxrChJo9Mxd4Hz22b
         P6eWQiW3ZWBnnWkQb6Jnc9gGeANwdh0c4o7DDUdGv+puoiykffuvZuCBagA6zXkPIKUh
         ho3K73Rxg36z47+sHl0iRRuoO8PsnM2gL0WfAyR/9kzJqNnYM16jrAKiWHrQgtuiRDAY
         Z6BA==
X-Gm-Message-State: ACrzQf0bEYDtHCWrs8DFCnr03ueuaNRE+rWEiWOU2iWehkqpCP402Yaf
        yfGQyv9v7tjKz/lv3d8g9rXzv7qt4S9AQaWlm3PwspOV/R321bUe
X-Google-Smtp-Source: AMsMyM7DkOY7jay+CWKMWoGqIN0B1SejyHWV/YuKV5ErUmyd40FHfP3SntPsnccoDJANVoDkAvDTTx/C/EzmeExfOiU=
X-Received: by 2002:a63:e045:0:b0:46f:e244:3136 with SMTP id
 n5-20020a63e045000000b0046fe2443136mr43971733pgj.95.1668097509647; Thu, 10
 Nov 2022 08:25:09 -0800 (PST)
MIME-Version: 1.0
References: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
 <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com> <CAP4dvsewcMPgTkx2R97J88xUi+NKVhn=cNC1cDFjRyi7suBBKA@mail.gmail.com>
In-Reply-To: <CAP4dvsewcMPgTkx2R97J88xUi+NKVhn=cNC1cDFjRyi7suBBKA@mail.gmail.com>
From:   Zhang Tianci <zhangtianci.1997@bytedance.com>
Date:   Fri, 11 Nov 2022 00:24:58 +0800
Message-ID: <CAP4dvsdJsVetmhsazYqXkbjSKd44-2EZ4gLtHmXL4f7knZH-YQ@mail.gmail.com>
Subject: Re: [External] Re: raid5 deadlock issue
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 10, 2022 at 11:24 AM Zhang Tianci
<zhangtianci.1997@bytedance.com> wrote:
>
> Hi Song,
>
> Thanks for your quick reply.
>
> On Thu, Nov 10, 2022 at 6:37 AM Song Liu <song@kernel.org> wrote:
> >
> >  Hi Tianci,
> >
> > Thanks for the report.
> >
> >
> > On Tue, Nov 8, 2022 at 10:50 PM Zhang Tianci
> > <zhangtianci.1997@bytedance.com> wrote:
> > >
> > > Hi Song,
> > >
> > > I am tracking down a deadlock in Linux-5.4.56.
> > >
> > [...]
> > >
> > > $ cat /proc/mdstat
> > > Personalities : [raid6] [raid5] [raid4]
> > > md10 : active raid5 nvme9n1p1[9] nvme8n1p1[7] nvme7n1p1[6]
> > > nvme6n1p1[5] nvme5n1p1[4] nvme4n1p1[3] nvme3n1p1[2] nvme2n1p1[1]
> > > nvme1n1p1[0]
> > >       15001927680 blocks super 1.2 level 5, 512k chunk, algorithm 2
> > > [9/9] [UUUUUUUUU]
> > >       [====>................]  check = 21.0% (394239024/1875240960)
> > > finish=1059475.2min speed=23K/sec
> > >       bitmap: 1/14 pages [4KB], 65536KB chunk
> >
> > How many instances of this issue do we have? If more than one, I wonder
> > they are all running the raid5 check (as this one is).
>
> We have three instances, but reboot one machine, so we have two machines now.
>
> And you are right, they are all running the raid5 check, but because I
> have debugged
> this problem for almost three weeks, and I remember they were not
> doing sync when
> I first checked /proc/mdstat.
>
> Now their raid5_resync threads backtrace are all:
>
> #0 [ffffa8d15fedfb90] __schedule at ffffffffa0d93b2d
>  #1 [ffffa8d15fedfc20] schedule at ffffffffa0d93eaa
>  #2 [ffffa8d15fedfc38] md_bitmap_cond_end_sync at ffffffffc045758e [md_mod]
>  #3 [ffffa8d15fedfc90] raid5_sync_request at ffffffffc0637e2f [raid456]
>  #4 [ffffa8d15fedfcf8] md_do_sync at ffffffffc044bd1c [md_mod]
>  #5 [ffffa8d15fedfe98] md_thread at ffffffffc0448e50 [md_mod]
>  #6 [ffffa8d15fedff10] kthread at ffffffffa06b0d76
>  #7 [ffffa8d15fedff50] ret_from_fork at ffffffffa0e001cf
>
> So I guess the resync thread is just a victim.
>
> >
> > >
> > > $ mdadm -D /dev/md10
> > > /dev/md10:
> > >         Version : 1.2
> > >   Creation Time : Fri Sep 23 11:47:03 2022
> > >      Raid Level : raid5
> > >      Array Size : 15001927680 (14306.95 GiB 15361.97 GB)
> > >   Used Dev Size : 1875240960 (1788.37 GiB 1920.25 GB)
> > >    Raid Devices : 9
> > >   Total Devices : 9
> > >     Persistence : Superblock is persistent
> > >
> > >   Intent Bitmap : Internal
> > >
> > >     Update Time : Sun Nov  6 01:29:49 2022
> > >           State : active, checking
> > >  Active Devices : 9
> > > Working Devices : 9
> > >  Failed Devices : 0
> > >   Spare Devices : 0
> > >
> > >          Layout : left-symmetric
> > >      Chunk Size : 512K
> > >
> > >    Check Status : 21% complete
> > >
> > >            Name : dc02-pd-t8-n021:10  (local to host dc02-pd-t8-n021)
> > >            UUID : 089300e1:45b54872:31a11457:a41ad66a
> > >          Events : 3968
> > >
> > >     Number   Major   Minor   RaidDevice State
> > >        0     259        8        0      active sync   /dev/nvme1n1p1
> > >        1     259        6        1      active sync   /dev/nvme2n1p1
> > >        2     259        7        2      active sync   /dev/nvme3n1p1
> > >        3     259       12        3      active sync   /dev/nvme4n1p1
> > >        4     259       11        4      active sync   /dev/nvme5n1p1
> > >        5     259       14        5      active sync   /dev/nvme6n1p1
> > >        6     259       13        6      active sync   /dev/nvme7n1p1
> > >        7     259       21        7      active sync   /dev/nvme8n1p1
> > >        9     259       20        8      active sync   /dev/nvme9n1p1
> > >
> > > And some internal state of the raid5 by crash or sysfs:
> > >
> > > $ cat /sys/block/md10/md/stripe_cache_active
> > > 4430               # There are so many active stripe_head
> > >
> > > crash > foreach UN bt | grep md_bitmap_startwrite | wc -l
> > > 48                    # So there are only 48 stripe_head blocked by
> > > the bitmap counter.
> > > crash > list -o stripe_head.lru -s stripe_head.state -O
> > > r5conf.delayed_list -h 0xffff90c1951d5000
> > > .... # There are so many stripe_head, and the number is 4382.
> > >
> > > There are 4430 active stripe_head, and 4382 are in delayed_list, the
> > > last 48 blocked by the bitmap counter.
> > > So I guess this is the second deadlock.
> > >
> > > Then I reviewed the changelog after the commit 391b5d39faea "md/raid5:
> > > Fix Force reconstruct-write io stuck in degraded raid5" date
> > > 2020-07-31, and found no related fixup commit. And I'm not sure my
> > > understanding of raid5 is right. So I wondering if you can help
> > > confirm whether my thoughts are right or not.
> >
> > Have you tried to reproduce this with the latest kernel? There are a few fixes
> > after 2020, for example
> >
> >   commit 3312e6c887fe7539f0adb5756ab9020282aaa3d4
> >
> Thanks for your commit, I tried to understand this commit, and I think
> it is an optimization
> of the batch list but not a fixup?
>
> I have not tried to reproduce this with the latest kernel, because the
> max bitmap counter
> (1 << 14) is so large that I think it is difficult to reproduce. So I
> create a special
> environment by hacking kernel(base on 5.4.56) that changes the bitmap counter
> max number(COUNTER_MAX) to 4. Then I could get a deadlock by this command:
>
> fio -filename=testfile -ioengine=libaio -bs=16M -size=10G -numjobs=100
> -iodepth=1 -runtime=60
> -rw=write -group_reporting -name="test"
>
> Then I found the first deadlock state, but it is not the real reason.
>
> I will do a test with the latest kernel. I will report to you the result later.
>
I can reproduce the first deadlock in linux-6.1-rc4.
There are 26 stripe_head and 26 fio threads blocked with same backtrace:

 #0 [ffffc9000cd0f8b0] __schedule at ffffffff818b3c3c
 #1 [ffffc9000cd0f940] schedule at ffffffff818b4313
 #2 [ffffc9000cd0f950] md_bitmap_startwrite at ffffffffc063354a [md_mod]
 #3 [ffffc9000cd0f9c0] __add_stripe_bio at ffffffffc064fbd6 [raid456]
 #4 [ffffc9000cd0fa00] raid5_make_request at ffffffffc065a84c [raid456]
 #5 [ffffc9000cd0fb30] md_handle_request at ffffffffc0628496 [md_mod]
 #6 [ffffc9000cd0fb98] __submit_bio at ffffffff813f308f
 #7 [ffffc9000cd0fbb8] submit_bio_noacct_nocheck at ffffffff813f3501
 #8 [ffffc9000cd0fc00] __block_write_full_page at ffffffff8134ca64
 #9 [ffffc9000cd0fc60] __writepage at ffffffff8123f4a3
#10 [ffffc9000cd0fc78] write_cache_pages at ffffffff8123fb57
#11 [ffffc9000cd0fd70] generic_writepages at ffffffff8123feef
#12 [ffffc9000cd0fdc0] do_writepages at ffffffff81241f12
#13 [ffffc9000cd0fe28] filemap_fdatawrite_wbc at ffffffff8123306b
#14 [ffffc9000cd0fe48] __filemap_fdatawrite_range at ffffffff81239154
#15 [ffffc9000cd0fec0] file_write_and_wait_range at ffffffff812393e1
#16 [ffffc9000cd0fef0] blkdev_fsync at ffffffff813ec223
#17 [ffffc9000cd0ff08] do_fsync at ffffffff81342798
#18 [ffffc9000cd0ff30] __x64_sys_fsync at ffffffff813427e0
#19 [ffffc9000cd0ff38] do_syscall_64 at ffffffff818a6114
#20 [ffffc9000cd0ff50] entry_SYSCALL_64_after_hwframe at ffffffff81a0009b

> Thanks,
> Tianci
