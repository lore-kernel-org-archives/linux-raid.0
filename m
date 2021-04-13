Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A01C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 05:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E218D613AF
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 05:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344821AbhDMF7d (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344909AbhDMF71 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 13 Apr 2021 01:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DF88613B1
        for <linux-raid@vger.kernel.org>; Tue, 13 Apr 2021 05:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618293548;
        bh=85u+TZJdFsW45/x8Kszgt3CDI/or3x6P+ySa5gQ4O1A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=deR2BI0UFRuL72V8gjZ55U3krW9kxry1MO/p4774fWWWH5xf1/7f1YLbGn38ayd0F
         WSsKowsUSAprYL4AWqnQ9u9ByogwdBAwVN+1SU4+XaoztkBCTR30i+X6p+5GPXXauv
         M9EEK9u57BUs2UI8wyNHVVgZn15Rou3q86/D3kmWSDE7hJltxzyb2u3RqG8GkraCt8
         dsjH7iBJiPxDYf1lhQnxZk4WunDFwNCO04ZaXBvr1Q/0zhvj0Ok7C2kRZpNcC+tkvj
         t8D/6PJ40l3tg3ZUjAuZG7L7R14U1prN9HwbLM/YXsVBoo527WMIfhGfpn/eGRnkgv
         9Pt+4QaXdv/6Q==
Received: by mail-lf1-f42.google.com with SMTP id g8so25375904lfv.12
        for <linux-raid@vger.kernel.org>; Mon, 12 Apr 2021 22:59:08 -0700 (PDT)
X-Gm-Message-State: AOAM531Bxb6sH9NfBtcer/RnZSldy0A0lUfgOsqaSouYxtufRh6nbmq0
        xeCoTz/FatUfKC7DDP/n/5I+57ne/vqCkZnLGd0=
X-Google-Smtp-Source: ABdhPJzUQSFJ+ijDDhWuqdfeiIo/4mEODpaKXl5sMXTEOslcMZI5cOPjH+wPQqE+wf0QjEne/3lQv04yZI+F/aPZDH0=
X-Received: by 2002:ac2:504f:: with SMTP id a15mr4320145lfm.176.1618293546811;
 Mon, 12 Apr 2021 22:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210413040829.GA26897@oracle.com>
In-Reply-To: <20210413040829.GA26897@oracle.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 12 Apr 2021 22:58:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6suq1y1+3F6Xy4T+Oj-jz_OiiWb4=tdfnABpWktFLyJQ@mail.gmail.com>
Message-ID: <CAPhsuW6suq1y1+3F6Xy4T+Oj-jz_OiiWb4=tdfnABpWktFLyJQ@mail.gmail.com>
Subject: Re: [PATCH v2] md/bitmap: wait for external bitmap writes to complete
 during tear down
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Zhao Heming <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 12, 2021 at 9:08 PM Sudhakar Panneerselvam
<sudhakar.panneerselvam@oracle.com> wrote:
>
[...]

>
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> Reviewed-by: Zhao Heming <heming.zhao@suse.com>

Applied to md-next. Thanks!
Song

> ---
> v2:
> - Do the additional bitmap write wait only for external bitmaps.
>
> ---
>  drivers/md/md-bitmap.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 200c5d0f08bf..ea3130e11680 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1722,6 +1722,8 @@ void md_bitmap_flush(struct mddev *mddev)
>         md_bitmap_daemon_work(mddev);
>         bitmap->daemon_lastrun -= sleep;
>         md_bitmap_daemon_work(mddev);
> +       if (mddev->bitmap_info.external)
> +               md_super_wait(mddev);
>         md_bitmap_update_sb(bitmap);
>  }
>
> --
> 1.8.3.1
>
