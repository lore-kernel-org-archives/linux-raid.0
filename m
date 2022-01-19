Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F696C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jan 2022 08:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352621AbiASIxD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:53:03 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:10791 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352622AbiASIxB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Jan 2022 03:53:01 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nA6iA-0003k4-9r;
        Wed, 19 Jan 2022 08:52:58 +0000
Message-ID: <cfea15f4-228e-4a38-5567-9b710b6dc5c2@youngman.org.uk>
Date:   Wed, 19 Jan 2022 08:52:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: PANIC OVER! Re: The mysterious case of the disappearing superblock
 ...
Content-Language: en-GB
To:     NeilBrown <neilb@suse.de>, anthony <antmbox@youngman.org.uk>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
 <164254680952.24166.7553126422166310408@noble.neil.brown.name>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <164254680952.24166.7553126422166310408@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18/01/2022 23:00, NeilBrown wrote:
>> Firstly, given that superblocks seem to disappear every now and then,
>> does anybody have any ideas for something that might help us track it
>> down? The 1.2 superblock is 4K into the device I believe? So if I copy
>> the first 8K ( dd if=/dev/sda4 of=sda4.img bs=4K count=2 ) of each
>> partition, that might help provide any clues as to what's happened to
>> it? What am I looking for? What is the superblock supposed to look like?

> Yes, 4K offset.  Yes, that dd command will get what you want it to.
> It hardly matters what the superblock should looks like, because it
> won't be there.  The thing you want to know is: what is there?
> i.e.  you see random bytes and need to guess what they mean, so you can
> guess where they came from.
> Best to post the "od -x" output and crowd-source.

That's exactly what I was thinking. But I was thinking if it had been 
damaged rather than destroyed maybe stuff would have been recoverable.
> 
> Are you sure the partition starts haven't changed? Was the array made of
> whole-devices or of partitions?

That's what I missed. I forgot my array was on top of dm-integrity, so 
although I think of it as sda4, sdb1, sdc4, they each in fact have an 
extra layer between them and the raid.

Dunno what or why, but my systemd service that fires that up failed. 
status tells me it was killed after 2msec.

So if that wasn't running, the integrity devices weren't there, and 
mdadm couldn't start the array.

Oh well, the good thing is that backup drive is on its way. I'm planning 
to put plain lvm on it, and write a bunch of services that create backup 
volumes then do a overwrite-in-place rsync. So as I keep advising 
people, it does an incremental backup, but the COW volumes mean I have 
full backups.

Cheers,
Wol
