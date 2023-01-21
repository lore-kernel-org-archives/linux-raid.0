Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F81EC27C76
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 22:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjAUW4S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 17:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjAUW4R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 17:56:17 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EED25E37
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 14:56:16 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NzsDF0ZpVzXL7;
        Sat, 21 Jan 2023 23:56:08 +0100 (CET)
Message-ID: <85f4ef15-dab7-5eb4-520c-338c94c9c61d@thelounge.net>
Date:   Sat, 21 Jan 2023 23:56:07 +0100
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <c2d7d60b-c21b-5e1b-5721-9362f459e37b@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 21.01.23 um 23:43 schrieb Pascal Hambourg:
> On 21/01/2023 at 20:08, Reindl Harald wrote:
>> Am 21.01.23 um 19:57 schrieb Pascal Hambourg:
>>>> Am 21.01.23 um 19:32 schrieb Pascal Hambourg:
>>>>> On 21/01/2023 at 16:21, Wols Lists wrote:
>>>>>> Is that one EFI per OS, or multiple identical EFI? :-)
>>>>>
>>>>> Neither. Multiple possibly not identical EFI partitions
>>
>> how is that related to RAID at all?
> 
> RAID provides redundancy while the system is running 

RAID provides redundancy for devices - no matter if something is running

> For boot 
> redundancy, the boot loader must be installed on each disk

so what

> With EFI 
> boot, it means there must be an EFI partition on each disk. But EFI 
> partitions do not need to be identical as long as any of them can boot 
> the system

so what - the topic is "Transferring an existing system from non-RAID 
disks to RAID1 disks in the same computer"

anything else for the sake of god belongs to a different topic

the same as for "What does TRIM/discard in RAID do" which is a question 
about the state of play

would you be so kind and stop mixing completly different topics in the 
same thread - that way people who don't give a shit about several topics 
they can simply ignore them



