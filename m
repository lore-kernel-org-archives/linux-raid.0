Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFD2C072A2
	for <linux-raid@archiver.kernel.org>; Mon, 20 Nov 2023 01:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjKTBjg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Nov 2023 20:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKTBjf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Nov 2023 20:39:35 -0500
X-Greylist: delayed 486 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Nov 2023 17:39:31 PST
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF152E6
        for <linux-raid@vger.kernel.org>; Sun, 19 Nov 2023 17:39:31 -0800 (PST)
Message-ID: <9f0b45c9-08e9-70af-ba04-889c89adf029@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1700443880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YYfEQ8fIHIVA8FEuolHWdcFCcO2CgmeUzHN1quGuJDo=;
        b=HJLa7AcscrjcC7Foio07Y69sf7dVYLAfe1tjLTYvtkl9e6PHuzw9R7WJFAzD+eJ5/bUDEY
        zX283CkUarNFDgCt5o1OdcZ5M+dQ8hxZPCVlznUeIuUSerJAgd1BAuWcwhm1VGRBIe9A6p
        5jST9rin0o2LMeQhrXY8y4dzpWzHyrg=
Date:   Mon, 20 Nov 2023 09:31:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] md: fix bi_status reporting in md_end_clone_io
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>
References: <20231118003958.2740032-1-song@kernel.org>
Content-Language: en-US
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
