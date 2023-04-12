Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB47C76196
	for <linux-raid@archiver.kernel.org>; Wed, 12 Apr 2023 00:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjDLASB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDLASA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Apr 2023 20:18:00 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48D112B
        for <linux-raid@vger.kernel.org>; Tue, 11 Apr 2023 17:17:57 -0700 (PDT)
Received: from host86-156-145-149.range86-156.btcentralplus.com ([86.156.145.149] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pmOBP-00013d-9C;
        Wed, 12 Apr 2023 01:17:56 +0100
Message-ID: <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
Date:   Wed, 12 Apr 2023 01:18:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Recover data from accidentally created raid5 over raid1
To:     John Stoffel <john@stoffel.org>,
        Moritz Rosin <moritz.rosin@itrosinen.de>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <25653.47458.489415.933722@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/04/2023 20:47, John Stoffel wrote:
>>>>>> "Moritz" == Moritz Rosin <moritz.rosin@itrosinen.de> writes:
> 
>> Hey there,
>> unfortunately I have to admit, that I learned my lesson the hard way
>> dealing with software raids.
> 
>> I had a raid1 running reliable over month using two 4TB HDDs.
>> Since I ran short on free space I tried to convert the raid1 to a raid5
>> in-place (with the plan to add the 3rd HDD after converting).
>> That's where my incredibly stupid mistake kicked in.
> 
>> I followed an internet tutorial that told me to do:
>> mdadm --create /dev/md0 --level=5 --raid-devices=2 /dev/sdX1 /dev/sdY1
> 
> Please share the link to the tutorial so we can maybe shame that
> person into fixing it.  Or removing it.

See below. There's no reason why it shouldn't work, PROVIDED nothing has 
happened to the mirror since you created it.
> 
>> I learned that I re-created a raid5 array instead of converting the
>> raid1 :-(
> 
> Yeah, I think you're out of luck here.  What kind of filesystem did
> you have on your setup?  Were you using MD -> LVM -> filesystem stack?
> Or just a raw filesystem on top of the /dev/md?  device?

I dunno. A two-disk raid-5 is the same as a 2-disk mirror. That raid-5 
MAY just start and run and you'll be okay. You can try mounting it 
read-only and see what happens ...
> 
>> Is there any chance to un-do the conversion or restore the data?
>> Has the process of creation really overwritten data or is there
>> anythins left on the disk itself that can be rescued?
> 
If the conversion has overwritten the data, it will merely have 
overwritten one copy of the data with the other.

> If you have any information on your setup before you did this, then
> you might be ok, but honestly, I think you're toast.
> 
It might be a bit of a forensic job, but no I don't think so. Do you 
have that third 4TB HDD? If so, MAKE A BACKUP of one of the drives. That 
way, you'll have three copies to play with to try and recover the data.

As John says, please give us all the information you can. If you've just 
put a file system on top of the array, you should now have three copies 
of the filesystem to try and recover. I can't help any further here. but 
all you have to do is track down the start of said filesystem, work out 
where you tell linux to start a partition so it correctly contains the 
filesystem, and then mount said partition. Your data should all be there.

Actually, you might be better off not copying onto drive 3. If you can 
work out where your filesystem partition should start, create a 
partition on drive 3 and copy the filesystem contents into said partition.

I've cc'd a couple of people I hope can help, but basically, you need to 
find out where in the raid array your data has been put, and then work 
out how to access it. Your data SHOULD be recoverable, but you've got 
some detective work ahead of you.

Cheers,
Wol
