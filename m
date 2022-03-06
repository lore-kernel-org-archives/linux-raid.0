Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7168BC433F5
	for <linux-raid@archiver.kernel.org>; Sun,  6 Mar 2022 15:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiCFPQ1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Mar 2022 10:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiCFPQ0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Mar 2022 10:16:26 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C87E3FBEB
        for <linux-raid@vger.kernel.org>; Sun,  6 Mar 2022 07:15:33 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id e15so10081799pfv.11
        for <linux-raid@vger.kernel.org>; Sun, 06 Mar 2022 07:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PoosqNS45Nfcc4L8nEdm8S4SyFbRorxpbmChCeAf/bU=;
        b=YipTuFbyeYjLfjDEKePl2rIGpXDqcZnbahKRRuz9v+4OViRrUEPG0QnVaW1R6/23nT
         m5wMk3u44ctQFFF8twlyuSoTUGHItwGqn/N4GgiIy7KnM7q7vFxSHzXRfZnLUR1rKWxG
         Or36YaXGHGgf274j1m2i7/e06EGZAaLd2+te96eD1dLtAvuH+afr97ICtRP6Hy+CB5q4
         yeKMYDl0yNWXt33/voPB6NpCT7BNzABdS/oLTgWHf0CieX6/Em0Q+B/XpCsUKTexoJmi
         kEu+x+RCRguFH+YSbfnrHCqvxcI6ZwmosV+I7EtKTdUmanv+qjAgdZcmA7FPzyC1QcD7
         93ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PoosqNS45Nfcc4L8nEdm8S4SyFbRorxpbmChCeAf/bU=;
        b=Y1Vm3Trswlvqa1MuagyDVUWSSQwk8OYheNe1pfKkOWFWtNLM1GR8YrPd3pFlz2gGXt
         Kp0z0L29A62dEjIUmTEt5KJO2K/SHZNeTJe/u8ANrw35doD2uEsBLZ676J1ohFTbscr3
         hKeKk/KGx5pMUXVhTQCGIiha7J82EU54TvshdPBGLWtb4nYTS5fwfnmz4V8q7jC/9F8O
         u3+fAv42ulyFCJ1V5Xa+sm6iXqfqtSzF0SDmeKM9GPa/1lbDOLQ6FMvcp+K9r1xdyZLF
         cCk5b3AnnDZdXtiZQlx61E1EUu2/ClZ3RlCEnjgBXPBU25nxi4bUAZNE96fUpgv739Oi
         rjNw==
X-Gm-Message-State: AOAM532dZmRI6j9cXkVRu1l5QhhIa5o4dwbVJjfHOvtbOWGCaClTOetD
        tl9MsP2pTPJ+2nS7yOtBk+C++g==
X-Google-Smtp-Source: ABdhPJx+ay0egToEeW3Jn0HOhGSR25bj4D8JGA6abtl+VToqp6bpkvqyodojIkoeQudhMR6edbcrhw==
X-Received: by 2002:a63:86c8:0:b0:37c:9031:c41a with SMTP id x191-20020a6386c8000000b0037c9031c41amr6258790pgd.242.1646579732304;
        Sun, 06 Mar 2022 07:15:32 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 142-20020a621894000000b004dfc714b076sm13062682pfy.11.2022.03.06.07.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 07:15:31 -0800 (PST)
Message-ID: <0143c7fe-6cdb-fb7f-ff94-97eec64ec3e8@kernel.dk>
Date:   Sun, 6 Mar 2022 08:15:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: bcache patches for Linux v5.18
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <084b5385-ebe7-5fca-8b56-a66276005e78@suse.de>
 <c94f9c70-7052-0bae-ca0e-9b9ccc48c46b@kernel.dk>
 <3b93c0db-316e-d227-e98e-be7a6f4e2907@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3b93c0db-316e-d227-e98e-be7a6f4e2907@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/6/22 7:55 AM, Coly Li wrote:
> On 3/6/22 10:17 PM, Jens Axboe wrote:
>> On 3/6/22 3:35 AM, Coly Li wrote:
>>> Hi Jens,
>>>
>>> I have technical problem to send patches via email this time, please
>>> consider to pull the bcache changes from my bcache tree. They can be
>>> applied on top of your for-5.18/drivers branch.
>>>
>>> We have 2 patches for Linux v5.18, both of them are from Mingzhe Zou.
>>> The first patch improves bcache initialization speed by avoid
>>> unnecessary cost of cache consistency, the second one fixes a
>>> potential NULL pointer deference in bcache initialization time,
>>>
>>> Please take them for Linux v5.18, thanks in advance.
>> I can take a git pull, but don't base it on something that isn't a tree
>> of mine. If I pull your branch right now, I'll get a ton of unrelated
>> changes.
> 
> I see, my for-next branch is not 100% clone the for-5.18/drivers
> branch, although the patches are verified on top of it.

It doesn't have to be a clone, but you can't sell a pull request that
ends up meaning the person pulling will get a lot more than the stuff
you just committed. Which means it should've been based on
for-5.18/drivers, or some earlier point there depending on when you
pulled it.

>> If you want to do a git pull vs sending patches, base it on
>> for-5.18/drivers instead.
>>
> Copied. Now I pull my for-next branch from your for-5.18/drivers
> branch, and they are same, and the two patches are added on top of it.

Thanks, pulled.

-- 
Jens Axboe

