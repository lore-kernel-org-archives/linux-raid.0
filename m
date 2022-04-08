Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D74C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 00:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiDHAbm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiDHAbl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 20:31:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578521D08E1
        for <linux-raid@vger.kernel.org>; Thu,  7 Apr 2022 17:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E56C7615C6
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 00:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF42C385A4
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 00:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649377778;
        bh=zxDfqdwCICYB6oHbCmvitUB1SOALJaIkCcX7W9ZMerw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NyRGwJhtWGHmTe4WpyPPaux+46xMm09SrB9kTwaDNWONT5BrruZi05EBdhtTfsZ4v
         MokqvC0ph/gOQZ06Pc4/XlJkxqvgGoKTX6xFpIgdY87tQ3lQKh6YXRYmla0Dg/8MWz
         k7J9Y9Fv+PrsDKNaKkXcCwig7pt+Q7TawNiGVfOKlU6j8vcN4GQWrKMgtor56mKS+f
         TpZTDhggoU8D/Q/HRwPYEI4SIrT+b6eiYoouXzEySJB0eMLu0jp3RqmMR1t0oIRfXy
         qKmLqqqxZqHPGtM2P5unqkJzN4mvw6OweXH9INyyGPV5uJgM5FMyPMPrdW1a6+FHUm
         qlZ9mlZ8z6NlQ==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2eb680211d9so79757467b3.9
        for <linux-raid@vger.kernel.org>; Thu, 07 Apr 2022 17:29:38 -0700 (PDT)
X-Gm-Message-State: AOAM531q4g+SD9ApzBwnxTplk1FdGnS91GlrRskYbOxnxIcmj42gNRGI
        2p8iEpyLhqpUuGYrHIhg7RHaRdivgaQDvElgwoY=
X-Google-Smtp-Source: ABdhPJwt5Cknl7GYC/lO6Y37cWJVAHS6YFr4BT6g1DhJt4nJ9E0jYW+SWEtAybCPIXr9SzHczW5ZkJotGcs5S4738T4=
X-Received: by 2002:a81:1694:0:b0:2eb:8d40:abd7 with SMTP id
 142-20020a811694000000b002eb8d40abd7mr13470753yww.211.1649377777251; Thu, 07
 Apr 2022 17:29:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com> <20220322152339.11892-4-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20220322152339.11892-4-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Apr 2022 17:29:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW47katBeSM7yuWeAxOCaK1GjcvEW6wM5m+YW8p8MS7_aA@mail.gmail.com>
Message-ID: <CAPhsuW47katBeSM7yuWeAxOCaK1GjcvEW6wM5m+YW8p8MS7_aA@mail.gmail.com>
Subject: Re: [PATCH 3/3] raid5: introduce MD_BROKEN
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 22, 2022 at 8:24 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Raid456 module had allowed to achieve failed state. It was fixed by
> fb73b357fb9 ("raid5: block failing device if raid will be failed").
> This fix introduces a bug, now if raid5 fails during IO, it may result
> with a hung task without completion. Faulty flag on the device is
> necessary to process all requests and is checked many times, mainly in
> analyze_stripe().
[...]

> Cc: stable@vger.kernel.org
> Fixes: fb73b357fb9 ("raid5: block failing device if raid will be failed")
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  drivers/md/raid5.c | 48 +++++++++++++++++++++++-----------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7c119208a214..4d76e3a89aa5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -686,17 +686,20 @@ int raid5_calc_degraded(struct r5conf *conf)
>         return degraded;
>  }
>
> -static int has_failed(struct r5conf *conf)
> +static bool has_failed(struct r5conf *conf)
>  {
> -       int degraded;
> +       int degraded = conf->mddev->degraded;
>
> -       if (conf->mddev->reshape_position == MaxSector)
> -               return conf->mddev->degraded > conf->max_degraded;
> +       if (test_bit(MD_BROKEN, &conf->mddev->flags))
> +               return true;
> +
> +       if (conf->mddev->reshape_position != MaxSector)
> +               degraded = raid5_calc_degraded(conf);
>
> -       degraded = raid5_calc_degraded(conf);
>         if (degraded > conf->max_degraded)

nit: we can just do
   return degraded > conf->max_degraded;

[...]
