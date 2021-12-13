Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E6C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 13 Dec 2021 22:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243774AbhLMWnv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 17:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbhLMWnr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Dec 2021 17:43:47 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B04C061574
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 14:43:47 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q16so15772064pgq.10
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 14:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=LruE0zQSluALIgjMtjGb4FIXvy6E3S+lcgD2o7Gms3o=;
        b=dck8wPmfORc694nofhq1dhaOFeVE23B1FTwfb8g5AQytu9HuVKG8njCVfA5CI/ca9c
         Hb/D7HBdmxJ5J5BL3dJPK3nw25coLwcRuoke9JPjgHlYf3ueI0wNGyDYqYI2iM2K6ONB
         3gOVOcunp4EV32qkPDvctyzGI7DNNHgKsdqO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LruE0zQSluALIgjMtjGb4FIXvy6E3S+lcgD2o7Gms3o=;
        b=a+xm+ym21iAN2HzJs3pmBmzrwyS5xOGBuHhzK/gO4E7KBWsoP1sQGVvnx1uIO8MSWN
         qZnlw8SgP88hdDUaYMry9dza8LMnz7qZuzFgNSi8ZjOOTYK05Av282q2yLNljITWBmKS
         t0NLOmlkgcf/huquFU+S3/VjzYPTDXcR5Zpx3bNP5G7AZ192exlgSzjDo+ikegOr1CFZ
         arpy5MUpJr/tD6Yq4dI5rFCYlc1WmpqfLWOjtAQJZ7wRTKkeEJW/m2RT+2WcGmzcKRZG
         kXh6VW+triFUDXYzfTOqnqvO7NCOj7wp3jJwXhlraNObzrEe0WrFFqLKF3elTdTGAmOm
         Om3g==
X-Gm-Message-State: AOAM530SEmpXLSYXSmmBo9GHSP603LISojIoDJg0X1dt6VkMlkhyxgCT
        jyByEBc/NyguNeCyg7Pjd5jOsXCWsYykYw==
X-Google-Smtp-Source: ABdhPJzgUhEnJRTptgZDEIHPP4T3WtpdIKTh6cb2D8PGScbsE+AfV9cIB2EgZq50eyMUBYDwrNksXA==
X-Received: by 2002:a63:cc4d:: with SMTP id q13mr1114459pgi.166.1639435427143;
        Mon, 13 Dec 2021 14:43:47 -0800 (PST)
Received: from [192.168.1.5] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id e14sm14742174pfv.18.2021.12.13.14.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 14:43:46 -0800 (PST)
Message-ID: <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com>
Date:   Mon, 13 Dec 2021 15:43:40 -0700
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
 <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com>
 <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/12/21 10:56 PM, Song Liu wrote:
