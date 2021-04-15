Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4ECC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 18:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ECE7611BF
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 18:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhDOSRZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 14:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbhDOSRY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Apr 2021 14:17:24 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFA7C061574
        for <linux-raid@vger.kernel.org>; Thu, 15 Apr 2021 11:17:01 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id b17so17465163pgh.7
        for <linux-raid@vger.kernel.org>; Thu, 15 Apr 2021 11:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/3+DmIKxLeSo4yjCTTR/U09tXkKHon6upI31qXgiif0=;
        b=StDLpfbaTHShZ3wetAPTn6u9zEUydm+OD3lOfjLZAUY9zfQv6jJ+yFMK3XEEMEqNIQ
         vkjVtwRON/eHfHzc4Gu/wvGJqAvDIKL83j9VmJAB1KdpvuBgULVckVyemjDegvRTVTDw
         m3t/H+x18B9lBg6mu9/HCKN8y6KiDtmHnssACDJU63G8DyZZuXuyJVNjApmUQEf6nTbP
         Q80o3m1yLDULC1N9CSAmNc6ICbwLn3DJntCQdSD9Hz1Y1Ccc6MtycelevbxPhew+U/5u
         6M5OfNzUZPgIB+W0Cyj+x2Oa2rv4Vs+dHQuL+m2ANNqhUKkXpLE/BinQcFb0wZGiWI6O
         dkng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/3+DmIKxLeSo4yjCTTR/U09tXkKHon6upI31qXgiif0=;
        b=k85VuYBLE16Jgcu6uHszfmeH+HICGeEv7MoaVXBGICxCFalfgzDKJXnkhtmi4KnXit
         hPQgQPz0jB3AEiGU1pJMaKFqMRQYXomPJrTvSAAx56Ur/Aa6dglylEdsChWhTeXgXZeJ
         gBEp09JD8QHkgLEPvO4kaN2KMHlirZhmd+IlJsgZmUKdzWtxf8R9ANETts8Rx/9NrU3h
         ikF0q8u+ljhmFBHPOTBun0+ZlEomBnYJIKyC0cFQgjqGF5zxqv3ZM7m1FRMi7lD/Q0jL
         oOxeleViBcRGJyMWZXA0U+MZZR45Syg+iZ0/lNClpFNUucLDVrpBzHJkCGCq2+F5mP+l
         sIDQ==
X-Gm-Message-State: AOAM530kbL5nMCpM+9cfG2oXnVv4lCyj8XyyNRNLKrL0r+aWXyJiZL1Y
        MNgrgGZIFPUGL6QIU3Zf+mPBnw==
X-Google-Smtp-Source: ABdhPJxyfukGxCJNvSp4P6zKOToaJANKr1ZG2Z2tyMOF49BzdIw3kXgcvloz5pRyKTeeKsDQcPO6Ag==
X-Received: by 2002:a62:f90d:0:b029:250:5397:4658 with SMTP id o13-20020a62f90d0000b029025053974658mr4478827pfh.48.1618510620899;
        Thu, 15 Apr 2021 11:17:00 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1638? ([2620:10d:c090:400::5:6df0])
        by smtp.gmail.com with ESMTPSA id b136sm2689094pfb.126.2021.04.15.11.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 11:17:00 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20210415
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
References: <BE74094A-F93B-4989-9C2F-A25E85C4CC97@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d6f5137c-21ad-dc01-d644-d6f27dae9596@kernel.dk>
Date:   Thu, 15 Apr 2021 12:16:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BE74094A-F93B-4989-9C2F-A25E85C4CC97@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/15/21 12:14 PM, Song Liu wrote:
> Hi Jens,
> 
> Please consider pulling the following changes on top of your for-5.13/drivers
> branch. The major changes are
> 
> 1. mddev_find_or_alloc() clean up, from Christoph.
> 2. Fix NULL pointer deref with external bitmap, from Sudhakar.

Pulled, thanks.

-- 
Jens Axboe

