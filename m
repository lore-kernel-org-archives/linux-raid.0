Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2546C433E7
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 16:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92EC20758
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 16:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgIBQcI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 12:32:08 -0400
Received: from hammer.websitemanagers.com.au ([59.100.172.130]:38468 "EHLO
        hammer.websitemanagers.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbgIBQcH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 12:32:07 -0400
Received: (qmail 20184 invoked by uid 1011); 2 Sep 2020 16:32:04 -0000
Received: from 192.168.5.112 by hammer (envelope-from <mailinglists@websitemanagers.com.au>, uid 1008) with qmail-scanner-1.24 
 (clamdscan: 0.102.4/25878. spamassassin: 3.4.2.  
 Clear:RC:1(192.168.5.112):. 
 Processed in 0.100878 secs); 02 Sep 2020 16:32:04 -0000
Received: from unknown (HELO ADAM-MBP.local) (adamg+websitemanagers.com.au@192.168.5.112)
  by 0 with ESMTPA; 2 Sep 2020 16:32:04 -0000
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
 <afb20610-530e-4185-69c3-4ceef939fc6f@websitemanagers.com.au>
 <675330127.983718.1599060311646.JavaMail.zimbra@karlsbakk.net>
From:   Adam Goryachev <mailinglists@websitemanagers.com.au>
Organization: Website Managers
Message-ID: <319708c9-cfda-ca0f-9d68-330cac8b6d7a@websitemanagers.com.au>
Date:   Thu, 3 Sep 2020 02:32:04 +1000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <675330127.983718.1599060311646.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 3/9/20 01:25, Roy Sigurd Karlsbakk wrote:
>>> I'd better want md to stop fixing "somebody else's problem", that is, the disk,
>>> and rather just do its job. As for the case, I have tried to manually read
>>> those sectors named in the badblocks list and they all work. All of them. But
>>> then, there's no fixing, since they are proclaimed dead. So are their siblings'
>>> sectors with the same number, regardless of status.
>> Just because you can read them, doesn't mean you can write them.
>> Clearly, at some point in time, one of your drives failed. You now need
>> to recover from that failed drive in the most sensible way.
>>> If a drive has multiple issues with bad sector, kick it out. It doesn't have
>>> anything to do in the RAID anymore
>> And if a group of 100 sectors are bad on drive 1, and 100 different
>> sectors on drive 2, you want to kick both drives out, and destroy all
>> your data until you can create a new array and restore from backup?
>>
>> OR, just mark those parts of all disks faulty, and at some point in the
>> future, you replace the disks, and then find a way to tell MD that the
>> sectors are working now (and preferably, re-test them before marking
>> them as OK)?
>>
>> BTW, I just found this:
>>
>> https://raid.wiki.kernel.org/index.php/The_Badblocks_controversy
> I linked to that earlier in the thread
>
>> Which suggests that there is indeed a bug which should be hunted and
>> fixed, and that actually the BBL isn't populated via failed writes, it
>> is populated by failed reads while doing a replace/add, AND the failed
>> read is from the source drive AND the parity/mirror drives.
> It is neither hunted down nor fixed. It's the same thing and it has stayed the same for these years.
So what will you do now to change that? Obviously nobody else has had 
enough of a problem with it to be bothered to "hunt it down and fix it". 
Can you help hunt it down at least?
>> Either way, perhaps what is needed (if you are interested) is a
>> repeatable test scenario causing the problem, which could then be used
>> to identify and fix the bug.
> I have tried several things and all show the same. I just don't know how to tell md "this drive's sector X is bad, so flag it so".
>
> Again, this is not the way to walk around a problem. What this does is just hiding real problems and let them grow in generations instead of just flagging a bad drive as bad, since that's the originating problem here.
>
> Vennlig hilsen
>
> roy

Based in the linked page, you would need to do something like this:

1) Create a clean array with correctly working disks

2) Tell the underlying block device to pretend there is a read error on 
a specific sector of one disk

3) Ask MD to replace the "bad" block device with a "good" one

4) See what happens with the BBL

5) Various steps of reading/writing to that specific stripe, and 
document the outcome/behavior

6) Replace another drive, and document the results

Hint: there is a block device that could sit between your actual block 
device and MD, and it can "pretend" there are certain errors. The 
answers here seem to contain relevant information: 
https://stackoverflow.com/questions/1870696/simulate-a-faulty-block-device-with-read-errors

As I said, I suspect that if a reproducible error is found, then it 
should be easier to fix the bug.

OTOH, you could just remove the BBL from your arrays, and ensure you 
create new arrays without the BBL.

Regards,
Adam


