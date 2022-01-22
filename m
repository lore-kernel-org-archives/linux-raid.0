Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD4CC433F5
	for <linux-raid@archiver.kernel.org>; Sat, 22 Jan 2022 22:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiAVWXF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Jan 2022 17:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiAVWXE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Jan 2022 17:23:04 -0500
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D372C06173B
        for <linux-raid@vger.kernel.org>; Sat, 22 Jan 2022 14:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1LvbfSyJ/4x9/b0K/oZCqnKfJB7dcM1hsq1I0pkA2U0=; b=I3uoIa0xDFuZDP18nN3SJrtSkw
        WpO9I85bd+l+iT6x53uOH9umN2naUbu8CE6gj3931DPBOMXYV8EJ0AJmAr9702lgDX6x8eMabgfmi
        7UmtQ0zPr6y92oTvBZ7qh25l8qXOiHwQii92SurJpaR+LRHasT+9c4K0gHRMOlJY9359DIcn83FkA
        2FptcGPgx+EBGyAm5BKIpzQFw1qmfuFGhM9G5QEv57iS010UFDL5cNM/UpwEZfK01Hm+6VNJJVIo2
        nSG8RfM3itzwCbzLKVH0KJ8VmOHsbFCXRYSQMZ1Yj1gA0ZXJWnq53yc7Tal62hDOyPa3UxmJUIf0B
        hEgAD29g==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1nBOmj-0002wI-Ph; Sat, 22 Jan 2022 22:23:01 +0000
Subject: Re: hardware recovery and RAID5 services
To:     Roger Heflin <rogerheflin@gmail.com>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220121164804.GE14596@justpickone.org>
 <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk>
 <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
 <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
Date:   Sat, 22 Jan 2022 17:23:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi David, et al,

The principle of "My Hard Drive Died" is Scott Moulton, a highly 
respected member of the forensics and white-hat scene here in the 
Atlanta Metro Area.

https://myharddrivedied.com/

That said, I highly recommend copying the disk showing read errors onto 
another disk, keeping the log of sectors replaced by zeros. Then 
performing a file by file backup from the degraded array, using the copy 
instead of the troubled drive.

*After* you recover what you can, examine the replaced sector list and 
back-calculate what files, if any, were affected.  This will give you a 
limited and less expensive task to pay experts to solve.  Or carry on 
with whatever you ended up with.  I think your odds are good.

And yes, the pros are not cheap.

On 1/22/22 9:23 AM, Roger Heflin wrote:
>  From the recovery I know about in the last 3 years, it was several
> thousand US$ per TB for the recovery.
> 
> On Sat, Jan 22, 2022 at 1:33 AM Wols Lists <antlists@youngman.org.uk> wrote:
>>
>> On 21/01/2022 19:34, Wols Lists wrote:
>>> On 21/01/2022 19:31, Wols Lists wrote:
>>>> Secondly, I'm sure I've dealt with these people in the past, although
>>>> I can't vouch for them ...
>>>>
>>>> https://www.vogon-computer-evidence.com/our-story/
>>>
>>> OUCH! Having found that page (which is pretty much as I remember the
>>> company), the rest of the web site looks like a cobweb site. So I don;t
>>> know what's happened, but it doesn't look promising ...
>>>
>> Following up further yes it certainly looks like a cobweb site. The
>> company was taken over by Ontrack - I've seen a couple of
>> recommendations for them. But I have to re-iterate I can't vouch for
>> them, just they are a big professional company that does that sort of thing.

Phil
