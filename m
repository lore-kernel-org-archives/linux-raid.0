Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B77C3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 14:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjAOOBw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 09:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjAOOBu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 09:01:50 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9175F113D1
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 06:01:49 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NvxfM4SrMzXKm;
        Sun, 15 Jan 2023 15:01:47 +0100 (CET)
Message-ID: <e8fbf250-8960-db86-3935-5c6c01d60aa2@thelounge.net>
Date:   Sun, 15 Jan 2023 15:01:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
 <e89b018d-e36f-2a62-0bff-4e1f62361283@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <e89b018d-e36f-2a62-0bff-4e1f62361283@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 14:58 schrieb Wols Lists:
> On 15/01/2023 12:13, Reindl Harald wrote:
>> Am 15.01.23 um 13:00 schrieb Pascal Hambourg:
>>> Linux RAID supports TRIM/discard, but what does it do exactly ?
>>> Does it only pass-through TRIM/discard information to the underlying 
>>> devices or can it also store information about which blocks contain 
>>> valid data in the superblock metadata?
>>
>> pass-through TRIM/discard
>>
>> it makes no sense to store that on the RAID layer - if someone is th 
>> eposition to store the information to reduce the fstrim load after a 
>> reboot it's the filesystem on-top
> 
> It makes EVERY sense to store it in the raid layer when you're doing a 
> rebuild.

in theory - but that's not the job of fstrim right now

> I would like to store it there for that exact reason - if you've lost a 
> drive and are in a recovery situation, then you can ignore parts of the 
> drive that don't contain filesystem data, because TRIM has told you they 
> don't.

different story and the main difference between BTRFS/ZFS RAID and mdadm

> afaik, however, nobody has got round to coding that, because it's a lot 
> of work and probably not financially worth doing. If someone wants to do 
> it for the love of it, great!

yeah, and since it has no usecase right now what sense would it make to 
store useless metadata in the superblock and how much space do the 
superblock have to begin with