> On Fri, Dec 10, 2021 at 10:26 AM Vishal Verma <vverma@digitalocean.com> wrote:
>>
>> On 12/9/21 7:16 PM, Song Liu wrote:
>>> On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
>>>> Returns EAGAIN in case the raid456 driver would block
>>>> waiting for situations like:
>>>>
>>>>     - Reshape operation,
>>>>     - Discard operation.
>>>>
>>>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>>>> ---
>>>>    drivers/md/raid5.c | 14 ++++++++++++++
>>>>    1 file changed, 14 insertions(+)
>>>>
>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> index 9c1a5877cf9f..fa64ee315241 100644
>>>> --- a/drivers/md/raid5.c
>>>> +++ b/drivers/md/raid5.c
>>>> @@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
>>>>                   int d;
>>>>           again:
>>>>                   sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
>>>> +               /* Bail out if REQ_NOWAIT is set */
>>>> +               if (bi->bi_opf & REQ_NOWAIT) {
>>>> +                       bio_wouldblock_error(bi);
>>>> +                       return;
>>>> +               }
>>> This is not right. raid5_get_active_stripe() gets refcount on the sh,
>>> we cannot simply
>>> return here. I think we need the logic after raid5_release_stripe()
>>> and before schedule().
>>>
>>>>                   prepare_to_wait(&conf->wait_for_overlap, &w,
>>>>                                   TASK_UNINTERRUPTIBLE);
>>>>                   set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
>>>> @@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>>>           bi->bi_next = NULL;
>>>>
>>>>           md_account_bio(mddev, &bi);
>>>> +       /* Bail out if REQ_NOWAIT is set */
>>>> +       if (bi->bi_opf & REQ_NOWAIT &&
>>>> +           conf->reshape_progress != MaxSector &&
>>>> +           mddev->reshape_backwards
>>>> +           ? logical_sector < conf->reshape_safe
>>>> +           : logical_sector >= conf->reshape_safe) {
>>>> +               bio_wouldblock_error(bi);
>>>> +               return true;
>>>> +       }
>>> This is also problematic, and is the trigger of those error messages.
>>> We only want to trigger -EAGAIN when logical_sector is between
>>> reshape_progress and reshape_safe.
>>>
>>> Just to clarify, did you mean doing something like:
>>> if (bi->bi_opf & REQ_NOWAIT &&
>>> +           conf->reshape_progress != MaxSector &&
>>> +           (mddev->reshape_backwards
>>> +           ? (logical_sector > conf->reshape_progress && logical_sector < conf->reshape_safe)
>>> +           : logical_sector >= conf->reshape_safe)) {
> I think this should be
>    :   (logical_sector >= conf->reshape_safe && logical_sector <
> conf->reshape_progress)


if (bi->bi_opf & REQ_NOWAIT &&
                 conf->reshape_progress != MaxSector &&
                 (mddev->reshape_backwards
                 ? (logical_sector > conf->reshape_progress && 
logical_sector <= conf->reshape_safe)
                 : (logical_sector >= conf->reshape_safe && 
logical_sector < conf->reshape_progress))) {
                         bio_wouldblock_error(bi);
                         return true;
         }

After making this change along with other changes, I ran some tests with 
100% reads, 70%read30%writes and 100% writes on a clean raid5 array.

Unfortunately, I ran into this following task hung with 100% writes 
(with both libaio and io_uring):

[21876.856692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[21876.864518] task:md5_raid5       state:D stack:    0 pid:11675 
ppid:     2 flags:0x00004000
[21876.864522] Call Trace:
[21876.864526]  __schedule+0x2d4/0x970
[21876.864532]  ? wbt_cleanup_cb+0x20/0x20
[21876.864535]  schedule+0x4e/0xb0
[21876.864537]  io_schedule+0x3f/0x70
[21876.864539]  rq_qos_wait+0xb9/0x130
[21876.864542]  ? sysv68_partition+0x280/0x280
[21876.864543]  ? wbt_cleanup_cb+0x20/0x20
[21876.864545]  wbt_wait+0x92/0xc0
[21876.864546]  __rq_qos_throttle+0x25/0x40
[21876.864548]  blk_mq_submit_bio+0xc6/0x5d0
[21876.864551]  ? submit_bio_checks+0x39e/0x5f0
[21876.864554]  __submit_bio+0x1bc/0x1d0
[21876.864555]  ? kmem_cache_free+0x378/0x3c0
[21876.864558]  ? mempool_free_slab+0x17/0x20
[21876.864562]  submit_bio_noacct+0x256/0x2a0
[21876.864565]  0xffffffffc01fa6d9
[21876.864568]  ? 0xffffffffc01f5d01
[21876.864569]  raid5_get_active_stripe+0x16c0/0x3e00 [raid456]
[21876.864571]  ? __wake_up_common_lock+0x8a/0xc0
[21876.864575]  raid5_get_active_stripe+0x2839/0x3e00 [raid456]
[21876.864577]  raid5_get_active_stripe+0x2d6e/0x3e00 [raid456]
[21876.864579]  md_thread+0xae/0x170
[21876.864581]  ? wait_woken+0x60/0x60
[21876.864582]  ? md_start_sync+0x60/0x60
[21876.864584]  kthread+0x127/0x150
[21876.864586]  ? set_kthread_struct+0x40/0x40
[21876.864588]  ret_from_fork+0x1f/0x30

>>> +               bio_wouldblock_error(bi);
>>> +               return true;
>>> +
>>>
>>> Please let me know if these make sense.
>>>
>>> Thanks,
>>> Song
>>>
>>>
>>> Makes sense. Thanks for your feedback. I'll incorporate it and test.
> When testing, please make sure we hit all different conditions with REQ_NOWAIT.
>
> Thanks,
> Song
