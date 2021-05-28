Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803D2C4708C
	for <linux-raid@archiver.kernel.org>; Fri, 28 May 2021 09:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 628C2613B6
	for <linux-raid@archiver.kernel.org>; Fri, 28 May 2021 09:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhE1JWc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 May 2021 05:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbhE1JWb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 May 2021 05:22:31 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85CCC061760
        for <linux-raid@vger.kernel.org>; Fri, 28 May 2021 02:20:53 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p39so2772931pfw.8
        for <linux-raid@vger.kernel.org>; Fri, 28 May 2021 02:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=GEnAd40hx9wXFJ4T9RvTll6ZU+ig6IZ72jOkRmJF61o=;
        b=NPuKslfWsLrB9i2smzFpRwgEV5YVilnyySXDTLp+LiRmcDle3qv/PdyDiQPEUXIO70
         9OEYVS3wS3Mvjo6xzUE/ayBfcZih6WWKSL3taHACDEey1K0DuhtQVOc5G5An1oI67hgp
         pgpZhnfCJnF0fUqoN30JXC/Awonu+Z/FJdbzMzOkUGUdUsdNa8QIU87zZYUkhsERaXsz
         rY9KXFjQDcCz1UZt/Yaxe2dlz8h8LRlBB1cJK8gHQcuQ3g3UL6TIRTEhkp0sYogkf1XC
         LfhjHZhbwedgbeEe8MrgDb9w++vXIIdcSGYP1gx9aWZ5X44FYMd4t6bPE73SOYGM9Nm4
         yq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GEnAd40hx9wXFJ4T9RvTll6ZU+ig6IZ72jOkRmJF61o=;
        b=ZHw2ZwMgjmRTy//9YrCzswpt8XcBxJQX8HrO3m1HMPEJD7BFfBvJjkugR84QG4bJIm
         p9A4dyCHuGqnPZSK7vStpSeuupPNp+0IC2CZvk+50lGUHgGfsUvSmEjUp6dA5H0Ek7MX
         TG32QQHWcOt45htTN6c2AWOJuIB426806gAWMG27QBLm945Ak6ATlvrapjk6zRWlsEh0
         ktDEYGN3RU9ZMxT2EW2yhELPk8SSTAm6fMQeWKeCM4KcrptXCIEQ30hzOFJgCloKYSlO
         TOpRZFPYqjrRF68yn82F9yLqfUbD8cNm23WoLui2wmsqLbosavYucQIjpMeZR7JFCGWg
         jnLw==
X-Gm-Message-State: AOAM533+Wouuw25YA58PolW7UWcADw4O/oWQCcM3A4r+HdNSZo2KD1Gt
        JNte0tBrOBEHFhFyOD+fpUw/HIasMuVwPQ==
X-Google-Smtp-Source: ABdhPJxyDdg9CpJpbKvcrVdXSvZVy90OtmdI4JbKKOCfGvp9zJWLNFZi3sEUBVLKF5wYirckkZUavw==
X-Received: by 2002:a63:5252:: with SMTP id s18mr8054343pgl.229.1622193653440;
        Fri, 28 May 2021 02:20:53 -0700 (PDT)
Received: from [10.6.2.165] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id s6sm3922465pjr.29.2021.05.28.02.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 02:20:53 -0700 (PDT)
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
To:     Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210525094623.763195-3-jiangguoqing@kylinos.cn>
 <YK+56xtF7VoZexoa@infradead.org>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <1e491df0-4dff-f4b1-9d9d-e3c9c90dac74@gmail.com>
Date:   Fri, 28 May 2021 17:20:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YK+56xtF7VoZexoa@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/27/21 11:25 PM, Christoph Hellwig wrote:

>   
>   	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
> -	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
> +	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
> +	    bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE)) {
> Don't we need to create this new only for raid0 and raid5?
> Shouldn't they call helpers to create it?

Good catch, will add a check for level.

>> @@ -5864,6 +5866,12 @@ int md_run(struct mddev *mddev)
>>   		if (err)
>>   			return err;
>>   	}
>> +	if (!bioset_initialized(&mddev->io_acct_set)) {
>> +		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
>> +				  offsetof(struct md_io_acct, bio_clone), 0);
>> +		if (err)
>> +			return err;
>> +	}
> Can someone explain why we are having these bioset_initialized checks
> here (also for the existing one)?  This just smells like very sloppy
> life time rules.

My understanding is that md_run is not only called when array is
created/assembled, for example, it can also be called in md_ioctl,
which means you can't call bioset_init unconditionally. Others may
have better explanation.

BTW, besides md, dm is another user of bioset_initialized.

>> +/* used by personalities (raid0 and raid5) to account io stats */
> Instead of mentioning the personalities this migt better explain
> something like ".. by personalities that don't already clone the
> bio and thus can't easily add the timestamp to their extended bio
> structure"

Ok, thanks for rephrasing.

>> +void md_account_bio(struct mddev *mddev, struct bio **bio)
>> +{
>> +	struct md_io_acct *md_io_acct;
>> +	struct bio *clone;
>> +
>> +	if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
>> +		return;
>> +
>> +	clone = bio_clone_fast(*bio, GFP_NOIO, &mddev->io_acct_set);
>> +	md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
>> +	md_io_acct->orig_bio = *bio;
>> +	md_io_acct->start_time = bio_start_io_acct(*bio);
>> +
>> +	clone->bi_end_io = md_end_io_acct;
>> +	clone->bi_private = md_io_acct;
>> +	*bio = clone;
> I would find a calling conventions that returns the allocated clone
> (or the original bio if there is no accounting) more logical.

Not sure if I follow, do you want the function return "struct bio *"
instead of "void"? I don't think there is fundamental difference
with current behavior.

>> +	struct bio_set			io_acct_set; /* for raid0 and raid5 io accounting */
> crazy long line.

At lease it aligns with above line and checkpatch doesn't complain
either.

Thanks,
Guoqing
