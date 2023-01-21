Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CB9C004D4
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 14:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjAUOiR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 09:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAUOiQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 09:38:16 -0500
Received: from mallaury.nerim.net (smtp-106-saturday.noc.nerim.net [178.132.17.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED4853B3C5
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 06:38:15 -0800 (PST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id AC0BADB17E;
        Sat, 21 Jan 2023 15:38:14 +0100 (CET)
Message-ID: <e8a44850-66d4-dbd3-ebf1-c1f584767aad@plouf.fr.eu.org>
Date:   Sat, 21 Jan 2023 15:38:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
        Wol <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>,
        H <agents@meddatainc.com>,
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
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <c2d4ca04-6512-0d46-08f7-b11265e00e77@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 21/01/2023 at 15:31, Reindl Harald wrote:
> Am 21.01.23 um 15:15 schrieb Pascal Hambourg:
>> On 21/01/2023 at 13:17, Reindl Harald wrote:
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=2133294
>>
>> Quoting:
>> "with uefi you can no longer have everything needed for boot on a RAID"
>>
>> AFAIK, that was never possible with legacy BIOS boot either. The MBR 
>> and GRUB core image were outside RAID
> 
> yeah, we all know that you need "grub-install /dev/sdx" on each device - 
> that's common knowledge and stuff outside the RAID partitions
> 
> and it's not something which got changed at kernel-updates and so 
> irrelevant

Then what is your point ?
