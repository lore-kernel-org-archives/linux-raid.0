Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16645C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 17:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhLJRYj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 12:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbhLJRYj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Dec 2021 12:24:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83CBC061746
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 09:21:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so8503091pjb.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 09:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bRjiraq06xeJ9SzUvXU6nvz/Av6O33eRA4w4B2QozuA=;
        b=4+nTtId4mlohvP+QABcnl8zcktc5C13DhIOniwc2dgO0WKcHDZIK1BjyBn+WyINiBB
         qxTNm0f8e4A0JS+Stp/2rl8W/rcbafgnQRywb6UW2Zk9Z1etzQ0sBzWeVqpBwCPSeQE6
         NZJRXtzzApTsm8Tqss7XqTq6xX6MoszvqiSMfDV79hkBO8w9CeJo1GKiAFdqsaGmlMl9
         qRuiMpAS3XLHXRQgnymf2bI8zYjzH6G12gnkfrhWWi5+JqS3FTgteqjHL7Ik5+aykOyD
         l79paBth8f4g3BRHzkJpshVooXRU6Q4L53PZlt9GscPN287FTWbY+CwxtQjGK7qu8OLg
         Nmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bRjiraq06xeJ9SzUvXU6nvz/Av6O33eRA4w4B2QozuA=;
        b=Xy4e6JIigIpM0fairFdcl8nlpqu7AC56n4MX2FxXuikKwtBdufqpVOp5AiAG2/S0ga
         Fa5ZciypTjLwUAAMZNKl+UThySjv7rdpsDGiNw3/svd3eDxSy2t1y1qqPHq4m8iTp7pE
         IlpMO99LCIuJVBpy+BSJcdZGAyq5RCeV5KhwKAY85Fmj6ouBnyDRP3nUuFqr36DPn+SW
         U7NB3C7jd5SKBydhfMdrMo0SZE2hOGDM9Akjnshg3fEhD6zUFYB7VtKKHkCBNS1/AC9J
         41JlgHwoXUQ/VUZHcRMXDnB/4eYqhgOUdXXeqJUvFTOR8i48gK8JDkE6Ig33RowRVS7E
         bt1g==
X-Gm-Message-State: AOAM531MKJAHHl+P2sky/1s1YjFY4EcjxtPhwD8LB0bqB6cMhU2o3RCQ
        HFZF8Md5AcxE9/r/J5EqbG7pV411wKQMaQ==
X-Google-Smtp-Source: ABdhPJzmcQj+Q2J4T1yh9X63SPjXRsfVkeibOcUfQu8nhihzPX34HUUyOWMQ/08OndvyMw9naux98A==
X-Received: by 2002:a17:902:b60b:b0:144:e601:de5 with SMTP id b11-20020a170902b60b00b00144e6010de5mr77359984pls.36.1639156863337;
        Fri, 10 Dec 2021 09:21:03 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id d12sm4315012pfu.91.2021.12.10.09.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 09:21:03 -0800 (PST)
Subject: Re: [GIT PULL] md-fixes 20211210
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     zhangyue <zhangyue1@kylinos.cn>,
        Markus Hochholdinger <markus@hochholdinger.net>
References: <BEA088C2-322C-4398-B43A-E231CC3B05B0@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <71a2aea3-4563-f3e8-5fa0-47820bc27646@kernel.dk>
Date:   Fri, 10 Dec 2021 10:21:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BEA088C2-322C-4398-B43A-E231CC3B05B0@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/10/21 10:17 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your block-5.16 branch. 
> Both changes are straightforward bug fixes. 

Pulled, thanks.

-- 
Jens Axboe

