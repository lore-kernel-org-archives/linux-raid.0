Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E356FC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 10:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDC936105A
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 10:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240775AbhJGKSy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 06:18:54 -0400
Received: from out10.migadu.com ([46.105.121.227]:58845 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240779AbhJGKSp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 7 Oct 2021 06:18:45 -0400
Subject: Re: [PATCH 4/6] md/raid10: add 'read_err' to raid10_read_request
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633601806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkRdmSngEwqw1hvWlz5eNO2jxJ/bPqGnNf1CQfMCG9g=;
        b=mwnRXnFaQEeTUDIG4CXsOW33FGN5MbnKPSYPiVEw8HZi/HlonmgmTDdfi4Q/9liP4y4zL4
        FF61Y5oszbAXvbcoFq8aXNgeITL8mBjiQGn1mLOkhZeLZwRFPrgqNRYKesFx5322IIXt8v
        OqpIDjjFNr245niGXyi4LGO7789iY2U=
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
 <20211004153453.14051-5-guoqing.jiang@linux.dev>
 <CAPhsuW5DF-5O19M6GFCsdjZbtNSiG__QO4JqynFYpMBD0FTQuw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <d58f50ee-214c-43ad-4c5d-1c2570be2151@linux.dev>
Date:   Thu, 7 Oct 2021 18:16:43 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5DF-5O19M6GFCsdjZbtNSiG__QO4JqynFYpMBD0FTQuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/7/21 2:20 PM, Song Liu wrote:
> On Mon, Oct 4, 2021 at 8:40 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>> Add the paramenter since the err retry logic is only meaningful when
>> the caller is handle_read_error.
>>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>> ---
>>   drivers/md/raid10.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index aa2636582841..29eb538db953 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1116,7 +1116,7 @@ static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
>>   }
>>
>>   static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>> -                               struct r10bio *r10_bio)
>> +                               struct r10bio *r10_bio, bool read_err)
>>   {
>>          struct r10conf *conf = mddev->private;
>>          struct bio *read_bio;
>> @@ -1129,7 +1129,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>>          struct md_rdev *err_rdev = NULL;
>>          gfp_t gfp = GFP_NOIO;
>>
>> -       if (slot >= 0 && r10_bio->devs[slot].rdev) {
>> +       if (read_err && slot >= 0 && r10_bio->devs[slot].rdev) {
> How about we just move this section to a separate function?

Will add an additional patch for it.

Thanks,
Guoqing
