Return-Path: <SRS0=oy2H=DM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E10C4727E
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 07:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 750042075A
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 07:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601883671;
	bh=CrPB3b/CTeo6piJZ4zrJbk2F/E42BpOrNE57xjhDsn0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=cndNWOqQKTsZ3Z4wuisvjhLn8dWVVLyS3YL9V7A//jIHZDgbm+j0L6Td4jppCECD6
	 jnzqjLL3x1B71MZLQknw8JhBULEiqYh2AWtzfN+wqSHkT9F2asK8Y6zgkcyzRDEyHU
	 LN8z0D5WzQfEZ+dkLQVmrb2MEfMZLu9dRTFe5VIE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgJEHlI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Oct 2020 03:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgJEHlI (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 5 Oct 2020 03:41:08 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A031620665
        for <linux-raid@vger.kernel.org>; Mon,  5 Oct 2020 07:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601883668;
        bh=CrPB3b/CTeo6piJZ4zrJbk2F/E42BpOrNE57xjhDsn0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FtWmHrJw1T/JA8tuQgoFgGcz9RFUrcFlrptX7QkL0rir3/Y4EG59qmjkQGEjyQrRs
         gCNJyeP9WxuR6aHRc9MoEJ8oTvCrzf+e4uouyYcj6zlYkNiSro94ThDwUzRRnXVEaF
         VGK5prIrkoQSVrnHbM184EeiVMb6rXLUVzwRkTCA=
Received: by mail-lf1-f50.google.com with SMTP id h6so2882984lfj.3
        for <linux-raid@vger.kernel.org>; Mon, 05 Oct 2020 00:41:07 -0700 (PDT)
X-Gm-Message-State: AOAM530VQa4UvaJ1yp6FD6Kly81+7/sJgX1l0uRr3IGlV/y6Hdn9AfiH
        HOQ7ZcH4GzB+s9bDqzfb6ycDDNRgcbFB0feq6NI=
X-Google-Smtp-Source: ABdhPJztE95cr71sljDm0W7GgKwe1sNmCK7rfn30IB8Quwm3P/0ebXyPDBLulND7JdK0hCerCgTQ7+Enb/6l+DJMncg=
X-Received: by 2002:a19:8c46:: with SMTP id i6mr4945795lfj.55.1601883665921;
 Mon, 05 Oct 2020 00:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <6F1A48DB-CA95-433B-91F3-D0051453A8E1@amazon.com>
 <CAPhsuW6q5bLgOUyuTH8MFTo6GSnGqRxne6sV+dsFHRy_qHtxRA@mail.gmail.com>
 <1600734878242.50073@amazon.com> <CAPhsuW4Q-aYzUQ=Utw6XigjJ0tVbCZOjmn+Wq6hvvjXhvAiwZA@mail.gmail.com>
In-Reply-To: <CAPhsuW4Q-aYzUQ=Utw6XigjJ0tVbCZOjmn+Wq6hvvjXhvAiwZA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 5 Oct 2020 00:40:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7+jnPkvzVsqn_Eh7TqB_HAuZRXTofar9ucj7rsqyfE9w@mail.gmail.com>
Message-ID: <CAPhsuW7+jnPkvzVsqn_Eh7TqB_HAuZRXTofar9ucj7rsqyfE9w@mail.gmail.com>
Subject: Re: RAID5 issue with UBUNTU 20.04.1 on my desktop
To:     "Sung, KoWei" <winders@amazon.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Duan, HanShen" <hansduan@amazon.com>,
        "Tokoyo, Hiroshi" <htokoyo@amazon.co.jp>,
        "Fortin, Mike" <mfortin@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi KoWei,

On Mon, Sep 28, 2020 at 10:15 AM Song Liu <song@kernel.org> wrote:
>
> On Mon, Sep 21, 2020 at 5:34 PM Sung, KoWei <winders@amazon.com> wrote:
> >
> > Hi, Song Liu:
> >
> > May I know if you're able to reproduce this issue? Thanks a lot for your help.
>

Could you please verify whether the following patch fixes it? If it
works well, please
reply with your Test-by tag.

Thanks,
Song

diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
index 66690b40818e7..39343479ac2a9 100644
--- i/drivers/md/raid5.c
+++ w/drivers/md/raid5.c
@@ -2585,8 +2585,6 @@ static int resize_stripes(struct r5conf *conf,
int newsize)
        } else
                err = -ENOMEM;

-       mutex_unlock(&conf->cache_size_mutex);
-
        conf->slab_cache = sc;
        conf->active_name = 1-conf->active_name;

@@ -2628,6 +2626,8 @@ static int resize_stripes(struct r5conf *conf,
int newsize)

        if (!err)
                conf->pool_size = newsize;
+       mutex_unlock(&conf->cache_size_mutex);
+
        return err;
 }
