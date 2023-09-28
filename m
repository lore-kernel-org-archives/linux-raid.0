Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F62E743C2
	for <linux-raid@archiver.kernel.org>; Thu, 28 Sep 2023 20:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjI1Uo1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Sep 2023 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Uo0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Sep 2023 16:44:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27C8180
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 13:44:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED4EC433C8
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 20:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695933864;
        bh=VvXsypq4T4cPTSQQmjyXy/ZDI+ijcZBXvHg4ZvDTPcU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JgPqmXvJEw0g+VPGBDfer4v0Ih4j03rs6qypxz/9Pz55uCjqYE08Cs/N/5qMZiYFU
         LpVQeJQV45sqLuIIEzGC/HZvb+bx8NKD7Few6sS/35fXrkrQFSZDkj4b58XPPcNfMy
         lIZEdLQin0H+CUzq4chb5/ofpIvBh+Ev0iovOrqagVJtAPhbBy+GwFQ74aufP4TKIO
         PuqbwGcr+u3g2K2OvkfVVkEmKYzqT1pQlRAzqFk8JD9XSbW1JDxNGvvMNuhT+Tdsbx
         1W8R90rX+om+zku/vTGcN1yCOhIKgKunisZqaixS6/lx9YBMmuMvZCxt2h3Y41i86i
         kIg7z41PFh81Q==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-503056c8195so21998765e87.1
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 13:44:24 -0700 (PDT)
X-Gm-Message-State: AOJu0YwbG5hKxvPZk5Bhsi/i2v1gC80AuB6HGfK/l5naBxdI5xsdi/lw
        e8uFmjDLtjrisYnQgjeid9gDphP/y/3o1aV2Ewg=
X-Google-Smtp-Source: AGHT+IGeOuOYZrILeKgLCDbDFR+OOh6ChkAT+RdUFtn6jclDCup8g9mPxSGDJMeOc72u6/LeDqEXfNcZjLEYq3iKR48=
X-Received: by 2002:a05:6512:68b:b0:504:369d:f11c with SMTP id
 t11-20020a056512068b00b00504369df11cmr2748994lfe.34.1695933862502; Thu, 28
 Sep 2023 13:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230928125517.12356-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20230928125517.12356-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 28 Sep 2023 13:44:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4rrOQAMaGwoCGR_fwS6qtPG+CUg9yKaAYN8Ye0+0-jBQ@mail.gmail.com>
Message-ID: <CAPhsuW4rrOQAMaGwoCGR_fwS6qtPG+CUg9yKaAYN8Ye0+0-jBQ@mail.gmail.com>
Subject: Re: [PATCH v2] md: do not require mddev_lock() for all options
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 28, 2023 at 5:55=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> We don't need to lock device to reject not supported request
> in array_state_store(). No functional changes intended.
>
> There are differences between ioctl and sysfs handling during stopping.
> With this change, it will be easier to add additional steps which needs
> to be completed before mddev_lock() is taken.
>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Applied to md-next. Thanks!

Song


> ---
> Song, feel free to remove second chapter if you think it is confusing.
>
>  drivers/md/md.c | 37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b8f232840f7c..469b1376e66c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4359,6 +4359,18 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>         int err =3D 0;
>         enum array_state st =3D match_word(buf, array_states);
>
> +       /* No lock dependent actions */
> +       switch (st) {
> +       case suspended:         /* not supported yet */
> +       case write_pending:     /* cannot be set */
> +       case active_idle:       /* cannot be set */
> +       case broken:            /* cannot be set */
> +       case bad_word:
> +               return -EINVAL;
> +       default:
> +               break;
> +       }
> +
>         if (mddev->pers && (st =3D=3D active || st =3D=3D clean) &&
>             mddev->ro !=3D MD_RDONLY) {
>                 /* don't take reconfig_mutex when toggling between
> @@ -4383,23 +4395,16 @@ array_state_store(struct mddev *mddev, const char=
 *buf, size_t len)
>         err =3D mddev_lock(mddev);
>         if (err)
>                 return err;
> -       err =3D -EINVAL;
> -       switch(st) {
> -       case bad_word:
> -               break;
> -       case clear:
> -               /* stopping an active array */
> -               err =3D do_md_stop(mddev, 0, NULL);
> -               break;
> +
> +       switch (st) {
>         case inactive:
> -               /* stopping an active array */
> +               /* stop an active array, return 0 otherwise */
>                 if (mddev->pers)
>                         err =3D do_md_stop(mddev, 2, NULL);
> -               else
> -                       err =3D 0; /* already inactive */
>                 break;
> -       case suspended:
> -               break; /* not supported yet */
> +       case clear:
> +               err =3D do_md_stop(mddev, 0, NULL);
> +               break;
>         case readonly:
>                 if (mddev->pers)
>                         err =3D md_set_readonly(mddev, NULL);
> @@ -4450,10 +4455,8 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>                         err =3D do_md_run(mddev);
>                 }
>                 break;
> -       case write_pending:
> -       case active_idle:
> -       case broken:
> -               /* these cannot be set */
> +       default:
> +               err =3D -EINVAL;
>                 break;
>         }
>
> --
> 2.26.2
>
