Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B91DC7619A
	for <linux-raid@archiver.kernel.org>; Wed, 12 Apr 2023 10:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjDLKQZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Apr 2023 06:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDLKQY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Apr 2023 06:16:24 -0400
Received: from itrosinen.de (itrosinen.de [185.13.148.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B46F2D57
        for <linux-raid@vger.kernel.org>; Wed, 12 Apr 2023 03:16:23 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by itrosinen.de (Postfix) with ESMTP id 7DD484E5F9;
        Wed, 12 Apr 2023 12:16:21 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at itrosinen.de
Received: from itrosinen.de ([127.0.0.1])
        by localhost (itrosinen.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 81TcHipHR65l; Wed, 12 Apr 2023 12:16:20 +0200 (CEST)
Received: from [10.10.10.42] (a89-182-79-183.net-htp.de [89.182.79.183])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: moritz)
        by itrosinen.de (Postfix) with ESMTPSA id 6AE3E4296D;
        Wed, 12 Apr 2023 12:16:20 +0200 (CEST)
Message-ID: <7ae36a36-05ce-0ae8-25c0-7757b9f0f62e@itrosinen.de>
Date:   Wed, 12 Apr 2023 12:15:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Recover data from accidentally created raid5 over raid1
To:     Phil Turmel <philip@turmel.org>, Wol <antlists@youngman.org.uk>,
        John Stoffel <john@stoffel.org>,
        Moritz Rosin <moritz.rosin@itrosinen.de>
Cc:     linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home>
 <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
 <83e691b8-4127-4691-da03-3c43d50f7a5c@turmel.org>
From:   Moritz Rosin <moritz@itrosinen.de>
In-Reply-To: <83e691b8-4127-4691-da03-3c43d50f7a5c@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Phil, et.al.,

first of all, thank y'all so much for your thoughts and answers.
I am going to add as much information as possible.

Am 12.04.2023 um 02:26 schrieb Phil Turmel:
> Hi Moritz, et al,
>
> On 4/11/23 20:18, Wol wrote:
>> On 11/04/2023 20:47, John Stoffel wrote:
>>>>>>>> "Moritz" == Moritz Rosin <moritz.rosin@itrosinen.de> writes:
>>>
>>>> Hey there,
>>>> unfortunately I have to admit, that I learned my lesson the hard way
>>>> dealing with software raids.
>>>
>>>> I had a raid1 running reliable over month using two 4TB HDDs.
>>>> Since I ran short on free space I tried to convert the raid1 to a 
>>>> raid5
>>>> in-place (with the plan to add the 3rd HDD after converting).
>>>> That's where my incredibly stupid mistake kicked in.
>>>
>>>> I followed an internet tutorial that told me to do:
>>>> mdadm --create /dev/md0 --level=5 --raid-devices=2 /dev/sdX1 /dev/sdY1
>
> Ewww.
>
>>> Please share the link to the tutorial so we can maybe shame that
>>> person into fixing it.  Or removing it.
I followed this tutorial, but found similar suggesting to use "mdadm -- 
create" -> 
https://dev.to/csgeek/converting-raid-1-to-raid-5-on-linux-file-systems-k73
>>>
>>
>> See below. There's no reason why it shouldn't work, PROVIDED nothing 
>> has happened to the mirror since you created it.
>>>
>>>> I learned that I re-created a raid5 array instead of converting the
>>>> raid1 :-(
>
> Indeed.  It would have sync'd every other chunk in opposite directions 
> to place "parity" in the right rotation, but otherwise equivalent to a 
> mirror.
>
>>> Yeah, I think you're out of luck here. What kind of filesystem did
>>> you have on your setup?  Were you using MD -> LVM -> filesystem stack?
>>> Or just a raw filesystem on top of the /dev/md?  device?
>>
>> I dunno. A two-disk raid-5 is the same as a 2-disk mirror. That 
>> raid-5 MAY just start and run and you'll be okay. You can try 
>> mounting it read-only and see what happens ...
>
> The odds of matching offsets depends entirely on how old the original 
> raid1 was.
The original raid1 was about 2 years old.
I was using ext4 directly ontop of the array.
>
>
>>>> Is there any chance to un-do the conversion or restore the data?
>>>> Has the process of creation really overwritten data or is there
>>>> anythins left on the disk itself that can be rescued?
>>>
>> If the conversion has overwritten the data, it will merely have 
>> overwritten one copy of the data with the other.
>
> Concur.
>
>>> If you have any information on your setup before you did this, then
>>> you might be ok, but honestly, I think you're toast.
>>>
>> It might be a bit of a forensic job, but no I don't think so. Do you 
>> have that third 4TB HDD? If so, MAKE A BACKUP of one of the drives. 
>> That way, you'll have three copies to play with to try and recover 
>> the data.
>
> This.
>
>> As John says, please give us all the information you can. If you've 
>> just put a file system on top of the array, you should now have three 
>> copies of the filesystem to try and recover. I can't help any further 
>> here. but all you have to do is track down the start of said 
>> filesystem, work out where you tell linux to start a partition so it 
>> correctly contains the filesystem, and then mount said partition. 
>> Your data should all be there.
>
> The trick will be to determine the offset.  Please share as much 
> information as possible as to the layering of the original setup, 
> preferable with the fstab contents if available.
Unfortunately I have no output (e.g. of fdisk -l) _bevore_ converting 
the array. What I found in the syslogs is pasted here: 
https://pastebin.com/iktUtYyt
Output of lsblk: https://pastebin.com/LNyUizGq
Output of fdisk -l (after conversion): https://pastebin.com/LH6ngUjc -- 
as you can see there is no partition table exitent for "md0"
Output of "mdadm --detail": https://pastebin.com/vYhjphKY
>
>> Actually, you might be better off not copying onto drive 3. If you 
>> can work out where your filesystem partition should start, create a 
>> partition on drive 3 and copy the filesystem contents into said 
>> partition.
>
> Or overlays with dmsetup.
>
>> I've cc'd a couple of people I hope can help, but basically, you need 
>> to find out where in the raid array your data has been put, and then 
>> work out how to access it. Your data SHOULD be recoverable, but 
>> you've got some detective work ahead of you.
>
> Your odds are decent.  Again, share all the info you can.
Is there anything else I can provide?
What is a good point to start the detective work?
>
>
>>
>> Cheers,
>> Wol
>
> Phil
Thanks
Moritz
