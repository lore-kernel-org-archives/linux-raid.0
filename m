Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9522C433E2
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 14:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AF420767
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 14:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgIBOmy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:42:54 -0400
Received: from hammer.websitemanagers.com.au ([59.100.172.130]:37760 "EHLO
        hammer.websitemanagers.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727943AbgIBOlb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 10:41:31 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2020 10:41:30 EDT
Received: (qmail 13887 invoked by uid 1011); 2 Sep 2020 14:34:31 -0000
Received: from 192.168.5.112 by hammer (envelope-from <mailinglists@websitemanagers.com.au>, uid 1008) with qmail-scanner-1.24 
 (clamdscan: 0.102.4/25878. spamassassin: 3.4.2.  
 Clear:RC:1(192.168.5.112):. 
 Processed in 0.043316 secs); 02 Sep 2020 14:34:31 -0000
Received: from unknown (HELO ADAM-MBP.local) (adamg+websitemanagers.com.au@192.168.5.112)
  by 0 with ESMTPA; 2 Sep 2020 14:34:31 -0000
Subject: Re: Feature request: Remove the badblocks list
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
References: <75076966.1748398.1597773608869.JavaMail.zimbra@karlsbakk.net>
 <001c5a42-93fd-eddb-ba86-aa3e2695f2a8@thehawken.org>
 <37b43194-f372-dd04-a319-34406f63c5a2@suddenlinkmail.com>
 <51057261.933837.1599053769942.JavaMail.zimbra@karlsbakk.net>
From:   Adam Goryachev <mailinglists@websitemanagers.com.au>
Organization: Website Managers
Message-ID: <8dce17fb-13df-b273-cc3d-b3f71d180354@websitemanagers.com.au>
Date:   Thu, 3 Sep 2020 00:34:31 +1000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <51057261.933837.1599053769942.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 2/9/20 23:36, Roy Sigurd Karlsbakk wrote:
> ----- Original Message -----
>> From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
>> To: "Linux Raid" <linux-raid@vger.kernel.org>
>> Sent: Saturday, 22 August, 2020 03:42:40
>> Subject: Re: Feature request: Remove the badblocks list
>> On 8/18/20 4:03 PM, Håkon Struijk Holmen wrote:
>>> Hi,
>>>
>>> Thanks for the CC, I just managed to get myself subscribed to the list :)
>>>
>>> I have gathered some thoughts on the subject as well after reading up on it,
>>> figuring out the actual header format is, and writing a tool [3] to fix my
>>> array...
>>>
>> <snip>
>>> But I have some complaints about the thing..
>> Well,
>>
>>   There is code in all things that can be fixed, but I for one will chime in
>> and say I don't care if a lose a strip or two so long as on a failed disk I
>> pop the new one in and it rebuilds without issue (which it does, even when the
>> disk was replaced due to bad blocks)
>>
>>   So whatever is done, don't fix what isn't broken and introduce more bugs
>> along the way. If this is such an immediate problem, then why are patches
>> being attached to the complaints?
> The problem is that it's already broken. Take a single mirror. One drive experiences a bad sector, fine, you have redundancy, so you read the data from the other drive and md flags the sector as bad. The drive two is replaced, you lose the data. The new drive will get flagged with the same sector number as faulty, since the first drive has it flagged. So you replace the first drive and during resync, it also gets flagged as having a bad sector. And so on.
>
> Modern (that is, disks since 20 years ago or so) reallocate sectors as they wear out. We have redundancy to handle errors, not to pinpoint them on disks and fill up not-so-smart lists with broken sectors that work. If md sees a drive with excessive errors, that drive should be kicked out, marked as dead, but not interfere with the rest of the raid.
>
> Vennlig hilsen
>
> roy

I'm no MD expert, but I there are a couple of things to consider...

1) MD doesn't mark the sector as bad unless we try to write to it, AND 
the drive replies to say it could not be written. So, in your case, the 
drive is saying that it doesn't have any "spare" sectors left to 
re-allocate, we are already passed that point.

2) When MD tries to read, it gets an error, so read from the other 
mirror, or re-construct from parity/etc, and automatically attempt to 
write to the sector, see point 1 above for the failure case.

So by the time MD gets a write error for a sector, the drive really is 
bad, and MD can no longer ensure that *this* sector will be able to 
properly store data again (whatever level of RAID we asked for, that 
level can't be achieved with one drive faulty). So MD marks it bad, and 
won't store any user data in that sector in future. As other drives are 
replaced, we mark the corresponding sector on those drives as also bad, 
so they also know that no user data should be stored there.

Eventually, we replace the faulty disk, and it would probably be safe to 
store user data in the marked sector (assuming the new drive is not 
faulty on the same sector, and all other member drives are not faulty on 
the same sector).

So, to "fix" this, we just need a way to tell MD to try and write to all 
member drives, on all faulty sectors, and if any drive returns fails to 
write, then keep the sector as marked bad, if *ALL* drives succeed, then 
remove from the bad blocks list on all members.

So why not add this feature to fix the problem, instead of throwing away 
something that is potentially useful? Perhaps this could be done as part 
of the "repair" mode, or done during a replace/add (when we reach the 
"bad" sector, test the new drive, test all existing drives, and then 
continue with the repair/add.

Would that solve the "bug"?

PS, As you noted, if MD gets repeated write errors for one drive, then 
it will be kicked out. That value is configurable.

