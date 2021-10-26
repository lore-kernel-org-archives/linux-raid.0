Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0671EC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 09:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF59D61002
	for <linux-raid@archiver.kernel.org>; Tue, 26 Oct 2021 09:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhJZJrj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:47:39 -0400
Received: from smarthost01b.ixn.mail.zen.net.uk ([212.23.1.21]:38686 "EHLO
        smarthost01b.ixn.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230431AbhJZJrh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 26 Oct 2021 05:47:37 -0400
Received: from [82.71.70.4] (helo=aawcs.co.uk)
        by smarthost01b.ixn.mail.zen.net.uk with esmtp (Exim 4.90_1)
        (envelope-from <john@aawcs.co.uk>)
        id 1mfJ16-0003rB-IB
        for linux-raid@vger.kernel.org; Tue, 26 Oct 2021 09:45:12 +0000
Received: from [192.168.1.200] ( [192.168.1.200])
          by aawcs.co.uk with ESMTP (Mailtraq/2.17.7.3560) id AWCS4B7217A9;
          Tue, 26 Oct 2021 10:46:11 +0100
Subject: Re: Missing Superblocks
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <de712291-fa08-b35a-f8fb-6d18b573f3f4@aawcs.co.uk>
 <a5f362c3-122e-d0ac-1234-d4852e43adfa@aawcs.co.uk>
 <CAAMCDee8fEHGMg7NBNzMq7+kbFHo-4DM0D2T=rNezpPZgKabeg@mail.gmail.com>
From:   John Atkins <John@aawcs.co.uk>
Organization: AAW Control Systems
Message-ID: <9d80e924-ae3e-4a04-1d17-65bfc949e276@aawcs.co.uk>
Date:   Tue, 26 Oct 2021 10:45:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDee8fEHGMg7NBNzMq7+kbFHo-4DM0D2T=rNezpPZgKabeg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Hops: 1
X-Originating-smarthost01b-IP: [82.71.70.4]
Feedback-ID: 82.71.70.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for the suggestions.
No partition ever on these disks.
I will try the dd method but as there was never a partition on the drive 
I don't think that will return results.
The busy drive is not part of an active md array nor mounted so still a 
bit bemused by that.
I know the order, after my first few muckups I number them to make sure 
if I have to move them it will work. If I use assume clean, if it does 
not work I can just try another order I assume. I do have a backup but 
14T will take time to replicate.

Email.png

	

*Regards John Atkins*

Senior Systems Support, Installation & Service Engineer

AAW Control Systems Ltd

Mobile: 07780480014

Office: 01635 248589

E-Mail: john@aawcs.co.uk


         
         
         
         

On 26/10/2021 00:16, Roger Heflin wrote:
>  Raw devices or not should not matter, unless you changed in the 
> middle and did not quite do all of it right.
>
> Usually when I find a missing header on disks it is because it really 
> was not where it was thought to be.  I have seen people put on raw 
> disks, later partitioniongin to misplace data--sometimes this 
> overwrites data depending on where the header lives (reboot exposes 
> it), I have seen them re-create a partition with a different starting 
> position and misplace data (the new partition was not used until 
> reboot).  I have also seen people label a partition and then remove 
> the partition and that also misplaces data.  If you are lucky then it 
> is a data misplace from a partition table issue.
>
> If you cannot find the header you might look a bit more carefully.  
> "dd if=devicename bs=1M count=20 | xxd -a | more" and compare the good 
> one to the bad one and see if the header begins at the same location 
> or at a different location.  On my disk with a partition table I get 
> data in the first 4 512byte blocks, and then no data until the start 
> of the actual partition/mdadm component.
>
> I have found LVM headers and other headers and reconstructed the 
> partition table using the above trick (assuming there was a partition 
> table).
>
> It is also possible that the header got overwrote by something.
>
> To use the assume clean you will need to do an mdadm --stop /dev/mdXX 
> device (to undo the busy).
>
> But also note that you must get the order exactly right with the 
> assume clean or it won't work (wrong order means corrupted data).   
> Usually it is suggested to make copies of the disks before attempting it.
>
>
>
>
> On Mon, Oct 25, 2021 at 8:26 AM John Atkins <John@aawcs.co.uk 
> <mailto:John@aawcs.co.uk>> wrote:
>
>     Good-day All
>     I "have" an array RAID6 6drives 1 spare. The OS got corrupted on
>     reboot.
>     On a fresh install the array is non detectable. Investigation
>     shows that
>     out of the 6 active drives only the first one has a valid super block
>     the rest look to be corrupt. My assumption is that this might be
>     down to
>     the fact that I raided on raw drives /dev/sdX and not on partitions
>     /dev/sdX1. Is this recoverable or should I load from a backup?
>     I assumed trying to create using --assume-clean should work but
>     currently the only drive with a super block shows as busy except
>     it is
>     not mounted.
>     Many Thanks
>     John Atkins
>

