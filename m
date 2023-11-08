Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5ACC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  8 Nov 2023 05:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbjKHFes (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Nov 2023 00:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjKHFeq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Nov 2023 00:34:46 -0500
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B28E10C9
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 21:34:44 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SQDL839xVz9QMk
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 16:34:40 +1100 (AEDT)
Received: from [IPV6:2405:6e00:4ed:cdf7:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:4ed:cdf7:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SQDJB73Zrz9PZ1
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 16:32:58 +1100 (AEDT)
Message-ID: <2d44a37a-ca08-4d74-ab7e-16f51a0004c4@eyal.emu.id.au>
Date:   Wed, 8 Nov 2023 16:32:45 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: extremely slow writes to degraded array
Content-Language: en-US
To:     list Linux RAID <linux-raid@vger.kernel.org>
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <25930.43201.247015.388374@petal.ty.sabi.co.uk>
 <3a6d41e6-7e49-4d6d-acb4-f10b05b02ee5@eyal.emu.id.au>
From:   eyal@eyal.emu.id.au
In-Reply-To: <3a6d41e6-7e49-4d6d-acb4-f10b05b02ee5@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 08/11/2023 12.37, eyal@eyal.emu.id.au wrote:
> On 08/11/2023 08.14, Peter Grandi wrote:
>>> 7 disks raid6 array(*1). boot, root and swap on a separate
>>> SSD. [...] One disk was removed recently and sent for
>>> replacement. The system felt OK but a few days later I noticed
>>> an issue... I started copying the full dataset (260GB 8,911k
>>> files). [...] 4GB (system limit) dirty blocks were created,
>>> which took 12h to clear.
>>
>> The MD RAID set is performing well as designed. The achievable
>> speed is very low except on special workloads, but that low
>> speed is still good performance for that design, which is close
>> to optimal for maximizing wait times on your workload.
>> Maximizing storage wait times is a common optimization in many
>> IT places.
>> https://www.sabi.co.uk/blog/17-one.html?170610#170610
>> https://www.sabi.co.uk/blog/15-one.html?150305#150305
>>
>>> [...] The copy completed fast but the kthread took about 1.5
>>> hours at 100%CPU to clear the dirty blocks.
>>> - When copying more files (3-5GB) the rsync was consuming
>>>    100%CPU and started pausing every few files (then killed). A
>>> - 'dd if=/dev/zero of=/data1/no-backup/old-backups/100GB'
>>>    completed quickly, no issues. [...]
>> [...]
>>> +  100.00%     1.60%  [kernel]  [k] ext4_mb_regular_allocator
>>> +   67.08%     5.93%  [kernel]  [k] ext4_mb_find_good_group_avg_frag_lists
>>> +   62.47%    42.34%  [kernel]  [k] ext4_mb_good_group
>>> +   22.51%    11.36%  [kernel]  [k] ext4_get_group_info
>>> +   19.70%    10.80%  [kernel]  [k] ext4_mb_scan_aligned
>>
>> My guess is that the filesystem residing on that RAID set is
>> nearly full, has lots of fragmentation, has lots of small files
>> and likely two out of three or even all three. Those are also
>> common optimizations used in many IT places to maximize storage
>> wait times.
> 
> Most of the files are not tiny as I archive and compress and significant collections.
> What I copied in the test IS a collection of very small files (see further down).
> 
>> https://www.techrepublic.com/forums/discussions/low-disk-performance-after-reching-75-of-disk-space/
>> https://www.spinics.net/lists/linux-ext4/msg26470.html
> 
> I plan to reboot at some point soon, in case a clean restart will fix the problem,
> but I first want to get what I can from the current situation.
> I also fear that the restart may not be straight forward. One hopes though.

Done. No problems in the restart. Now not degraded.

The same issue is still there. Short of a kernel bug, maybe some md settings are less than optimal.
I see some postings saying dirty limit should actually be lowered?

> While the fs is at about 83% full (10TB free out of 60TB) I had the array almost 100% full in the past
> (it was then a 20TB array) and did not notice such a drastic slowdown.
> 
> $ df -h /data1
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md127       55T   45T  9.8T  83% /data1
> 
> Now the recovery finished and it is not degraded, yet the problem remains. The bitmap is now clear.
> 
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid6 sdh1[10] sde1[4] sdc1[9] sdf1[5] sdb1[8] sdd1[7] sdg1[6]
>        58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/7] [UUUUUUU]
>        bitmap: 0/88 pages [0KB], 65536KB chunk
> 
> I copied (rsync) files to the array
>      Number of created files: 15,754 (reg: 13,056, dir: 2,435, link: 1, dev: 260, special: 2)
>      Total transferred file size: 242,397,771 bytes
> Which completed rapidly. It created a bunch of dirty blocks
>      2023-11-08 11:04:52 Dirty:    254328 kB  Buffers:   4190376 kB  MemFree:   1480148 kB
> which took 20m to drain:
>      2023-11-08 11:24:33 Dirty:     44624 kB  Buffers:   4565116 kB  MemFree:    888884 kB
>      2023-11-08 11:24:43 Dirty:     44548 kB  Buffers:   4565136 kB  MemFree:    894436 kB
>      2023-11-08 11:24:53 Dirty:        56 kB  Buffers:   4565192 kB  MemFree:    894052 kB
> 
> %util is not that bad, though the array is significantly higher than the members, and there is still much reading while writing.
> 
> 11:08:58 Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
> 11:08:58 md127            0.00      0.00     0.00   0.00    0.00     0.00    3.80     21.60     0.00   0.00 3669.63     5.68    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   13.94  12.37
> 11:08:58 sdb              0.40     16.40     3.70  90.24    0.25    41.00    1.60     19.00     3.70  69.81    2.19    11.88    0.00      0.00     0.00   0.00    0.00     0.00    1.20    2.42    0.01   0.30
> 11:08:58 sdc              0.40     16.40     3.70  90.24   11.50    41.00    2.00     24.20     4.60  69.70    6.75    12.10    0.00      0.00     0.00   0.00    0.00     0.00    1.20    7.00    0.03   1.01
> 11:08:58 sdd              0.00      0.00     0.00   0.00    0.00     0.00    1.60      7.80     0.90  36.00   18.94     4.88    0.00      0.00     0.00   0.00    0.00     0.00    1.20    3.00    0.03   2.87
> 11:08:58 sde              0.40     16.40     3.70  90.24    4.25    41.00    1.60     19.00     3.70  69.81   13.31    11.88    0.00      0.00     0.00   0.00    0.00     0.00    1.20    2.33    0.03   1.97
> 11:08:58 sdf              0.40      5.20     0.90  69.23    0.50    13.00    1.60      7.80     0.90  36.00   14.00     4.88    0.00      0.00     0.00   0.00    0.00     0.00    1.20    2.67    0.03   2.18
> 11:08:58 sdg              0.00      0.00     0.00   0.00    0.00     0.00    1.20      2.60     0.00   0.00   15.58     2.17    0.00      0.00     0.00   0.00    0.00     0.00    1.20    0.42    0.02   1.77
> 11:08:58 sdh              0.00      0.00     0.00   0.00    0.00     0.00    1.20      2.60     0.00   0.00    1.50     2.17    0.00      0.00     0.00   0.00    0.00     0.00    1.20    1.17    0.00   0.28
> 
> I also noticed that I have an old (since 2012) stanza in rc.local to set stripe_cache_size:
>      # cat /sys/block/md127/md/stripe_cache_size
>      16384
> Is it possibly unsuitable for this array?
> Any other setting I should investigate?
> 
> 
> Finally (important? I think it is OK), I see different UUIDs in different places:
> 
> /dev/disk/by-uuid
>          378e74a6-e379-4bd5-ade5-f3cd85952099 -> ../../md127
> 
> /etc/fstab
>          UUID=378e74a6-e379-4bd5-ade5-f3cd85952099 /data1 ext4   noatime 0 0
> 
> /dev/disk/by-id
>      md-uuid-15d250cf:fe43eafb:5779f3d8:7e79affc -> ../../md127
> 
> mdadm -D /dev/md127    # also in mdadm -E
>          UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
> 
> /etc/mdadm.conf
>          ARRAY /dev/md127 metadata=1.2 name=e4.eyal.emu.id.au:127 UUID=15d250cf:fe43eafb:5779f3d8:7e79affc
> 
> The first  (f3cd85952099) is the UUID of the ext4 fs,
> The second (:7e79affc) is what I see in my array logs since it was created 5 years ago.
> 
> TIA
> 

-- 
Eyal at Home (eyal@eyal.emu.id.au)

