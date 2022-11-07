Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FFDC4332F
	for <linux-raid@archiver.kernel.org>; Mon,  7 Nov 2022 09:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiKGJdF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiKGJdE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Nov 2022 04:33:04 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9EBE58
        for <linux-raid@vger.kernel.org>; Mon,  7 Nov 2022 01:33:01 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667813579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grRm51fJYQow8zvkKIcsTmPNXLCcX5WSgYbGqQK4PYI=;
        b=WqOTRwL2maGdfzAMNV68BgplA7bj8tGZia81++KyZ6kI/KuXMt3B2bdTAfEO5SLga6PU5W
        byhpIOINOSxMSzTD0BpX0QNVJJzePtSZbk3qK+/0K1EypW2ZUGkOLbWM4xeT/5/6YZBHLJ
        tOBdnV4wYCcbLG/KKf5qj5ltfEV5GzY=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Zdenek Kabelac <zkabelac@redhat.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <alpine.LRH.2.21.2211030851090.10884@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.21.2211031018030.18305@file01.intranet.prod.int.rdu2.redhat.com>
 <5dd07779-5c09-4c75-6e34-392e4c05c3c8@linux.dev>
 <alpine.LRH.2.21.2211040909470.19553@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <beba4872-9cee-03e7-f147-1a7c6e84e9a4@linux.dev>
Date:   Mon, 7 Nov 2022 17:32:55 +0800
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2211040909470.19553@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/4/22 9:40 PM, Mikulas Patocka wrote:
> On Fri, 4 Nov 2022, Guoqing Jiang wrote:
>
>> On 11/3/22 11:20 PM, Mikulas Patocka wrote:
>>> On Thu, 3 Nov 2022, Mikulas Patocka wrote:
>>>
>>>>> BTW, is the mempool_free from endio -> dec_count -> complete_io?
>>>>> And io which caused the crash is from dm_io -> async_io / sync_io
>>>>>    -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
>>>>> suppose the io is for mirror image.
>>>>>
>>>>> Thanks,
>>>>> Guoqing
>>>> I presume that the bug is caused by destruction of a bio set while bio
>>>> from that set was in progress. When the bio finishes and an attempt is
>>>> made to free the bio, a crash happens when the code tries to free the bio
>>>> into a destroyed mempool.
>>>>
>>>> I can do more testing to validate this theory.
>>>>
>>>> Mikulas
>>> When I disable tail-call optimizations with "-fno-optimize-sibling-calls",
>>> I get this stacktrace:
>> Just curious, is the option used for compile kernel or lvm?
> I used it to compile the kernel. I set
> export KCFLAGS="-march=barcelona -fno-optimize-sibling-calls"
> and recompiled the kernel.

Thanks for the sharing!

>> BTW, this trace is different from previous one, and it is more
>> understandable to me, thanks.
>>
>>> [  200.105367] Call Trace:
>>> [  200.105611]  <TASK>
>>> [  200.105825]  dump_stack_lvl+0x33/0x42
>>> [  200.106196]  dump_stack+0xc/0xd
>>> [  200.106516]  mempool_free.cold+0x22/0x32
>>> [  200.106921]  bio_free+0x49/0x60
>>> [  200.107239]  bio_put+0x95/0x100
>>> [  200.107567]  super_written+0x4f/0x120 [md_mod]
>>> [  200.108020]  bio_endio+0xe8/0x100
>>> [  200.108359]  __dm_io_complete+0x1e9/0x300 [dm_mod]
>>> [  200.108847]  clone_endio+0xf4/0x1c0 [dm_mod]
>>> [  200.109288]  bio_endio+0xe8/0x100
>>> [  200.109621]  __dm_io_complete+0x1e9/0x300 [dm_mod]
>>> [  200.110102]  clone_endio+0xf4/0x1c0 [dm_mod]
>> Assume the above from this chain.
>>
>> clone_endio -> dm_io_dec_pending -> __dm_io_dec_pending -> dm_io_complete
>> -> __dm_io_complete -> bio_endio
>>
>>> [  200.110543]  bio_endio+0xe8/0x100
>>> [  200.110877]  brd_submit_bio+0xf8/0x123 [brd]
>>> [  200.111310]  __submit_bio+0x7a/0x120
>>> [  200.111670]  submit_bio_noacct_nocheck+0xb6/0x2a0
>>> [  200.112138]  submit_bio_noacct+0x12e/0x3e0
>>> [  200.112551]  dm_submit_bio_remap+0x46/0xa0 [dm_mod]
>>> [  200.113036]  flush_expired_bios+0x28/0x2f [dm_delay]
>> Was flush_expired_bios triggered by the path?
>>
>> __dm_destroy or __dm_suspend -> suspend_targets -> delay_presuspend
>> -> del_timer_sync(&dc->delay_timer) -> handle_delayed_timer
> No - del_timer_sync doesn't call handle_delayed_timer.
>
> The timer was set by "mod_timer(&dc->delay_timer, expires);". When the
> time expires, it calls handle_delayed_timer. handle_delayed_timer calls
> "queue_work(dc->kdelayd_wq, &dc->flush_expired_bios);" - this submits a
> work item that calls "flush_expired_bios" and triggers this stacktrace.

Ok, so the queue_timeout which sets expire timer is called by delay_map
-> delay_bio or flush_delayed_bios, and in either way the bio is originated
from delayed_bios list.

