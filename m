Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC3FC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 18:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiFXSo6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 14:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiFXSo5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 14:44:57 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3053F62710
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 11:44:56 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id E13AA6A6;
        Fri, 24 Jun 2022 18:44:54 +0000 (UTC)
Date:   Fri, 24 Jun 2022 23:44:53 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Alexander Shenkin <al@shenkin.org>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Upgrading motherboard + CPU
Message-ID: <20220624234453.43cf4c74@nvm>
In-Reply-To: <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
        <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
        <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
        <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
        <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
        <20220624232049.502a541e@nvm>
        <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 24 Jun 2022 11:27:08 -0700
Alexander Shenkin <al@shenkin.org> wrote:

> I have 1 RAID6 (root) and 1 RAID1 (boot) array running across 7 drives 
> in my Ubuntu 20.04 system.  I bought a new motherboard and CPU that I'd 
> like to replace my current ones.  In non-raid systems, I get the sense 
> that it's not a very risky operation.  However, I suspect RAID makes it 
> more tricky.

Luckily with software RAID using mdadm it does not.

> Wondering if anyone can offer any advice here?  Do I have to make sure sata
> cables are plugged into corresponding ports in the new motherboard?

No, the order of cables is unimportant. Just plug everything in, and it should
work.

May have to check in BIOS that it doesn't require a UEFI boot partition, but
allows to boot from a legacy-style bootloader, in settings such as "Launch
CSM: Enabled" and "Boot device control: (UEFI and) Legacy".

-- 
With respect,
Roman
