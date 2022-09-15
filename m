Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4537FC6FA86
	for <linux-raid@archiver.kernel.org>; Thu, 15 Sep 2022 09:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiIOJNW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Sep 2022 05:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiIOJND (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Sep 2022 05:13:03 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC7698D2B;
        Thu, 15 Sep 2022 02:12:35 -0700 (PDT)
Received: from [172.30.1.130] (unknown [193.158.90.91])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6FF8761EA1931;
        Thu, 15 Sep 2022 11:12:32 +0200 (CEST)
Message-ID: <6a1060e1-990c-b068-b515-b43c62595a8b@molgen.mpg.de>
Date:   Thu, 15 Sep 2022 11:12:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/4] md/raid10: cleanup wait_barrier()
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Logan Gunthorpe <logang@deltatee.com>, song@kernel.org,
        guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20220914014914.398712-1-yukuai1@huaweicloud.com>
 <20220914014914.398712-2-yukuai1@huaweicloud.com>
 <f0dd9208-05ec-b2fa-4b29-5fa140486fa3@deltatee.com>
 <1932cd56-87fc-51ac-4cb0-ec35d912525c@huaweicloud.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <1932cd56-87fc-51ac-4cb0-ec35d912525c@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Yu,


Am 15.09.22 um 09:21 schrieb Yu Kuai:

> 在 2022/09/15 0:16, Logan Gunthorpe 写道:

>> On 2022-09-13 19:49, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> Currently the nasty condition is wait_barrier() is hard to read. This
>>> patch factor out the condition into a function.
>>>
>>> There are no functional changes.
>>>
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> ---
>>>   drivers/md/raid10.c | 56 ++++++++++++++++++++++++++-------------------
>>>   1 file changed, 32 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 64d6e4cd8a3a..56458a53043d 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -957,44 +957,52 @@ static void lower_barrier(struct r10conf *conf)
>>>       wake_up(&conf->wait_barrier);
>>>   }
>>> +static bool stop_waiting_barrier(struct r10conf *conf)
>>> +{
>>> +    /* barrier is dropped */
>>> +    if (!conf->barrier)
>>> +        return true;
>>> +
>>> +    /*
>>> +     * If there are already pending requests (preventing the barrier 
>>> from
>>> +     * rising completely), and the pre-process bio queue isn't 
>>> empty, then
>>> +     * don't wait, as we need to empty that queue to get the nr_pending
>>> +     * count down.
>>> +     */
>>> +    if (atomic_read(&conf->nr_pending)) {
>>> +        struct bio_list *bio_list = current->bio_list;
>>
>> I'd probably just put the bio_list declaration at the top of this
>> function, then the nested if statements are not necessary. The compiler
>> should be able to optimize the access just fine.
>>
>>>       if (conf->barrier) {
>>> -        struct bio_list *bio_list = current->bio_list;
>>> -        conf->nr_waiting++;
>>> -        /* Wait for the barrier to drop.
>>> -         * However if there are already pending
>>> -         * requests (preventing the barrier from
>>> -         * rising completely), and the
>>> -         * pre-process bio queue isn't empty,
>>> -         * then don't wait, as we need to empty
>>> -         * that queue to get the nr_pending
>>> -         * count down.
>>> -         */
>>>           /* Return false when nowait flag is set */
>>>           if (nowait) {
>>>               ret = false;
>>>           } else {
>>> +            conf->nr_waiting++;
>>
>> Technically speaking, I think moving nr_waiting counts as a functional
>> change. As best as I can see it is correct, but it should probably be at
>> least mentioned in the commit message, or maybe done as a separate
>> commit with it's own justification. That way if it causes problems down
>> the road, a bisect will make the issue clearer.
> 
> Thanks for your advice, I just think increase and decrease nr_waiting in
> the case 'nowait' is pointless, and I move it incidentally.
> 
> I'll post a separate clean up patch to do that.
> 
> Paul, can I still add your Acked-by for this patch?

Yes, sure.


Kind regards,

Paul
