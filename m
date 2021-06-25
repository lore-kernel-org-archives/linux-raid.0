Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D59C2B9F4
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 22:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B320F61946
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 22:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhFYWLK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYWLJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Jun 2021 18:11:09 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3F6C061574
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 15:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vtNqdc1tnvNKODXuNIHkjbCDxDrMt+uvEsQI4VDDewo=; b=1LwF7Fhud8yBkJJlJDd+BEsPKa
        UUrgrcwz0fgkt5Ewx+50F630PvvTq21BgIZp4kjByH6tGCx0Jfm8kRKLYClL6k8ayFWUfYpVJnrWa
        ZKHKRhs4nhMo8dox9oGjGxgyPJWiduOWi6DueiHmnjUuTHVMDLhSmbEkrHvDpc3fRB9CVutuUtDg2
        ZEOu59V42UhcQHgDjszWOKiDt4C3pr3pd+Gfmlx8cp98QzbbQCx6zxjLdf6WUL0QehozOaEmJoH1A
        VJ6kwqy26vrpkeqaPhmF9IyqEo1fYdAxvd2DvFxv0GB3YhumUWyAKM4SuHztkQ7MxPcpvqSR4P2q7
        KZ3mqHpg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1lwu0D-0007O6-6h
        for linux-raid@vger.kernel.org; Fri, 25 Jun 2021 22:08:45 +0000
Date:   Fri, 25 Jun 2021 22:08:45 +0000
From:   Andy Smith <andy@strugglers.net>
To:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Redundant EFI Systemp Partitions (Was Re: How does one enable SCTERC
 on an NVMe drive (and other install questions))
Message-ID: <20210625220845.57wcwz4sppavywf6@bitfolk.com>
Mail-Followup-To: Linux-RAID <linux-raid@vger.kernel.org>
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On Mon, Jun 21, 2021 at 12:00:13AM -0500, Edward Kuns wrote:
> looks like maybe I cannot use the installer to set up RAID mirroring
> for /boot or /boot/efi.  I may have to set that up after the fact.

In November 2020 I had this discussion on debian-user:

    https://www.mail-archive.com/debian-user@lists.debian.org/msg762784.html

The summary was that the ESP is for the firmware and the firmware
doesn't know about MD RAID, so is only ever going to see the member
devices.

You could lie to the firmware and tell it that each MD member device
is an ESP, but it isn't. This will probably work as long as you use
the correct metadata format (so the MD metadata is at the end and
the firmware is fooled that the member device is just a normal
partition). BUT it is in theory possible for the firmware to write
to the ESP and that would cause a broken array when you boot, which
you'd then recover by randomly choosing one of the member devices as
the "correct" one.

Some people (myself included, after discovering all that) decided
that putting ESP on an MD device was too complicated due to these
issues and that it would be better to have one ESP on each bootable
device and be able to boot from any of them. The primary one is
synced to all the others any time there is a system update.

Ubuntu have patched grub to detect multiple ESP and install grub on
all of them.

In theory it would be possible to write an EFI firmware module that
understands MD devices and then you could put the ESP on an MD array
in the same way that grub can boot off of an MD array.

Cheers,
Andy
