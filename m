Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B61C433E6
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 15:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226E464DFF
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 15:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhBHPgw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Feb 2021 10:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhBHPee (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Feb 2021 10:34:34 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4BDC06178A
        for <linux-raid@vger.kernel.org>; Mon,  8 Feb 2021 07:33:38 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id y15so13079094ilj.11
        for <linux-raid@vger.kernel.org>; Mon, 08 Feb 2021 07:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0H5gUc/Wq6b2vAxOqVg+YwgeGcV8rQ3iyVtvXXPrGes=;
        b=Y6lY/bRb0ctKLz7Pk1mEpg1pP9v8g2PnaaDUei58i2sVYDXeMZET0RsIdjFbB8lwRK
         q4bYTdi2YSKLDHJ3KDxP+uQZjPyI9SfkFFqrG2VVb/GhngL6tyHhxerjCEe+jU8ABxqa
         hn9VrbdYDF1ag0zj8z3vxr1Ft9gmzeTRemo40kDZvmwnhqB72/y/2pG9eoUxVe4VFMr2
         c9xlNyyZv/6YGxiO42OwK4HcJamhR3+C9d9/xL2PL7DeKS1QrIX/PKNMCJN0g7JOrtP5
         evzintbZTcwQbwRNvhVAbijnzXMMA+PFW/l+UAfl41MxG0HmkUTgGFfYznJ80Kfwff2a
         3j7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0H5gUc/Wq6b2vAxOqVg+YwgeGcV8rQ3iyVtvXXPrGes=;
        b=Np9jyUsoGekWzVUQSbUFxrSrcdIZVWacbh8jW5EMu0M/T6VekFODdP1ZvSMSonAC9V
         +TAWcCKQaZzhTGm3KMv6dWtTFBhJBi6NTukkQZ6UrRzgjQ8UWyCO+tqSilG45wlVmaFN
         APpmfm+bIoVbhLAviDlLdmFc1o9zlRulgeTRovYgMm7HTxs8i9ZAQ6APiL9N9salRt0R
         yFftJe3iDnbNKBOQBiXjCwB7mK+COgPNP6RxvCrgJ0acVR7qMBPqdOHPIFqF/6M8VyVo
         rFPaOYZwcXKEDZCAHsdTfvGESW3VvkfviYPMwjmNFHxU0yZ210mngJ4HMKyAEpaxwX+6
         bjBg==
X-Gm-Message-State: AOAM530T4KDLE4x0H8V9TNeC6RGWEpSdLPySA1sfQPueF6gS0ybQcrwu
        g+SVkEzbZZEb+in572Vo8czyaQOxD7tPwXR1
X-Google-Smtp-Source: ABdhPJzoFS2b5GM3tLGwIOj7IgKU4wrrx/0D0PqKLe5KSDaxqBaYUVNxBMK5FNK3AjTl4yo7Knqq0w==
X-Received: by 2002:a92:444e:: with SMTP id a14mr15790169ilm.215.1612798417195;
        Mon, 08 Feb 2021 07:33:37 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f15sm8968817ilj.23.2021.02.08.07.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:33:36 -0800 (PST)
Subject: Re: cleanup bvec allocation
To:     Christoph Hellwig <hch@lst.de>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
References: <20210202171929.1504939-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c77fd1d7-25b1-af1c-04ec-959ffb1b509c@kernel.dk>
Date:   Mon, 8 Feb 2021 08:33:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/2/21 10:19 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> This series cleans up various lose ends in the bvec allocator.

Applied, thanks.

-- 
Jens Axboe

