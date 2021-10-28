Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC76FC4332F
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 16:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9977660D43
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 16:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhJ1Qow (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Oct 2021 12:44:52 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:29614 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhJ1Qoo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 28 Oct 2021 12:44:44 -0400
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mg8Tl-00072l-8e; Thu, 28 Oct 2021 17:42:13 +0100
Subject: Re: growing a RAID5 array by adding disks later
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20211028133626.GX6557@justpickone.org>
From:   Wol <antlists@youngman.org.uk>
Message-ID: <752f98f7-1a2c-b29c-472a-5322fd37127d@youngman.org.uk>
Date:   Thu, 28 Oct 2021 17:42:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211028133626.GX6557@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/10/2021 14:36, David T-G wrote:
> Hi, all --
> 
> It's time to replace a few 4T disks in our little server.  I don't
> particularly want to go back with more 4T disks (although the same
> model sure are cheap these days! :-) and figure I should put in larger
> drives as I go.  I am then left with weighing simple $/G vs total price;
> bigger drives can be cheaper per volume but of course more overall.
> My first approach is to put newer, larger drives in place and expect to
> grow into the empty space when all of the old ones have been swapped out.
> 
> But ...  If I were to splurge and buy 3ea big drives to replace all of

Does that mean you have three drives currently?

> the space that I have now, how practical is it to grow that RAID5 array
> by adding additional drives later? 

Very. mdadm --add ...

> My eventual goal would be to get
> to 8-10 devices in a RAID6 layout (two "extras"), but of course I can't
> afford that today.  Do I have an easy path to get there in the long run?
> 
> [BTW, can I convert an array from RAID5 to RAID6, too?]
> 
> On the other hand, I do have the empty slots (currently filled with
> scratch drives here and there), so I could both replace my aging drives
> and add more and just grow this array 1) if the growth idea is practical
> and 2) if I don't get to splurge.
> 
Okay, buy your new 8TB drives in pairs (unless you've got a bunch of 
scratch 4TB drives).

Assuming you've got a 3x4TB array this will get you to a 3x8TB in one hit...

mdadm --replace 4TB with 8TB
Twice.

mdadm --create --level=striped 4TB 4TB (to give you an 8TB raid0)

mdadm --replace 4TB with 8TB raid0 mirror

You may then be able move the data off your scratch drives onto the 
array, create another 8TB raid0, and add that for a raid6. You can then 
just add 8TB drives bit by bit.

Read the website - there#s a lot of info there...
https://raid.wiki.kernel.org/index.php/Linux_Raid

Cheers,
Wol
