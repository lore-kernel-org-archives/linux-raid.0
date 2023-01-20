Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA6DC05027
	for <linux-raid@archiver.kernel.org>; Fri, 20 Jan 2023 21:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjATVKM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 16:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjATVKG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 16:10:06 -0500
Received: from smtp-delay1.nerim.net (mailhost-f4-m0.internext.fr [78.40.49.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 890198B32B
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 13:10:02 -0800 (PST)
Received: from mallaury.nerim.net (smtp-105-friday.noc.nerim.net [178.132.17.105])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id DC5CEC81C4
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 22:01:59 +0100 (CET)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 0BDECDB17D;
        Fri, 20 Jan 2023 22:01:48 +0100 (CET)
Message-ID: <3a3d1de2-f02b-cd2a-7dd4-9d269bb0443e@plouf.fr.eu.org>
Date:   Fri, 20 Jan 2023 22:01:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Wol <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>,
        H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
 <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
 <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/01/2023 at 21:26, Wol wrote:
> 
> I think you've just put your finger on it. Multiple EFI partitions is 
> outside the remit of linux

I do not subscribe to this point of view. Distributions used to handle 
multiple boot sectors, why could they not handle multiple EFI partitions 
as well ?

> I really don't think the system manager - be it yast, 
> yum, apt, whatever - is capable of even trying.

yum and apt are package managers, not system managers. FWIW, Ubuntu's 
grub-efi packages can deal with multiple EFI partitions in the same way 
grub-pc can deal with multiple boot sectors.

> At the end of the day, it's down to the user, and if you can shove a 
> quick rsync in the initramfs or boot sequence to sync EFIs, then that's 
> probably the best place. Then it doesn't get missed ...

No, these are not adequate places. Too early or too late. The right 
place is when anything is written to the EFI partition.
