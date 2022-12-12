Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE671C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 12 Dec 2022 07:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiLLHFf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Dec 2022 02:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiLLHFe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Dec 2022 02:05:34 -0500
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0C3F60D9
        for <linux-raid@vger.kernel.org>; Sun, 11 Dec 2022 23:05:32 -0800 (PST)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id B34DE616CA;
        Mon, 12 Dec 2022 18:05:30 +1100 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id 9xwViZEeBFYF; Mon, 12 Dec 2022 18:05:30 +1100 (AEDT)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 85CC761646;
        Mon, 12 Dec 2022 18:05:30 +1100 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 6EE8D680272; Mon, 12 Dec 2022 18:05:30 +1100 (AEDT)
Date:   Mon, 12 Dec 2022 18:05:30 +1100
From:   Chris Dunlop <chris@onthe.net.au>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Is it possible to restart --add?
Message-ID: <20221212070530.GA138951@onthe.net.au>
References: <20221210195945.GA34756@onthe.net.au>
 <d4e4611f-4764-c66a-0bc9-b8dbcbfae39e@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d4e4611f-4764-c66a-0bc9-b8dbcbfae39e@youngman.org.uk>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Dec 11, 2022 at 01:55:54PM +0000, Wols Lists wrote:
> On 10/12/2022 19:59, Chris Dunlop wrote:
>> Hi,
>>
>> When replacing a failed disk with a new one using --add, is it 
>> possible to restart a partially-complete --add, e.g. after a reboot?
>>
>> I have a raid-6 with a failed disk, and used --add to add a new disk 
>> as a replacement. From /proc/mdstat, "finish" told me it would take 
>> around 24 hours to complete the add.
>>
>> The machine was rebooted some hours into the add, and on restart the 
>> md was missing the new disk (and the failed disk). I tried to 
>> --re-add the new disk again, but mdadm told me it's "not possible":
>>
>> mdadm: --re-add for /dev/sdh1 to /dev/md0 is not possible
>>
>> I ended up --add'ing the disk again, so the 24 hours to complete 
>> started again.
>>
>> Is this expected, and/or is there a way to restart the --add rather 
>> than starting from the beginning again?
>
> Raid is supposed to be robust, so this surprises me. When it rebooted 
> it should have known it was part-way through a rebuild. Was it a 
> controlled reboot, or a crash and restart?

Controlled reboot.

> What I would expect is that the array would be rebuilt including sdh1, 
> and the rebuild would just carry on. So I suspect that whatever went 
> wrong, it was a bit further back than that - somehow md forgot that 
> sdh1 was now part of the array.

Yes, I was expecting that the --add would be periodically recording it's 
current "synced to" block or offset so on restart it would be able to pick 
up where it left off (or a little before).

> Weird.

Yup.

Tks,

Chris
