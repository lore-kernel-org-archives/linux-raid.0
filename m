Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1049C04FF3
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 05:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FD361151
	for <linux-raid@archiver.kernel.org>; Mon, 24 May 2021 05:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhEXFvj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 May 2021 01:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229733AbhEXFvi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 May 2021 01:51:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F231F61151
        for <linux-raid@vger.kernel.org>; Mon, 24 May 2021 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621835411;
        bh=K0oejYvYe/GHeaQRDcxLuZhxbLHYMeA4P06WFhY3xHs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m8htabiHJFFwe9VglPNGM4CnO/sH7cD9mXaAVliCG3QVb7lKZ3o+YnwpNp94OwLMS
         fDA9IdqdqCmeWABhVwBVn1XPkvyTUi7YsclfVoLtXJw5JJwrgvbT5kz4YP+FjZh+97
         oxVGml/nBfd3FUw8bTldeJAgl9LWnN3JIQ/YFhlauzmdRYBEErvXYPIbBjby0iOkdr
         w6m8nB0OyGvabRVui6NafgyXyT625tul+tP4ustFwZ2eDJAlEx4WXHvFTEZ9Br5yWq
         Ydr7Hch4W/Z4YlHr9RvIx5hpOEFCgsQM6fPwjXT8a3IzFuonsBZn3QLRBZ//NmbeTf
         isZgg9XFQ6LyQ==
Received: by mail-lj1-f178.google.com with SMTP id a4so17181316ljd.5
        for <linux-raid@vger.kernel.org>; Sun, 23 May 2021 22:50:10 -0700 (PDT)
X-Gm-Message-State: AOAM533JndaYnrSiFm5t284pLmrRpcP+XmRzzfjrdZCuF4yoeCHthR17
        I0uwRJ6r/CMzAsdIcvN6vopnuPdscNcp6srGFGs=
X-Google-Smtp-Source: ABdhPJxsDfKqQNq5Ul0wAN9/WeN3oTZ0TiiFwVYSeHd1Y2qpLnyWroqr8cxKTyzgxKaWBTJEBT7QLCcK6kN9ia0YOuQ=
X-Received: by 2002:a2e:a365:: with SMTP id i5mr15931383ljn.344.1621835409283;
 Sun, 23 May 2021 22:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn> <20210521080036.723295-1-jiangguoqing@kylinos.cn>
In-Reply-To: <20210521080036.723295-1-jiangguoqing@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Sun, 23 May 2021 22:49:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7wpWR5cUspUjgLoC78AFd3X=-7BpUDQCeqZ3UZTNcj9Q@mail.gmail.com>
Message-ID: <CAPhsuW7wpWR5cUspUjgLoC78AFd3X=-7BpUDQCeqZ3UZTNcj9Q@mail.gmail.com>
Subject: Re: [UPDATE PATCH V2 3/7] md: the latest try for improve io stats accounting
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 21, 2021 at 1:01 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>
> From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>
> Use generic io accounting functions to manage io stats. There was an
> attempt to do this earlier in commit 18c0b223cf990172 ("md: use generic
> io stats accounting functions to simplify io stat accounting"), but it
> did not include a call to generic_end_io_acct() and caused issues with
> tracking in-flight IOs, so it was later removed in commit 74672d069b29
> ("md: fix md io stats accounting broken").
>
> This patch attempts to fix this by using both generic_start_io_acct()
> and generic_end_io_acct(). To make it possible, in md_make_request() a
> bio is cloned with additional data - struct md_io, which includes the io
> start_time. A new bioset is introduced for this purpose. We call
> generic_start_io_acct() and pass the clone instead of the original to
> md_handle_request(). When it completes, we call generic_end_io_acct()
> and complete the original bio.
>
> This adds correct statistics about in-flight IOs and IO processing time,
> interpreted e.g. in iostat as await, svctm, aqu-sz and %util.
>
> It also fixes a situation where too many IOs where reported if a bio was
> re-submitted to the mddev, because io accounting is now performed only
> on newly arriving bios.
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> [Guoqing: rebase and make generic accounting applies to personalities
>           which don't have clone infrastructure]
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> ---
> Delete not necessary bioset_exit in md_integrity_register, thanks for
> Artur's review.
>
>  drivers/md/md.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/md/md.h |  1 +
>  2 files changed, 55 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7ba00e4c862d..d8823db843db 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -441,6 +441,25 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>  }
>  EXPORT_SYMBOL(md_handle_request);
>
> +struct md_io {
> +       struct mddev *mddev;
> +       struct bio *orig_bio;
> +       unsigned long start_time;
> +       struct bio bio_clone;
> +};
> +
> +static void md_end_io(struct bio *bio)
> +{
> +       struct md_io *md_io = bio->bi_private;
> +       struct bio *orig_bio = md_io->orig_bio;
> +
> +       orig_bio->bi_status = bio->bi_status;
> +
> +       bio_end_io_acct(orig_bio, md_io->start_time);
> +       bio_put(bio);
> +       bio_endio(orig_bio);
> +}
> +
>  static blk_qc_t md_submit_bio(struct bio *bio)
>  {
>         const int rw = bio_data_dir(bio);
> @@ -465,6 +484,30 @@ static blk_qc_t md_submit_bio(struct bio *bio)
>                 return BLK_QC_T_NONE;
>         }
>
> +       /*
> +        * clone bio under conditions:
> +        * 1. QUEUE_FLAG_IO_STAT flag is set.
> +        * 2. bio just enters md and it is not split from personality.
> +        */

We had iostat on by default. So, let set QUEUE_FLAG_IO_STAT in
md_run().

Thanks,
Song
