Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E02C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 25 Dec 2021 22:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhLYWNl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Dec 2021 17:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhLYWNl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Dec 2021 17:13:41 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0159C061401
        for <linux-raid@vger.kernel.org>; Sat, 25 Dec 2021 14:13:40 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p14so8792470plf.3
        for <linux-raid@vger.kernel.org>; Sat, 25 Dec 2021 14:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=F81TmucoZrB2PqT69PL6wm//9IYHGamv+z7UNVc2SO4=;
        b=LeBAnCuvIOndxxBpg8EpKe2B/XxaevPM1fwpZ1AoKGKDnbL7MuLrmkXFQYUr/17UOA
         xrTcYe6Bvv+yU9tEK4cD7xAiYr3NCP7M+1I51WoWx6LWqYypgoAiBMrVvHdBa4jD3bcK
         QiaE1DauRqqqSSwkrJKg1guO9XIc07uVr+wT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=F81TmucoZrB2PqT69PL6wm//9IYHGamv+z7UNVc2SO4=;
        b=1CAlLdeCU0buAa15j5S63KU+BUFj+3/5B+PDMH+7KovuBjQg4WVX2x3IgXdcAPLO/G
         cIqb745Yj+N2h0Vqn+m8HRn1J4i2v4pE490tefuTAkVCmhkt+3UMHHro5xNkb6fB6FUV
         c7FdV7g4EFNOyVrCWC7iWt9Hvr0s1JVUYvieTiaAi6EKgLUfpaQ3fFbvJkUSMYspnZdB
         LsxlbvyZeGU3yhNu8+lKWhKEhtChsfL3jiG9JnlAgkos+/TEB2wG7d+8cxZm0PWYDgvM
         lPgmJDe2o97HvXUOYoU3qrPs0sW9i1jDdDN0G/JfGO72jVmHg7TDhIhXrlNrFde+2jhi
         hy1w==
X-Gm-Message-State: AOAM530is/5WRIZdxwkvFrBfHDPGW3sc12iu/aDkREh7VZUWsLwzrBRT
        jz/b4ojfQX/CBSgk8KMuGWLKgQ==
X-Google-Smtp-Source: ABdhPJyYqgB82DLACTa6OX9dIVkBH+7Fh7Vv5Q5o/AK2q9kYbq/fvqEqYw3obP/dbjMrzgS2RvZaig==
X-Received: by 2002:a17:902:f242:b0:148:b5e5:22c7 with SMTP id j2-20020a170902f24200b00148b5e522c7mr11611731plc.119.1640470419331;
        Sat, 25 Dec 2021 14:13:39 -0800 (PST)
Received: from [192.168.1.4] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id j13sm13197329pfu.22.2021.12.25.14.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Dec 2021 14:13:38 -0800 (PST)
Message-ID: <3306ef8e-88e0-74ec-4f7f-efca2605fc24@digitalocean.com>
Date:   Sat, 25 Dec 2021 15:13:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v6 4/4] md: raid456 add nowait support
From:   Vishal Verma <vverma@digitalocean.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
 <20211221200622.29795-4-vverma@digitalocean.com>
 <CAPhsuW6ugK+6fcA9d4Jkx8+i9=1cMfrfJE7ZY4WH6TKrWLxP=g@mail.gmail.com>
 <aadc6d52-bc6e-527a-3b9c-0be225f9b727@digitalocean.com>
In-Reply-To: <aadc6d52-bc6e-527a-3b9c-0be225f9b727@digitalocean.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/25/21 12:28 AM, Vishal Verma wrote:
>
>
> On 12/24/21 7:14 PM, Song Liu wrote:
>> On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma<vverma@digitalocean.com>  wrote:
>>> Returns EAGAIN in case the raid456 driver would block
>>> waiting for situations like:
>>>
>>>    - Reshape operation,
>>>    - Discard operation.
>>>
>>> Signed-off-by: Vishal Verma<vverma@digitalocean.com>
>> I think we will need the following fix for raid456:
> Ack
>> ============================ 8< ============================
>>
>> diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
>> index 6ab22f29dacd..55d372ce3300 100644
>> --- i/drivers/md/raid5.c
>> +++ w/drivers/md/raid5.c
>> @@ -5717,6 +5717,7 @@ static void make_discard_request(struct mddev
>> *mddev, struct bio *bi)
>>                          raid5_release_stripe(sh);
>>                          /* Bail out if REQ_NOWAIT is set */
>>                          if (bi->bi_opf & REQ_NOWAIT) {
>> +                               finish_wait(&conf->wait_for_overlap, &w);
>>                                  bio_wouldblock_error(bi);
>>                                  return;
>>                          }
>> @@ -5734,6 +5735,7 @@ static void make_discard_request(struct mddev
>> *mddev, struct bio *bi)
>>                                  raid5_release_stripe(sh);
>>                                  /* Bail out if REQ_NOWAIT is set */
>>                                  if (bi->bi_opf & REQ_NOWAIT) {
>> +
>> finish_wait(&conf->wait_for_overlap, &w);
>>                                          bio_wouldblock_error(bi);
>>                                          return;
>>                                  }
>> @@ -5829,7 +5831,6 @@ static bool raid5_make_request(struct mddev
>> *mddev, struct bio * bi)
>>          last_sector = bio_end_sector(bi);
>>          bi->bi_next = NULL;
>>
>> -       md_account_bio(mddev, &bi);
>>          /* Bail out if REQ_NOWAIT is set */
>>          if ((bi->bi_opf & REQ_NOWAIT) &&
>>              (conf->reshape_progress != MaxSector) &&
>> @@ -5837,9 +5838,11 @@ static bool raid5_make_request(struct mddev
>> *mddev, struct bio * bi)
>>              ? (logical_sector > conf->reshape_progress &&
>> logical_sector <= conf->reshape_safe)
>>              : (logical_sector >= conf->reshape_safe && logical_sector
>> < conf->reshape_progress))) {
>>                  bio_wouldblock_error(bi);
>> +               if (rw == WRITE)
>> +                       md_write_end(mddev);
>>                  return true;
>>          }
>> -
>> +       md_account_bio(mddev, &bi);
>>          prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>>          for (; logical_sector < last_sector; logical_sector +=
>> RAID5_STRIPE_SECTORS(conf)) {
>>                  int previous;
>>
>> ============================ 8< ============================
>>
>> Vishal, please try to trigger all these conditions (including raid1,
>> raid10) and make sure
>> they work properly.
>>
>> For example, I triggered raid5 reshape and used something like the
>> following to make
>> sure the logic is triggered:
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 55d372ce3300..e79de48a0027 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5840,6 +5840,11 @@ static bool raid5_make_request(struct mddev
>> *mddev, struct bio * bi)
>>                  bio_wouldblock_error(bi);
>>                  if (rw == WRITE)
>>                          md_write_end(mddev);
>> +               {
>> +                       static int count = 0;
>> +                       if (count++ < 10)
>> +                               pr_info("%s REQ_NOWAIT return\n", __func__);
>> +               }
>>                  return true;
>>          }
>>          md_account_bio(mddev, &bi);
>>
>> Thanks,
>> Song
>>
> Sure, will try this and verify for raid1/10.
I am running into an issue during raid10 reshape. I can see the nowait 
code getting triggered during reshape, but it seems like the reshape 
operation was stuck as soon as I issued write IO using FIO to the array 
during reshape.
FIO also seem stuck i.e no IO went through...

