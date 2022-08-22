Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25818C28D13
	for <linux-raid@archiver.kernel.org>; Mon, 22 Aug 2022 20:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbiHVUkw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237572AbiHVUkv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 Aug 2022 16:40:51 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08104507A
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 13:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=i5f6M1hMP6hMaJdsrlq3zzyZsGzq0qDakTfI2zqmWVo=; b=bWhtTmtPd7IuCmac1Ky4jKtvjD
        yXbZ+89vD7QFYtuWIUXvkMwL9jiiV8BFac/PlP6usWIWpQjH6yg5uFbI6F6kHC6JDhrWyhVPoQwZN
        8QCSPEbsEhHUVJySTnR0ptZmgbzj52kJpioZBq0giyIReGf19ZmyR2LWLxWWIIJdaXYBwXh7MeWgE
        Npm11SL+kVFEEx5qVlHmlclvFvVMf+/wbM12qrU3dJYwaBIUkd2WBrxf76KMxLQ4dFVIFN5KTWHz0
        x33d6tClS/hhdZirXJ3hdOc/WFhNTB2yx7NZxvV2X+pwPcnBthYTCb+GtHvwBOe+/zG4kK4LUDkM6
        8dpjiyxQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oQEE4-005k36-1m; Mon, 22 Aug 2022 14:40:48 -0600
Message-ID: <6d311960-017e-8b45-2860-26c802546b5e@deltatee.com>
Date:   Mon, 22 Aug 2022 14:40:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com>
 <CAPhsuW4=aa08-XGDtoQ3rLb8r-5t9Q7VwwFgGbTTt-xbkzEW8Q@mail.gmail.com>
 <b4e29397-3150-8580-86aa-f23cee893ee6@deltatee.com>
 <CAPhsuW40XFwAQVwkH6bgT3fe45pZDwASEzt+R=SsqMywrTKcdA@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPhsuW40XFwAQVwkH6bgT3fe45pZDwASEzt+R=SsqMywrTKcdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: song@kernel.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: raid5 Journal Recovery Bug
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-08-22 13:12, Song Liu wrote:
> On Mon, Aug 22, 2022 at 9:28 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>>
>>
>>
>> On 2022-08-22 01:04, Song Liu wrote:
>>> Could you please add some printk so that we know which condition triggered
>>> handle_stripe_fill() here:
>>>
>>>         if (s.to_read || s.non_overwrite
>>>             || (s.to_write && s.failed)
>>>             || (s.syncing && (s.uptodate + s.compute < disks))
>>>             || s.replacing
>>>             || s.expanding)
>>>                 handle_stripe_fill(sh, &s, disks);
>>>
>>> This would help us narrow down to the exact condition. I guess it is
>>> "(s.to_write && s.failed)", but I am not quite sure.
>>
>> Ok, I hit this bug on a stripe and got these values for the call:
>>
>>   to_read       = 0
>>   non_overwrite = 0
>>   to_write      = 0
>>   failed        = 1
>>   syncing       = 1
>>   uptodate      = 2
>>   compute       = 0
>>   disks         = 3
>>   replacing     = 0
>>   expanding     = 0
>>
>> So it's actually the "(s.syncing && (s.uptodate + s.compute < disks))"
>> condition that is getting hit.
> 
> Thanks for the information! So the stripe is syncing. Could you please
> try whether the following fixes the issue?

Yup, thanks! Looks like that fixes my test case. I can do more general
testing on it later this week.

Logan
