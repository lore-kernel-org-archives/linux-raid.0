Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F6CC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 22:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiFXWIl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 18:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiFXWIk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 18:08:40 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B6C87D4C
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 15:08:38 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 44DEE5C6;
        Fri, 24 Jun 2022 22:08:34 +0000 (UTC)
Date:   Sat, 25 Jun 2022 03:08:33 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Wol <antlists@youngman.org.uk>
Cc:     Alexander Shenkin <al@shenkin.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Upgrading motherboard + CPU
Message-ID: <20220625030833.3398d8a4@nvm>
In-Reply-To: <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
        <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
        <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
        <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
        <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
        <20220624232049.502a541e@nvm>
        <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
        <20220624234453.43cf4c74@nvm>
        <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
        <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
        <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
        <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 24 Jun 2022 23:00:02 +0100
Wol <antlists@youngman.org.uk> wrote:

> So your boot device is currently in physical connector 1 on the mobo. If 
> you move it across, you need to make sure it stays in physical position 
> 1, otherwise the mobo will try to boot off whatever disk is in position 
> 1, and there won't be a boot system to boot off!

Using RAID1 across all disks with metadata 0.90 for /boot makes sure the BIOS
can boot no matter which disk it tries first.

In fact it could be with recent grub the "0.90" part is not even required
anymore.

Just make sure to "grub-install /dev/sdX" at least once to all of them.

-- 
With respect,
Roman
