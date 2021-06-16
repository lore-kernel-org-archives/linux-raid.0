Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B93C48BE6
	for <linux-raid@archiver.kernel.org>; Wed, 16 Jun 2021 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17AA6115C
	for <linux-raid@archiver.kernel.org>; Wed, 16 Jun 2021 03:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhFPD74 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhFPD7z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Jun 2021 23:59:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A945C061574
        for <linux-raid@vger.kernel.org>; Tue, 15 Jun 2021 20:57:50 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id k15so1102940pfp.6
        for <linux-raid@vger.kernel.org>; Tue, 15 Jun 2021 20:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=y5cZmfg9b+3b745RRk1eTK2BNL19+pvob09R4hCAe00=;
        b=IFZROHyx1jistLO+RnEIrU4S43hN+sbi/S1FRXRXjQGTeHFFO8vki5Nf41Pb76BebQ
         iIk/PgsLMLiVtg/eFhy9g9xOgoKIWhlSISEHJ2ewYah9PARU6xzbMIFb1jDY5Ef9MDUe
         NpEhY9N3VkN8lTPAGrkoe0degJfzA62xhiD+uo1k3ZKqPndsgojqS09TRzOi3JN7Vp50
         pQXGWSz0wvpyzsysVUOkT1IO9a9OdFMI//cCV/ipEopkJwnvadVybfumdiX7u5ekowWZ
         UQv2l0uP700IrcQjpRR4OCyAW5DyFQscZya4QZsXXedcf6W5oj7VfeoKURXtr2sJbNus
         CsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=y5cZmfg9b+3b745RRk1eTK2BNL19+pvob09R4hCAe00=;
        b=e9b1V7PDmR3GuiTsqOHCsmzSM+q9YRlGmNR6x1wuDJ3r1Hbaxt4qS/cOmKdUmi01+P
         XGQ+FxX7lwF1OZQoVEQuEgoSI0zDxEm3B+TOEcvxFluGsfNMC4lfMEjCStZEF3/hLSbg
         HY2qFwBP+6lmREN7A/DXS1wsAXooxzsw+wjC7tTCIYl9hFadBulwaJvSdTWaEqxFoHRn
         +zAUTMbW+l16oD9KcKq5/ObjScKYdpBN5sOn83+2CnoR0Kcq3iVlVjEsAyn4bH0bGsSn
         ixGrUygFBcvqrOK4I7hj6z5TGISAtoKL9dHupC5S3qIHaKm3HJDWt6tYu+J7YgE1gHlE
         I27Q==
X-Gm-Message-State: AOAM531GjzV250vz2SbqdY055OJAlMesdUCkyyYH9A1S9kkQVSHpCG53
        euWgvfdQPhKhCrUQViOWvgJsq1V+7VBImTQi
X-Google-Smtp-Source: ABdhPJzNsNVUs6IDiXjXCljYMAhcMPhs6PFs+7g2+Bvt01cEHvLmzWk4Xq8qShNtM1tXuBR3AxXESw==
X-Received: by 2002:a05:6a00:98d:b029:2f5:fcb5:5efb with SMTP id u13-20020a056a00098db02902f5fcb55efbmr7576158pfg.10.1623815869310;
        Tue, 15 Jun 2021 20:57:49 -0700 (PDT)
