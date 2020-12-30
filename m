Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E41C433E6
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 17:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3286922242
	for <linux-raid@archiver.kernel.org>; Wed, 30 Dec 2020 17:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgL3RHN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Dec 2020 12:07:13 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:34210 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgL3RHH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Dec 2020 12:07:07 -0500
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id DAE0325CE0;
        Wed, 30 Dec 2020 12:06:25 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 57317A6ACF; Wed, 30 Dec 2020 12:06:25 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24556.45969.276771.345181@quad.stoffel.home>
Date:   Wed, 30 Dec 2020 12:06:25 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Danny Shih <dannyshih@synology.com>
Cc:     John Stoffel <john@stoffel.org>, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/4] block: introduce submit_bio_noacct_add_head
In-Reply-To: <abac671f-91f2-ca4e-7f77-8bb5da85a4cc@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
        <1609233522-25837-2-git-send-email-dannyshih@synology.com>
        <24555.49943.411197.147225@quad.stoffel.home>
        <abac671f-91f2-ca4e-7f77-8bb5da85a4cc@synology.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Danny" == Danny Shih <dannyshih@synology.com> writes:

Danny> Hi, John,
Danny> Thank you for taking the time to write a review.


Danny> John Stoffel <john@stoffel.org> writes:
>>>>>>> "dannyshih" == dannyshih  <dannyshih@synology.com> writes:
dannyshih> From: Danny Shih <dannyshih@synology.com>
dannyshih> Porvide a way for stacking block device to re-submit the bio
dannyshih> which sholud be handled firstly.
>> 
>> You're spelling needs to be fixed in these messages.


Danny> Sorry for so many spelling errors.

Danny> The message should be

Danny> "Provide a way for stacking block device to re-submit

Danny> the bio which should be handled first."

Danny> I will fix it.

Great, though my second question is *why* it needs to be handled
first?  What is the difference between stacked and un-stacked devices
and how could it be done in a way that doesn't require a seperate
function like this?




dannyshih> Signed-off-by: Danny Shih <dannyshih@synology.com>
dannyshih> Reviewed-by: Allen Peng <allenpeng@synology.com>
dannyshih> Reviewed-by: Alex Wu <alexwu@synology.com>
dannyshih> ---
dannyshih> block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++-----------
dannyshih> include/linux/blkdev.h |  1 +
dannyshih> 2 files changed, 34 insertions(+), 11 deletions(-)
>> 
dannyshih> diff --git a/block/blk-core.c b/block/blk-core.c
dannyshih> index 96e5fcd..693dc83 100644
dannyshih> --- a/block/blk-core.c
dannyshih> +++ b/block/blk-core.c
dannyshih> @@ -1031,16 +1031,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
dannyshih> return ret;
dannyshih> }
>> 
dannyshih> -/**
dannyshih> - * submit_bio_noacct - re-submit a bio to the block device layer for I/O
dannyshih> - * @bio:  The bio describing the location in memory and on the device.
dannyshih> - *
dannyshih> - * This is a version of submit_bio() that shall only be used for I/O that is
dannyshih> - * resubmitted to lower level drivers by stacking block drivers.  All file
dannyshih> - * systems and other upper level users of the block layer should use
dannyshih> - * submit_bio() instead.
dannyshih> - */
dannyshih> -blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih> +static blk_qc_t do_submit_bio_noacct(struct bio *bio, bool add_head)
dannyshih> {
dannyshih> if (!submit_bio_checks(bio))
dannyshih> return BLK_QC_T_NONE;
dannyshih> @@ -1052,7 +1043,10 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih> * it is active, and then process them after it returned.
dannyshih> */
dannyshih> if (current->bio_list) {
dannyshih> -		bio_list_add(&current->bio_list[0], bio);
dannyshih> +		if (add_head)
dannyshih> +			bio_list_add_head(&current->bio_list[0], bio);
dannyshih> +		else
dannyshih> +			bio_list_add(&current->bio_list[0], bio);
dannyshih> return BLK_QC_T_NONE;
dannyshih> }
>> 
dannyshih> @@ -1060,9 +1054,37 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih> return __submit_bio_noacct_mq(bio);
dannyshih> return __submit_bio_noacct(bio);
dannyshih> }
dannyshih> +
dannyshih> +/**
dannyshih> + * submit_bio_noacct - re-submit a bio to the block device layer for I/O
dannyshih> + * @bio:  The bio describing the location in memory and on the device.
dannyshih> + *
dannyshih> + * This is a version of submit_bio() that shall only be used for I/O that is
dannyshih> + * resubmitted to lower level drivers by stacking block drivers.  All file
dannyshih> + * systems and other upper level users of the block layer should use
dannyshih> + * submit_bio() instead.
dannyshih> + */
dannyshih> +blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih> +{
dannyshih> +	return do_submit_bio_noacct(bio, false);
dannyshih> +}
dannyshih> EXPORT_SYMBOL(submit_bio_noacct);
>> 
>> So why is it named "submit_bio_noacct" when it's supposed to be only
>> used by layers submitting to lower level drivers.  How can this be
>> figured out by drivers automatically, so the writed doesn't have to
>> know about this?


