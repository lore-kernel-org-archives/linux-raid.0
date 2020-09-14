Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B60C433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 14:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01177206C9
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 14:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sAGbwpaE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgINOdo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 10:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgINOdA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Sep 2020 10:33:00 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31818C06174A
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2020 07:33:00 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id w16so113805oia.2
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2020 07:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NYjXacxZihZcxRY7fJVy9eyXwklmaDGqEXUKY/87nQc=;
        b=sAGbwpaEM5INsoB78EVdqrhaSdOBoG/OBhOyQqa6ITJ7uFRWStoWTU2NqWj3gnDrvk
         ojPxDeKIUqnU8W8krLF0u7w2A8aHtlbKG91rwa1OncbJiI0qS+apRyhUWCeDnBXVFSn1
         hUbcnWT8jKKdp2wtexxFE++PbwoAjOHVVrtXyNOZe82AZnn+68o8qTZqknyeOZw5uxBK
         1oON2+C+wrk+Fb6ocs3K2SDuqRxy9hovmUmsiKV6Gm236kNq/rZ1HnCfzWkPglDQmBrY
         +gLc9Tu6mFUhPQtknlHiRhV6DQt65DWc6EMA6K2+UyinCtBYanXBR5qc7LSCP4t7wLgJ
         LOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NYjXacxZihZcxRY7fJVy9eyXwklmaDGqEXUKY/87nQc=;
        b=cFnBg07orJPTJny6Z3c6UWhQ4QuCVkrOVM5SOY2vT6ZCdjgML5naP21JiLgLs6+6Yj
         qWBYPfnHB1o+NKfPBTE/Ppy+FyTW0vuQchl8HNOIP8hpXUM2XwDdbpr3qdLqkabBe/X+
         yCyNkgVXWeumKCihdqCFNbrVKBAVI+hwPMbhBi41V8eeV0/BCUjnKTPExWZj7hk8rLU6
         pnoFQ8cFPN+Q8fIBwqdsHDJ46yaFKSO71rewKq1SN/m8SQbMPfpTZkOReJ6biFG++1VB
         BMY3w8X+iLw3ZOAr7q5XmUAkd2I6U5IbMFcvn9MBGJ+vXTFV1dOYv6hW81Il0yVyPfjz
         akcQ==
X-Gm-Message-State: AOAM530QfDwiHL5z1TH0mfaTbUlrhgjBBbN8Uw8zZcbOCXGKw/7kvC2x
        2M57X1zcLiNd71zHStFaxWNQ3wsz9aU=
X-Google-Smtp-Source: ABdhPJx5fZG6L2UN765s7AVGIQ0gg9laY3mBRJEzCMuDxIRU3oJGMy3Vq2YsK47a7WdxtLL9CVgTNQ==
X-Received: by 2002:a54:411a:: with SMTP id l26mr8217124oic.12.1600093975706;
        Mon, 14 Sep 2020 07:32:55 -0700 (PDT)
Received: from [192.168.3.75] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id c12sm3358737otm.61.2020.09.14.07.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 07:32:55 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Nix <nix@esperi.org.uk>
Cc:     Drew <drew.kay@gmail.com>, antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
 <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
 <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
 <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com>
 <87v9ggzivk.fsf@esperi.org.uk>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <74d07a6c-799b-2ebb-cc7a-0d3ccd19150c@gmail.com>
Date:   Mon, 14 Sep 2020 09:32:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87v9ggzivk.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/14/20 6:40 AM, Nix wrote:
> On 1 Sep 2020, Ram Ramesh uttered the following:
>
>> After thinking through this, I really like the idea of simply
>> recording programs to SSD and move one file at a time based on some
>> aging algorithms of my own. I will move files back and forth as needed
>> during overnight hours creating my own caching effect.
> I don't really see the benefit here for a mythtv installation in
> particular. I/O patterns for large media are extremely non-seeky: even
> with multiple live recordings at once, an HDD would easily be able to
> keep up since it'd only have to seek a few times per 30s period given
> the size of most plausible write caches.
>
> In general, doing the hierarchical storage thing is useful if you have
> stuff you will almost never access that you can keep on slower media
> (or, in this case, stuff whose access patterns are non-seeky that you
> can keep on media with a high seek time). But in this case, that would
> be 'all of it'. Even if it weren't, by-hand copying won't deal with the
> thing you really need to keep on fast-seek media: metadata. You can't
> build your own filesystem with metadata on SSD and data on non-SSD this
> way! But both LVM caching and bcache do exactly that.
Agreed, all I need is a file level LRU caching effect. All recently 
accessed/created files in SSD and the ones untouched for a while in 
spinning disks. I was trying to get this done using a block level 
caching methods which is too complicated for the purpose.

My aim is not to improve the performance, instead improve on power. I 
want my raid disks to be mostly sitting idle holding files and spin up 
and serve only when called for. Most of the time, I am 
watching/recording recent shows/programs or popular movies and typically 
that is about 200-400GB of storage. With ultraviolet, prime, netflix and 
disney, movies are more often sourced from online content and TV shows 
get deleted after watching and new ones gets added in that space. So, 
typical usage seem ideal for popular SSD size (with a large backup store 
in spinning disk), I think. This means my spinning disks are going to 
wake up once a day or two at most. More often I expect it to be once a 
week or have periods of high activity and die down to nothing for a 
while.  Instead, currently they are running 24x7 which does not make sense.

Regards
Ramesh