Received: from [10.6.1.62] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id i10sm551669pfk.74.2021.06.15.20.57.47
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 20:57:48 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
Subject: Re: Intermittent stalling of all MD IO, Debian buster (4.19.0-16)
To:     linux-raid@vger.kernel.org
References: <20210612124157.hq6da5zouwd53ucy@bitfolk.com>
Message-ID: <336ddb45-990f-5d52-23b0-c097c124d022@gmail.com>
Date:   Wed, 16 Jun 2021 11:57:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210612124157.hq6da5zouwd53ucy@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 6/12/21 8:41 PM, Andy Smith wrote:
> Hi,
>
> I've been experiencing this problem intermittently since December of
> last year after upgrading some existing servers to Debian stable
> (buster). I can't reproduce it at will and it can sometimes take
> several months to happen again, although it has just happened twice
> in 3 days on one host.
>
> What happens is that all IO to particular MD devices seems to
> freeze. At this point I generally have no option but to power cycle
> the server as an orderly shutdown can't be completed.
>
> These servers are Xen hypervisors, and very occasionally I or a
> guest administrator has been able to shut down a guest and then
> things seem to become unblocked. I am aware that this could mean it
> could be a Xen issue and I'm pursuing that angle as well. The
> version of the Xen hypervisor in use did change as well as the OS
> upgrade.
>
> In terms of logging, this is the sort of thing I get:
>
> Jun 12 12:04:40 clockwork kernel: [216427.246183] INFO: task md5_raid1:205 blocked for more than 120 seconds.
> Jun 12 12:04:40 clockwork kernel: [216427.246995]       Not tainted 4.19.0-16-amd64 #1 Debian 4.19.181-1
> Jun 12 12:04:40 clockwork kernel: [216427.247852] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jun 12 12:04:40 clockwork kernel: [216427.248674] md5_raid1       D 0   205      2 0x80000000
> Jun 12 12:04:40 clockwork kernel: [216427.249534] Call Trace:
> Jun 12 12:04:40 clockwork kernel: [216427.250368] __schedule+0x29f/0x840
> Jun 12 12:04:40 clockwork kernel: [216427.251788]  ? _raw_spin_unlock_irqrestore+0x14/0x20
> Jun 12 12:04:40 clockwork kernel: [216427.253078] schedule+0x28/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.253945] md_super_wait+0x6e/0xa0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.254812]  ? finish_wait+0x80/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.256139] md_bitmap_wait_writes+0x93/0xa0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.256994]  ? md_bitmap_get_counter+0x42/0xd0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.257787] md_bitmap_daemon_work+0x1f7/0x370 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.258608]  ? md_rdev_init+0xb0/0xb0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.259553] md_check_recovery+0x41/0x530 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.260304]  raid1d+0x5c/0xf10 [raid1]
> Jun 12 12:04:40 clockwork kernel: [216427.261096]  ? lock_timer_base+0x67/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.261863]  ? _raw_spin_unlock_irqrestore+0x14/0x20
> Jun 12 12:04:40 clockwork kernel: [216427.262659]  ? try_to_del_timer_sync+0x4d/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.263436]  ? del_timer_sync+0x37/0x40
> Jun 12 12:04:40 clockwork kernel: [216427.264189]  ? schedule_timeout+0x173/0x3b0
> Jun 12 12:04:40 clockwork kernel: [216427.264911]  ? md_rdev_init+0xb0/0xb0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.265664]  ? md_thread+0x94/0x150 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.266412]  ? process_checks+0x4a0/0x4a0 [raid1]
> Jun 12 12:04:40 clockwork kernel: [216427.267124] md_thread+0x94/0x150 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.267842]  ? finish_wait+0x80/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.268539] kthread+0x112/0x130
> Jun 12 12:04:40 clockwork kernel: [216427.269231]  ? kthread_bind+0x30/0x30
> Jun 12 12:04:40 clockwork kernel: [216427.269903] ret_from_fork+0x35/0x40
> Jun 12 12:04:40 clockwork kernel: [216427.270590] INFO: task md2_raid1:207 blocked for more than 120 seconds.
> Jun 12 12:04:40 clockwork kernel: [216427.271260]       Not tainted 4.19.0-16-amd64 #1 Debian 4.19.181-1
> Jun 12 12:04:40 clockwork kernel: [216427.271942] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jun 12 12:04:40 clockwork kernel: [216427.272721] md2_raid1       D 0   207      2 0x80000000
> Jun 12 12:04:40 clockwork kernel: [216427.273432] Call Trace:
> Jun 12 12:04:40 clockwork kernel: [216427.274172] __schedule+0x29f/0x840
> Jun 12 12:04:40 clockwork kernel: [216427.274869] schedule+0x28/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.275543] io_schedule+0x12/0x40
> Jun 12 12:04:40 clockwork kernel: [216427.276208] wbt_wait+0x205/0x300
> Jun 12 12:04:40 clockwork kernel: [216427.276861]  ? wbt_wait+0x300/0x300
> Jun 12 12:04:40 clockwork kernel: [216427.277503] rq_qos_throttle+0x31/0x40
> Jun 12 12:04:40 clockwork kernel: [216427.278193] blk_mq_make_request+0x111/0x530
> Jun 12 12:04:40 clockwork kernel: [216427.278876] generic_make_request+0x1a4/0x400
> Jun 12 12:04:40 clockwork kernel: [216427.279657]  ? try_to_wake_up+0x54/0x470
> Jun 12 12:04:40 clockwork kernel: [216427.280400] submit_bio+0x45/0x130
> Jun 12 12:04:40 clockwork kernel: [216427.281136]  ? md_super_write.part.63+0x90/0x120 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.281788] md_update_sb.part.65+0x3a8/0x8e0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.282480]  ? md_rdev_init+0xb0/0xb0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.283106] md_check_recovery+0x272/0x530 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.283738]  raid1d+0x5c/0xf10 [raid1]
> Jun 12 12:04:40 clockwork kernel: [216427.284345]  ? __schedule+0x2a7/0x840
> Jun 12 12:04:40 clockwork kernel: [216427.284939]  ? md_rdev_init+0xb0/0xb0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.285522]  ? schedule+0x28/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.286121]  ? schedule_timeout+0x26d/0x3b0
> Jun 12 12:04:40 clockwork kernel: [216427.286702]  ? __schedule+0x2a7/0x840
> Jun 12 12:04:40 clockwork kernel: [216427.287279]  ? md_rdev_init+0xb0/0xb0 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.287871]  ? md_thread+0x94/0x150 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.288458]  ? process_checks+0x4a0/0x4a0 [raid1]
> Jun 12 12:04:40 clockwork kernel: [216427.289062] md_thread+0x94/0x150 [md_mod]
> Jun 12 12:04:40 clockwork kernel: [216427.289663]  ? finish_wait+0x80/0x80
> Jun 12 12:04:40 clockwork kernel: [216427.290288] kthread+0x112/0x130
> Jun 12 12:04:40 clockwork kernel: [216427.290858]  ? kthread_bind+0x30/0x30
> Jun 12 12:04:40 clockwork kernel: [216427.291433] ret_from_fork+0x35/0x40

The above looks like the bio for sb write was throttled by wbt, which 
caused the first calltrace.
I am wondering if there  were intensive IOs happened to the underlying 
device of md5, which
triggered wbt to throttle sb write, or can you access the underlying 
device directly?

And there was a report [1] for raid5 which may related to wbt throttle 
as well, not sure if the
change [2] could help or not.

[1]. 
https://lore.kernel.org/linux-raid/d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz/
[2]. 
https://lore.kernel.org/linux-raid/cb0f312e-55dc-cdc4-5d2e-b9b415de617f@gmail.com/

Thanks,
Guoqing
