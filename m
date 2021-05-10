Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDA2C433ED
	for <linux-raid@archiver.kernel.org>; Mon, 10 May 2021 07:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38E661352
	for <linux-raid@archiver.kernel.org>; Mon, 10 May 2021 07:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEJHsG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 May 2021 03:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhEJHsG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 May 2021 03:48:06 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C046C061573;
        Mon, 10 May 2021 00:47:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s22so12683780pgk.6;
        Mon, 10 May 2021 00:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=glCsIRw/Boons0Drf4KT3lVP96p3GKEkMeEC68Os5U4=;
        b=JsUTKXdE/g3skwdL7LnCl6EiqpJKtNKwaFPoh4b/D4pBElPi3flYVX2Aa1IPDbsAgr
         xRr2cu1NxyhgsVdbwYZXLLhPgqqTeVIxR76kfTiDVbKPwrA5TwBAVo+BucGkjLvCXRLp
         uG00XoR4f4Wn2Cu0WFVWjt0vhnDVs/DVqZMbBZVzR9ZPdMOEGjCGhT22KQmJrwOaqBEj
         orjPAxcD+fb0osn9Kg18ioZNfgGf5yVlb+OLa/gOtbqYVK8pduU9AsvBXLrFHPIzSMYm
         Ho55/2iGpmz57BGnJ9FMH4fjsT8Rbz8JAm3U/Rq92iuXM58rD5CEESqcSxt4BSIbAbl7
         MRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=glCsIRw/Boons0Drf4KT3lVP96p3GKEkMeEC68Os5U4=;
        b=IsqP5yh6Pfe1nTKbfQmAjzTycm31nU1bt19mwWxVk767KeAt+1qMnpFbyLcyD23CCK
         B1hKswnxH1pskViCI8Dyfo7+J66HTKxWUB1WANaPHg6rEbZ1hfBaEgiG7YTiL4krqegp
         yV1on7a9t8mmxeZvcxbUNaQvLgSmih9oa9vRVtSXQ0LJD+f8A7xSEegcFXRPxnQOixV7
         rWJHJUH/X/wz0fkBo4krCv8Y7UlIanDzFLR9oDS+UI9aJEe6KJ8GPH4IJ9hEPW5EitCp
         AgiRVBasO7NlwHN+selyKhRzCXc59T8VdB9Tv7lkKumpVzyNHK3eFY75F2bqhDshtkvN
         pAiw==
X-Gm-Message-State: AOAM533M/Z/3XuqxzomdoekNNUG4dLBNoiLD36zq4qyVpoVh0tpW/SS1
        jQlEfoFnV2co7twWiLDqmzQ=
X-Google-Smtp-Source: ABdhPJwXkEq9UHxzOZKAJccYp3cqzTrBUDw/iLvqAcsS6fSYPwdXlBaPQwoOKFtRiRCOum9O+38NvQ==
X-Received: by 2002:a05:6a00:c3:b029:28e:d284:c39f with SMTP id e3-20020a056a0000c3b029028ed284c39fmr24021937pfj.4.1620632821556;
        Mon, 10 May 2021 00:47:01 -0700 (PDT)
Received: from [10.6.3.44] ([89.187.161.160])
        by smtp.gmail.com with ESMTPSA id h10sm10397932pfk.210.2021.05.10.00.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 00:47:01 -0700 (PDT)
Subject: Re: [PATCH] md: don't account io stat for split bio
To:     Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, pawel.wiejacha@rtbhouse.com,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
References: <20210508034815.123565-1-jgq516@gmail.com>
 <YJjL6AQ+mMgzmIqM@infradead.org>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
Date:   Mon, 10 May 2021 15:46:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YJjL6AQ+mMgzmIqM@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/10/21 2:00 PM, Christoph Hellwig wrote:
> On Sat, May 08, 2021 at 11:48:15AM +0800, Guoqing Jiang wrote:
>> It looks like stack overflow happened for split bio, to fix this,
>> let's keep split bio untouched in md_submit_bio.
>>
>> As a side effect, we need to export bio_chain_endio.
> Err, no.  The right answer is to not change ->bi_end_io of bios that
> you do not own instead of using a horrible hack to skip accounting for
> bios that have no more or less reason to be accounted than others bios.

Thanks for the reply. I suppose that md needs to revert current
implementation of accounting io stats, then re-implement it.

Song and Artur, what are your opinion?

Thanks,
Guoqing
