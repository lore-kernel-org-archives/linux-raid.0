Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825E4C0015E
	for <linux-raid@archiver.kernel.org>; Sat, 12 Aug 2023 13:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjHLNYu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Aug 2023 09:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjHLNYt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Aug 2023 09:24:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EF012D
        for <linux-raid@vger.kernel.org>; Sat, 12 Aug 2023 06:24:50 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-564a0d2d35eso1645500a12.0
        for <linux-raid@vger.kernel.org>; Sat, 12 Aug 2023 06:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1691846690; x=1692451490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TZeMSyBQKmMliUFi1YBBLsUQzX6hccChYekrrTkC1ec=;
        b=k/T9o23KMpeIS2Y4uTT4IJFnZK7fqUYKXBeLg8UT3Tw4+Bclrbt6QEK1KCP1XYRGjn
         N70gH7EkysTzHu9FX+p1XUqPJWJUx054xj3/gqV3daOLsY27yaZl9CB9Xp7dTVZgvNt/
         VtoG6jjBHw9EnYYOqI6BqQ2VJnzYFqleG9kNzA7FIpZKoXr6wxd+CughcPwBK7S9hVA9
         e++zmYORPgHAZKVzQWoSWO+8rZMJqh2aYgNvmarvuv/Qr/Zmgg6UUTo7DrxOrt0/7UpE
         xHbRXFbqTFZz/zFzu9bUEMEBNSvgvOm/NiCMnEsvyIzUNPlvdDC0TuopIZdL2uXUtwc7
         cnag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691846690; x=1692451490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZeMSyBQKmMliUFi1YBBLsUQzX6hccChYekrrTkC1ec=;
        b=hH7e1nr2y/9EQmDVhwOatqaymHK5jIw6E4XgcpLjih7LG4p4IA1bOAX7LUj2/Ot6B+
         JQl1D03jvoEdD9eBIHSt1Vmbf+6R6V2pG9AppMJBk0qjSHLyNNG+n18ZLBjLesJI6xVU
         PaNb+G1Sk7Ahzi7jwmVM/ywdwfIEFzX4nDHA9VZrWS6mo2UZIGAp+SWJ8bVy7hRsdqNi
         knrDR5EpliqsmFv0IrAo5STw1AjYRMY7fhO6C0X14Zf6+PXTS15RVZyMjd4YbJ6EUANp
         SE1gNmdcD9PTtiybmsMVI1rKKFQbjr0F+3VRskt0YXqb4wQz30+sjzHQopGEopy/MaA7
         4ZdQ==
X-Gm-Message-State: AOJu0YzVE3HAGnidT/qWza4yb3QWt4xz88aCb0pf0HFWSpBmseIugOKl
        LTXAu2dMKt0uHap1e620uLhvHA==
X-Google-Smtp-Source: AGHT+IH7Z4oe6edMVeXTdufAxvaEYGvS00v0iXAMMZAo3LTzmOsAqvUFpXaCTiZ/C7W8y2LlBKBg0g==
X-Received: by 2002:a17:90a:2ac7:b0:268:5bc6:dc66 with SMTP id i7-20020a17090a2ac700b002685bc6dc66mr2766213pjg.45.1691846689857;
        Sat, 12 Aug 2023 06:24:49 -0700 (PDT)
Received: from [127.0.0.1] ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id a22-20020a17090acb9600b00267b7c5d232sm935023pju.48.2023.08.12.06.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Aug 2023 06:24:49 -0700 (PDT)
Message-ID: <68db8926-0e10-79b1-5704-3734a2a88b41@smartx.com>
Date:   Sat, 12 Aug 2023 21:24:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] md/raid1: don't allow_barrier() before r1bio got freed
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
        djeffery@redhat.com, dan.j.williams@intel.com, neilb@suse.de,
        akpm@linux-foundation.org, shli@fb.com, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230808033211.197383-1-xueshi.hu@smartx.com>
 <f9524fe8-8178-b83b-ec55-2a902c4f998c@huaweicloud.com>
