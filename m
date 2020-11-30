Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7FBC64E8A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 13:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE5B20708
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 13:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgK3NMX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:12:23 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:45898 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgK3NMX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 08:12:23 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kjixu-0002ld-8X; Mon, 30 Nov 2020 13:11:39 +0000
Subject: =?UTF-8?Q?Re=3a_=e2=80=9croot_account_locked=e2=80=9d_after_removin?=
 =?UTF-8?Q?g_one_RAID1_hard_disc?=
To:     Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
 <5FC4DEED.9030802@youngman.org.uk>
 <832e1194-cc76-b8f8-cb59-2e6bedaeb4dc@thelounge.net>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <a5288edf-0f77-d813-2f68-995dc4be2ca5@youngman.org.uk>
Date:   Mon, 30 Nov 2020 13:11:40 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <832e1194-cc76-b8f8-cb59-2e6bedaeb4dc@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/11/2020 12:13, Reindl Harald wrote:
> 
> 
> Am 30.11.20 um 13:00 schrieb Wols Lists:
>> On 30/11/20 10:31, Reindl Harald wrote:
>>> since when is it broken that way?
>>>
>>> from where should that commandlien come from when the operating system
>>> itself is on the for no vali dreason not assembling RAID?
>>>
>>> luckily the past few years no disks died but on the office server 300
>>> kilometers from here with /boot, os and /data on RAID1 this was not true
>>> at least 10 years
>>>
>>> * disk died
>>> * boss replaced it and made sure
>>>    the remaining is on the first SATA
>>>    port
>>> * power on
>>> * machine booted
>>> * me partitioned and added the new drive
>>>
>>> hell it's and ordinary situation for a RAID that a disk disappears
>>> without warning because they tend to die from one moment to the next
>>>
>>> hell it's expected behavior to boot from the remaining disks, no matter
>>> RAID1, RAID10, RAID5 as long as there are enough present for the whole
>>> dataset
>>>
>>> the only thing i expect in that case is that it takes a little longer to
>>> boot when soemthing tries to wait until a timeout for the missing device
>>> / componenzt
>>>
>> So what happened? The disk failed, you shut down the server, the boss
>> replaced it, and you rebooted?
> 
> in most cases smartd shouts a warning, the machine is powered down 
> *without* remove the partitions from the RAID devices

And? The partitions have nothing to do with it.

The disk failed, the system was shut down, THE SUPERBLOCK WAS UPDATED!
> 
> the disk with SMART alerts is replaced by a blank, unpartitioned one
> 
> the remaining disk is made to be sure on the first SATA so that the 
> first disk found by the BIOS is not the new blank one
> 
>> In that case I would EXPECT the system to come back - the superblock
>> matches the disks, the system says "everything is as it was", and your
>> degraded array boots fine.
> 
> correct, RAID comes up degraded
> 
>> EXCEPT THAT'S NOT WHAT IS HAPPENING HERE.
>>
>> The - fully functional - array is shut down.
>>
>> A disk is removed.
>>
>> On boot, reality and the superblock DISAGREE. In which case the system
>> takes the only sensible route, screams "help!", and waits for MANUAL
>> INTERVENTION.
> 
> but i fail to see the difference and to understand why reality and 
> superblock disagree,

In YOUR case the array was degraded BEFORE shutdown. In the OP's case, 
the array was degraded AFTER shutdown.

> it shouldn't matter how and when a disk is removed, 
> it's not there, so what as long as there are enough disks to bring the 
> array up

FFS - how on earth is the system supposed to update the superblock, if 
it's SWITCHED OFF. !?!?
> 
> in my case the fully functional array is shutdown too by shutdown the 
> machine and after that one disk is replaced and when the RAID comes up 
> there is a disk logically missing because on it's place is a blank one 
> without any partitions
> 
>> That's why you only have to force a degraded array to boot once - once
>> the disks and superblock are back in sync, the system assumes the ops
>> know about it.
> still don't get how that happens and why

Just ask yourself this simple question. "Did the array change state 
BETWEEN SHUTDOWN AND BOOT?". In *your* case the answer is "no", in the 
OP's case it is "yes". And THAT is what matters - if the array is 
degraded at boot, but was fully functional at shutdown, the raid system 
screams for help.

Cheers,
Wol
