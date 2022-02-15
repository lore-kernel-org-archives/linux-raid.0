Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31578C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 15 Feb 2022 03:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiBODnz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:43:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiBODny (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Feb 2022 22:43:54 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5181C680E
        for <linux-raid@vger.kernel.org>; Mon, 14 Feb 2022 19:43:44 -0800 (PST)
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644896619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VEeJbDkVp1eofMceX3hik4N5hY9zIize9LBlmEcWUIA=;
        b=DjCMpEkNkgXpNDzaZ2nqN3p+GWCpYwWkYtyTfXRBXMMPwHGMtNfvY0mffqbRQBdHrg4hMm
        FPmjBhG3a16r+ts/zYdHVKlnqmwqbiYds9TRYBHTOAaCVHS495OGhTuDiAbwMo4ZU3NeAh
        dkUlVQ1njwv2EGJ1mOSCrLz8tVi4L9A=
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com>
 <de8e69dc-4e44-de6f-d3d2-9d52935c9b35@linux.dev>
 <20220214103738.000017f8@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <67429e77-f669-87f7-c2db-aaa4f545590b@linux.dev>
Date:   Tue, 15 Feb 2022 11:43:34 +0800
MIME-Version: 1.0
In-Reply-To: <20220214103738.000017f8@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2/14/22 5:37 PM, Mariusz Tkaczyk wrote:
> On Sat, 12 Feb 2022 09:12:00 +0800
> Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>> On 1/27/22 11:39 PM, Mariusz Tkaczyk wrote:
>>> Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and
>>> fail BIOs if a member is gone") allowed to finish writes earlier
>>> (before level dependent actions) for non-redundant arrays.
>>>
>>> To achieve that MD_BROKEN is added to mddev->flags if drive
>>> disappearance is detected. This is done in is_mddev_broken() which
>>> is confusing and not consistent with other levels where
>>> error_handler() is used. This patch adds appropriate error_handler
>>> for raid0 and linear.
>> I think the purpose of them are quite different, as said before,
>> error_handler
>> is mostly against rdev while is_mddev_broken is for mddev though it
>> needs to test rdev first.
> I changed is_mddev_broken to is_rdev_broken, because it checks the
> device now. On error it calls md_error and later error_handler.
> I unified error handling for each level. Do you consider it as wrong?

I am neutral to the change

>> It also adopts md_error(), we only want to call .error_handler for
>> those levels. mddev->pers->sync_request is additionally checked,
>> its existence implies a level with redundancy.
>>
>> Usage of error_handler causes that disk failure can be requested
>> from userspace. User can fail the array via #mdadm --set-faulty
>> command. This is not safe and will be fixed in mdadm.
>> What is the safe issue here? It would betterr to post mdadm fix
>> together.
> We can and should block user from damaging raid even if it is
> recoverable. It is a regression.

I don't follow, did you mean --set-fault from mdadm could "damaging raid"?

> I will fix mdadm. I don't consider it as a big risk (because it is
> recoverable) so I focused on kernel part first.
>
>>> It is correctable because failed
>>> state is not recorded in the metadata. After next assembly array
>>> will be read-write again.
>> I don't think it is a problem, care to explain why it can't be RW
>> again?
> failed state is not recoverable in runtime, so you need to recreate
> array.

IIUC, the failfast flag is supposed to be set during transient error not
permanent failure, the rdev (marked as failfast) need to be revalidated
and readded to array.


[ ... ]

>>> +		char *md_name = mdname(mddev);
>>> +
>>> +		pr_crit("md/linear%s: Disk failure on %pg
>>> detected.\n"
>>> +			"md/linear:%s: Cannot continue, failing
>>> array.\n",
>>> +			md_name, rdev->bdev, md_name);
>> The second md_name is not needed.
> Could you elaborate here more? Do you want to skip device name in
> second message?

Yes, we printed two md_name here, seems unnecessary.

[ ... ]

>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct
>>> md_rdev *rdev)
>>>    	if (!mddev->pers || !mddev->pers->error_handler)
>>>    		return;
>>> -	mddev->pers->error_handler(mddev,rdev);
>>> +	mddev->pers->error_handler(mddev, rdev);
>>> +
>>> +	if (!mddev->pers->sync_request)
>>> +		return;
>> The above only valid for raid0 and linear, I guess it is fine if DM
>> don't create LV on top
>> of them. But the new checking deserves some comment above.
> Will do, could you propose comment?

Or, just check if it is raid0 or linear directly instead of implies 
level with
redundancy.

Thanks,
Guoqing
