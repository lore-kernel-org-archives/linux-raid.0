Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA90C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 23:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B20E613FA
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 23:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhDTXto (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Apr 2021 19:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234442AbhDTXtn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 20 Apr 2021 19:49:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CFDE61401
        for <linux-raid@vger.kernel.org>; Tue, 20 Apr 2021 23:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618962551;
        bh=/AhLnZkxvPSZneBs/4Qrr3nsF1qNH/BTA0L+75EaqHg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ErCXIMSK52HS8sJPH9TOvslbjRoMRiml/UGB7jR7zl3vb6ILd8fogBC6S9Dxjb7f4
         uqtF+p3R8AmkS6evzzMgUcqAVbrTK5T500+u8nM5b0BcyP54dRu+QKILu/TR0m6Csq
         zQW7Lmz8Buohk6AbusVVCzI1K63tUCDsQE1NjxIe8uZ1o9okjdmUgiNXWSMfGTg/TS
         U6PtqPyI9ppwlFCJ8yJzue/lBI9lPLG7ZajdtosXAsr2nE/x+7Lqe9NoTbUWD/Ao1t
         +cw33u4X9GUsUh+h4GZ7bqklGM2NAIGd6V5oZeYIghvEE6KHr5vTJmkKbaS7QbHJDL
         4JqmqxC1y3HWA==
Received: by mail-lj1-f180.google.com with SMTP id a25so32327981ljm.11
        for <linux-raid@vger.kernel.org>; Tue, 20 Apr 2021 16:49:11 -0700 (PDT)
X-Gm-Message-State: AOAM533v+MNHXcYxTePSeXQXqxqacQTEh76HQG76gzF5sUGefcBUmCmS
        Mxezt4ruwei4xwGtIJ0iBDdqvmjYTU6LWKVFBLQ=
X-Google-Smtp-Source: ABdhPJw/mwyJMd6e7iA5SfOtKx6OIbAs8zpaE37I0uT8yz0V7mnHkZMG3mXuReoT1/kbWzX9WCbDr5a3pU5h7rDtlh4=
X-Received: by 2002:a05:651c:1026:: with SMTP id w6mr6241390ljm.167.1618962549760;
 Tue, 20 Apr 2021 16:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <607f4fd0.1c69fb81.9f7e7.05ef@mx.google.com>
In-Reply-To: <607f4fd0.1c69fb81.9f7e7.05ef@mx.google.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 20 Apr 2021 16:48:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4qW_mMfQuf3efn18AAt4xHQz25+YKjuynwDzzDYLY=Pw@mail.gmail.com>
Message-ID: <CAPhsuW4qW_mMfQuf3efn18AAt4xHQz25+YKjuynwDzzDYLY=Pw@mail.gmail.com>
Subject: Re: [PATCH] md/raid1: properly indicate failure when ending a failed
 write request
To:     Paul Clements <paul.clements@us.sios.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Apr 20, 2021 at 3:05 PM Paul Clements <paul.clements@us.sios.com> wrote:
>
> This patch addresses a data corruption bug in raid1 arrays using bitmaps.
> Without this fix, the bitmap bits for the failed I/O end up being cleared.

I think this only happens when we re-add a faulty drive?

Thanks,
Song

>
> Since we are in the failure leg of raid1_end_write_request, the request
> either needs to be retried (R1BIO_WriteError) or failed (R1BIO_Degraded).
>
> Signed-off-by: Paul Clements <paul.clements@us.sios.com>
>
> ---
>  drivers/md/raid1.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d2378765dc15..ced076ba560e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -478,6 +478,8 @@ static void raid1_end_write_request(struct bio *bio)
>                 if (!test_bit(Faulty, &rdev->flags))
>                         set_bit(R1BIO_WriteError, &r1_bio->state);
>                 else {
> +                       /* Fail the request */
> +                       set_bit(R1BIO_Degraded, &r1_bio->state);
>                         /* Finished with this branch */
>                         r1_bio->bios[mirror] = NULL;
>                         to_put = bio;
> --
> 2.17.1
>
