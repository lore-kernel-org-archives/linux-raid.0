Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A5EC433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171C861361
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhESBvq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 21:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbhESBvn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 21:51:43 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A4FC06175F
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:50:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 22so8395452pfv.11
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=JZCVh4JnGk+vDjml6/YmIJpU3ACUrGyG5Dlg12nH7GI=;
        b=VN6BEK8OpSxYAugZb4vFT+RFvaFZ7ZU1cG+Zk5Nq/NdzB+IMZcp3ICIVUk6yp2rIl+
         C2+CXzGdOgaM37HwcZkO+yxD39o57IN4onLeZi6dnFp6L+9RfnyY4+wdra2vqoxryPSC
         NZcEEHiJ9+m68bJYgwqbC6BnjSUbIZdUL/dpfhoCQQXMD9p01ecoKboCargc4PJ5s5kY
         3g+h54HtiD9D48m5wvp4zs4KZBniVG+Kg5yQ2LXfDlBtMreCSSQiW0i9c+epo5gTEZRy
         HfSNCTWKnACGg5RZFivcDizEAHipxNnaP0zqotZ9os8QGoOAT1HSWE3fT/PahGGX7VIF
         Ctwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JZCVh4JnGk+vDjml6/YmIJpU3ACUrGyG5Dlg12nH7GI=;
        b=nXa4cr9LA/Xa1JijSQoep1WYDCJ5xPtYAQJdbOlIAoEslFaJjvR/GmdrRnK9mLsz6h
         +c7BNgOYbWtg3sSuQ/rMocAVA9r5W3vpr2UHpM410eSrk0fimzaVIZ2Vsgnv4zXkx6HW
         S1XyXP2U/z4a4MBdJ1qMpTquKK8b5V0RbQKnvz0pkGwL2AGYZhu282wgb58pooj3iiFk
         IYtKIMoS5DQS4Cjs01uoIwT0Idk9cEFnRwP1VO9MzcUd6PwTVkCwheuy/dyQ/jyL79la
         4p6XLTQ2mlRgOq4DVtCXh3EDS+MbBJ08WUWdwf9la8RYCpTMjed0xu0XWyXxhV/hRrWd
         hEEA==
X-Gm-Message-State: AOAM532iyjDH7aPHabrCXUfYaIc18/bR5I5ykHHZUsALrOGT5GKEs4cg
        JPhnbQ9GxACd4+ZR5eOZ6Mc=
X-Google-Smtp-Source: ABdhPJwqZofSU+20N9qROQ9YyntqGsS5kTWxuFsJGy3yKgY8bGSTWhqMF6fN+ZhngFSGyqawbkt+cg==
X-Received: by 2002:a05:6a00:bcf:b029:2d5:d695:d52f with SMTP id x15-20020a056a000bcfb02902d5d695d52fmr3447479pfu.38.1621389024513;
        Tue, 18 May 2021 18:50:24 -0700 (PDT)
Received: from [10.6.3.223] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id h24sm13456805pfn.180.2021.05.18.18.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 18:50:24 -0700 (PDT)
Subject: Re: [PATCH 0/5] md: io stats accounting
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <CAPhsuW7fDEZFw6_D31GRh6U9Kh0188NOkdh5s=PsvaSpGbB5vA@mail.gmail.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <27344c09-38d8-c5f9-bedf-96683b67864c@gmail.com>
Date:   Wed, 19 May 2021 09:50:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7fDEZFw6_D31GRh6U9Kh0188NOkdh5s=PsvaSpGbB5vA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/19/21 8:14 AM, Song Liu wrote:
> On Mon, May 17, 2021 at 10:33 PM Guoqing Jiang <jgq516@gmail.com> wrote:
>> Hi Song,
>>
>> Based on previous discussion, this set reverts current mechanism, then
>> switches back to the v1 version from Artur.
>>
>> Also reuses the current clone infrastructer for mpath, raid1 and raid10.
>>
>> Thanks,
>> Guoqing
> Thanks Guoqing! Please address Christoph's feedback and send v2.

Sure, please comment about the checking about skip the split by md.

Thanks,
Guoqing
