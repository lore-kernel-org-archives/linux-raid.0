Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE9AC71156
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13964221EB
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390913AbgLAJaH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:30:07 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:59935 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388019AbgLAJaB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 1 Dec 2020 04:30:01 -0500
Received: from [141.14.16.43] (donald-xps13.molgen.mpg.de [141.14.16.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 81C522064786D;
        Tue,  1 Dec 2020 10:29:18 +0100 (CET)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <77244d60-1c2d-330e-71e6-4907d4dd65fc@molgen.mpg.de>
Date:   Tue, 1 Dec 2020 10:29:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am 30.11.20 um 03:06 schrieb Guoqing Jiang:
> 
> 
> On 11/28/20 13:25, Donald Buczek wrote:
>> Dear Linux mdraid people,
>>
>> we are using raid6 on several servers. Occasionally we had failures, where a mdX_raid6 process seems to go into a busy loop and all I/O to the md device blocks. We've seen this on various kernel versions.
>>
>> The last time this happened (in this case with Linux 5.10.0-rc4), I took some data.
>>
>> The triggering event seems to be the md_check cron job trying to pause the ongoing check operation in the morning with
>>
>>      echo idle > /sys/devices/virtual/block/md1/md/sync_action
>>
>> This doesn't complete. Here's /proc/stack of this process:
>>
>>      root@done:~/linux_problems/mdX_raid6_looping/2020-11-27# ps -fp 23333
>>      UID        PID  PPID  C STIME TTY          TIME CMD
>>      root     23333 23331  0 02:00 ?        00:00:00 /bin/bash /usr/bin/mdcheck --continue --duration 06:00
>>      root@done:~/linux_problems/mdX_raid6_looping/2020-11-27# cat /proc/23333/stack
>>      [<0>] kthread_stop+0x6e/0x150
>>      [<0>] md_unregister_thread+0x3e/0x70
>>      [<0>] md_reap_sync_thread+0x1f/0x1e0
>>      [<0>] action_store+0x141/0x2b0
>>      [<0>] md_attr_store+0x71/0xb0
>>      [<0>] kernfs_fop_write+0x113/0x1a0
>>      [<0>] vfs_write+0xbc/0x250
>>      [<0>] ksys_write+0xa1/0xe0
>>      [<0>] do_syscall_64+0x33/0x40
>>      [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Note, that md0 has been paused successfully just before.
> 
> What is the personality of md0? Is it also raid6?

Yes.

> 
>>
>>      2020-11-27T02:00:01+01:00 done CROND[23333]: (root) CMD (/usr/bin/mdcheck --continue --duration "06:00")
>>      2020-11-27T02:00:01+01:00 done root: mdcheck continue checking /dev/md0 from 10623180920
>>      2020-11-27T02:00:01.382994+01:00 done kernel: [378596.606381] md: data-check of RAID array md0
>>      2020-11-27T02:00:01+01:00 done root: mdcheck continue checking /dev/md1 from 11582849320
>>      2020-11-27T02:00:01.437999+01:00 done kernel: [378596.661559] md: data-check of RAID array md1
>>      2020-11-27T06:00:01.842003+01:00 done kernel: [392996.625147] md: md0: data-check interrupted.
>>      2020-11-27T06:00:02+01:00 done root: pause checking /dev/md0 at 13351127680
>>      2020-11-27T06:00:02.338989+01:00 done kernel: [392997.122520] md: md1: data-check interrupted.
>>      [ nothing related following.... ]
>>
>> After that, we see md1_raid6 in a busy loop:
>>
>>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
>>      2376 root     20   0       0      0      0 R 100.0  0.0   1387:38 md1_raid6
> 
> Seems the reap sync thread was trying to stop md1_raid6 while md1_raid6 was triggered again and again.
> 
>>
>> Also, all processes doing I/O do the md device block.
>>
>> This is /proc/mdstat:
>>
>>      Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [multipath]
>>      md1 : active raid6 sdk[0] sdj[15] sdi[14] sdh[13] sdg[12] sdf[11] sde[10] sdd[9] sdc[8] sdr[7] sdq[6] sdp[5] sdo[4] sdn[3] sdm[2] sdl[1]
>>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]
>>            [==================>..]  check = 94.0% (7350290348/7813894144) finish=57189.3min speed=135K/sec
>>            bitmap: 0/59 pages [0KB], 65536KB chunk
>>      md0 : active raid6 sds[0] sdah[15] sdag[16] sdaf[13] sdae[12] sdad[11] sdac[10] sdab[9] sdaa[8] sdz[7] sdy[6] sdx[17] sdw[4] sdv[3] sdu[2] sdt[1]
>>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 2 [16/16] [UUUUUUUUUUUUUUUU]
>>            bitmap: 0/59 pages [0KB], 65536KB chunk
>>
> 
> So the RECOVERY_CHECK flag should be set, not sure if the simple changes
> helps, but you may give it a try.

Thanks. I've copied the original condition block to execute before the modified one and added some logging to it to see, if the change actually triggers. I will pause and unpause the check frequently on a busy machine to get this code executed more often.

Best
   Donald

> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 98bac4f..e2697d0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9300,7 +9300,8 @@ void md_check_recovery(struct mddev *mddev)
>                          md_update_sb(mddev, 0);
> 
>                  if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> -                   !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
> +                   (!test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> +                    test_bit(MD_RECOVERY_CHECK, &mddev->recovery))) {
>                          /* resync/recovery still happening */
>                          clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>                          goto unlock;
> 
> Thanks,
> Guoqing

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
