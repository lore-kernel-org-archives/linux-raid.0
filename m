Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BC4C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 14 Nov 2022 19:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiKNT6e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Nov 2022 14:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiKNT6c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Nov 2022 14:58:32 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEDF2AC7
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 11:58:30 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id p141so9044758iod.6
        for <linux-raid@vger.kernel.org>; Mon, 14 Nov 2022 11:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRgBY2Cbtw55aVDyEbE1QNe1Q/HavagJWufrHMAvsc8=;
        b=kvdj2vp4RuYEVNAOJr8aqRg7k7Es4WEm8oZCBI43RZpDVlGP8V+gAJ8wyMaEq22X9H
         hMSsUAxX7I1IhZiNOExS++ut5YJOQfVUyllJy9sybiixwKU0+e7J/LuXJBnQ+PGVYlSm
         J8kfPYOGr6Rhw6PxytZfJ375ryfoY+pUzVtYySaDFV/skh3mqg335l3gzz0cfRL80Nv5
         zRlHwW7JuNFFg5C867ZRMflx/ss3T6eEn6ymKrbgBjsnuGue1MQHlnnsJZoO1phYhRB8
         mmxZ1mE142haQ3gu8l7ZbB5zZpyYbv7B5pc2jQuR7aGXNMKQHX4tUz9A4Yg4dKC4a071
         JSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XRgBY2Cbtw55aVDyEbE1QNe1Q/HavagJWufrHMAvsc8=;
        b=KM8GnkqPm6E1dxq1lKSwjHJcxsXisvH1AS08uko/pU7DY3RbsF8rE6kVsK9fmtwpV7
         JW7x/+oEV51zq/xDU7tXqXpS0rW76YZsG5u6WG3UPvTUgRw4Dx/z4BsmzmSJloG1dMR/
         HrgrOn6xK8BFZHAA0bctboEEVNBDV4r3Z5/hzz2W9vl/kdNtpTgUr/gYRM+JIGsetQmW
         /Bicw1q+W+FpEUS6c9hzc68rIgTbM3wstkt8dV1b5ieTuHtccaxfnaqQKpfhcDHM0EvP
         20F8a47KRxCBDjXanEpH2yBITgzVyvQWawRZbqycHttCzdybaV1r/3uGUARhMyLzNlLI
         YpGw==
X-Gm-Message-State: ANoB5pmI7ZzUpfDt9SYUA5/rAmUlzCEPkyp06xuqWe4CZcrtYEEqV70S
        n3fAV+OsSce/NJDcuTAlM90U0A==
X-Google-Smtp-Source: AA0mqf45usDLIZ8xjiyD8QB2PVAnbkIaJaYvFET1mC3cJ66EYYNRIP3AFWV0kKYWYRLNJgzGls1fQA==
X-Received: by 2002:a5d:9cc4:0:b0:6de:383e:414f with SMTP id w4-20020a5d9cc4000000b006de383e414fmr288460iow.47.1668455909989;
        Mon, 14 Nov 2022 11:58:29 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t18-20020a02b192000000b00363c4307bb2sm3548083jah.79.2022.11.14.11.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 11:58:29 -0800 (PST)
Message-ID: <0a98944a-d39f-4bea-4b57-5aa7469c5375@kernel.dk>
Date:   Mon, 14 Nov 2022 12:58:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [GIT PULL] md-next 20221114
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jiang Li <jiang.li@ugreen.com>, Xiao Ni <xni@redhat.com>,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>, Ye Bin <yebin10@huawei.com>,
        Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Li Zhong <floridsleeves@gmail.com>
References: <09491954-333F-400F-A277-A37BE9DC9F45@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <09491954-333F-400F-A277-A37BE9DC9F45@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/14/22 11:22 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your 
> for-6.2/block branch. 
> 
> These changes are fixes for corner cases and code refactoring. 
> 
> Thanks,
> Song 
> 
> 
> 
> The following changes since commit 4f8126bb2308066b877859e4b5923ffb54143630:
> 
>   sbitmap: Use single per-bitmap counting to wake up queued tags (2022-11-11 08:38:29 -0700)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

Pulled, thanks.

-- 
Jens Axboe


