Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711AFC004D4
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 12:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjAUMRv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 07:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUMRu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 07:17:50 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC621350E
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 04:17:48 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nzb3Y2KZyzXL7;
        Sat, 21 Jan 2023 13:17:45 +0100 (CET)
Message-ID: <acc6add5-347b-7ecb-f6e9-056d21783984@thelounge.net>
Date:   Sat, 21 Jan 2023 13:17:45 +0100
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <3a3d1de2-f02b-cd2a-7dd4-9d269bb0443e@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 20.01.23 um 22:01 schrieb Pascal Hambourg:
> On 20/01/2023 at 21:26, Wol wrote:
>>
>> I think you've just put your finger on it. Multiple EFI partitions is 
>> outside the remit of linux
> 
> I do not subscribe to this point of view. Distributions used to handle 
> multiple boot sectors, why could they not handle multiple EFI partitions 
> as well ?
> 
>> I really don't think the system manager - be it yast, yum, apt, 
>> whatever - is capable of even trying.
> 
> yum and apt are package managers, not system managers. FWIW, Ubuntu's 
> grub-efi packages can deal with multiple EFI partitions in the same way 
> grub-pc can deal with multiple boot sectors.
> 
>> At the end of the day, it's down to the user, and if you can shove a 
>> quick rsync in the initramfs or boot sequence to sync EFIs, then 
>> that's probably the best place. Then it doesn't get missed ...
> 
> No, these are not adequate places. Too early or too late. The right 
> place is when anything is written to the EFI partition

these ARE adequate places and a "too late" simp,y can't exist - after 
the package transistion /efi/ should be rsynced to /efi-bk/

sadly for noew that's not supported and you have to call your 
"backup-afi.sh" by hand

https://bugzilla.redhat.com/show_bug.cgi?id=2133294
