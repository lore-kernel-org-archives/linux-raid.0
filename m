Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB3DC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 03:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70D9160FD9
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 03:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhKBDoD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Nov 2021 23:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhKBDoD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Nov 2021 23:44:03 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB99C061714
        for <linux-raid@vger.kernel.org>; Mon,  1 Nov 2021 20:41:28 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id n201so8949790vkn.12
        for <linux-raid@vger.kernel.org>; Mon, 01 Nov 2021 20:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aNfDlmcCvZAu6RZheE0Gs/en1Sxc8Nn+8RdvpkG7Vs4=;
        b=efzNJ3pqXF+REEHyAzk+/j5Veta6Fl0UfLt1dm81GkJWtUeentW+Hhs/cgkcrvFpYF
         xozq2v8JqOISB22Yrl/z/n8aB3jg1X3/1hudhZj4UWAXa5RAhT1QWlMBLco9xSKyWtdb
         b0wdmo5sL+K4fS/DoOpwtYZfBZxChZQnZSbELgKLgwQbb+soPMWbqb57pPzN0i+4L4nz
         7fg8OpXd7haGMIyEqQYmxnA35TPFswqYsvltqmQaLc4X2dYyKY04n7giYEOMYEgk75qK
         tCW8/P8FLV70/Eq8sn/aRelo+R+vynDZ3lc/x9QZrTkyDJM6jgktRIsp5IFp2SBj5qgY
         oTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aNfDlmcCvZAu6RZheE0Gs/en1Sxc8Nn+8RdvpkG7Vs4=;
        b=HXVVJqSjQorBOmbwaFrzeWkR7HSx5hiyNJbWt5WFSVVfC3udg8NAjCn96wir7Tt0MF
         H9w3Z58MJ6Hc4/CapeXFqd91QqSDmiXn/afrSEQc8XzQdmju5DE3bB+a6KLBK67HrgHF
         FZl3Z4A2a7odsdZN/cigYEukbylmtxeHdlShzOBcEj/nCb6qYMPAOOowDXLuTpqKcxk1
         iLVtHdNVom/6T+NvBw9Y/SQmb6xrbfs7QVNEkFOfFunjjSM2WYBSTFnxDfSg0XCca722
         74w1Ekr26ZpfNqMeuW1BuOY3fwm3idReCm4CDP7Z3fsTRy+NOqqtHKMNGO1Z5bKJ51UB
         KpRQ==
X-Gm-Message-State: AOAM531TCtyPYx37nDAwT4r2L4aQ2t+QDwGra3TSnkH3mchCbWuG/62J
        NjBbxsXGh+FfEJo7Fl5qBPMoTv8gAvu8DY+AO+VdxA==
X-Google-Smtp-Source: ABdhPJzlM+quNvYBxc2Qj1BVP80yeqwQpoHIi9HJyUDF/dLTgHQullxzmyc6B8fAY79+N8E3A7TLb1/osWCIUH8xsYg=
X-Received: by 2002:a05:6122:2201:: with SMTP id bb1mr34428074vkb.19.1635824487972;
 Mon, 01 Nov 2021 20:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211101215143.1580-1-vverma@digitalocean.com>
In-Reply-To: <20211101215143.1580-1-vverma@digitalocean.com>
From:   Li Feng <fengli@smartx.com>
Date:   Tue, 2 Nov 2021 11:41:17 +0800
Message-ID: <CAHckoCzJDHQ_4EsBWuuZE3Rk3t00Sdu6NLDKr=0_aRK8P+CmUw@mail.gmail.com>
Subject: Re: [PATCH] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 2, 2021 at 5:52 AM Vishal Verma <vverma@digitalocean.com> wrote:
>
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
> it for linear target") added support for REQ_NOWAIT for dm. This uses
> a similar approach to incorporate REQ_NOWAIT for md based bios.
>
> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> ---
>  drivers/md/md.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5111ed966947..51b2df32aed5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -419,6 +419,12 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>         if (is_suspended(mddev, bio)) {
>                 DEFINE_WAIT(__wait);
>                 for (;;) {
> +                       /* Bail out if REQ_NOWAIT is set for the bio */
> +                       if (bio->bi_opf & REQ_NOWAIT) {
> +                               bio_wouldblock_error(bio);
> +                               break;
> +                       }
> +
>                         prepare_to_wait(&mddev->sb_wait, &__wait,
>                                         TASK_UNINTERRUPTIBLE);
>                         if (!is_suspended(mddev, bio))
> @@ -5792,6 +5798,7 @@ int md_run(struct mddev *mddev)
>         int err;
>         struct md_rdev *rdev;
>         struct md_personality *pers;
> +       bool nowait = true;
>
>         if (list_empty(&mddev->disks))
>                 /* cannot run an array with no devices.. */
> @@ -5862,8 +5869,14 @@ int md_run(struct mddev *mddev)
>                         }
>                 }
>                 sysfs_notify_dirent_safe(rdev->sysfs_state);
> +               if (!blk_queue_nowait(bdev_get_queue(rdev->bdev)))
> +                       nowait = false;
I think this is more clear:
nowait = blk_queue_nowait(bdev_get_queue(rdev->bdev));

>         }
>
> +       /* Set the NOWAIT flags if all underlying devices support it */
> +       if (nowait)
> +               blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
> +
>         if (!bioset_initialized(&mddev->bio_set)) {
>                 err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>                 if (err)
> @@ -7007,6 +7020,14 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>         if (!mddev->thread)
>                 md_update_sb(mddev, 1);
> +       /* If the new disk does not support REQ_NOWAIT,
> +        * disable on the whole MD.
> +        */
> +       if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
> +               pr_info("%s: Disabling nowait because %s does not support nowait\n",
> +                       mdname(mddev), bdevname(rdev->bdev, b));
> +               blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
> +       }
>         /*
>          * Kick recovery, maybe this spare has to be added to the
>          * array immediately.
> --
> 2.17.1
>