Danny> There is no logical change while using submit_bio_noacct() after my 
Danny> patch. So I didn't change

Danny> the name and the documentation of submit_bio_noacct().


>> 
dannyshih> /**
dannyshih> + * submit_bio_noacct - re-submit a bio, which needs to be handle firstly,
dannyshih> + *                     to the block device layer for I/O
dannyshih> + * @bio:  The bio describing the location in memory and on the device.
dannyshih> + *
dannyshih> + * alternative submit_bio_noacct() which add bio to the head of
dannyshih> + * current->bio_list.
dannyshih> + */
>> 
>> Firstly isn't proper english.  Maybe something like:
>> 
>> submit_bio_noacct - re-submit a bio which needs to be handled first
>> because <reasons> to the block device layer for I/O
>> 
>> But the name still sucks, and the *reason* the bio needs to be handled
>> differently isn't well explained.


Danny> Sorry for the grammar mistake. And I wrote the wrong function name here.

Danny> It should be replaced by submit_bio_noacct_add_head.


Danny> About the function name, the name of submit_bio_noacct_add_head()

Danny> is trying to let drivers know that this is just an alternative version of

Danny> submit_bio_noacct(). The only difference is that this function adds bio to

Danny> the head of current->bio_list, and submit_bio_noacct() adds it to the tail.


Danny> About the documentation, what if I change it like:


Danny> "submit_bio_noacct_add_head - re-submit a bio which needs to

Danny> be handled first to the block device layer for I/O, because it has

Danny> sequential relevance with the bio handling in current ->submit_bio.


Danny> Alternative submit_bio_noacct() adds bio to the head of

current-> bio_list. To keep bio sequence, this function is used

Danny> when a block device splits bio and re-submits the remainder back

Danny> to itself. This makes sure that the re-submitted bio will be handle

Danny> just after the split part of the original bio."


Danny> Thanks for your suggestion.


dannyshih> +blk_qc_t submit_bio_noacct_add_head(struct bio *bio)
dannyshih> +{
dannyshih> +	return do_submit_bio_noacct(bio, true);
dannyshih> +}
dannyshih> +EXPORT_SYMBOL(submit_bio_noacct_add_head);
dannyshih> +
dannyshih> +/**
dannyshih> * submit_bio - submit a bio to the block device layer for I/O
dannyshih> * @bio: The &struct bio which describes the I/O
dannyshih> *
dannyshih> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
dannyshih> index 070de09..b0080d0 100644
dannyshih> --- a/include/linux/blkdev.h
dannyshih> +++ b/include/linux/blkdev.h
dannyshih> @@ -905,6 +905,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
dannyshih> extern int blk_register_queue(struct gendisk *disk);
dannyshih> extern void blk_unregister_queue(struct gendisk *disk);
dannyshih> blk_qc_t submit_bio_noacct(struct bio *bio);
dannyshih> +blk_qc_t submit_bio_noacct_add_head(struct bio *bio);
dannyshih> extern void blk_rq_init(struct request_queue *q, struct request *rq);
dannyshih> extern void blk_put_request(struct request *);
dannyshih> extern struct request *blk_get_request(struct request_queue *, unsigned int op,
dannyshih> --
dannyshih> 2.7.4

Danny> Best Regards,

Danny> Danny Shih


