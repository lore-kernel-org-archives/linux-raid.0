Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77314EEAA60
	for <linux-raid@archiver.kernel.org>; Thu, 14 Sep 2023 17:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240531AbjINR6K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Sep 2023 13:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239714AbjINR6K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Sep 2023 13:58:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4361FFA
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 10:58:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEB3C433C9
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694714285;
        bh=CWY5MNlWNk9b+M9b6JJOharLepzYIqtnKC/3VcZo9Pg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lPB0jbVa3ceBuhwqYIEUYuw030KRRcp3bwIsNP+0qDVrrB53HsE+RrnI/xOxgMSVB
         R5pVLNpY588SjtvcZ8pIHTgj4BC6VYHDSXl1KXYIk3D78F68ZjWi12FeZ0x0olRj1T
         WSHwW5P9LZoKAT+y4GUNelVH4VcEOhxmWUiJ+nDTCYHGAz2st+NTbtjL/bf6sO+zJR
         j1ftMPZQuVLrqZ/IsK2CDqD3y2jb+nbciIvhsEna8jFJ6YfP01WXhGm+gc065fPG6I
         LUvDyvqC6tVB/YeVSczpibaOH9yv6lfANsb+jomRvkRO0K7wr8LNqpSlaK5Ju2qCwI
         paXaMztXFPyIQ==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-501eec0a373so2090582e87.3
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 10:58:05 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx86g4Up2nEHFPSMa45jY167x/8L1Wr7jJI7YgPP7UtOO7J9BL0
        v8j7pxOvzb4A5n7S1I0ZjF/JSri7GJn9yPuV6Ow=
X-Google-Smtp-Source: AGHT+IG2tAkvmcmsQ5Ej4vSrD7RLySbfvtlCoFJEKRIAQ4zlHIEVNmnkhIJFdczwnR9THqQELCuSS9wAxijSFO+Cm3o=
X-Received: by 2002:a19:710a:0:b0:500:8fcd:c3b8 with SMTP id
 m10-20020a19710a000000b005008fcdc3b8mr4667156lfc.8.1694714283751; Thu, 14 Sep
 2023 10:58:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230914152416.10819-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20230914152416.10819-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 14 Sep 2023 10:57:49 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6nNoMXs0b32DtZzTNpGDpWUuhyy-n+WQs-OcKGLeW8QA@mail.gmail.com>
Message-ID: <CAPhsuW6nNoMXs0b32DtZzTNpGDpWUuhyy-n+WQs-OcKGLeW8QA@mail.gmail.com>
Subject: Re: [PATCH v3] md: do not _put wrong device in md_seq_next
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        AceLan Kao <acelan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 14, 2023 at 8:24=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> If there are multiple arrays in system and one mddevice is marked
> with MD_DELETED and md_seq_next() is called in the middle of removal
> then it _get()s proper device but it may _put() deleted one. As a result,
> active counter may never be zeroed for mddevice and it cannot
> be removed.
>
> Put the device which has been _get with previous md_seq_next() call.
>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the di=
sk is freed")
> Reported-by: AceLan Kao <acelan@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217798
>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Applied to md-fixes, with minor changes in the commit log.

Thanks,
Song

> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0fe7ab6e8ab9..b8f232840f7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8256,7 +8256,7 @@ static void *md_seq_next(struct seq_file *seq, void=
 *v, loff_t *pos)
>         spin_unlock(&all_mddevs_lock);
>
>         if (to_put)
> -               mddev_put(mddev);
> +               mddev_put(to_put);
>         return next_mddev;
>
>  }
> --
> 2.26.2
>
