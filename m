Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12080C433E1
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 07:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F582072D
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 07:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=sabi.unospace.net header.i=@sabi.unospace.net header.b="nNstV6WG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgHVHZx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:25:53 -0400
Received: from azure.uno.uk.net ([95.172.254.11]:48868 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgHVHZw (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 22 Aug 2020 03:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sabi.unospace.net; s=default; h=From:References:In-Reply-To:Subject:To:Date
        :Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KZWYy77XyaP48CV+XQGDmnyV3vpi7IvuFHzvCdlQllk=; b=nNstV6WGAB7afTJf2VL3KrQjUZ
        fIx8j0rLukvJsWqj4iZPAM7RHbcZ6HZwkZWr/Q83r2OW3jt4ZQD7OriLdqBNGzTmHz8ZpyHVKlpXP
        zLwo2ErQEN2F34F7QF55WO0r8aKtFPtkZ7gMBMbWrBvNDcpCz+9IfoktUiEbb0oyz9GHYwyaECB+T
        s2CUUYrXQobQNp+zHYrayFmFeFTVy37sJZ/QD+s+QggQ80Ipmr469w+beHDGncqqFsYTGlLX+F9LC
        pLDg2RTLFX/xbdSrQgc1m8l4kP4bsg8OT1Z/Q3yrm4bkONU7vCHfpLLwuu/jSXBRb34xXAGhWR0Lk
        /Ygit7/w==;
Received: from [95.172.224.50] (port=57136 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1k9NuQ-00077T-Fc
        for linux-raid@vger.kernel.org; Sat, 22 Aug 2020 08:25:50 +0100
Received: from from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1k9NuH-00CRE0-Qy
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 08:25:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24384.51317.30569.169686@cyme.ty.sabi.co.uk>
Date:   Sat, 22 Aug 2020 08:25:41 +0100
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Recommended filesystem for RAID 6
In-Reply-To: <05661c44-8193-6bba-67c9-4e0d220eb348@suddenlinkmail.com>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
        <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
        <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
        <5F32F56C.7040603@youngman.org.uk>
        <05661c44-8193-6bba-67c9-4e0d220eb348@suddenlinkmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - azure.uno.uk.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - root.t00.sabi.co.uk
X-Get-Message-Sender-Via: azure.uno.uk.net: authenticated_id: sabity@sabi.unospace.net
X-Authenticated-Sender: azure.uno.uk.net: sabity@sabi.unospace.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>> [...] Note that it IS a shingled drive, so fine for backup,
>> much less so for anything else.

It is fine for backup especially if used as a tape that is say
divided into partitions and backup is done using 'dd' (but
careful if using Btrfs) or 'tar' or similar. If using 'rsync' or
similar those still write a lot of inodes and often small files
if they are present in the source.

>> I'm not sure whether btrfs would be a good choice or not ...

> [...] btrfs did NOT play well with raid 5/6. It may be old
> info, but:
> https://superuser.com/questions/1131701/btrfs-over-mdadm-raid6

That seems based on some misunderstanding: native Btrfs 5/6 has
some "limitations", like most of its volume management, but
running over MS RAID 5/6 is much the same as running on top of a
single disk, so fine. MD RAID 5/6 takes care of redundancy so
there is no need to have metadata in 'dup' mode.

Using RAID 5/6 with SMR drives can result in pretty huge delays
(IIRC a previous poster has given some relevant URL) on writing
or on rebuilding, as the "chunk" size is very likely not to be
very congruent with the SMT zones.
