Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74405C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 15 Sep 2021 15:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A63661029
	for <linux-raid@archiver.kernel.org>; Wed, 15 Sep 2021 15:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhIOPKW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbhIOPKV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Sep 2021 11:10:21 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D371DC061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Sep 2021 08:09:02 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id p9so1881787uak.4
        for <linux-raid@vger.kernel.org>; Wed, 15 Sep 2021 08:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=RMJSUECpOrASX7O5LRnVxYeIxFzjfrmjLGpxkqAvY8k=;
        b=fG1R+ZurZZNulSU4h2FyWa8BiLThdEPNYfMegeS+bqMakGkSdanMBkE+TPOqkBZ45K
         zSj2rCbLodjCbuJ+ba+7+8wP36tkHVHGkv/X+ug2B/NBnsYDm0ES03GYQ7ltClBNLCBt
         2v0FMjTe5USxxcwcE/1XPryTf/AfNCg08HZ0wNZdYE5ugt34VBoVUM1Pe7M11SGJrtFe
         B5UZv3hgMb+9QMEWoT06Hz4zjii9wFSXH+BgCVb3SD6g8F6YRZKJuucVQ2/V7l4ck7j/
         oD3jqxnjz/a/hCE6tY/zogQ5p3iR0rolSGAhaXU+4vNA+e2cdGhZDrzPBEeRygW1TkQL
         so+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=RMJSUECpOrASX7O5LRnVxYeIxFzjfrmjLGpxkqAvY8k=;
        b=6EwHeT+GnWydLMOF0Pg/hYDFGqdEqvHKlKSvb1n5KKiqAExmNz7WR4LzXfl5tcu/77
         mM7xJWAnLgBAPqJHc57zmNX/MnIR9jdejmygsL2EBbNW/Bnm2U2VBCYukLODsaFDtxe/
         gOEMeNnqeBhICclWlA3NT3tZFCn/ISaAvjxdfwV6t60XC+9BdekzxAowx8lK64eEFaRC
         sQUefsANpNc7qqHJwmPUVamfnQ6+FxG6VyQDkN7gf613S2S4MUQ21JrZu31a8DNQa95A
         ysksY3YlVTO5t02I5zh6fO3SuJOaxchSsimhxKgvkkX6Wkxs5dBABgaGdqN5l/YMTYmI
         ysxw==
X-Gm-Message-State: AOAM530i7kSIOR1w7EVRPe7tfKn73dzMtbJQuOGFKU2hu7u1ob7I5E9L
        cBNjrdPb+syST6AFX782mM/w2+xiw3iPDpK1XK8nBg==
X-Google-Smtp-Source: ABdhPJz+lGvkNRjznJyetIKGsh0f+EIE9yBanUGKONiFPZyfcHxk7aW8eKufEF0k707acuEIfxACcEktEQW9DrvGs18=
X-Received: by 2002:ab0:2246:: with SMTP id z6mr290058uan.31.1631718541884;
 Wed, 15 Sep 2021 08:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210913032003.2836583-1-fengli@smartx.com>
In-Reply-To: <20210913032003.2836583-1-fengli@smartx.com>
From:   Li Feng <fengli@smartx.com>
Date:   Wed, 15 Sep 2021 23:08:51 +0800
Message-ID: <CAHckoCyDULok_QLLh5Nmbx4qLCxKL43TgtFgCSAwuaPpRy1BFw@mail.gmail.com>
Subject: Re: [PATCH] md: allow to set the fail_fast on RAID1/RAID10
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ping ...

Thanks,
Feng Li

Li Feng <fengli@smartx.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8813=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8811:22=E5=86=99=E9=81=93=EF=BC=9A
>
> When the running RAID1/RAID10 need to be set with the fail_fast flag,
> we have to remove each device from RAID and re-add it again with the
> --fail_fast flag.
>
> Export the fail_fast flag to the userspace to support the read and
> write.
>
> Signed-off-by: Li Feng <fengli@smartx.com>
> ---
>  drivers/md/md.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ae8fe54ea358..ce63972a4555 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3583,6 +3583,35 @@ ppl_size_store(struct md_rdev *rdev, const char *b=
uf, size_t len)
>  static struct rdev_sysfs_entry rdev_ppl_size =3D
>  __ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store);
>
> +static ssize_t
> +fail_fast_show(struct md_rdev *rdev, char *page)
> +{
> +       return sprintf(page, "%d\n", test_bit(FailFast, &rdev->flags));
> +}
> +
> +static ssize_t
> +fail_fast_store(struct md_rdev *rdev, const char *buf, size_t len)
> +{
> +       int ret;
> +       bool bit;
> +
> +       ret =3D kstrtobool(buf, &bit);
> +       if (ret)
> +               return ret;
> +
> +       if (test_bit(FailFast, &rdev->flags) && !bit) {
> +               clear_bit(FailFast, &rdev->flags);
> +               md_update_sb(rdev->mddev, 1);
> +       } else if (!test_bit(FailFast, &rdev->flags) && bit) {
> +               set_bit(FailFast, &rdev->flags);
> +               md_update_sb(rdev->mddev, 1);
> +       }
> +       return len;
> +}
> +
> +static struct rdev_sysfs_entry rdev_fail_fast =3D
> +__ATTR(fail_fast, 0644, fail_fast_show, fail_fast_store);
> +
>  static struct attribute *rdev_default_attrs[] =3D {
>         &rdev_state.attr,
>         &rdev_errors.attr,
> @@ -3595,6 +3624,7 @@ static struct attribute *rdev_default_attrs[] =3D {
>         &rdev_unack_bad_blocks.attr,
>         &rdev_ppl_sector.attr,
>         &rdev_ppl_size.attr,
> +       &rdev_fail_fast.attr,
>         NULL,
>  };
>  static ssize_t
> --
> 2.31.1
>
