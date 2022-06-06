Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2270EC43334
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 11:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiFFLzF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 07:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiFFLzD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 07:55:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75B9A6FD1E
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 04:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654516501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WZUFPcQC7IxFrWfBOIck+f16i6k6e8qELtgw/otWqss=;
        b=bh2UkF3u59PAM59Wm21p/UnRRQpx+d+795WXaU17dfATOKgfxfnfmwZBvQTCouk5+rd5PM
        YSuUDd8X6Kj3fc3sF5eDCZdj9GF4i1FNC0CEvE/n951LazDqHgBgQ8GxWH2HoAs0mW0aTZ
        H2lcTG8MORKecN18QPrIdxDzecA9Mag=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-yYScj-K7NPS7WTg8PRw6DQ-1; Mon, 06 Jun 2022 07:55:00 -0400
X-MC-Unique: yYScj-K7NPS7WTg8PRw6DQ-1
Received: by mail-ot1-f70.google.com with SMTP id a5-20020a9d4705000000b0060b9c5da2e0so4731974otf.2
        for <linux-raid@vger.kernel.org>; Mon, 06 Jun 2022 04:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WZUFPcQC7IxFrWfBOIck+f16i6k6e8qELtgw/otWqss=;
        b=ubUCD1+jRY7XrYNGIncqNvV1wF4cX2B1j1LrLNlySmAi2EvtUyXD2CQFRK1oNLCSp/
         c0c/CEMwrRtrtZklNVKSbn8+l9Mloi4BH+4WcfZCyxlcKk/6Gi4v4Xjq5D1OHdPgvNk0
         pWbwHk0bQvS2yz2H2eFA1FTdPq6Qd+8hJYQaowuQNaUWjISbvqeTBAz418n3DYMsAuX2
         0agu1UitwSFtzRrB95vaz9t5zbKJMrInJyNiaiAQCcyVJg1A9Ololkuf8I8Sf56jwykc
         Y/UcD/xYzk9NhqM6O5RSxETPEl849sQsaGSPqvthO/I5WF9p81wWaAI9Id/kphyI/zMM
         FDqw==
X-Gm-Message-State: AOAM533OBzuAcfCSuQmFVqtNkbbTmfQO/JOVGRVuanjXzxzNqbIgGizr
        otk/Ob1neD3cmVwvW5vc/SdEyLFu0K/UWGtiMijYsHvCU4L+E6ydW1SzT0AFpTtXoVYtmJxGP7B
        +fmh+fJQ9YXA7y/ehs+3biHCNY3SkTDwl5kom5g==
X-Received: by 2002:a05:6870:2425:b0:de:2fb0:1caa with SMTP id n37-20020a056870242500b000de2fb01caamr13490800oap.115.1654516499349;
        Mon, 06 Jun 2022 04:54:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6Rqcj89RcU8+8X9dml0JkCktA2q0aSV0l7Iw55fGsdh/fy7JI7hTBciBqhErB+xsCWESQigBNAXWAEQeDqwU=
X-Received: by 2002:a05:6870:2425:b0:de:2fb0:1caa with SMTP id
 n37-20020a056870242500b000de2fb01caamr13490790oap.115.1654516499092; Mon, 06
 Jun 2022 04:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
 <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com> <04d66d44-dc18-55f7-b044-defcbcf88fe0@linux.dev>
 <CALTww2_f5727NmOQw2=jiqg7DKSyYvEEMqvW_d_9UU0XT6n=4Q@mail.gmail.com>
 <f2e7af8c-074a-fc07-58a8-616616c59b64@linux.dev> <CALTww2-GtH7g5Z1-e73TOE_xDGvDF___LcUq-FO53yeHqoGYUQ@mail.gmail.com>
 <a709dffa-84b4-281f-45c5-a52634c632a6@linux.dev>
In-Reply-To: <a709dffa-84b4-281f-45c5-a52634c632a6@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 6 Jun 2022 19:54:48 +0800
Message-ID: <CALTww29z-NRNmDyzKmRk6iMW6pGg9AGQ3Krh2nyZzBOyDKZjYg@mail.gmail.com>
Subject: Re: [PATCH] md: only unlock mddev from action_store
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Logan Gunthorpe <logang@deltatee.com>, Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 6, 2022 at 5:55 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 6/6/22 5:36 PM, Xiao Ni wrote:
> >>> @@ -4827,12 +4827,14 @@ action_store(struct mddev *mddev, const char
> >>> *page, size_t len)
> >>>                           clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >>>                   if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> >>>                       mddev_lock(mddev) == 0) {
> >>> +                       mddev_suspend(mddev);
> >>>                           if (work_pending(&mddev->del_work))
> >>>                                   flush_workqueue(md_misc_wq);
> >>>                           if (mddev->sync_thread) {
> >>>                                   set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >>>                                   md_reap_sync_thread(mddev);
> >>>                           }
> >>> +                       mddev_resume(mddev);
> >>>                           mddev_unlock(mddev);
> >>>                   }
> >>>           } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> >> The action actually means sync action which are for internal IO instead
> >> of external IO, I suppose the semantic is different with above change.
> > The original problem should be i/o happen when interrupting the sync thread?
> > So the external i/o calls md_write_start and sets MD_SB_CHANGE_PENDING.
> > Then raid5d->md_check_recovery can't update superblock and handle internal
> > stripes. So the `echo idle` action is stuck.
>
> My point is action_store shouldn't disturb external IO, it should only
> deal with
> sync IO and relevant stuffs as the function is for sync_action node, no?

Yes, it's a change that was mentioned above. It depends on which way
we want to go.
In some sysfs file store functions, it also calls mddev_suspend. For
some situations,
it needs to choose if we need to stop the i/o temporarily.

Anyway, it's only a possible method I want to discuss. It's very good
for me to dig into this problem.
Now I have a better understanding of those codes :)

Best Regards
Xiao

