Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EB7C48BCF
	for <linux-raid@archiver.kernel.org>; Sat, 12 Jun 2021 12:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1503B61287
	for <linux-raid@archiver.kernel.org>; Sat, 12 Jun 2021 12:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFLMoB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Jun 2021 08:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLMoB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Jun 2021 08:44:01 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E82C061574
        for <linux-raid@vger.kernel.org>; Sat, 12 Jun 2021 05:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Kx4CrjzQRR5Ql57zgLQ69/74LjDTyIDQDZpPKs3ee2Y=; b=PPLzyZO1o/3P3/f3Qf2+C+znOL
        CTzsIRfyaSkOObzmx8HWgUOaaSSwWeJnayTtGrLLq0r9d/MFqbMcT5tVeYXynFRsc1uBdzcycpq03
        lR+MZzBEOA/jMMjwK7TF6yGsknhhAyuuwi7318apoSp3a8/BPCAkg9+UowNUxI7PZTsVTzYspcB5p
        pG+ubxmkLfM+5BG4/DDj57RIBNbCx0h1aOArF6KvYdfu73N55DlLXRZegapdoCO04j7OBQHD/FR28
        m57ak3CAaAEsKzebxqolPuRmknvisB4fTxOlaDYCgfIfdcR0AARiLWDXtFNwezUaLsUCRVz2NapTO
        KJLqE9IA==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1ls2xZ-0000Cp-Ma
        for linux-raid@vger.kernel.org; Sat, 12 Jun 2021 12:41:57 +0000
Date:   Sat, 12 Jun 2021 12:41:57 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Intermittent stalling of all MD IO, Debian buster (4.19.0-16)
Message-ID: <20210612124157.hq6da5zouwd53ucy@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I've been experiencing this problem intermittently since December of
last year after upgrading some existing servers to Debian stable
(buster). I can't reproduce it at will and it can sometimes take
several months to happen again, although it has just happened twice
in 3 days on one host.

What happens is that all IO to particular MD devices seems to
freeze. At this point I generally have no option but to power cycle
the server as an orderly shutdown can't be completed.

These servers are Xen hypervisors, and very occasionally I or a
guest administrator has been able to shut down a guest and then
things seem to become unblocked. I am aware that this could mean it
could be a Xen issue and I'm pursuing that angle as well. The
version of the Xen hypervisor in use did change as well as the OS
upgrade.

In terms of logging, this is the sort of thing I get:

