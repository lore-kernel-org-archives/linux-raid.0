Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26F4C64E7C
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 01:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D232217A0
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 01:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLCB4T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Dec 2020 20:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgLCB4S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Dec 2020 20:56:18 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D649DC061A4E
        for <linux-raid@vger.kernel.org>; Wed,  2 Dec 2020 17:55:32 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id t3so403239pgi.11
        for <linux-raid@vger.kernel.org>; Wed, 02 Dec 2020 17:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ubsR/qiIEFFmdKLf5Q808gVWgXuWA3n3kWhdn2997Tg=;
        b=axaL3kQLECQcxzv9hCQ2raEOybn1oj9gkHXYo5XJc682upYH/CE859ApndXH0j40/6
         fLSzoXbYP1mFPO7k+SF5drxD86Pl6cUdUj4AaRRS/x+w90G7aJ9CTcafxKcIgmkeR5zQ
         QWxuelu7EyYcqU4AMayBQEUG9BnguZJu50CLeuSXDseDahnnoHmDIPVpri+hMNT096Y9
         +ztPo2/kL6RW+6ohGfTF2JqbcQmdbvnqKMeBwuGl29GTAn0nof2z3+WaIoCO+hF+nCgi
         3NJFc8vN/XgIiq9cN7VYOQar8nSlMMlBu7zAW5Kfcmid3mdYr5uNWP/X5tSpj42WqPy1
         Jx2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubsR/qiIEFFmdKLf5Q808gVWgXuWA3n3kWhdn2997Tg=;
        b=JEHtMXEgyXENCyXWgMgRMI7B7FxwXfrqHhdflVU/j2+t9sRkiztBzTldF1xiuhXISM
         jYl2erxSm0f994cmNPq6qJKch7D6N1l1DhB/uzLQvmgElRnYZScUiPLIuYd6SfQSEhWi
         NvNOaUucOKjWYof+p+QGZDTWabnz4h/xWSGVJPke0s9Jr2A5SEOOvA19hImO0jfEdY6/
         O+D4naOkl4lBkrDjqN1sVH2g6M9SwPUtfIga8AVZUGGwwnhcfjWkH6VxOl9QHo/OPhsT
         p36hU47P+rr1C495kMlsTzasY3Gpdwjafsrl8pz7+lBEM55Jk8M5faM0GBIhVCAAF2ft
         E0rg==
X-Gm-Message-State: AOAM531OFHYpVNYcuy/Cxl4OJhsLh37FwVrAYczz8XG5fRLi8ZBn2uYF
        bwenXJqzpTBDHzGAy8iNbvDL3wE0ufOPxw==
X-Google-Smtp-Source: ABdhPJx4YsZiA17OE9XjeBSDEnNNGJ19oD/2ORchhPmlfCK28I/46QYo2j6l0ao2lkTky2ublxGRMw==
X-Received: by 2002:a05:6a00:22c9:b029:198:15b2:bbd3 with SMTP id f9-20020a056a0022c9b029019815b2bbd3mr909217pfj.64.1606960531048;
        Wed, 02 Dec 2020 17:55:31 -0800 (PST)
Received: from [10.8.0.104] ([196.245.9.44])
        by smtp.gmail.com with ESMTPSA id o9sm149986pjl.11.2020.12.02.17.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 17:55:30 -0800 (PST)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
 <77244d60-1c2d-330e-71e6-4907d4dd65fc@molgen.mpg.de>
 <7c5438c7-2324-cc50-db4d-512587cb0ec9@molgen.mpg.de>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <b289ae15-ff82-b36e-4be4-a1c8bbdbacd7@cloud.ionos.com>
Date:   Thu, 3 Dec 2020 02:55:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7c5438c7-2324-cc50-db4d-512587cb0ec9@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Donald,

On 12/2/20 18:28, Donald Buczek wrote:
> Dear Guoqing,
> 
> unfortunately the patch didn't fix the problem (unless I messed it up 
> with my logging). This is what I used:
> 
>      --- a/drivers/md/md.c
>      +++ b/drivers/md/md.c
>      @@ -9305,6 +9305,14 @@ void md_check_recovery(struct mddev *mddev)
>                              clear_bit(MD_RECOVERY_NEEDED, 
> &mddev->recovery);
>                              goto unlock;
>                      }

I think you can add the check of RECOVERY_CHECK in above part instead of 
add a new part.

