Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39435C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 10 Jan 2022 15:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiAJPLa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Jan 2022 10:11:30 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:42715 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233484AbiAJPLa (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 10 Jan 2022 10:11:30 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1n6vKm-0008Vm-65; Mon, 10 Jan 2022 14:07:41 +0000
Message-ID: <509c1c25-afd0-2a65-c5e9-cc0d980ebb3a@youngman.org.uk>
Date:   Mon, 10 Jan 2022 14:07:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Feature request: Add flag for assuming a new clean drive
 completely dirty when adding to a degraded raid5 array in order to increase
 the speed of the array rebuild
Content-Language: en-GB
To:     =?UTF-8?B?SmFyb23DrXIgQ8OhcMOtaw==?= <jaromir.capik@email.cz>
Cc:     linux-raid@vger.kernel.org
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
 <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
 <KWj.44rc9.53XeO0rrYlI.1Xt3RY@seznam.cz>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <KWj.44rc9.53XeO0rrYlI.1Xt3RY@seznam.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/01/2022 13:38, Jaromír Cápík wrote:
> Nope, I haven't read the code. I only see a low sync speed (fluctuating from 20
> to 80MB/s) whilst the drives can perform much better doing sequential reading
> and writing (250MB/s per drive and up to 600MB/s all 4 drives in total).
> During the sync I hear a high noise caused by heads flying there and back and
> that smells.

Okay, so read performance from the array is worse than you would expect 
from a single drive. And the heads should not be "flying there and back" 
- they should just be streaming data. That's actually worrying - a VERY 
plausible explanation is that your drives are on the verge of failure!!

> The chosen drives have poor seeking performance and small caches and are
> probably unable to reorder the operations to be more sequential. The whole
> solution is 'economic' since the organisation owning the solution is poor and
> cannot afford better hardware.

The drives shouldn't need to reorder the operations - a rebuild is an 
exercise in pure streaming ... unless there are so many badblocks the 
whole drive is a mess ...

> That also means RAID6 is not an option. But we shouldn't search excuses what's
> wrong on the chosen scenario when the code is potentially suboptimal :] We're
> trying to make Linux better, right? :]
> 
> I'm searching for someone, who knows the code well and can confirm my findings
> or who could point me at anything I could try in order to increase the rebuild
> speed. So far I've tried changing the readahead, minimum resync speed, stripe
> cache size, but it increased the resync speed by few percent only.

Actually, you might find (counter-intuitive though it sounds) REDUCING 
the max sync speed might be better ... I'd guess from what you say, 
about 60MB/s.

The other thing is, could you be confusing MB and Mb? Three 250Mb drives 
would peak at about 80MB.
> 
> I believe I would be able to write my own userspace application for rebuilding
> the array offline with much higher speed ... just doing XOR of bytes at the same
> offsets. That would prove the current rebuild strategy is suboptimal.
> 
> Of course it would mean a new code if it doesn't work like suggested and I know
> it could be difficult and requiring a deep knowledge of the linux-raid code that
> unfortunately I don't have.
> 
What make/model are your drives? What does smartdrv say about them? And 
take a look at

https://www.ept.ca/features/everything-need-know-hard-drive-vibration/

The thing that worries me is your reference to repeated seeks. That 
should NOT be happening. Unless of course the system is in heavy use at 
the same time as the rebuild.

Cheers,
Wol
