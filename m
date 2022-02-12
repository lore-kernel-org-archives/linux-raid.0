Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D286C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 12 Feb 2022 01:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354521AbiBLBMK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Feb 2022 20:12:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiBLBMJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Feb 2022 20:12:09 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4995D5C
        for <linux-raid@vger.kernel.org>; Fri, 11 Feb 2022 17:12:06 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644628323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQLultXQdNvtYvW2PYUXjTr+d4B8T8/S9nuBmOR7Ki0=;
        b=gSla1N+PConVS3YvwcZRKnDAq154XtTX/vcZhhsR4gVIBkWXqk+/Sy5/SChxv2zaLPmdLb
        PbuYVtyTeWFQLU7LLBDcWhmacUYm8DEoHoNuEGGTAl1lLRkGYicRwYsa0We9019An95tQz
        qxuh3rofmqiGpyhJRZuhW3ge7bLfxnI=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com>
Message-ID: <de8e69dc-4e44-de6f-d3d2-9d52935c9b35@linux.dev>
Date:   Sat, 12 Feb 2022 09:12:00 +0800
MIME-Version: 1.0
In-Reply-To: <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 1/27/22 11:39 PM, Mariusz Tkaczyk wrote:
> Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs
> if a member is gone") allowed to finish writes earlier (before level
> dependent actions) for non-redundant arrays.
>
> To achieve that MD_BROKEN is added to mddev->flags if drive disappearance
> is detected. This is done in is_mddev_broken() which is confusing and not
> consistent with other levels where error_handler() is used.
> This patch adds appropriate error_handler for raid0 and linear.

I think the purpose of them are quite different, as said before, 
error_handler
is mostly against rdev while is_mddev_broken is for mddev though it needs
to test rdev first.

> It also adopts md_error(), we only want to call .error_handler for those
> levels. mddev->pers->sync_request is additionally checked, its existence
> implies a level with redundancy.
>
> Usage of error_handler causes that disk failure can be requested from
> userspace. User can fail the array via #mdadm --set-faulty command. This
> is not safe and will be fixed in mdadm.

What is the safe issue here? It would betterr to post mdadm fix together.

> It is correctable because failed
> state is not recorded in the metadata. After next assembly array will be
> read-write again.

I don't think it is a problem, care to explain why it can't be RW again?

> For safety reason is better to keep MD_BROKEN in runtime only.

Isn't MD_BROKEN runtime already? It is mddev_flags not mddev_sb_flags.

> Signed-off-by: Mariusz Tkaczyk<mariusz.tkaczyk@linux.intel.com>
> ---
>   drivers/md/md-linear.c | 15 ++++++++++++++-
>   drivers/md/md.c        |  6 +++++-
>   drivers/md/md.h        | 10 ++--------
>   drivers/md/raid0.c     | 15 ++++++++++++++-
>   4 files changed, 35 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 1ff51647a682..3c368e3e4641 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
>   		     bio_sector < start_sector))
>   		goto out_of_bounds;
>   
> -	if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
> +	if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
> +		md_error(mddev, tmp_dev->rdev);

[ ... ]

>   
> +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags)) {

s/rdev->mddev/mddev/

> +		char *md_name = mdname(mddev);
> +
> +		pr_crit("md/linear%s: Disk failure on %pg detected.\n"
> +			"md/linear:%s: Cannot continue, failing array.\n",
> +			md_name, rdev->bdev, md_name);

The second md_name is not needed.

> +	}
> +}
> +
>   static void linear_quiesce(struct mddev *mddev, int state)
>   {
>   }
> @@ -297,6 +309,7 @@ static struct md_personality linear_personality =
>   	.hot_add_disk	= linear_add,
>   	.size		= linear_size,
>   	.quiesce	= linear_quiesce,
> +	.error_handler	= linear_error,
>   };
>   
>   static int __init linear_init (void)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e8666bdc0d28..f888ef197765 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   
>   	if (!mddev->pers || !mddev->pers->error_handler)
>   		return;
> -	mddev->pers->error_handler(mddev,rdev);
> +	mddev->pers->error_handler(mddev, rdev);
> +
> +	if (!mddev->pers->sync_request)
> +		return;

The above only valid for raid0 and linear, I guess it is fine if DM 
don't create LV on top
of them. But the new checking deserves some comment above.

> +
>   	if (mddev->degraded)
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	sysfs_notify_dirent_safe(rdev->sysfs_state);

[ ... ]

> +static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
> +{
> +	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags)) {
> +		char *md_name = mdname(mddev);
> +
> +		pr_crit("md/raid0%s: Disk failure on %pg detected.\n"
> +			"md/raid0:%s: Cannot continue, failing array.\n",
> +			md_name, rdev->bdev, md_name);

The comments for linear_error also valid here.

Thanks,
Guoqing
