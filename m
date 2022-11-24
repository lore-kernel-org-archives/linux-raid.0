Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB14C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 24 Nov 2022 21:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiKXVdI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXVdH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Nov 2022 16:33:07 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20CA7720C
        for <linux-raid@vger.kernel.org>; Thu, 24 Nov 2022 13:33:04 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oyJqA-0005Nf-7H;
        Thu, 24 Nov 2022 21:33:02 +0000
Message-ID: <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
Date:   Thu, 24 Nov 2022 21:33:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <20221124211019.GE19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/11/2022 21:10, David T-G wrote:
> How is linear different from RAID0?  I took a quick look but don't quite
> know what I'm reading.  If that's better then, hey, I'd try it (or at
> least learn more).

Linear tacks one drive on to the end of another. Raid-0 stripes across 
all drives. Both effectively combine a bunch of drives into one big drive.

Striped gives you speed, a big file gets spread over all the drives. The 
problem, of course, is that losing one drive can easily trash pretty 
much every big file on the array, irretrievably.

Linear means that much of your array can be recovered if a drive fails. 
But it's no faster than a single drive because pretty much every file is 
stored on just the one drive. And depending on what drive you lose, it 
can wipe your directory structure such that you just end up with a 
massive lost+found directory.

That's why there's raid-10. Note that outside of Linux (and often 
inside) when people say "raid-10" they actually mean "raid 1+0". That's 
two striped raid-0's, mirrored.

Linux raid-10 is different. it means you have at least two copies of 
each stripe, smeared across all the disks.

Either version (10, or 1+0), gives you get the speed of striping, and 
the safety of a mirror. 10, however, can use an odd number of disks, and 
disks of random sizes.

Cheers,
Wol
