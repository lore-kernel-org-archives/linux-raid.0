Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FE0C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 00:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiGRAj1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRAj0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Jul 2022 20:39:26 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B9C6573
        for <linux-raid@vger.kernel.org>; Sun, 17 Jul 2022 17:39:24 -0700 (PDT)
Message-ID: <2329c9c3-f0bd-0ed2-ef01-07fca1cf9ed1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658104761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqfLoWbD62IWn7+ono/uO9v9Hdbjc5ZbYpgrPY6PYo4=;
        b=wJNLTseaNvGFeSiaLTMtQ0ei6LPS1W4P+n9l55PqK5Cti43PXtPtBwlysyzpuqnjTyv5y8
        F8+CW/fMrC9CfEaIVCa+UKRlDDVkaeRzzE/TC3+VBM6FMFdfp7w60wCYpgd/mrJu01Il9O
        8ciAxszRHln9ZbBuPD9f1nD+B5v/JgY=
Date:   Mon, 18 Jul 2022 08:39:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND] raid5: fix duplicate checks for
 rdev->saved_raid_disk
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220716031136.1426264-1-liu.yun@linux.dev>
 <CAPhsuW7O2V1D4OT7xJKnjeQVVd8=oKLsxq7K4mXJGR31MN03Lw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jackie Liu <liu.yun@linux.dev>
In-Reply-To: <CAPhsuW7O2V1D4OT7xJKnjeQVVd8=oKLsxq7K4mXJGR31MN03Lw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song.

在 2022/7/17 13:31, Song Liu 写道:
> On Fri, Jul 15, 2022 at 8:11 PM Jackie Liu <liu.yun@linux.dev> wrote:
>>
>> From: Jackie Liu <liuyun01@kylinos.cn>
>>
>> 'first' will always be greater than or equal to 0, it is unnecessary to
>> repeat the 0 check, clean it up.
>>
>> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> 
> This looks identical to the original version. Which branch is this based on?

I based on linux.git/v5.19-rc7, it's linus tree.

> Please rebase on top of md-next branch and resend the patch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/log/?h=md-next

Sure. will send new patch base this branch.

> 
> Thanks,
> Song
> 
>> ---
>>   drivers/md/raid5.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 20e53b167f81..a0b38a0ea9c3 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -8063,8 +8063,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>>           * find the disk ... but prefer rdev->saved_raid_disk
>>           * if possible.
>>           */
>> -       if (rdev->saved_raid_disk >= 0 &&
>> -           rdev->saved_raid_disk >= first &&
>> +       if (rdev->saved_raid_disk >= first &&
>>              rdev->saved_raid_disk <= last &&
>>              conf->disks[rdev->saved_raid_disk].rdev == NULL)
>>                  first = rdev->saved_raid_disk;
>> --
>> 2.25.1
>>
