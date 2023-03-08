Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41E1C678D5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Mar 2023 19:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjCHTF7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Mar 2023 14:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjCHTFW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Mar 2023 14:05:22 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35435D38E0
        for <linux-raid@vger.kernel.org>; Wed,  8 Mar 2023 11:04:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678302255; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OFEQ938QyM0dUkJ/sRjsy6A/7ZA9bUH42f4XR4RsRzw4qwm0Y12YtP5G3Xpo/NuJDk0uz0tC3JKUwnltPI4crubNiU8V4yimQjkb4l+8IutKhov3+XKsK+4HGVqpKathA4uPO+TDnP0kTgobAGtjkreo9sMPWKZE3weJk7OCnr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1678302255; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=KNVmNPmaM/5azFy7ryjl/uOyNk1E86Eet8DQ4tbibhw=; 
        b=k43RYF0qWtwCelbf6TBQbgh9zrkSeiLOMcTIfvDK9jv0t5mo9fNP6j3BjUj39rj3KOQU+aLazMuGACSMbohZtGyUrpdoYKaE9Kj7C24SPyRKdwhDht7pYCLUlpfH6PwqWc91SY07KQdu9DN06EwCw3Z18RADt9P0EoucvM2w8UU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 167830225367611.550168989586268; Wed, 8 Mar 2023 20:04:13 +0100 (CET)
Message-ID: <824b2eca-cada-43b2-be8f-100676654bb2@trained-monkey.org>
Date:   Wed, 8 Mar 2023 14:04:12 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/3] mdadm: refactor ident->name handling
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     colyli@suse.de, linux-raid@vger.kernel.org
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
 <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
 <bef57069-acdb-3a2f-b691-2c438c4247fb@trained-monkey.org>
 <20221229103931.00006ff0@linux.intel.com>
 <0017b6dc-b0c0-7d4e-4765-fcc429b41862@trained-monkey.org>
 <20230303130410.000043e0@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230303130410.000043e0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/3/23 07:04, Mariusz Tkaczyk wrote:
> On Thu, 2 Mar 2023 09:52:31 -0500
> Jes Sorensen <jes@trained-monkey.org> wrote:
> 
>> On 12/29/22 04:39, Mariusz Tkaczyk wrote:
>>
>> Hi Mariusz,
>>
>> Apologies for the slow response on this one.
>>
>>> On Wed, 28 Dec 2022 10:07:22 -0500
>>> Jes Sorensen <jes@trained-monkey.org> wrote:  
>>
>>>> I appreciate the work to consolidate duplicate code. However, I am not a
>>>> fan of new typedefs, in addition you return status_t codes in functions
>>>> changed to return error_t, which is inconsistent.  
>>>
>>> Hi Jes,
>>> Indeed, initially I named it as error_t and I forgot to update that part.
>>> I'm surprised that compiler didn't catch it. Thanks!
>>>
>>> About typedef, I did it same for IMSM already:
>>> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super-intel.c#n376
>>> I can change that but I wanted to define a common solution propagated later
>>> to other mdadm parts.  
>>
>> I am really on the fence on this one. I'd very much like to see us get
>> away from the nasty 0/1/2 error codes we currently have all over the
>> place, but I am also vary of reinventing the wheel.
>>
>> I must admit I missed it in super-intel.c
>>
>>>> I would prefer if we move towards standard POSIX error codes instead of
>>>> trying to invent new ones.
>>>>  
>>>
>>> The POSIX errors are defined for communication with kernel space and
>>> unfortunately they are not detailed enough. For example "undefined" or
>>> just "general_error" statuses are not available.
>>> https://man7.org/linux/man-pages/man3/errno.3.html
>>> It the approach I proposed we are free to create exact errors we need.
>>> Later we can create a map of error values to string and create dedicated
>>> error print functions.  
>>
>> I agree that POSIX codes aren't perfect, however at least for the
>> current errors I see reported in this patch -EINVAL or -E2BIG ought to
>> cover. If you think there are many cases where we cannot map well to
>> POSIX, then I would be OK with it, but I would prefer to go straight to
>> a global error code space rather than one per subsystem.
>>
>> Thoughts?
>>
> Hi Jes,
> 
> I was in this place with ledmon project:
> https://github.com/intel/ledmon/blob/master/src/status.h
> 
> Yeah, it seems to be overhead to maintain error enum per each subsystem yet, you
> are right here. I don't plan huge code reactor to make those enums common used.
> If we don't plan mdadm library, then there is no need to handle define multiple
> enums. It has real sense if we want to hide some statuses from library user
> inside our code.
> 
> I would like to handle internal error definitions because I think that mdadm
> deserves flexibility to define status what it needs. In general case we needs
> just *error* but when it comes to more advanced flows I can see multiple
> meaningful statuses we need to differentiate. The goal here is to make errors
> straightforward.
> 
> I don't consider it as reinventing the wheel because the software is free
> to define error handlers as it wants. There are no restrictions and POSIX codes
> are not a solution. POSIX codes are available to us because we need to
> understand kernel error codes and we need to handle them and react
> appropriately.
> 
> Simply, I would like to have error possibly the best self described and the
> error enum allows me to achieve that. It also forces developers to
> follow the statuses we have there because if something like that is defined,
> there is high probability that maintainer will ask developer to use this enum
> in new function and use meaningful error codes respectively.
> 
> I would like to add this enum to mdadm.h but I will avoid to adding more enum
> in the future if there is no need to. Let me know if that works for you.

Sounds fair!

Maybe it would be worth starting the enum outside the range of the
regular errno so they can overlap? Not sure if it adds any value, just a
thought.

Cheers,
Jes


