Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AADCC54EBE
	for <linux-raid@archiver.kernel.org>; Sun,  8 Jan 2023 22:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbjAHWUe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 Jan 2023 17:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjAHWUc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 Jan 2023 17:20:32 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8559611147
        for <linux-raid@vger.kernel.org>; Sun,  8 Jan 2023 14:20:30 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1pEe1j-0007mK-7t;
        Sun, 08 Jan 2023 22:20:27 +0000
Message-ID: <7ef4bb85-2d0f-8f1a-7fb7-336142acf405@youngman.org.uk>
Date:   Sun, 8 Jan 2023 22:20:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Parity distribution when adding disks to md-raid6
To:     boscabeag <boscabeag@protonmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <A73A8YRNkUS11zoz7eEaNfvnfZqyj6-vP-7mvI6_FFLdSETs_g6CFYgIL_PyV0F8AE6cXMomd7SznnsQDGQqwLuSJFMi8EbxGzxibvYjZ2s=@protonmail.com>
Content-Language: en-GB
From:   anthony <antmbox@youngman.org.uk>
In-Reply-To: <A73A8YRNkUS11zoz7eEaNfvnfZqyj6-vP-7mvI6_FFLdSETs_g6CFYgIL_PyV0F8AE6cXMomd7SznnsQDGQqwLuSJFMi8EbxGzxibvYjZ2s=@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 08/01/2023 20:13, boscabeag wrote:
> I'm replacing the drives in my home NAS and can't fully populate it all at one.  I can start with 4 drives, and create a raid 6 array.  When I add drives #5 and #6, will the parity chunks remain on the first four devices or will the resync process distribute them over the entire array, just like it would if I created the array with all devices?  Is there anything I should do (with mdadm) to an array after adding devices that's not just at the md level not the fs level?

Does that mean your NAS takes six drives in total, and you can only 
replace a couple at a time?

I think you need to give us rather more detail if you want better 
advice, but I'm *GUESSING* you're trying to move from a non-raid setup. 
I'm trying to think of a way that will avoid hammering the disks, but at 
the end of the day if they're newish then it really doesn't matter.

Okay. I'll assume you have two drives, you want to merge them in a raid, 
and you've bought four more drives to make a big raid and double your 
storage.

First things first. Your new four-drive raid-6 will be SMALLER than your 
two original drives combined. If they aren't full, that won't matter, as 
the difference isn't much, but you need to be aware of it.

And if you're going from two non-raided disks, I'd be inclined to go via 
raid 5. it'll avoid hammering the disks quite so much, and you're not 
losing redundancy you didn't have ... just try and make sure you have a 
backup (which you should have, anyway).

Okay. So we create your 4-disk raid - 5 or 6. Once that's done, what I'd 
do is take whichever disk is the fullest, and simply dd it onto the raid 
device. It might be a lot of disk, but it's a straightforward stream and 
shouldn't hammer the system too much. Once complete, your raid partition 
will be a copy of the disk partition.

Now grow the filesystem, and just copy the second disk across. 
Hopefully, you've got a simple clean setup (unlike mine, with hard links 
everywhere...)

Now I guess you're adding the existing disks into the array. Just add 
and resize the array in one hit, upgrading from raid 5 to 6 if 
appropriate at the same time. The rebuild will splurge the data and 
parity across all the drives - that's what raid 5 or 6 is - so that's 
the answer to that question of yours. The reason I suggested starting 
with a raid 5 is the calculation of the first parity is simple, 
calculating the second is more complicated so you've deferred that cost 
until this point.

Lastly, because you've grown the array to 4 data disks, the array size 
is less than the space available. You need to increase the size of the 
array, and then the filesystem (assuming you want to).

Personally, if I was doing this, I'd've stuck lvm on the raid, and then 
kept the two disks as separate lvm partitions. That would mean that I'd 
had to go the raid-5 route, as there just wouldn't be enough space on 
the raid otherwise. And then you've got roughly half your new disk space 
spare to grow your partitions, take snapshots, whatever, all the stuff 
lvm makes possible.

Hopefully this has given you a bunch of ideas. And made it clear why we 
need more detail if you want good advice - pretty much all of this is 
guesswork as to what you're trying to do ...

If you haven't found this already ...
https://raid.wiki.kernel.org/index.php/Linux_Raid
and especially
https://raid.wiki.kernel.org/index.php/Converting_an_existing_system

Cheers,
Wol
