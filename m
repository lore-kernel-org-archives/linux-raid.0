Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A114DC47089
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 02:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E78E61358
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 02:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhE0CB4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 May 2021 22:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhE0CBz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 May 2021 22:01:55 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3B7C061574
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 19:00:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 29so2502960pgu.11
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 19:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=9kLrNiNyijqWApGzIXSaT3yILs5OhMbTu7tVWU+GYa4=;
        b=FubqouxLTeliYmKbHqm2ZBMTBNJ0ACzcRs2Kc0ixDZY30o1Svb/tpZuDcq+GcomFbX
         v6rfAhV5jGoThGdp3J4NiJ7sFlLeYu+d56+c5yjcsqqVI9s7LoWg/nUtm7sw3ArHs9zo
         QC9ESiYK7D/VdC2d6ldtYrtbSDvauv4cPslPCsLYcXW0gLuyn9eso0447SMn3+Wjj3fI
         gegA8BFrzunWqE2EKzw1wqiSqaXrfBnMW5SWaCBLB33LB8JPXh0kODVkc+da20xzGKyr
         G+xyxOJjjatqand8z0CIZaKEps3OdKXAv5KtKU7sVI0gIEZZRbJ8wFzYeTLo4ydKgix8
         S5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9kLrNiNyijqWApGzIXSaT3yILs5OhMbTu7tVWU+GYa4=;
        b=Lee+5uM7AQtgW8UL6HESPKAYRqPPHydbf2kbbpIpN7wAnx79RO8C6uLc2ktrh8Jfxp
         dI0qvg3vR+z3zG443/Vx+BSvryQgAyhrJcyQ8zgjTlSUoCnchlTp5BQdX3JiF6oaCERl
         sOORVZ5DDW4IYfSBQgqUHePAwxJG3uW7XkiEFZ21ASv+yHHr5LDjHIhpA6u+GdBcYdmd
         6N9h/1Aoq3NgzsJpfK51FFsR+PyhYo0cY2wXQ5QJq9U2W4K0HCNRzt8Db0tJOyC1AKQH
         z4OBedNHkIE/nHoD9rdwu5l+yy7maH9u9cO1XgViJ5cFv4Mkesq1U2XeFQ66JSKY6rax
         geoA==
X-Gm-Message-State: AOAM531N/56DMfAiDi7v2VmrRziRUDb3Y+2vIUL51xXWaWKw7+7EY2hP
        5t0UMcSc/IBrS1u/SitMkVQ=
X-Google-Smtp-Source: ABdhPJxtuftsYiVR3HMEkcDOsEpK5CelpB8f4Mc+NeMQPYJPWn5QonM0VVPeuqRLfzTiOC/9im1IxA==
X-Received: by 2002:a63:1349:: with SMTP id 9mr1454608pgt.235.1622080816084;
        Wed, 26 May 2021 19:00:16 -0700 (PDT)
Received: from [10.6.1.163] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id p16sm300601pgl.60.2021.05.26.19.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 19:00:15 -0700 (PDT)
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210525094623.763195-3-jiangguoqing@kylinos.cn>
 <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
 <a2342aab-28da-64a2-9591-bc7b482e1751@gmail.com>
 <CAPhsuW7Xz6nOPFsn64qLhvDtNGDGX6Pf_U3Tb=d0KiL4+9_h=Q@mail.gmail.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <20118145-e993-b11f-8907-5e2f1cc44ddb@gmail.com>
Date:   Thu, 27 May 2021 10:00:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7Xz6nOPFsn64qLhvDtNGDGX6Pf_U3Tb=d0KiL4+9_h=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/27/21 12:00 AM, Song Liu wrote:
> On Wed, May 26, 2021 at 12:53 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>>
>>
>> On 5/26/21 2:32 PM, Song Liu wrote:
>>> On Tue, May 25, 2021 at 2:47 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>>>
>>>
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -2340,7 +2340,8 @@ int md_integrity_register(struct mddev *mddev)
>>>>                                  bdev_get_integrity(reference->bdev));
>>>>
>>>>           pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
>>>> -       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
>>>> +       if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
>>>> +           bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE)) {
>>> Added better error handling here.
>> No need to do it here, because md_integrity_register is called from
>> md_run() -> pers->run(), if above returns failure, then the path
>> (bioset_exit -> bioset_integrity_free) is triggered.
>>
>> I thought we probably need a comment here given it is not explicit.
> I think it is better to handle it within this function. Does it have
> any downside
> to call bioset_integrity_free(&mddev->bio_set) here?
>
> [...]

md_run has to deal with failure path by call bioset_exit, which
already call bioset_integrity_free implicitly. Why the additional
call of bioset_integrity_free would be helpful? Or do you want
to remove bioset_exit from md_run as well?

>>>> +
>>>> +       if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
>>>> +               return;
>>> Added blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue); to md_run.
>>> We still need it as md doesn't use mq. Without it, the default iostats is 0.
>>>
>> It enables io accounting by default, so raid5 and raid0 users have to
>> disable it if they don't want the additional latency.
> iostats was on by default before this set, as we didn't check
> blk_queue_io_stat().
> So it is better to keep the same behavior.

Could you point the place where md enables iostats before the set?
I can't find relevant code for it.

Thanks,
Guoqing
