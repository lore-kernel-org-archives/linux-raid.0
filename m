Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4034C48BE5
	for <linux-raid@archiver.kernel.org>; Sat, 12 Jun 2021 13:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15BE610A0
	for <linux-raid@archiver.kernel.org>; Sat, 12 Jun 2021 13:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhFLNlr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Jun 2021 09:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLNlq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Jun 2021 09:41:46 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601C0C061574
        for <linux-raid@vger.kernel.org>; Sat, 12 Jun 2021 06:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OcYkHS3qi7JxEcDHuppg5aEmX+w5OrFCoHrDiHPlq/I=; b=RKBJAghUxVARStuB2bz39OtFb2
        xZ29zYez7lnkuBOKfy+kflmm28fZd5SDOjxDf+nB1Vod6kTdXKUyre8XavaTL5HAaL5jnDO1HYXZm
        i7sCuHm42XJTWENqkhPbahFMfni9NibyoWEeZ7ukq6DUWVLLn4ZTkclEKjyJ8OIDUCExCPPvQ71Ky
        zhysp9E/SvEgPVIeOyOt84tOub0jycKrQk/gLuS0RP9RHX2vQ1a52Fv7OR53LWobHH+QurSJu+RvZ
        SfHM1Ka8FUEaPgl8cpDJBunaVRDoWDpn0KHMHpgRvWdFvdPd2bQt1KORuvz+mNTpnyP1oX1xngwpU
        KKKH/I5w==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1ls3rV-0002Ru-VX
        for linux-raid@vger.kernel.org; Sat, 12 Jun 2021 13:39:45 +0000
Date:   Sat, 12 Jun 2021 13:39:45 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: Intermittent stalling of all MD IO, Debian buster (4.19.0-16)
Message-ID: <20210612133945.exl24sor4scy4sz6@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <20210612124157.hq6da5zouwd53ucy@bitfolk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612124157.hq6da5zouwd53ucy@bitfolk.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jun 12, 2021 at 12:41:57PM +0000, Andy Smith wrote:
> Hi,
> 
> I've been experiencing this problem intermittently since December of
> last year after upgrading some existing servers to Debian stable
> (buster). I can't reproduce it at will and it can sometimes take
> several months to happen again, although it has just happened twice
> in 3 days on one host.

I was in a bit of a rush when I dashed that email off. Here's some
more information about the typical configuration of these servers.

$ uname -a
Linux clockwork 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64 GNU/Linux
$ mdadm --version
mdadm - v4.1 - 2018-10-01

Most of these servers have spent about 5 years running on earlier
versions of Debian, notably the full Debian jessie release cycle,
without issue. I've only started having issues after upgrading to
Debian buster.

I will omit details of all member devices as I'm not getting issues
with IO errors, dropouts etc. Most of the servers just have two SATA
SSDs although I am also seeing this on more complex setups.

$ cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10]

md5 : active raid1 sdb5[1] sda5[0]
      3742779392 blocks super 1.2 [2/2] [UU]
      bitmap: 14/28 pages [56KB], 65536KB chunk

md1 : active raid1 sdb1[1] sda1[0]
      975296 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sda2[0] sdb2[1]
      4878336 blocks super 1.2 [2/2] [UU]

md3 : active (auto-read-only) raid1 sdb3[1] sda3[0]
      1951744 blocks super 1.2 [2/2] [UU]

unused devices: <none>

$ sudo smartctl -i /dev/sda
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-16-amd64] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG MZ7KH3T8HALS-00005
Serial Number:    S47RNA0MC01657
LU WWN Device Id: 5 002538 e09c88bb3
Firmware Version: HXM7404Q
User Capacity:    3,840,755,982,336 bytes [3.84 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-4 T13/BSR INCITS 529 revision 5
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Jun 12 13:36:47 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

$ sudo smartctl -i /dev/sdb
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-16-amd64] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG MZ7KH3T8HALS-00005
Serial Number:    S47RNA0MC01656
LU WWN Device Id: 5 002538 e09c88b8a
Firmware Version: HXM7404Q
User Capacity:    3,840,755,982,336 bytes [3.84 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-4 T13/BSR INCITS 529 revision 5
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Jun 12 13:36:54 2021 UTC
Local Time is:    Sat Jun 12 13:36:54 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

At this point it would be really helpful fi Ic ould even narrow it
down to "Xen problem" or "dom0 kernel problem". :(

Cheers,
Andy
