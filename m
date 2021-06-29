Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8337C11F66
	for <linux-raid@archiver.kernel.org>; Tue, 29 Jun 2021 07:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2E5361DD2
	for <linux-raid@archiver.kernel.org>; Tue, 29 Jun 2021 07:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhF2H1F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Jun 2021 03:27:05 -0400
Received: from mailgw.kylinos.cn ([123.150.8.42]:48548 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232227AbhF2H1F (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Jun 2021 03:27:05 -0400
X-UUID: 05e6fcdca00641389e3384d0df8a4371-20210629
X-UUID: 05e6fcdca00641389e3384d0df8a4371-20210629
X-User: jiangguoqing@kylinos.cn
Received: from [172.30.60.82] [(106.37.198.34)] by nksmu.kylinos.cn
        (envelope-from <jiangguoqing@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 385053192; Tue, 29 Jun 2021 15:23:44 +0800
Subject: Re: [PATCH v2][RESEND] md/raid10: properly indicate failure when
 ending a failed write request
To:     wsy@dogben.com, linux-raid@vger.kernel.org
Cc:     song@kernel.org, jgq516@gmail.com, paul.clements@us.sios.com,
        yuyufen@huawei.com
References: <E1lxlU5-002GZB-TY@dogben.com>
From:   Guoqing Jiang <jiangguoqing@kylinos.cn>
Message-ID: <2398043c-8503-3a52-b995-6acce0d68917@kylinos.cn>
Date:   Tue, 29 Jun 2021 15:24:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <E1lxlU5-002GZB-TY@dogben.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/28/21 3:15 PM, wsy@dogben.com wrote:
> Similar to commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd, this patch
> fixes the same bug in raid10. Also cleanup the comments.
>
> Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
> Signed-off-by: Wei Shuyu <wsy@dogben.com>
> ---
>   drivers/md/raid1.c  | 2 --
>   drivers/md/raid10.c | 4 ++--
>   2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ced076ba560e..753822ca9613 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -472,8 +472,6 @@ static void raid1_end_write_request(struct bio *bio)
>   		/*
>   		 * When the device is faulty, it is not necessary to
>   		 * handle write error.
> -		 * For failfast, this is the only remaining device,
> -		 * We need to retry the write without FailFast.
>   		 */
>   		if (!test_bit(Faulty, &rdev->flags))
>   			set_bit(R1BIO_WriteError, &r1_bio->state);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 13f5e6b2a73d..40e845fb9717 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -469,12 +469,12 @@ static void raid10_end_write_request(struct bio *bio)
>   			/*
>   			 * When the device is faulty, it is not necessary to
>   			 * handle write error.
> -			 * For failfast, this is the only remaining device,
> -			 * We need to retry the write without FailFast.
>   			 */
>   			if (!test_bit(Faulty, &rdev->flags))
>   				set_bit(R10BIO_WriteError, &r10_bio->state);
>   			else {
> +				/* Fail the request */
> +				set_bit(R10BIO_Degraded, &r10_bio->state);
>   				r10_bio->devs[slot].bio = NULL;
>   				to_put = bio;
>   				dec_rdev = 1;

Acked-by: Guoqing Jiang <jiangguoqing@kylinos.cn>

Thanks,
Guoqing
