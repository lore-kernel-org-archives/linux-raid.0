Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E36C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 087246135F
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhESBsu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 21:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhESBsu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 21:48:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9595DC06175F
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:47:31 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id k19so8784113pfu.5
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=QDLDg/lV1zsZSvkv+SEbNkMxoSKffxc23ckSfA4VOLk=;
        b=Rr6f7coWDyl3Jx7WfUNcK0Z8w9IV34X7OYGaerELqrhd/q5t5e9lRKSHvj0VEEfO9K
         cObTImG3WOnOD/Ux3fNtapKo2avvoM1SkEbCvwbPoVdcWpL3Y4yUDm+CreUzFEoZr5j1
         EOVNmpttBTs1kmNeouXuW1Bw6W1jXRSZZNY374T2Ip9wdNLnZ5uTW1MaOwZ0kdfkIZz0
         58yt6A48lrnxIxKx0kDKK0+lgOW5vZ85jyBQKZVXG9VI86HqqAtl2FFiROudNq54eTlO
         zPE7AUur2eOK0uEDztsEH5x71ynRes207g5rX6LJYDMHM+lnLxVeg9WvZ5mb+6E3LWPP
         8HDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=QDLDg/lV1zsZSvkv+SEbNkMxoSKffxc23ckSfA4VOLk=;
        b=gOLppAadaxYRrBltGh3b/XL/GxlEjvD/eAOR42TUlo52ifPutCh3PxTFO3d4/nGzdW
         zYO3r0rwSmYUZlPUERYC7s4BAaqGxH4RQWifYd322UyZfKkJsyzLm4gihtv7H+soYUB1
         i8puxeya/+goL1qxHl0Cqcrd4jcnIqySqdCn+B1UsYu9suTDz4grId2IasX14IQgBJVI
         2fjrutY5CFBYQY9jv674fYEM2MMtTdS7ThIe3PbQgbFMVsxG5nhdMs/bb5q9eHP5CgJF
         91WH6YObadNTZo9rOMJl1v/CiMgnpygud/2/c/iefHp6c1LtdVAFrj+Swn3SqCFdoDi1
         3ryw==
X-Gm-Message-State: AOAM530Rzc5rdokOB+7qgr5tKU5qp/6DPOsfL3BjHQ6WwWACTPK6ab8x
        916157TTQ8AbM8IKHEG2vEM=
X-Google-Smtp-Source: ABdhPJy3QbpRuEsSOJTDypcEp+zvTYAMmrarEBlPibZ8ES/02jgKwQRyLTT7+X4nMP/jCfds9Uohkw==
X-Received: by 2002:a62:1cc9:0:b029:28e:e318:976b with SMTP id c192-20020a621cc90000b029028ee318976bmr8047305pfc.8.1621388851182;
        Tue, 18 May 2021 18:47:31 -0700 (PDT)
Received: from [10.6.3.223] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id f2sm5422483pgl.67.2021.05.18.18.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 18:47:30 -0700 (PDT)
Subject: Re: [PATCH 4/5] md/raid1: enable io accounting
To:     Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-5-jiangguoqing@kylinos.cn>
 <YKPD4IxoGecsvQyv@infradead.org>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <1b18eae2-944e-2779-96b8-8081ffd707a7@gmail.com>
Date:   Wed, 19 May 2021 09:47:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YKPD4IxoGecsvQyv@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/18/21 9:40 PM, Christoph Hellwig wrote:
> On Tue, May 18, 2021 at 01:32:24PM +0800, Guoqing Jiang wrote:
>> For raid1, we record the start time between split bio and clone bio,
>> and finish the accounting in the final endio.
>>
>> Also introduce start_time in r1bio accordingly.
>>
>> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
>> ---
>>   drivers/md/raid1.c | 11 +++++++++++
>>   drivers/md/raid1.h |  1 +
>>   2 files changed, 12 insertions(+)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index ced076ba560e..b08a47523dbb 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -300,6 +300,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
>>   	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>>   		bio->bi_status = BLK_STS_IOERR;
>>   
>> +	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
>> +		bio_end_io_acct_remapped(bio, r1_bio->start_time, bio->bi_bdev);
> This can use bio_end_io_acct.

Sure.

>> +	/*
>> +	 * Reuse print_msg, if it is false then a fresh r1_bio is just
>> +	 * allocated before.
>> +	 */
>> +	if (!print_msg && blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
>> +		r1_bio->start_time = bio_start_io_acct(bio);
>> +
> Please rename the print_msg vaiable to something sensible and drop the
> comment.

Ok.

Thanks,
Guoqing
