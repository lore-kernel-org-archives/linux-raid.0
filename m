Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B43C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 09:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5A7021919
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 09:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgL3JwN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Dec 2020 04:52:13 -0500
Received: from mail.synology.com ([211.23.38.101]:44132 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgL3JwM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Dec 2020 04:52:12 -0500
Received: from [10.17.32.105] (unknown [10.17.32.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 0D98FCE781AC;
        Wed, 30 Dec 2020 17:51:30 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1609321890; bh=vNptn2H0DY5msg+Jmf9MApzufS1tfR+Wzw6M03URVDM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=WaS1fCmXW3GABEjBHDDZAvXpas8qYUjxGtskKY6dRbl+xyzakmZQR72vXDBpQJgSt
         tFgNWYSw6R19+JRbIhFpvvy6ZQ+0tfdqflpGWSPYtwJ1TSiQD9Cn/qIgCHSD2rPlKI
         +oXlFM53Ec3IFunX1eiCSpuGXSv/3xZ6/qBMvAHI=
Subject: Re: [PATCH 1/4] block: introduce submit_bio_noacct_add_head
To:     John Stoffel <john@stoffel.org>
Cc:     axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
        dm-devel@redhat.com, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
 <1609233522-25837-2-git-send-email-dannyshih@synology.com>
 <24555.49943.411197.147225@quad.stoffel.home>
From:   Danny Shih <dannyshih@synology.com>
Message-ID: <abac671f-91f2-ca4e-7f77-8bb5da85a4cc@synology.com>
Date:   Wed, 30 Dec 2020 17:51:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <24555.49943.411197.147225@quad.stoffel.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, John,

Thank you for taking the time to write a review.


John Stoffel <john@stoffel.org> writes:
>>>>>> "dannyshih" == dannyshih  <dannyshih@synology.com> writes:
> dannyshih> From: Danny Shih <dannyshih@synology.com>
> dannyshih> Porvide a way for stacking block device to re-submit the bio
> dannyshih> which sholud be handled firstly.
>
> You're spelling needs to be fixed in these messages.


Sorry for so many spelling errors.

The message should be

"Provide a way for stacking block device to re-submit

the bio which should be handled first."

I will fix it.


> dannyshih> Signed-off-by: Danny Shih <dannyshih@synology.com>
> dannyshih> Reviewed-by: Allen Peng <allenpeng@synology.com>
> dannyshih> Reviewed-by: Alex Wu <alexwu@synology.com>
> dannyshih> ---
> dannyshih>  block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++-----------
> dannyshih>  include/linux/blkdev.h |  1 +
> dannyshih>  2 files changed, 34 insertions(+), 11 deletions(-)
>
> dannyshih> diff --git a/block/blk-core.c b/block/blk-core.c
> dannyshih> index 96e5fcd..693dc83 100644
> dannyshih> --- a/block/blk-core.c
> dannyshih> +++ b/block/blk-core.c
> dannyshih> @@ -1031,16 +1031,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
> dannyshih>  	return ret;
> dannyshih>  }
>   
> dannyshih> -/**
> dannyshih> - * submit_bio_noacct - re-submit a bio to the block device layer for I/O
> dannyshih> - * @bio:  The bio describing the location in memory and on the device.
> dannyshih> - *
> dannyshih> - * This is a version of submit_bio() that shall only be used for I/O that is
> dannyshih> - * resubmitted to lower level drivers by stacking block drivers.  All file
> dannyshih> - * systems and other upper level users of the block layer should use
> dannyshih> - * submit_bio() instead.
> dannyshih> - */
> dannyshih> -blk_qc_t submit_bio_noacct(struct bio *bio)
> dannyshih> +static blk_qc_t do_submit_bio_noacct(struct bio *bio, bool add_head)
> dannyshih>  {
> dannyshih>  	if (!submit_bio_checks(bio))
> dannyshih>  		return BLK_QC_T_NONE;
> dannyshih> @@ -1052,7 +1043,10 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
> dannyshih>  	 * it is active, and then process them after it returned.
> dannyshih>  	 */
> dannyshih>  	if (current->bio_list) {
> dannyshih> -		bio_list_add(&current->bio_list[0], bio);
> dannyshih> +		if (add_head)
> dannyshih> +			bio_list_add_head(&current->bio_list[0], bio);
> dannyshih> +		else
> dannyshih> +			bio_list_add(&current->bio_list[0], bio);
> dannyshih>  		return BLK_QC_T_NONE;
> dannyshih>  	}
>   
> dannyshih> @@ -1060,9 +1054,37 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
> dannyshih>  		return __submit_bio_noacct_mq(bio);
> dannyshih>  	return __submit_bio_noacct(bio);
> dannyshih>  }
> dannyshih> +
> dannyshih> +/**
> dannyshih> + * submit_bio_noacct - re-submit a bio to the block device layer for I/O
> dannyshih> + * @bio:  The bio describing the location in memory and on the device.
> dannyshih> + *
> dannyshih> + * This is a version of submit_bio() that shall only be used for I/O that is
> dannyshih> + * resubmitted to lower level drivers by stacking block drivers.  All file
> dannyshih> + * systems and other upper level users of the block layer should use
> dannyshih> + * submit_bio() instead.
> dannyshih> + */
> dannyshih> +blk_qc_t submit_bio_noacct(struct bio *bio)
> dannyshih> +{
> dannyshih> +	return do_submit_bio_noacct(bio, false);
> dannyshih> +}
> dannyshih>  EXPORT_SYMBOL(submit_bio_noacct);
>
> So why is it named "submit_bio_noacct" when it's supposed to be only
> used by layers submitting to lower level drivers.  How can this be
> figured out by drivers automatically, so the writed doesn't have to
> know about this?


There is no logical change while using submit_bio_noacct() after my 
patch. So I didn't change

the name and the documentation of submit_bio_noacct().


>   
> dannyshih>  /**
> dannyshih> + * submit_bio_noacct - re-submit a bio, which needs to be handle firstly,
> dannyshih> + *                     to the block device layer for I/O
> dannyshih> + * @bio:  The bio describing the location in memory and on the device.
> dannyshih> + *
> dannyshih> + * alternative submit_bio_noacct() which add bio to the head of
> dannyshih> + * current->bio_list.
> dannyshih> + */
>
> Firstly isn't proper english.  Maybe something like:
>
> submit_bio_noacct - re-submit a bio which needs to be handled first
> because <reasons> to the block device layer for I/O
>
> But the name still sucks, and the *reason* the bio needs to be handled
> differently isn't well explained.


Sorry for the grammar mistake. And I wrote the wrong function name here.

It should be replaced by submit_bio_noacct_add_head.


About the function name, the name of submit_bio_noacct_add_head()

is trying to let drivers know that this is just an alternative version of

submit_bio_noacct(). The only difference is that this function adds bio to

the head of current->bio_list, and submit_bio_noacct() adds it to the tail.


About the documentation, what if I change it like:


"submit_bio_noacct_add_head - re-submit a bio which needs to

be handled first to the block device layer for I/O, because it has

sequential relevance with the bio handling in current ->submit_bio.


Alternative submit_bio_noacct() adds bio to the head of

current->bio_list. To keep bio sequence, this function is used

when a block device splits bio and re-submits the remainder back

to itself. This makes sure that the re-submitted bio will be handle

just after the split part of the original bio."


Thanks for your suggestion.


> dannyshih> +blk_qc_t submit_bio_noacct_add_head(struct bio *bio)
> dannyshih> +{
> dannyshih> +	return do_submit_bio_noacct(bio, true);
> dannyshih> +}
> dannyshih> +EXPORT_SYMBOL(submit_bio_noacct_add_head);
> dannyshih> +
> dannyshih> +/**
> dannyshih>   * submit_bio - submit a bio to the block device layer for I/O
> dannyshih>   * @bio: The &struct bio which describes the I/O
> dannyshih>   *
> dannyshih> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> dannyshih> index 070de09..b0080d0 100644
> dannyshih> --- a/include/linux/blkdev.h
> dannyshih> +++ b/include/linux/blkdev.h
> dannyshih> @@ -905,6 +905,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
> dannyshih>  extern int blk_register_queue(struct gendisk *disk);
> dannyshih>  extern void blk_unregister_queue(struct gendisk *disk);
> dannyshih>  blk_qc_t submit_bio_noacct(struct bio *bio);
> dannyshih> +blk_qc_t submit_bio_noacct_add_head(struct bio *bio);
> dannyshih>  extern void blk_rq_init(struct request_queue *q, struct request *rq);
> dannyshih>  extern void blk_put_request(struct request *);
> dannyshih>  extern struct request *blk_get_request(struct request_queue *, unsigned int op,
> dannyshih> --
> dannyshih> 2.7.4

Best Regards,

Danny Shih


