Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F17EC433E2
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 19:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9542083B
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 19:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIBTpM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 15:45:12 -0400
Received: from asav21.altibox.net ([109.247.116.8]:59254 "EHLO
        asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBTpK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 15:45:10 -0400
Received: from mx1.thehawken.org (unknown [51.175.209.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asav21.altibox.net (Postfix) with ESMTPS id 70CE780063;
        Wed,  2 Sep 2020 21:45:04 +0200 (CEST)
Subject: Re: Feature request: Remove the badblocks list
To:     Adam Goryachev <mailinglists@websitemanagers.com.au>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>
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
 <319708c9-cfda-ca0f-9d68-330cac8b6d7a@websitemanagers.com.au>
From:   =?UTF-8?Q?H=c3=a5kon_Struijk_Holmen?= <hawken@thehawken.org>
Message-ID: <2ec8980a-0b8c-21e6-4764-37c117eae6c1@thehawken.org>
Date:   Wed, 2 Sep 2020 21:45:02 +0200
MIME-Version: 1.0
In-Reply-To: <319708c9-cfda-ca0f-9d68-330cac8b6d7a@websitemanagers.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=XdKnMrx5 c=1 sm=1 tr=0
        a=PoiGM2p7BgezEa0kfMnBZQ==:117 a=PoiGM2p7BgezEa0kfMnBZQ==:17
        a=IkcTkHD0fZMA:10 a=M51BFTxLslgA:10 a=VwQbUJbxAAAA:8 a=uPZiAMpXAAAA:8
        a=P-ZmTP3SmGiJgFismbkA:9 a=RmwNpGintuZfviI2:21 a=49l4KawB2z3f-e8J:21
        a=QEXdDO2ut3YA:10 a=YQZzFssXFEgA:10 a=AjGcO6oz07-iQ99wixmX:22
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 9/2/20 6:32 PM, Adam Goryachev wrote:
>
> On 3/9/20 01:25, Roy Sigurd Karlsbakk wrote:
>>>> I'd better want md to stop fixing "somebody else's problem", that 
>>>> is, the disk,
>>>> and rather just do its job. As for the case, I have tried to 
>>>> manually read
>>>> those sectors named in the badblocks list and they all work. All of 
>>>> them. But
>>>> then, there's no fixing, since they are proclaimed dead. So are 
>>>> their siblings'
>>>> sectors with the same number, regardless of status.
>>> Just because you can read them, doesn't mean you can write them.
>>> Clearly, at some point in time, one of your drives failed. You now need
>>> to recover from that failed drive in the most sensible way.
>>>> If a drive has multiple issues with bad sector, kick it out. It 
>>>> doesn't have
>>>> anything to do in the RAID anymore
>>> And if a group of 100 sectors are bad on drive 1, and 100 different
>>> sectors on drive 2, you want to kick both drives out, and destroy all
>>> your data until you can create a new array and restore from backup?
>>>
>>> OR, just mark those parts of all disks faulty, and at some point in the
>>> future, you replace the disks, and then find a way to tell MD that the
>>> sectors are working now (and preferably, re-test them before marking
>>> them as OK)?
>>>
>>> BTW, I just found this:
>>>
>>> https://raid.wiki.kernel.org/index.php/The_Badblocks_controversy
>> I linked to that earlier in the thread
>>
>>> Which suggests that there is indeed a bug which should be hunted and
>>> fixed, and that actually the BBL isn't populated via failed writes, it
>>> is populated by failed reads while doing a replace/add, AND the failed
>>> read is from the source drive AND the parity/mirror drives.
>> It is neither hunted down nor fixed. It's the same thing and it has 
>> stayed the same for these years.
> So what will you do now to change that? Obviously nobody else has had 
> enough of a problem with it to be bothered to "hunt it down and fix 
> it". Can you help hunt it down at least?
>>> Either way, perhaps what is needed (if you are interested) is a
>>> repeatable test scenario causing the problem, which could then be used
>>> to identify and fix the bug.
>> I have tried several things and all show the same. I just don't know 
>> how to tell md "this drive's sector X is bad, so flag it so".
>>
>> Again, this is not the way to walk around a problem. What this does 
>> is just hiding real problems and let them grow in generations instead 
>> of just flagging a bad drive as bad, since that's the originating 
>> problem here.
>>
>> Vennlig hilsen
>>
>> roy
>
> Based in the linked page, you would need to do something like this:
>
> 1) Create a clean array with correctly working disks
>
> 2) Tell the underlying block device to pretend there is a read error 
> on a specific sector of one disk
>
> 3) Ask MD to replace the "bad" block device with a "good" one
>
> 4) See what happens with the BBL
>
> 5) Various steps of reading/writing to that specific stripe, and 
> document the outcome/behavior
>
> 6) Replace another drive, and document the results
>
> Hint: there is a block device that could sit between your actual block 
> device and MD, and it can "pretend" there are certain errors. The 
> answers here seem to contain relevant information: 
> https://stackoverflow.com/questions/1870696/simulate-a-faulty-block-device-with-read-errors
>
> As I said, I suspect that if a reproducible error is found, then it 
> should be easier to fix the bug.
>
> OTOH, you could just remove the BBL from your arrays, and ensure you 
> create new arrays without the BBL.
>
> Regards,
> Adam
>
Hi,

