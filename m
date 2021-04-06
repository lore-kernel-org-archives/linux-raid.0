Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2458CC433B4
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 21:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF5DC61284
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 21:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbhDFVMk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Apr 2021 17:12:40 -0400
Received: from mx2.nbi.dk ([130.225.213.194]:60280 "EHLO smtp.nbi.ku.dk"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232861AbhDFVMj (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 6 Apr 2021 17:12:39 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 17:12:39 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by smtp.nbi.ku.dk (Postfix) with ESMTPSA id D648589F2D7
        for <linux-raid@vger.kernel.org>; Tue,  6 Apr 2021 23:05:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nbi.dk;
        s=mx2-20200103; t=1617743146;
        bh=Dy+8iSO52ek8ME8pMTs5y0PePZvcK+CMgQOK8Gj5EPM=;
        h=To:References:From:Subject:Date:In-Reply-To:From;
        b=pNJtzYpEh7emQrxuRHtqgybXvtlvaOxW5IxtDWnOabN+J38eomiubd0NstIsWelQ/
         GcfLkIqpsyK+uc1A3OfjS/Mq6Z2K/0cDrWZ34m00JEoDbtq11Pn/5l/vk530ggVFKL
         6MVGcvC+ETcGpPYTAeVS8cNad7jyg73e+DAh7nk+hB5Qpx12vRejINDtrH6n8BeEwY
         ZWWgEX3sfllxXGhGhHRwvpEXY5CVbVvXPR2dP5zHlSgskoxYPs9vKNeciT7HiobWr7
         Nf1jbMjA8tTpAG+HOiMiVfBtcf722b6BogMdKRTA6l/eS6yFkrkNQtMaq2+71Rxuti
         zXSWKSIwavTWw==
To:     linux-raid@vger.kernel.org
References: <CAAMCDedmGUcWY=9Nb36gXoo0+F82rhq=-6yKZ1xPf74Gj0mq7Q () mail !
 gmail ! com>
From:   Hans Henrik Happe <happe@nbi.dk>
Subject: Re: OT: Processor recommendation for RAID6
Message-ID: <0950b0da-e2d4-d530-50cf-5c322a303fdd@nbi.dk>
Date:   Tue, 6 Apr 2021 23:05:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAAMCDedmGUcWY=9Nb36gXoo0+F82rhq=-6yKZ1xPf74Gj0mq7Q () mail !
 gmail ! com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.1 at mx2.nbi.dk
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02.04.2021 16.45, Roger Heflin wrote:
> On Fri, Apr 2, 2021 at 4:13 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>> Dear Linux folks,
>>
>>
> 
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
>> [=E2=80=A6]
>>
>>
>> Kind regards,
>>
>> Paul
>>
>>
>> PS: Here are the commands on the AMD EPYC system:
>>
>> ```
>> $ for i in $(seq 1 16); do truncate -s 10G /dev/shm/vdisk$i.img; done
>> $ for i in /dev/shm/v*.img; do sudo losetup --find --show $i; done
>> /dev/loop0
>> /dev/loop1
>> /dev/loop2
>> /dev/loop3
>> /dev/loop4
>> /dev/loop5
>> /dev/loop6
>> /dev/loop7
>> /dev/loop8
>> /dev/loop9
>> /dev/loop10
>> /dev/loop11
>> /dev/loop12
>> /dev/loop13
>> /dev/loop14
>> /dev/loop15
>> $ sudo mdadm --create /dev/md1 --level=3D6 --raid-devices=3D16
>> /dev/loop{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md1 started.
>> $ more /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
>> [multipath]
>> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12]
>> loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5]266
>> loop4[4] loop3[3] lo
>> op2[2] loop1[1] loop0[0]
>>        146671616 blocks super 1.2 level 6, 512k chunk, algorithm 276
>> [16/16] [UUUUUUUUUUUUUUUU]
>>        [>....................]  resync =3D  3.9% (416880/10476544)
>> finish=3D5.6min speed=3D29777K/sec
>>
>> unused devices: <none>
>> $ more /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
>> [multipath]
>> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12]
>> loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5]
>> loop4[4] loop3[3] lo
>> op2[2] loop1[1] loop0[0]
>>        146671616 blocks super 1.2 level 6, 512k chunk, algorithm 2
>> [16/16] [UUUUUUUUUUUUUUUU]
>>        [>....................]  resync =3D  4.1% (439872/10476544)
>> finish=3D5.3min speed=3D31419K/sec
>> $ sudo mdadm -S /dev/md1
>> mdadm: stopped /dev/md1
>> $ sudo losetup -D
>> $ sudo rm /dev/shm/vdisk*.img
> 
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
> So 4*2933/2*2666 =3D 2.20 * 34671 =3D 76286 (fairly close to your results).
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


I don't think it's a memory issue. I can read from similar /dev/shm
setup at ~20GB/s on single EPYC Rome.

I've also experienced slow sync behavior on otherwise idle CentOS7/8
systems. Even tried kernel-lt.x86_64 5.4.95-1.el8.elrepo. Setting
speed_limit_min helps, but that should not be needed when the system is
not doing other I/O or compute.

This I first noticed with a RAID6 of SAS3 HDDs being far from fast
enough for sync. Also writes vere very bad, with less than 1GB/s for
10-18 disk sets, no matter how many writers.

With 16 writers on the described loop setup I get this 'perf top' output
(similar on HDDs):

  33.92%  [kernel]                  [k] native_queued_spin_lock_slowpath



   7.05%  [kernel]                  [k] async_copy_data.isra.61



   5.81%  [kernel]                  [k] memcpy



   2.44%  [kernel]                  [k] read_tsc



   1.65%  [kernel]                  [k] analyse_stripe



   1.64%  [kernel]                  [k] native_sched_clock



   1.32%  [kernel]                  [k] raid6_avx22_gen_syndrome



   1.14%  [kernel]                  [k] generic_make_request_checks



   1.11%  [kernel]                  [k] _raw_spin_unlock_irqrestore



   1.07%  [kernel]                  [k] native_irq_return_iret



   1.06%  [kernel]                  [k] add_stripe_bio



   1.03%  [kernel]                  [k] raid5_compute_blocknr



   0.99%  [kernel]                  [k] _raw_spin_lock_irq



   0.88%  [kernel]                  [k] raid5_compute_sector



   0.82%  [kernel]                  [k] select_task_rq_fair



   0.81%  [kernel]                  [k] _raw_spin_lock_irqsave



   0.71%  [kernel]                  [k] blk_mq_make_request



   0.70%  [kernel]                  [k] raid5_get_active_stripe



   0.68%  [kernel]                  [k] bio_reset



   0.67%  [kernel]                  [k] percpu_counter_add_batch



   0.63%  [kernel]                  [k] ktime_get



   0.61%  [kernel]                  [k] llist_reverse_order



   0.59%  [kernel]                  [k] ops_run_io



   0.59%  [kernel]                  [k] release_stripe_plug



   0.50%  [kernel]                  [k] raid5_make_request



   0.48%  [kernel]                  [k] raid5_release_stripe



   0.45%  [kernel]                  [k] loop_queue_work



   0.44%  [kernel]                  [k] llist_add_batch



   0.42%  [kernel]                  [k] sched_clock_cpu



   0.41%  [kernel]                  [k] blk_mq_dispatch_rq_list



   0.39%  [kernel]                  [k] default_send_IPI_single_phys



   0.38%  [kernel]                  [k] do_iter_readv_writev



   0.38%  [kernel]                  [k] bio_endio



   0.37%  [kernel]                  [k] md_write_inc




I'm not sure if it is expected that 'native_queued_spin_lock_slowpath'
is so dominant. Seems to increase when adding more and more writers.

BTW RAID0 does not have this issue.

Cheers,
Hans Henrik
