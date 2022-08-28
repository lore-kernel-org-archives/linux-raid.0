Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D45ECAAD5
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 17:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiH1RYY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 13:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiH1RYX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 13:24:23 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082662FFD1
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 10:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qM5ErtEzlg8P53TLuJsK7r106f6oilRvViI5RgOyqYU=; b=PlW3C9Y1aKqJgV9Bx8DCs7J8/v
        5VYEAiYd2ClwzO5tImSyDZ4ZkMkbnKVYxqZB+4O9BC3bvF21RgPe/Pb/wHlbOW2SGk8CRijqBr/XU
        5EAj4u82P7l5E95pjOykoejUUpNotb1EzNgtYiOxdX8aWjkP6I/67K8CB2poNADxfk+i/p6Tu2FSF
        GM15p3b91tmkyBqpJJry+Qzn+7PFB3XOdDQ5tclny0OBMEzUTSWou68YvCeH987kh44gZwXePuMVa
        +aI/bVoiMC3Xqnka61Se1+1GMjNPiG/O8dOaGJsVOcoRzlHyW1RsOgr6acMxo/pXkntTzYDt/pV+2
        OcYa5mew==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1oSLpE-00035d-8E
        for linux-raid@vger.kernel.org; Sun, 28 Aug 2022 17:11:56 +0000
Date:   Sun, 28 Aug 2022 17:11:56 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: RAID 6, 6 device array - all devices lost superblock
Message-ID: <20220828171156.56iqcps7z6hvzarp@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Peter,

On Sat, Aug 27, 2022 at 10:00:32PM -0400, Peter Sanders wrote:
> After the hardware was replaced, my array will not assemble - mdadm
> assemble reports no RAID superblock on the devices.
> root@superior:/etc/mdadm# mdadm --assemble --scan --verbose
> mdadm: looking for devices for /dev/md/0
> mdadm: cannot open device /dev/sr0: No medium found
> mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sda
> mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdb

I'm wondering if this is one of those motherboards that at boot
helpfully writes a new empty GPT on any drive that it thinks doesn't
have any kind of partitioning. I say this because:

- It looks like you're using sd{a,b} etc with no partitions
- I've heard of motherboards that do this
- You say you just switched to a new motherboard

Cheers,
Andy
