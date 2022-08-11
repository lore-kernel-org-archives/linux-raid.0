Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF043C19F2A
	for <linux-raid@archiver.kernel.org>; Thu, 11 Aug 2022 17:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbiHKRrB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Aug 2022 13:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiHKRrA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Aug 2022 13:47:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01801A0264
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 10:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DADE61741
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 17:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C0DC43470
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660240018;
        bh=tfa3JgbtNctpJCDOt04IEWJaaeTa2n0o1FCg3cGNd8o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fzmA542JlvxHgyENtq9fbW/U2sXM8ALCKJ+4B6byLifXeUYxg8lPF1l1xGPgHguTz
         B0B2t+1sffBlBeionbLRRWclQEcpXL7rRjxAm9LOTA1cBeeao1y0Jtw+jM7lDgpGvK
         GoGViQP08gdAtb4eScZLrw4g4LyueaQIcebQT1e1eZ0xtgM4EctK1oLDsEmqUr2nVB
         p2Yt78iajrMSnGvPoU4YSNsqmMqGaeL5b6u1D1+TAi6d4ZnLO/UAD6arPmgc7xikMK
         k265i91HZlbtAx9eh3k0f9/Z3LqwDCNOEZYppQmEeCR8B7p2FtRDQW9tcr0WuCNmlc
         KJxQZw7myQ32Q==
Received: by mail-yb1-f181.google.com with SMTP id 204so29398597yba.1
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 10:46:57 -0700 (PDT)
X-Gm-Message-State: ACgBeo1CAbwwyctMrJsRANSmEBzqM/JCJy7Sk1qHCVkfTAfWX3ldUIVf
        K1HNmQfQfJyZ16UyJ+K8BViKxzbTUr7VDD5WzGI=
X-Google-Smtp-Source: AA6agR6/vvESeyj2kCOlb8NGFB3ua6BtnCOBVa0yUwZHc9NXuRbSqLHIESsjV/JY6TLDeZio6Fe8mH1pZym0XAtqiZs=
X-Received: by 2002:a25:428f:0:b0:67a:82bd:5a0 with SMTP id
 p137-20020a25428f000000b0067a82bd05a0mr401909yba.257.1660240017050; Thu, 11
 Aug 2022 10:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220810182012.755167-1-bvanassche@acm.org>
In-Reply-To: <20220810182012.755167-1-bvanassche@acm.org>
From:   Song Liu <song@kernel.org>
Date:   Thu, 11 Aug 2022 10:46:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6ubVnF5KinJMhjPgGskLFvVp8AqxnEfqbezjHUXRxLTg@mail.gmail.com>
Message-ID: <CAPhsuW6ubVnF5KinJMhjPgGskLFvVp8AqxnEfqbezjHUXRxLTg@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid10: Fix the data type of an r10_sync_page_io() argument
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Rong A Chen <rong.a.chen@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 10, 2022 at 11:20 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Fix the following sparse warning:
>
> drivers/md/raid10.c:2647:60: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected restricted blk_opf_t [usertype] opf @@     got int rw @@
>
> This patch does not change any functionality since REQ_OP_READ = READ = 0
> and since REQ_OP_WRITE = WRITE = 1.
>
> Cc: Rong A Chen <rong.a.chen@intel.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>
> Fixes: 4ce4c73f662b ("md/core: Combine two sync_page_io() arguments")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Applied to md-fixes. Thanks!

Song

> ---
>
> Changes compared to v1: made the patch subject more specific.
>
>  drivers/md/raid10.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9117fcdee1be..64d6e4cd8a3a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2639,18 +2639,18 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
>  }
>
>  static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
> -                           int sectors, struct page *page, int rw)
> +                           int sectors, struct page *page, enum req_op op)
>  {
>         sector_t first_bad;
>         int bad_sectors;
>
>         if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
> -           && (rw == READ || test_bit(WriteErrorSeen, &rdev->flags)))
> +           && (op == REQ_OP_READ || test_bit(WriteErrorSeen, &rdev->flags)))
>                 return -1;
> -       if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
> +       if (sync_page_io(rdev, sector, sectors << 9, page, op, false))
>                 /* success */
>                 return 1;
> -       if (rw == WRITE) {
> +       if (op == REQ_OP_WRITE) {
>                 set_bit(WriteErrorSeen, &rdev->flags);
>                 if (!test_and_set_bit(WantReplacement, &rdev->flags))
>                         set_bit(MD_RECOVERY_NEEDED,
> @@ -2780,7 +2780,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>                         if (r10_sync_page_io(rdev,
>                                              r10_bio->devs[sl].addr +
>                                              sect,
> -                                            s, conf->tmppage, WRITE)
> +                                            s, conf->tmppage, REQ_OP_WRITE)
>                             == 0) {
>                                 /* Well, this device is dead */
>                                 pr_notice("md/raid10:%s: read correction write failed (%d sectors at %llu on %pg)\n",
> @@ -2814,8 +2814,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>                         switch (r10_sync_page_io(rdev,
>                                              r10_bio->devs[sl].addr +
>                                              sect,
> -                                            s, conf->tmppage,
> -                                                READ)) {
> +                                            s, conf->tmppage, REQ_OP_READ)) {
>                         case 0:
>                                 /* Well, this device is dead */
>                                 pr_notice("md/raid10:%s: unable to read back corrected sectors (%d sectors at %llu on %pg)\n",
