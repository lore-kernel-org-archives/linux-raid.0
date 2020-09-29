Return-Path: <SRS0=Kwls=DG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22240C2D0A8
	for <linux-raid@archiver.kernel.org>; Tue, 29 Sep 2020 01:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEBFD207C4
	for <linux-raid@archiver.kernel.org>; Tue, 29 Sep 2020 01:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgI2BDa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Sep 2020 21:03:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbgI2BD2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 28 Sep 2020 21:03:28 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D8E2FBA48425B18F6922;
        Tue, 29 Sep 2020 09:03:22 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 09:03:13 +0800
Subject: Re: [PATCH] raid5: refactor raid5 personality definition
To:     <song@kernel.org>, <yuyufen@huawei.com>,
        <linux-raid@vger.kernel.org>
References: <20200921063825.3501577-1-yanaijie@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <96d8e516-511d-c2d4-4c93-ce2b9c38b226@huawei.com>
Date:   Tue, 29 Sep 2020 09:03:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200921063825.3501577-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.92]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all, any comments?

ÔÚ 2020/9/21 14:38, Jason Yan Ð´µÀ:
> The definition of md personality for raid4/raid5/raid6 is almost the same.
> So introduce a macro 'RAID5_PERSONALITY_ATTR' to help define the
> personality. This can help us reduce some duplicated code.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/md/raid5.c | 104 ++++++++++++++-------------------------------
>   1 file changed, 31 insertions(+), 73 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 225380efd1e2..b56ebc45fb53 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8492,79 +8492,37 @@ static int raid5_start(struct mddev *mddev)
>   	return r5l_start(conf->log);
>   }
>   
> -static struct md_personality raid6_personality =
> -{
> -	.name		= "raid6",
> -	.level		= 6,
> -	.owner		= THIS_MODULE,
> -	.make_request	= raid5_make_request,
> -	.run		= raid5_run,
> -	.start		= raid5_start,
> -	.free		= raid5_free,
> -	.status		= raid5_status,
> -	.error_handler	= raid5_error,
> -	.hot_add_disk	= raid5_add_disk,
> -	.hot_remove_disk= raid5_remove_disk,
> -	.spare_active	= raid5_spare_active,
> -	.sync_request	= raid5_sync_request,
> -	.resize		= raid5_resize,
> -	.size		= raid5_size,
> -	.check_reshape	= raid6_check_reshape,
> -	.start_reshape  = raid5_start_reshape,
> -	.finish_reshape = raid5_finish_reshape,
> -	.quiesce	= raid5_quiesce,
> -	.takeover	= raid6_takeover,
> -	.change_consistency_policy = raid5_change_consistency_policy,
> -};
> -static struct md_personality raid5_personality =
> -{
> -	.name		= "raid5",
> -	.level		= 5,
> -	.owner		= THIS_MODULE,
> -	.make_request	= raid5_make_request,
> -	.run		= raid5_run,
> -	.start		= raid5_start,
> -	.free		= raid5_free,
> -	.status		= raid5_status,
> -	.error_handler	= raid5_error,
> -	.hot_add_disk	= raid5_add_disk,
> -	.hot_remove_disk= raid5_remove_disk,
> -	.spare_active	= raid5_spare_active,
> -	.sync_request	= raid5_sync_request,
> -	.resize		= raid5_resize,
> -	.size		= raid5_size,
> -	.check_reshape	= raid5_check_reshape,
> -	.start_reshape  = raid5_start_reshape,
> -	.finish_reshape = raid5_finish_reshape,
> -	.quiesce	= raid5_quiesce,
> -	.takeover	= raid5_takeover,
> -	.change_consistency_policy = raid5_change_consistency_policy,
> -};
> -
> -static struct md_personality raid4_personality =
> -{
> -	.name		= "raid4",
> -	.level		= 4,
> -	.owner		= THIS_MODULE,
> -	.make_request	= raid5_make_request,
> -	.run		= raid5_run,
> -	.start		= raid5_start,
> -	.free		= raid5_free,
> -	.status		= raid5_status,
> -	.error_handler	= raid5_error,
> -	.hot_add_disk	= raid5_add_disk,
> -	.hot_remove_disk= raid5_remove_disk,
> -	.spare_active	= raid5_spare_active,
> -	.sync_request	= raid5_sync_request,
> -	.resize		= raid5_resize,
> -	.size		= raid5_size,
> -	.check_reshape	= raid5_check_reshape,
> -	.start_reshape  = raid5_start_reshape,
> -	.finish_reshape = raid5_finish_reshape,
> -	.quiesce	= raid5_quiesce,
> -	.takeover	= raid4_takeover,
> -	.change_consistency_policy = raid5_change_consistency_policy,
> -};
> +#define RAID5_PERSONALITY_ATTR(__name, __level)			\
> +static struct md_personality __name##_personality =		\
> +{								\
> +	.name		= #__name,				\
> +	.level		= __level,				\
> +	.owner		= THIS_MODULE,				\
> +	.make_request	= raid5_make_request,			\
> +	.run		= raid5_run,				\
> +	.start		= raid5_start,				\
> +	.free		= raid5_free,				\
> +	.status		= raid5_status,				\
> +	.error_handler	= raid5_error,				\
> +	.hot_add_disk	= raid5_add_disk,			\
> +	.hot_remove_disk= raid5_remove_disk,			\
> +	.spare_active	= raid5_spare_active,			\
> +	.sync_request	= raid5_sync_request,			\
> +	.resize		= raid5_resize,				\
> +	.size		= raid5_size,				\
> +	.start_reshape  = raid5_start_reshape,			\
> +	.finish_reshape = raid5_finish_reshape,			\
> +	.quiesce	= raid5_quiesce,			\
> +	.change_consistency_policy = raid5_change_consistency_policy,	\
> +	.check_reshape	= __name##_check_reshape,		\
> +	.takeover	= __name##_takeover,			\
> +}
> +
> +#define raid4_check_reshape raid5_check_reshape
> +
> +RAID5_PERSONALITY_ATTR(raid4, 4);
> +RAID5_PERSONALITY_ATTR(raid5, 5);
> +RAID5_PERSONALITY_ATTR(raid6, 6);
>   
>   static int __init raid5_init(void)
>   {
> 
