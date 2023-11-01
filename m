Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FFEC4167B
	for <linux-raid@archiver.kernel.org>; Wed,  1 Nov 2023 06:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345276AbjKAGpB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Nov 2023 02:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345237AbjKAGpA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Nov 2023 02:45:00 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933ED11D
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 23:44:55 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKyDN4Fbcz9R5k
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 17:44:52 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKyDN1Xxqz9QV2
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 17:44:52 +1100 (AEDT)
Message-ID: <60eb72b9-a9a6-4887-a206-6b026bad0516@eyal.emu.id.au>
Date:   Wed, 1 Nov 2023 17:44:47 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [now urgent] problem with recovered array
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <a095b798-6bfc-4b41-9d1d-19b99a9279bf@eyal.emu.id.au>
 <d3a6a9a1-0dc4-4aa4-b215-ba3a864a80bb@eyal.emu.id.au>
From:   eyal@eyal.emu.id.au
In-Reply-To: <d3a6a9a1-0dc4-4aa4-b215-ba3a864a80bb@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Bugger, I changed my mind. I now see that recordings do show write activity.

The reason why playing a recording from 12h ago does not show any reads is probably
because it is still in the cache, but not dirty. I guess.

My original problem remains though. rsync a large tree of small files to the array
chokes after a minute and after that, writing progresses at a very slow pace
of a few 10s of KB/s. A kthread then starts, runs at 100%CPU for hours even though
only 5 GB were copied.

See my recent thread 'problem with recovered array' for details. The problem is still urgent.
I cannot safely shut down the machine.

On 01/11/2023 15.31, eyal@eyal.emu.id.au wrote:
> Why do I see it as urgent now:
> I suspect that my system will soon run out of cache (due to no writes of dirty blocks to the array)
> and fail in an ugly way.
> 
> If you can help then please read this thread.
> 
> Another unusual observation of the situation where the system looks OK but is evidently not.
> 
> While pondering the above situation, I noticed that when I watched a mythtv recording,
> which is on the array (md127), I see no activity on md127 or the components '/dev/sd[b-g]1'.(*1)
> 
> Now, if I watch a program from earlier, from before the last boot(*2), I do see it in iostat.
> Is it possible that all the recent recordings are still cached and were never written to disk?
> 
> What is holding the system from draining the cache? Is the array somehow in readonly mode? How do I fix this?
> I now think that on shutdown, a sync is done that ends up preventing the shutdown from completion.
> 
> BTW, before, in the same situation, running 'sync' never completes.
> 
> HTH
> 
> (*1)
> $ df -h /data1
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md127       55T   45T  9.8T  83% /data1
> 
> ]$ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid6 sde1[4] sdc1[9] sdf1[5] sdb1[8] sdd1[7] sdg1[6]
>        58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
>        bitmap: 88/88 pages [352KB], 65536KB chunk
> 
> $ locate 2050_20231031093600.ts
> /data1/mythtv/lib/2050_20231031093600.ts
> 
> $ ls -l /var/lib/mythtv
> lrwxrwxrwx 1 root root 17 Feb 26  2023 /var/lib/mythtv -> /data1/mythtv/lib
> 
> $ ls -l /data1/mythtv/lib/2050_20231031093600.ts
> -rw-r--r-- 1 mythtv mythtv 2362511964 Oct 31 21:24 /data1/mythtv/lib/2050_20231031093600.ts
> 
> (*2)
> $ uptime
>   15:02:37 up 15:05, 27 users,  load average: 0.49, 0.59, 0.67
> 
> 
> On 01/11/2023 08.44, eyal@eyal.emu.id.au wrote:
>> On 31/10/2023 00.35, eyal@eyal.emu.id.au wrote:
>>> F38
>>>
>>> I know this is a bit long but I wanted to provide as much detail as I thought needed.
>>>
>>> I have a 7-member raid6. The other day I needed to send a disk for replacement.
>>> I have done this before and all looked well. The array is now degraded until I get the new disk.
> 
> [trimmed] See original posting.

-- 
Eyal at Home (eyal@eyal.emu.id.au)

