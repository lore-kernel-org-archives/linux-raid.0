Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DC4C4321E
	for <linux-raid@archiver.kernel.org>; Wed, 30 Nov 2022 06:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiK3GWC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Nov 2022 01:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiK3GV5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Nov 2022 01:21:57 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BD831DF6
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 22:21:53 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id mv18so14845972pjb.0
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 22:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lT4cu8PMXo4ZPvi+XS0/JyNRrbFuVrL4pLpVao6apxY=;
        b=K965WoM2FnDufrycmDRvhzo5y274Ygos4RLTktw3p9HN4t6EvnLEB+Q4rb5b5l09C3
         zoxSLiL6NY4TJSA8+eWaQrAGts50KS8mW+3GVaRkCNgEKZ0bVTiNecm8WCkQNFrE5t6O
         lJtcnVLI+PbeyEYKD4fmYa8ETq+XB6xaiUTGtq5HsWWrPbqcGRRGIzDTlKU563W1yRHY
         VeUl3e+7TlaXqiz+z7FXpsha8+pY2MQFQfpALqJ5RXlfJ1dZmQEXNWiJr28CafDqqUwX
         3mK9hytoaY+NTXbMmJpCBzlop21ZfKcvm7/s+Xv0yzSyY5kX3BM8riq1y8/tRhbUv7gY
         zneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lT4cu8PMXo4ZPvi+XS0/JyNRrbFuVrL4pLpVao6apxY=;
        b=AzMtSwTWyuiH/CGw8VFXXke0ApJ75eFrGCrEC3u0h5kFwlB1DnMqCmriqJlmGA0EBV
         cJHfR6+B5d2tnmkpIJJEKNXgLsttoJJ4AKQ3xvS/SGq33BxwnekXUh6xomHVT+eqpEAJ
         FgHEqLHDEuAz9DOMSaf5q4/NtUfOlwmpH6z/JqRqqvSjPanwJf/NaAPBOm0l5d64P9Lz
         B2MbGv2SH1tzlC5GNjBLwMUBGntsE6eIEB+hfCuDZqxwcK1W5kA6xLGDV2SkfX+t8YOl
         qH5IztUB+o2C6+wg9QDp2n+iLtPIXWqKexkkhTQXU8NPxafWgVBVp/Icm4+mbJmx9WkT
         Owzw==
X-Gm-Message-State: ANoB5pn8eXasTm6BDKt11MlRf3UguFoEaYLA3GMunW30cFbLK7NFD0O7
        fR6DJ4uvZT4Kp2lstcu47BmR64COVbAPOY2TXJxYJqy2kI5sYA==
X-Google-Smtp-Source: AA0mqf5qF6pr5ltAVpopeEhSCPMTT7Z2SM9ZU6shwovnHX2TWYhhZ4YFLErhTWM4qrt5ttAoErULX4oHUYdPmwGMwVw=
X-Received: by 2002:a17:90a:8b03:b0:213:16d2:4d4c with SMTP id
 y3-20020a17090a8b0300b0021316d24d4cmr64265635pjn.70.1669789312748; Tue, 29
 Nov 2022 22:21:52 -0800 (PST)
MIME-Version: 1.0
References: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
 <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com>
 <CAP4dvsewcMPgTkx2R97J88xUi+NKVhn=cNC1cDFjRyi7suBBKA@mail.gmail.com>
 <CAP4dvsdJsVetmhsazYqXkbjSKd44-2EZ4gLtHmXL4f7knZH-YQ@mail.gmail.com>
 <CAPhsuW4Y3o=Q3w3mSO40y5SozatF+p+dyr-jcjP05gwOs596qg@mail.gmail.com> <CAP4dvscWyUKUWE=NxgFTWLROatNb2rPi0WaGdVQsC+8o-VqbHg@mail.gmail.com>
