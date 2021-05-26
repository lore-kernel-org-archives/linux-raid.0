Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AE2C47088
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 14:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61293613B4
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 14:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhEZOtr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 May 2021 10:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbhEZOtq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 May 2021 10:49:46 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E252C06175F
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 07:48:14 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id d25so1280042ioe.1
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 07:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9i4c6oMtpEvTMMjhgvEQ+8auwY/AesJ1YjN5Tm87qA4=;
        b=CAwBxU6RWvSV3oXyJ8Pp5Bp+nIzaNYgTYH0jua2CQxsOc56LDC+vRmWRTp4wcNdbu1
         1sW33Qs9llKTC2vpUvSrbn79wkyBUQMpvqzk/H6DkdM568Fd+sKz19naTp1AeMifJzxD
         cyTuAHQgrqrgnrwgz/K4624/P9YtPcmK0Sl/NdDQiLLL59o8DE+S/SnUUNNNdGh4+6u0
         TQ6nwckl5XQF6ti9koCg4gDoA4t9w/M2VoNAkXocHWWy3fA3Md2FmJidm56CFWlWsVAN
         qNsHYmy6+uDqj3qT3MHAz0jbbx0uPeIx66kMhAdFIe+Fs3VcS+2IFQVMUhjV2KLizJA9
         h6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9i4c6oMtpEvTMMjhgvEQ+8auwY/AesJ1YjN5Tm87qA4=;
        b=oJ5TeyZQlI26gkq8KkE1ZNEce6zaiMh2O9iAMjPJOUOpc2fnORqgKC/Pp2jvrlEQZf
         9GztEjYiw5KzRwdH8AJaZ0USy+ZgmMiMrH2FWrmhGCRb5n5BjyS9ltVukngbodj5Jm+Z
         y/87cLvaHf4OqPSoMoczRkTcFwkT1FI2qzISYqtwcCV+HQqy6rhzXMCHu05IX49dkj2b
         QZZXrNXm+ldbd3rWDxznM0eh4CH/qBxVFFWxzP8ic9A6wuVvw6bwy9rLdPOiLHCh+5gK
         f4pjQeYj4Y209CqLxSfhG7Eqk5dqe6lpNDvAFATRP+XwEcMKBv02E7Kcr0N3mCfCV/rF
         RTeA==
X-Gm-Message-State: AOAM531eSiBE2OkSJglPNqpoyP1rBco6tstoZ0blCnRi2axjv9dHS8Ah
        gy+opoq+t7YVnrtn0ycNMcKS5D+a+he5vBz+
X-Google-Smtp-Source: ABdhPJzoRNSeNyfIr/dLVOmCo0wm4aPZKK5LO85KlwqR5rnoUMKEzml8F7L4JpFSMaXnmjAWBHv8Bw==
X-Received: by 2002:a6b:156:: with SMTP id 83mr24056857iob.22.1622040493242;
        Wed, 26 May 2021 07:48:13 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a6sm14917640ili.21.2021.05.26.07.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 07:48:12 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210525
To:     Song Liu <songliubraving@fb.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <589AFEE4-EB54-4313-AECF-89208C1DCD63@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <117fa5ed-2a4d-a632-cbc9-d3ec9a2cd982@kernel.dk>
Date:   Wed, 26 May 2021 08:48:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <589AFEE4-EB54-4313-AECF-89208C1DCD63@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/25/21 11:08 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-5.13 branch.
> The fix removes a bad WARN_ON_ONCE(). 

Pulled, thanks.

-- 
Jens Axboe

