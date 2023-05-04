Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9640C77B7C
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 08:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjEDIh1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 May 2023 04:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjEDIhZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 May 2023 04:37:25 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0109D
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 01:37:21 -0700 (PDT)
Received: from [192.168.100.1] ([94.134.214.237]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MEUaQ-1q0VnP2sEE-00Fxo0; Thu, 04 May 2023 10:36:57 +0200
Message-ID: <4051438a-e476-061d-a635-06671996b90b@online.de>
Date:   Thu, 4 May 2023 10:36:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Content-Language: de-DE, en-US
From:   Peter Neuwirth <reddunur@online.de>
To:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:JlS3LmsRyQzbKLMf0sB2o2Z7u1OZbfRtvDCz7gR4s59fvlSY6BU
 2ktnUZEDKG+Nkjl+15VeKGpqALAdlmnoAA6H6LIY+IQcoGdh2bGr4ognEt5gBj6eDdAtYtz
 g9cvfOA2UhRiCvYyUE7wQi3WXdUg4eTaBBRwxRn8wX9c6jFWPswLXkqTbnTISKRLB8hwA86
 ZmUbKyEPxQNiCKAoSvjeA==
UI-OutboundReport: notjunk:1;M01:P0:+piPIYWaSrM=;lm2flj3iNFQgbvVswUQy4ZD8a7p
 LkGTiZNBcx88xs5SeyBbrLWOjyRkQU+/VZzMssQ47QwmMUvRcn08PvUOn0UAIk8UwtfdRhZAz
 6tA4qLzq2S2CR/eunZxYCJuZ1YQJ0aFOsqujYAv0n9yEltQ73bDNP97supcZ8yjj2S2C0oOpY
 ief8ZAayaoH33S+MVwo+TgqJIjxxk6yz6FkoeavbgrLPnCYCKVnfnMAjhBj7992D6BmP3Pk4c
 dGReq1r0sP5MwtQiQWqwFLtmjJnEI2U7RoycmF8P0URx5HyUW/EWdEcBYLseKW8KD8FIKlKH4
 XBrBFbvray1BKNa2tRuuObCuAKxATj6yogGP6LwvROaiKX/vK8tfJGZIcboVfC+MlTXDOsRbo
 N/z9GpqpicKh+MGs9oNZ9zkEy/YUyty3n9Lfqy8z2ID69Bdt3gEKp6XJc6lob7j8oRqxQUK4g
 zV4COCBEyDXNJdXSQm56dWs4iqgPTmmejH8xLXPqIxeEBnu8froiEwC9/AkhSuZGLMU1ve/G1
 qi4qYr6DIT4cI+hg0MFkhgf07kt1pD68soEAaUObcIyZz24XbCsYFeH8NaKhdb3PuAFaQZnl6
 YgUZQk/zZ5vwYPWA9/V7WFbXWFxcXzxR4xyKvgW2A/0eBHZhrolL3DHrmFA7G4G0l3gY6u6MP
 jZjTM9Zk6kXTZv725CyRxRvnoPbzqeiPiaLz7nAx9g==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thank you, Kuai!
So my gut instinct was not that bad. Now as I could reassemble my raid set (it tried to recontinue the rebuild, I stopped it)
I have a /dev/md0 but it seems that no sensible data is stored on it. Not even a partition table could be found.

 From your investigations, what would you say : is there hope I could rescue some of the data from the raidset with a tool
like testdisk, when I "recreate" my old gpt partition table ? Or is it likely that the restarted reshape/grow process made
minced meat out of my whole raid data ?
It seemed interesting to me, that the first grow/shape process seemed to not even touch the two added discs, shown as
spare now, their partition tables had not been touched. The process seems to deal only with my legacy raid 5 set with
six plates and seemed to move it to a transient raid5/6 architecture, therefore operating atleast on the disc (3) of legacy
set, that is now missing..
I'm not sure, how much time to spend in this data is sensible,
your advice could be very helpful.

regards

Peter


Am 04.05.23 um 10:16 schrieb Yu Kuai:
> Hi,
>
> 在 2023/04/28 5:09, Peter Neuwirth 写道:
>> Hello linux-raid group.
>>
>> I have an issue with my linux raid setup and I hope somebody here
>> could help me get my raid active again without data loss.
>>
>> I have a debian 11 system with one raid array (6x 1TB hdd drives, raid level 5 )
>> that was active running till today, when I added two more 1TB hdd drives
>> and also changed the raid level to 6.
>>
>> Note: For completition:
>>
>> My raid setup month ago was
>>
>> mdadm --create --verbose /dev/md0 -c 256K --level=5 --raid-devices=6  /dev/sdd /dev/sdc /dev/sdb /dev/sda /dev/sdg /dev/sdf
>>
>> mkfs.xfs -d su=254k,sw=6 -l version=2,su=256k -s size=4k /dev/md0
>>
>> mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
>>
>> update-initramfs -u
>>
>> echo '/dev/md0 /mnt/data ext4 defaults,nofail,discard 0 0' | sudo tee -a /etc/fstab
>>
>>
>> Today I did:
>>
>> mdadm --add /dev/md0 /dev/sdg /dev/sdh
>>
>> sudo mdadm --grow /dev/md0 --level=6
>>
>>
>> This started a growth process, I could observe with
>> watch -n 1 cat /proc/mdstat
>> and md0 was still usable all the day.
>> Due to speedy file access reasons I paused the grow and insertion
>> process today at about 50% by issue
>>
>> echo "frozen" > /sys/block/md0/md/sync_action
>>
>>
>> After the file access was done, I restarted the
>> process with
>>
>> echo reshape > /sys/block/md0/md/sync_action
>>
> After look into this problem, I figure out that this is how the problem
> (corrupted data) triggered in the first place, while the problem that
> kernel log about "md: cannot handle concurrent replacement and reshape"
> is not fatal.
>
> "echo reshape" will restart the whole process, while recorded reshape
> position should be used. This is a seriously kernel bug, I'll try to fix
> this soon.
>
> By the way, "echo idle" should avoid this problem.
>
> Thanks,
> Kuai
>>
>> but I saw in mdstat that it started form the scratch.
>> After about 5 min I noticed, that /dev/dm0 mount was gone with
>> an input/output error in syslog and I rebooted the computer, to see the
>> kernel would reassemble dm0 correctly. Maybe the this was a problem,
>> because the dm0 was still reshaping, I do not know..
>

