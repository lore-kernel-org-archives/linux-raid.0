Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A2FC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 16:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB35D611C9
	for <linux-raid@archiver.kernel.org>; Wed, 22 Sep 2021 16:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhIVQPs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbhIVQPr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Sep 2021 12:15:47 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA860C061574
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 09:14:17 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e82so3957705iof.5
        for <linux-raid@vger.kernel.org>; Wed, 22 Sep 2021 09:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C2ZH8VDUkdsDIgu4eEVQOiTcj6TZ+qDtzY04HOGNPLI=;
        b=DRTsBM/bJMWPm40l5RNXJabNm5Z287IInevnjrLx1wer5WS8PB+SzseApMbytsQYKA
         HQ0EllA6tDaR/66dk6D0Qu5Ub718EAu2jlz2gf354oxlWP2PN7GahFkPjARYvkJQkjhq
         l0peZXrRanJ1a1iW7dmEjvjeyHieC9J+qMxw+aU8hE8IboQjniAqmo0uDOKqLPGY+haa
         MM+eIfOu4Adtig8X/AhMa8wW52aJeHCsUgTHM1NLIn8k8jR3fzL7sAs3dybDnb+DKNJq
         PSPrDLxcU5DHVxGsEktvTsK2RjcgEvI94du6Cx8gZoG6MNzR4M9qh2qkqS5jcSTznMp7
         /4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C2ZH8VDUkdsDIgu4eEVQOiTcj6TZ+qDtzY04HOGNPLI=;
        b=AnXxMrCw1f9A7PMbcLGmcwdMG3hg0LLvavALbZeJZDxxRzKwhWIMs0V63maYYfcWpM
         MDWWlwsfD4xG0cjiB5MDvYlxsd5bZZ1PmzMZjXtoD+MS+KJ5RGE4kdR6t7+hlnhXpaHy
         Suo7ydDy0gD8nS3aUJYvOyZc6xRW13HRQeobYGl/iFngzP1c/xwSth6nbrkVM5IInThf
         ugWGPXWuqz5OyQsS9q2ariC8WJBHGdOPnkS9pi3I9wdG9o6UXSLcLNinhrhpCrUckN7R
         UlddLyI5OIFjRAOwqtvrzeITBk/JW71PlIFgcOq0UZmd0oJkqLNdDwNhzd6d3lFPBU6c
         UZ+w==
X-Gm-Message-State: AOAM532LqD5w2ggspN79/3i3hb6sNgzVQxUwTII/ns438M/hr5Q3Qubj
        qitSE74SvtyMvpCnnmDacC8koHVUVQokAvl3wI0=
X-Google-Smtp-Source: ABdhPJxBnU/E/7/VrumwIpn2EhX476zE2ch/DVMu/xs763+IA5TXIEe/DLE0gRYKVfGokA5cIoHsoQ==
X-Received: by 2002:a05:6602:55:: with SMTP id z21mr331044ioz.205.1632327257015;
        Wed, 22 Sep 2021 09:14:17 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s6sm1160981iow.1.2021.09.22.09.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 09:14:16 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20210922
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>
References: <A739EDD6-BF73-458E-B674-D426564E13C0@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7f6f82a2-0f10-3648-e6ae-4a66e1e50bbb@kernel.dk>
Date:   Wed, 22 Sep 2021 10:14:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <A739EDD6-BF73-458E-B674-D426564E13C0@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/22/21 10:10 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-fixes on top of your 
> block-5.15 branch. The changes are:
>   1. Fix lock order reversal in md_alloc. (Christoph)
>   2. Handle add_disk error in md_alloc. (Luis)
>   3. Refactor md sysfs attrs, included because of dependency with 1 and 2. 
>      (Christoph). 

I don't think the error handling for add_disk is prudent at this point,
that's something that should go in with the 5.16 cycle. It's been like
that forever, nothing that warrants pushing this for 5.15 at all.


-- 
Jens Axboe

