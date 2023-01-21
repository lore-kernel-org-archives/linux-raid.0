Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C00C004D4
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 14:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjAUOxE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 09:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjAUOxC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 09:53:02 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7A47EED
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 06:53:01 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NzfVg0xWxzXL7;
        Sat, 21 Jan 2023 15:52:59 +0100 (CET)
Message-ID: <f8078086-037d-cc54-b7c7-b9ad88255bfc@thelounge.net>
Date:   Sat, 21 Jan 2023 15:52:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Wol <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>,
        H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
 <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
 <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
 <3a3d1de2-f02b-cd2a-7dd4-9d269bb0443e@plouf.fr.eu.org>
 <acc6add5-347b-7ecb-f6e9-056d21783984@thelounge.net>
 <23acc8a9-08c1-2e3c-0e98-2915f27d29ea@plouf.fr.eu.org>
 <c2d4ca04-6512-0d46-08f7-b11265e00e77@thelounge.net>
 <e8a44850-66d4-dbd3-ebf1-c1f584767aad@plouf.fr.eu.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <e8a44850-66d4-dbd3-ebf1-c1f584767aad@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 21.01.23 um 15:38 schrieb Pascal Hambourg:
> On 21/01/2023 at 15:31, Reindl Harald wrote:
>> Am 21.01.23 um 15:15 schrieb Pascal Hambourg:
>>> On 21/01/2023 at 13:17, Reindl Harald wrote:
>>>>
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=2133294
>>>
>>> Quoting:
>>> "with uefi you can no longer have everything needed for boot on a RAID"
>>>
>>> AFAIK, that was never possible with legacy BIOS boot either. The MBR 
>>> and GRUB core image were outside RAID
>>
>> yeah, we all know that you need "grub-install /dev/sdx" on each device 
>> - that's common knowledge and stuff outside the RAID partitions
>>
>> and it's not something which got changed at kernel-updates and so 
>> irrelevant
> 
> Then what is your point?

what was your point when we all know that the MBR wanst't part of the 
RAID and frankly wasn't stored inside a partition at all

my point in that bugreport is that i don't want to manually call 
"backup-efi.sh" after kernel updates which are happening often on Fedora

kernel-install.sh is responsible for create the initrd and so on - when 
i can tell that "call /scripts/backup-efi.sh" after you are done my ESP 
partitions on both drives are always in sync

and no the 1:1000000 chance that a crash happens between isn't relevant 
because the whole kenel-install/initrd dance isn't atomic at it's own
