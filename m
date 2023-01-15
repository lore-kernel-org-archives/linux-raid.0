Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331BAC63797
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 15:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjAOPwY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 10:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjAOPwX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 10:52:23 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4FFF75F
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 07:52:22 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nw05s4B1LzXKm;
        Sun, 15 Jan 2023 16:52:17 +0100 (CET)
Message-ID: <28fe352b-1391-0227-5a1d-a3122c5e2e78@thelounge.net>
Date:   Sun, 15 Jan 2023 16:52:17 +0100
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
 <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
 <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
 <68262873-6ceb-f28a-0dae-67d373af7d1f@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <68262873-6ceb-f28a-0dae-67d373af7d1f@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 16:42 schrieb Wols Lists:
> On 15/01/2023 14:48, Reindl Harald wrote:
>>
>>
>> Am 15.01.23 um 15:43 schrieb Pascal Hambourg:
>>> On 15/01/2023 at 13:13, Reindl Harald wrote:
>>>>
>>>> Am 15.01.23 um 13:00 schrieb Pascal Hambourg:
>>>>> Linux RAID supports TRIM/discard, but what does it do exactly ?
>>>>> Does it only pass-through TRIM/discard information to the 
>>>>> underlying devices or can it also store information about which 
>>>>> blocks contain valid data in the superblock metadata?
>>>>
>>>> pass-through TRIM/discard
>>>>
>>>> it makes no sense to store that on the RAID layer
>>>
>>> Wouldn't it make sense to:
>>> - skip the initial sync at array creation
>>> - only resync valid data areas during array resync
>>> - reduce wear caused by useless writes on flash drives
>>> - enable TRIM/discard with parity RAID levels by default without 
>>> relying on the underlying device capability to return zeroes on read 
>>> after TRIM
>>> - ignore mismatches in invalid data areas when scrubbing
>>
>> it would make sense but it's out of question the way mdadm is 
>> implemented today - just store the information without a proper 
>> usecase would make things only worser
>>
>> the intentional design of mdadm is a pure RAID implementation on the 
>> device layer with no konwledge of the filesystem on top
> 
> And that's the whole point of TRIM. It tells mdadm absolutely nothing 
> about the file system above APART FROM which part of the array is in use 

exactly what i said

>> everything you listed above has an answer and that's ZFS/BTRFS which 
>> has RAID-functionality by design as part of the FS and hence knows 
>> implcit that unused space don#t need to be mirrored
>>
>> "skip the initial sync at array creation" - surely, would be nice, but 
>> the design is "we don't know what is stord in thea RAID, our job is 
>> that in RAID1 all mirros are identical at the phyiscal disk layer"
>>
> But what we DO know, is that when the array is *created* THERE IS 
> NOTHING STORED IN THE ARRAY

but we do not know if the drive is completly empty and would bypass a 
direct compare of A versus B without null it

> TRIM is the mechanism used for one layer (any layer) to tell the layer 
> below what part of the block device is in use. If raid can use TRIM to 
> keep track of what blocks carry valid data, and what blocks contain 
> garbage, then the raid itself can be much more efficient and pro-active 
> at protecting that data.

but the topic is "What DOES TRIM/discard in RAID do"

> You come over very much as believing that md-raid *should* *not* be 
> improved. 

where did i say that?

you came over the same way as i asked why don't work "write-mostly" for 
RAID10 while it does for RAID1 when you want to mix SSD/HDD

and you even came up the first posts like you are a developer while you 
are just a ordianry user like me

> Is it really that perfect? 

did i say that?

> Some of us are looking for 
> opportunities 

look for opportunities in your own threads about that opportunities and 
not in questions about state of play

> to improve things, and actively supporting TRIM at the 
> raid level is such an obvious advance ...

but that is NOT the topic of a question "What DOES TRIM/discard in RAID do"

DOES versus COULD DO

> Whether it's worth the effort is a different question ... :-)

it's an important question because someone has a) to do the work b) god 
beware of errors in that context and c) the world is not SSD only

> Can I ask a favour. STOP POURING COLD WATER ON OTHER PEOPLES' IDEAS. It 
> doesn't achieve anything, and drives people away!

the topic was "oes it only pass-through TRIM/discard information to the 
underlying devices or can it also store information about which blocks 
contain valid data in the superblock metadata"

if you want to discuss something else for the sake of god start your own 
thread and leave me in peace
