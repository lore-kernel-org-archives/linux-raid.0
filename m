Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AB7C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 10 Mar 2022 23:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344516AbiCJXFx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Mar 2022 18:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiCJXFx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Mar 2022 18:05:53 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35A713C240
        for <linux-raid@vger.kernel.org>; Thu, 10 Mar 2022 15:04:51 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so3279730pjb.3
        for <linux-raid@vger.kernel.org>; Thu, 10 Mar 2022 15:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aNv7HvFkg/UVzY5CpW+51gcwm/tSTicoot8l+5ODEIk=;
        b=ylO7rYSWOVfkb0YMfUzF+jsHS+OGS1IOIkgO37JvgCS1A23mMYvTtBNH3arASbjKn2
         cCok1EOcYGvt/p6wTRg9audnhVL8zsebxj5iW9aFkA7of0IXlPVKTd1CP2VXHO3XSExu
         z3OHgIsGbQMUvV0nxeMFnn6X091UZ6bb0+zj59oOZX/Z/YCHxR8MnxTLC04Mhc3+Luxb
         GiHdqbWPCaKmX/bwC/oFgmpPs2X/x23BLwKX7ViY3a0iFH9fOS9sKiAGcADBvWwJluaQ
         OL0WONTcp4KBFXzeZdf02/Eddq6n9ovwzsGDeNSs9FneCDjvweM3RRXsAX7fpKnaV+bF
         S3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aNv7HvFkg/UVzY5CpW+51gcwm/tSTicoot8l+5ODEIk=;
        b=nzdqtdVHgVr/nBrFq1jrLG72ys3hG79zyxz8f0/SCXhM5WKFPO3x15O5t+8CBH86/B
         EfDPIeUAz8lLPcfy9suaiMLQ0WW3Q223F+9wzrC/siLVZZ5YoI3flSEd7M+cgsWnersU
         YMQlmQuXHSn3FjMogiQCAl7sqzosfsPksmIfMcM17cOrJsDlO8HKOg7fMlVh9zS++zpn
         EbXO9vZyveQf1mLZ95b8X+9Kt/ac9aOg6FTDWs7B3RkQQiOqn5L+dOtFrYzZm+L+qu9m
         +JHFovn3mmKdyfj8tZd1tBX/YJB4n/z6tyTjo6vpfm2InW5kFQ8MBz6TU0BaOuUjJfIJ
         vmug==
X-Gm-Message-State: AOAM531kEAM0k1gS05lWCXMLvZ4km3DlKBysWExQls4i45inVY/vekZ2
        DIMhuV9lqnyhRl6X9S9Q07o37Y5Kgx6JCs+H
X-Google-Smtp-Source: ABdhPJxQ+RyumRjWEA6N8t08BD3pUDAJuPL3jtPZKuhmR5bWi8RtlFxNrEJFBTwstQKVEnQ4qoi5Pw==
X-Received: by 2002:a17:90b:4595:b0:1be:db22:8327 with SMTP id hd21-20020a17090b459500b001bedb228327mr18617675pjb.99.1646953491121;
        Thu, 10 Mar 2022 15:04:51 -0800 (PST)
Received: from ?IPV6:2600:380:7676:ce7b:11ac:aee8:fe09:2807? ([2600:380:7676:ce7b:11ac:aee8:fe09:2807])
        by smtp.gmail.com with ESMTPSA id f7-20020a056a0022c700b004e11d3d0459sm8503584pfj.65.2022.03.10.15.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 15:04:50 -0800 (PST)
Message-ID: <19254e98-8629-6ff0-6eec-d81d0b1488d5@kernel.dk>
Date:   Thu, 10 Mar 2022 16:04:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [GIT PULL] md-next 20220310
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>
References: <0F4A0065-2209-40F3-A375-5660B5055FA5@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0F4A0065-2209-40F3-A375-5660B5055FA5@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/10/22 3:41 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-5.18/drivers branch. This set contains raid5 bio handling cleanups
> for raid5. 

Pulled, thanks.

-- 
Jens Axboe

