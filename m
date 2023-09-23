Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815CECE7A88
	for <linux-raid@archiver.kernel.org>; Sat, 23 Sep 2023 15:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjIWPSM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Sep 2023 11:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjIWPSM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Sep 2023 11:18:12 -0400
Received: from micaiah.parthemores.com (micaiah.parthemores.com [199.26.172.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0612D193
        for <linux-raid@vger.kernel.org>; Sat, 23 Sep 2023 08:18:04 -0700 (PDT)
Received: from [192.168.50.170] (h-155-4-132-6.NA.cust.bahnhof.se [155.4.132.6])
        by micaiah.parthemores.com (Postfix) with ESMTPSA id 2964F300A6B;
        Sat, 23 Sep 2023 17:17:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parthemores.com;
        s=micaiah; t=1695482226;
        bh=VwIP4BofFYSLBR481I32MfqN294SwOgHpcP1ZUX8BXc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=cu2QUsbGVPVCniqY2Q/XbOIJtDxvYMs2BSDP6fN3KimIdv5QJ5miQB3FwUHyStOS6
         o4Vm3ZFQjcgCxYKRRenhKktEEWkHwQH1v4EBkPD1scUqM2m4SCTcZ8whC0+CPpvrMh
         1CZ58qzN3Q+gblxmyhq/2XVzEp+00Myx2Niua5q8=
Message-ID: <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
Date:   Sat, 23 Sep 2023 17:18:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: request for help on IMSM-metadata RAID-5 array
Content-Language: en-GB
To:     Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
 <20230923162449.3ea0d586@nvm>
From:   Joel Parthemore <joel@parthemores.com>
In-Reply-To: <20230923162449.3ea0d586@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Den 2023-09-23 kl. 13:24, skrev Roman Mamedov:
> On Sat, 23 Sep 2023 12:54:52 +0200
> Joel Parthemore <joel@parthemores.com> wrote:
>
>> the RAID array looking seemingly okay (according to mdadm -D) BUT this
>> time, any attempt to access the RAID array or even just stop the array
>> (mdadm --stop /dev/md126, mdadm --stop /dev/md127) once it was started
>> would cause the RAID array to lock up. That means (I think) that I can't
>> create an image of the array contents using dd, which is what -- of
>> course -- I should have done in the first place. (I could assemble the
>> RAID array read-only, but the RAID array is out of sync because it
>> didn't shut down properly.)
> Does accessing the array also lock up when it's assembled read-only?


I didn't want to try that again until I had confirmation that the 
out-of-sync wouldn't (or shouldn't) be an issue. (I had tried it once 
before, but the system had somehow swapped /dev/md126 and /dev/md127 so 
that /dev/md126 became the container and /dev/md127 the RAID-5 array, 
which confused me. So I stopped experimenting further until I had a 
chance to write to the list.)

The array is assembled read only, and this time both /dev/md126 and 
/dev/md127 are looking like I expect them to. I started dd to make a 
backup image using dd if=/dev/md126 of=/dev/sdc bs=64K 
conv=noerror,sync. (The EXT4 file store on the 2TB RAID-5 array is about 
900GB full.) At first, it was running most of the time and just 
occasionally in uninterruptible sleep, but the periods of 
uninterruptible sleep quickly started getting longer. Now it seems to be 
spending most but not quite all of its time in uninterruptible sleep. Is 
this some kind of race condition? Anyway, I'll leave it running 
overnight to see if it completes.

Accessing the RAID array definitely isn't locking things up this time. I 
can go in and look at the partition table, for example, no problem. 
Access is awfully slow, but I assume that's because of whatever dd is or 
isn't doing.

By the way, I'm using kernel 6.5.3, which isn't the latest (that would 
be 6.5.5) but is close.

Thanks for the help,

Joel Parthemore

