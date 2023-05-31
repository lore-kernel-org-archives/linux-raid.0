Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C513FC77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 01:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjEaBHB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 21:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjEaBHA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 21:07:00 -0400
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64E2115
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 18:06:54 -0700 (PDT)
Message-ID: <b9fd7105-eadc-29cb-fa2e-24109f4a99b7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685495212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktzBuz1Q0UcNMvPLJbCEC7kXeHrx4XPsgK/A+XpXcuU=;
        b=EJC9mR5IYtOEihQJMiQ3p2YVDC9buKhBp0eZPGkk3yxFbf4kkEOCXDSGcAJRdu0n1J0i6P
        6xyGMgnkya/qb9Jz5rYkkr8qo3zDR4AwSBhGe/zxv+xDAH3PndkF47zRMHjkXOIZdUll9/
        dc4EuVou47LGbuMJ5DyzQt5Ukc8NXaU=
Date:   Wed, 31 May 2023 09:06:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] md/raid5: don't allow concurrent reshape with recovery
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
        pmenzel@molgen.mpg.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20230529133410.2125914-1-yukuai1@huaweicloud.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <20230529133410.2125914-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/29/23 21:34, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
>
> Commit 0aecb06e2249 ("md/raid5: don't allow replacement while reshape
> is in progress") fixes that replacement can be set if reshape is
> interrupted, which will cause that array can't be assembled.
>
> There is a similar problem on the other side, if recovery is
> interrupted, then reshape can start, which will cause the same problem.
>
> Fix the problem by not starting to reshape while recovery is still in
> progress.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
> Changes in v2:
>   - fix some typo in commit message.
>
>   drivers/md/raid5.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8686d629e3f2..6615abf54d3f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8525,6 +8525,7 @@ static int raid5_start_reshape(struct mddev *mddev)
>   	struct r5conf *conf = mddev->private;
>   	struct md_rdev *rdev;
>   	int spares = 0;
> +	int i;
>   	unsigned long flags;
>   
>   	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> @@ -8536,6 +8537,13 @@ static int raid5_start_reshape(struct mddev *mddev)
>   	if (has_failed(conf))
>   		return -EINVAL;
>   
> +	/* raid5 can't handle concurrent reshape and recovery */
> +	if (mddev->recovery_cp < MaxSector)
> +		return -EBUSY;
> +	for (i = 0; i < conf->raid_disks; i++)
> +		if (rdev_mdlock_deref(mddev, conf->disks[i].replacement))
> +			return -EBUSY;
> +

Does it mean reshape and recovery  can happen in parallel without the 
change?
I really doubt about it given any kind of internal io (resync, reshape 
and recovery)
is handled by resync thread. And IIUC either md_do_sync or md_check_recovery
should avoid it, no need to do it in personality layer.

Thanks,
Guoqing