I think you may have misunderstood slightly. Bad blocks can get written 
based on failed read requests, which is the case that Roy and I are 
complaining about. Such a read error may just be temporary, and affect 
multiple drives if there is some sort of a controller problem.

I have actually done an experiment, and I would like to explain it in 
terms of your numbered points.


1) A NFS server was set up with a share and some block files were set 
up, approx 100MB in size for each. The NFS server was given a secondary 
IP address for the client, that could be added or removed to simulate a 
passing controller failure. The NFS client mapped up this with a soft 
mount, allowing it to give IO errors after a timeout. The files were 
mapped to loopback blocks and a raid array was created, I think it was 
raid 5. The array was formatted to xfs and filled with data. Caches were 
wiped.

2) The IP was removed to simulate the controller temporarily failing. 
Then I tried reading from the raid array, producing io errors on all the 
drives. The IP was added back in to restore communication, and md took 
the opportunity to write one of the drives full of bad blocks. The rest 
of the block devices were thrown out, maybe for failing to write to the 
bad block list.

3) My attempt wasn't entirely successful, since only one drive got bad 
blocks. I think this was out of luck. In this case md will have enough 
data to repair the error during a drive replacement. Maybe if one of the 
"healthy" ones were removed, then we would see md failing to reconstruct 
data and writing bad blocks to the new device. I didn't carry this out, 
but I understand the algorithm to work like that.


The issue I have is that a temporary read failure can cause blocks to be 
marked with a flag that means "the data here is not the correct data". 
It would be necessary to handle read failures differently to have a 
distinction and be able to retry reading from these types of bad blocks. 
There's just one flag, and it's used if reading fails, if writing fails, 
if the correct data was not found for a new drive and thus the data was 
not initialized...

I've talked to Roy and we will probably try removing the lists, and I 
think it will work. At least partially. For his array, he has been 
replacing some drives from time to time without knowing about the bad 
block lists, and this means that his bad blocks are a combination of 
drives where the data actually is present, and drives where the data was 
never written in the first place. If we remove the lists, then we will 
probably get a mix of uninitialized data and correct data back. I did 
the same to my array, but I did not replace any drives so I was certain 
that I had all the data. My drives actually don't have any bad blocks at 
all, I iterated the lists and read all of the sectors.

I would expect md to state that the array is degraded, send angry emails 
and such, but it seems like you will only know the state of your BBLs if 
you go and check them.


Regards and thanks for understanding,
Håkon
