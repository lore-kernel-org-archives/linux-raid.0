Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6DAC25B50
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 18:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjAUSwU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 13:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjAUSwT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 13:52:19 -0500
Received: from mallaury.nerim.net (smtp-106-saturday.noc.nerim.net [178.132.17.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3472C1D939
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 10:52:18 -0800 (PST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 4E2E5DB17D;
        Sat, 21 Jan 2023 19:52:17 +0100 (CET)
Message-ID: <8a70562d-eadb-bb24-e549-5decc04984d1@plouf.fr.eu.org>
Date:   Sat, 21 Jan 2023 19:52:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
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
 <f8078086-037d-cc54-b7c7-b9ad88255bfc@thelounge.net>
 <6b7f968b-813b-6405-cd71-c103b579012d@plouf.fr.eu.org>
 <d96d7d83-ecf8-50aa-1007-bd0a320d58f3@thelounge.net>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <d96d7d83-ecf8-50aa-1007-bd0a320d58f3@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 21/01/2023 at 17:24, Reindl Harald wrote:
> Am 21.01.23 um 16:17 schrieb Pascal Hambourg:
>> My point was that UEFI did not change the fact that "you cannot have 
>> everything needed for boot on a RAID", so nothing new here.
> 
> useless nitpicking isn't helpful

Barking up the wrong tree isn't useful either. EFI is not the culprit.

>> What is written in the EFI partition on kernel update in Fedora ? In 
>> Debian, the EFI partition is written only on grub package update or 
>> when running grub-install.
> 
> and where do you think is the kernel-selection stored?

I already wrote I don't know anything about Fedora.

> https://fedoraproject.org/wiki/Changes/BootLoaderSpecByDefault

I did not find any information about where the kernel-selection is 
stored in this page.

> [root@srv-rhsoft:~]$ ls /efi/loader/entries/

I guess /efi it the EFI partition mount point. Well then, any system 
tool that populates this directory should be able to manage multiple EFI 
partitions.

>> Not my point. My point is that if secondary EFI partitions are updated 
>> only during the boot sequence then they will be out of sync at the 
>> next boot following an update of the primary EFI partition
> 
> nobody is takling about update it during the boot sequence

Please re-read the thread.
In Message-ID: <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>, 
Wol wrote:
> quick rsync in the initramfs or boot sequence to sync EFIs, then that's 
> probably the best place.

And in Message-ID: <acc6add5-347b-7ecb-f6e9-056d21783984@thelounge.net>, 
after I expressed disagreement, you wrote:
> these ARE adequate places



> 
> * kernel-install generates initrd and boot entries
> * kernel-install needs a drop-in to run a script
>    after it's finished
> * that script can rsync /efi/ to /efi-bkp/ or whereever
>    you mount the ESP on the second drive
> * case closed - the ESP on both drives have the same
>    content and it just works
> 
> for now you need to rsync manually
