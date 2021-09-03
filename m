Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DA0C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 02:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21BE60F3A
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 02:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbhICC5F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Sep 2021 22:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhICC5E (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Sep 2021 22:57:04 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C07BC061575
        for <linux-raid@vger.kernel.org>; Thu,  2 Sep 2021 19:56:05 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a15so5133229iot.2
        for <linux-raid@vger.kernel.org>; Thu, 02 Sep 2021 19:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oEMteyWEUVn7e+xXFPrS5AZWLYUCG4YT0odxQJYwUuo=;
        b=tDLGfhPmwG4isfvy+/g+GwWUnqkzyFTifx3eR0b9Di3PORXFtglQMTA8yYD62aF6lK
         H/f2mCD+RT0R3ZfVmFpV/fla3Ebz000X6Fo4IaNyT+dxkk+c0LdokbTxwCA9jVZfuVSM
         Gz3d/KRqjghi4/QJ3rNnDcqt7CFLogb37I5CqR+Tv9XXRqFMpXNfDZl78cwBA+MIZjeM
         XZIhePxsxR+w+TjpoQblyX4+PMLvrXLr3jcG4SIF/O5iTJstjKqh3xITD7TzWoxoFLOC
         d2HSIGN9huFmJMp5PbN0/CnP0yiK4lYwAe6dMjjmUh9vVm1O3T9dYAj6o7jipIMseqAa
         dZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oEMteyWEUVn7e+xXFPrS5AZWLYUCG4YT0odxQJYwUuo=;
        b=Zoilsc16avcb6/n5FwXkaSZQk7YvE5YPvyfehEmykIqDY5iJ+Effl9RGVZAL1Lp1lU
         5p7dm60YjCLnowMe00iQOVr7m7ugOi4v+gp0wIYvJxayTp29SzSmZtctsJXd41guGvtz
         sT78U2lLawmZpu7eiaoKTIg2IFdAxQZVxv3cHjEvzsgcXaoeeFuXe3CITbfPDa6nb9ne
         FK4M9OB93Ma29W/q4ZgNpqcAy4f9njIOQs4Hct/Yh4cSRCL43Rxe141yjpIqG3r5ufiH
         L/XWZK+LT8cepQ+4++D2eaxW4IBF6GIq1yLQOVwd0OK8QE8PmrOVcIB1hc/zB8Xy3AaN
         4Bkw==
X-Gm-Message-State: AOAM533N3vXq1GmKmrBJSmDX6TJF0kF6PVe0XLRKNXY5OVH7BcM1OcxY
        QgcOJCgVFuzZ7f0DJFXpdS8nRr7722FQHQ==
X-Google-Smtp-Source: ABdhPJwmNxrUeYAjQiZhO4w+pa5a21DC63XM2znsaUngseyaPXD3JHXdNVHjfH2mFrgIi0slienrIQ==
X-Received: by 2002:a5e:a813:: with SMTP id c19mr1250087ioa.199.1630637764431;
        Thu, 02 Sep 2021 19:56:04 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s12sm2002406ilo.0.2021.09.02.19.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 19:56:03 -0700 (PDT)
Subject: Re: Slow initial resync in RAID6 with 36 SAS drives
To:     Song Liu <song@kernel.org>, Marcin Wanat <marcin.wanat@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
 <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com>
 <CAPhsuW491s_6pEYRxHphgSAPVta=qPrsKXONvq03Xxv71BVx2g@mail.gmail.com>
 <CAPhsuW7R=8XyU5wU1-NT-Eo=Hir7gV_b7+_MB+bUFx3bEecbDw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aa6b7483-e7a9-b272-a34d-06ad73a40d57@kernel.dk>
Date:   Thu, 2 Sep 2021 20:56:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7R=8XyU5wU1-NT-Eo=Hir7gV_b7+_MB+bUFx3bEecbDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/2/21 6:58 PM, Song Liu wrote:
> On Tue, Aug 31, 2021 at 10:19 PM Song Liu <song@kernel.org> wrote:
>>
>> On Wed, Aug 25, 2021 at 3:06 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
>>>
>>> On Thu, Aug 19, 2021 at 11:28 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
>>>>
>>>> Sorry, this will be a long email with everything I find to be relevant.
>>>> I have a mdraid6 array with 36 hdd SAS drives each able to do
>>>>> 200MB/s, but I am unable to get more than 38MB/s resync speed on a
>>>> fast system (48cores/96GB ram) with no other load.
>>>
>>> I have done a bit more research on 24 NVMe drives server and found
>>> that resync speed bottleneck affect RAID6 with >16 drives:
>>
>> Sorry for the late response.
>>
>> This is interesting behavior. I don't really know why this is the case at the
>> moment. Let me try to reproduce this first.
>>
>> Thanks,
>> Song
> 
> The issue is caused by blk_plug logic. Something like the following should
> fix it.
> 
> Marcin, could you please give it a try?
> 
> Thanks,
> Song
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2c4ac51e54eba..fdb945be85753 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2251,7 +2251,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
>                 else
>                         last = list_entry_rq(plug->mq_list.prev);
> 
> -               if (request_count >= BLK_MAX_REQUEST_COUNT || (last &&
> +               if (request_count >= blk_plug_max_rq_count(plug) || (last &&
>                     blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
>                         blk_flush_plug_list(plug, false);
>                         trace_block_plug(q);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b5c033cf5f26f..2e3c07e959c14 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1239,6 +1239,13 @@ extern void blk_start_plug(struct blk_plug *);
>  extern void blk_finish_plug(struct blk_plug *);
>  extern void blk_flush_plug_list(struct blk_plug *, bool);
> 
> +static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
> +{
> +       if (plug->multiple_queues)
> +               return BLK_MAX_REQUEST_COUNT * 4;
> +       return BLK_MAX_REQUEST_COUNT;
> +}
> +
>  static inline void blk_flush_plug(struct task_struct *tsk)
>  {
>         struct blk_plug *plug = tsk->plug;

Just put this in blk-mq.c, there's no reason to put this in blkdev.h. It
could go in block/blk.h, but let's just put it where it's used for now.

Should also have a comment on why we allow more for multiple_queues.

That said, the principle is sound imho.

-- 
Jens Axboe

