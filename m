Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB05CCE7A88
	for <linux-raid@archiver.kernel.org>; Sat, 23 Sep 2023 15:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjIWPp7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Sep 2023 11:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbjIWPp6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Sep 2023 11:45:58 -0400
Received: from micaiah.parthemores.com (micaiah.parthemores.com [199.26.172.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F296A19A
        for <linux-raid@vger.kernel.org>; Sat, 23 Sep 2023 08:45:51 -0700 (PDT)
Received: from [192.168.50.170] (h-155-4-132-6.NA.cust.bahnhof.se [155.4.132.6])
        by micaiah.parthemores.com (Postfix) with ESMTPSA id 4A7ED300A6B;
        Sat, 23 Sep 2023 17:44:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parthemores.com;
        s=micaiah; t=1695483893;
        bh=uQv4hdQrSa45So1K5vKB5tKO4rmORgIhQSVseu1+tlM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Va/rg4upFH2NwnPFGgQMzC+wNzyBkEO8JI/5QvZPffvniHnyL0GxXpw3nSoks4w3A
         vgM163ajN/5eOHAPxlQWanKA3sYudepr4ODbqVbWnx9dtEUHVRW2bhi7ZY0N+jzdCG
         8bveXV6KO9alHXVps41jWLZ3T+v4w25T+q0Tp8kc=
Message-ID: <b0a940ad-adac-0df4-6654-7b6e1c535616@parthemores.com>
Date:   Sat, 23 Sep 2023 17:45:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: request for help on IMSM-metadata RAID-5 array
Content-Language: en-GB
To:     Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
 <20230923162449.3ea0d586@nvm>
 <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
 <20230923203512.581fcd7d@nvm>
From:   Joel Parthemore <joel@parthemores.com>
In-Reply-To: <20230923203512.581fcd7d@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have been wondering about HDD issues all along, of course, though I 
didn't see any smoking gun.

I ran iostat -x 2 /dev/sdX on all three drives. All show an idle rate of 
just under 90%. So I don't think that's the problem.

Joel

Den 2023-09-23 kl. 17:35, skrev Roman Mamedov:
> On Sat, 23 Sep 2023 17:18:00 +0200
> Joel Parthemore <joel@parthemores.com> wrote:
>
>> I didn't want to try that again until I had confirmation that the
>> out-of-sync wouldn't (or shouldn't) be an issue. (I had tried it once
>> before, but the system had somehow swapped /dev/md126 and /dev/md127 so
>> that /dev/md126 became the container and /dev/md127 the RAID-5 array,
>> which confused me. So I stopped experimenting further until I had a
>> chance to write to the list.)
>>
>> The array is assembled read only, and this time both /dev/md126 and
>> /dev/md127 are looking like I expect them to. I started dd to make a
>> backup image using dd if=/dev/md126 of=/dev/sdc bs=64K
>> conv=noerror,sync. (The EXT4 file store on the 2TB RAID-5 array is about
>> 900GB full.) At first, it was running most of the time and just
>> occasionally in uninterruptible sleep, but the periods of
>> uninterruptible sleep quickly started getting longer. Now it seems to be
>> spending most but not quite all of its time in uninterruptible sleep. Is
>> this some kind of race condition? Anyway, I'll leave it running
>> overnight to see if it completes.
>>
>> Accessing the RAID array definitely isn't locking things up this time. I
>> can go in and look at the partition table, for example, no problem.
>> Access is awfully slow, but I assume that's because of whatever dd is or
>> isn't doing.
>>
>> By the way, I'm using kernel 6.5.3, which isn't the latest (that would
>> be 6.5.5) but is close.
> Maybe it's an HDD issue, one of them did have some unreadable sectors in the
> past, although the firmware has not decided to do anything about that, such
> as reallocating them and recording that in SMART.
>
> Check if one of the drives is holding up things, with a command like
>
>    iostat -x 2 /dev/sd?
>
> If you see 100% next to one of the drives, and much less for others, that one
> might be culprit.
