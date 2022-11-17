Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF67C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 17 Nov 2022 19:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbiKQT46 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Nov 2022 14:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240496AbiKQT4y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Nov 2022 14:56:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3541836A
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 11:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7CAE62246
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 19:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284F5C433C1
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 19:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668715012;
        bh=CT73l0rKqfBVbtDUXVseQxwplBnWgXeqPjQKpEY7RgA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GMgpwdakAkQ5hUx1UT/fKTL30J7GiH7rtS+dVPMAz2bT9IyG5eYEdF5Kzu9T95dUY
         uf+V3s/xYtAXUl7UeIiUWlAbrwTEOqKnJcqc3JlYHyyFZwpcns0HTlkDfjokZ4QB07
         8LHfD0Zb6S9UIV1ExM091E2WyQq01RNiAQ+bNFRZZF8++fsbtV26TT5zfLTVdAOfRF
         HvQBAsKsm3js47uBfT5qNuOcB0/Cz1TYC4Bd5hvLuFUGujTs3XCvDDT2mDvoTCK9gD
         IYwB2Sik9sb6ylpxARJq3XdHT0L6hH5H1onz8y2bCIlVZwKCZV6ZUEUaTMybczN4fm
         6bBanHOI3Pe8Q==
Received: by mail-ej1-f51.google.com with SMTP id kt23so7798871ejc.7
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 11:56:52 -0800 (PST)
X-Gm-Message-State: ANoB5plC5qEbtKZt8mvtNnQZb9df4+eu0FJhqplGd7ys2+SGzVHElV9Y
        UY6K3qEIGF6Tt2msWfBNUsiuX4zhW7uTdRMtCl8=
X-Google-Smtp-Source: AA0mqf7FNOEVRvmHH+l4WObXqJttqUwA3BuOuToReIu0wrapvS7Z+Yyf0CJq6DZ5jqOQxHXXmBzRc3rPUnCGxhW10A4=
X-Received: by 2002:a17:906:348b:b0:78d:9e04:d8c2 with SMTP id
 g11-20020a170906348b00b0078d9e04d8c2mr3298136ejb.614.1668715010285; Thu, 17
 Nov 2022 11:56:50 -0800 (PST)
MIME-Version: 1.0
References: <20221024064836.12731-1-xni@redhat.com> <CAPhsuW7-VaWT1SkuT-Tj_2jGgjso3NJ2hN6v8xUgdCHq3NON_g@mail.gmail.com>
 <CALTww28dJes9MSw5S0bS+zqa6vLGsw1AMeqi5UKHwOkbgKMhQw@mail.gmail.com> <CALTww2_=vEpbCWHrVchYnoS=ohZUsVUr+6F=TERCQgBKNa=XYg@mail.gmail.com>
In-Reply-To: <CALTww2_=vEpbCWHrVchYnoS=ohZUsVUr+6F=TERCQgBKNa=XYg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 17 Nov 2022 11:56:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4rkLtYaPQbXPsQn+5kEFNzACYhM4UaAS+sKU1AHurRzw@mail.gmail.com>
Message-ID: <CAPhsuW4rkLtYaPQbXPsQn+5kEFNzACYhM4UaAS+sKU1AHurRzw@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] Add mddev->io_acct_cnt for raid0_quiesce
To:     Xiao Ni <xni@redhat.com>
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

Thanks for the results.

On Wed, Nov 16, 2022 at 6:03 PM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Song
>
> The performance is good.  Please check the result below.
>
> And for the patch itself, do you think we should add a smp_mb
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4d0139cae8b5..3696e3825e27 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8650,9 +8650,11 @@ static void md_end_io_acct(struct bio *bio)
>         bio_put(bio);
>         bio_endio(orig_bio);
>
> -       if (atomic_dec_and_test(&mddev->io_acct_cnt))
> +       if (atomic_dec_and_test(&mddev->io_acct_cnt)) {
> +               smp_mb();
>                 if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
>                         wake_up(&mddev->wait_io_acct);
> +       }
>  }
>
>  /*
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 9d4831ca802c..1818f79bfdf7 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -757,6 +757,7 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
>          * to member disks to avoid memory alloc and performance decrease
>          */
>         set_bit(MD_QUIESCE, &mddev->flags);
> +       smp_mb();
>         wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
>         clear_bit(MD_QUIESCE, &mddev->flags);
>  }
>
> Test result:

I think there is some noise in the result?

>
>                           without patch    with patch
> psync read          100MB/s           101MB/s         job:1 bs:4k

For example, this is a small improvement, but

>                            1015MB/s         1016MB/s       job:1 bs:128k
>                            1359MB/s         1358MB/s       job:1 bs:256k
>                            1394MB/s         1393MB/s       job:40 bs:4k
>                            4959MB/s         4873MB/s       job:40 bs:128k
>                            6166MB/s         6157MB/s       job:40 bs:256k
>
>                           without patch      with patch
> psync write          286MB/s           275MB/s        job:1 bs:4k

this is a big regression (~4%).

>                             1810MB/s         1808MB/s      job:1 bs:128k
>                             1814MB/s         1814MB/s      job:1 bs:256k
>                             1802MB/s         1801MB/s      job:40 bs:4k
>                             1814MB/s         1814MB/s      job:40 bs:128k
>                             1814MB/s         1814MB/s      job:40 bs:256k
>
>                           without patch
> psync randread    39.3MB/s           39.7MB/s      job:1 bs:4k
>                              791MB/s            783MB/s       job:1 bs:128k
>                             1183MiB/s          1217MB/s     job:1 bs:256k
>                             1183MiB/s          1235MB/s     job:40 bs:4k
>                             3768MB/s          3705MB/s     job:40 bs:128k

And some regression for 128kB but improvement for 4kB.

>                             4410MB/s           4418MB/s     job:40 bs:256k

So I am not quite convinced by these results.

Also, do we really need an extra counter here? Can we use
mddev->active_io instead?

Thanks,
Song

[...]
