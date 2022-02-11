Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E62EC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 11 Feb 2022 08:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbiBKI6x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:58:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiBKI6u (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Feb 2022 03:58:50 -0500
X-Greylist: delayed 542 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Feb 2022 00:58:49 PST
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B809A218
        for <linux-raid@vger.kernel.org>; Fri, 11 Feb 2022 00:58:49 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644569385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xBzHRphqul3p6cJisFjSZrLDwrotAMqrn0ldrG9ZKm4=;
        b=buRdtmHQFMqgEdDnXpbfzyP6xIOhhtXpG5EmoYsTuEwBRRDMyiPQQSzWl+OiqhK4AESqNL
        djxA0bAztYrex9kepxmAfsBuqVk8goBisiB5bEeKRaTSMGXuJz9CEio/YAXdV909shSaHw
        exb1epPPisVv/SDa7Q3X4ims1rYQoJE=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: fail_last_dev and FailFast/LastDev flag incompatibility
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>, Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220209104046.00004427@linux.intel.com>
Message-ID: <acc4e1ed-2161-fa83-0b87-322cf8c81e3d@linux.dev>
Date:   Fri, 11 Feb 2022 16:49:38 +0800
MIME-Version: 1.0
In-Reply-To: <20220209104046.00004427@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2/9/22 5:40 PM, Mariusz Tkaczyk wrote:
> Hi All,
> During my work under failed arrays handling[1]*improvements*,

Sorry, I disagree, will comment your new version later.

> I discovered potential issue with "failfast" and metadata writes. In
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
>                  pr_err("md: %s gets error=%d\n", __func__,
>                         blk_status_to_errno(bio->bi_status));
>                  md_error(mddev, rdev);
> -               if (!test_bit(Faulty, &rdev->flags)
> +               if (test_bit(MD_BROKEN, mddev->flag)
>                      && (bio->bi_opf & MD_FAILFAST)) {
>                          set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>                          set_bit(LastDev, &rdev->flags);

IIUC, there is no problem with checking Faulty since super_written is
against rdev while MD_BROKEN is supposed to mean array is broken.

Thanks,
Guoqing
