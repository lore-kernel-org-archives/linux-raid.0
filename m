Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F9CC433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 20:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CCDA2074A
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 20:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/stZdmq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgH1Ujr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 16:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1Ujr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 16:39:47 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E75C061264
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 13:39:47 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id h17so337039otl.9
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 13:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=o4EKVUxu4E8V2Uo+4VaNnZYt0CpgHvnR22lh1CuI97k=;
        b=M/stZdmqYejmxbvn/UcY7YilCWxh+rQx2RqB3oLwCSjFqn+TDa92E9aiX3c7J8gV84
         W2V6Y4Lr5PMG5e+2MEaYpgoqG/EadrszcXl8omDf0zz2I22h40kyz0US2X+xHajFcdf4
         kQnGuQMyHBA2YMOMYcH/mUKo+xX+nT28eNAtLPTzOHcKUv8VbqlRaXSJg0MjpVh9SlH5
         HHVXx9YXKv6mSQ3FdaD2uHvZMrm/U4whydV3i0UJPZ4nle9ZttELq6cayFypLaKfVuti
         TW5Qxk//XvdFRqHb1mp31RKRVvpnvm4XmeJ8asb0zzdTEQl0+GDQ8p/q3qUZ+HPSVZtJ
         puKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=o4EKVUxu4E8V2Uo+4VaNnZYt0CpgHvnR22lh1CuI97k=;
        b=V/JZgmv4rGCqNN44mlaH2Z+VuCFCqI/4P02Gh9/NpsE3Ze7mwIfrBuPiR0erGZQRRk
         PcgSsR/0Nwbs2u5C2Zds6+0loppNx6sztSs6Bm2y4UvGT4vS9YP9XOAC/lkef9Zn81L1
         Bl5yySjb2tzR/m6avRyFs8Q4xFLNjFwlpkjphC/BhENRmXDZOgy7bSnzq/c3nHcc47c7
         P55GY0bXAEvq7Tkge1pfJxfbh6DopAbojxawv5vC5YwVFuORDD1fZDAXL6e1Bx5vL3kA
         3Cv31I+2L/44tLA+hVuI+FH40271W49w+1zZ7TI9CUs9+Jkp4MGqA8wjcriJzX7UVT2V
         mxlQ==
X-Gm-Message-State: AOAM5316dWwSvEM4O8d8n3n8F+zy+uVHLaPEs6wGAuIYqQzZgWuXt1Fj
        ZCqj0RKMqpbasLewM4zaEge836epP7o=
X-Google-Smtp-Source: ABdhPJzMjKPCrP2MHkr71EVQXWDtWKLaoAMdjK18cNe0tQkX6AgqClr0a3fD43MkWh8s7VMWHjQeMQ==
X-Received: by 2002:a9d:5f0c:: with SMTP id f12mr297966oti.141.1598647186156;
        Fri, 28 Aug 2020 13:39:46 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id w11sm127299oog.33.2020.08.28.13.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 13:39:45 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Roman Mamedov <rm@romanrm.net>, "R. Ramesh" <rramesh@verizon.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <20200828224616.58a1ad6c@natsu>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com>
Date:   Fri, 28 Aug 2020 15:39:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200828224616.58a1ad6c@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/28/20 12:46 PM, Roman Mamedov wrote:
> On Thu, 27 Aug 2020 21:31:07 -0500
> "R. Ramesh" <rramesh@verizon.net> wrote:
>
>> I have two raid6s running on mythbuntu 14.04. The are built on 6
>> enterprise drives. So, no hd issues as of now. Still, I plan to upgrade
>> as it has been a while and the size of the hard drives have become
>> significantly larger (a indication that my disks may be older) I want to
>> build new raid using the 16/14tb drives. Since I am building new raid, I
>> thought I could explore caching options. I see a mention of LVM cache
>> and few other bcache/xyzcache etc.
> Once you set up bcache, it cannot be removed. The volume will always stay a
> bcache volume, even if you decide to stop using caching. Which feels weird and
> potentially troublesome, going through an extra layer (kernel driver) with its
> complexity and computational overhead (no matter how small).
>
> On the other hand LVM with caching turned off is just normal LVM, that you'd
> likely would have used anyway, for other benefits that it provides.
>
> Also my impression is that LVM has more solid and reliable codebase, but
> bcache might provide a somewhat better the performance boost due to caching.
>
Thanks for the info on bcache. I do not think it will be my favorite. I 
am going to try LVM cache as my first choice. Note that the new disks 
will be spare disks for some time and I will be able to try out a few 
things before deciding to put it into use.

One thing about LVM that I am not clear. Given the choice between 
creating /mirror LV /on a VG over simple PVs and /simple LV/ over raid1 
PVs, which is preferred method? Why?

Ramesh

