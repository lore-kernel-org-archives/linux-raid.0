Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D547C64E8A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 02:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18FA920757
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 02:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="jCVFjKrl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgK3CHS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgK3CHS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 29 Nov 2020 21:07:18 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB76C0613D2
        for <linux-raid@vger.kernel.org>; Sun, 29 Nov 2020 18:06:32 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id a16so18320259ejj.5
        for <linux-raid@vger.kernel.org>; Sun, 29 Nov 2020 18:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yUFTrmBcTv6s2WlseBa7/fojjPpOwHHi239KldjwbCQ=;
        b=jCVFjKrlsOTWqDGb4O0NCvhBceF/Nu6W7EHItFnfB4It963FJCon2qmaCVn7odK21B
         UTbRTW1Wmqqb3ZS1yVFyoUqGLAfo3cvs/17z9Ckdy8YrCEvyBUg6RY/3MIsjJXkVKn3I
         YnlO/MsiAftCiiInM8RVtRD6O00mNaNvpH/av53qMZLQCL8BOvsKHB2bvWD+Yj0OVVWr
         0Ev+HjjkHqOq/kJg1mwJK7tba88El97A1cE3F1OaZEOeoPIO7DfOhxZgNb5K2nYfr8cc
         lXsgO8YMGWdK8HsJR5oP9GlTNNakyEVx2FkyABYnBs2sMqki0BnZ11B0fVf404ll8mWD
         1T1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yUFTrmBcTv6s2WlseBa7/fojjPpOwHHi239KldjwbCQ=;
        b=SFLQtNWKt7Pkk9MnWoGUCm+nX8i+wiBtOicBvzh+u2r9FpzhNo89Mb1A+p62f12asU
         vRwz08B/gtkG6ft+/t3yaGHrsSjSYL5typaRtnEy3XXNTy51TS3fIjVqfVN7XTtOZ3+3
         QVzihNHEZOwBX4R/WsXABD/Xr2YaNzW6YGm/24RHhRNZ/UTdzfwRjN2qVicuqge9axdZ
         Ga18xVjKvSQ8JiIIiXI9G7nlBfS1alaxING8C2SM5/YnQCrXppiX7ruysnDQ14AjqrmA
         Av2Q8cHZqEbls16ysEVbEyWh1HezIIQxTsgCsDXxCuWegDnl5TzChV2hKA09jdX28qUD
         5VuQ==
X-Gm-Message-State: AOAM533N3zhh5pAUa27YY+Qx1lAQ5uV7WuFlaX3EYPYZi1ZGnlEJgyPK
        Qfeh+E8CCMRPqF4KbeUP5Y5CDA==
X-Google-Smtp-Source: ABdhPJzwld2qWB0JvY0wVJqs9rtlmG3dUpTNk8zZ4y5WOAiV03tAlEcun196GwC7kmfo7ZrmIXuncQ==
X-Received: by 2002:a17:906:7191:: with SMTP id h17mr2975447ejk.421.1606701990627;
        Sun, 29 Nov 2020 18:06:30 -0800 (PST)
Received: from ?IPv6:240e:82:0:92f3:e12d:4673:cbec:1111? ([240e:82:0:92f3:e12d:4673:cbec:1111])
        by smtp.gmail.com with ESMTPSA id m7sm5905343eds.73.2020.11.29.18.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 18:06:30 -0800 (PST)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
