Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED46FC4332F
	for <linux-raid@archiver.kernel.org>; Fri, 11 Nov 2022 04:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiKKEO4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Nov 2022 23:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKKEOy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Nov 2022 23:14:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B31526E
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 20:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7829DCE24F4
        for <linux-raid@vger.kernel.org>; Fri, 11 Nov 2022 04:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB9AC433D6
        for <linux-raid@vger.kernel.org>; Fri, 11 Nov 2022 04:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668140088;
        bh=2C6vcbC9F5cwH1TgLsNqQSqIM+kszMycIktohmoi6Es=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VhlINCd+lnDjLnU04lW9G66pyFXQHlJjy6+q/qrGOPv/zJI/rSIc9zMU1K96uIn6U
         HzAvtryHMF4xoFM+1T8F3AzPN4npsBvsDcm1q7aqY6ccPXpGm+s8HNvPZFO/YMPrbr
         rP/b7kApv3tGupKKVc07lIiI/+u9aDMmBZdZzY63vcWllDUjNt8WsKvLiiWpzkr0jr
         N+8/uYPqRSAeVflpLaIV+GEdMPW/uH824JotgiK/YMvkYTxvM/Y4AlR12Efyz0b0Ed
         eYfQowxx8Oai0lB67SJyYz6LehP1gST2uf8ZAlv3VA0r8zjXtnLo6KOEmmsu7PHP8P
         E9/nvjrL9AQaw==
Received: by mail-ej1-f42.google.com with SMTP id y14so9980943ejd.9
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 20:14:48 -0800 (PST)
X-Gm-Message-State: ANoB5pmIw3m0K0Z79q5mT7Ydpx0PIqkvWaVi/UiIaqzLG2SFc/AgAtai
        MvurY+BXk7ktnOsZfVY/niP3hMOkzkoYNIG2y34=
X-Google-Smtp-Source: AA0mqf4fAY0tbFmEnbMe4gYaP91xtOzDkbfWpk0F9irE+jN3Qg0d3v7aKiVQShH7oYoi/uWa22f+2o1/O5QuaP4Jb/M=
X-Received: by 2002:a17:907:9618:b0:78e:17ad:ba62 with SMTP id
 gb24-20020a170907961800b0078e17adba62mr422914ejc.719.1668140086829; Thu, 10
 Nov 2022 20:14:46 -0800 (PST)
MIME-Version: 1.0
References: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
 <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com>
 <CAP4dvsewcMPgTkx2R97J88xUi+NKVhn=cNC1cDFjRyi7suBBKA@mail.gmail.com> <CAP4dvsdJsVetmhsazYqXkbjSKd44-2EZ4gLtHmXL4f7knZH-YQ@mail.gmail.com>
In-Reply-To: <CAP4dvsdJsVetmhsazYqXkbjSKd44-2EZ4gLtHmXL4f7knZH-YQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Nov 2022 22:14:34 -0600
X-Gmail-Original-Message-ID: <CAPhsuW4Y3o=Q3w3mSO40y5SozatF+p+dyr-jcjP05gwOs596qg@mail.gmail.com>
Message-ID: <CAPhsuW4Y3o=Q3w3mSO40y5SozatF+p+dyr-jcjP05gwOs596qg@mail.gmail.com>
Subject: Re: [External] Re: raid5 deadlock issue
To:     Zhang Tianci <zhangtianci.1997@bytedance.com>
Cc:     linux-raid@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 10, 2022 at 10:25 AM Zhang Tianci
<zhangtianci.1997@bytedance.com> wrote:
>

> > fio -filename=testfile -ioengine=libaio -bs=16M -size=10G -numjobs=100
> > -iodepth=1 -runtime=60
> > -rw=write -group_reporting -name="test"
> >
> > Then I found the first deadlock state, but it is not the real reason.
> >
> > I will do a test with the latest kernel. I will report to you the result later.
> >
> I can reproduce the first deadlock in linux-6.1-rc4.
> There are 26 stripe_head and 26 fio threads blocked with same backtrace:
>
>  #0 [ffffc9000cd0f8b0] __schedule at ffffffff818b3c3c
>  #1 [ffffc9000cd0f940] schedule at ffffffff818b4313
>  #2 [ffffc9000cd0f950] md_bitmap_startwrite at ffffffffc063354a [md_mod]
>  #3 [ffffc9000cd0f9c0] __add_stripe_bio at ffffffffc064fbd6 [raid456]
>  #4 [ffffc9000cd0fa00] raid5_make_request at ffffffffc065a84c [raid456]
>  #5 [ffffc9000cd0fb30] md_handle_request at ffffffffc0628496 [md_mod]
>  #6 [ffffc9000cd0fb98] __submit_bio at ffffffff813f308f
>  #7 [ffffc9000cd0fbb8] submit_bio_noacct_nocheck at ffffffff813f3501
>  #8 [ffffc9000cd0fc00] __block_write_full_page at ffffffff8134ca64
>  #9 [ffffc9000cd0fc60] __writepage at ffffffff8123f4a3
> #10 [ffffc9000cd0fc78] write_cache_pages at ffffffff8123fb57
> #11 [ffffc9000cd0fd70] generic_writepages at ffffffff8123feef
> #12 [ffffc9000cd0fdc0] do_writepages at ffffffff81241f12
> #13 [ffffc9000cd0fe28] filemap_fdatawrite_wbc at ffffffff8123306b
> #14 [ffffc9000cd0fe48] __filemap_fdatawrite_range at ffffffff81239154
> #15 [ffffc9000cd0fec0] file_write_and_wait_range at ffffffff812393e1
> #16 [ffffc9000cd0fef0] blkdev_fsync at ffffffff813ec223
> #17 [ffffc9000cd0ff08] do_fsync at ffffffff81342798
> #18 [ffffc9000cd0ff30] __x64_sys_fsync at ffffffff813427e0
> #19 [ffffc9000cd0ff38] do_syscall_64 at ffffffff818a6114
> #20 [ffffc9000cd0ff50] entry_SYSCALL_64_after_hwframe at ffffffff81a0009b

Thanks for this information.

I guess this is with COUNTER_MAX of 4? And it is slightly different to the
issue you found?

I will try to look into this next week (taking some time off this week).

Thanks,
Song
