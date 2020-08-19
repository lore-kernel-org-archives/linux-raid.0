Return-Path: <SRS0=jE/M=B5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E183EC433E1
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 18:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B903220658
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597862184;
	bh=lz0rEkjUYTP+hTzAq2da9Kb1Hje0UTS8AeqXSsEkRhU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Ay35xiVHa4bGvsc4DI00abI/z0BBkPm4YJjNu8FjoQf0AMSmsaTkzZ4UdYex/GYBq
	 V5Ft9c5LRYwX8z4pm3/uy0SlZBgVyALIGJZd1MP5QBrbR+tKLTqW9J0tw8pSpIkEJb
	 pZCfHpATDOdAm/YAv3DftjWkJ1pYQ0ZIsPrftrb4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHSSgY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSSgX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Aug 2020 14:36:23 -0400
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6B8F207FF
        for <linux-raid@vger.kernel.org>; Wed, 19 Aug 2020 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597862182;
        bh=lz0rEkjUYTP+hTzAq2da9Kb1Hje0UTS8AeqXSsEkRhU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=y45kXCrL6ZpnWSKQQqo/ti7zWj897PUHIlKkUGBrVf0kKwPCvFV12/2cVXAyDQ7Ka
         5fnBN8CEaq17GL3nvl4V1ofixDa6jgNr8spzGRlIRpos8rFonW3sRXPVET7MfWHz/b
         wl9Kt/PsSU0AftyPsDnTxV/YcfbFvwODMKQkQQbo=
Received: by mail-lj1-f177.google.com with SMTP id v12so26491359ljc.10
        for <linux-raid@vger.kernel.org>; Wed, 19 Aug 2020 11:36:21 -0700 (PDT)
X-Gm-Message-State: AOAM531tCvdooBzpbXz2dQM1sT9BalEuVBg8pA+Ie8lYV8J38AuQ0GCM
        uym1kpQOfAwkJmmA49fkjlq5OY0yPLWeuKlu+As=
X-Google-Smtp-Source: ABdhPJzuGWBdjuBXLaKEjsC0rsiqJ1c5x8DN+TA0OBA1CNl6VOEmp2mNsorIfroVP6luWlgIKRAYpbZZ/FgXjVYiIX4=
X-Received: by 2002:a2e:5748:: with SMTP id r8mr12856584ljd.27.1597862180110;
 Wed, 19 Aug 2020 11:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <1597306476-8396-1-git-send-email-xni@redhat.com> <1597306476-8396-4-git-send-email-xni@redhat.com>
In-Reply-To: <1597306476-8396-4-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 19 Aug 2020 11:36:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4sa8PBC8sn4u+9SBMEHkinoAr2jRss1bSsvV+WQ+yPuA@mail.gmail.com>
Message-ID: <CAPhsuW4sa8PBC8sn4u+9SBMEHkinoAr2jRss1bSsvV+WQ+yPuA@mail.gmail.com>
Subject: Re: [PATCH V3 3/4] md/raid10: improve raid10 discard request
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 13, 2020 at 1:15 AM Xiao Ni <xni@redhat.com> wrote:
>
[...]
> Reviewed-by: Coly Li <colyli@suse.de>
> Reviewed-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
>

Please add "---" before "v1:..." so that this part is ignored during git am.

