Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8368DC4338F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 06:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 636A561A3F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 06:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhHPG2b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 02:28:31 -0400
Received: from out0.migadu.com ([94.23.1.103]:25861 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhHPG2b (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Aug 2021 02:28:31 -0400
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629095278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axkEiHAnVD5Wd2kbH1btpwM/jQcyRI29qQamEGMsVqA=;
        b=UhVlWhH8OB9+HrsEMFizsUTdzU15w20HPCbXouscBYmUezSoGtfjf+gvOXs6u9F7BoSP3C
        qQVn7CC2qHpRZuFySNbTgmwlOMTYaHueOhrM0HHvEQ7q4RyCFI36QxVrQHBH0D1HSwQvrJ
        mJXDm3tKvGGc/qiZ8NdlzrGb+5Rjq4U=
To:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        jens@chianterastutte.eu, linux-block@vger.kernel.org
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org> <YReFYrjtWr9MvfBr@T590>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <05bdd906-2e78-bc85-c186-7bffac9076e0@linux.dev>
Date:   Mon, 16 Aug 2021 14:27:48 +0800
MIME-Version: 1.0
In-Reply-To: <YReFYrjtWr9MvfBr@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Ming and Christoph,

On 8/14/21 4:57 PM, Ming Lei wrote:
> On Sat, Aug 14, 2021 at 08:55:21AM +0100, Christoph Hellwig wrote:
>> On Fri, Aug 13, 2021 at 04:38:59PM +0800, Guoqing Jiang wrote:
>>> Ok, thanks.
>>>
>>>> In general the size of a bio only depends on the number of vectors, not
>>>> the total I/O size.  But alloc_behind_master_bio allocates new backing
>>>> pages using order 0 allocations, so in this exceptional case the total
>>>> size oes actually matter.
>>>>
>>>> While we're at it: this huge memory allocation looks really deadlock
>>>> prone.
>>> Hmm, let me think more about it, or could you share your thought? ????
>> Well, you'd need a mempool which can fit the max payload of a bio,
>> that is BIO_MAX_VECS pages.

IIUC, the behind bio is allocated from bio_set (mddev->bio_set) which is 
allocated in md_run by
call bioset_init, so the mempool (bvec_pool) of  this bio_set is created 
by biovec_init_pool which
uses global biovec slabs. Do we really need another mempool? Or, there 
is no potential deadlock
  for this case.

>> FYI, this is what I'd do instead of this patch for now.  We don't really
>> need a vetor per sector, just per page.  So this limits the I/O
>> size a little less.
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 3c44c4bb40fc..5b27d995302e 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1454,6 +1454,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>   		goto retry_write;
>>   	}
>>   
>> +	/*
>> +	 * When using a bitmap, we may call alloc_behind_master_bio below.
>> +	 * alloc_behind_master_bio allocates a copy of the data payload a page
>> +	 * at a time and thus needs a new bio that can fit the whole payload
>> +	 * this bio in page sized chunks.
>> +	 */

Thanks for the above, will copy it accordingly. I will check if 
WriteMostly is set before, then check both
the flag and bitmap.

>> +	if (bitmap)
>> +		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SIZE);
> s/PAGE_SIZE/PAGE_SECTORS

Agree.

>> +
>>   	if (max_sectors < bio_sectors(bio)) {
>>   		struct bio *split = bio_split(bio, max_sectors,
>>   					      GFP_NOIO, &conf->bio_split);
> Here the limit is max single-page vectors, and the above way may not work,
> such as:ust splitted and not
>
> 0 ~ 254: each bvec's length is 512
> 255: bvec's length is 8192
>
> the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
> still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().

Thanks for deeper looking! I guess it is because how vcnt is calculated.

> One solution is to add queue limit of max_single_page_bvec, and let
> blk_queue_split() handle it.

The path (blk_queue_split -> blk_bio_segment_split -> bvec_split_segs) 
which respects max_segments
of limit. Do you mean introduce max_single_page_bvec to limit? Then 
perform similar checking as for
  max_segment.

Thanks,
Guoqing
