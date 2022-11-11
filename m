Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBB2C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 11 Nov 2022 06:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiKKGbC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Nov 2022 01:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiKKGag (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Nov 2022 01:30:36 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C87C08
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 22:27:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b11so3662687pjp.2
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 22:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rZRGhBQnuLhAXoV4LViZ84WNiHK7LM/GDP2mXgcZxJk=;
        b=aIHIL6W+BChxH+HbK3nX4SRD4mPZWu+42e+QrNNdVivvlmFq5SGuGW3cWLMYJL7IDN
         kUZJIUGA7J59khHhT9K2j0fcfykE2daqp3c4C7AYHcrDTc5wqgyJmBDXizMHSbDuEVxX
         bbgbDlyXoOJhQ5LRhUVeYSkMxEoHcUh9WSox05WRuoGo9l4E+l1FMN3Zy7IfOe1V7kA4
         aFYvsRjzOQXr8JleOonwut8WuGcMuEFYAEn7CaB4YBpozMWu+bAwx6uKMIvKIHi8Hm10
         uCuquq8xkbqhYnsri8f+PLna340jPCBksJQvw/B3Ttnjx9y3HQX/aQNCZLPYW4/3QooK
         PYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rZRGhBQnuLhAXoV4LViZ84WNiHK7LM/GDP2mXgcZxJk=;
        b=13s/f3h1psV0xZSnSP25893cyeb9IeTjN31fNBFxZlwUgLdgRuMtFxYTMvkpLhlIfS
         91FFU0GrhObbr3uZKh+3v/oPpYMKazVCx0LixXJY80kvkwI2zv41KCWqB7sX6bBfKSZf
         1hpEgpY7klYZZlAvHN0TIoR+qEKKDJZkXFSm9xfAr2+LIZYdeobm27Vz08ow8D3R+yup
         +HzzjuHGYXRyjvUN13ikoob0najMq9GX9MjWbzNzxYB9kLpU2qavcW8V3lHKcKDHonjn
         /FK9bboVMiyXMyEGYrD6N0HA7NDtRO8Od198+h5E9sDyG/LqwfKXGu4WdJIAa0ULJP4L
         90eQ==
X-Gm-Message-State: ANoB5pkWtzGNvJOt6bP1w2nfypCGtebRZ4KfX+GZisyZcENEDG3e7WvE
        xqURbIoQj9D++xDwA+CGHWupyOULPhBJJZvy3QdwVNhNUsEjR3az
X-Google-Smtp-Source: AA0mqf6CO3U4tFZ3KV7FDEHRDwPMy/pAjhMFNC5jqWi/JUkKPgOAh3Up9phFXAEvZRrBPNjvtaQExhbSBaRjeelg1zA=
X-Received: by 2002:a17:902:b183:b0:186:9b19:1dbb with SMTP id
 s3-20020a170902b18300b001869b191dbbmr1291839plr.59.1668148025781; Thu, 10 Nov
 2022 22:27:05 -0800 (PST)
MIME-Version: 1.0
References: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
 <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com>
 <CAP4dvsewcMPgTkx2R97J88xUi+NKVhn=cNC1cDFjRyi7suBBKA@mail.gmail.com>
 <CAP4dvsdJsVetmhsazYqXkbjSKd44-2EZ4gLtHmXL4f7knZH-YQ@mail.gmail.com> <CAPhsuW4Y3o=Q3w3mSO40y5SozatF+p+dyr-jcjP05gwOs596qg@mail.gmail.com>
In-Reply-To: <CAPhsuW4Y3o=Q3w3mSO40y5SozatF+p+dyr-jcjP05gwOs596qg@mail.gmail.com>
From:   Zhang Tianci <zhangtianci.1997@bytedance.com>
Date:   Fri, 11 Nov 2022 14:26:54 +0800
Message-ID: <CAP4dvscWyUKUWE=NxgFTWLROatNb2rPi0WaGdVQsC+8o-VqbHg@mail.gmail.com>
Subject: Re: [External] Re: raid5 deadlock issue
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 11, 2022 at 12:14 PM Song Liu <song@kernel.org> wrote:
>
> On Thu, Nov 10, 2022 at 10:25 AM Zhang Tianci
> <zhangtianci.1997@bytedance.com> wrote:
> >
>
> > > fio -filename=testfile -ioengine=libaio -bs=16M -size=10G -numjobs=100
> > > -iodepth=1 -runtime=60
> > > -rw=write -group_reporting -name="test"
> > >
> > > Then I found the first deadlock state, but it is not the real reason.
> > >
> > > I will do a test with the latest kernel. I will report to you the result later.
> > >
> > I can reproduce the first deadlock in linux-6.1-rc4.
> > There are 26 stripe_head and 26 fio threads blocked with same backtrace:
> >
> >  #0 [ffffc9000cd0f8b0] __schedule at ffffffff818b3c3c
> >  #1 [ffffc9000cd0f940] schedule at ffffffff818b4313
> >  #2 [ffffc9000cd0f950] md_bitmap_startwrite at ffffffffc063354a [md_mod]
> >  #3 [ffffc9000cd0f9c0] __add_stripe_bio at ffffffffc064fbd6 [raid456]
> >  #4 [ffffc9000cd0fa00] raid5_make_request at ffffffffc065a84c [raid456]
> >  #5 [ffffc9000cd0fb30] md_handle_request at ffffffffc0628496 [md_mod]
> >  #6 [ffffc9000cd0fb98] __submit_bio at ffffffff813f308f
> >  #7 [ffffc9000cd0fbb8] submit_bio_noacct_nocheck at ffffffff813f3501
> >  #8 [ffffc9000cd0fc00] __block_write_full_page at ffffffff8134ca64
> >  #9 [ffffc9000cd0fc60] __writepage at ffffffff8123f4a3
> > #10 [ffffc9000cd0fc78] write_cache_pages at ffffffff8123fb57
> > #11 [ffffc9000cd0fd70] generic_writepages at ffffffff8123feef
> > #12 [ffffc9000cd0fdc0] do_writepages at ffffffff81241f12
> > #13 [ffffc9000cd0fe28] filemap_fdatawrite_wbc at ffffffff8123306b
> > #14 [ffffc9000cd0fe48] __filemap_fdatawrite_range at ffffffff81239154
> > #15 [ffffc9000cd0fec0] file_write_and_wait_range at ffffffff812393e1
> > #16 [ffffc9000cd0fef0] blkdev_fsync at ffffffff813ec223
> > #17 [ffffc9000cd0ff08] do_fsync at ffffffff81342798
> > #18 [ffffc9000cd0ff30] __x64_sys_fsync at ffffffff813427e0
> > #19 [ffffc9000cd0ff38] do_syscall_64 at ffffffff818a6114
> > #20 [ffffc9000cd0ff50] entry_SYSCALL_64_after_hwframe at ffffffff81a0009b
>
> Thanks for this information.
>
> I guess this is with COUNTER_MAX of 4? And it is slightly different to the
> issue you found?

Yes, I hack COUNTER_MAX to 4, I think this could increase the
probability of bitmap
counter racing.

And this kind of deadlock is very difficult to happen without hacking.

It just happened when I debugged, but it help me find a guess(the
second deadlock state
in the first email) about the real reason.

>
> I will try to look into this next week (taking some time off this week).

Thanks,
Tianci
