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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD4DC433B4
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 07:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABF376138C
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 07:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhEUHpE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 May 2021 03:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbhEUHpD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 May 2021 03:45:03 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22469C061574
        for <linux-raid@vger.kernel.org>; Fri, 21 May 2021 00:43:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v13so10504370ple.9
        for <linux-raid@vger.kernel.org>; Fri, 21 May 2021 00:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Hakh17wK/7u75U1FziPAjEDsAHmNncRpaYmVg8TLkMY=;
        b=sknnp5rvQRS1dxJivZ0PLg/VB/NbK90SkXHCo9L7AcCcM8y9Y3lKQgnEoXfpngW0xH
         pC0Rhlwwe1vaaHvxHl6htITVjpnrmmiDWA6cnRjDSj6aCCnvU8pUFTB8PPD7R0ukK43h
         4ZHrQj71WxLve/uYdWxUWxeuFhs89YUMyzA8UgTnBBvHNaKNGPVc3hERo6TbOfFJOgBb
         D9DOMkdR+83ttGjqjTPzj0eYTaoMVuivfyoYHXsG7V1WAW2cx2eHQSEBM8tBJ0TOf2De
         gO0Znqw4H0q2cGfckWjPhJV+n0b3nqDf4AD2HLpBzqE9OqNBUKnBFqx6xaXFMq/Iaq2P
         8mPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Hakh17wK/7u75U1FziPAjEDsAHmNncRpaYmVg8TLkMY=;
        b=aqUH8T56Dsj78Vdt3wtjW+ULunOUmoKJo/aAiEeXc1JQyHlT06+bt/ritvafPW6z+o
         hlhAySPh68E0YK2fbSS1CPHs5XVpmMSQNUPdWZF0Gj0YIFbMMFUV+JwYrpk9/kPrgOuA
         hG4NuzmgaEhsrHH1gQNVXZ+VfpRHYkn4GCLv0Cu+PKpYWaec/3/CzqN248EfnZDT4W/N
         nU5VAFJS5JfKQpnk4tpJFLRTa9SFVmKpCEN4/GYdqEYNSA1wMdmIsSGYx4R0s+4HTRbD
         5r8FMFr6s2JKv2AVjLRlxbhMNAMe8sRVTuf9RtWo3X8+F2Ow/QAh1nE+RbtEIG3Jo1MR
         RLLg==
X-Gm-Message-State: AOAM533zW7GcFrFs41Umf9ImVw6tJ+jacB6To7IDs7KMU1mdVQJkpVyF
        uLMg6at/A7rFhOA3XDM2iQwlth0McSpSjLOL
X-Google-Smtp-Source: ABdhPJxd7ebAWB/X1f0TDGvpprz00OaoI37/aaZZgqpwrvXdEBJh1McOn29jOJZzECJjgLOThT86rQ==
X-Received: by 2002:a17:90a:c38c:: with SMTP id h12mr9856825pjt.145.1621583020409;
        Fri, 21 May 2021 00:43:40 -0700 (PDT)
Received: from [10.6.3.47] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id q10sm7618163pjv.24.2021.05.21.00.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 00:43:40 -0700 (PDT)
Subject: Re: [PATCH V2 3/7] md: the latest try for improve io stats accounting
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
 <20210521005521.713106-4-jiangguoqing@kylinos.cn>
 <83d02180-27ee-f8c2-7a41-f9b587324536@intel.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <de1ca79c-a099-33bf-930f-5a194071422b@gmail.com>
Date:   Fri, 21 May 2021 15:43:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <83d02180-27ee-f8c2-7a41-f9b587324536@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/21/21 3:32 PM, Artur Paszkiewicz wrote:
>> @@ -2340,9 +2383,12 @@ int md_integrity_register(struct mddev *mddev)
>>                               bdev_get_integrity(reference->bdev));
>>   
>>        pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
>> -     if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
>> +     if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
>> +         bioset_integrity_create(&mddev->md_io_bs, BIO_POOL_SIZE)) {
>>                pr_err("md: failed to create integrity pool for %s\n",
>>                       mdname(mddev));
>> +             bioset_exit(&mddev->bio_set);
>> +             bioset_exit(&mddev->md_io_bs);
>>                return -EINVAL;
> Are you sure bioset_exit() here is correct? This is always called from
> pers->run() and the cleanup in case of error is handled in md_run().

You are right! Maybe it deserves additional comment given it is
not obvious. Will drop it.

Thanks,
Guoqing
