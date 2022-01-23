Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D51C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 23 Jan 2022 00:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiAWAUv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Jan 2022 19:20:51 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:29381 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbiAWAUv (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 22 Jan 2022 19:20:51 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1nBQcj-0000MQ-9k;
        Sun, 23 Jan 2022 00:20:49 +0000
Message-ID: <ef90b493-cc05-e4aa-9ce9-4e029157b239@youngman.org.uk>
Date:   Sun, 23 Jan 2022 00:20:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: hardware recovery and RAID5 services
Content-Language: en-GB
To:     Phil Turmel <philip@turmel.org>,
        Roger Heflin <rogerheflin@gmail.com>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220121164804.GE14596@justpickone.org>
 <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk>
 <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
 <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
 <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
From:   anthony <antmbox@youngman.org.uk>
In-Reply-To: <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks like one of the first things I need to do when my raid testbed is 
up and running, is to set up a disk drive with dm-integrity --no-format, 
and see if I can dd successfully to it.

IFF that works, you'll then be able to just add it straight back in to 
the array, and running an integrity check will trigger a read error on 
anything that couldn't be recovered.

But there's no way I could recommend that at the moment, seeing as I 
have no idea whether or not it will actually work, even though I think 
it should.

Cheers,
Wol

On 22/01/2022 22:23, Phil Turmel wrote:
> Hi David, et al,
> 
> The principle of "My Hard Drive Died" is Scott Moulton, a highly 
> respected member of the forensics and white-hat scene here in the 
> Atlanta Metro Area.
> 
> https://myharddrivedied.com/
> 
> That said, I highly recommend copying the disk showing read errors onto 
> another disk, keeping the log of sectors replaced by zeros. Then 
> performing a file by file backup from the degraded array, using the copy 
> instead of the troubled drive.
> 
> *After* you recover what you can, examine the replaced sector list and 
> back-calculate what files, if any, were affected.  This will give you a 
> limited and less expensive task to pay experts to solve.  Or carry on 
> with whatever you ended up with.  I think your odds are good.
> 
> And yes, the pros are not cheap.
> 
> On 1/22/22 9:23 AM, Roger Heflin wrote:
>>  From the recovery I know about in the last 3 years, it was several
>> thousand US$ per TB for the recovery.
>>
>> On Sat, Jan 22, 2022 at 1:33 AM Wols Lists <antlists@youngman.org.uk> 
>> wrote:
>>>
>>> On 21/01/2022 19:34, Wols Lists wrote:
>>>> On 21/01/2022 19:31, Wols Lists wrote:
>>>>> Secondly, I'm sure I've dealt with these people in the past, although
>>>>> I can't vouch for them ...
>>>>>
>>>>> https://www.vogon-computer-evidence.com/our-story/
>>>>
>>>> OUCH! Having found that page (which is pretty much as I remember the
>>>> company), the rest of the web site looks like a cobweb site. So I don;t
>>>> know what's happened, but it doesn't look promising ...
>>>>
>>> Following up further yes it certainly looks like a cobweb site. The
>>> company was taken over by Ontrack - I've seen a couple of
>>> recommendations for them. But I have to re-iterate I can't vouch for
>>> them, just they are a big professional company that does that sort of 
>>> thing.
> 
> Phil
