Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37C3C43334
	for <linux-raid@archiver.kernel.org>; Sat, 16 Jul 2022 03:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiGPDJR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jul 2022 23:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiGPDJO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Jul 2022 23:09:14 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D446C2C135
        for <linux-raid@vger.kernel.org>; Fri, 15 Jul 2022 20:09:12 -0700 (PDT)
Message-ID: <bc690cab-4c50-eb69-94b0-1c95e7397478@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657940950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=peXiav/KyWTxYy3esquC7YQqoGz8JZ4SO1YmF7jQnY8=;
        b=vP5orTH6JPNBH4+vfyezAp1C8Bq2cuHm2bFrJvXH+nCs9pfKCMZIYVvm3xWZs45oHnJ/1u
        n796DOyP3NEGZG9hGRJ3gROfhyW/20TgFq5r62pHVh4Hifb1yJxxxXIkQWMFhxorFoUQ7Y
        J421B3YniTv5OMcrqo/6HDkcKqCEu+c=
Date:   Sat, 16 Jul 2022 11:09:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] raid5: fix duplicate checks for rdev->saved_raid_disk
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220707090834.1881470-1-liu.yun@linux.dev>
 <CAPhsuW5VzKNQrmZDhnVz9Fyn2=JvdeaffSOCodAmVMcVM+fFCg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jackie Liu <liu.yun@linux.dev>
In-Reply-To: <CAPhsuW5VzKNQrmZDhnVz9Fyn2=JvdeaffSOCodAmVMcVM+fFCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



在 2022/7/16 05:37, Song Liu 写道:
> On Thu, Jul 7, 2022 at 2:09 AM Jackie Liu <liu.yun@linux.dev> wrote:
>>
>> From: Jackie Liu <liuyun01@kylinos.cn>
>>
>> 'first' will always be greater than or equal to 0, it is unnecessary to
>> repeat the 0 check, clean it up.
>>
>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> 
> For some reason, the patch won't apply. Could you please resend?

OK.

--
Jackie Liu

> 
> Thanks,
> Song
> 
>> ---
>>   drivers/md/raid5.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 20e53b167f81..a0b38a0ea9c3 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -8063,8 +8063,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>>           * find the disk ... but prefer rdev->saved_raid_disk
>>           * if possible.
>>           */
>> -       if (rdev->saved_raid_disk >= 0 &&
>> -           rdev->saved_raid_disk >= first &&
>> +       if (rdev->saved_raid_disk >= first &&
>>              rdev->saved_raid_disk <= last &&
>>              conf->disks[rdev->saved_raid_disk].rdev == NULL)
>>                  first = rdev->saved_raid_disk;
>> --
>> 2.25.1
>>
