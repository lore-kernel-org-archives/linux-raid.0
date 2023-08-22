Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C38EE49A4
	for <linux-raid@archiver.kernel.org>; Tue, 22 Aug 2023 12:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbjHVMrm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 08:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjHVMrm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 08:47:42 -0400
X-Greylist: delayed 366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 05:47:31 PDT
Received: from out-55.mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30A0CE8
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 05:47:31 -0700 (PDT)
Message-ID: <35130b3f-c0fd-e2d6-e849-a5ceb6a2895f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692708082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTilMz2CDbWouopIuwfNHDClbeAzVoPD8IX4A7TLmJg=;
        b=V+rO3XA6g+qXgDjsX2bSBOmgY5YMmpipQgY/LG+XTKtSm5Yv1DM8fb6u1H5/+c2rpw2F/C
        Ma2bt34R/cOTEZPOF0/xtsa11/pMSZTD+gI/CCwiRlaxNIfFSB7bB/SZ/A9wK6Y58bIst1
        1kp1z0KAI8OnEZPTlyxZlWtqiz0fI6A=
Date:   Tue, 22 Aug 2023 20:41:15 +0800
MIME-Version: 1.0
Subject: Re: Infiniate systemd loop when power off the machine with multiple
 MD RAIDs
To:     AceLan Kao <acelan@gmail.com>
Cc:     Song Liu <song@kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <028a21df-4397-80aa-c2a5-7c754560f595@gmail.com>
 <20230818101630.000027f4@linux.intel.com>
 <b0488ff7-10c8-4b4e-28b8-01809133c297@linux.dev>
 <CAPhsuW6cSLqwRVO_EpFyimvc7hgi1rb3T8-NA+stHdwrqrScBA@mail.gmail.com>
 <20230822083923.00007fb6@linux.intel.com>
 <CAMz9Wg8KE1rDkSaQnUTJ5ikzH7YGGYbkLM3AcrVue3=JgK+14w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAMz9Wg8KE1rDkSaQnUTJ5ikzH7YGGYbkLM3AcrVue3=JgK+14w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Acelan,

On 8/22/23 16:13, AceLan Kao wrote:
>>>>> Hello,
>>>>> The issue is reproducible with IMSM metadata too, around 20% of reboot
>>>>> hangs. I will try to raise the priority in the bug because it is valid
>>>>> high- the base functionality of the system is affected.
>>>> Since it it reproducible from your side, is it possible to turn the
>>>> reproduce steps into a test case
>>>> given the importance?
>> I didn't try to reproduce it locally yet because customer was able to
>> bisect the regression and it pointed them to the same patch so I connected it
>> and asked author to take a look first. At a first glance, I wanted to get
>> community voice to see if it is not something obvious.
>>
>> So far I know, customer is creating 3 IMSM raid arrays, one is the system
>> volume and do a reboot and it sporadically fails (around 20%). That is all.
>>
>>>> I guess If all arrays are set with MD_DELETED flag, then reboot might
>>>> hang, not sure whether
>>>> below (maybe need to flush wq as well  before list_del) helps or not,
>>>> just FYI.
>>>>
>>>> @@ -9566,8 +9566,10 @@ static int md_notify_reboot(struct notifier_block
>>>> *this,
>>>>
>>>>           spin_lock(&all_mddevs_lock);
>>>>           list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
>>>> -               if (!mddev_get(mddev))
>>>> +               if (!mddev_get(mddev)) {
>>>> +                       list_del(&mddev->all_mddevs);
>>>>                           continue;
>>>> +               }

My suggestion is delete the list node under this scenario, did you try 
above?

>>> I am still not able to reproduce this, probably due to differences in the
>>> timing. Maybe we only need something like:
>>>
>>> diff --git i/drivers/md/md.c w/drivers/md/md.c
>>> index 5c3c19b8d509..ebb529b0faf8 100644
>>> --- i/drivers/md/md.c
>>> +++ w/drivers/md/md.c
>>> @@ -9619,8 +9619,10 @@ static int md_notify_reboot(struct notifier_block
>>> *this,
>>>
>>>          spin_lock(&all_mddevs_lock);
>>>          list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
>>> -               if (!mddev_get(mddev))
>>> +               if (!mddev_get(mddev)) {
>>> +                       need_delay = 1;
>>>                          continue;
>>> +               }
>>>                  spin_unlock(&all_mddevs_lock);
>>>                  if (mddev_trylock(mddev)) {
>>>                          if (mddev->pers)
>>>
>>>
>>> Thanks,
>>> Song
>> I will try to reproduce issue at Intel lab to check this.
>>
>> Thanks,
>> Mariusz
> Hi Guoqing,
>
> Here is the command how I trigger the issue, have to do it around 10
> times to make sure the issue is reproducible
>
> echo "repair" | sudo tee /sys/class/block/md12?/md/sync_action && sudo
> grub-reboot "Advanced options for Ubuntu>Ubuntu, with Linux 6.5.0-rc77
> 06a74159504-dirty" && head -c 1G < /dev/urandom > myfile1 && sleep 180
> && head -c 1G < /dev/urandom > myfile2 && sleep 1 && cat /proc/mdstat
> && sleep 1 && rm myfile1 &&
> sudo reboot

Is the issue still reproducible with remove below from cmd?

echo "repair" | sudo tee /sys/class/block/md12?/md/sync_action

Just want to know if resync thread is related with the issue or not.

> And the patch to add need_delay doesn't work.

My assumption is that mddev_get always returns NULL, so set need_delay
wouldn't help.

Thanks,
Guoqing
