Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26A9C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 22 Dec 2021 01:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbhLVBWu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 20:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240670AbhLVBWu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 20:22:50 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CB1C06173F
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 17:22:49 -0800 (PST)
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1640136166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jorl+SwnCF7Hl5D24TxYgu0YarUgGaQaX0xY2kglyes=;
        b=GZxBao5rYAbqdnQarFZwKc1OXT5Z+qgMFcdxJyvnkOPMIEYdxtWT/eEqulY7YuXRBbciWJ
        XPHZHdTMvN0uhuXUapewzrrH6exNQGJJDi3qXVMd9XqnnBQpHZuIDxS6kIAUYvGGPgIoGl
        wTctM9a82K9+lOvmio19NuK3qcMj90U=
To:     Xiao Ni <xni@redhat.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
 <3d8128c8-7cca-a805-5433-027378cdd060@linux.dev>
 <CALTww2_QettJ2_=g=wNf_PMSesi0WiOz8OihFmWkMYNHe6L-dA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <619ecab5-4cc1-4ae9-8d1b-1772ad832dec@linux.dev>
Date:   Wed, 22 Dec 2021 09:22:41 +0800
MIME-Version: 1.0
In-Reply-To: <CALTww2_QettJ2_=g=wNf_PMSesi0WiOz8OihFmWkMYNHe6L-dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/19/21 11:26 AM, Xiao Ni wrote:
> On Fri, Dec 17, 2021 at 10:00 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 12/16/21 10:52 PM, Mariusz Tkaczyk wrote:
>>> Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs
>>> if a member is gone") allowed to finish writes earlier (before level
>>> dependent actions) for non-redundant arrays.
>>>
>>> To achieve that MD_BROKEN is added to mddev->flags if drive disappearance
>>> is detected. This is done in is_mddev_broken() which is confusing and not
>>> consistent with other levels where error_handler() is used.
>>> This patch adds appropriate error_handler for raid0 and linear.
>>>
>>> It also adopts md_error(), we only want to call .error_handler for those
>>> levels. mddev->pers->sync_request is additionally checked, its existence
>>> implies a level with redundancy.
>>>
>>> Usage of error_handler causes that disk failure can be requested from
>>> userspace. User can fail the array via #mdadm --set-faulty command. This
>>> is not safe and will be fixed in mdadm. It is correctable because failed
>>> state is not recorded in the metadata. After next assembly array will be
>>> read-write again. For safety reason is better to keep MD_BROKEN in
>>> runtime only.
>>>
>>> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>>> ---
>>>    drivers/md/md-linear.c | 15 ++++++++++++++-
>>>    drivers/md/md.c        |  6 +++++-
>>>    drivers/md/md.h        | 10 ++--------
>>>    drivers/md/raid0.c     | 15 ++++++++++++++-
>>>    4 files changed, 35 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
>>> index 1ff51647a682..415d2615d17a 100644
>>> --- a/drivers/md/md-linear.c
>>> +++ b/drivers/md/md-linear.c
>>> @@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
>>>                     bio_sector < start_sector))
>>>                goto out_of_bounds;
>>>
>>> -     if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
>>> +     if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
>>> +             md_error(mddev, tmp_dev->rdev);
>>>                bio_io_error(bio);
>>>                return true;
>>>        }
>>> @@ -281,6 +282,17 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
>>>        seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
>>>    }
>>>
>>> +static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
>>> +{
>>> +     char b[BDEVNAME_SIZE];
>>> +
>>> +     if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
>>> +             pr_crit("md/linear%s: Disk failure on %s detected.\n"
>>> +                     "md/linear:%s: Cannot continue, failing array.\n",
>>> +                     mdname(mddev), bdevname(rdev->bdev, b),
>>> +                     mdname(mddev));
>>> +}
>>> +
>> Do you consider to use %pg to print block device?
>>
>>>    static void linear_quiesce(struct mddev *mddev, int state)
>>>    {
>>>    }
>>> @@ -297,6 +309,7 @@ static struct md_personality linear_personality =
>>>        .hot_add_disk   = linear_add,
>>>        .size           = linear_size,
>>>        .quiesce        = linear_quiesce,
>>> +     .error_handler  = linear_error,
>>>    };
>>>
>>>    static int __init linear_init (void)
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index e8666bdc0d28..f888ef197765 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>>>
>>>        if (!mddev->pers || !mddev->pers->error_handler)
>>>                return;
>>> -     mddev->pers->error_handler(mddev,rdev);
>>> +     mddev->pers->error_handler(mddev, rdev);
>>> +
>>> +     if (!mddev->pers->sync_request)
>>> +             return;
>>> +
>> What is the reason of the above change? I suppose dm event can be missed.
> Hi Guoqing
>
> What's the dm event here?

Pls see mddev->event_work after above line, also commit 768e587e18 for dm
which might be relevant.

Thanks,
Guoqing

