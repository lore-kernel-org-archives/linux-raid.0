Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA35C05027
	for <linux-raid@archiver.kernel.org>; Fri, 20 Jan 2023 23:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjATXdi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 18:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjATXdh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 18:33:37 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676207DFAA
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 15:33:35 -0800 (PST)
Received: from host81-147-105-30.range81-147.btcentralplus.com ([81.147.105.30] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pIxxY-0009SV-8n;
        Fri, 20 Jan 2023 20:26:00 +0000
Message-ID: <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
Date:   Fri, 20 Jan 2023 20:26:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Phil Turmel <philip@turmel.org>, H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
 <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/01/2023 19:27, Pascal Hambourg wrote:
> Why in initramfs-tools ? The initramfs has nothing to do with the 
> bootloader installation nor the EFI partition so there is no need to 
> resync EFI partitions on initramfs update (unless GRUB menu entries or 
> kernel and initramfs images are in the EFI partition, which is not a 
> great idea IMO). IMO the right place would be a hook called after the 
> system configuration manager or the GRUB package runs grub-install, if 
> that exists.

I think you've just put your finger on it. Multiple EFI partitions is 
outside the remit of linux, and having had two os's arguing over which 
was the right EFI, I really don't think the system manager - be it yast, 
yum, apt, whatever - is capable of even trying. With a simple 
configuration you don't have mirrored EFI, some systems have one EFI per 
OS, others have one EFI for several OSes, ...

At the end of the day, it's down to the user, and if you can shove a 
quick rsync in the initramfs or boot sequence to sync EFIs, then that's 
probably the best place. Then it doesn't get missed ...

Cheers,
Wol
