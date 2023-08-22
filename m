Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE71EE4996
	for <linux-raid@archiver.kernel.org>; Tue, 22 Aug 2023 10:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbjHVKUT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 06:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbjHVKUS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 06:20:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0BC18B
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 03:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692699569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sBfhKxkrMmsGIzpY/0/vS1cgmtOXfCWjIYyuonQhTsA=;
        b=VVUBNjlVGz3yzHtZ5sswZ/vYCA++qAzjKHKBiU28BZpjwUeIp4+/cWFDXViuHGPR8IR2Dd
        vOMJlrR8H56qWuIs4VYGr0n2j0CBGj3F4TCm9Dibl+FtvRcENUEoY+qwavfM8bU8t0JVMs
        heUttD3sevbsCQkkh3zFTfB+5eSe030=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-jdIvL7Z_NyyV-Fji5WGx-Q-1; Tue, 22 Aug 2023 06:19:28 -0400
X-MC-Unique: jdIvL7Z_NyyV-Fji5WGx-Q-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-267f00f6876so4644655a91.3
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 03:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692699567; x=1693304367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sBfhKxkrMmsGIzpY/0/vS1cgmtOXfCWjIYyuonQhTsA=;
        b=N0PEDlpkZOvjfTpocdqSJTYhA7JNfnTfwJlXozVu5gynl21JQhBgDqUq9xYaODNPaM
         +vHVY6I6RZal4g+47RgBnEwl6hXdKYpkPekftyou9XwxLf+PEXin5YD1BnygPJRjX5Sv
         Zcuu6gqdD/bBYtdFe3pj9LNpmbWT/Flcc3Vo2u9uQcR7Q7/UntVxvxhdI3Yuwld6YjNU
         JR3T/UhICNOc5B89pfh3OEeEqn+NWotNHyyatnftjUyNxmwHMJ5EeBW6+rkrvxbbJKs4
         y2eDTGXaVG6S7U1QIOaW+Klca7K7b/0DHW7fWxJLgAkakQKvYp9CYZvvMMHZTDWLWa33
         Kchw==
X-Gm-Message-State: AOJu0YwFKCQvNevhFN5a0gYccTC/MI+mlVtciWe4bhvyAx0sd6n+Vv6Z
        oDoOvHIna0Xr2yrJkk2tfdOUST89V7+g2NmuCp5yFVZvfqDH5A1ub2Usgv1zan0QCdrDR8rC+GY
        5k0omlSXPepFas0MHsE078w8nDw7vYx1t3xEOGQ==
X-Received: by 2002:a17:90b:4b82:b0:269:2356:19fb with SMTP id lr2-20020a17090b4b8200b00269235619fbmr6028274pjb.15.1692699567348;
        Tue, 22 Aug 2023 03:19:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhrxNdfMXnk16axJ2zWyGj7XP3x5wGyIuVvaTa3xh1G5lcPseQp05Y7UWtFr1Un5KLIHBv8FbCEavHO6u+CnI=
X-Received: by 2002:a17:90b:4b82:b0:269:2356:19fb with SMTP id
 lr2-20020a17090b4b8200b00269235619fbmr6028263pjb.15.1692699567027; Tue, 22
 Aug 2023 03:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230820090949.2874537-1-yukuai1@huaweicloud.com> <20230820090949.2874537-5-yukuai1@huaweicloud.com>
In-Reply-To: <20230820090949.2874537-5-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 22 Aug 2023 18:19:16 +0800
Message-ID: <CALTww2-mH7SW3Dz0DOd+NyBpZAZzB8r50UCBOkMipNtV4VxWTw@mail.gmail.com>
Subject: Re: [PATCH -next v3 4/7] md: factor out a helper rdev_removeable()
 from remove_and_add_spares()
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
> There are no functional changes, just to make the code simpler and
> prepare to delay remove_and_add_spares() to md_start_sync().
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 561cac13ff96..ceace5ffadd6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9153,6 +9153,22 @@ void md_do_sync(struct md_thread *thread)
>  }
>  EXPORT_SYMBOL_GPL(md_do_sync);
>
> +static bool rdev_removeable(struct md_rdev *rdev)
> +{
> +       if (rdev->raid_disk < 0 || test_bit(Blocked, &rdev->flags) ||
> +           atomic_read(&rdev->nr_pending))
> +               return false;
> +
> +       if (test_bit(RemoveSynchronized, &rdev->flags))
> +               return true;
> +
> +       if (test_bit(In_sync, &rdev->flags) ||
> +           test_bit(Journal, &rdev->flags))
> +               return false;
> +
> +       return true;
> +}
> +
>  static int remove_and_add_spares(struct mddev *mddev,
>                                  struct md_rdev *this)
>  {
> @@ -9166,11 +9182,7 @@ static int remove_and_add_spares(struct mddev *mdd=
ev,
>                 return 0;
>
>         rdev_for_each(rdev, mddev) {
> -               if ((this =3D=3D NULL || rdev =3D=3D this) &&
> -                   rdev->raid_disk >=3D 0 &&
> -                   !test_bit(Blocked, &rdev->flags) &&
> -                   test_bit(Faulty, &rdev->flags) &&
> -                   atomic_read(&rdev->nr_pending)=3D=3D0) {
> +               if ((this =3D=3D NULL || rdev =3D=3D this) && rdev_remove=
able(rdev)) {

There is a small change with the original method. Before this patch,
it checks the Faulty flag when setting RemoveSynchronized and it
checks RemoveSynchronized and "!In_sync && !Journal". I'm not sure if
it's right or not.

>                         /* Faulty non-Blocked devices with nr_pending =3D=
=3D 0
>                          * never get nr_pending incremented,
>                          * never get Faulty cleared, and never get Blocke=
d set.
> @@ -9185,19 +9197,12 @@ static int remove_and_add_spares(struct mddev *md=
dev,
>                 synchronize_rcu();
>         rdev_for_each(rdev, mddev) {
>                 if ((this =3D=3D NULL || rdev =3D=3D this) &&
> -                   rdev->raid_disk >=3D 0 &&
> -                   !test_bit(Blocked, &rdev->flags) &&
> -                   ((test_bit(RemoveSynchronized, &rdev->flags) ||
> -                    (!test_bit(In_sync, &rdev->flags) &&
> -                     !test_bit(Journal, &rdev->flags))) &&
> -                   atomic_read(&rdev->nr_pending)=3D=3D0)) {
> -                       if (mddev->pers->hot_remove_disk(
> -                                   mddev, rdev) =3D=3D 0) {
> +                   rdev_removeable(rdev) &&
> +                   mddev->pers->hot_remove_disk(mddev, rdev) =3D=3D 0) {
>                                 sysfs_unlink_rdev(mddev, rdev);
>                                 rdev->saved_raid_disk =3D rdev->raid_disk=
;
>                                 rdev->raid_disk =3D -1;
>                                 removed++;
> -                       }
>                 }
>                 if (remove_some && test_bit(RemoveSynchronized, &rdev->fl=
ags))
>                         clear_bit(RemoveSynchronized, &rdev->flags);
> --
> 2.39.2
>

