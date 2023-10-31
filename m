Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C419C4167B
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 02:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjJaCul (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Oct 2023 22:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjJaCul (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Oct 2023 22:50:41 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2378DA6
        for <linux-raid@vger.kernel.org>; Mon, 30 Oct 2023 19:50:38 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKF4X6zC9z9RN0
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 13:50:36 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKF4X16Lrz9Pr4;
        Tue, 31 Oct 2023 13:50:34 +1100 (AEDT)
Message-ID: <2201b0da-c978-4cc4-82a4-416e0ff9e7bc@eyal.emu.id.au>
Date:   Tue, 31 Oct 2023 13:50:34 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: problem with recovered array
Content-Language: en-US
To:     eyal@eyal.emu.id.au, linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ae1e840e-4b7c-4f3b-958d-902de1db514a@eyal.emu.id.au>
From:   eyal@eyal.emu.id.au
In-Reply-To: <ae1e840e-4b7c-4f3b-958d-902de1db514a@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 31/10/2023 13.35, eyal@eyal.emu.id.au wrote:
> Thanks Roger,
> 
> On 31/10/2023 03.14, Roger Heflin wrote:
>> look at  SAR -d output for all the disks in the raid6.   It may be a
>> disk issue (though I suspect not given the 100% cpu show in raid).
> 
> It seems that sar is installed but not active here. Latest data is from 2017...
> 
>> Clearly something very expensive/deadlockish is happening because of
>> the raid having to rebuild the data from the missing disk, not sure
>> what could be wrong with it.
>>
>> If you are on a kernel that has a newer version upgrading and
>> rebooting may change something  If it is one close to the newest
>> kernel version going back a minor version (if 6.5 go back to the last
>> 6.4 kernel).
> 
> I am running the latest available kernel
>      6.5.8-200.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Fri Oct 20 15:53:48 UTC 2023 x86_64 GNU/Linux
> 
>> You might also install the perf package and run "perf top" and see
>> what sorts of calls the kernel is spending all of its time in.
> 
> I now installed perf. Below is a grab from the console. Should I use different options?
> 
> Does anyone understand it?
> 
> BTW, I now ran rsync into the array and it barely moved. In 2 hours it copied about 5GB.
> iostat shows about 5KB/s (kilobytes!) all that time.

rsync kept the thread running at 100% CPU. After stopping the copy, the thread was
no longer at the top of 'top' (could not see it listed at all).

> TIA
> 
> top shows
>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> 1385760 root      20   0       0      0      0 R  99.7   0.0 161:32.64 kworker/u16:4+flush-9:127
> 
> $ sudo perf top --pid 1385760 -g
> +  100.00%     0.49%  [kernel]  [k] ext4_mb_regular_allocator

[stack trimmed]

>> On Mon, Oct 30, 2023 at 8:44 AM <eyal@eyal.emu.id.au> wrote:
>>>
>>> F38
>>>
>>> I know this is a bit long but I wanted to provide as much detail as I thought needed.
>>>
>>> I have a 7-member raid6. The other day I needed to send a disk for replacement.
>>> I have done this before and all looked well. The array is now degraded until I get the new disk.
>>>
>>> At one point my system got into trouble and I am not sure why, but it started to have
>>> very slow response to open/close files, or even keystrokes. At the end I decided to reboot.
>>> It refused to complete the shutdown and after a while I used the sysrq feature for this.
>>>
>>> On the restart it dropped into emergency shell, the array had all members listed as spares.
>>> I tried to '--run' the array but mdadm refused 'cannot start dirty degraded array'
>>> though the array was now listed in mdstat and looked as expected.
>>>
>>> Since mdadm suggested I use --force', I did so
>>>          mdadm --assemble --force /dev/md127 /dev/sd{b,c,d,e,f,g}1
>>>
>>> Q0) was I correct to use this command?
>>>
>>> 2023-10-30T01:08:25+1100 kernel: md/raid:md127: raid level 6 active with 6 out of 7 devices, algorithm 2
>>> 2023-10-30T01:08:25+1100 kernel: md127: detected capacity change from 0 to 117187522560
>>> 2023-10-30T01:08:25+1100 kernel: md: requested-resync of RAID array md127
>>>
>>> Q1) What does this last line mean?
>>>
>>> Now that the array came up I still could not mount the fs (still in emergency shell).
>>> I rebooted and all came up, the array was there and the fs was mounted and so far
>>> I did not notice any issues with the fs.
>>>
>>> However, it is not perfect. I tried to copy some data from an external (USB) disk to the array
>>> and it went very slowly (as in 10KB/s, the USB could do 120MB/s). The copy (rsync) was running
>>> at 100% CPU which is unexpected. I then stopped it. As a test, I rsync'ed the USB disk to another
>>> SATA disk on the server and it went fast, so the USB disk is OK.
>>>
>>> I then noticed (in 'top') that there is a kworker running at 100% CPU:
>>>
>>>       PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>>>    944760 root      20   0       0      0      0 R 100.0   0.0 164:00.85 kworker/u16:3+flush-9:127
>>>
>>> It did it for many hours and I do not know what it is doing.
>>>
>>> Q2) what does this worker do?
>>>
>>> I also noticed that mdstat shows a high bitmap usage:
>>>
>>> Personalities : [raid6] [raid5] [raid4]
>>> md127 : active raid6 sde1[4] sdg1[6] sdf1[5] sdd1[7] sdb1[8] sdc1[9]
>>>         58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
>>>         bitmap: 87/88 pages [348KB], 65536KB chunk
>>>
>>> Q3) Is this OK? Should the usage go down? It does not change at all.
>>>
>>> While looking at everything, I started iostat on md127 and I see that there is a constant
>>> trickle of writes, about 5KB/s. There is no activity on this fs.
>>> Also, I see similar activity on all the members, at the same rate, so md127 does not show
>>> 6 times the members activity. I guess this is just how md works?
>>>
>>> Q4) What is this write activity? Is it related to the abovementioned 'requested-resync'?
>>>          If this is a background thing, how can I monitor it?
>>>
>>> Q5) Finally, will the array come up (degraded) if I reboot or will I need to coerse it to start?
>>>          What is the correct way to bring up a degraded array? What about the 'dirty' part?
>>> 'mdadm -D /dev/md127' mention'sync':
>>>       Number   Major   Minor   RaidDevice State
>>>          -       0        0        0      removed
>>>          8       8       17        1      active sync   /dev/sdb1
>>>          9       8       33        2      active sync   /dev/sdc1
>>>          7       8       49        3      active sync   /dev/sdd1
>>>          4       8       65        4      active sync   /dev/sde1
>>>          5       8       81        5      active sync   /dev/sdf1
>>>          6       8       97        6      active sync   /dev/sdg1
>>> Is this related?
>>>
>>> BTW I plan to run a 'check' at some point.
>>>
>>> TIA
>>>
>>> -- 
>>> Eyal at Home (eyal@eyal.emu.id.au)
> 

-- 
Eyal at Home (eyal@eyal.emu.id.au)

