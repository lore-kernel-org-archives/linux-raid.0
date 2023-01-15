Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A92C63797
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 14:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjAOOtH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 09:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbjAOOtA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 09:49:00 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDC810404
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 06:48:59 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nvyhm4f50zXKm;
        Sun, 15 Jan 2023 15:48:56 +0100 (CET)
Message-ID: <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
Date:   Sun, 15 Jan 2023 15:48:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
 <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 15:43 schrieb Pascal Hambourg:
> On 15/01/2023 at 13:13, Reindl Harald wrote:
>>
>> Am 15.01.23 um 13:00 schrieb Pascal Hambourg:
>>> Linux RAID supports TRIM/discard, but what does it do exactly ?
>>> Does it only pass-through TRIM/discard information to the underlying 
>>> devices or can it also store information about which blocks contain 
>>> valid data in the superblock metadata?
>>
>> pass-through TRIM/discard
>>
>> it makes no sense to store that on the RAID layer
> 
> Wouldn't it make sense to:
> - skip the initial sync at array creation
> - only resync valid data areas during array resync
> - reduce wear caused by useless writes on flash drives
> - enable TRIM/discard with parity RAID levels by default without relying 
> on the underlying device capability to return zeroes on read after TRIM
> - ignore mismatches in invalid data areas when scrubbing

it would make sense but it's out of question the way mdadm is 
implemented today - just store the information without a proper usecase 
would make things only worser

the intentional design of mdadm is a pure RAID implementation on the 
device layer with no konwledge of the filesystem on top

everything you listed above has an answer and that's ZFS/BTRFS which has 
RAID-functionality by design as part of the FS and hence knows implcit 
that unused space don#t need to be mirrored

"skip the initial sync at array creation" - surely, would be nice, but 
the design is "we don't know what is stord in thea RAID, our job is that 
in RAID1 all mirros are identical at the phyiscal disk layer"


