Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36631C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jan 2022 21:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbiARVxz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jan 2022 16:53:55 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:14997 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343750AbiARVxz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 Jan 2022 16:53:55 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1n9uWB-0009cu-4K;
        Tue, 18 Jan 2022 19:51:47 +0000
Message-ID: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
Date:   Tue, 18 Jan 2022 19:51:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-GB
To:     Linux RAID <linux-raid@vger.kernel.org>
From:   anthony <antmbox@youngman.org.uk>
Subject: The mysterious case of the disappearing superblock ...
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

You all know the story of how the cobbler's children are the worst shod, 
I expect :-) Well, the superblock to my raid (containing /home, etc) has 
disappeared, and I don't have a backup ... (well I do but it's now well 
out of date).

So, a new hard drive is on order, for backup ...

Firstly, given that superblocks seem to disappear every now and then, 
does anybody have any ideas for something that might help us track it 
down? The 1.2 superblock is 4K into the device I believe? So if I copy 
the first 8K ( dd if=/dev/sda4 of=sda4.img bs=4K count=2 ) of each 
partition, that might help provide any clues as to what's happened to 
it? What am I looking for? What is the superblock supposed to look like?

Secondly, once I've backed up my partitions, I obviously need to do 
--create --assume-clean ... The only snag is, the array has been 
rebuilt, so I doubt my data offset is the default. The history of the 
array is simple. It's pretty new, so it will have been created with the 
latest mdadm, and was originally a mirror of sda4 and sdb4.

A new drive was added and the array upgraded to raid-5, and I BELIEVE 
the order is sdc4, sda4, sdb1 - sdb1 being the new drive that was added.

Am I safe to assume that sdc4 and sda4 will have the same data offset? 
What is it likely to be? And seeing as it was the last added am I safe 
to assume that sdb1 is the last drive, so all I have to do is see which 
way round the other two should be?

At least the silver lining behind this, is that having been forced to 
recover my own array, I'll understand it much better helping other 
people recover theirs!

Cheers,
Wol
