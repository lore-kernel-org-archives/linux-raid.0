Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43485C27C76
	for <linux-raid@archiver.kernel.org>; Sun, 22 Jan 2023 11:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjAVL3z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Jan 2023 06:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjAVL3y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 Jan 2023 06:29:54 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD7783F3
        for <linux-raid@vger.kernel.org>; Sun, 22 Jan 2023 03:29:54 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4P09xr2QvZzXL7;
        Sun, 22 Jan 2023 12:29:52 +0100 (CET)
Message-ID: <53f24484-6623-da63-be1f-d41ebd1a2a77@thelounge.net>
Date:   Sun, 22 Jan 2023 12:29:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
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
 <8a70562d-eadb-bb24-e549-5decc04984d1@plouf.fr.eu.org>
 <65ce1e60-ebeb-a9ac-b521-52b59a99abb1@thelounge.net>
 <cddb631b-04e6-6615-2299-d4a1a6492a17@plouf.fr.eu.org>
 <86343cc9-fff2-413a-dadc-c322fd2c96fa@thelounge.net>
 <ecae3a57-4034-75f4-0a9f-bb544f293854@plouf.fr.eu.org>
 <2e189f92-6067-2d55-1b86-2143d3183112@thelounge.net>
 <8fcc4d0c-3d0d-c5b3-feeb-6304531623dc@plouf.fr.eu.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <8fcc4d0c-3d0d-c5b3-feeb-6304531623dc@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 22.01.23 um 10:22 schrieb Pascal Hambourg:
> On 22/01/2023 at 00:02, Reindl Harald wrote:
>> Am 21.01.23 um 23:56 schrieb Pascal Hambourg:
>>> On 21/01/2023 at 21:44, Reindl Harald wrote:
>>>> Am 21.01.23 um 21:04 schrieb Pascal Hambourg:
>>>>> On 21/01/2023 at 19:57, Reindl Harald wrote:
>>>>>> Am 21.01.23 um 19:52 schrieb Pascal Hambourg:
>>>>>
>>>>> No, EFI is not the root cause either. The root cause is carelessly 
>>>>> storing stuff in the bootloader area as if it was part of the 
>>>>> standard Linux filesystem. Guess what ? It is not. 
>>>>
>>>> LSB is dead
>>>
>>> LSB has nothing to do with this.
>>
>> fine, so nobody else but you knows what "part of standard Linux
>> filesystem" means
> 
> I mean
> - POSIX-compliant filesystem.

then for the sake of god say what you mean MORON

> A Linux operating system usually expects 
> features such as case-sensitiveness, ownership and permissions, hard 
> links and symlinks, special files... which are not supported by an EFI 
> partition FAT filesystem.

so what (google what that means)

> - A standard Linux system can be installed on top of any block device 
> layer supported by the kernel+initramfs and the boot loader (RAID, LVM, 
> LUKS...). An EFI partition cannot because these are not supported by 
> UEFI firmware.

so what

>>>> initramfs execution is completly irrelevant for the topic
>>>
>>> Why they did you agree that it was a fine place to sync EFI partitions ?
>>
>> i did not
> 
> You did in <acc6add5-347b-7ecb-f6e9-056d21783984@thelounge.net>.

i meant only to agree half of the sentence and told you that already

>>> I'm not talking about that. I'm talking about other boot loader 
>>> updates that may happen independently of kernel updates
>>
>> which is the reason why multi-boot is dead
> 
> I am not talking about multi-boot. I am talking about boot loader 
> components such as GRUB, shim... They get updates too, and then all EFI 
> partitions should be updated

why do you then talk so much nonsense isstead say what you mean?

that's a solved problem by rsync /efi/

can we stop running in circles like a monkey in this idiotic thread? i 
simply have enough of people like you explaining me the world which i 
discovered before you knew what a computer is
