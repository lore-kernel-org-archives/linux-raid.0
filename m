Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2183AC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Dec 2021 01:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbhLVBqZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 20:46:25 -0500
Received: from out0.migadu.com ([94.23.1.103]:59134 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232258AbhLVBqY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 21 Dec 2021 20:46:24 -0500
Subject: Re: [PATCH 3/3] raid5: introduce MD_BROKEN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1640137581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5GTSZPLd//aVLg7MpOgjUUUiIrV4Vwfqz8azPctC+Zk=;
        b=w74qLUVgRiv41uT1s7KWrhZhtJ3Xop1y8s14J159OwPZzlqQop9vaEjKxJW984vA5uwDiT
        7frHzefVf3Ey94FylMACvL+X4aCMuaS8Nd36w7Xs3dv7pURmBAp56QF1ne9AYz7WClrasL
        HBAEo/xHdpbWq7hhXtjd5ZpBZOOvNmc=
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-4-mariusz.tkaczyk@linux.intel.com>
 <3d5fe975-265f-557e-5d13-88ef6b06bcba@linux.dev>
 <20211217093755.00007264@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <3da9324e-01e7-2a07-4bcd-14245db56693@linux.dev>
Date:   Wed, 22 Dec 2021 09:46:11 +0800
MIME-Version: 1.0
In-Reply-To: <20211217093755.00007264@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/17/21 4:37 PM, Mariusz Tkaczyk wrote:
> Hi Guoqing,
>
> On Fri, 17 Dec 2021 10:26:27 +0800
> Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index 1240a5c16af8..8b5561811431 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -690,6 +690,9 @@ static int has_failed(struct r5conf *conf)
>>>    {
>>>    	int degraded;
>>>    
>>> +	if (test_bit(MD_BROKEN, &conf->mddev->flags))
>>> +		return 1;
>>> +
>>>    	if (conf->mddev->reshape_position == MaxSector)
>>>    		return conf->mddev->degraded > conf->max_degraded;
>>>    
>>> @@ -2877,34 +2880,29 @@ static void raid5_error(struct mddev
>>> *mddev, struct md_rdev *rdev) unsigned long flags;
>>>    	pr_debug("raid456: error called\n");
>>>    
>>> -	spin_lock_irqsave(&conf->device_lock, flags);
>>> -
>>> -	if (test_bit(In_sync, &rdev->flags) &&
>>> -	    mddev->degraded == conf->max_degraded) {
>>> -		/*
>>> -		 * Don't allow to achieve failed state
>>> -		 * Don't try to recover this device
>>> -		 */
>>> -		conf->recovery_disabled = mddev->recovery_disabled;
>>> -		spin_unlock_irqrestore(&conf->device_lock, flags);
>>> -		return;
>>> -	}
>>> +	pr_crit("md/raid:%s: Disk failure on %s, disabling
>>> device.\n",
>>> +		mdname(mddev), bdevname(rdev->bdev, b));
>>>    
>>> +	spin_lock_irqsave(&conf->device_lock, flags);
>>>    	set_bit(Faulty, &rdev->flags);
>>>    	clear_bit(In_sync, &rdev->flags);
>>>    	mddev->degraded = raid5_calc_degraded(conf);
>>> +
>>> +	if (has_failed(conf)) {
>>> +		set_bit(MD_BROKEN, &mddev->flags);
>> What about other callers of has_failed? Do they need to set BROKEN
>> flag? Or set the flag in has_failed if it returns true, just FYI.
>>
> The function checks rdev->state for faulty. There are two, places
> where it can be set:
> - raid5_error (handled here)
> - raid5_spare_active (not a case IMO).
>
> I left it in raid5_error to be consistent with other levels.
> I think that moving it t has_failed is safe but I don't see any
> additional value in it.

 From raid5's point of view, it is broken in case has_failed returns 1, 
so it is
kind of inconsistent I think.

> I see that in raid5_error we hold device_lock. It is not true for
> all has_failed calls.

Didn't go detail of each caller, not sure the lock  is needed for set/clear
mddev->flags.

> Do you have any recommendations?

I don't have strong opinion for it.

Thanks,
Guoqing
