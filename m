Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1C6C072A2
	for <linux-raid@archiver.kernel.org>; Mon, 20 Nov 2023 01:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjKTBkP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Nov 2023 20:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKTBkP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Nov 2023 20:40:15 -0500
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90FAE6
        for <linux-raid@vger.kernel.org>; Sun, 19 Nov 2023 17:40:11 -0800 (PST)
Message-ID: <018cb659-462e-135a-28df-37fc6d846fa9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1700444410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YYfEQ8fIHIVA8FEuolHWdcFCcO2CgmeUzHN1quGuJDo=;
        b=k3+yfkKMpOeZratr5r/5SOJLMnKmapXwC9tlE1S4WWm1Q1yMOgIdEpIYaqFJvWTaKnHx5o
        K+Khu2zaTcW9U9STm9JZ5LGsFpNcH1FoiO5NTEgviuhPjUurW5ovLzDfGd0S+q2I5w+3y3
        bfccUMV3wbYIvmPud5IRINBfiO6/2Fc=
Date:   Mon, 20 Nov 2023 09:40:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] md: fix bi_status reporting in md_end_clone_io
Content-Language: en-US
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>, guoqing.jiang@linux.dev
References: <20231118003958.2740032-1-song@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <20231118003958.2740032-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/18/23 08:39, Song Liu wrote:
> md_end_clone_io() may overwrite error status in orig_bio->bi_status with
> BLK_STS_OK. This could happen when orig_bio has BIO_CHAIN (split by
> md_submit_bio => bio_split_to_limits, for example). As a result, upper
> layer may miss error reported from md (or the device) and consider the
> failed IO was successful.
>
> Fix this by only update orig_bio->bi_status when current bio reports
> error and orig_bio is BLK_STS_OK. This is the same behavior as
> __bio_chain_endio().

DRBD has the similar change.

> Fixes: 10764815ff47 ("md: add io accounting for raid0 and raid5")
> Reported-by: Bhanu Victor DiCara <00bvd0+linux@gmail.com>
> Closes: https://lore.kernel.org/regressions/5727380.DvuYhMxLoT@bvd0/
> Signed-off-by: Song Liu <song@kernel.org>
> Tested-by: Xiao Ni <xni@redhat.com>
> Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>   drivers/md/md.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4ee4593c874a..c94373d64f2c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8666,7 +8666,8 @@ static void md_end_clone_io(struct bio *bio)
>   	struct bio *orig_bio = md_io_clone->orig_bio;
>   	struct mddev *mddev = md_io_clone->mddev;
>   
> -	orig_bio->bi_status = bio->bi_status;
> +	if (bio->bi_status && !orig_bio->bi_status)
> +		orig_bio->bi_status = bio->bi_status;

Thanks for the fix!

Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Guoqing
