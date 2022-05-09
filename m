Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A951C433FE
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 13:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiEINSP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 09:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiEINSL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 09:18:11 -0400
X-Greylist: delayed 6908 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 06:14:16 PDT
Received: from mail-out-auth1.hosts.co.uk (mail-out-auth1.hosts.co.uk [195.7.255.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663222A83EF
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 06:14:16 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1no1Pr-000584-Fr;
        Mon, 09 May 2022 12:19:04 +0100
Message-ID: <6f41c017-8102-cfe6-ad37-e07df3e23cc0@youngman.org.uk>
Date:   Mon, 9 May 2022 12:19:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
Content-Language: en-GB
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, Song Liu <song@kernel.org>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <c2917c23-c218-e600-7e10-31a504c844e2@youngman.org.uk>
 <f3c2ea9a-2dd4-52be-cd3d-a8c994213fd4@linux.dev>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <f3c2ea9a-2dd4-52be-cd3d-a8c994213fd4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/05/2022 11:37, Guoqing Jiang wrote:
> 
> 
> On 5/9/22 5:32 PM, Wols Lists wrote:
>> On 09/05/2022 09:09, Guoqing Jiang wrote:
>>> I can switch back to V2 if you think that is the correct way to do 
>>> though no
>>> one comment about the change in dm-raid.
>>
>> DON'T QUOTE ME ON THIS
>>
>> but it is very confusing, as I believe dm-raid is part of Device 
>> Managment, which is actually nothing to do with md-raid
> 
> 
> No, dm-raid (I mean dm-raid.c here) is a bridge between dm framwork and 
> md raid, which
> makes dm can reuse md raid code to avoid re-implementation raid logic 
> inside dm itself.

Hmm...

Which backs up what I thought - if it's used by the dm people to call 
md-raid, then asking for info/comments about it on the md list is likely 
to get you no-where...

>> (apart from, like many block layer drivers, md-raid uses dm to manage 
>> the device beneath it.)
> 
> The above statement is very confusing.
> 
Yup. I've never understood it. But, from all my time on the list, it is 
noticeable that nobody seems to know or care much about dm, and this is 
simply one more data point that agrees with that impression. If you want 
to know about dm-raid, you probably need to go where the dm people hang out.

Cheers,
Wol
