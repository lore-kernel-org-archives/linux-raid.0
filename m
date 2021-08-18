Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BCAC432BE
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 05:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3478661038
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 05:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhHRFhZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Aug 2021 01:37:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237618AbhHRFhR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 18 Aug 2021 01:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629265002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=thXJHRl8iaosCj0fzpTTuRGeoi44YH2eXbma5dF/0Ko=;
        b=FQHwzbL+h1L2GaCeUx6ifHeId7LeKENQx1Wbx4XwLGUSse+NkrtGXYheOp12a2fWr6Pa4J
        OqSBR0jz5PhNDu0DQuj1wLC1/IHgbVCtSoiDZJHRmLFXXwU2E57JCAq0KPZTHmMUPbSi/T
        p6wLX9itYDLOLYXJY9vslCgXhYOrglM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-6S87u2VhMt-81qTsreW7vw-1; Wed, 18 Aug 2021 01:36:40 -0400
X-MC-Unique: 6S87u2VhMt-81qTsreW7vw-1
Received: by mail-ed1-f71.google.com with SMTP id v20-20020aa7d9d40000b02903be68450bf3so433895eds.23
        for <linux-raid@vger.kernel.org>; Tue, 17 Aug 2021 22:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=thXJHRl8iaosCj0fzpTTuRGeoi44YH2eXbma5dF/0Ko=;
        b=tw2V2TAkCAetta7OZKeVVvWh5tE9LkMPGzOJNktwGhTRC6vsU5zTr45snOQfbub3um
         9Opb4mvneqapHgWmlFhbDkvvH3v0y9qa5EcIhTWtM/wHv2V8uVAinjoHhxYqd0xXAwxs
         BkIspemhe7qrQusAzGyOQ5k3EodUdwDhZtdgDBn+329ztfriB2eWIUUmIJUP0bykvYQf
         UjduGB7NXXDZkjoUnxuUgtXK/WdFHPQMdKguWoKsIBojFTPkLdg0mJGdGRmIOHis1M0R
         ktHqDETiaTkaqyQUXiJGNjZGgkNyBHNP8Vkihm7iONtHpCS/RKWkuIehiTjqmmGARra0
         gRrw==
X-Gm-Message-State: AOAM531wr4K6C0ycK8pFm/ujlUneBxHRg4RONqAZ40OGcQ+ADFEZC6AX
        Of5zZYjsyExfwMp9R91icR9Sp8L3rNX6Ef2H7Vlf0fAfzcEz5BBEfh3WAkc/ZsXGONwkoBJpR/a
        Uvn4Ek8DISLMLXEq4jO96XB1oOTjjWD0K0v2kww==
X-Received: by 2002:a17:906:f11:: with SMTP id z17mr8168069eji.385.1629264999679;
        Tue, 17 Aug 2021 22:36:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz+U0y4EakDxNCOhFAJsvmxK9pGhhFGUiYDIaNP6HEdEoLS3fVxPA7RTngl7yaORCDaUh24e93tLM/oGAbbYs=
X-Received: by 2002:a17:906:f11:: with SMTP id z17mr8168057eji.385.1629264999524;
 Tue, 17 Aug 2021 22:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <1629253137-5571-1-git-send-email-xni@redhat.com>
In-Reply-To: <1629253137-5571-1-git-send-email-xni@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 18 Aug 2021 13:36:28 +0800
Message-ID: <CALTww291b+-sbhs8eapZLkAQnZRQR4vNGegO5gtL1bDDUyt0fA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] md/raid10: Remove rcu_dereference when it doesn't
 need rcu lock to protect
To:     Song Liu <song@kernel.org>
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

Sorry, please ignore this patch. The v2 is not in the right place in
the comment. I'll send a new one.

Regards
Xiao

On Wed, Aug 18, 2021 at 10:19 AM Xiao Ni <xni@redhat.com> wrote:
>
> One warning message is triggered like this:
> [  695.110751] =============================
> [  695.131439] WARNING: suspicious RCU usage
> [  695.151389] 4.18.0-319.el8.x86_64+debug #1 Not tainted
> [  695.174413] -----------------------------
> [  695.192603] drivers/md/raid10.c:1776 suspicious
> rcu_dereference_check() usage!
> [  695.225107] other info that might help us debug this:
> [  695.260940] rcu_scheduler_active = 2, debug_locks = 1
> [  695.290157] no locks held by mkfs.xfs/10186.
>
> In the first loop of function raid10_handle_discard. It already
> determines which disk need to handle discard request and add the
> rdev reference count rdev->nr_pending. So the conf->mirrors will
> not change until all bios come back from underlayer disks. It
> doesn't need to use rcu_dereference to get rdev.
>
> V2: Fix comment style problem
>
> Fixes: d30588b2731f ('md/raid10: improve raid10 discard request')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/raid10.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 16977e8..d5d9233 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1712,6 +1712,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>         } else
>                 r10_bio->master_bio = (struct bio *)first_r10bio;
>
> +       /*
> +        * first select target devices under rcu_lock and
> +        * inc refcount on their rdev.  Record them by setting
> +        * bios[x] to bio
> +        */
>         rcu_read_lock();
>         for (disk = 0; disk < geo->raid_disks; disk++) {
>                 struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
> @@ -1743,9 +1748,6 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>         for (disk = 0; disk < geo->raid_disks; disk++) {
>                 sector_t dev_start, dev_end;
>                 struct bio *mbio, *rbio = NULL;
> -               struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
> -               struct md_rdev *rrdev = rcu_dereference(
> -                       conf->mirrors[disk].replacement);
>
>                 /*
>                  * Now start to calculate the start and end address for each disk.
> @@ -1775,9 +1777,12 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>
>                 /*
>                  * It only handles discard bio which size is >= stripe size, so
> -                * dev_end > dev_start all the time
> +                * dev_end > dev_start all the time.
> +                * It doesn't need to use rcu lock to get rdev here. We already
> +                * add rdev->nr_pending in the first loop.
>                  */
>                 if (r10_bio->devs[disk].bio) {
> +                       struct md_rdev *rdev = conf->mirrors[disk].rdev;
>                         mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
>                         mbio->bi_end_io = raid10_end_discard_request;
>                         mbio->bi_private = r10_bio;
> @@ -1790,6 +1795,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>                         bio_endio(mbio);
>                 }
>                 if (r10_bio->devs[disk].repl_bio) {
> +                       struct md_rdev *rrdev = conf->mirrors[disk].replacement;
>                         rbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
>                         rbio->bi_end_io = raid10_end_discard_request;
>                         rbio->bi_private = r10_bio;
> --
> 2.7.5
>

