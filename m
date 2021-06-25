Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768D6C49EA6
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 03:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 473BC613FB
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 03:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhFYDRO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Jun 2021 23:17:14 -0400
Received: from mailgw.kylinos.cn ([123.150.8.42]:1127 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232917AbhFYDRO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 24 Jun 2021 23:17:14 -0400
X-UUID: 8138c634105749dd81aead7495fd7d2b-20210625
X-UUID: 8138c634105749dd81aead7495fd7d2b-20210625
X-User: jiangguoqing@kylinos.cn
Received: from [172.30.60.82] [(106.37.198.34)] by nksmu.kylinos.cn
        (envelope-from <jiangguoqing@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES128-GCM-SHA256 128/128)
        with ESMTP id 1614821533; Fri, 25 Jun 2021 11:14:07 +0800
Subject: Re: [PATCH] md/raid10: properly indicate failure when ending a failed
 write request
To:     Wei Shuyu <wsy@dogben.com>, Guoqing Jiang <jgq516@gmail.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Paul Clements <paul.clements@us.sios.com>,
        Yufen Yu <yuyufen@huawei.com>
References: <E1lwU4E-0029Uw-MM@dogben.com>
 <9245e56b-33f3-35f8-c02e-4d57a809c2c8@gmail.com>
 <26936ea3126d12df70fbdc274177cf9b@dogben.com>
From:   Guoqing Jiang <jiangguoqing@kylinos.cn>
Message-ID: <86bed8df-3194-4e04-7eb4-fbb0922ab8c8@kylinos.cn>
Date:   Fri, 25 Jun 2021 11:14:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <26936ea3126d12df70fbdc274177cf9b@dogben.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/25/21 11:03 AM, Wei Shuyu wrote:
> On 2021-06-25 09:58, Guoqing Jiang wrote:
>> On 6/25/21 2:27 AM, wsy@dogben.com wrote:
>>> Similar to commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd, this patch
>>> fixes the same bug in raid10.
>>>
>>> Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
>>> Signed-off-by: Wei Shuyu <wsy@dogben.com>
>>> ---
>>>
>>> Maybe there are other bugs fixed in one but left open in the other?
>>>
>>>   drivers/md/raid10.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 13f5e6b2a73d..f9c3b2323d7c 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -475,6 +475,8 @@ static void raid10_end_write_request(struct bio 
>>> *bio)
>>>               if (!test_bit(Faulty, &rdev->flags))
>>>                   set_bit(R10BIO_WriteError, &r10_bio->state);
>>>               else {
>>> +                /* Fail the request */
>>> +                set_bit(R10BIO_Degraded, &r10_bio->state);
>>>                   r10_bio->devs[slot].bio = NULL;
>>>                   to_put = bio;
>>>                   dec_rdev = 1;
>>
>> While at it, could you also delete the incorrect comment? I don't know
>> how the above part is relevant
>> with failfast after the refactor.
>>
>>                         /*
>>                          * When the device is faulty, it is not 
>> necessary to
>>                          * handle write error.
>> -                        * For failfast, this is the only remaining 
>> device,
>> -                        * We need to retry the write without FailFast.
>>                          */
>>
>> Thanks,
>> Guoqing
>
> Shall I make another patch that fix the comments in both files or just 
> piggyback in V2?

It is up to you, I don't have strong opinion for it.

Thanks,
Guoqing
