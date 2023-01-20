Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A449C05027
	for <linux-raid@archiver.kernel.org>; Fri, 20 Jan 2023 19:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjATT2r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 14:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjATT2q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 14:28:46 -0500
Received: from mallaury.nerim.net (smtp-105-friday.noc.nerim.net [178.132.17.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 538103D0B4
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 11:28:14 -0800 (PST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 7BA1CDB17D;
        Fri, 20 Jan 2023 20:27:40 +0100 (CET)
Message-ID: <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
Date:   Fri, 20 Jan 2023 20:27:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     Phil Turmel <philip@turmel.org>, H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
Content-Language: en-US
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/01/2023 at 03:51, Phil Turmel wrote:
> On 1/15/23 06:31, Pascal Hambourg wrote:
>>
>> Create EFI partitions on both new drives. Using RAID1 with metadata 
>> 1.0 (superblock at the end) with EFI partitions is a hack (corruption 
>> may happen if the UEFI firmware or anything outside Linux RAID writes 
>> to any of them).
>> Create the RAID arrays for LVM and /boot.
(...)
> FWIW, except for the raid of the EFI partitions, this is what I would 
> do.

I did not suggest using RAID on the EFI partitions, I warned againt it.

> I recommend *not* using any raid on your EFI partitions.  Make them all 
> separate, so your BIOS can tell that they are distinct filesystems (raid 
> would duplicate the FS UUID/label/CRC).

AFAICS on GPT, EFI boot entries contain only the partition UUID, not the 
filesystem UUID, so duplicate filesystem UUIDs should not harm.

> Use a hook in initramfs-tools to make /boot/efi[2..N] match /boot/efi 
> whenever kernels get installed/modified.

Why in initramfs-tools ? The initramfs has nothing to do with the 
bootloader installation nor the EFI partition so there is no need to 
resync EFI partitions on initramfs update (unless GRUB menu entries or 
kernel and initramfs images are in the EFI partition, which is not a 
great idea IMO). IMO the right place would be a hook called after the 
system configuration manager or the GRUB package runs grub-install, if 
that exists.
