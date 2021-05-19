Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F56AC433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F7476135F
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhESBmP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 21:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhESBmO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 21:42:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC03C06175F
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:40:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso2592729pjp.5
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=9fhuv892KcNCnM77Amo7PQ2GBd6IfgCa7xpPNMmEH8g=;
        b=mAQe8PgFUynuO2cUpJkzS5IUsxM1sBzfiKCSLm2v6k36QTTeom85hrRzt9TGrRzdy3
         73fZUxg27TNYYVMMvtMF7Ny5hJB/oIKAkJg7NyFrI+cSdBKRsIU6VDpjvg5sXo15t2ud
         /LB9xgpYD4ccjtZTvfkW5wvfHWpKfJdZnfHRykOBuRR79DOOwvqRj9LMeDcZ+ITew4QU
         IAW2Z+i2iQGB2z1sUWTt3tMyl8aOydgpPht5wQC4uAbj93w2ddSscV1zoIlTGnpc41ym
         8mtz4ooXHUKSGMhffnFJO8uIx9Fzi/ckT3CDGKPgfCQ4Phu4a4aD3d9D7vy6zg7MTwIy
         2FkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9fhuv892KcNCnM77Amo7PQ2GBd6IfgCa7xpPNMmEH8g=;
        b=KzLdERAMSvAvHViWWFUZmdK7tKea1yDNFc9rTZXLeXqmuMJYUiHLeGIbyIg86IeLUu
         lN7WMKob350KflhwTgyfD5P/vfzMuqPwn2qCbki8IGir/SpKxziFXCh9pdnYu7EayPRD
         sNCr+CLKRXtSsFk9ZyYb2m2bxnq8ug9rxEJy4NVtBtU5Vlo+eSRbwtffTtbo7W+QStiE
         r9bhUvDieydwHCc8rVRPE1VqXJ4REo2GLyCjwcU3+3+XeYwP7dOyV/zpl+L2ST8jm0l1
         CKPLQdr9tiPBlTuJObpHMhHfsv+rrPpbbxqgz6aNxHguWXtvB8QjwtOSqg9EkoGTX90P
         OAwQ==
X-Gm-Message-State: AOAM532zM4UssKcOf9fN2ZLJ1eJOHnpOOH/AOMUbAlDpDr6VNsn5g5BF
        02aV/+HjyxPJcFNy4Q+HF7SbfyET5Ps=
X-Google-Smtp-Source: ABdhPJyZPOz82hgRMybf81eDUG/XlIUqjTJ+L7y21vhdUIK5PzTjeuuDjuFfj/XQ3iheF2VvMlUTQg==
X-Received: by 2002:a17:902:bc81:b029:ef:3f99:9f76 with SMTP id bb1-20020a170902bc81b02900ef3f999f76mr7950027plb.33.1621388455830;
        Tue, 18 May 2021 18:40:55 -0700 (PDT)
Received: from [10.6.3.223] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id o10sm13865683pjl.2.2021.05.18.18.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 18:40:55 -0700 (PDT)
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
To:     Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn>
 <YKPCpwHbr/E9q31g@infradead.org>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <d4bf06f8-6cc7-882e-17d0-754f1981eaa8@gmail.com>
Date:   Wed, 19 May 2021 09:40:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YKPCpwHbr/E9q31g@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/18/21 9:35 PM, Christoph Hellwig wrote:
>> +	struct bio orig_bio_clone;
> Maybe call this bio_clone?  or just bio?

Ok, will rename it.

>> +static void md_end_io(struct bio *bio)
>> +{
>> +	struct md_io *md_io = bio->bi_private;
>> +	struct bio *orig_bio = md_io->orig_bio;
>> +
>> +	orig_bio->bi_status = bio->bi_status;
>> +
>> +	bio_end_io_acct_remapped(orig_bio, md_io->start_time, orig_bio->bi_bdev);
> Overly long line.  And trivially fixed by just using bio_end_io_acct.

Thanks for reminder.

>> +	/*
>> +	 * We don't clone bio for multipath, raid1 and raid10 since we can reuse
>> +	 * their clone infrastructure.
>> +	 */
>> +	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue) &&
>> +	    (bio->bi_pool != &mddev->md_io_bs) &&
>> +	    (mddev->level != 1) && (mddev->level != 10) &&
>> +	    (mddev->level != LEVEL_MULTIPATH)) {
> This should use a flag in struct md_personality instead.

Yes.

>> -	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
>> +	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
>> +	    bioset_integrity_create(&mddev->md_io_bs, BIO_POOL_SIZE)) {
> If the md_io_bs creation fails bio_set needs to be cleaned up.

Good catch, and seems we need to call bioset_exit(&mddev->bio_set) as well.

Thanks,
Guoqing
