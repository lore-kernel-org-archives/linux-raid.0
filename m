Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D720EC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 11 Feb 2022 06:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344026AbiBKGs2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:48:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240644AbiBKGsX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Feb 2022 01:48:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 290D910B4
        for <linux-raid@vger.kernel.org>; Thu, 10 Feb 2022 22:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644562102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FDwBQ13mzLdBvtS5dld81k2YIMs1kTH1PBkPnaQTPkQ=;
        b=ekbN03qf9kD6NooFVm1/3XgVUjlBjPOxWciZK/YeI0DeYp05HM0SrntxoeFfmERZQFCNSH
        EWwEODqqiXs9ESbXJTBe1OBY4lFBcn8gjhJOi8SNDN1FRRTKkw6Stl+pDTUBzMlUBAbAfU
        msHGa/VwdC1Nr6GtV0NvQGdHllXawZo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-AnEGkLJZN6e3iCVB2UD8OA-1; Fri, 11 Feb 2022 01:48:20 -0500
X-MC-Unique: AnEGkLJZN6e3iCVB2UD8OA-1
Received: by mail-ed1-f70.google.com with SMTP id w3-20020a50c443000000b0040696821132so4746348edf.22
        for <linux-raid@vger.kernel.org>; Thu, 10 Feb 2022 22:48:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDwBQ13mzLdBvtS5dld81k2YIMs1kTH1PBkPnaQTPkQ=;
        b=S9w3x8wz9klO0GJ24Jygm9UMba2K3HweV5XXCgtT6LrYxUDJWQmF4ZqeHfKHQ2ghT4
         tlkmXVXbg6hmULD7ZBxrFxdvgg1nL6zz4j1DdjPg0tSCehPmhPtjuJH0Y+Li3RuUvwqT
         gozbuV9NElKg9Sk6KFprnfH9sq14nB26GuNaBS06nhvsJ05zUAyoUpmPWWgP6m/a5Q4l
         QEV7yqJrYbY26FiQZH6k3SI7beLMCOXprXNXJaRLNBS2ZqWKmgg1N2XjZnJVbt9tDxI+
         gLHwpKPVFJSZtcx7qrY5aQIaODUYFHTF8PzmZBZAQRaCPkknOLp52jHKF9FDs3djF1uh
         m7gQ==
X-Gm-Message-State: AOAM531xlgrZZUf55kJe2EZFHl5U45BjakgSFxU4a39GdmDZYsjEL0j1
        AoHQnsszOYoCnMepDHqmqrZesNvkcTWJINixUNYrKugJYZrcErwarPh9iOx+Pz5Y2/q/JDycv84
        OnUGCS2i+VXkj1eFad6pkl0rw7pupJa7xLoRcsQ==
X-Received: by 2002:a17:907:a426:: with SMTP id sg38mr217056ejc.108.1644562099639;
        Thu, 10 Feb 2022 22:48:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxylPKTlD8mVKxOXLe6uCHDc8UM0+HhN8krMzlS+aYWmG5u96H0CzCnGSdzUSs6iDsLfHSBZnsyZ4ceVWDyOPs=
X-Received: by 2002:a17:907:a426:: with SMTP id sg38mr217048ejc.108.1644562099433;
 Thu, 10 Feb 2022 22:48:19 -0800 (PST)
MIME-Version: 1.0
References: <20220209104046.00004427@linux.intel.com>
In-Reply-To: <20220209104046.00004427@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 11 Feb 2022 14:48:57 +0800
Message-ID: <CALTww2-OLe4y1kjBnz7CTBQiNerd-y9XrEc34rjO1sm5tEV5VA@mail.gmail.com>
Subject: Re: fail_last_dev and FailFast/LastDev flag incompatibility
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Marisuz

We don't need to consider MD_FAILFAST for raid456. Because only raid1
and raid10 support it.
MD_FAILFAST_SUPPORTED is only set in raid1_run/raid10_run. So LastDev
only be useful for
raid1/raid10. It should be good to only check Faulty here.

Best Regards
Xiao

On Wed, Feb 9, 2022 at 5:40 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi All,
> During my work under failed arrays handling[1] improvements, I
> discovered potential issue with "failfast" and metadata writes. In
> commit message[2] Neil mentioned that:
> "If we get a failure writing metadata but the device doesn't
> fail, it must be the last device so we re-write without
> FAILFAST".
>
> Obviously, this is not true for RAID456 (again)[1] but it is also not
> true for RAID1 and RAID10 with "fail_las_dev"[3] functionality enabled.
>
> I did a quick check and can see that setter for "LastDev" flag is
> called if "Faulty" on device is not set. I proposed some changes in the
> area in my patchset[4] but after discussion we decided to drop changes
> here. Current approach is not correct for all branches, so my proposal
> is to change:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7b024912f1eb..3daec14ef6b2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -931,7 +931,7 @@ static void super_written(struct bio *bio)
>                 pr_err("md: %s gets error=%d\n", __func__,
>                        blk_status_to_errno(bio->bi_status));
>                 md_error(mddev, rdev);
> -               if (!test_bit(Faulty, &rdev->flags)
> +               if (test_bit(MD_BROKEN, mddev->flag)
>                     && (bio->bi_opf & MD_FAILFAST)) {
>                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>                         set_bit(LastDev, &rdev->flags);
>
>
> It will force "LastDev" to be set on every metadata rewrite if mddevice
> is known to be failed.
> Do you have any other suggestions?
>
> + Guoqing - author of fail_last_dev.
> + Xiao - you are familiarized with FailFast so please take a look.
>
> [1]https://lore.kernel.org/linux-raid/CAPhsuW54_9CTR6sh7mnQ6O77F2HNArLHGWHYsUdbNGy7pXgipQ@mail.gmail.com/T/#m8cf7c57429b6fd332220157186151900ce23865d
> [2]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=46533ff7fefb7e9e3539494f5873b00091caa8eb
> [3]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce
> [4]https://lore.kernel.org/linux-raid/CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com/
>
> Thanks,
> Mariusz
>

