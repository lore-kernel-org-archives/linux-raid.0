Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C635EE49A0
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 03:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjHWDZN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 23:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjHWDZM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 23:25:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A17CD6
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 20:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692761063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SnQ+N+1/jGHTpLOSLvg0zVfzIC9bNsC+FTYOKHkdiUg=;
        b=WO04iP5oDpB211qI5grgxJ8MwkFL7JSxlSqrI6rhT6d9FqzTWTymgGl59F5eFFg6bFx1Tm
        Cs9+lq57bJ4rJUOZpDVWbHPbiPPnoIS6aF/KswL/wrAQKRdtisiKqjCY6MzvYB+8XdVdUE
        I4JxyZ1fPqOdqwINdWgSOybJLFVxHvI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-PqSjOuxvPoy1BSk49luMwQ-1; Tue, 22 Aug 2023 23:24:22 -0400
X-MC-Unique: PqSjOuxvPoy1BSk49luMwQ-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a850ee02c8so3817580b6e.2
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 20:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692761062; x=1693365862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SnQ+N+1/jGHTpLOSLvg0zVfzIC9bNsC+FTYOKHkdiUg=;
        b=glx76jjkiyT3VNKk+D4H45q0Rjdc5Wt0EiyeMfpTl940vCQQSKA31F7pv2T9R83H8W
         gYprkskfBdfY+JBW4PRS8thflFsvYDMf8Kh45ue76LdW3hRHrCWWiVpa9TQJY2X3kBEP
         +bZcCmEwwFZzFc+xfUHPXHR9A2Ow+L0BdLnHDZ1oC34aDfY0RsIyIHWikys4HAQp5As8
         Tq2mvq7oJoe8Y+RHXIrI8t5cqMZuvM5q9EzKSywL9g/pu7sZVSus8j4ZCTaOFX/wUJWq
         FEAB16diaexV53wfvJucpwcf7mEUJvbBFb7vYnD4apqUf/+J9nG+Bym8teyml/qCoi3l
         5XjQ==
X-Gm-Message-State: AOJu0Yw1VeWGQGOc8OvasIr7hTAjzTpMsDJ+DTzEWzl5plALIPkUDlHJ
        JwJpHKEoPhikAY3+6N4A5cgBNjXs8N1INb0OxlNzLi5xn+yUjOs+WL53B/XaG5NBn64fjJtGsKX
        UKTL00VXT1eXAgTp/lXj1QTLOtSs+1+ZSJXF8Qg==
X-Received: by 2002:a05:6808:4097:b0:3a7:3ce0:1ad7 with SMTP id db23-20020a056808409700b003a73ce01ad7mr11785870oib.20.1692761061987;
        Tue, 22 Aug 2023 20:24:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3BvmEA+Fq04AGrvCF1QWh/VASudRFeyrJzHuSDWKoUq7hCy4S3UK5FrAyIIwcu5F9t+fu87Z79/a6R7XW0t4=
X-Received: by 2002:a05:6808:4097:b0:3a7:3ce0:1ad7 with SMTP id
 db23-20020a056808409700b003a73ce01ad7mr11785854oib.20.1692761061761; Tue, 22
 Aug 2023 20:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230820090949.2874537-1-yukuai1@huaweicloud.com> <20230820090949.2874537-8-yukuai1@huaweicloud.com>
In-Reply-To: <20230820090949.2874537-8-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 23 Aug 2023 11:24:10 +0800
Message-ID: <CALTww2_=-q5r0+XsDiHBHFMovD0002dYoa3gL2w3DPbruJpEOQ@mail.gmail.com>
Subject: Re: [PATCH -next v3 7/7] md: delay remove_and_add_spares() for read
 only array to md_start_sync()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, mariusz.tkaczyk@linux.intel.com,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Aug 20, 2023 at 5:13=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
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
>
> This change make sure that array reconfiguration is independent from
> daemon, and it'll be much easier to synchronize it with io, consier
> that io may rely on daemon thread to be done.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 43 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 33 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index cdc361c521d4..f08b683f724f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4866,6 +4866,7 @@ action_store(struct mddev *mddev, const char *page,=
 size_t len)
>                 /* A write to sync_action is enough to justify
>                  * canceling read-auto mode
>                  */
> +               flush_work(&mddev->sync_work);
>                 mddev->ro =3D MD_RDWR;
>                 md_wakeup_thread(mddev->sync_thread);
>         }
> @@ -7638,6 +7639,10 @@ static int md_ioctl(struct block_device *bdev, blk=
_mode_t mode,
>                 mutex_unlock(&mddev->open_mutex);
>                 sync_blockdev(bdev);
>         }
> +
> +       if (!md_is_rdwr(mddev))
> +               flush_work(&mddev->sync_work);
> +
>         err =3D mddev_lock(mddev);
>         if (err) {
>                 pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n=
",
> @@ -8562,6 +8567,7 @@ bool md_write_start(struct mddev *mddev, struct bio=
 *bi)
>         BUG_ON(mddev->ro =3D=3D MD_RDONLY);
>         if (mddev->ro =3D=3D MD_AUTO_READ) {
>                 /* need to switch to read/write */
> +               flush_work(&mddev->sync_work);
>                 mddev->ro =3D MD_RDWR;
>                 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>                 md_wakeup_thread(mddev->thread);
> @@ -9191,6 +9197,16 @@ static bool rdev_addable(struct md_rdev *rdev)
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
> @@ -9311,6 +9327,12 @@ static void md_start_sync(struct work_struct *ws)
>
>         mddev_lock_nointr(mddev);
>
> +       if (!md_is_rdwr(mddev)) {
> +               remove_and_add_spares(mddev, NULL);
> +               mddev_unlock(mddev);
> +               return;
> +       }
> +
>         if (!md_choose_sync_action(mddev, &spares))
>                 goto not_running;
>
> @@ -9405,7 +9427,8 @@ void md_check_recovery(struct mddev *mddev)
>         }
>
>         if (!md_is_rdwr(mddev) &&
> -           !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
> +           (!test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +            work_pending(&mddev->sync_work)))
>                 return;
>         if ( ! (
>                 (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> @@ -9433,15 +9456,8 @@ void md_check_recovery(struct mddev *mddev)
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

Can we keep those comments?

> -                       remove_and_add_spares(mddev, NULL);
> -                       /* There is no thread, but we need to call
> +                       /*
> +                        * There is no thread, but we need to call
>                          * ->spare_active and clear saved_raid_disk
>                          */
>                         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> @@ -9449,6 +9465,13 @@ void md_check_recovery(struct mddev *mddev)
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

Reviewed-by: Xiao Ni <xni@redhat.com>

