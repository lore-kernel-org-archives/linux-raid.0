Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F99FC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 08:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 655B563218
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 08:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhKOIJP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 03:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbhKOIIh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Nov 2021 03:08:37 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C0C061766
        for <linux-raid@vger.kernel.org>; Mon, 15 Nov 2021 00:05:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t30so28798804wra.10
        for <linux-raid@vger.kernel.org>; Mon, 15 Nov 2021 00:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=hZ/UThjHnd5E2V3Vzz8kSGTA8gZLVwKE/eYpSfxPKhs=;
        b=t959405z1AimouUbB5Cxm4di673xgPRKUS3giWUxq4HU67lMqUKsyjHCGQpfnLKaoh
         a1yL10NW3T7yAljV9FUrB4PE7FrvRswbEzsFZyiszz48ZPFeJg1v5nTgyGIIS6dUV5o5
         n8Xa33Um9lIGZj4iNym6vL/VM0rF2+2HAQukAtPPFbZxuUBki4eUd118fMyHjYCo1yhm
         JkhWuqMPiv6/7nKIjXTwtPMbaIoUnhrCv8PwFkOxoJx5g2oUla6KHDGscuwkrmAbtUJx
         UoNBQpXxPt8jjn0JgVpOkvJCMdrOnysD13UZr520dEw/xWoZL8Y17d/EtoONGRXR3TYX
         2NQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hZ/UThjHnd5E2V3Vzz8kSGTA8gZLVwKE/eYpSfxPKhs=;
        b=jSCRTgqlMSQbY87eisZ6fSYbplnoxbtxJpsd/AVQ4kQ+AIykGCoGRv/bFDITIAgL0C
         1l/U9PBVzLcBzmMkxvBmebvkn1f6pxZhsBrLf0jiNkgxXcvnAzDpWstoU+HWrQe7570e
         fLVJvbLM8RgcW8q48qfuOjkGcHEPbCsEbCuW7iPnMPGwJJQW8fXfB8ifTElPVpTimp9P
         Z6IcYXCM/fPeHg0p7Mq8IjZkAOkavTQrwDfgccXTkRb6FQ9qkqxHmdiGoxPesn6NNz8J
         e3v/MK6HivTSOBjtQQAaOP2K+oeUUAeoGk/X4IM5SsXNnfd+6GlmstwjXnBfpcBmxoGn
         oJpQ==
X-Gm-Message-State: AOAM533dchZisLjpxZvzvTLLgxVqQt7Ky7MOFPt6nzuTS3ZsfKKuNgNB
        nUK/yNrrPC847kcq+fm8wc/b7Q==
X-Google-Smtp-Source: ABdhPJwKGsRdrjI07xLGGq1s0bqYoTWIkRAyQjzqGgUHRnGEgjz7qqIXKGWHUHg0UDGO5J1tU3YW4w==
X-Received: by 2002:a5d:550c:: with SMTP id b12mr44816891wrv.427.1636963540668;
        Mon, 15 Nov 2021 00:05:40 -0800 (PST)
Received: from ?IPV6:2a10:800c:87bd:0:3adb:b326:abd4:3024? ([2a10:800c:87bd:0:3adb:b326:abd4:3024])
        by smtp.googlemail.com with ESMTPSA id p62sm12080637wmp.10.2021.11.15.00.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 00:05:40 -0800 (PST)
Message-ID: <78ccd535-29fa-9d03-0adc-746d1ed62373@scylladb.com>
Date:   Mon, 15 Nov 2021 10:05:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: raid0 vs io_uring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Linux-RAID <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <c978931b-d3ba-89c7-52ef-30eddf740ba6@scylladb.com>
 <ee22cbab-950f-cdb0-7ef0-5ea0fe67c628@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
