Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A3BC04A94
	for <linux-raid@archiver.kernel.org>; Wed, 16 Aug 2023 07:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbjHPHUA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Aug 2023 03:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242348AbjHPHTk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Aug 2023 03:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C392117
        for <linux-raid@vger.kernel.org>; Wed, 16 Aug 2023 00:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692170335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y9YpilQCL3ynVImiYsoeiobJXH6We3bG9cGLYb4gSg0=;
        b=DFlVB9V7/Gw77zq9wHKFn8WqnU7Wk1Wdv3MZn/mU1gKOgXC+Lc2qI6IR3d5CjZ5nHCgrx5
        KJfokQv8OVhhg20CPZ8+t+weVt3N9RZ0dwU6eiGeII20vMUXJ6Fx5WFiZFzNAhpXI6CchC
        vyYw4YanmGoi3e6zNxU7zZ8bC8EeClk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-GMgsN7v1MH6a_9-SoFtN7A-1; Wed, 16 Aug 2023 03:18:53 -0400
X-MC-Unique: GMgsN7v1MH6a_9-SoFtN7A-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-68877684da1so1222176b3a.1
        for <linux-raid@vger.kernel.org>; Wed, 16 Aug 2023 00:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692170332; x=1692775132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9YpilQCL3ynVImiYsoeiobJXH6We3bG9cGLYb4gSg0=;
        b=PEwzYHJwgXkA2lItZ9TyiLWsfrbc+b0ob8yfwGrbNgGxSg6nBzyd9S9aKRjD78UHSM
         JpPtZd+zXMjhuaKFK8HzhyuBruvx37tU0JJa/3GS5/aU07QIxQ03Djt7iQV2kN0OZhjN
         q27JaHJeyPjWsweKlUpPp58UC3/tnhbn8dJgF4rP4qJeC65LAuhrG0X2YGNAqxiI+X4H
         7eo87TlD7yrQJ3g2Tt9AhJU73zjBg2xw+Xp3LaTIzXjhI4VKfdBlXjxTjP+9UBmhFhV5
         OU946Pn818oLLXZxnA5cSyjl92JukRS4mnwJwdotVbT9ihiMzu4G8LdgZ/BIIO5cRCgD
         kTpw==
X-Gm-Message-State: AOJu0YzyfMqSpfW/YFdUrljkiJm/3/wnZezJxrdGvw8bfJEV9j0IpXH3
        ZUqLM2CgIy0woZxfEmhATuY8e/BPPmjUIozKsvev5mIWnisn1gh4Fw/m4kcEdl0i0VKSa3jkIFk
        o/6tk+WJkJs8XrCJ1hFHrBwsNKLJGWrUvjx08gf2lEZzF83I45PI=
X-Received: by 2002:a05:6a20:914d:b0:132:79da:385a with SMTP id x13-20020a056a20914d00b0013279da385amr1199085pzc.23.1692170332422;
        Wed, 16 Aug 2023 00:18:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKG3xiXPLtvSBOy7UTZ4AJ+JKycafKj/HYMUsWrsaKDAi3ZvRcMzimuYXdqRkXCl1oe3Fr7TH132EJgtc4jh4=
X-Received: by 2002:a05:6a20:914d:b0:132:79da:385a with SMTP id
 x13-20020a056a20914d00b0013279da385amr1199071pzc.23.1692170332143; Wed, 16
 Aug 2023 00:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230815030957.509535-1-yukuai1@huaweicloud.com> <20230815030957.509535-8-yukuai1@huaweicloud.com>
In-Reply-To: <20230815030957.509535-8-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 16 Aug 2023 15:18:40 +0800
Message-ID: <CALTww28yBsGucpaPO9BiQO-gU3+F25MaNVgGhnOA3Mi+9enFjQ@mail.gmail.com>
Subject: Re: [PATCH -next v2 7/7] md: delay remove_and_add_spares() for read
 only array to md_start_sync()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 15, 2023 at 11:13=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Before this patch, for read-only array:
>
> md_check_recovery() check that 'MD_RECOVERY_NEEDED' is set, then it will
> call remove_and_add_spares() directly to try to remove and add rdevs
> from array.
>
> After this patch:
>
> 1) md_check_recovery() check that 'MD_RECOVERY_NEEDED' is set, and the
>    worker 'sync_work' is not pending, and there are rdevs can be added
>    or removed, then it will queue new work md_start_sync();
> 2) md_start_sync() will call remove_and_add_spares() and exist;

Hi Kuai

If md_check_recovery returns and md_starts_sync doesn't start, during
the window the raid changes to read-write, the sync thread can be run
but MD_RECOVERY_RUNNING isn't set. Is there such a problem?

Regards
Xiao

>
> This change make sure that array reconfiguration is independent from
> daemon, and it'll be much easier to synchronize it with io, consier
> that io may rely on daemon thread to be done.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 37 +++++++++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d26d2c35f9af..74d529479fcf 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9191,6 +9191,16 @@ static bool rdev_addable(struct md_rdev *rdev)
>         return true;
>  }
>
> +static bool md_spares_need_change(struct mddev *mddev)
> +{
> +       struct md_rdev *rdev;
> +
> +       rdev_for_each(rdev, mddev)
> +               if (rdev_removeable(rdev) || rdev_addable(rdev))
> +                       return true;
> +       return false;
> +}
> +
>  static int remove_and_add_spares(struct mddev *mddev,
>                                  struct md_rdev *this)
>  {
> @@ -9309,6 +9319,12 @@ static void md_start_sync(struct work_struct *ws)
>
>         mddev_lock_nointr(mddev);
>
> +       if (!md_is_rdwr(mddev)) {
> +               remove_and_add_spares(mddev, NULL);
> +               mddev_unlock(mddev);
> +               return;
> +       }
> +
>         if (!md_choose_sync_direction(mddev, &spares))
>                 goto not_running;
>
> @@ -9403,7 +9419,8 @@ void md_check_recovery(struct mddev *mddev)
>         }
>
>         if (!md_is_rdwr(mddev) &&
> -           !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
> +           (!test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +            work_pending(&mddev->sync_work)))
>                 return;
>         if ( ! (
>                 (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> @@ -9431,15 +9448,8 @@ void md_check_recovery(struct mddev *mddev)
>                                  */
>                                 rdev_for_each(rdev, mddev)
>                                         clear_bit(Blocked, &rdev->flags);
> -                       /* On a read-only array we can:
> -                        * - remove failed devices
> -                        * - add already-in_sync devices if the array its=
elf
> -                        *   is in-sync.
> -                        * As we only add devices that are already in-syn=
c,
> -                        * we can activate the spares immediately.
> -                        */
> -                       remove_and_add_spares(mddev, NULL);
> -                       /* There is no thread, but we need to call
> +                       /*
> +                        * There is no thread, but we need to call
>                          * ->spare_active and clear saved_raid_disk
>                          */
>                         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> @@ -9447,6 +9457,13 @@ void md_check_recovery(struct mddev *mddev)
>                         clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>                         clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>                         clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)=
;
> +
> +                       /*
> +                        * Let md_start_sync() to remove and add rdevs to=
 the
> +                        * array.
> +                        */
> +                       if (md_spares_need_change(mddev))
> +                               queue_work(md_misc_wq, &mddev->sync_work)=
;
>                         goto unlock;
>                 }
>
> --
> 2.39.2
>

