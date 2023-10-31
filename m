Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6922EC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 06:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbjJaGZa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 02:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbjJaGZ3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 02:25:29 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCE310A
        for <linux-raid@vger.kernel.org>; Mon, 30 Oct 2023 23:25:23 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKKrK6fp5z9RLx
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 17:25:21 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKKrK3yJLz9R9f
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 17:25:21 +1100 (AEDT)
Message-ID: <d5596ad4-aa91-449e-9b67-8762e9142230@eyal.emu.id.au>
Date:   Tue, 31 Oct 2023 17:25:07 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: problem with recovered array
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
Content-Language: en-US
From:   eyal@eyal.emu.id.au
In-Reply-To: <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 31/10/2023 14.21, Carlos Carvalho wrote:
> Roger Heflin (rogerheflin@gmail.com) wrote on Mon, Oct 30, 2023 at 01:14:49PM -03:
>> look at  SAR -d output for all the disks in the raid6.   It may be a
>> disk issue (though I suspect not given the 100% cpu show in raid).
>>
>> Clearly something very expensive/deadlockish is happening because of
>> the raid having to rebuild the data from the missing disk, not sure
>> what could be wrong with it.
> 
> This is very similar to what I complained some 3 months ago. For me it happens
> with an array in normal state. sar shows no disk activity yet there are no
> writes to the array (reads happen normally) and the flushd thread uses 100%
> cpu.
> 
> For the latest 6.5.* I can reliably reproduce it with
> % xzcat linux-6.5.tar.xz | tar x -f -
> 
> This leaves the machine with ~1.5GB of dirty pages (as reported by
> /proc/meminfo) that it never manages to write to the array. I've waited for
> several hours to no avail. After a reboot the kernel tree had only about 220MB
> instead of ~1.5GB...

I rebooted the machine, so all is pristine.
This is F38, kernel 6.5.8-200.fc38.x86_64, with 32GB RAM.

I started a copy (SATA->rsync) into the array. Within seconds the kworked started running with 100%CPU.
In less that 1 minute is almost stopped(*1), after transferring about 5GB.
Below(*2) is the meminfo at that time.

10 minutes later it is till copying the same (32KB!) file.
20m later I stopped the copy bnut the kworker remained.
10m later I removed the target directory and the kworker was immediately gone.

I still suspect that after the array was 'all spares' and I re-assembled it, after when it looked good,
something is not completely right.

What other information should I provide to help resolve this issue?

TIA

(*1) the read side had zero activity and the write (the array) had a trikkle of about 50KB/s.

(*2) $ cat /proc/meminfo
MemTotal:       32704880 kB
MemFree:          654660 kB
MemAvailable:   29397832 kB
Buffers:          951396 kB
Cached:         26962316 kB
SwapCached:           32 kB
Active:          2698164 kB
Inactive:       26738212 kB
Active(anon):    1755572 kB
Inactive(anon):    51596 kB
Active(file):     942592 kB
Inactive(file): 26686616 kB
Unevictable:      177112 kB
Mlocked:               0 kB
SwapTotal:      16777212 kB
SwapFree:       16776444 kB
Zswap:                 0 kB
Zswapped:              0 kB
Dirty:           5069080 kB
Writeback:            28 kB
AnonPages:       1699812 kB
Mapped:           669464 kB
Shmem:            284500 kB
KReclaimable:    1452908 kB
Slab:            1731432 kB
SReclaimable:    1452908 kB
SUnreclaim:       278524 kB
KernelStack:       16160 kB
PageTables:        29476 kB
SecPageTables:         0 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    33129652 kB
Committed_AS:    8020984 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       58744 kB
VmallocChunk:          0 kB
Percpu:             5792 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
Unaccepted:            0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:      338060 kB
DirectMap2M:     4757504 kB
DirectMap1G:    28311552 kB

-- 
Eyal at Home (eyal@eyal.emu.id.au)

