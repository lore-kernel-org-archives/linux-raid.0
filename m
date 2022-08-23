Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41D5C32772
	for <linux-raid@archiver.kernel.org>; Tue, 23 Aug 2022 19:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiHWTJn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Aug 2022 15:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiHWTJH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Aug 2022 15:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A686AE206
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 10:47:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED6A615FB
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 17:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946BAC433D6
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661276381;
        bh=tQi3HvWT0U/0YO1dP0DgLQ6zsdi5e6MkpMuAu5df4HM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=amzAahpqwybunADLynMOrEpM+O5xrN5/Q/9CUem6LpSKbTAIRf5XKLUQvftMOT3V2
         jSPOdQenn4J4KOWBua2/Yr1hMFBhHAu4r6JZXaprS2fiRTaiHEfpylAp6lnjivDyJX
         zcv0v5xbHBbac4AQ8XtEnMHCVcgx23vh4goFcHM5nUFc28o5Qs0c4x/2zKvwpS3p+6
         qW+Pd4agOSsreEQG8/ICxurd+jkNW9+YTQwxCwW/tq2IJqACD/sf7TTnqT9bNFtMQ2
         GX6EENpBO2VrXEll60oJixNL9M0tFNC95LjKzf1nwkoR/Ttze0zWk/5N8n7xuaT0AR
         EixcFwp/cNMGA==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-333b049f231so399152227b3.1
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 10:39:41 -0700 (PDT)
X-Gm-Message-State: ACgBeo1n1GmTofh/sGxYGMWqYLjL/GLqSWmJ1UlTalu8Ym4XXE62dCOd
        6jW1KMxvRfxSK5jj8gteD2CLXWT3e4dy8is4R8k=
X-Google-Smtp-Source: AA6agR74Aq/L/YU0gwJTCETt3CkVgcoeG3ja2t0M27J/pXD1/j92ahRh5mV6FwuynT4HiKXI8fVj5FWhKg2xhw0Mb1c=
X-Received: by 2002:a25:3813:0:b0:68d:c8f8:60b9 with SMTP id
 f19-20020a253813000000b0068dc8f860b9mr25935649yba.257.1661276380551; Tue, 23
 Aug 2022 10:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220822074539.12877-1-guoqing.jiang@linux.dev>
In-Reply-To: <20220822074539.12877-1-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Tue, 23 Aug 2022 10:39:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW763vum3E240rC4XhnsGL-NSH5sdvtn--5ajMiCGF14MQ@mail.gmail.com>
Message-ID: <CAPhsuW763vum3E240rC4XhnsGL-NSH5sdvtn--5ajMiCGF14MQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: fix compile warning
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 22, 2022 at 12:46 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> With W=1, compiler complains.
>
> drivers/md/raid10.c:1983: warning: bad line:
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Applied to md-next.

Thanks!
Song

> ---
>  drivers/md/raid10.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 26545950ca42..aa5b28017a49 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1980,7 +1980,7 @@ static int enough(struct r10conf *conf, int ignore)
>   * Otherwise, it must be degraded:
>   *     - recovery is interrupted.
>   *     - &mddev->degraded is bumped.
> -
> + *
>   * @rdev is marked as &Faulty excluding case when array is failed and
>   * &mddev->fail_last_dev is off.
>   */
> --
> 2.31.1
>
