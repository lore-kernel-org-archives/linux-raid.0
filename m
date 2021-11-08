Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7985DC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59CF8619A6
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 22:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbhKHWjp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbhKHWjo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Nov 2021 17:39:44 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F25C061570
        for <linux-raid@vger.kernel.org>; Mon,  8 Nov 2021 14:37:00 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso25198849otg.9
        for <linux-raid@vger.kernel.org>; Mon, 08 Nov 2021 14:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=o6WSSVqh8lZtt9+L7YVjggWszcAAimuW93RHtkmDi50=;
        b=R1CoWVreuCCui8c6f+KRNu2vGd2b24C9neaQkSkxJESoPeWmUrKSjejFeM3fToEfy7
         sdNzWfj0prbQEdekEjGIDEqz0wIoTbwuxOSY8XjfWm1AoTNSWQTiSmBHDINbGNw49VV6
         7dsk2Smljk53ElvbfEI+nTWUz0Wh4gYhliFhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=o6WSSVqh8lZtt9+L7YVjggWszcAAimuW93RHtkmDi50=;
        b=GbbFHcBlQqfLwqxSsY6KgYWpujJJHpfWlVG+LO7Q+4wJyGPrlnIhP3cGQvGj2g538Y
         ntfLl+D8TFZPbcQZw6mQR/vjBTp/shFzQSBlFIEcHBxIhlCcuRksfNUtxmFUrHWyYiOE
         N0/pgQ0gdd36BpsofKj5q9uUUns/6EvA1DB2jhbR4l1UxnLBYl8Yjk+gijN379ht2KcK
         aAYEF9h4KkE8Z+JAS0sidUywrevDLSzqyeRA9PBeHxeKQ36m7mqPxa/9FzATvy6wnAE+
         ukASXXLKnDgBWFlhgAyOVbO+5CPHAmaes5juBW4UdXJFgzc3Op1J46aePGbBm4cwwtFR
         7DlQ==
X-Gm-Message-State: AOAM531mfXAebnYUchwWGtNPjScX263UMJyB/prNU4ENqlVoC3iF553s
        Xfq6ZxM7E36wXc/LaWSDxrsB1A==
X-Google-Smtp-Source: ABdhPJw1ADQcusTAKCt+4pUvg1Ub5A/nsZ2JUpf5aTP6sfguspArJ2H4/0wg6ZtRT7JIFO49vMFA4Q==
X-Received: by 2002:a9d:352:: with SMTP id 76mr1825395otv.79.1636411019295;
        Mon, 08 Nov 2021 14:36:59 -0800 (PST)
Received: from [192.168.1.7] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id t12sm2454335oor.21.2021.11.08.14.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 14:36:58 -0800 (PST)
Message-ID: <62d56d6b-5651-f582-a9aa-e567d47d2876@digitalocean.com>
Date:   Mon, 8 Nov 2021 15:36:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 1/2] md: add support for REQ_NOWAIT
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
 <20211104045149.9599-2-vverma@digitalocean.com>
 <CAPhsuW6OtyJ_e9ZSqDE1YRk+zfNfQn0KRGOBe2AetUe5c=BvMQ@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW6OtyJ_e9ZSqDE1YRk+zfNfQn0KRGOBe2AetUe5c=BvMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 11/8/21 3:17 PM, Song Liu wrote:
> On Wed, Nov 3, 2021 at 9:52 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
>> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
>> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
>> it for linear target") added support for REQ_NOWAIT for dm. This uses
>> a similar approach to incorporate REQ_NOWAIT for md based bios.
>>
>> This patch was tested using t/io_uring tool within FIO. A nvme drive
>> was partitioned into 2 partitions and a simple raid 0 configuration
>> /dev/md0 was created.
>>
>> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>>        937423872 blocks super 1.2 512k chunks
>>
>> Before patch:
>>
>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>
>> Running top while the above runs:
>>
>> $ ps -eL | grep $(pidof io_uring)
>>
>>    38396   38396 pts/2    00:00:00 io_uring
>>    38396   38397 pts/2    00:00:15 io_uring
>>    38396   38398 pts/2    00:00:13 iou-wrk-38397
>>
>> We can see iou-wrk-38397 io worker thread created which gets created
>> when io_uring sees that the underlying device (/dev/md0 in this case)
>> doesn't support nowait.
>>
>> After patch:
>>
>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>
>> Running top while the above runs:
>>
>> $ ps -eL | grep $(pidof io_uring)
>>
>>    38341   38341 pts/2    00:10:22 io_uring
>>    38341   38342 pts/2    00:10:37 io_uring
>>
>> After running this patch, we don't see any io worker thread
>> being created which indicated that io_uring saw that the
>> underlying device does support nowait. This is the exact behaviour
>> noticed on a dm device which also supports nowait.
>>
>> For all the other raid personalities except raid0, we would need
>> to train pieces which involves make_request fn in order for them
>> to correctly handle REQ_NOWAIT.
>>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> I think we still need the logic in md_handle_request() similar to v1?
>
> Thanks,
> Song
>
> Yes, I believe so. I misunderstood your earlier comment in v1 regarding bio_endio().
> Will fix it.
>> ---
>>   drivers/md/md.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 5111ed966947..73089776475f 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5792,6 +5792,7 @@ int md_run(struct mddev *mddev)
>>          int err;
>>          struct md_rdev *rdev;
>>          struct md_personality *pers;
>> +       bool nowait = true;
>>
>>          if (list_empty(&mddev->disks))
>>                  /* cannot run an array with no devices.. */
>> @@ -5862,8 +5863,13 @@ int md_run(struct mddev *mddev)
>>                          }
>>                  }
>>                  sysfs_notify_dirent_safe(rdev->sysfs_state);
>> +               nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
>>          }
>>
>> +       /* Set the NOWAIT flags if all underlying devices support it */
>> +       if (nowait)
>> +               blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
>> +
>>          if (!bioset_initialized(&mddev->bio_set)) {
>>                  err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>>                  if (err)
>> @@ -7007,6 +7013,14 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
>>          set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>>          if (!mddev->thread)
>>                  md_update_sb(mddev, 1);
>> +       /* If the new disk does not support REQ_NOWAIT,
>> +        * disable on the whole MD.
>> +        */
>> +       if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
>> +               pr_info("%s: Disabling nowait because %s does not support nowait\n",
>> +                       mdname(mddev), bdevname(rdev->bdev, b));
>> +               blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
>> +       }
>>          /*
>>           * Kick recovery, maybe this spare has to be added to the
>>           * array immediately.
>> --
>> 2.17.1
>>
