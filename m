Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5121C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 26 Dec 2021 04:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhLZEC6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Dec 2021 23:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhLZEC5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Dec 2021 23:02:57 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB592C061401
        for <linux-raid@vger.kernel.org>; Sat, 25 Dec 2021 20:02:57 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g22so10724047pgn.1
        for <linux-raid@vger.kernel.org>; Sat, 25 Dec 2021 20:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=A3dRRFV820KSPZkxolG0wsSoXkQ+KKYn9JTyECk4wfk=;
        b=haeH6g5BMs3ERUR5t3UH/I2HV1MXcRQ7cvAnvbaK7grp8u8Bhk27ATgcB2efgCQojd
         0CsSV8wvqIVj/LzHNmpeeBFcYnU1Z/wJnVMwvjdxXuVJItzD1O8QSainLvAQ2NYw44Jc
         dAlNxrSPLg8M83+DJ55yPUnohFrRoOPBXLMFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=A3dRRFV820KSPZkxolG0wsSoXkQ+KKYn9JTyECk4wfk=;
        b=gDFrlRAGerv7+nW8Jd+mc3QYsdXYTPo3F3bfD2VB1LI82WuVp4UnbbGjVjGDVtPbSX
         S6MNekHXEH580OwBgc5HNPAvdvoWbcGfyrR3al6CO7KgAgUL9I53xVve1UvnO8/ju6oK
         lBm7v1zEA+Zk2eAAv6v1mS6F1JiRwV9YgJQfFjeuFw6nkCXIv/IiIAwPXQh8xPRvXVAk
         L8RR6AB7WLZvRNhrETnWmdqGQ/OIdl6F+wEopB3welFLVUikcFRQ68aqoy34A525iUNq
         mCP1jaWyScVT7acLmIEq22plU4qokkIlpV42lEsaInxGTYmt6WFGimBQm4PUlzCLFmx2
         L6Uw==
X-Gm-Message-State: AOAM531yJKzqvdEoH7ea1tHI2TjXjY3m6WYIRMSUt5YaibFDFcrtZOaB
        YCyBqMstlESYcBhR+a+ESwNN0A==
X-Google-Smtp-Source: ABdhPJx1FNY9hTTO/9AgkOJkjmN1GyRUubDbFId+LgTDlsI5UgR4SKbdKoD1u801vhUJFqitB8H4Nw==
X-Received: by 2002:a05:6a00:114d:b0:4a2:87bd:37f with SMTP id b13-20020a056a00114d00b004a287bd037fmr12716602pfm.82.1640491377222;
        Sat, 25 Dec 2021 20:02:57 -0800 (PST)
Received: from [192.168.1.4] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id il18sm16310184pjb.37.2021.12.25.20.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Dec 2021 20:02:56 -0800 (PST)
Message-ID: <b80a0898-af7f-ec1b-9f4e-6d24cdb2e38a@digitalocean.com>
Date:   Sat, 25 Dec 2021 21:02:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v6 4/4] md: raid456 add nowait support
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
 <20211221200622.29795-4-vverma@digitalocean.com>
 <CAPhsuW6ugK+6fcA9d4Jkx8+i9=1cMfrfJE7ZY4WH6TKrWLxP=g@mail.gmail.com>
 <aadc6d52-bc6e-527a-3b9c-0be225f9b727@digitalocean.com>
 <3306ef8e-88e0-74ec-4f7f-efca2605fc24@digitalocean.com>
 <CAPhsuW5m69F19w85N67WGSZfTgPfkgQv0zhYk7uGXwzkoAJh_w@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW5m69F19w85N67WGSZfTgPfkgQv0zhYk7uGXwzkoAJh_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/25/21 5:07 PM, Song Liu wrote:
