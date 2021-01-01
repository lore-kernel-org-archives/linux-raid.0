Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262FEC433E0
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 19:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEBC8221F2
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 19:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbhAATuv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Jan 2021 14:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbhAATuu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Jan 2021 14:50:50 -0500
X-Greylist: delayed 2441 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Jan 2021 11:50:10 PST
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFE8C061573
        for <linux-raid@vger.kernel.org>; Fri,  1 Jan 2021 11:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O3Yv6/jWIrr9s32cdbC1rZsCa2CXDxQ8b2/MhzoEBLw=; b=EEWFBAhi4XwZrlv3NqokH+IGB8
        O9af0l36LOLEaplS2FTdvCpbgZDJrnoEWltlMDIfWg8EsZ7W1k0h75NRGdVsYSfPfLPIRyLsw+V59
        1DyJK06YX137DNDQzNO4zv1LKYAPEJG/KdDZtC1AppmjwlQMgHoMHlb/FBoiNOEYAkOESpKYFAiIM
        kBX2NVwcAwFL8DO+GQKgUgfLrt8fRu0fkYO+3Qyy8mTBmASbQ3r4QvOU+lrZ8XKxXZuH6G6luXglw
        c412xFZ9aXrFwrT6/VmQt/pqpJ43fMrxI2qz6s6kpnX7VM/xQ6YDYP/QaIrxQb0zlNV9Ksuf7Ydio
        /p5Tbv3A==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1kvPni-0005r6-5G; Fri, 01 Jan 2021 19:09:26 +0000
Subject: Re: naming system of raid devices
To:     c.buhtz@posteo.jp, linux-raid@vger.kernel.org
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <5d53fe14-3e61-d3bf-d467-9227c93b11a2@turmel.org>
Date:   Fri, 1 Jan 2021 14:09:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4D6pnR0fqcz9rxN@submission02.posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/1/21 10:28 AM, c.buhtz@posteo.jp wrote:
> In the last weeks I played around with mdadm - on VMs, Odroid-Devices,
> PCs - all with Debian 10.
> 
> I observed a (for me) curious behavior about the naming of RAID
> devices.
> 
> I did "--create /dev/md0" all the time.
> 
> But sometimes it results in /dev/md127.
> Sometimes it is /dev/md/0.
> Sometimes it switches between upgrade of the kernel image (/dev/md127
> become /dev/md0 and booting fails).
> 
> Googleing this topic brings up a lot of other users discussing about
> that problem.
> 
> My current solution is to ignore the /dev/*-name and mount the
> device/partition by its UUID.
> 
> Another often reported "solution" is to edit the mdadm.conf. But this
> is not a good solution for me. mdadm looks in the superblock and knows
> (nearly) everything. Each conf-file I need to edit keeps the
> possibility for errors/mistakes/faults (because I am not a sysop/admin
> but a simple home-server-wannabe-admin).

Most distros incrementally assemble raid arrays during early boot, 
before the real root filesystem is mounted.  By itself, with no 
mdadm.conf guidance, mdadm will assign names to arrays starting with 
md127 and counting backwards.  And will process all arrays found.

I recommend creating an mdadm.conf file containing ARRAY entries for 
your desired setup.  Trim those lines to only have the desired name and 
UUID.

Have your distro then rebuild your initramfs (distro-specific) so the 
updated mdadm.conf is available during early boot.  Reboot to see that 
it worked.

Once you are sure it works, I also recommend adding AUTO=-all to 
mdadm.conf, so any extra arrays you might plug in temporarily won't 
auto-assemble if still plugged in during boot.

Phil
