Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A687BEE4996
	for <linux-raid@archiver.kernel.org>; Tue, 22 Aug 2023 10:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbjHVKFp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 06:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjHVKFp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 06:05:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC80CC1
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 03:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692698696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nhj91CECcIxnBdAViZ5aTSC/L/AeQfU+/IVAfuxs9/E=;
        b=NtCalsTRvWnhImkcBLFklAaBV1rSubawIvB4+neSjWgOwjmJrGlJsWWJ4viVVXADa0X4xy
        O0L+A/AxbxKln/gtVrOUZeaOU4CzkS9mpSpGkcUhVPqi2og8mSAh809KtMFE+MfEnwH8Z+
        NKD1B2aiESMqeJo1qX3Y1IoFquwmJJY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-xgtnQEJLPA-9qb0JIJpF1A-1; Tue, 22 Aug 2023 06:04:54 -0400
X-MC-Unique: xgtnQEJLPA-9qb0JIJpF1A-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-26d52dc97e3so3995057a91.2
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 03:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692698694; x=1693303494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nhj91CECcIxnBdAViZ5aTSC/L/AeQfU+/IVAfuxs9/E=;
        b=UXiXP4dlAmriv1xJ3o7UTVFayvtkf7ytvgZuMLSticJ7nxT27Rbc1225vztvYU+b2X
         QD/836VhAnF8LznZWwr+VBA1+0i4jA3FdjEgHT6HW9UsapuPByEJBQw7ZMfzk3tTyPuO
         NW4sOOYJvC93kbvwVGVAsr8kddlJvM5ZIROdRrS/lztWgT2GacAbinoJ68TsrS3p/EgD
         2GJlYokqMyf99KfevM9FFEpHVuypPfPNZeFmuHCydYkP9N57KSOiodMwPLp9+Fr0mMbL
         xMt33r7CUecd9NMNScYOB1VFRpcI3hRhbQVssNz1rRSTdi4myAN5HENzhwgT+japkwQn
         Na1Q==
X-Gm-Message-State: AOJu0YxO37VzMRyQl9P5wWvn1bJQji8yDtY5CBkS3lEsoRQzNHLc2Q6q
        OIAB8NnaIrzhroXmP/wE+NtY8aHLx5fHWK6YJVHzrVeugowETdw4N23wZfsBRj279AGq/GxyXmh
        EEKNkyXvuKzS+LDxZlP1ZDFmTzwxEV91dU/ZfuQ==
X-Received: by 2002:a17:90b:23c7:b0:26b:17ef:7365 with SMTP id md7-20020a17090b23c700b0026b17ef7365mr5178878pjb.48.1692698693948;
        Tue, 22 Aug 2023 03:04:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE26YlmJHhfUHjcy5IY/xEkYsiQelMxX0OM604G2+o0BGV4NyzNRdOvhHe0daPV5pBt8ZpWUWL7H4NQIZSw9E8=
X-Received: by 2002:a17:90b:23c7:b0:26b:17ef:7365 with SMTP id
 md7-20020a17090b23c700b0026b17ef7365mr5178866pjb.48.1692698693668; Tue, 22
 Aug 2023 03:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230820090949.2874537-1-yukuai1@huaweicloud.com> <20230820090949.2874537-3-yukuai1@huaweicloud.com>
In-Reply-To: <20230820090949.2874537-3-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 22 Aug 2023 18:04:43 +0800
Message-ID: <CALTww29sF3OMdPfcKWqBoNcbKJPKot22SnpsJ3Dr5fudGNcfDQ@mail.gmail.com>
Subject: Re: [PATCH -next v3 2/7] md: factor out a helper to choose sync
 action from md_check_recovery()
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
> There are no functional changes, on the one hand make the code cleaner,
> on the other hand prevent following checkpatch error in the next patch to
> delay choosing sync action to md_start_sync().
>
> ERROR: do not use assignment in if condition
> +       } else if ((spares =3D remove_and_add_spares(mddev, NULL))) {
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 70 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 45 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 90815be1e80f..0cb9fa703a0c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9246,6 +9246,50 @@ static int remove_and_add_spares(struct mddev *mdd=
ev,
>         return spares;
>  }
>
> +static bool md_choose_sync_action(struct mddev *mddev, int *spares)
> +{
> +       /* Check if reshape is in progress first. */
> +       if (mddev->reshape_position !=3D MaxSector) {
> +               if (mddev->pers->check_reshape =3D=3D NULL ||
> +                   mddev->pers->check_reshape(mddev) !=3D 0)
> +                       return false;
> +
> +               set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> +               clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> +               return true;
> +       }
> +
> +       /*
> +        * Remove any failed drives, then add spares if possible. Spares =
are
> +        * also removed and re-added, to allow the personality to fail th=
e
> +        * re-add.
> +        */
> +       *spares =3D remove_and_add_spares(mddev, NULL);
> +       if (*spares) {
> +               clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +               clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> +               clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> +
> +               /* Start new recovery. */
> +               set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> +               return true;
> +       }
> +
> +       /* Check if recovery is in progress. */
> +       if (mddev->recovery_cp < MaxSector) {
> +               set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +               clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> +               return true;
> +       }
> +
> +       /* Delay to choose resync/check/repair in md_do_sync(). */
> +       if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
> +               return true;
> +
> +       /* Nothing to be done */
> +       return false;
> +}
> +
>  static void md_start_sync(struct work_struct *ws)
>  {
>         struct mddev *mddev =3D container_of(ws, struct mddev, sync_work)=
;
> @@ -9427,32 +9471,8 @@ void md_check_recovery(struct mddev *mddev)
>                 if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recov=
ery) ||
>                     test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>                         goto not_running;
> -               /* no recovery is running.
> -                * remove any failed drives, then
> -                * add spares if possible.
> -                * Spares are also removed and re-added, to allow
> -                * the personality to fail the re-add.
> -                */
> -
> -               if (mddev->reshape_position !=3D MaxSector) {
> -                       if (mddev->pers->check_reshape =3D=3D NULL ||
> -                           mddev->pers->check_reshape(mddev) !=3D 0)
> -                               /* Cannot proceed */
> -                               goto not_running;
> -                       set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
> -                       clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> -               } else if ((spares =3D remove_and_add_spares(mddev, NULL)=
)) {
> -                       clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> -                       clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> -                       clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery=
);
> -                       set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> -               } else if (mddev->recovery_cp < MaxSector) {
> -                       set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> -                       clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> -               } else if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
> -                       /* nothing to be done ... */
> +               if (!md_choose_sync_action(mddev, &spares))
>                         goto not_running;
> -
>                 if (mddev->pers->sync_request) {
>                         if (spares) {
>                                 /* We are adding a device or devices to a=
n array
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

