Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58227C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Sep 2021 14:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E15B611CC
	for <linux-raid@archiver.kernel.org>; Fri, 10 Sep 2021 14:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhIJOt1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Sep 2021 10:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbhIJOt0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Sep 2021 10:49:26 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F83C061756
        for <linux-raid@vger.kernel.org>; Fri, 10 Sep 2021 07:48:15 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a15so2644896iot.2
        for <linux-raid@vger.kernel.org>; Fri, 10 Sep 2021 07:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8baKku/7AG9XewMLkmq1NNzE4+nYImNwUkVNnAae6NI=;
        b=y8ADmvj/2zwU/4hG2VWMCCFE+qvtKbYthcnoyiXbXIMnZABI3jaKtX1UVj7Y3NmLQa
         Bb5jOJ6DX489XqM+uSY9IErqtobGJcf4/RjSA00LT1NhINsKJPirLZbgVvG9he68rQUR
         3ju358CYyPwmE0nPr0IkT9hA/638Gin1cYlWeiQ0M4PDajgP1rKRZc655yxdByG9goP8
         Ezm/fHtc2lJEiNS+m/Kqw27iujNl2HH49A9tAV+q4SsoODkmP7TADaQKMGec0XPDrt4j
         X3KOSzPtIPA7y+AlAl9YspgnQkyD3b83++919zu83bwuCq1k9eV4grXh36YYPWfeMSwc
         8crg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8baKku/7AG9XewMLkmq1NNzE4+nYImNwUkVNnAae6NI=;
        b=4v3cj6TCZSRX/bqqS392Stpn1FcUHQtPR+8Vws+EKBX1oRxRfC9w4VNLyNudzeEBiQ
         Gu2GzTvz65wZtjrjzAvVOfzqxcwfmsZdbrzGzgrt1kfjs6ZxeVJRlJd20e3GFSzlLg6F
         vTu9Jp9/0C8KP85+4xCRWVx7YLOBM0Vk4OmG0/TVNq4NK8TMk0kWTsC7bdhVr2vaDGoC
         pOaN9cdPpvPu7GHGUROryIY17IqCTm6Uu27BK7FEGc+ve8A2I4RXnrPX1O2aI3WivcKA
         onU8vXH0Tcbq94rgXQsl7qB3NsDWku9P9UJw5WRBBtpS4ilfQXzJDUOSlQCaZmaYwdDr
         38hA==
X-Gm-Message-State: AOAM5324nPSNk7y7ERv7Fa2/v0K759jE71ILlMvbuMXB7kRVclIsbXlU
        RftTEH2QU1VYWEtJWNKFPGmqdwOBbw5tXQJ++sw=
X-Google-Smtp-Source: ABdhPJy0q89CLNTSLfxvRq0Dhp6wEIyc9srxstylWI9WE7EVXIxAGMJSk2L5pGToeVqWKFTHMciIBg==
X-Received: by 2002:a05:6602:2c05:: with SMTP id w5mr7509271iov.160.1631285294605;
        Fri, 10 Sep 2021 07:48:14 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g23sm2489960ioc.8.2021.09.10.07.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 07:48:14 -0700 (PDT)
Subject: Re: [Non-DoD Source] Re: [PATCH] blk-mq: allow 4x
 BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        Song Liu <songliubraving@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <20210907230338.227903-1-songliubraving@fb.com>
 <f64a938a-372c-aac1-4c5c-4b9456af5a69@kernel.dk>
 <5EAED86C53DED2479E3E145969315A2385876DB8@UMECHPA7B.easf.csd.disa.mil>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <420e6629-62c4-1267-7118-229ecbf3876e@kernel.dk>
Date:   Fri, 10 Sep 2021 08:48:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385876DB8@UMECHPA7B.easf.csd.disa.mil>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/10/21 8:43 AM, Finlayson, James M CIV (USA) wrote:
> All,
> I have a suspicion this will help my efforts increasing the IOPS
> ability of mdraid  in 10-12 NVMe drive  per raid group situations.
> 
> Pure neophyte question, which I apologize for in advance, how can I
> test this?   Does this end up in  a 5.15 release candidate kernel?

It's queued up to go into Linus's tree before -rc1, so should be in
5.15-rc1 for you to test.

> I want to make contributions wherever I can, as I have hardware and
> needs, so I can act as a performance validator within reason.   I know
> I can't make contributions as a developer, but I'm willing to
> contribute in areas where our goals are in alignment and this appears
> to be one.

Testing is definitely valuable, particularly for something like this! So
please do test -rc1 and report back your findings.

-- 
Jens Axboe

