Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F98BC433B4
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 13:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDF461353
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 13:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245456AbhDGNrK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Apr 2021 09:47:10 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34713 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242048AbhDGNrG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 7 Apr 2021 09:47:06 -0400
Received: from [192.168.0.2] (ip5f5ae880.dynamic.kabel-deutschland.de [95.90.232.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2C862206473D6;
        Wed,  7 Apr 2021 15:46:55 +0200 (CEST)
Subject: Re: OT: Processor recommendation for RAID6
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        it+linux-raid@molgen.mpg.de
References: <16ceff73-1257-fc3d-aade-43656c7216e7@molgen.mpg.de>
 <12e8f7f1-6655-9f0b-72b1-0908f229dcac@molgen.mpg.de>
 <b5eb567d-9866-8f0f-ea61-83ae97d4d21f@molgen.mpg.de>
 <CAAMCDedmGUcWY=9Nb36gXoo0+F82rhq=-6yKZ1xPf74Gj0mq7Q@mail.gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <e5d4dd39-7d75-77c6-abc8-8c701b9066fd@molgen.mpg.de>
Date:   Wed, 7 Apr 2021 15:46:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDedmGUcWY=9Nb36gXoo0+F82rhq=-6yKZ1xPf74Gj0mq7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Roger,


Thank you for your response.


Am 02.04.21 um 16:45 schrieb Roger Heflin:
> On Fri, Apr 2, 2021 at 4:13 AM Paul Menzel wrote:

>>> Are these values a good benchmark for comparing processors?
>>
>> After two years, yes they are. I created 16 10 GB files in `/dev/shm`,
>> set them up as loop devices, and created a RAID6. For resync speed it
>> makes difference.
>>
>> 2 x AMD EPYC 7601 32-Core Processor:    34671K/sec
>> 2 x Intel Xeon Gold 6248 CPU @ 2.50GHz: 87533K/sec
>>
>> So, the current state of affairs seems to be, that AVX512 instructions
>> do help for software RAIDs, if you want fast rebuild/resync times.
>> Getting, for example, a four core/eight thread Intel Xeon Gold 5222
>> might be useful.
>>
>> Now, the question remains, if AMD processors could make it up with
>> higher performance, or better optimized code, or if AVX512 instructions
>> are a must,
>>
>> […]

>> PS: Here are the commands on the AMD EPYC system:
>>
>> ```
>> $ for i in $(seq 1 16); do truncate -s 10G /dev/shm/vdisk$i.img; done
>> $ for i in /dev/shm/v*.img; do sudo losetup --find --show $i; done
>> […]
>> $ sudo mdadm --create /dev/md1 --level=6 --raid-devices=16 /dev/loop{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md1 started.
>> $ more /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]
>> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12] loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>>         146671616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]
>>         [>....................]  resync =  3.9% (416880/10476544) finish=5.6min speed=29777K/sec
>>
>> unused devices: <none>
>> $ more /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]
>> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12] loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>>         146671616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]
>>         [>....................]  resync =  4.1% (439872/10476544) finish=5.3min speed=31419K/sec
>> $ sudo mdadm -S /dev/md1
>> mdadm: stopped /dev/md1
>> $ sudo losetup -D
>> $ sudo rm /dev/shm/vdisk*.img
> 
> I think you are testing something else.  Your speeds are way below
> what the raw processor can do. You are probably testing memory
> speed/numa arch differences between the 2.
> 
> On the intel arch there are 2 numa nodes total with 4 channels, so the
> system  has 8 usable channels of bandwidth, but a allocation on a
> single numa node will only have 4 channels usable (ddr4-2933)
> 
> On the epyc there are 8 numa nodes with 2 channels each (ddr4-2666),
> so any single memory allocation will have only 2 channels available
> and if the accesses are across the numa bus will be slower.
> 
> So 4*2933/2*2666 = 2.20 * 34671 = 76286 (fairly close to your results).
> 
> How the allocation for memory works depends a lot on how much ram you
> actually have per numa node and how much for the whole machine.  But
> any single block for any single device should be on a single numa node
> almost all of the time.
> 
> You might want to drop the cache before the test, run numactl
> --hardware to see how much memory is free per numa node, then rerun
> the test and at the of the test before the stop run numactl --hardware
> again to see how it was spread across numa nodes.  Even if it spreads
> it across multiple numa nodes that may well mean that on the epyc case
> you are running with several numa nodes were the main raid processes
> are running against remote numa nodes, and because intel only has 2
> then there is a decent chance that it is only running on 1 most of the
> time (so no remote memory).  I have also seen in benchmarks I have run
> on 2P and 4P intel machines that interleaved on a 2P single thread job
> is faster than running on a single numa nodes memory (with the process
> pinned to a single cpu on one of the numa nodes, memory interleaved
> over both), but on a 4P/4numa node machine interleaving slows it down
> significantly.  And in the default case any single write/read of a
> block is likely only on a single numa node so that specific read/write
> is constrained by a single numa node bandwidth giving an advantage to
> fewer faster/bigger numa nodes and less remote memory.
> 
> Outside of rebooting and forcing the entire machine to interleave I am
> not sure how to get shm to interleave.   It might be a good enough
> test to just force the epyc to interleave and see if the benchmark
> result changes in any way.  If the result does change repeat on the
> intel.  Overall for the most part the raid would not be able to use
> very many cpu anyway, so a bigger machine with more numa nodes may
> slow down the overall rate.

Thank you for the analysis. If I am going to have time, I am going to 
try your suggestions. In the meantime I won’t test in `/dev/shm`. Our 
servers with 256+ GB RAM are only two socket systems with a lot of 
cores/threads, but I didn’t have controllers and disks for testing handy.

Quickly testing this on two desktop machine.

Dell OptiPlex 5055 with AMD Ryzen 5 PRO 1500 (max 3.5 GHz), 16 GB 
memory, and 16 loop mounted 512 MB files in `/dev/shm` Linux 5.12.0-rc6 
reports 60000K/sec.

```
$ more /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]
md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12] 
loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5] 
loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
       7311360 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] 