In-Reply-To: <ee22cbab-950f-cdb0-7ef0-5ea0fe67c628@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/14/21 20:23, Jens Axboe wrote:
> On 11/14/21 10:07 AM, Avi Kivity wrote:
>> Running a trivial randread, direct=1 fio workload against a RAID-0
>> composed of some nvme devices, I see this pattern:
>>
>>
>>                fio-7066  [009]  1800.209865: function: io_submit_sqes
>>                fio-7066  [009]  1800.209866: function:
>> rcu_read_unlock_strict
>>                fio-7066  [009]  1800.209866: function:
>> io_submit_sqe
>>                fio-7066  [009]  1800.209866: function:
>> io_init_req
>>                fio-7066  [009]  1800.209866:
>> function:                      io_file_get
>>                fio-7066  [009]  1800.209866:
>> function:                         fget_many
>>                fio-7066  [009]  1800.209866:
>> function:                            __fget_files
>>                fio-7066  [009]  1800.209867:
>> function:                               rcu_read_unlock_strict
>>                fio-7066  [009]  1800.209867: function:
>> io_req_prep
>>                fio-7066  [009]  1800.209867:
>> function:                      io_prep_rw
>>                fio-7066  [009]  1800.209867: function:
>> io_queue_sqe
>>                fio-7066  [009]  1800.209867:
>> function:                      io_req_defer
>>                fio-7066  [009]  1800.209867:
>> function:                      __io_queue_sqe
>>                fio-7066  [009]  1800.209868:
>> function:                         io_issue_sqe
>>                fio-7066  [009]  1800.209868:
>> function:                            io_read
>>                fio-7066  [009]  1800.209868:
>> function:                               io_import_iovec
>>                fio-7066  [009]  1800.209868:
>> function:                               __io_file_supports_async
>>                fio-7066  [009]  1800.209868:
>> function:                                  I_BDEV
>>                fio-7066  [009]  1800.209868:
>> function:                               __kmalloc
>>                fio-7066  [009]  1800.209868:
>> function:                                  kmalloc_slab
>>                fio-7066  [009]  1800.209868: function: __cond_resched
>>                fio-7066  [009]  1800.209868: function:
>> rcu_all_qs
>>                fio-7066  [009]  1800.209869: function: should_failslab
>>                fio-7066  [009]  1800.209869:
>> function:                               io_req_map_rw
>>                fio-7066  [009]  1800.209869:
>> function:                         io_arm_poll_handler
>>                fio-7066  [009]  1800.209869:
>> function:                         io_queue_async_work
>>                fio-7066  [009]  1800.209869:
>> function:                            io_prep_async_link
>>                fio-7066  [009]  1800.209869:
>> function:                               io_prep_async_work
>>                fio-7066  [009]  1800.209870:
>> function:                            io_wq_enqueue
>>                fio-7066  [009]  1800.209870:
>> function:                               io_wqe_enqueue
>>                fio-7066  [009]  1800.209870:
>> function:                                  _raw_spin_lock_irqsave
>>                fio-7066  [009]  1800.209870: function:
>> _raw_spin_unlock_irqrestore
>>
>>
>>
>>   From which I deduce that __io_file_supports_async() (today named
>> __io_file_supports_nowait) returns false, and therefore every io_uring
>> operation is bounced to a workqueue with the resulting great loss in
>> performance.
>>
>>
>> However, I also see NOWAIT is part of the default set of flags:
>>
>>
>> #define QUEUE_FLAG_MQ_DEFAULT   ((1 << QUEUE_FLAG_IO_STAT) |            \
>>                                    (1 << QUEUE_FLAG_SAME_COMP) |          \
>>                                    (1 << QUEUE_FLAG_NOWAIT))
>>
>> and I don't see that md touches it (I do see that dm plays with it).
>>
>>
>> So, what's the story? does md not support NOWAIT? If so, that's a huge
>> blow to io_uring with md. If it does, are there any clues about why I
>> see requests bouncing to a workqueue?
> That is indeed the story, dm supports it but md doesn't just yet.


Ah, so I missed md clearing the default flags somewhere.


This is a false negative from io_uring's point of view, yes? An md on 
nvme would be essentially nowait in normal operation, it just doesn't 
know it. aio on the same device would not block on the same workload.


> It's
> being worked on right now, though:
>
> https://lore.kernel.org/linux-raid/20211101215143.1580-1-vverma@digitalocean.com/
>
> Should be pretty simple, and then we can push to -stable as well.
>

That's good to know.


