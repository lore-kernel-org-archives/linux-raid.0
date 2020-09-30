Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BA1C4727F
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 09:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD7720659
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 09:00:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=madore.org header.i=@madore.org header.b="aog7JSqR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgI3JAd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:00:33 -0400
Received: from achernar.gro-tsen.net ([163.172.93.86]:42390 "EHLO
        achernar.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI3JAc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Sep 2020 05:00:32 -0400
X-Greylist: delayed 26399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 05:00:32 EDT
Received: by achernar.gro-tsen.net (Postfix, from userid 500)
        id 278A92140599; Wed, 30 Sep 2020 11:00:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=madore.org;
        s=achernar; t=1601456431;
        bh=ptppgBEzt33EUPrLpGCnMcUh6tybW01WGAe/imHZ37c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aog7JSqRWXx9l0WNTAzQ3VOcjQxCcQRg6pdgwR/6fc1+zWuokUEpSakEzO6W0v30G
         V9Lgu2ZKed+CPWKtReFW3+Vt5uQf9xRfhjC+wKy7x8ySMqbDU4qsciUmylYWnzSsBZ
         9sj97fBsE3L9S6kK7zfsXEnCyfN3ZDUA8xmFzxLw=
Date:   Wed, 30 Sep 2020 11:00:31 +0200
From:   David Madore <david+ml@madore.org>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
Message-ID: <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
 <5F740390.7050005@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F740390.7050005@youngman.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 30, 2020 at 05:03:28AM +0100, Wols Lists wrote:
> uname -a ???

Linux vega.stars 4.9.237-vega #1 SMP Tue Sep 29 23:52:36 CEST 2020 x86_64 GNU/Linux

This is a stock 4.9.237 kernel that I compiled with gcc version 4.8.4
(Debian 4.8.4-1).  RAID-related options in the config are:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_MD_CLUSTER is not set
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_RAID6_PQ=m

(I can, of course, put the full config somewhere).

> mdadm --version ???

mdadm - v3.4 - 28th January 2016

(This is the version from Debian 9.13 "stretch" (aka oldstable).)

> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

I should have clarified that I suffered no data loss.  Since the
attempt to reshape simply does nothing (and the underlying filesystem
was read-only just in case), I was able to simply recreate the RAID5
array with --assume-clean.  But I'd really like to convert to RAID6.

I can, of course, provide detailed information on the disks, but since
I can reproduce the problem on loopback devices, I imagine this isn't
too relevant.

> I'm guessing you're on an older version of Ubuntu / Debian ?

Yes, Debian 9.13 "stretch" (aka oldstable).

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
