Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254F0C432BE
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 14:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D1B60F91
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 14:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhHZO2M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 10:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhHZO2M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Aug 2021 10:28:12 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0A0C061757
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 07:27:24 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id f6so4067066iox.0
        for <linux-raid@vger.kernel.org>; Thu, 26 Aug 2021 07:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0rttwFoNj3ukgoxDu3FinE4i3YCrjxjwlv5aEFLHPT4=;
        b=EaoPbWK+Dbq0WiqzTuwvhPjS3jLKbsY0KnIB4K9t3MEee4l5cbUSYOPmfIuHEDmx0U
         VxkLiOQ57gJz8Vg7JmTiJg5xZ//MkKp6xKkTJUQDC+emgSbhzTEJPFaK6FzbMq8he3/0
         AFng7fcgtFk+hLwYVdld7u+gZ4wFN7UmIUGETTABQ7nYRtSSie21lub0cC6gDO2GBbCw
         Yvwwp65ZtAcssTsIB/qML4ycDpSJ+HAGE1YafEXes2CxrvqjG3aM8MUpx7KJiGAGHSgq
         UuzJMSwNPrEFenffbr6hOz7VtBzh3wZQOgTousX+BZZbssByClwdhowHp2NnwBj7RhQ1
         nyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0rttwFoNj3ukgoxDu3FinE4i3YCrjxjwlv5aEFLHPT4=;
        b=jftMnXVjI3F4PzW6tXMu0SxNmnRyCBUTWuglemImaaaINUoj4/aejQRIjPlFqFVEBV
         66soM1m8k9urCDrhHPhTa/x8U4hgPu6U/ZlO6zcMlrjSPHtK9oQh2LhhdAX0k0fiOiIJ
         duS8Uih5lEfuj4iBAQ/ei3C8t8qKglLMgqF4jD36EOV0rsIL3x57G1859r1LBPVCpI0e
         cWFc791BrDsN5N+HNP/D5BIveV2j9vPBp0uRSbYKbBkfzqjBxpwG2cC4InNW3Je9NDiN
         Fx9EyLKIQLkW2YvMvS01JZVQQdAqsleFk1np932iKHbRDjJcmOD2BuQsHQ149iu3ED+n
         iSQQ==
X-Gm-Message-State: AOAM531QqSamelAkEjBHL8m8jEkUsbAxPivDU1a+H7z7zD8fao4WKTuA
        3BN2t28ull5JmLqFoHKcnVA8Lw==
X-Google-Smtp-Source: ABdhPJybJJpFzNcFAlPKcMBYaOcyxdED9CF6FZtsDnQbft6FJyxnaKN+PatHvD64fdYyJCL7DrgGHQ==
X-Received: by 2002:a02:a10b:: with SMTP id f11mr3839751jag.16.1629988044036;
        Thu, 26 Aug 2021 07:27:24 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g12sm1683518iok.32.2021.08.26.07.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 07:27:23 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210825
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>
References: <9E359DE1-AFC6-4D46-97C3-C8490D051B6E@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <167d18b5-f3bd-30fe-62b3-dd2b128739fb@kernel.dk>
Date:   Thu, 26 Aug 2021 08:27:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9E359DE1-AFC6-4D46-97C3-C8490D051B6E@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/25/21 7:11 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix for raid10 on top of your
> block-5.14 branch. 

Since 5.14 is days from release and this doesn't look like a super
critical thing that needs fixing (not something that was introduced in
this merge window), let's do it for 5.15 instead

-- 
Jens Axboe

