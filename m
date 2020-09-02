Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38038C433E7
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 15:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B01E20773
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 15:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgIBPJ3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:09:29 -0400
Received: from hammer.websitemanagers.com.au ([59.100.172.130]:37942 "EHLO
        hammer.websitemanagers.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727894AbgIBPJJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 11:09:09 -0400
Received: (qmail 25223 invoked by uid 1011); 2 Sep 2020 15:09:07 -0000
Received: from 192.168.5.112 by hammer (envelope-from <mailinglists@websitemanagers.com.au>, uid 1008) with qmail-scanner-1.24 
 (clamdscan: 0.102.4/25878. spamassassin: 3.4.2.  
 Clear:RC:1(192.168.5.112):. 
 Processed in 0.055628 secs); 02 Sep 2020 15:09:07 -0000
Received: from unknown (HELO ADAM-MBP.local) (adamg+websitemanagers.com.au@192.168.5.112)
  by 0 with ESMTPA; 2 Sep 2020 15:09:06 -0000
Subject: Re: Feature request: Remove the badblocks list
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     "David C. Rankin" <drankinatty@suddenlinkmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <75076966.1748398.1597773608869.JavaMail.zimbra@karlsbakk.net>
 <001c5a42-93fd-eddb-ba86-aa3e2695f2a8@thehawken.org>
 <37b43194-f372-dd04-a319-34406f63c5a2@suddenlinkmail.com>
 <51057261.933837.1599053769942.JavaMail.zimbra@karlsbakk.net>
 <8dce17fb-13df-b273-cc3d-b3f71d180354@websitemanagers.com.au>
 <1375662956.965590.1599058237477.JavaMail.zimbra@karlsbakk.net>
From:   Adam Goryachev <mailinglists@websitemanagers.com.au>
Organization: Website Managers
Message-ID: <afb20610-530e-4185-69c3-4ceef939fc6f@websitemanagers.com.au>
Date:   Thu, 3 Sep 2020 01:09:06 +1000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1375662956.965590.1599058237477.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 3/9/20 00:50, Roy Sigurd Karlsbakk wrote:
>> I'm no MD expert, but I there are a couple of things to consider...
>>
>> 1) MD doesn't mark the sector as bad unless we try to write to it, AND
>> the drive replies to say it could not be written. So, in your case, the
>> drive is saying that it doesn't have any "spare" sectors left to
>> re-allocate, we are already passed that point.
>>
>> 2) When MD tries to read, it gets an error, so read from the other
>> mirror, or re-construct from parity/etc, and automatically attempt to
>> write to the sector, see point 1 above for the failure case.
>>
>> So by the time MD gets a write error for a sector, the drive really is
>> bad, and MD can no longer ensure that *this* sector will be able to
>> properly store data again (whatever level of RAID we asked for, that
>> level can't be achieved with one drive faulty). So MD marks it bad, and
>> won't store any user data in that sector in future. As other drives are
>> replaced, we mark the corresponding sector on those drives as also bad,
>> so they also know that no user data should be stored there.
>>
>> Eventually, we replace the faulty disk, and it would probably be safe to
>> store user data in the marked sector (assuming the new drive is not
>> faulty on the same sector, and all other member drives are not faulty on
>> the same sector).
>>
>> So, to "fix" this, we just need a way to tell MD to try and write to all
>> member drives, on all faulty sectors, and if any drive returns fails to
>> write, then keep the sector as marked bad, if *ALL* drives succeed, then
>> remove from the bad blocks list on all members.
>>
>> So why not add this feature to fix the problem, instead of throwing away
>> something that is potentially useful? Perhaps this could be done as part
>> of the "repair" mode, or done during a replace/add (when we reach the
>> "bad" sector, test the new drive, test all existing drives, and then
>> continue with the repair/add.
>>
>> Would that solve the "bug"?
> I'd better want md to stop fixing "somebody else's problem", that is, the disk, and rather just do its job. As for the case, I have tried to manually read those sectors named in the badblocks list and they all work. All of them. But then, there's no fixing, since they are proclaimed dead. So are their siblings' sectors with the same number, regardless of status.
Just because you can read them, doesn't mean you can write them. 
Clearly, at some point in time, one of your drives failed. You now need 
to recover from that failed drive in the most sensible way.
> If a drive has multiple issues with bad sector, kick it out. It doesn't have anything to do in the RAID anymore

And if a group of 100 sectors are bad on drive 1, and 100 different 
sectors on drive 2, you want to kick both drives out, and destroy all 
your data until you can create a new array and restore from backup?

OR, just mark those parts of all disks faulty, and at some point in the 
future, you replace the disks, and then find a way to tell MD that the 
sectors are working now (and preferably, re-test them before marking 
them as OK)?

BTW, I just found this:

https://raid.wiki.kernel.org/index.php/The_Badblocks_controversy

Which suggests that there is indeed a bug which should be hunted and 
fixed, and that actually the BBL isn't populated via failed writes, it 
is populated by failed reads while doing a replace/add, AND the failed 
read is from the source drive AND the parity/mirror drives.

Either way, perhaps what is needed (if you are interested) is a 
repeatable test scenario causing the problem, which could then be used 
to identify and fix the bug.

Regards,
Adam