Jun 12 12:04:40 clockwork kernel: [216427.246183] INFO: task md5_raid1:205 blocked for more than 120 seconds.
Jun 12 12:04:40 clockwork kernel: [216427.246995]       Not tainted 4.19.0-16-amd64 #1 Debian 4.19.181-1
Jun 12 12:04:40 clockwork kernel: [216427.247852] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 12:04:40 clockwork kernel: [216427.248674] md5_raid1       D 0   205      2 0x80000000
Jun 12 12:04:40 clockwork kernel: [216427.249534] Call Trace:
Jun 12 12:04:40 clockwork kernel: [216427.250368] __schedule+0x29f/0x840
Jun 12 12:04:40 clockwork kernel: [216427.251788]  ? _raw_spin_unlock_irqrestore+0x14/0x20
Jun 12 12:04:40 clockwork kernel: [216427.253078] schedule+0x28/0x80
Jun 12 12:04:40 clockwork kernel: [216427.253945] md_super_wait+0x6e/0xa0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.254812]  ? finish_wait+0x80/0x80
Jun 12 12:04:40 clockwork kernel: [216427.256139] md_bitmap_wait_writes+0x93/0xa0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.256994]  ? md_bitmap_get_counter+0x42/0xd0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.257787] md_bitmap_daemon_work+0x1f7/0x370 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.258608]  ? md_rdev_init+0xb0/0xb0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.259553] md_check_recovery+0x41/0x530 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.260304]  raid1d+0x5c/0xf10 [raid1]
Jun 12 12:04:40 clockwork kernel: [216427.261096]  ? lock_timer_base+0x67/0x80
Jun 12 12:04:40 clockwork kernel: [216427.261863]  ? _raw_spin_unlock_irqrestore+0x14/0x20
Jun 12 12:04:40 clockwork kernel: [216427.262659]  ? try_to_del_timer_sync+0x4d/0x80
Jun 12 12:04:40 clockwork kernel: [216427.263436]  ? del_timer_sync+0x37/0x40
Jun 12 12:04:40 clockwork kernel: [216427.264189]  ? schedule_timeout+0x173/0x3b0
Jun 12 12:04:40 clockwork kernel: [216427.264911]  ? md_rdev_init+0xb0/0xb0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.265664]  ? md_thread+0x94/0x150 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.266412]  ? process_checks+0x4a0/0x4a0 [raid1]
Jun 12 12:04:40 clockwork kernel: [216427.267124] md_thread+0x94/0x150 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.267842]  ? finish_wait+0x80/0x80
Jun 12 12:04:40 clockwork kernel: [216427.268539] kthread+0x112/0x130
Jun 12 12:04:40 clockwork kernel: [216427.269231]  ? kthread_bind+0x30/0x30
Jun 12 12:04:40 clockwork kernel: [216427.269903] ret_from_fork+0x35/0x40
Jun 12 12:04:40 clockwork kernel: [216427.270590] INFO: task md2_raid1:207 blocked for more than 120 seconds.
Jun 12 12:04:40 clockwork kernel: [216427.271260]       Not tainted 4.19.0-16-amd64 #1 Debian 4.19.181-1
Jun 12 12:04:40 clockwork kernel: [216427.271942] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 12:04:40 clockwork kernel: [216427.272721] md2_raid1       D 0   207      2 0x80000000
Jun 12 12:04:40 clockwork kernel: [216427.273432] Call Trace:
Jun 12 12:04:40 clockwork kernel: [216427.274172] __schedule+0x29f/0x840
Jun 12 12:04:40 clockwork kernel: [216427.274869] schedule+0x28/0x80
Jun 12 12:04:40 clockwork kernel: [216427.275543] io_schedule+0x12/0x40
Jun 12 12:04:40 clockwork kernel: [216427.276208] wbt_wait+0x205/0x300
Jun 12 12:04:40 clockwork kernel: [216427.276861]  ? wbt_wait+0x300/0x300
Jun 12 12:04:40 clockwork kernel: [216427.277503] rq_qos_throttle+0x31/0x40
Jun 12 12:04:40 clockwork kernel: [216427.278193] blk_mq_make_request+0x111/0x530
Jun 12 12:04:40 clockwork kernel: [216427.278876] generic_make_request+0x1a4/0x400
Jun 12 12:04:40 clockwork kernel: [216427.279657]  ? try_to_wake_up+0x54/0x470
Jun 12 12:04:40 clockwork kernel: [216427.280400] submit_bio+0x45/0x130
Jun 12 12:04:40 clockwork kernel: [216427.281136]  ? md_super_write.part.63+0x90/0x120 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.281788] md_update_sb.part.65+0x3a8/0x8e0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.282480]  ? md_rdev_init+0xb0/0xb0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.283106] md_check_recovery+0x272/0x530 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.283738]  raid1d+0x5c/0xf10 [raid1]
Jun 12 12:04:40 clockwork kernel: [216427.284345]  ? __schedule+0x2a7/0x840
Jun 12 12:04:40 clockwork kernel: [216427.284939]  ? md_rdev_init+0xb0/0xb0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.285522]  ? schedule+0x28/0x80
Jun 12 12:04:40 clockwork kernel: [216427.286121]  ? schedule_timeout+0x26d/0x3b0
Jun 12 12:04:40 clockwork kernel: [216427.286702]  ? __schedule+0x2a7/0x840
Jun 12 12:04:40 clockwork kernel: [216427.287279]  ? md_rdev_init+0xb0/0xb0 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.287871]  ? md_thread+0x94/0x150 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.288458]  ? process_checks+0x4a0/0x4a0 [raid1]
Jun 12 12:04:40 clockwork kernel: [216427.289062] md_thread+0x94/0x150 [md_mod]
Jun 12 12:04:40 clockwork kernel: [216427.289663]  ? finish_wait+0x80/0x80
Jun 12 12:04:40 clockwork kernel: [216427.290288] kthread+0x112/0x130
Jun 12 12:04:40 clockwork kernel: [216427.290858]  ? kthread_bind+0x30/0x30
Jun 12 12:04:40 clockwork kernel: [216427.291433] ret_from_fork+0x35/0x40

Anyone seen anything like this before or have any suggestions for
what to try next?

It's not really feasible for me to try to see if it happens without
running as a Xen dom0 because even if it doesn't happen for 2 months
I won't have confidence…

Thanks,
Andy
