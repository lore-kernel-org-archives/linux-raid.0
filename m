Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D708C48BDF
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 21:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C4E610A2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 21:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFOVps (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Jun 2021 17:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFOVps (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Jun 2021 17:45:48 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B56C061574
        for <linux-raid@vger.kernel.org>; Tue, 15 Jun 2021 14:43:42 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id a26so114191oie.11
        for <linux-raid@vger.kernel.org>; Tue, 15 Jun 2021 14:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OyQfunXazoXBOXxJVefloBMvC5Js1RvOPuzhQE6Grpc=;
        b=dNI9J7p9nMD7oxWyB8OhTlFQODmeqcFJoEUljGcOjnOvSjehPzcDxx3SaM8uH8RRRZ
         ak6Jq+9bcQKD+HIm+9jQCkPCp/QFU8ERohhtIYT/uyaU7zs7QEldGaFnD9cUr8Gow31r
         g18j5/8UpjHjUUmYWlMCtWBebLulpCcbMrP07ddlyAWDP1elY4UB7CXyer5wxKUmX59l
         N5ZGY+Gf0OWCtLlm6WOwmjzaJSWLXSvKDTJZCchd3Oj/oCTh3uTOlfhskBzkRO01v4Et
         KIF4DKToDRVgWfZ7dKnnYxkb5MhjvLesb4XRgcFsFCIygS3EwbvItE1u7lXg/E3y/B2p
         /KLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OyQfunXazoXBOXxJVefloBMvC5Js1RvOPuzhQE6Grpc=;
        b=YB9KIVG7Z9kxG21dZw5EVxmqUs4MoYhfVFdjZVqnysfdQQ2kU8aGM/7aDpUgcrGkxz
         h6dE1UDuB/feFpFSVR2UQXYfAJ13/Aq5jKxqDp43MDzQ5Y/M9by9FrqDOrrSIbCARqny
         LGKJqy/1/ArHr3jatHbD2wimeRPdKZW6FH8u3dMMPNBzo28zEFX+nzgnveuGCQ890KcO
         PrvgXN2kN83t8PtNHqrLRPDqmsM0sDtw34syjXMxgvaxEBYjFclL090razSmNfi3OySF
         47VdGwf9ql8qIV1KURS7712Kp9pEaVeIr0g02PI4cD4HWCWV64VdFrPqylMwzFv1oFoW
         H4Bg==
X-Gm-Message-State: AOAM531mbKWjAasU2EU5v+x0/XM+ve8exhWu+jrA0IfZg8QtiSJs+9at
        Nbh1cDqVVb1eZPASAjKRn6HXhA==
X-Google-Smtp-Source: ABdhPJynU2tJqJMMPZFkRVOaadAMfu4Y5v72qYNalpg8im31anNNORh816UTQ12Sk1249OYouhE3NA==
X-Received: by 2002:aca:ac02:: with SMTP id v2mr4855398oie.154.1623793421722;
        Tue, 15 Jun 2021 14:43:41 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id l2sm49548otn.32.2021.06.15.14.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:43:41 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20210615
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Gal Ofri <gal.ofri@storing.io>
References: <88538F4F-01D2-4491-82D2-CD242F98AFC3@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <061705be-d9d7-31cc-9082-75e1a4562ba3@kernel.dk>
Date:   Tue, 15 Jun 2021 15:43:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <88538F4F-01D2-4491-82D2-CD242F98AFC3@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/15/21 1:43 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-5.14/drivers branch. The major changes are:
> 
>   1) iostats rewrite by Guoqing Jiang;
>   2) raid5 lock contention optimization by Gal Ofri.

Pulled, thanks.

-- 
Jens Axboe