[UUUUUUUUUUUUUUUU]
       [===================>.]  resync = 95.6% (500704/522240) 
finish=0.0min speed=62588K/sec

unused devices: <none>
```

Dell Precision 3620 with Intel i7-7700 @ 3.6 GHz, 32 GB memory Linux 
5.12.0-rc3 reports 110279K/sec.

```
$ more /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
[multipath]
md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12] 
loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5] 
loop4[4] loop3[3] lo
op2[2] loop1[1] loop0[0]
       7311360 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] 
[UUUUUUUUUUUUUUUU]
       [================>....]  resync = 84.3% (441116/522240) 
finish=0.0min speed=110279K/sec

unused devices: <none>
```

I have no idea, if it’s related to the smaller files or the 
processor/system (single thread performance?).

On a Dell T440/021KCD (firmware 2.9.3) with two Intel Xeon Gold 5222 CPU 
@ 3.80GHz (AVX512), 128 GB memory, Adaptec Smart Storage PQI 12G 
SAS/PCIe 3 (HBA1100) and 16 8 TB Seagate ST8000NM001A, Linux 5.4.97 
reports over 130000K/sec.

```
$ more /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
[multipath]
md0 : active raid6 sdr[15] sdq[14] sdp[13] sdo[12] sdn[11] sdm[10] 
sdl[9] sdk[8] sdj[7] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] sdd[1] sdc[0]
       109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[16/16] [UUUUUUUUUUUUUUUU]
       [=>...................]  resync =  5.7% (452697636/7813894144) 
finish=938.1min speed=130767K/sec
       bitmap: 56/59 pages [224KB], 65536KB chunk

unused devices: <none>
$ sudo perf top
[…]
   15.97%  [kernel]            [k] xor_avx_5
   12.78%  [kernel]            [k] analyse_stripe
   11.90%  [kernel]            [k] memcmp
    7.71%  [kernel]            [k] ops_run_io
    4.75%  [kernel]            [k] blk_rq_map_sg
    4.41%  [kernel]            [k] raid6_avx5124_gen_syndrome
    3.36%  [kernel]            [k] bio_advance
    3.03%  [kernel]            [k] raid5_get_active_stripe
    3.00%  [kernel]            [k] raid5_end_read_request
    2.85%  [kernel]            [k] xor_avx_3
    1.72%  [kernel]            [k] blk_update_request
[…]
```

This is also much faster compared to the Dell PowerEdge T640 with two 
Intel Xeon Gold 6248 @ 2,50 GHz results in `/dev/shm`.

So, for the thread purpose, tests need to be done on real disks and not 
loop mounted files in memory.


Kind regards,

Paul