>      +               if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>      +                   (!test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
>      +                    test_bit(MD_RECOVERY_CHECK, &mddev->recovery))) {
>      +                       /* resync/recovery still happening */
>      +                       pr_info("md: XXX BUGFIX applied\n");
>      +                       clear_bit(MD_RECOVERY_NEEDED, 
> &mddev->recovery);
>      +                       goto unlock;
>      +               }
>                      if (mddev->sync_thread) {
>                              md_reap_sync_thread(mddev);
>                              goto unlock;


> 
> With pausing and continuing the check four times an hour, I could 
> trigger the problem after about 48 hours. This time, the other device 
> (md0) has locked up on `echo idle > 
> /sys/devices/virtual/block/md0/md/sync_action` , while the check of md1 
> is still ongoing:

Without the patch, md0 was good while md1 was locked. So the patch 
switches the status of the two arrays, a little weird ...

What is the stack of the process? I guess it is same as the stack of 
23333 in your previous mail, but just to confirm.

> 
>      Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
> [multipath]
>      md1 : active raid6 sdk[0] sdj[15] sdi[14] sdh[13] sdg[12] sdf[11] 
> sde[10] sdd[9] sdc[8] sdr[7] sdq[6] sdp[5] sdo[4] sdn[3] sdm[2] sdl[1]
>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 
> 2 [16/16] [UUUUUUUUUUUUUUUU]
>            [=>...................]  check =  8.5% (666852112/7813894144) 
> finish=1271.2min speed=93701K/sec
>            bitmap: 0/59 pages [0KB], 65536KB chunk
>      md0 : active raid6 sds[0] sdah[15] sdag[16] sdaf[13] sdae[12] 
> sdad[11] sdac[10] sdab[9] sdaa[8] sdz[7] sdy[6] sdx[17] sdw[4] sdv[3] 
> sdu[2] sdt[1]
>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 
> 2 [16/16] [UUUUUUUUUUUUUUUU]
>            [>....................]  check =  0.2% (19510348/7813894144) 
> finish=253779.6min speed=511K/sec
>            bitmap: 0/59 pages [0KB], 65536KB chunk
> 
> after 1 minute:
> 
>      Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
> [multipath]
>      md1 : active raid6 sdk[0] sdj[15] sdi[14] sdh[13] sdg[12] sdf[11] 
> sde[10] sdd[9] sdc[8] sdr[7] sdq[6] sdp[5] sdo[4] sdn[3] sdm[2] sdl[1]
>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 
> 2 [16/16] [UUUUUUUUUUUUUUUU]
>            [=>...................]  check =  8.6% (674914560/7813894144) 
> finish=941.1min speed=126418K/sec
>            bitmap: 0/59 pages [0KB], 65536KB chunk
>      md0 : active raid6 sds[0] sdah[15] sdag[16] sdaf[13] sdae[12] 
> sdad[11] sdac[10] sdab[9] sdaa[8] sdz[7] sdy[6] sdx[17] sdw[4] sdv[3] 
> sdu[2] sdt[1]
>            109394518016 blocks super 1.2 level 6, 512k chunk, algorithm 
> 2 [16/16] [UUUUUUUUUUUUUUUU]
>            [>....................]  check =  0.2% (19510348/7813894144) 
> finish=256805.0min speed=505K/sec
>            bitmap: 0/59 pages [0KB], 65536KB chunk
> 
> A data point, I didn't mention in my previous mail, is that the 
> mdX_resync thread is not gone when the problem occurs:
> 
>      buczek@done:/scratch/local/linux (v5.10-rc6-mpi)$ ps -Af|fgrep [md
>      root       134     2  0 Nov30 ?        00:00:00 [md]
>      root      1321     2 27 Nov30 ?        12:57:14 [md0_raid6]
>      root      1454     2 26 Nov30 ?        12:37:23 [md1_raid6]
>      root      5845     2  0 16:20 ?        00:00:30 [md0_resync]
>      root      5855     2 13 16:20 ?        00:14:11 [md1_resync]
>      buczek    9880  9072  0 18:05 pts/0    00:00:00 grep -F [md
>      buczek@done:/scratch/local/linux (v5.10-rc6-mpi)$ sudo cat 
> /proc/5845/stack
>      [<0>] md_bitmap_cond_end_sync+0x12d/0x170
>      [<0>] raid5_sync_request+0x24b/0x390
>      [<0>] md_do_sync+0xb41/0x1030
>      [<0>] md_thread+0x122/0x160
>      [<0>] kthread+0x118/0x130
>      [<0>] ret_from_fork+0x1f/0x30
> 
> I guess, md_bitmap_cond_end_sync+0x12d is the 
> `wait_event(bitmap->mddev->recovery_wait,atomic_read(&bitmap->mddev->recovery_active) 
> == 0);` in md-bitmap.c.
> 

Could be, if so, then I think md_done_sync was not triggered by the path 
md0_raid6 -> ... -> handle_stripe.

I'd suggest to compare the stacks between md0 and md1 to find the 
difference.

Thanks,
Guoqing
