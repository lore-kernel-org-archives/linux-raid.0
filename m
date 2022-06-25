Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB52C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 08:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiFYI0o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 04:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiFYI0n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 04:26:43 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5018B3137E
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 01:26:41 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o500O-0001Iq-CJ;
        Sat, 25 Jun 2022 08:14:57 +0100
Message-ID: <d912cd74-7140-c440-f3e2-1aad3be83464@youngman.org.uk>
Date:   Sat, 25 Jun 2022 08:14:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-GB
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Alexander Shenkin <al@shenkin.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
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
 <20220625030833.3398d8a4@nvm>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20220625030833.3398d8a4@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/06/2022 23:08, Roman Mamedov wrote:
> On Fri, 24 Jun 2022 23:00:02 +0100
> Wol <antlists@youngman.org.uk> wrote:
> 
>> So your boot device is currently in physical connector 1 on the mobo. If
>> you move it across, you need to make sure it stays in physical position
>> 1, otherwise the mobo will try to boot off whatever disk is in position
>> 1, and there won't be a boot system to boot off!
> 
> Using RAID1 across all disks with metadata 0.90 for /boot makes sure the BIOS
> can boot no matter which disk it tries first.
> 
> In fact it could be with recent grub the "0.90" part is not even required
> anymore.
> 
> Just make sure to "grub-install /dev/sdX" at least once to all of them.
> 
Don't use 0.9, use 1.0.

Both of these put the superblock at the end, so the start of the array 
on disk is also the start of the data area. Which means you can bypass 
the raid (normally a bad idea, but here you need it).

Thing is, v0.x is deprecated, if it breaks it won't be fixed. v1.x is 
supported, all the x indicates is the location of the superblock, it's 
identical across all 1.x arrays.

1.0 is at the end, not necessarily a good idea. To be avoided where 
possible.

1.1 is at the start. Where any problems with a rogue partitioner will 
trample it. To be avoided.

1.2 leaves a 4K scratch space and puts the superblock after that. So it 
will survive most damage to the start of a partition. Recommended.

Cheers,
Wol
