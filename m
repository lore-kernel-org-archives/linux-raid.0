Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFA2E71D20
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 12:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjI2MRi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 08:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbjI2MRd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 08:17:33 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279E71AC
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 05:17:31 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6c45a230403so1602562a34.1
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 05:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695989850; x=1696594650; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DDaOXFK/PqYazUxpAenFnwFL5Z8COu9To7RGX4pLsTo=;
        b=K6HYGq9FSBdYj8jIQP3vMYzOvdJLxx/3GjCbCw0aP+0GFzFZLa94PhugriXJW7UW+E
         Ct2Bt1dJfTtWX6lsKi8HytsAnMb19/tdW7tpJ2eoNL6/aZOxtDNv2IaQKXnAx9LDpwdE
         ctGP6Cs9xGdMfOpK3Ncz87Pvfflzy9zlvDNoBBrixp0m54PXiWaeqZd+MMyS7h4rssii
         PXSFGP/jD25uS9XUiNxiDfddmFaTNVc16h88O8i7LLfeniYv/kEYYT3jJvyjOxmbn9NI
         a0LWSsYCjtQzopkKhpnvmZxgzjuTsFuUwS4Vkg8Hbd6q6GupAkgZ33Y4TCmy+q0/Rn/h
         SQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695989850; x=1696594650;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DDaOXFK/PqYazUxpAenFnwFL5Z8COu9To7RGX4pLsTo=;
        b=OvjeI3axTk1mpcKiN/2d+pQbg3Zb2hrHGbcquYq01Um64SJRNXXDOPeuAgk7/htIEX
         bynZIZofcYJBZ1k/+G2DzltPAJC8qZ2BrsuDRdODXLewGsO1rEIydANLiNU1kICoOZas
         hM4uN6r4Iuokw0DtSA9pr92wsP8naNrqmXfmzje1jqnn3r5DzoX4/yebmP1+VRGE6zCw
         2mWkd9J0bP6nhXXOwCfxPC36wqdpnwTdNRMZNsiV+Ws7U88S0CNJ4xBa7o2/52qgR5kP
         CuBao/0+p2/CS9/kc8pRjMNUVqJCl6mJio9xsnZg5qsCfVnibhuqpjHQSopIv/CV1hX0
         6HIQ==
X-Gm-Message-State: AOJu0Yy3Df5S+UYijm9Z5uDbFwQPTYlS55u30fOeDnOJqXTo/F0P1T6T
        iO5RSX4gXmVP4CeoZco8ll3gng==
X-Google-Smtp-Source: AGHT+IHcGF4h9jDIdsXIynoHsSHUfRWQE7ETyJzNMSt4R7mwgDalcUuvelwOfg9sU48xb38wZLNQyA==
X-Received: by 2002:a05:6830:359a:b0:6b9:db20:4d25 with SMTP id bd26-20020a056830359a00b006b9db204d25mr4507739otb.1.1695989850328;
        Fri, 29 Sep 2023 05:17:30 -0700 (PDT)
Received: from [172.19.130.163] ([216.250.210.88])
        by smtp.gmail.com with ESMTPSA id r18-20020a0cb292000000b0065b18f18709sm3625051qve.78.2023.09.29.05.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 05:17:29 -0700 (PDT)
Message-ID: <b271911c-19cc-43aa-b29f-c5489bf357e3@kernel.dk>
Date:   Fri, 29 Sep 2023 06:16:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 2023-09-28
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Justin Stitt <justinstitt@google.com>,
        Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <956CEF49-A326-4F68-BCB3-350C4BF3BAA8@fb.com>
 <f945f9bb-68bc-41b5-977c-64a1f2d0e016@kernel.dk>
 <69B42599-C78A-457F-81A4-DCA643FC32C9@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69B42599-C78A-457F-81A4-DCA643FC32C9@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/29/23 6:12 AM, Song Liu wrote:
> 
> 
>> On Sep 28, 2023, at 11:02 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/28/23 2:58 PM, Song Liu wrote:
>>> Hi Jens, 
>>>
>>> Please consider pulling the following changes for md-next on top of your
>>> for-6.7/block branch. 
>>>
>>> Major changes in these patches are:
>>>
>>> 1. Make rdev add/remove independent from daemon thread, by Yu Kuai;
>>> 2. Refactor code around quiesce() and mddev_suspend(), by Yu Kuai.
>>
>> Changes looks fine to me, but this patch:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=b71fe4ac7531d67e6fc8c287cbcb2b176aa93833
>>
>> is referencing a commit that doesn't exist:
>>
>> "After commit 4d27e927344a ("md: don't quiesce in mddev_suspend()"),"
>>
>> which I think should be:
>>
>> b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
>>
>> where is this other sha from?
> 
> The other sha was from a previous md-next that got rebased later. 
> I guess Kuai didn't catch it because he had the old sha in his 
> local git cache. I should have caught it, but missed it because 
> it was not behind a Fixed tag (still my fault). 

Makes sense. It's not a huge deal, and I would not rebase your tree for
it. Mostly just curious where it came from.

> I recently improved my process to only do rebase when necessary 
> (I used to rebase too often). Hopefully this will prevent sha 
> mismatch in the future. However, to fix this one, I guess I have 
> no options but rebase the branch? I will fix it later today and 
> resend the pull request. 

I did notice that the tree looks much better now, rather than have all
brand new commits. Thanks for doing that! So I say we keep it as-is and
I pull it - it's easy enough to find the real commit just based on the
subject.

-- 
Jens Axboe