> v1:
> Coly helps to review these patches and give some suggestions:
> One bug is found. If discard bio is across one stripe but bio size is bigger
> than one stripe size. After spliting, the bio will be NULL. In this version,
> it checks whether discard bio size is bigger than 2*stripe_size.
> In raid10_end_discard_request, it's better to check R10BIO_Uptodate is set
> or not. It can avoid write memory to improve performance.
> Add more comments for calculating addresses.
>
> v2:
> Fix error by checkpatch.pl
> Fix one bug for offset layout. v1 calculates wrongly split size
> Add more comments to explain how the discard range of each component disk
> is decided.
> ---
>  drivers/md/raid10.c | 287 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 286 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index cef3cb8..5431e1b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1526,6 +1526,287 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>                 raid10_write_request(mddev, bio, r10_bio);
>  }
>
> +static void wait_blocked_dev(struct mddev *mddev, int cnt)
> +{
> +       int i;
> +       struct r10conf *conf = mddev->private;
> +       struct md_rdev *blocked_rdev = NULL;
> +
> +retry_wait:
> +       rcu_read_lock();
> +       for (i = 0; i < cnt; i++) {
> +               struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
> +               struct md_rdev *rrdev = rcu_dereference(
> +                       conf->mirrors[i].replacement);
> +               if (rdev == rrdev)
> +                       rrdev = NULL;
> +               if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
> +                       atomic_inc(&rdev->nr_pending);
> +                       blocked_rdev = rdev;
> +                       break;
> +               }
> +               if (rrdev && unlikely(test_bit(Blocked, &rrdev->flags))) {
> +                       atomic_inc(&rrdev->nr_pending);
> +                       blocked_rdev = rrdev;
> +                       break;
> +               }
> +       }
> +       rcu_read_unlock();
> +
> +       if (unlikely(blocked_rdev)) {
> +               /* Have to wait for this device to get unblocked, then retry */
> +               allow_barrier(conf);
> +               raid10_log(conf->mddev, "%s wait rdev %d blocked",
> +                               __func__, blocked_rdev->raid_disk);
> +               md_wait_for_blocked_rdev(blocked_rdev, mddev);
> +               wait_barrier(conf);
> +               goto retry_wait;

We need to clear blocked_rdev before this goto, or put retry_wait label
before "blocked_rdev = NULL;". I guess this path is not tested...

We are duplicating a lot of logic from raid10_write_request() here. Can we
try to pull the common logic into a helper function?

[...]

> +static void raid10_end_discard_request(struct bio *bio)
> +{
> +       struct r10bio *r10_bio = bio->bi_private;
> +       struct r10conf *conf = r10_bio->mddev->private;
> +       struct md_rdev *rdev = NULL;
> +       int dev;
> +       int slot, repl;
> +
> +       /*
> +        * We don't care the return value of discard bio
> +        */
> +       if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
> +               set_bit(R10BIO_Uptodate, &r10_bio->state);
> +
> +       dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
> +       if (repl)
> +               rdev = conf->mirrors[dev].replacement;
> +       if (!rdev) {
> +               smp_rmb();
> +               repl = 0;
> +               rdev = conf->mirrors[dev].rdev;
> +       }
> +
> +       if (atomic_dec_and_test(&r10_bio->remaining)) {
> +               md_write_end(r10_bio->mddev);
> +               raid_end_bio_io(r10_bio);
> +       }
> +
> +       rdev_dec_pending(rdev, conf->mddev);
> +}
> +
> +/* There are some limitations to handle discard bio
> + * 1st, the discard size is bigger than stripe_size*2.
> + * 2st, if the discard bio spans reshape progress, we use the old way to
> + * handle discard bio
> + */
> +static bool raid10_handle_discard(struct mddev *mddev, struct bio *bio)
> +{
> +       struct r10conf *conf = mddev->private;
> +       struct geom geo = conf->geo;

Do we really need a full copy of conf->geo?

> +       struct r10bio *r10_bio;
> +
> +       int disk;
> +       sector_t chunk;
> +       int stripe_size, stripe_mask;
> +
> +       sector_t bio_start, bio_end;
> +       sector_t first_stripe_index, last_stripe_index;
> +       sector_t start_disk_offset;
> +       unsigned int start_disk_index;
> +       sector_t end_disk_offset;
> +       unsigned int end_disk_index;
> +
> +       wait_barrier(conf);
> +
> +       if (conf->reshape_progress != MaxSector &&
> +           ((bio->bi_iter.bi_sector >= conf->reshape_progress) !=
> +            conf->mddev->reshape_backwards))
> +               geo = conf->prev;
> +
> +       stripe_size = (1<<geo.chunk_shift) * geo.raid_disks;

This could be raid_disks << chunk_shift

> +       stripe_mask = stripe_size - 1;

Does this work when raid_disks is not power of 2?

> +
> +       bio_start = bio->bi_iter.bi_sector;
> +       bio_end = bio_end_sector(bio);
> +
> +       /* Maybe one discard bio is smaller than strip size or across one stripe
> +        * and discard region is larger than one stripe size. For far offset layout,
> +        * if the discard region is not aligned with stripe size, there is hole
> +        * when we submit discard bio to member disk. For simplicity, we only
> +        * handle discard bio which discard region is bigger than stripe_size*2
> +        */
> +       if (bio_sectors(bio) < stripe_size*2)
> +               goto out;
> +
> +       if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +               bio_start < conf->reshape_progress &&
> +               bio_end > conf->reshape_progress)
> +               goto out;
> +

[...]