>>> [  200.113536]  process_one_work+0x1b4/0x320
>>> [  200.113943]  worker_thread+0x45/0x3e0
>>> [  200.114319]  ? rescuer_thread+0x380/0x380
>>> [  200.114714]  kthread+0xc2/0x100
>>> [  200.115035]  ? kthread_complete_and_exit+0x20/0x20
>>> [  200.115517]  ret_from_fork+0x1f/0x30
>>> [  200.115874]  </TASK>
>>>
>>> The function super_written is obviously buggy, because it first wakes up a
>>> process and then calls bio_put(bio) - so the woken-up process is racing
>>> with bio_put(bio) and the result is that we attempt to free a bio into a
>>> destroyed bio set.
>> Does it mean the woken-up process destroyed the bio set?
> Yes.
>
>> The io for super write is allocated from sync_set, and the bio set is
>> mostly destroyed in md_free_disk or md_stop, I assume md_stop is more
>> relevant here as it is called by dm-raid.
> Yes.
>
>> So I guess the problem is, raid_dtr is called while in flight (or
>> expired) bio still not completed,
> When device mapper calls raid_dtr, there are no external bios in progress
> (this is guaranteed by dm design). However, the bio that writes the
> superblock is still in progress and it races with the md_stop. I am not an
> expert in md, so I don't know if this is OK or not.

For md raid, I think the same situation can't happen given the bioset 
can only
be destroyed from disk_release, and block layer guarantees all bios 
happen to
array should be finished before release disk.

Also I believe dm can guarantee all bio happened to dm should be 
finished before
dtr, but the bio in the call trace was issued to md layer instead of 
inside dm, not
sure how dm handle this case correctly.

And super write bio is kind of special, it happens mostly when the 
configuration
of array is changed, e.g. size,  disk member, but seems mddev_detach is not
capable to guarantee the completion of super write bio, which means when the
path (md_stop -> __md_stop) destroys bioset, the super write bio could 
still exist.
Maybe it is necessary to check pending_writes for super write io in md_stop
before bioset_exit.

> maybe lvm issues cmd to call dm_table_destroy and dm was in the progress
> of suspend or destroy. Just my $0.02.
>
>>> When I fix super_written, there are no longer any crashes. I'm posting a
>>> patch in the next email.
>> IIRC, the code existed for a long time, I'd suggest try with mdadm test
>> suite first with the change. Cc Neil too.
> I get an error when attempting to run the testsuite:
> [debian:/usr/src/git/mdadm]# ./test
> Testing on linux-6.1.0-rc3 kernel
> /usr/src/git/mdadm/tests/00createnames... FAILED - see
> /var/tmp/00createnames.log and /var/tmp/fail00createnames.log for details
>
> [debian:/usr/src/git/mdadm]# cat /var/tmp/00createnames.log
> + . /usr/src/git/mdadm/tests/00createnames
> ++ set -x -e
> ++ _create /dev/md/name
> ++ local DEVNAME=/dev/md/name
> ++ local NAME=
> ++ [[ -z '' ]]
> ++ mdadm -CR /dev/md/name -l0 -n 1 /dev/loop0 --force
> ++ rm -f /var/tmp/stderr
> ++ case $* in
> ++ case $* in
> ++ for args in $*
> ++ [[ -CR =~ /dev/ ]]
> ++ for args in $*
> ++ [[ /dev/md/name =~ /dev/ ]]
> ++ [[ /dev/md/name =~ md ]]
> ++ for args in $*
> ++ [[ -l0 =~ /dev/ ]]
> ++ for args in $*
> ++ [[ -n =~ /dev/ ]]
> ++ for args in $*
> ++ [[ 1 =~ /dev/ ]]
> ++ for args in $*
> ++ [[ /dev/loop0 =~ /dev/ ]]
> ++ [[ /dev/loop0 =~ md ]]
> ++ /usr/src/git/mdadm/mdadm --zero /dev/loop0
> mdadm: Unrecognised md component device - /dev/loop0
> ++ for args in $*
> ++ [[ --force =~ /dev/ ]]
> ++ /usr/src/git/mdadm/mdadm --quiet -CR /dev/md/name -l0 -n 1 /dev/loop0
> --force --auto=yes
> ++ rv=1
> ++ case $* in
> ++ cat /var/tmp/stderr
> mdadm: unexpected failure opening /dev/md127
> ++ return 1
> ++ [[ 1 != \0 ]]
> ++ echo 'Cannot create device.'
> Cannot create device.
> ++ exit 1
> mdadm: unexpected failure opening /dev/md127
>
> [debian:/usr/src/git/mdadm]# cat /var/tmp/fail00createnames.log
> ## debian.vm: saving dmesg.
> ## debian.vm: saving proc mdstat.
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>
> ## debian.vm: no array assembled!
> ## debian.vm: saving dmesg.
> ## debian.vm: saving proc mdstat.
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>
> ## debian.vm: no array assembled!
> ## debian.vm: saving dmesg.
> ## debian.vm: saving proc mdstat.
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>
> ## debian.vm: no array assembled!
> ## debian.vm: saving dmesg.
> ## debian.vm: saving proc mdstat.
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>
> ## debian.vm: no array assembled!

I guess the problem is that loop module was not loaded, but I didn't
have experience with debian.

Thanks,
Guoqing
