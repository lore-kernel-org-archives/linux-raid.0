Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A52C43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 00:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiGTAXi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 20:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiGTAXh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 20:23:37 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D9859270
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 17:23:36 -0700 (PDT)
Message-ID: <7be202aa-b2e4-7053-d9a4-e08358e50b9e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658276614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V7FLMzwQqqmbCrGL9que8rDlv7YNVJZWp+AjBTXyVro=;
        b=rODosPvl++nYtvuELyOkwNej71FMqHlatxjopLNBUqmfGvXNoeZIbKJkCSvDGrC4b4Z+uM
        bQNHlPLHzXuqCfypw2rRh6pTxqzshFbnHBhdgkZR+EgVt7bad/n0pvpQdb/Dt4N4NZDlNM
        CyeSMaI+pMnc4rfGkT+q0cHKx3sItDI=
Date:   Wed, 20 Jul 2022 08:23:25 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND] raid5: fix duplicate checks for
 rdev->saved_raid_disk
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220716031136.1426264-1-liu.yun@linux.dev>
 <CAPhsuW7O2V1D4OT7xJKnjeQVVd8=oKLsxq7K4mXJGR31MN03Lw@mail.gmail.com>
 <8c062246-5cdf-9821-c047-e18f54f392e3@linux.dev>
 <CAPhsuW5qeiAUPmOg33JPH-ha1Rus+1qA0ET+oQLLhex6w65MDg@mail.gmail.com>
 <CAPhsuW4d9kS9m211wrQUFeXQdeim7POpoWno-1_fFocNS=ik6g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jackie Liu <liu.yun@linux.dev>
In-Reply-To: <CAPhsuW4d9kS9m211wrQUFeXQdeim7POpoWno-1_fFocNS=ik6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song.

It's fine. Thanks.

--
Jackie Liu

在 2022/7/20 02:45, Song Liu 写道:
> Hi Jackie,
> 
> As suggested by Jens, I will postpone this fix until after the merge window.
> 
> Thanks,
> Song
> 
> On Sun, Jul 17, 2022 at 11:08 PM Song Liu <song@kernel.org> wrote:
>>
>> On Sun, Jul 17, 2022 at 10:19 PM Jackie Liu <liu.yun@linux.dev> wrote:
>>>
>>> Hi, Song.
>>>
>>> 在 2022/7/17 13:31, Song Liu 写道:
>>>> On Fri, Jul 15, 2022 at 8:11 PM Jackie Liu <liu.yun@linux.dev> wrote:
>>>>>
>>>>> From: Jackie Liu <liuyun01@kylinos.cn>
>>>>>
>>>>> 'first' will always be greater than or equal to 0, it is unnecessary to
>>>>> repeat the 0 check, clean it up.
>>>>>
>>>>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
>>>>
>>>> This looks identical to the original version. Which branch is this based on?
>>>> Please rebase on top of md-next branch and resend the patch:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/log/?h=md-next
>>>>
>>>
>>> The md-next branch is lower than the upstream version, v5.19-rc5
>>> adds a patch.
>>>
>>> commit 617b365872a247480e9dcd50a32c8d1806b21861
>>> Author: Mikulas Patocka <mpatocka@redhat.com>
>>> Date:   Wed Jun 29 13:40:57 2022 -0400
>>>
>>>       dm raid: fix KASAN warning in raid5_add_disks
>>>
>>>       There's a KASAN warning in raid5_add_disk when running the LVM
>>> testsuite.
>>>       The warning happens in the test
>>>       lvconvert-raid-reshape-linear_to_raid6-single-type.sh. We fix the
>>> warning
>>>       by verifying that rdev->saved_raid_disk is within limits.
>>>
>>>       Cc: stable@vger.kernel.org
>>>       Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>       Signed-off-by: Mike Snitzer <snitzer@kernel.org>
>>>
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index ba289411f26f..20e53b167f81 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -8065,6 +8065,7 @@ static int raid5_add_disk(struct mddev *mddev,
>>> struct md_rdev *rdev)
>>>            */
>>>           if (rdev->saved_raid_disk >= 0 &&
>>>               rdev->saved_raid_disk >= first &&
>>> +           rdev->saved_raid_disk <= last &&
>>>               conf->disks[rdev->saved_raid_disk].rdev == NULL)
>>>                   first = rdev->saved_raid_disk;
>>>
>>> ...
>>> can you rebase from upstream? Thanks.
>>
>> ah, I see. Now it works. No need to resend.
>>
>> Thanks,
>> Song
