Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B85BC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 02:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhLQCHu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 21:07:50 -0500
Received: from out0.migadu.com ([94.23.1.103]:35217 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231334AbhLQCHu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 16 Dec 2021 21:07:50 -0500
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639706866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=toqKdjeURP+Ij0mF7yqdrdN8NgYY8OLaIQ0Zwl+cKmI=;
        b=MjdZhDxlm64xh92+B3E34BzOs1FtulJRzBESThFxYD1xPNyUoNifYd9v1NIo5uMEONSFQN
        D6flHLWvVW7t67SN303Bbsl2E/m90UxeP1XmVjVGRGJKILYogVbNAW3x1C73j1SXNVpq/o
        oOv5LC25h0vyOYu2X1L7JMOlfLWi2yo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
 <3d8128c8-7cca-a805-5433-027378cdd060@linux.dev>
Message-ID: <ff9f4f19-fa49-4c55-ef41-c9970c906b5f@linux.dev>
Date:   Fri, 17 Dec 2021 10:07:39 +0800
MIME-Version: 1.0
In-Reply-To: <3d8128c8-7cca-a805-5433-027378cdd060@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/17/21 10:00 AM, Guoqing Jiang wrote:
>> +static inline bool is_rdev_broken(struct md_rdev *rdev)
>>   {
>> -    if (!disk_live(rdev->bdev->bd_disk)) {
>> -        if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
>> -            pr_warn("md: %s: %s array has a missing/failed member\n",
>> -                mdname(rdev->mddev), md_type);
>> -        return true;
>> -    }
>> -    return false;
>> +    return !disk_live(rdev->bdev->bd_disk);
>>   }
>
>
> Besides, if MD_BROKEN is not set here then I think you can also delete 
> the
> flag from other places as well. 

Oops, I didn't notice the flag is set elsewhere.

Thanks,
Guoqing
