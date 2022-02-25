Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301F4C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 25 Feb 2022 07:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbiBYHWm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Feb 2022 02:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiBYHWl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Feb 2022 02:22:41 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9067D17776B
        for <linux-raid@vger.kernel.org>; Thu, 24 Feb 2022 23:22:08 -0800 (PST)
Subject: Re: [PATCH 3/3] raid5: introduce MD_BROKEN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1645773726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9LSbFbaAGBt8uzTZ/YGzsOZocdYy4E+0RdAFgfXZxs=;
        b=DLPzE0s6IInBJvgw1NQ2FgXEfL6+jWKFXpZboppdAdQXeb+x04HpmRn32YTfS2VOuRF1lC
        xaUXbfii+7T8x+p+AA6bCCZMoO4Qd5DJRZWzKuASU5OcS1m6rKHXP09ULIbetDkJHwj0ZK
        1IKizQus+GSoqFq6gLbXDHdP6kVNs8E=
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-4-mariusz.tkaczyk@linux.intel.com>
 <fbe1ec39-acee-8226-adb2-6c61e3d7fdd0@linux.dev>
 <20220222151851.0000089a@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <8b918c2a-5b68-6ddc-0a23-69af70f28d7d@linux.dev>
Date:   Fri, 25 Feb 2022 15:22:00 +0800
MIME-Version: 1.0
In-Reply-To: <20220222151851.0000089a@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

On 2/22/22 10:18 PM, Mariusz Tkaczyk wrote:
>
>>>    
>>> -static int has_failed(struct r5conf *conf)
>>> +static bool has_failed(struct r5conf *conf)
>>>    {
>>> -	int degraded;
>>> +	int degraded = conf->mddev->degraded;
>>>    
>>> -	if (conf->mddev->reshape_position == MaxSector)
>>> -		return conf->mddev->degraded > conf->max_degraded;
>>> +	if (test_bit(MD_BROKEN, &conf->mddev->flags))
>>> +		return true;
>> If one member disk was set Faulty which caused BROKEN was set, is it
>> possible to re-add the same member disk again?
>>
> Is possible to re-add drive to failed raid5 array now? From my
> understanding of raid5_add_disk it is not possible.

I mean the below steps, it works as you can see.

>> [root@vm ~]# echo faulty > /sys/block/md0/md/dev-loop1/state
>> [root@vm ~]# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 loop2[2] loop1[0](F)
>>         1046528 blocks super 1.2 level 5, 512k chunk, algorithm 2
>> [2/1] [_U] bitmap: 0/1 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>> [root@vm ~]# echo re-add > /sys/block/md0/md/dev-loop1/state
>> [root@vm ~]# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 loop2[2] loop1[0]
>>         1046528 blocks super 1.2 level 5, 512k chunk, algorithm 2
>> [2/2] [UU] bitmap: 0/1 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>>
>> And have you run mdadm test against the series?
>>
> I run imsm test suite and our internal IMSM scope. I will take the
> challenge and will verify with native. Thanks for suggestion.

Cool, thank you.

BTW, I know the mdadm test suite is kind of broke, at least this one
which I aware.

https://lore.kernel.org/all/20220119055501.GD27703@xsang-OptiPlex-9020/

And given the complexity of md, the more we test, the less bug we can
avoid.


>>> -	degraded = raid5_calc_degraded(conf);
>>> -	if (degraded > conf->max_degraded)
>>> -		return 1;
>>> -	return 0;
>>> +	if (conf->mddev->reshape_position != MaxSector)
>>> +		degraded = raid5_calc_degraded(conf);
>>> +
>>> +	if (degraded > conf->max_degraded) {
>>> +		set_bit(MD_BROKEN, &conf->mddev->flags);
>> Why not set BROKEN flags in err handler to align with other levels? Or
>> do it in md_error only.
> https://lore.kernel.org/linux-raid/3da9324e-01e7-2a07-4bcd-14245db56693@linux.dev/
>
> You suggested that.
> Other levels doesn't have dedicates has_failed() routines. For raid5 it
> is reasonable to set it in has_failed().

When has_failed returns true which means MD_BROKEN should be set, if so,
then it makes sense to set it in raid5_error.


> I can't do that in md_error because I don't have such information in
> all cases. !test_bit("Faulty", rdev->flags) result varies.

Fair enough.

Thanks,
Guoqing