Date:   Mon, 30 Nov 2020 03:06:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/28/20 13:25, Donald Buczek wrote:
> Dear Linux mdraid people,
> 
> we are using raid6 on several servers. Occasionally we had failures, 
> where a mdX_raid6 process seems to go into a busy loop and all I/O to 
> the md device blocks. We've seen this on various kernel versions.
> 
> The last time this happened (in this case with Linux 5.10.0-rc4), I took 
> some data.
> 
> The triggering event seems to be the md_check cron job trying to pause 
> the ongoing check operation in the morning with
> 
>      echo idle > /sys/devices/virtual/block/md1/md/sync_action
> 
> This doesn't complete. Here's /proc/stack of this process:
> 
>      root@done:~/linux_problems/mdX_raid6_looping/2020-11-27# ps -fp 23333
>      UID        PID  PPID  C STIME TTY          TIME CMD
>      root     23333 23331  0 02:00 ?        00:00:00 /bin/bash 
> /usr/bin/mdcheck --continue --duration 06:00
>      root@done:~/linux_problems/mdX_raid6_looping/2020-11-27# cat 
> /proc/23333/stack
>      [<0>] kthread_stop+0x6e/0x150
>      [<0>] md_unregister_thread+0x3e/0x70
>      [<0>] md_reap_sync_thread+0x1f/0x1e0
>      [<0>] action_store+0x141/0x2b0
>      [<0>] md_attr_store+0x71/0xb0
>      [<0>] kernfs_fop_write+0x113/0x1a0
>      [<0>] vfs_write+0xbc/0x250
>      [<0>] ksys_write+0xa1/0xe0
>      [<0>] do_syscall_64+0x33/0x40
>      [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Note, that md0 has been paused successfully just before.

What is the personality of md0? Is it also raid6?

> 
>      2020-11-27T02:00:01+01:00 done CROND[23333]: (root) CMD 
> (/usr/bin/mdcheck --continue --duration "06:00")
>      2020-11-27T02:00:01+01:00 done root: mdcheck continue checking 
> /dev/md0 from 10623180920
>      2020-11-27T02:00:01.382994+01:00 done kernel: [378596.606381] md: 
> data-check of RAID array md0
>      2020-11-27T02:00:01+01:00 done root: mdcheck continue checking 
> /dev/md1 from 11582849320
>      2020-11-27T02:00:01.437999+01:00 done kernel: [378596.661559] md: 
> data-check of RAID array md1
>      2020-11-27T06:00:01.842003+01:00 done kernel: [392996.625147] md: 
> md0: data-check interrupted.
>      2020-11-27T06:00:02+01:00 done root: pause checking /dev/md0 at 
> 13351127680
>      2020-11-27T06:00:02.338989+01:00 done kernel: [392997.122520] md: 
> md1: data-check interrupted.
>      [ nothing related following.... ]
> 
> After that, we see md1_raid6 in a busy loop:
> 
>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ 
> COMMAND
>      2376 root     20   0       0      0      0 R 100.0  0.0   1387:38 
> md1_raid6

Seems the reap sync thread was trying to stop md1_raid6 while md1_raid6 
was triggered again and again.

> 
> Also, all processes doing I/O do the md device block.
> 
> This is /proc/mdstat:
> 
>      Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
> [multipath]
>      md1 : active raid6 sdk[0] sdj[15] sdi[14] sdh[13] sdg[12] sdf[11] 
> sde[10] sdd[9] sdc[8] sdr[7] sdq[6] sdp[5] sdo[4] sdn[3] sdm[2] sdl[1]
>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 
> 2 [16/16] [UUUUUUUUUUUUUUUU]
>            [==================>..]  check = 94.0% 
> (7350290348/7813894144) finish=57189.3min speed=135K/sec
>            bitmap: 0/59 pages [0KB], 65536KB chunk
>      md0 : active raid6 sds[0] sdah[15] sdag[16] sdaf[13] sdae[12] 
> sdad[11] sdac[10] sdab[9] sdaa[8] sdz[7] sdy[6] sdx[17] sdw[4] sdv[3] 
> sdu[2] sdt[1]
>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 
> 2 [16/16] [UUUUUUUUUUUUUUUU]
>            bitmap: 0/59 pages [0KB], 65536KB chunk
> 

So the RECOVERY_CHECK flag should be set, not sure if the simple changes
helps, but you may give it a try.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f..e2697d0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9300,7 +9300,8 @@ void md_check_recovery(struct mddev *mddev)
                         md_update_sb(mddev, 0);

                 if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
-                   !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
+                   (!test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
+                    test_bit(MD_RECOVERY_CHECK, &mddev->recovery))) {
                         /* resync/recovery still happening */
                         clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
                         goto unlock;

Thanks,
Guoqing
