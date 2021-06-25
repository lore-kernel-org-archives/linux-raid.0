Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9158FC49EA6
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 03:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F62261351
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 03:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhFYDGZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Jun 2021 23:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhFYDGY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Jun 2021 23:06:24 -0400
Received: from dogben.com (dogben.com [IPv6:2400:8902::f03c:91ff:febc:5721])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FFEC061574
        for <linux-raid@vger.kernel.org>; Thu, 24 Jun 2021 20:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dogben.com;
        s=main; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
        In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Mx7JKK19OL3wTlnEnZENFtSaP8h/tQ/giZOvrrzStMw=; b=k/rNVM6wkt8ndSXFrZrkpbUtL+
        9V3JZnS/w1/krv4EG4IfbNWmxfitm8i+RAg4rL8rOsPcm9YATUSqRfE1uhs4yQmX8FuPQ3XBBQPhU
        VEHR53054L898UdPbuKjcv/HvcLaUEuk+iBKb/dhkNgtA9XXnBFHAw09VU1YeJSkuEiXzGd/+bmnx
        F38pZ2Ihs9k94PtGmplYlj60wuSeVbSaVlVY11UpZsRntcZAs/C8IUDlAMoVfxKtOpR9uvgsAkjVT
        mNi1TCH797cREZXx7awDLtBekd19yBTc56A0dgjJ6tz5eSwJWWohfAPE+ItctpVdaj4vG+sJiIZQ/
        7VhpzNuQ==;
Received: from dogben.com ([2400:8902::f03c:91ff:febc:5721])
        by dogben.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <wsy@dogben.com>)
        id 1lwc8O-002AGW-06; Fri, 25 Jun 2021 03:04:00 +0000
MIME-Version: 1.0
Date:   Fri, 25 Jun 2021 11:03:59 +0800
From:   Wei Shuyu <wsy@dogben.com>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Paul Clements <paul.clements@us.sios.com>,
        Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH] md/raid10: properly indicate failure when ending a failed
 write request
In-Reply-To: <9245e56b-33f3-35f8-c02e-4d57a809c2c8@gmail.com>
References: <E1lwU4E-0029Uw-MM@dogben.com>
 <9245e56b-33f3-35f8-c02e-4d57a809c2c8@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <26936ea3126d12df70fbdc274177cf9b@dogben.com>
X-Sender: wsy@dogben.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2021-06-25 09:58, Guoqing Jiang wrote:
> On 6/25/21 2:27 AM, wsy@dogben.com wrote:
>> Similar to commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd, this patch
>> fixes the same bug in raid10.
>> 
>> Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
>> Signed-off-by: Wei Shuyu <wsy@dogben.com>
>> ---
>> 
>> Maybe there are other bugs fixed in one but left open in the other?
>> 
>>   drivers/md/raid10.c | 2 ++
>>   1 file changed, 2 insertions(+)
>> 
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 13f5e6b2a73d..f9c3b2323d7c 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -475,6 +475,8 @@ static void raid10_end_write_request(struct bio 
>> *bio)
>>   			if (!test_bit(Faulty, &rdev->flags))
>>   				set_bit(R10BIO_WriteError, &r10_bio->state);
>>   			else {
>> +				/* Fail the request */
>> +				set_bit(R10BIO_Degraded, &r10_bio->state);
>>   				r10_bio->devs[slot].bio = NULL;
>>   				to_put = bio;
>>   				dec_rdev = 1;
> 
> While at it, could you also delete the incorrect comment? I don't know
> how the above part is relevant
> with failfast after the refactor.
> 
>                         /*
>                          * When the device is faulty, it is not 
> necessary to
>                          * handle write error.
> -                        * For failfast, this is the only remaining 
> device,
> -                        * We need to retry the write without FailFast.
>                          */
> 
> Thanks,
> Guoqing

Shall I make another patch that fix the comments in both files or just 
piggyback in V2?
