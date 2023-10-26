Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDCBC25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjJZVjz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjJZVjy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:39:54 -0400
Received: from sender-op-o11.zoho.eu (sender-op-o11.zoho.eu [136.143.169.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF65FDC
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698356384; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OL7pk/T/32ItNlGgoxAvHdW5XMAFXwA2CZMoNUKzzqqee2NI6KHTSJbKc0oTL8aRKg7UjIHUar1Zz3HcR7pnm3Rpn8TZvI+Mrhe446uhm+j3zh2mbm/gKpg9XGbuqKKOnNebaU7EyB1A1FH6StRSYkAGeb29l4krPBMBvszFQ0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698356384; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=crHlGODsTyC9vatkuNpIt8UrjjNZ51FsP8Juox/WS+c=; 
        b=H5/JllKMF9ipXpfQPzL/1gvpDEYiUdojt25hNBmizoNjsYENFi2pYw/RifzQHBQlAD/YyY7JZWpxA2pIubiN/lTxjpONyoo0Jp6IRSX5qNP43+4dSNrEh8BhYkbJOiXqkQN9yn1l0WazyvgdPTZO8OB1GU8N3DtkvhEzHiyZkm0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698356381875875.3219231557148; Thu, 26 Oct 2023 23:39:41 +0200 (CEST)
Date:   Thu, 26 Oct 2023 17:39:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/4 v2] mdadm/tests: Fix regular expression failure
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20230927025219.49915-1-xni@redhat.com>
 <20230927025219.49915-2-xni@redhat.com>
 <20230928112448.000010f6@linux.intel.com>
 <CALTww2_EKnO=uE81=3O48rPCfebkFXAGSQVW+w4FWZ3jH15T-g@mail.gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <4abf64c5-7066-78dc-f6f9-53b3f89d8223@trained-monkey.org>
In-Reply-To: <CALTww2_EKnO=uE81=3O48rPCfebkFXAGSQVW+w4FWZ3jH15T-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/7/23 09:35, Xiao Ni wrote:
> On Thu, Sep 28, 2023 at 5:25 PM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
>>
>> On Wed, 27 Sep 2023 10:52:16 +0800
>> Xiao Ni <xni@redhat.com> wrote:
>>
>>> The test fails because of the regular expression.
>>>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>>  tests/06name | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tests/06name b/tests/06name
>>> index 4d5e824d3e0e..86eaab69e3a1 100644
>>> --- a/tests/06name
>>> +++ b/tests/06name
>>> @@ -3,8 +3,8 @@ set -x
>>>  # create an array with a name
>>>
>>>  mdadm -CR $md0 -l0 -n2 --metadata=1 --name="Fred" $dev0 $dev1
>>> -mdadm -E $dev0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
>>> -mdadm -D $md0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
>>> +mdadm -E $dev0 | grep 'Name : Fred' > /dev/null || exit 1
>>> +mdadm -D $md0 | grep 'Name : Fred' > /dev/null || exit 1
>>>  mdadm -S $md0
>>>
>>>  mdadm -A $md0 --name="Fred" $devlist
>>
>> Hello Xiao,
>> I can see that it is not sent first time. Previous version was moved by me to
>> the "awaiting_upstream" state on patchwork but I forgot to answer.
>> You don't need to send it again. I'm ignoring this one. Anyway, here my
>> approval:
>>
>> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>>
>> https://patchwork.kernel.org/project/linux-raid/patch/20230907085744.18967-1-xni@redhat.com/
> 
> Thanks for the information :)
>

Applied!

Thanks,
Jes



