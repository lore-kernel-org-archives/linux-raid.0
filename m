Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D88DC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 18:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245315AbhLJSac (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 13:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245313AbhLJSab (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Dec 2021 13:30:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC38C061746
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 10:26:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so8195015pjq.4
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 10:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=J8RFAv0KM8C6o7z1L1AOzWRgRuIdvw1VGdkz4cyIXqs=;
        b=e0iub+lSATOrRBRcHOzKVlH49Agqtxjf4tEQJunBagOFMf/roWo/ytbwKj/smG+bIR
         7tOaiFnLK5xSlmYFA5MwnR7v+/KRn+odhpe04wmpRY2iXEll/YW442dmRN/c4C4kaV9p
         wgTpgFRTwUYjrNN/MRx7Smaj243zF5m9sE5Dk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J8RFAv0KM8C6o7z1L1AOzWRgRuIdvw1VGdkz4cyIXqs=;
        b=bMCzOeWfyD7yeUH6QB9wEDIX5T2MkRREoNeWqrFBhbFNREqGv3WzwDh9mZ/LJ+15HZ
         3jMuxuCXFBuWg6t0PTY3HmJ/PQnQNBrDKbpK69oZxneu83f8w3MG3rwjV50DhYT0hgtL
         /K4bVq/RZkbThrroFW1o7gy3IrA+SyzHazHevdOcH4yjmfp6FM4+UoWl2xaDWbnU2z61
         RX6PRQOxnVV1Oc89TIxMrJSnY335/abqI+pG3z7VOYBIRNg2Rv9ivk6doA/jpYcoJiau
         gHv9+uKry5S7dexOGvkxob1Zm62TAuYzMUd14mFZA+wl+FW0VuJurvGQvz8AsITki++5
         KomQ==
X-Gm-Message-State: AOAM533Jdl9IIRqdNC230ILgMrN/y1sZ8KDVr1l8dhmIfR1ZF1N4VbpW
        eQ0uCzoHrXcBkDEr26f4fi3VORWISPD31A==
X-Google-Smtp-Source: ABdhPJzQxkml5xc87reJxxErluI2gzhLE3H2tTYAqtKanj4d+6+5DGmFknK7OSPU45L8t883IVuwKw==
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id w3-20020a170902d70300b00144e012d550mr76152293ply.38.1639160816014;
        Fri, 10 Dec 2021 10:26:56 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id w1sm4093545pfg.11.2021.12.10.10.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 10:26:55 -0800 (PST)
Message-ID: <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com>
Date:   Fri, 10 Dec 2021 11:26:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
 <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/9/21 7:16 PM, Song Liu wrote:
> On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
>> Returns EAGAIN in case the raid456 driver would block
>> waiting for situations like:
>>
>>    - Reshape operation,
>>    - Discard operation.
>>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>> ---
>>   drivers/md/raid5.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 9c1a5877cf9f..fa64ee315241 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>>                  int d;
>>          again:
>>                  sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
>> +               /* Bail out if REQ_NOWAIT is set */
>> +               if (bi->bi_opf & REQ_NOWAIT) {
>> +                       bio_wouldblock_error(bi);
>> +                       return;
>> +               }
> This is not right. raid5_get_active_stripe() gets refcount on the sh,
> we cannot simply
> return here. I think we need the logic after raid5_release_stripe()
> and before schedule().
>
>>                  prepare_to_wait(&conf->wait_for_overlap, &w,
>>                                  TASK_UNINTERRUPTIBLE);
>>                  set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
>> @@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>          bi->bi_next = NULL;
>>
>>          md_account_bio(mddev, &bi);
>> +       /* Bail out if REQ_NOWAIT is set */
>> +       if (bi->bi_opf & REQ_NOWAIT &&
>> +           conf->reshape_progress != MaxSector &&
>> +           mddev->reshape_backwards
>> +           ? logical_sector < conf->reshape_safe
>> +           : logical_sector >= conf->reshape_safe) {
>> +               bio_wouldblock_error(bi);
>> +               return true;
>> +       }
> This is also problematic, and is the trigger of those error messages.
> We only want to trigger -EAGAIN when logical_sector is between
> reshape_progress and reshape_safe.
>
> Just to clarify, did you mean doing something like:
> if (bi->bi_opf & REQ_NOWAIT &&
> +           conf->reshape_progress != MaxSector &&
> +           (mddev->reshape_backwards
> +           ? (logical_sector > conf->reshape_progress && logical_sector < conf->reshape_safe)
> +           : logical_sector >= conf->reshape_safe)) {
> +               bio_wouldblock_error(bi);
> +               return true;
> +
>
> Please let me know if these make sense.
>
> Thanks,
> Song
>
>
> Makes sense. Thanks for your feedback. I'll incorporate it and test.
