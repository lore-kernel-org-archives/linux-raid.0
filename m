Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13F0C49EA5
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 14:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 856E961C2F
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 14:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhFZOjD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Jun 2021 10:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZOjD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Jun 2021 10:39:03 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2462AC061574
        for <linux-raid@vger.kernel.org>; Sat, 26 Jun 2021 07:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IsBGiHXsXt08qX+Ne2CpKqoKEK0YtesKLGbmF2sH7qQ=; b=NcR17eSUUOTxTiObcpjUkZhIxw
        ygbMB3aTmaLN20XeBIczsCrQmtooOBEX5EUyNOutmMP0aV6cC0blv84B3MXIPlCRALbyvYxsGDzTz
        XJgwNtRp+MITS9GNj/xfrmYTAP/Na1IxDZZ5aDn60GFUgONr/6P3cK/EKQkgPVyTh73fezWeE2Rgz
        6BBlxmIeYZ81r83Wa79Hqk1U4Cog3CD63Y6lgIutF4fXGS8ZAke9l6yKrbsnczvPXRl5BYUXesQDL
        6auvvdX/Mf6M2JKnKRTLSfQ0cstKVelTIk+W2GRUSLyv/62yYtU4ALVg8C70bu+gxlbN6/3BYOZOG
        jX3eiSow==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lx9QG-0000qp-AW
        for linux-raid@vger.kernel.org; Sat, 26 Jun 2021 14:36:40 +0000
Subject: Re: Redundant EFI Systemp Partitions (Was Re: How does one enable
 SCTERC on an NVMe drive (and other install questions))
To:     Linux-RAID <linux-raid@vger.kernel.org>
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
 <20210625220845.57wcwz4sppavywf6@bitfolk.com>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <afbb6970-72ac-6900-8bf9-ba84bc6f3ffb@turmel.org>
Date:   Sat, 26 Jun 2021 10:36:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210625220845.57wcwz4sppavywf6@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good morning Andy,

On 6/25/21 6:08 PM, Andy Smith wrote:
> Hello,
> 
> On Mon, Jun 21, 2021 at 12:00:13AM -0500, Edward Kuns wrote:
>> looks like maybe I cannot use the installer to set up RAID mirroring
>> for /boot or /boot/efi.  I may have to set that up after the fact.
> 
> In November 2020 I had this discussion on debian-user:
> 
>      https://www.mail-archive.com/debian-user@lists.debian.org/msg762784.html
> 
> The summary was that the ESP is for the firmware and the firmware
> doesn't know about MD RAID, so is only ever going to see the member
> devices.

Indeed.

> You could lie to the firmware and tell it that each MD member device
> is an ESP, but it isn't. This will probably work as long as you use
> the correct metadata format (so the MD metadata is at the end and
> the firmware is fooled that the member device is just a normal
> partition). BUT it is in theory possible for the firmware to write
> to the ESP and that would cause a broken array when you boot, which
> you'd then recover by randomly choosing one of the member devices as
> the "correct" one.

Pretty low risk, I think, but yes.  If you construct the raid with what 
the EFI system thinks as the "first" bootable ESP as member role 0, 
mdadm will sync correctly.  Fragile, but generally works.

> Some people (myself included, after discovering all that) decided
> that putting ESP on an MD device was too complicated due to these
> issues and that it would be better to have one ESP on each bootable
> device and be able to boot from any of them. The primary one is
> synced to all the others any time there is a system update.

I started doing this with my work server.  I wrote a hook script for 
initramfs updates to ensure everything was in place.

> Ubuntu have patched grub to detect multiple ESP and install grub on
> all of them.

Didn't know this.  I will experiment to see if I can retire my hook.

> In theory it would be possible to write an EFI firmware module that
> understands MD devices and then you could put the ESP on an MD array
> in the same way that grub can boot off of an MD array.

Yeah, not holding my breath for this.

> Cheers,
> Andy

Thanks!  Learned something new today.

Phil

