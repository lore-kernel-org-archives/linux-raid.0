Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4C1C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jul 2022 16:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiGCQCL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 12:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiGCQCG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 12:02:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9894C25E1
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 09:02:04 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w24so7104517pjg.5
        for <linux-raid@vger.kernel.org>; Sun, 03 Jul 2022 09:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8VykbU35U1O8dMCegrkT1wRrUhDzpbZrJ4wCebBi9qY=;
        b=3fq1Z43fe31nQ6dQ/qDRsnl8CGa3zbCC696DdZqM4uJ/IDaPOHDwfGAK0VvR+Zp199
         2K8QfI+eqOexO0KhbXD0aNXoXoCLJLgBIHrQ7dgDpA/i2kR/uhOf+pRc3+ehU+9C3FYp
         lagty+BBXJpa+ziqjSiM+RvK6bCLfj/hes2PiNchG9ect3h6kPJc/HM033lYaH/Qdo8f
         495nBSlFPc9NIwSYZ/kH0OaSNsO/Mef4qaAnYJUFdxmlGeZFUBkaUY8OPs/oM0JudM6Q
         4XFAz/mWpapw+5PPamepkDADvMarVNSERxO1u2hItZnRtPVATCBYzmZ7mpFthbjJp3zR
         APIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8VykbU35U1O8dMCegrkT1wRrUhDzpbZrJ4wCebBi9qY=;
        b=PnqwaHEiXr9uY+vFyPpQaie97jZ2bxVFGX5tPE/QEYxJ5Jsd1H6zWa1IzuR9FgNFq5
         FCGawGzZO9e4YAcwMMR6ZRQ8+udHcJ1IxZf3LHBHeR+JkQdGDX6mUAJanURZYuLXACsY
         Qq0389NPi/MRqa9UH+cw2MIV8MqtjukuBc6U3Qp2nrIbVnH/vvtPzM4zZSKBKBGee8s8
         zpcaC3vgUy2nJLUdfI2olmdNxWNwBzqK5821RRPYNq+Ht8JR9DGP/4JmZN67zAtMtasL
         /uB7kWKdy/H7OHRhhchAfbGGQis8kKhs4dI9EIjQ5w1b0zaD8l/f/DGD3gvPwlzcH2oD
         qJ2A==
X-Gm-Message-State: AJIora9mwBWrk89raPnppflijmnx1xbFrwMv7uLHcu/q6HDuUeSwnC3H
        mQTqkt9cE5bTgswRY5QkW4sCYqBrwwbigw==
X-Google-Smtp-Source: AGRyM1upvuqzL+6wT7ktRqEGt2DxzH9NAyTvYOuAAS7aPaPDp7mbjcidxABDs4PjZ11I6FhlVrtRFA==
X-Received: by 2002:a17:90a:73c5:b0:1ef:880f:fe95 with SMTP id n5-20020a17090a73c500b001ef880ffe95mr500477pjk.95.1656864123870;
        Sun, 03 Jul 2022 09:02:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q6-20020a63cc46000000b0040d287f1378sm18775723pgi.7.2022.07.03.09.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 09:02:03 -0700 (PDT)
Message-ID: <d76ca8b8-b827-4928-6286-47a0dbb6de25@kernel.dk>
Date:   Sun, 3 Jul 2022 10:02:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220703
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <jgq516@gmail.com>,
        Chris Webb <chris@arachsys.com>,
        Zhang Jiaming <jiaming@nfschina.com>
References: <9727B564-F3B3-4CB1-A609-01AAD3C193F6@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9727B564-F3B3-4CB1-A609-01AAD3C193F6@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/3/22 9:13 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your for-5.20/drivers
> branch. The major changes are:
> 
> 1. Improve raid5 lock contention, by Logan Gunthorpe.
> 2. Misc fixes to raid5, by Logan Gunthorpe.
> 3. Fix race condition with md_reap_sync_thread(), by Guoqing Jiang.
> 

I pulled this in, but what I pulled doesn't match this pull request.
There seems to be an extra patch in there, and diffstat doesn't match
what is in your email:

>  MAINTAINERS                |   1 +
>  drivers/md/dm-raid.c       |   1 +
>  drivers/md/md-autodetect.c |   1 +
>  drivers/md/md-cluster.c    |   4 +-
>  drivers/md/md.c            |  76 ++++++++++++++++---------
>  drivers/md/md.h            |  16 ++++++
>  drivers/md/raid5-cache.c   |  40 +++++++------
>  drivers/md/raid5-log.h     |  77 ++++++++++++-------------
>  drivers/md/raid5-ppl.c     |   2 +-
>  drivers/md/raid5.c         | 646 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------
>  10 files changed, 549 insertions(+), 315 deletions(-)

 MAINTAINERS                      |   1 +
 drivers/block/drbd/drbd_bitmap.c |  49 +++-
 drivers/md/dm-raid.c             |   1 +
 drivers/md/md-autodetect.c       |   1 +
 drivers/md/md-cluster.c          |   4 +-
 drivers/md/md.c                  |  76 +++--
 drivers/md/md.h                  |  16 ++
 drivers/md/raid5-cache.c         |  40 ++-
 drivers/md/raid5-log.h           |  77 +++--
 drivers/md/raid5-ppl.c           |   2 +-
 drivers/md/raid5.c               | 654 +++++++++++++++++++++++++++---------------
 11 files changed, 595 insertions(+), 326 deletions(-)

-- 
Jens Axboe