> On Sat, Dec 25, 2021 at 2:13 PM Vishal Verma <vverma@digitalocean.com> wrote:
>>
>> On 12/25/21 12:28 AM, Vishal Verma wrote:
>>>
>>> On 12/24/21 7:14 PM, Song Liu wrote:
>>>> On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma<vverma@digitalocean.com>  wrote:
>>>>> Returns EAGAIN in case the raid456 driver would block
>>>>> waiting for situations like:
>>>>>
>>>>>     - Reshape operation,
>>>>>     - Discard operation.
>>>>>
>>>>> Signed-off-by: Vishal Verma<vverma@digitalocean.com>
>>>> I think we will need the following fix for raid456:
>>> Ack
>>>> ============================ 8< ============================
>>>>
>>>> diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
>>>> index 6ab22f29dacd..55d372ce3300 100644
>>>> --- i/drivers/md/raid5.c
>>>> +++ w/drivers/md/raid5.c
>>>> @@ -5717,6 +5717,7 @@ static void make_discard_request(struct mddev
>>>> *mddev, struct bio *bi)
>>>>                           raid5_release_stripe(sh);
>>>>                           /* Bail out if REQ_NOWAIT is set */
>>>>                           if (bi->bi_opf & REQ_NOWAIT) {
>>>> +                               finish_wait(&conf->wait_for_overlap, &w);
>>>>                                   bio_wouldblock_error(bi);
>>>>                                   return;
>>>>                           }
>>>> @@ -5734,6 +5735,7 @@ static void make_discard_request(struct mddev
>>>> *mddev, struct bio *bi)
>>>>                                   raid5_release_stripe(sh);
>>>>                                   /* Bail out if REQ_NOWAIT is set */
>>>>                                   if (bi->bi_opf & REQ_NOWAIT) {
>>>> +
>>>> finish_wait(&conf->wait_for_overlap, &w);
>>>>                                           bio_wouldblock_error(bi);
>>>>                                           return;
>>>>                                   }
>>>> @@ -5829,7 +5831,6 @@ static bool raid5_make_request(struct mddev
>>>> *mddev, struct bio * bi)
>>>>           last_sector = bio_end_sector(bi);
>>>>           bi->bi_next = NULL;
>>>>
>>>> -       md_account_bio(mddev, &bi);
>>>>           /* Bail out if REQ_NOWAIT is set */
>>>>           if ((bi->bi_opf & REQ_NOWAIT) &&
>>>>               (conf->reshape_progress != MaxSector) &&
>>>> @@ -5837,9 +5838,11 @@ static bool raid5_make_request(struct mddev
>>>> *mddev, struct bio * bi)
>>>>               ? (logical_sector > conf->reshape_progress &&
>>>> logical_sector <= conf->reshape_safe)
>>>>               : (logical_sector >= conf->reshape_safe && logical_sector
>>>> < conf->reshape_progress))) {
>>>>                   bio_wouldblock_error(bi);
>>>> +               if (rw == WRITE)
>>>> +                       md_write_end(mddev);
>>>>                   return true;
>>>>           }
>>>> -
>>>> +       md_account_bio(mddev, &bi);
>>>>           prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>>>>           for (; logical_sector < last_sector; logical_sector +=
>>>> RAID5_STRIPE_SECTORS(conf)) {
>>>>                   int previous;
>>>>
>>>> ============================ 8< ============================
>>>>
>>>> Vishal, please try to trigger all these conditions (including raid1,
>>>> raid10) and make sure
>>>> they work properly.
>>>>
>>>> For example, I triggered raid5 reshape and used something like the
>>>> following to make
>>>> sure the logic is triggered:
>>>>
>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> index 55d372ce3300..e79de48a0027 100644
>>>> --- a/drivers/md/raid5.c
>>>> +++ b/drivers/md/raid5.c
>>>> @@ -5840,6 +5840,11 @@ static bool raid5_make_request(struct mddev
>>>> *mddev, struct bio * bi)
>>>>                   bio_wouldblock_error(bi);
>>>>                   if (rw == WRITE)
>>>>                           md_write_end(mddev);
>>>> +               {
>>>> +                       static int count = 0;
>>>> +                       if (count++ < 10)
>>>> +                               pr_info("%s REQ_NOWAIT return\n", __func__);
>>>> +               }
>>>>                   return true;
>>>>           }
>>>>           md_account_bio(mddev, &bi);
>>>>
>>>> Thanks,
>>>> Song
>>>>
>>> Sure, will try this and verify for raid1/10.
> Please also try test raid5 with discard. I haven't tested those two
> conditions yet.
Ack.
>
>> I am running into an issue during raid10 reshape. I can see the nowait
>> code getting triggered during reshape, but it seems like the reshape
>> operation was stuck as soon as I issued write IO using FIO to the array
>> during reshape.
>> FIO also seem stuck i.e no IO went through...
> Maybe the following could fix it?
>
> Thanks,
> Song
Hmm no luck, still the same issue.
> diff --git i/drivers/md/raid10.c w/drivers/md/raid10.c
> index e2c524d50ec0..291eceaeb26c 100644
> --- i/drivers/md/raid10.c
> +++ w/drivers/md/raid10.c
> @@ -1402,14 +1402,14 @@ static void raid10_write_request(struct mddev
> *mddev, struct bio *bio,
>               : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
>                  bio->bi_iter.bi_sector < conf->reshape_progress))) {
>                  /* Need to update reshape_position in metadata */
> -               mddev->reshape_position = conf->reshape_progress;
> -               set_mask_bits(&mddev->sb_flags, 0,
> -                             BIT(MD_SB_CHANGE_DEVS) |
> BIT(MD_SB_CHANGE_PENDING));
> -               md_wakeup_thread(mddev->thread);
>                  if (bio->bi_opf & REQ_NOWAIT) {
>                          bio_wouldblock_error(bio);
>                          return;
>                  }
> +               mddev->reshape_position = conf->reshape_progress;
> +               set_mask_bits(&mddev->sb_flags, 0,
> +                             BIT(MD_SB_CHANGE_DEVS) |
> BIT(MD_SB_CHANGE_PENDING));
> +               md_wakeup_thread(mddev->thread);
>                  raid10_log(conf->mddev, "wait reshape metadata");
>                  wait_event(mddev->sb_wait,
>                             !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
