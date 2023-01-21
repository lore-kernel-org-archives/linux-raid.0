Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9897AC25B50
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 18:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjAUS5Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 13:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjAUS5Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 13:57:25 -0500
Received: from mallaury.nerim.net (smtp-106-saturday.noc.nerim.net [178.132.17.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5A991E5CF
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 10:57:22 -0800 (PST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 5B312DB17E;
        Sat, 21 Jan 2023 19:57:21 +0100 (CET)
Message-ID: <5dc67a57-1ebb-4ce5-80f3-bdc4f59a9510@plouf.fr.eu.org>
Date:   Sat, 21 Jan 2023 19:57:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
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
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <19a04b8a-c314-becd-f272-1323160f346f@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 21/01/2023 at 19:39, Reindl Harald wrote:
> Am 21.01.23 um 19:32 schrieb Pascal Hambourg:
>> On 21/01/2023 at 16:21, Wols Lists wrote:
>>> Is that one EFI per OS, or multiple identical EFI? :-)
>>
>> Neither. Multiple possibly not identical EFI partitions
> 
> is completly off-topic BTW

Can you elaborate ?

>> Mirroring with one EFI partition per OS does not make much sense.
>> And it would not be universal if it required identical partitions.
> 
> and how do you expect the UEFI smell which one is supposed to be booted 
> from?

Boot* and BootOrder EFI variables exist for a purpose.

> you can't fix the design-errors of UEFI

But you can (and should) deal with them.