Content-Language: en-US
From:   Xueshi Hu <xueshi.hu@smartx.com>
In-Reply-To: <f9524fe8-8178-b83b-ec55-2a902c4f998c@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/12/23 16:06, Yu Kuai wrote:
> Hi,
> 
> 在 2023/08/08 11:32, Xueshi Hu 写道:
>> Because raid reshape changes the r1conf::raid_disks and the mempool, it
>> orders that there's no in-flight r1bio when reshaping. However, the
>> current caller of allow_barrier() allows the reshape
>> operation to proceed even if the old r1bio requests have not been freed.
>>
>> Free the r1bio firstly before allow_barrier()
>>
>> Fixes: c91114c2b89d ("md/raid1: release pending accounting for an I/O 
>> only after write-behind is also finished")
>> Fixes: 6bfe0b499082 ("md: support blocking writes to an array on 
>> device failure")
>> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
> 
> It's just a suggestion, you can split this patch into 3 patches, one for
> each fix.
> 
>> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
>> ---
>> -> v2:
>>     - fix the problem one by one instead of calling
>>     blk_mq_freeze_queue() as suggested by Yu Kuai
>> -> v3:
>>     - add freeze_array_totally() to replace freeze_array() instead
>>       of gave up in raid1_reshape()
>>     - add a missed fix in raid_end_bio_io()
>>     - add a small check at the start of raid1_reshape()
>> -> v4:
>>     - add fix tag and revise the commit message
>>     - drop patch 1 as there is an ongoing systematic fix for the bug
> 
> I think it's okay to fix the bug as I suggested in v3, the refactor is a
> long term...
> 
> Thanks,
> Kuai
Good suggestion, I'll remake the patch.

Thanks,
Hu
> 
>>     - drop patch 3 as it's unrelated which will be sent in
>>     another patch
>>
>>   drivers/md/raid1.c | 15 +++++++++------
>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index dd25832eb045..5a5eb5f1a224 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -313,6 +313,7 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
>>   {
>>       struct bio *bio = r1_bio->master_bio;
>>       struct r1conf *conf = r1_bio->mddev->private;
>> +    sector_t sector = r1_bio->sector;
>>       /* if nobody has done the final endio yet, do it now */
>>       if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
>> @@ -323,13 +324,13 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
>>           call_bio_endio(r1_bio);
>>       }
>> +
>> +    free_r1bio(r1_bio);
>>       /*
>>        * Wake up any possible resync thread that waits for the device
>>        * to go idle.  All I/Os, even write-behind writes, are done.
>>        */
>> -    allow_barrier(conf, r1_bio->sector);
>> -
>> -    free_r1bio(r1_bio);
>> +    allow_barrier(conf, sector);
>>   }
>>   /*
>> @@ -1373,6 +1374,7 @@ static void raid1_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>           return;
>>       }
>> + retry_write:
>>       r1_bio = alloc_r1bio(mddev, bio);
>>       r1_bio->sectors = max_write_sectors;
>> @@ -1388,7 +1390,6 @@ static void raid1_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>        */
>>       disks = conf->raid_disks * 2;
>> - retry_write:
>>       blocked_rdev = NULL;
>>       rcu_read_lock();
>>       max_sectors = r1_bio->sectors;
>> @@ -1468,7 +1469,7 @@ static void raid1_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>           for (j = 0; j < i; j++)
>>               if (r1_bio->bios[j])
>>                   rdev_dec_pending(conf->mirrors[j].rdev, mddev);
>> -        r1_bio->state = 0;
>> +        free_r1bio(r1_bio);
>>           allow_barrier(conf, bio->bi_iter.bi_sector);
>>           if (bio->bi_opf & REQ_NOWAIT) {
>> @@ -2498,6 +2499,7 @@ static void handle_read_error(struct r1conf 
>> *conf, struct r1bio *r1_bio)
>>       struct mddev *mddev = conf->mddev;
>>       struct bio *bio;
>>       struct md_rdev *rdev;
>> +    sector_t sector;
>>       clear_bit(R1BIO_ReadError, &r1_bio->state);
>>       /* we got a read error. Maybe the drive is bad.  Maybe just
>> @@ -2527,12 +2529,13 @@ static void handle_read_error(struct r1conf 
>> *conf, struct r1bio *r1_bio)
>>       }
>>       rdev_dec_pending(rdev, conf->mddev);
>> -    allow_barrier(conf, r1_bio->sector);
>> +    sector = r1_bio->sector;
>>       bio = r1_bio->master_bio;
>>       /* Reuse the old r1_bio so that the IO_BLOCKED settings are 
>> preserved */
>>       r1_bio->state = 0;
>>       raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
>> +    allow_barrier(conf, sector);
>>   }
>>   static void raid1d(struct md_thread *thread)
>>
> 

