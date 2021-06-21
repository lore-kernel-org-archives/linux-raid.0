Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441C8C4743C
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 12:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 209E560FF4
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 12:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhFUMTt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Jun 2021 08:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFUMTt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Jun 2021 08:19:49 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0610C061574
        for <linux-raid@vger.kernel.org>; Mon, 21 Jun 2021 05:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OTFUlO7li/jd6mUC/fX/i9nste0+2xewINHKPXZR2TM=; b=b0JHXDBGIigoNFLHMitez96G5h
        rfzWbOC3Ji1gBmtCmHiLf7w18FrCCoPgpYjiFpuxO71p9xkloQjvNwiNgtIfJ2J47q+BfiEpHuuqO
        Xxrh90UKxXn8WT4vWCVWqeNVbOHuddlDWFRQDsLhNpCWkE8DFSn9M9ZyXXi96S06E3iFUhYJjYdeI
        Pdp9nPS7gi2Cw+7EFk0yAAHEeR5spZG0R9xuXcBs2j3To86cijoYKE/NQnnrCz2UED/8qjeVILIFB
        4I33E8iQvfWHTHbWI+nP0qPn4nlVwAy7eB5IISM4iEgRfQ8D6zKouHeZO5lRomJTDTnssi5Yt0mzc
        7afpet3g==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lvIrt-0001x2-86; Mon, 21 Jun 2021 12:17:33 +0000
Subject: Re: How does one enable SCTERC on an NVMe drive (and other install
 questions)
To:     Edward Kuns <eddie.kuns@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <823ffe5e-f2d2-3bd8-d947-8f3af8b1514e@turmel.org>
Date:   Mon, 21 Jun 2021 08:17:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Eddie,

On 6/21/21 1:00 AM, Edward Kuns wrote:
> 1) Topic one - SCTERC on NVMe
> 
> I'm in the middle of installing Linux on a new PC.  I have a pair of
> 1TB NVMe drives.  All of my non-NVMe drives support "smartctl -l
> scterc,70,70" but the NVMe drives do not seem to.  How can one ensure
> that SCTERC is configured properly in an NVMe drive that is part of a
> software RAID constructed using mdadm?  Is this an issue that has been
> solved or asked or addressed before?  The searching I did didn't bring
> anything up.

You can't, if the firmware doesn't allow it.  Do try reading the values 
before writing them, though.  I've seen SSDs that start up with "40,40" 
and refuse changes.  40,40 is fine.

Please report here any brands/models that either don't support SCTERC at 
all, or are stuck on disabled.  So the rest of us can avoid them.

> 2) Topic two - RAID on /boot and /boot/efi
> 
> It looks like RHEL 8 and clones don't support the installer building
> LVM on top of RAID as they used to.  I kind of suspect that the
> installer would prefer that if I want LVM, that I use the RAID built
> into LVM at this point.  But it looks to me like the mdadm tools are
> still much more mature than the RAID built into LVM.  (Even though it
> appears that this is built on top of the same code base?)
> 
> This means I have to do that work before running the installer, by
> running the installer in rescue mode, then run the installer and
> "reformat' the partitions I have created by hand.  I haven't gone all
> the way through this process but it looks like it works.  It also
> looks like maybe I cannot use the installer to set up RAID mirroring
> for /boot or /boot/efi.  I may have to set that up after the fact.  It
> looks like I have to use metadata format 1.0 for that?  I'm going to
> go through a couple experimental installs to see how it all goes
> (using wipefs, and so on, between attempts).  I've made a script to do
> all the work for me so I can experiment.
> 
> The good thing about this is it gets me more familiar with the
> command-line tools before I have an issue, and it forces me to
> document what I'm doing in order to set it up.  One of my goals for
> this install is that any single disk can fail, including a disk
> containing / or /boot or /boot/efi, with a simple recovery process of
> replacing the failed disk and rebuilding an array and no unscheduled
> downtime.  I'm not sure it's possible (with /boot and /boot/efi in
> particular)  but I'm going to find out.  All I can tell from research
> so far is that metadata 1.1 or 1.2 won't work for such partitions.

I don't use CentOS, but you seem to be headed down the same path I would 
follow.  And yes, use metadata v1.0 so the BIOS can treat /boot/efi as a 
normal partition.  You may be able to use other metadata on /boot itself 
if the grub shim in /boot/efi supports it.  (Not sure on that.)

[trimmed what Wol responded to]

Regards,

Phil
