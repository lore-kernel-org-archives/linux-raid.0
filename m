Return-Path: <SRS0=Fkpm=DC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8FAC4363D
	for <linux-raid@archiver.kernel.org>; Fri, 25 Sep 2020 13:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAEC32083B
	for <linux-raid@archiver.kernel.org>; Fri, 25 Sep 2020 13:49:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="YxP0gaNl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgIYNtx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Sep 2020 09:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgIYNtw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Sep 2020 09:49:52 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CE0C0613CE
        for <linux-raid@vger.kernel.org>; Fri, 25 Sep 2020 06:49:52 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 34so2615472pgo.13
        for <linux-raid@vger.kernel.org>; Fri, 25 Sep 2020 06:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4clcgGPds3bmvgfh8eFvxDdVD8ehYyeTGx+JENl9kiw=;
        b=YxP0gaNlHO6KRVSEw8oKlAVm59V6nbT4lTEK16VlNnDJht617tjkz1RNP+gYQTg34c
         ihJ8PZFMJbCwxfaSk8ERjLs9/IikixOovuHGbmVrCc5WmmP4FoVkGCQsV+pO9c0oii4W
         vztObhyVrLphGOYGlAHo5aY49YSmtMaReyQWmvHkw9LHpz21oIMrPXW1FGlj+B/kgogz
         o7dA3gvlBcM7vNNxkJHitFx0hllxt1kGrFJTyHH/LBAN5bLg+r7NmfnYKq/wDYwx5gCy
         WOOopzeFHlFJbaDs8+rTQeZwGO4BzOsyINPAY0XJrtdDLmPrdNQ8R2NRz60WoNMZn/YR
         UqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4clcgGPds3bmvgfh8eFvxDdVD8ehYyeTGx+JENl9kiw=;
        b=Ewg+VEgwircuB2EJojUynGg+CKr+Rfjm5EOAMH1Z8jyaZ6a2rk7Tye+iXDJjqXxO2N
         f4hutnfH3pkeDoJ9C+PzIUj0BYVnDdGj05lgzQJ3tKdfGlc26Uf3RxxUGBZptH51n7Ad
         CIsyjBfFn3mNk11U6nk+q5LMPTCVuj6/Jo2Zd+gpgFTbhEWIFkm91PYFw+gMWILXoOzO
         IaDNlAV/J/YQRI/c+lSkW/rtGqD238/ttPObGiZpVPILPaPNGS+NeU6t8m0oC4SBpesa
         ImqqY5CWUsMXrsEkWMtSUutYNZMh8U9QGBg01vuE3htaqLepAxfSdTxJpqiSYVDMz9RL
         ajEg==
X-Gm-Message-State: AOAM53081TsCDnrplJ2f0Gde/HWbL84GnDdQ8NTqEfsEJrshTp3nvIqY
        hn1r8H2S2asXok559tRVlMvblA==
X-Google-Smtp-Source: ABdhPJy8l2eV6aZf2OGf2Wo0a4fCgWq3y2kOqQKZddHW6qyvTIwbNwPaCJq9k0/nbZ6NfP0uF9UBMQ==
X-Received: by 2002:a17:902:ed12:b029:d2:166:6411 with SMTP id b18-20020a170902ed12b02900d201666411mr4424457pld.59.1601041792471;
        Fri, 25 Sep 2020 06:49:52 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id gt11sm2128643pjb.48.2020.09.25.06.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 06:49:51 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20200924
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xianting Tian <tian.xianting@h3c.com>, Xiao Ni <xni@redhat.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
References: <AB173AED-FC49-4098-BFF4-CF94438CFA94@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b3772d42-2cb7-39bf-f380-2f10850c3af2@kernel.dk>
Date:   Fri, 25 Sep 2020 07:49:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AB173AED-FC49-4098-BFF4-CF94438CFA94@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/24/20 5:54 PM, Song Liu wrote:
> Hi Jens,
> 
> Please consider pulling the following changes on top of your for-5.10/drivers
> branch. 

Pulled, thanks.

In the future, can you please include a summary of changes in your pull
request?

-- 
Jens Axboe

