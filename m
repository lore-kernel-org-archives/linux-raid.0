Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C687C43334
	for <linux-raid@archiver.kernel.org>; Mon,  4 Jul 2022 01:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiGDBmo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGDBmo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 21:42:44 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5598D6437
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 18:42:43 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 145so7592286pga.12
        for <linux-raid@vger.kernel.org>; Sun, 03 Jul 2022 18:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cEwn6ALzf01K94LBQxplMMDRDWdDE3+nYTcscNaPiuY=;
        b=a3j1kNvK1WvYMGDACd5zY+xlKI7dIu2NE3NyJakuBWsKfwpbkioqEaNSDX1HSSE1r9
         GEhhw0zoG7haCgBveTCCu2E5ivlYJqeZXhHupUtLFQe0fT3eunZVp1Zc4GiG9rdAMSgr
         b7+QzvuttLYGFB8Uub4bi4JTfViFGtOkplI4xswV3WST2c9tjgadZ0QY4FdQV18tN4En
         ONrLJaDD4c+TTMbCYpooAer7g8mMmPq7d6VOTu0ykOMsh3teY/921AqaBsqr7Hnri45z
         95abEyYlqgG9TZDWnlIQQPCgW3KBKbYZA2FPzc13NxvkRoxespbt4+hrPFuhQ7Qxdqda
         GBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cEwn6ALzf01K94LBQxplMMDRDWdDE3+nYTcscNaPiuY=;
        b=nrd5WkDuuuGHW6biPq6kYEJyCjaeAZINhjWq//kRj+2kf9S6+9SVd/KZg1g2icTUtE
         SPeG4XMWBeD+Ut8OHVYF/a/iS6UqAEojK5tSUSi2Oq5KgbC2DoWIx26A/mPy/QGWDrdB
         XVCZ9vreQa57+NTb88QcsD85+VMkrOie5ur7x32wlk5983mDSNTmxeNispdK84pCuPbx
         3k+FbihZPosA9ZiXrBLnySmwDXngs/MS8XpB6rQlgcT0Yt6OuQ4sE0eRfq9ScP4RIvYI
         VHzNihVpMIzoOfeuIg7hionPvyOEv+Fy/ihVKRwHC4/uC8LU8i1lqATnoEfHjaV3/Cmu
         DvJw==
X-Gm-Message-State: AJIora90SkiW/+886TbjB24ZxT+LEwWY0LCv6BtSERoRMbr/lscYbt9+
        U45wzEEzslKxWiitrdTHiiqC7A==
X-Google-Smtp-Source: AGRyM1vQdCDeaEmj88I8VXW25wkU2QTVVMW4fhmnVgO6PQNcx8fVZOIF16IRLANGuDVEn7JZtPSaDA==
X-Received: by 2002:a63:82c3:0:b0:40d:3b63:a806 with SMTP id w186-20020a6382c3000000b0040d3b63a806mr23247938pgd.75.1656898962736;
        Sun, 03 Jul 2022 18:42:42 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id lx13-20020a17090b4b0d00b001df264610c4sm13551540pjb.0.2022.07.03.18.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 18:42:42 -0700 (PDT)
Message-ID: <78ef66c1-9a2d-2296-5b13-24ea46d9abae@kernel.dk>
Date:   Sun, 3 Jul 2022 19:42:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220703
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <jgq516@gmail.com>,
        Chris Webb <chris@arachsys.com>,
        Zhang Jiaming <jiaming@nfschina.com>
References: <9727B564-F3B3-4CB1-A609-01AAD3C193F6@fb.com>
 <d76ca8b8-b827-4928-6286-47a0dbb6de25@kernel.dk>
 <275e61e8-44bc-2247-41c0-730d0e0f3bab@kernel.dk>
 <E5976072-2F61-4B96-98D0-FADE94F96B5F@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <E5976072-2F61-4B96-98D0-FADE94F96B5F@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/3/22 5:49 PM, Song Liu wrote:
> 
> 
>> On Jul 3, 2022, at 9:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/3/22 10:02 AM, Jens Axboe wrote:
>>> On 7/3/22 9:13 AM, Song Liu wrote:
>>>> Hi Jens, 
>>>>
>>>> Please consider pulling the following changes on top of your for-5.20/drivers
>>>> branch. The major changes are:
>>>>
>>>> 1. Improve raid5 lock contention, by Logan Gunthorpe.
>>>> 2. Misc fixes to raid5, by Logan Gunthorpe.
>>>> 3. Fix race condition with md_reap_sync_thread(), by Guoqing Jiang.
>>>>
>>>
>>> I pulled this in, but what I pulled doesn't match this pull request.
>>> There seems to be an extra patch in there, and diffstat doesn't match
>>> what is in your email:
>>>
>>>> MAINTAINERS                |   1 +
>>>> drivers/md/dm-raid.c       |   1 +
>>>> drivers/md/md-autodetect.c |   1 +
>>>> drivers/md/md-cluster.c    |   4 +-
>>>> drivers/md/md.c            |  76 ++++++++++++++++---------
>>>> drivers/md/md.h            |  16 ++++++
>>>> drivers/md/raid5-cache.c   |  40 +++++++------
>>>> drivers/md/raid5-log.h     |  77 ++++++++++++-------------
>>>> drivers/md/raid5-ppl.c     |   2 +-
>>>> drivers/md/raid5.c         | 646 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
>>>> 10 files changed, 549 insertions(+), 315 deletions(-)
>>>
>>> MAINTAINERS                      |   1 +
>>> drivers/block/drbd/drbd_bitmap.c |  49 +++-
>>> drivers/md/dm-raid.c             |   1 +
>>> drivers/md/md-autodetect.c       |   1 +
>>> drivers/md/md-cluster.c          |   4 +-
>>> drivers/md/md.c                  |  76 +++--
>>> drivers/md/md.h                  |  16 ++
>>> drivers/md/raid5-cache.c         |  40 ++-
>>> drivers/md/raid5-log.h           |  77 +++--
>>> drivers/md/raid5-ppl.c           |   2 +-
>>> drivers/md/raid5.c               | 654 +++++++++++++++++++++++++++---------------
>>> 11 files changed, 595 insertions(+), 326 deletions(-)
>>
>> TUrns out I pulled it into the wrong branch. But even after correcting
>> that, I now see:
>>
>> MAINTAINERS                |   1 +
>> drivers/md/dm-raid.c       |   1 +
>> drivers/md/md-autodetect.c |   1 +
>> drivers/md/md-cluster.c    |   4 +-
>> drivers/md/md.c            |  76 ++++--
>> drivers/md/md.h            |  16 ++
>> drivers/md/raid5-cache.c   |  40 ++-
>> drivers/md/raid5-log.h     |  77 +++---
>> drivers/md/raid5-ppl.c     |   2 +-
>> drivers/md/raid5.c         | 654 +++++++++++++++++++++++++++++++-----------------
>> 10 files changed, 553 insertions(+), 319 deletions(-)
>>
>> which is still off, with the discrepancy being in raid5.c?
> 
> Hmm... I just pulled your for-5.20/drivers branch again, and I am
> still getting the original diff:
> 
>  MAINTAINERS                |   1 +
>  drivers/md/dm-raid.c       |   1 +
>  drivers/md/md-autodetect.c |   1 +
>  drivers/md/md-cluster.c    |   4 +-
>  drivers/md/md.c            |  76 ++++++++++++-------
>  drivers/md/md.h            |  16 ++++
>  drivers/md/raid5-cache.c   |  40 +++++-----
>  drivers/md/raid5-log.h     |  77 +++++++++----------
>  drivers/md/raid5-ppl.c     |   2 +-
>  drivers/md/raid5.c         | 646 ++++++++++++++++++++++++++++++++++++++++++++++++++\
>        +++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------\
>        ----------------------------
>  10 files changed, 549 insertions(+), 315 deletions(-)
> 
> Is is because different git versions? My current version is git
> version 2.30.2. 

Oh, I think I may know what it is. It's the histrogram vs default diff.
I just checked the results and it looks fine. Sorry for the noise, there
was nothing wrong with your pull request! Now queued up.

-- 
Jens Axboe

