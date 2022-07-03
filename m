Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B4EC43334
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jul 2022 16:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbiGCQUD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 12:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiGCQUC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 12:20:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747562645
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 09:20:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w24so7128161pjg.5
        for <linux-raid@vger.kernel.org>; Sun, 03 Jul 2022 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=ePn8ZREWBPDcqD+BBlGK/VvCLKkHgfdSSc39TIM+9/s=;
        b=eBEps1/C1sB/megjrvYszgDr9pAtnucvQfTIZY5bL22yd+7oMQeVKJvhXjQHIgWfzd
         GOKrBcDWEU0Dnh96KJdudhwIA1QT/hXEZm9gCqOEfALwfRJPRNNIQZ/nXTurjcuLBgj7
         SMkLUQYAgSVg7+3+4ZauXJb4RHM1oosvUoOSRxcmLQVXt9MDtGmrIScadM1x57Mzkkho
         k79SXXfYIlWkT6/IB9YPDLo3h0gxXwGy/5p4peZFj/Q2BzA2SNw2LkmvL/UzV5jBR9fP
         NaF0Sc0OWWAnNIhMYfvhmGkChtwgfjeUn3o0l9gBaKHyFThG9MCF7MbU0SkQ7l4jVHRD
         GBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ePn8ZREWBPDcqD+BBlGK/VvCLKkHgfdSSc39TIM+9/s=;
        b=nBm1v6/6q0GoL1CIckFVYATTs6V9P++GS8DM8a/jfeh1jRUeQSzd5CLAwdvWkcogXM
         M5aShxm8iCmP31elbRSqpXXwVcphd34LAAtHdvQo1BzuQIlsoCYuFExwF7r/hoTMqmTX
         wi0ByWfCiIIGLRogGNokKtu52NRYHqn5i36ihaqsV/cju4pMUVmpsnH682kXtv/aD5CB
         /4OlC9hG19c4BDWapGH2cE/n2WdR3peOrh7SeleqGb9yc0tFYkToMkwpNguJQKKmiajb
         8oUFxjUIQLLqww1nHA/o5Ty78uHRQqAhxtVNh1EN7P91ZIkzgoHsl01ab3UP7rx1/8k2
         9q2A==
X-Gm-Message-State: AJIora9S9o2rp29lBV2VjF42DdifHZMCNujuiFsmij+S8b0gmTnBbfKi
        pctwL0Pic74YL0VwTG51b6nmhA==
X-Google-Smtp-Source: AGRyM1sG19AATAysB1QcJSGuxGfOSpbTuYK6MiNlKOfIcmIJxAifRAhteutup68Jd0YTYNmzyPblVg==
X-Received: by 2002:a17:902:e1d1:b0:16a:239d:e6f1 with SMTP id t17-20020a170902e1d100b0016a239de6f1mr30416867pla.20.1656865200914;
        Sun, 03 Jul 2022 09:20:00 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902dc8100b00163c6ac211fsm19255064pld.111.2022.07.03.09.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 09:20:00 -0700 (PDT)
Message-ID: <275e61e8-44bc-2247-41c0-730d0e0f3bab@kernel.dk>
Date:   Sun, 3 Jul 2022 10:19:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220703
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <jgq516@gmail.com>,
        Chris Webb <chris@arachsys.com>,
        Zhang Jiaming <jiaming@nfschina.com>
References: <9727B564-F3B3-4CB1-A609-01AAD3C193F6@fb.com>
 <d76ca8b8-b827-4928-6286-47a0dbb6de25@kernel.dk>
In-Reply-To: <d76ca8b8-b827-4928-6286-47a0dbb6de25@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/3/22 10:02 AM, Jens Axboe wrote:
> On 7/3/22 9:13 AM, Song Liu wrote:
>> Hi Jens, 
>>
>> Please consider pulling the following changes on top of your for-5.20/drivers
>> branch. The major changes are:
>>
>> 1. Improve raid5 lock contention, by Logan Gunthorpe.
>> 2. Misc fixes to raid5, by Logan Gunthorpe.
>> 3. Fix race condition with md_reap_sync_thread(), by Guoqing Jiang.
>>
> 
> I pulled this in, but what I pulled doesn't match this pull request.
> There seems to be an extra patch in there, and diffstat doesn't match
> what is in your email:
> 
>>  MAINTAINERS                |   1 +
>>  drivers/md/dm-raid.c       |   1 +
>>  drivers/md/md-autodetect.c |   1 +
>>  drivers/md/md-cluster.c    |   4 +-
>>  drivers/md/md.c            |  76 ++++++++++++++++---------
>>  drivers/md/md.h            |  16 ++++++
>>  drivers/md/raid5-cache.c   |  40 +++++++------
>>  drivers/md/raid5-log.h     |  77 ++++++++++++-------------
>>  drivers/md/raid5-ppl.c     |   2 +-
>>  drivers/md/raid5.c         | 646 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
>>  10 files changed, 549 insertions(+), 315 deletions(-)
> 
>  MAINTAINERS                      |   1 +
>  drivers/block/drbd/drbd_bitmap.c |  49 +++-
>  drivers/md/dm-raid.c             |   1 +
>  drivers/md/md-autodetect.c       |   1 +
>  drivers/md/md-cluster.c          |   4 +-
>  drivers/md/md.c                  |  76 +++--
>  drivers/md/md.h                  |  16 ++
>  drivers/md/raid5-cache.c         |  40 ++-
>  drivers/md/raid5-log.h           |  77 +++--
>  drivers/md/raid5-ppl.c           |   2 +-
>  drivers/md/raid5.c               | 654 +++++++++++++++++++++++++++---------------
>  11 files changed, 595 insertions(+), 326 deletions(-)

TUrns out I pulled it into the wrong branch. But even after correcting
that, I now see:

 MAINTAINERS                |   1 +
 drivers/md/dm-raid.c       |   1 +
 drivers/md/md-autodetect.c |   1 +
 drivers/md/md-cluster.c    |   4 +-
 drivers/md/md.c            |  76 ++++--
 drivers/md/md.h            |  16 ++
 drivers/md/raid5-cache.c   |  40 ++-
 drivers/md/raid5-log.h     |  77 +++---
 drivers/md/raid5-ppl.c     |   2 +-
 drivers/md/raid5.c         | 654 +++++++++++++++++++++++++++++++-----------------
 10 files changed, 553 insertions(+), 319 deletions(-)

which is still off, with the discrepancy being in raid5.c?

-- 
Jens Axboe

