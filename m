Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F139C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  1 Nov 2023 13:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbjKANIP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Nov 2023 09:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjKANIO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Nov 2023 09:08:14 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6562EA6
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 06:08:11 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SL6kc45bSz9R8M
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 00:08:08 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SL6kc1P1lz9R8C
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 00:08:08 +1100 (AEDT)
Message-ID: <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
Date:   Thu, 2 Nov 2023 00:08:02 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: problem with recovered array
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
 <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
From:   eyal@eyal.emu.id.au
In-Reply-To: <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01/11/2023 21.30, Roger Heflin wrote:
> Did you check with iostat/sar?    (iostat -x 2 5).  The md
> housekeeping/background stuff does not show on the md device itself,
> but it shows on the underlying disks.

Yes, I have iostat on both the md device and the components and I see sparse activity on both.

> It might also be related the the bitmap keeping track of how far the
> missing disk is behind.

This may be the case. In case the disk is re-added it may help to know this,
but if a new disk is added then the full disk will be recreated anyway.

> Small files are troublesome.    A tiny file takes several reads and writes.

Yes, but the array is so fast that this should not be a problem.
The rsync source is 175MB/s and the target array is 800MB/s so I do not
see how the writing can slow the copy.

In one case I (virsh) saved a VM, which created one 8GB file, which took
many hours to be written.

> I think the bitmap is tracking how many writes need to be done on the
> missing disk, and if so then until the new disk gets put back will not
> start cleaning up.
> 
> 
> On Tue, Oct 31, 2023 at 4:40 PM <eyal@eyal.emu.id.au> wrote:
>>
>> On 31/10/2023 21.24, Roger Heflin wrote:
>>> If you directory entries are large (lots of small files in a
>>> directory) then the recovery of the missing data could be just enough
>>> to push your array too hard.
>>
>> Nah, the directory I am copying has nothing really large, and the target directory is created new.
>>
>>> find /<mount> -type d -size +1M -ls     will find large directories.
>>>
>>> do a ls -l <largedirname> | wc -l and see how many files are in there.
>>>
>>> ext3/4 has issues with really big directories.
>>>
>>> The perf top showed just about all of the time was being spend in
>>> ext3/4 threads allocating new blocks/directory entries and such.
>>
>> Just in case there is an issue, I will copy another directory as a test.
>> [later] Same issue. This time the files were Pictures, 1-3MB each, so it went faster (but not as fast as the array can sustain).
>> After a few minutes (9GB copied) it took a long pause and a second kworker started. This one gone after I killed the copy.
>>
>> However, this same content was copied from an external USB disk (NOT to the array) without a problem.
>>
>>> How much free space does the disk show in df?
>>
>> Enough  room:
>>          /dev/md127       55T   45T  9.8T  83% /data1
>>
>> I still suspect an issue with the array after it was recovered.
>>
>> A replated issue is that there is a constant rate of writes to the array (iostat says) at about 5KB/s
>> when there is no activity on this fs. In the past I saw zero read/write in iostat in this situation.
>>
>> Is there some background md process? Can it be hurried to completion?
>>
>>> On Tue, Oct 31, 2023 at 4:29 AM <eyal@eyal.emu.id.au> wrote:
>>>>
>>>> On 31/10/2023 14.21, Carlos Carvalho wrote:
>>>>> Roger Heflin (rogerheflin@gmail.com) wrote on Mon, Oct 30, 2023 at 01:14:49PM -03:
>>>>>> look at  SAR -d output for all the disks in the raid6.   It may be a
>>>>>> disk issue (though I suspect not given the 100% cpu show in raid).
>>>>>>
>>>>>> Clearly something very expensive/deadlockish is happening because of
>>>>>> the raid having to rebuild the data from the missing disk, not sure
>>>>>> what could be wrong with it.
>>>>>
>>>>> This is very similar to what I complained some 3 months ago. For me it happens
>>>>> with an array in normal state. sar shows no disk activity yet there are no
>>>>> writes to the array (reads happen normally) and the flushd thread uses 100%
>>>>> cpu.
>>>>>
>>>>> For the latest 6.5.* I can reliably reproduce it with
>>>>> % xzcat linux-6.5.tar.xz | tar x -f -
>>>>>
>>>>> This leaves the machine with ~1.5GB of dirty pages (as reported by
>>>>> /proc/meminfo) that it never manages to write to the array. I've waited for
>>>>> several hours to no avail. After a reboot the kernel tree had only about 220MB
>>>>> instead of ~1.5GB...
>>>>
>>>> More evidence that the problem relates to the cache not flushed to disk.
>>>>
>>>> If I run 'rsync --fsync ...' it slows it down as the writing is flushed to disk for each file.
>>>> But it also evicts it from the cache, so nothing accumulates.
>>>> The result is a slower than otherwise copying but it streams with no pauses.
>>>>
>>>> It seems that the array is slow to sync files somehow. Mythtv has no problems because it write
>>>> only a few large files. rsync copies a very large number of small files which somehow triggers
>>>> the problem.
>>>>
>>>> This is why my 'dd if=/dev/zero of=file-on-array' goes fast without problems.
>>>>
>>>> Just my guess.
>>>>
>>>> BTW I ran fsck on the fs (on the array) and it found no fault.
>>>>
>>>> --
>>>> Eyal at Home (eyal@eyal.emu.id.au)
>>>>
>>
>> --
>> Eyal at Home (eyal@eyal.emu.id.au)
>>

-- 
Eyal at Home (eyal@eyal.emu.id.au)

