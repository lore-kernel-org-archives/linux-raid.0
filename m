Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B514C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 20 Aug 2021 08:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73BDD6108B
	for <linux-raid@archiver.kernel.org>; Fri, 20 Aug 2021 08:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhHTIUK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Aug 2021 04:20:10 -0400
Received: from out2.migadu.com ([188.165.223.204]:64044 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231921AbhHTIUJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 20 Aug 2021 04:20:09 -0400
Subject: Re: [PATCH V2] raid1: ensure write behind bio has less than
 BIO_MAX_VECS sectors
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629447569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yf4anWdazhvxt/TXRJ1WvOf6zp5A8gyIfbQCtNpJqYQ=;
        b=GzP1H+J6Hb8eWp9ovFKBaupicgllZce804PBiD/x55yQVmFuvYZED34vW9yGu33Ll/1WY6
        POMwfFsXThuLPOy2HzZxHvCNu02x00x9CKYJVKUXm6pkwDV1rkcddY+AzU42ZVZmkJUH4F
        9GlqeioMwl+z/W/lz4O4l/RnfWFN3tY=
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <20210818073738.1271033-1-guoqing.jiang@linux.dev>
 <YR4ckyTCiOXCRnue@infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <207ca922-4223-632b-ed68-4e78e40ac3dc@linux.dev>
Date:   Fri, 20 Aug 2021 16:19:22 +0800
MIME-Version: 1.0
In-Reply-To: <YR4ckyTCiOXCRnue@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 8/19/21 4:55 PM, Christoph Hellwig wrote:
> On Wed, Aug 18, 2021 at 03:37:38PM +0800, Guoqing Jiang wrote:
>>   	for (i = 0;  i < disks; i++) {
>>   		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
>> +
>> +		if (test_bit(WriteMostly, &mirror->rdev->flags))
>> +			write_behind = true;
> How does this condition relate to the ones used for actually calling
> alloc_behind_master_bio?  It looks related, but as someone not familiar
> with the code I can't really verify if this is correct, so a comment
> explaining it might be useful.

How about this?

+               /*
+                * The write-behind io is only attempted on drives marked as
+                * write-mostly, which means we will allocate write behind
+                * bio later.
+                */
                 if (test_bit(WriteMostly, &mirror->rdev->flags))
                         write_behind = true;

>> +	/*
>> +	 * When using a bitmap, we may call alloc_behind_master_bio below.
>> +	 * alloc_behind_master_bio allocates a copy of the data payload a page
>> +	 * at a time and thus needs a new bio that can fit the whole payload
>> +	 * this bio in page sized chunks.
>> +	 */
>> +	if (write_behind && bitmap)
>> +		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SECTORS);
> Overly long line here.

I can change it given you still prefer the  limitation is 80 characters.

Thanks,
Guoqing
