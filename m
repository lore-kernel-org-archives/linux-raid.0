Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1A4C004D4
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 16:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjAUQYr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 11:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjAUQYq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 11:24:46 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E50252BF
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 08:24:39 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NzhXN4ptTzXL7;
        Sat, 21 Jan 2023 17:24:31 +0100 (CET)
Message-ID: <d96d7d83-ecf8-50aa-1007-bd0a320d58f3@thelounge.net>
Date:   Sat, 21 Jan 2023 17:24:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <6b7f968b-813b-6405-cd71-c103b579012d@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 21.01.23 um 16:17 schrieb Pascal Hambourg:
> My point was that UEFI did not change the fact that "you cannot have 
> everything needed for boot on a RAID", so nothing new here.

useless nitpicking isn't helpful

>> my point in that bugreport is that i don't want to manually call 
>> "backup-efi.sh" after kernel updates which are happening often on Fedora
>>
>> kernel-install.sh is responsible for create the initrd and so on - 
>> when i can tell that "call /scripts/backup-efi.sh" after you are done 
>> my ESP partitions on both drives are always in sync
> 
> What is written in the EFI partition on kernel update in Fedora ? In 
> Debian, the EFI partition is written only on grub package update or when 
> running grub-install.

and where do you think is the kernel-selection stored?

https://fedoraproject.org/wiki/Changes/BootLoaderSpecByDefault

[root@srv-rhsoft:~]$ ls /efi/loader/entries/
insgesamt 16K
-rwxr-xr-x 1 root root 585 2023-01-15 12:46 
3871a85f73dce2f522a1a97b00001bf2-6.1.6-100.fc36.x86_64.conf
-rwxr-xr-x 1 root root 651 2023-01-19 00:30 
3871a85f73dce2f522a1a97b00001bf2-6.1.7-100.fc36.x86_64.conf

>> and no the 1:1000000 chance that a crash happens between isn't 
>> relevant because the whole kenel-install/initrd dance isn't atomic at 
>> it's own
> 
> Not my point. My point is that if secondary EFI partitions are updated 
> only during the boot sequence then they will be out of sync at the next 
> boot following an update of the primary EFI partition

nobody is takling about update it during the boot sequence

* kernel-install generates initrd and boot entries
* kernel-install needs a drop-in to run a script
   after it's finished
* that script can rsync /efi/ to /efi-bkp/ or whereever
   you mount the ESP on the second drive
* case closed - the ESP on both drives have the same
   content and it just works

for now you need to rsync manually
