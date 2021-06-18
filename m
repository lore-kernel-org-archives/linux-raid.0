Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711E2C48BE8
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 05:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4167C61164
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 05:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhFRFhd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Jun 2021 01:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhFRFhc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Jun 2021 01:37:32 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F98C061574
        for <linux-raid@vger.kernel.org>; Thu, 17 Jun 2021 22:35:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so5215147pjn.1
        for <linux-raid@vger.kernel.org>; Thu, 17 Jun 2021 22:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=EKHJkpB7SHNIWlL1/ZapqGRm3ayRgWeyTZRDoBR2XE4=;
        b=IP909pcaGVZbBsGH06O7wFk7oJOehFVZR+hi79hCq5SjzOuy4T43vOwidH+eYIIM3X
         lB/nlJu6e6mzDxWksj1LUFjDVhg45ZYo1wzvbB+B6RFOLzNRQO2s+CmP6ZJbvRXSCVR3
         xpcRQjDsMbxsDpx9x07xZE52G+rVT7R9Ht09xrkPqF5141whXpKt8KGXoE0CxMrbiA7l
         0cZRFZ50b6Fkl2fUB5ozP77dKgsXEaHZ+FrwqfHG1cGq6GaDRrJ/CPbTlbHY8nO2hX/J
         IIXPK3nBdzoUj/afAIXBDQGNW8uZ/ANIfgZvPzz2rKS/t+DzZNgKCIpLLjqU5jDf5a1C
         SQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EKHJkpB7SHNIWlL1/ZapqGRm3ayRgWeyTZRDoBR2XE4=;
        b=QyhfWnRvBchj/GzxNQc9wfJ/c8sls+icH3eA+vI6g2dXGM5LoIw2bwhVM892je9tYv
         CsjnCX9asMPYbdXP/SapjKXUstIVC32snVrXYJOogByq9xNOd9kXPwD1TceIrg19EfzE
         8vw2JUv781whEZlRzEUwmzA1B28n4s96YY5F/P5Tj+1ZdlMA0lpBBdFTJkkgyMgg/r9g
         syPlmjXXNkSpp8IxuSxJNCpR2fnbqzc4mAFOqKIUNX92dKj9Gqby+kiIiCqVx/k/ASRs
         e064Dp5g1G/HNhkY+BaUsTHpuBN9Do7hfffVbQurFDiQIapvc1fJzu90WnyimtFgEFEj
         w6nQ==
X-Gm-Message-State: AOAM533R/9BSWYVbvOlCFJm4D6LgndwPCkVQ4j2whxpK1nSpe0plhDA5
        Q71adKtWAoPs4Vyaiq6ONzLH14qxl67Cnb6s1F0=
X-Google-Smtp-Source: ABdhPJz54ilamE9kdIXMe/2msHzkywaLrHtGKUfOzIsM7b/k8ha3+WILK2N2dXs7tzMrpTShs+9a1A==
X-Received: by 2002:a17:902:249:b029:121:b9eb:a513 with SMTP id 67-20020a1709020249b0290121b9eba513mr492750plc.6.1623994522176;
        Thu, 17 Jun 2021 22:35:22 -0700 (PDT)
Received: from [10.6.0.61] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id o16sm6641295pfk.129.2021.06.17.22.35.20
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 22:35:21 -0700 (PDT)
Subject: Re: Intermittent stalling of all MD IO, Debian buster (4.19.0-16)
To:     linux-raid@vger.kernel.org
References: <20210612124157.hq6da5zouwd53ucy@bitfolk.com>
 <336ddb45-990f-5d52-23b0-c097c124d022@gmail.com>
 <20210616150549.ojm3nvdamkmqb6ev@bitfolk.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <33236a83-a14d-a9e0-5384-91aa007858dc@gmail.com>
Date:   Fri, 18 Jun 2021 13:35:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210616150549.ojm3nvdamkmqb6ev@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Andy,

On 6/16/21 11:05 PM, Andy Smith wrote:
> Hi Guoqing,
>
> Thanks for looking at this.
>
> On Wed, Jun 16, 2021 at 11:57:33AM +0800, Guoqing Jiang wrote:
>> The above looks like the bio for sb write was throttled by wbt, which caused
>> the first calltrace.
>> I am wondering if there  were intensive IOs happened to the
>> underlying device of md5, which triggered wbt to throttle sb
>> write, or can you access the underlying device directly?
> Next time it occurs I can check if I am able to read from the SSDs
> that make up the MD device, if that information would be helpful.
>
> I have never been able to replicate the problem in a test
> environment so it is likely that it needs to be under heavy load for
> it to happen.

I guess so, and a reliable reproducer definitely  helps us to analysis 
the root cause.

>> And there was a report [1] for raid5 which may related to wbt throttle as
>> well, not sure if the
>> change [2] could help or not.
>>
>> [1]. https://lore.kernel.org/linux-raid/d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz/
>> [2]. https://lore.kernel.org/linux-raid/cb0f312e-55dc-cdc4-5d2e-b9b415de617f@gmail.com/
> All of my MD arrays tend to be RAID-1 or RAID-10, two devices, no
> journal, internal bitmap. I see the reporter of this problem was
> using RAID-6 with an external write journal. I can still build a
> kernel with this patch and try it out, if you think it could possibly
> help.

Yes, because both of the two issues have wbt related call traces though 
raid level is different.

> The long time between incidents obviously makes things
> extra challenging.
>
> The next step I have taken is to put the buster-backports kernel
> package (5.10.24-1~bpo10+1) on two test servers, and will also boot
> the production hosts into this if they should experience the problem
> again.

Good luck :).

Thanks,
Guoqing
