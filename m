Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66454C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  7 Nov 2021 00:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ABBD61165
	for <linux-raid@archiver.kernel.org>; Sun,  7 Nov 2021 00:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhKGATl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 Nov 2021 20:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbhKGATk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 Nov 2021 20:19:40 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E837DC061570
        for <linux-raid@vger.kernel.org>; Sat,  6 Nov 2021 17:16:58 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id g25-20020a9d5f99000000b0055af3d227e8so14797460oti.11
        for <linux-raid@vger.kernel.org>; Sat, 06 Nov 2021 17:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=pAxXMYYtMOokZB6K6tlKBWBC3C6Fg/dBwCpD+Unub2E=;
        b=UTQYwNrddmpZzceOqt9r72yOkbQY3DCmI/z26G8iJejGECprOIEi7zeD6FDvwCJYd7
         i+tVXYH0lcVgS9vddY7n916mopaMpuVQc0YzroBkhcRR2dVd8HvhZ9cGfzySpqInvzpz
         YeVDmPz3LsEjXhIRAkWmSHWYxVLp4QM6Qd96Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pAxXMYYtMOokZB6K6tlKBWBC3C6Fg/dBwCpD+Unub2E=;
        b=xiLEcXZoJUkBuLxCAkJJpj28SraogYw6r3iz2ocHd1jW5EzqM9Ehqqe5C/8kGdG6pu
         01yWUjX2HK0Wt7UDVpmg56nURtz7DWj8P4H+7K4QI7oiHgz9opAPhYzcSlub/KHH4HDl
         ZRUY2kDjpGYy1NKWvWd3uy0ydMYoA2/aj7cU4b0F09ee0reiUa/RN6HWTrcLQ9oEKuzm
         nqziOSIDguG9g2mQcw9qHtPv+ioOQne/ZI/ysIIOvGpUfYW7WccjaNZDmaHUa3bpMy6L
         jOXPdjbY2mz9pcz4x/s/1U4XCaqIczHCEuD0YEzDz18B1oBSB582tKIWrcO40vDFDx4P
         Wcvw==
X-Gm-Message-State: AOAM532J9J7zWUJSMSW1sfC2QK6Nc/79IGUpQqzicJlqtqbazFDviiiR
        WHAbMBKXyiLjA39jfGW/IkXgEg==
X-Google-Smtp-Source: ABdhPJyi/1rOg9Fz+mlG8haBsOsc4C0zwIjk7iTEEH3WQla+kiv35thV2ev6ua6vfojwbimLXYIcAw==
X-Received: by 2002:a9d:5d01:: with SMTP id b1mr12467788oti.7.1636244218182;
        Sat, 06 Nov 2021 17:16:58 -0700 (PDT)
Received: from [192.168.1.7] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id l2sm4362292otl.61.2021.11.06.17.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 17:16:57 -0700 (PDT)
Message-ID: <215d0fe7-a731-f4dd-70f0-7616315cdf01@digitalocean.com>
Date:   Sat, 6 Nov 2021 17:16:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 1/2] md: add support for REQ_NOWAIT
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com>
 <20211104045149.9599-2-vverma@digitalocean.com>
 <c39a47d0-9984-b3c8-9803-3991552d09f5@linux.dev>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <c39a47d0-9984-b3c8-9803-3991552d09f5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 11/6/21 8:38 AM, Guoqing Jiang wrote:
>
>
> On 11/4/21 12:51 PM, Vishal Verma wrote:
>> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
>> for checking whether a given bdev supports handling of REQ_NOWAIT or 
>> not.
>> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and 
>> enable
>> it for linear target") added support for REQ_NOWAIT for dm. This uses
>> a similar approach to incorporate REQ_NOWAIT for md based bios.
>>
>> This patch was tested using t/io_uring tool within FIO. A nvme drive
>> was partitioned into 2 partitions and a simple raid 0 configuration
>> /dev/md0 was created.
>>
>> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>>        937423872 blocks super 1.2 512k chunks
>>
>> Before patch:
>>
>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>
>> Running top while the above runs:
>>
>> $ ps -eL | grep $(pidof io_uring)
>>
>>    38396   38396 pts/2    00:00:00 io_uring
>>    38396   38397 pts/2    00:00:15 io_uring
>>    38396   38398 pts/2    00:00:13 iou-wrk-38397
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
>>    38341   38341 pts/2    00:10:22 io_uring
>>    38341   38342 pts/2    00:10:37 io_uring
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
>> ---
>>   drivers/md/md.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 5111ed966947..73089776475f 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5792,6 +5792,7 @@ int md_run(struct mddev *mddev)
>>       int err;
>>       struct md_rdev *rdev;
>>       struct md_personality *pers;
>> +    bool nowait = true;
>>         if (list_empty(&mddev->disks))
>>           /* cannot run an array with no devices.. */
>> @@ -5862,8 +5863,13 @@ int md_run(struct mddev *mddev)
>>               }
>>           }
>>           sysfs_notify_dirent_safe(rdev->sysfs_state);
>> +        nowait = nowait && 
>> blk_queue_nowait(bdev_get_queue(rdev->bdev));
>>       }
>>   +    /* Set the NOWAIT flags if all underlying devices support it */
>> +    if (nowait)
>> +        blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
>> +
>>       if (!bioset_initialized(&mddev->bio_set)) {
>>           err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, 
>> BIOSET_NEED_BVECS);
>>           if (err)
>> @@ -7007,6 +7013,14 @@ static int hot_add_disk(struct mddev *mddev, 
>> dev_t dev)
>>       set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>>       if (!mddev->thread)
>>           md_update_sb(mddev, 1);
>> +    /* If the new disk does not support REQ_NOWAIT,
>> +     * disable on the whole MD.
>> +     */
>
> The comment style is
>
> /*
>  * xxx
>  */
> Ack, will fix it.
>> +    if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
>> +        pr_info("%s: Disabling nowait because %s does not support 
>> nowait\n",
>> +            mdname(mddev), bdevname(rdev->bdev, b));
>
> Use %pg to print block device name will be more popular though md has 
> lots of legacy code
> with bdevname.
>
> Thanks for pointing, will fix it!
>
> Thanks,
> Guoqing
