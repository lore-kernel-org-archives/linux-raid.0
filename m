Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA418C004D4
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 14:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjAUObm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 09:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjAUObl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 09:31:41 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BADB39CE1
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 06:31:37 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nzf1w06pwzXL7;
        Sat, 21 Jan 2023 15:31:32 +0100 (CET)
Message-ID: <c2d4ca04-6512-0d46-08f7-b11265e00e77@thelounge.net>
Date:   Sat, 21 Jan 2023 15:31:31 +0100
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <23acc8a9-08c1-2e3c-0e98-2915f27d29ea@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 21.01.23 um 15:15 schrieb Pascal Hambourg:
> On 21/01/2023 at 13:17, Reindl Harald wrote:
>> Am 20.01.23 um 22:01 schrieb Pascal Hambourg:
>>> On 20/01/2023 at 21:26, Wol wrote:
>>>>
>>>> if you can shove a quick rsync in the initramfs or boot sequence to 
>>>> sync EFIs, then that's probably the best place. Then it doesn't get 
>>>> missed ...
>>>
>>> No, these are not adequate places. Too early or too late. The right 
>>> place is when anything is written to the EFI partition
>>
>> these ARE adequate places and a "too late" simp,y can't exist - after 
>> the package transistion /efi/ should be rsynced to /efi-bk/
> 
> Using only Debian-based distributions and GRUB, I confess that I know 
> very little about other distributions and boot loaders such as Red Hat 
> and systemd-boot. In Debian, package upgrades do not happen during the 
> boot sequence, so waiting for the next boot to sync EFI partitions 
> implies that they will be out of sync when the boot loader is run at the 
> next boot, possibly breaking the boot sequence.
> 
>> https://bugzilla.redhat.com/show_bug.cgi?id=2133294
> 
> Quoting:
> "with uefi you can no longer have everything needed for boot on a RAID"
> 
> AFAIK, that was never possible with legacy BIOS boot either. The MBR and 
> GRUB core image were outside RAID

yeah, we all know that you need "grub-install /dev/sdx" on each device - 
that's common knowledge and stuff outside the RAID partitions

and it's not something which got changed at kernel-updates and so irrelevant
