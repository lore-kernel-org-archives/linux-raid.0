Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F60C004D4
	for <linux-raid@archiver.kernel.org>; Fri, 20 Jan 2023 02:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjATC6g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 21:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjATC6f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 21:58:35 -0500
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F05A59D0
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 18:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P9C21OWwtcXow7rFt4uZknHc835fHfInJvd/XRZKD+8=; b=pp5zL+hDDrRMGGiKhSWmSKNnw+
        XN6U3m84MfxYuVvnjlM/UiGoUOnhb5JWF14rfLHN1/y8L1wzi6Wfr6zU9PjUUdqHEcIW3yaXNjau/
        8yqsEYbSCLSUexYGWpNCtvh8NspFxkCyHVSYpH6RCv1V9CB7lsxKXlJOqvlPdelR/9UTmGeRgdday
        m8gn2X+M1n+HTyI0mM+FjSNWc7Z6IHNMBdAYUHz43bSEHaEo4Yj/Z1O04DCoPjBGpGdcS9H4VC3fN
        RiwLU1gnOTCQInRXfgvftbOpzM3lM58LJmfKI6q0udIQT3qwvvjeVVju16evuJjQ79dIuqHqhMEjw
        rCYXlW6A==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1pIhSB-0002Pb-47; Fri, 20 Jan 2023 02:48:31 +0000
Message-ID: <5d2a537e-79bf-18df-6288-cc3a54834147@turmel.org>
Date:   Thu, 19 Jan 2023 21:48:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     Wols Lists <antlists@youngman.org.uk>,
        Reindl Harald <h.reindl@thelounge.net>,
        H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <37a150cb-286b-4137-bb72-08e2de21c851@youngman.org.uk>
 <9aab4088-3ba3-3c7c-4254-a0d829b06066@thelounge.net>
 <d9a4dea4-c15d-453d-9a60-4694e31147b1@youngman.org.uk>
Content-Language: en-US
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <d9a4dea4-c15d-453d-9a60-4694e31147b1@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/15/23 04:20, Wols Lists wrote:

> IF YOU CAN GUARANTEE that /boot/efi is only ever modified inside linux, 
> then raid it. Why not? Personally, I'm not sure that guarantee holds.

Your EFI bios can write to these partitions, too, under operator control.

> If you do raid it, then you MUST use the 1.0 superblock, otherwise it 
> will be inaccessible outside of linux. Seeing as the system needs it 
> before linux boots, that's your classic catch-22.

I recommend *not* using any raid on your EFI partitions.  Make them all 
separate, so your BIOS can tell that they are distinct filesystems (raid 
would duplicate the FS UUID/label/CRC).

When separate, you can use efibootmgr to make the extra one(s) fallback 
boot devices.

Use a hook in initramfs-tools to make /boot/efi[2..N] match /boot/efi 
whenever kernels get installed/modified.

Phil