In-Reply-To: <CAP4dvscWyUKUWE=NxgFTWLROatNb2rPi0WaGdVQsC+8o-VqbHg@mail.gmail.com>
From:   Zhang Tianci <zhangtianci.1997@bytedance.com>
Date:   Wed, 30 Nov 2022 14:21:41 +0800
Message-ID: <CAP4dvse1TvqipOQnjQ5TjR87krsqz2_3Xd+EVtZJ=yMh2OfYag@mail.gmail.com>
Subject: Re: [External] Re: raid5 deadlock issue
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 11, 2022 at 2:26 PM Zhang Tianci
<zhangtianci.1997@bytedance.com> wrote:
>
> On Fri, Nov 11, 2022 at 12:14 PM Song Liu <song@kernel.org> wrote:
> >
> > On Thu, Nov 10, 2022 at 10:25 AM Zhang Tianci
> > <zhangtianci.1997@bytedance.com> wrote:
> > >
> >
> > > > fio -filename=testfile -ioengine=libaio -bs=16M -size=10G -numjobs=100
> > > > -iodepth=1 -runtime=60
> > > > -rw=write -group_reporting -name="test"
> > > >
> > > > Then I found the first deadlock state, but it is not the real reason.
> > > >
> > > > I will do a test with the latest kernel. I will report to you the result later.
> > > >
> > > I can reproduce the first deadlock in linux-6.1-rc4.
> > > There are 26 stripe_head and 26 fio threads blocked with same backtrace:
> > >
> > >  #0 [ffffc9000cd0f8b0] __schedule at ffffffff818b3c3c
> > >  #1 [ffffc9000cd0f940] schedule at ffffffff818b4313
> > >  #2 [ffffc9000cd0f950] md_bitmap_startwrite at ffffffffc063354a [md_mod]
> > >  #3 [ffffc9000cd0f9c0] __add_stripe_bio at ffffffffc064fbd6 [raid456]
> > >  #4 [ffffc9000cd0fa00] raid5_make_request at ffffffffc065a84c [raid456]
> > >  #5 [ffffc9000cd0fb30] md_handle_request at ffffffffc0628496 [md_mod]
> > >  #6 [ffffc9000cd0fb98] __submit_bio at ffffffff813f308f
> > >  #7 [ffffc9000cd0fbb8] submit_bio_noacct_nocheck at ffffffff813f3501
> > >  #8 [ffffc9000cd0fc00] __block_write_full_page at ffffffff8134ca64
> > >  #9 [ffffc9000cd0fc60] __writepage at ffffffff8123f4a3
> > > #10 [ffffc9000cd0fc78] write_cache_pages at ffffffff8123fb57
> > > #11 [ffffc9000cd0fd70] generic_writepages at ffffffff8123feef
> > > #12 [ffffc9000cd0fdc0] do_writepages at ffffffff81241f12
> > > #13 [ffffc9000cd0fe28] filemap_fdatawrite_wbc at ffffffff8123306b
> > > #14 [ffffc9000cd0fe48] __filemap_fdatawrite_range at ffffffff81239154
> > > #15 [ffffc9000cd0fec0] file_write_and_wait_range at ffffffff812393e1
> > > #16 [ffffc9000cd0fef0] blkdev_fsync at ffffffff813ec223
> > > #17 [ffffc9000cd0ff08] do_fsync at ffffffff81342798
> > > #18 [ffffc9000cd0ff30] __x64_sys_fsync at ffffffff813427e0
> > > #19 [ffffc9000cd0ff38] do_syscall_64 at ffffffff818a6114
> > > #20 [ffffc9000cd0ff50] entry_SYSCALL_64_after_hwframe at ffffffff81a0009b
> >
> > Thanks for this information.
> >
> > I guess this is with COUNTER_MAX of 4? And it is slightly different to the
> > issue you found?
>
> Yes, I hack COUNTER_MAX to 4, I think this could increase the
> probability of bitmap
> counter racing.
>
> And this kind of deadlock is very difficult to happen without hacking.
>
> It just happened when I debugged, but it help me find a guess(the
> second deadlock state
> in the first email) about the real reason.
>
> >
> > I will try to look into this next week (taking some time off this week).
>
> Thanks,
> Tianci

Hi Song,

We have met this problem in a new machine, and the /proc/mdstat is not
doing sync:

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md10 : active raid5 nvme9n1p1[9] nvme8n1p1[7] nvme7n1p1[6]
nvme6n1p1[5] nvme5n1p1[4] nvme4n1p1[3] nvme3n1p1[2] nvme2n1p1[1]
nvme1n1p1[0]
      15001927680 blocks super 1.2 level 5, 512k chunk, algorithm 2
[9/9] [UUUUUUUUU]
      bitmap: 6/14 pages [24KB], 65536KB chunk

unused devices: <none>

And there are 1w5+ stripe_head are blocked.

# cat /sys/block/md10/md/stripe_cache_active
15456

I guess this is the same problem as before.

What do you think about my deadlock guess in the first email?

Thanks,
Tianci
