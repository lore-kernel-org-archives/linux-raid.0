Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC03C3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 15:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjAOPnC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 10:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjAOPnA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 10:43:00 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A12869B
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 07:42:58 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pH59t-000BIC-4A;
        Sun, 15 Jan 2023 15:42:57 +0000
Message-ID: <68262873-6ceb-f28a-0dae-67d373af7d1f@youngman.org.uk>
Date:   Sun, 15 Jan 2023 15:42:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
 <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
 <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 14:48, Reindl Harald wrote:
> 
> 
> Am 15.01.23 um 15:43 schrieb Pascal Hambourg:
>> On 15/01/2023 at 13:13, Reindl Harald wrote:
>>>
>>> Am 15.01.23 um 13:00 schrieb Pascal Hambourg:
>>>> Linux RAID supports TRIM/discard, but what does it do exactly ?
>>>> Does it only pass-through TRIM/discard information to the underlying 
>>>> devices or can it also store information about which blocks contain 
>>>> valid data in the superblock metadata?
>>>
>>> pass-through TRIM/discard
>>>
>>> it makes no sense to store that on the RAID layer
>>
>> Wouldn't it make sense to:
>> - skip the initial sync at array creation
>> - only resync valid data areas during array resync
>> - reduce wear caused by useless writes on flash drives
>> - enable TRIM/discard with parity RAID levels by default without 
>> relying on the underlying device capability to return zeroes on read 
>> after TRIM
>> - ignore mismatches in invalid data areas when scrubbing
> 
> it would make sense but it's out of question the way mdadm is 
> implemented today - just store the information without a proper usecase 
> would make things only worser
> 
> the intentional design of mdadm is a pure RAID implementation on the 
> device layer with no konwledge of the filesystem on top

And that's the whole point of TRIM. It tells mdadm absolutely nothing 
about the file system above APART FROM which part of the array is in use ...
> 
> everything you listed above has an answer and that's ZFS/BTRFS which has 
> RAID-functionality by design as part of the FS and hence knows implcit 
> that unused space don#t need to be mirrored
> 
> "skip the initial sync at array creation" - surely, would be nice, but 
> the design is "we don't know what is stord in thea RAID, our job is that 
> in RAID1 all mirros are identical at the phyiscal disk layer"
> 
But what we DO know, is that when the array is *created* THERE IS 
NOTHING STORED IN THE ARRAY.

TRIM is the mechanism used for one layer (any layer) to tell the layer 
below what part of the block device is in use. If raid can use TRIM to 
keep track of what blocks carry valid data, and what blocks contain 
garbage, then the raid itself can be much more efficient and pro-active 
at protecting that data.

You come over very much as believing that md-raid *should* *not* be 
improved. Is it really that perfect? Some of us are looking for 
opportunities to improve things, and actively supporting TRIM at the 
raid level is such an obvious advance ...

Whether it's worth the effort is a different question ... :-)

Can I ask a favour. STOP POURING COLD WATER ON OTHER PEOPLES' IDEAS. It 
doesn't achieve anything, and drives people away!

Cheers,
Wol

