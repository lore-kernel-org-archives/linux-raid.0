Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004D5C25B4E
	for <linux-raid@archiver.kernel.org>; Sun, 22 Jan 2023 11:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjAVLZM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Jan 2023 06:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAVLZL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 Jan 2023 06:25:11 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB7D1C32A
        for <linux-raid@vger.kernel.org>; Sun, 22 Jan 2023 03:25:10 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4P09rN56FBzXL7;
        Sun, 22 Jan 2023 12:25:08 +0100 (CET)
Message-ID: <1dced648-4f45-db7d-8c63-b98f11c01564@thelounge.net>
Date:   Sun, 22 Jan 2023 12:25:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Wols Lists <antlists@youngman.org.uk>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
 <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
 <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
 <3a3d1de2-f02b-cd2a-7dd4-9d269bb0443e@plouf.fr.eu.org>
 <d4988c81-21f5-9b71-18ed-6ce489b28667@youngman.org.uk>
 <5030b2e0-b4af-c55f-b965-9e3aab6e5c39@plouf.fr.eu.org>
 <81f7f74f-259e-35e6-985d-3678e2b3c02e@youngman.org.uk>
 <ea1c9fda-32a2-e19c-5718-c164f0ae3b4f@plouf.fr.eu.org>
 <0a3e3d16-e73b-ce13-2cd4-4234e03af022@youngman.org.uk>
 <c48da91f-122f-b827-471b-4fcace5679c0@plouf.fr.eu.org>
 <19a04b8a-c314-becd-f272-1323160f346f@thelounge.net>
 <5dc67a57-1ebb-4ce5-80f3-bdc4f59a9510@plouf.fr.eu.org>
 <2240c8d8-0ad3-46b3-1166-31ce35f900d9@thelounge.net>
 <c2d7d60b-c21b-5e1b-5721-9362f459e37b@plouf.fr.eu.org>
 <85f4ef15-dab7-5eb4-520c-338c94c9c61d@thelounge.net>
 <88dd4c81-03fe-b4e0-182f-b232592c6068@plouf.fr.eu.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <88dd4c81-03fe-b4e0-182f-b232592c6068@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 22.01.23 um 10:04 schrieb Pascal Hambourg:
> On 21/01/2023 at 23:56, Reindl Harald wrote:
>> Am 21.01.23 um 23:43 schrieb Pascal Hambourg:
>>>
>>> RAID provides redundancy while the system is running 
>>
>> RAID provides redundancy for devices - no matter if something is running
> 
> RAID alone does not provide boot redundancy.
> If a drive fails, the system will continue to run until shutdown. But it 
> won't boot if the boot area was only set up on the failed disk

what's the point of such nonsense-comments?

yes, when i am an idiot an don't run grub2-install on all disks it#s no 
there - but as saif dozens of times: we all know this and it has to be 
only done ONCE per drive

after that RAID ensures (ensured before UEFI) that /boot and everything 
in that filesystem is redundant

>>> For boot redundancy, the boot loader must be installed on each disk
>>
>> so what
> 
> So that the system can still boot after whichever drive failed.

"so what" meant "tell me something we didn't know before you where born"

>>> With EFI boot, it means there must be an EFI partition on each disk. 
>>> But EFI partitions do not need to be identical as long as any of them 
>>> can boot the system
>>
>> so what - the topic is "Transferring an existing system from non-RAID 
>> disks to RAID1 disks in the same computer"
> 
> People who install the system on RAID usually expect boot redundancy

and i explained multiple times how to get that with ESP
