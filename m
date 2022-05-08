Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA21C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  8 May 2022 22:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiEHWT5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 May 2022 18:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiEHWT4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 May 2022 18:19:56 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A98BBC38
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 15:16:00 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nnpC3-000B5I-43;
        Sun, 08 May 2022 23:15:59 +0100
Message-ID: <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk>
Date:   Sun, 8 May 2022 23:15:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Failed adadm RAID array after aborted Grown operation
Content-Language: en-GB
To:     Bob Brand <brand@wmawater.com.au>, linux-raid@vger.kernel.org
Cc:     Phil Turmel <philip@turmel.org>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au>
 <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk>
 <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

How old is CentOS 7? With that kernel I guess it's quite old?

Try and get a CentOS 8.5 disk. At the end of the day, the version of 
linux doesn't matter. What you need is an up-to-date rescue disk. 
Distro/whatever is unimportant - what IS important is that you are using 
the latest mdadm, and a kernel that matches.

The problem you have sounds like a long-standing but now-fixed bug. An 
original CentOS disk might be okay (with matched kernel and mdadm), but 
almost certainly has what I consider to be a "dodgy" version of mdadm.

If you can afford the downtime, after you've reverted the reshape, I'd 
try starting it again with the rescue disk. It'll probably run fine. Let 
it complete and then your old CentOS 7 will be fine with it.

Cheers,
Wol

On 08/05/2022 23:04, Bob Brand wrote:
> Thank Wol.
> 
> Should I use a CentOS 7 disk or a CentOS disk?
> 
> Thanks
> 
> -----Original Message-----
> From: Wols Lists <antlists@youngman.org.uk>
> Sent: Monday, 9 May 2022 1:32 AM
> To: Bob Brand <brand@wmawater.com.au>; linux-raid@vger.kernel.org
> Cc: Phil Turmel <philip@turmel.org>
> Subject: Re: Failed adadm RAID array after aborted Grown operation
> 
> On 08/05/2022 14:18, Bob Brand wrote:
>> If you’ve stuck with me and read all this way, thank you and I hope
>> you can help me.
> 
> https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> Especially
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
> 
> What you need to do is revert the reshape. I know what may have happened,
> and what bothers me is your kernel version, 3.10.
> 
> The first thing to try is to boot from up-to-date rescue media and see if an
> mdadm --revert works from there. If it does, your Centos should then bring
> everything back no problem.
> 
> (You've currently got what I call a Frankensetup, a very old kernel, a
> pretty new mdadm, and a whole bunch of patches that does who knows what.
> You really need a matching kernel and mdadm, and your frankenkernel won't
> match anything ...)
> 
> Let us know how that goes ...
> 
> Cheers,
> Wol
> 
> 
> 
> CAUTION!!! This E-mail originated from outside of WMA Water. Do not click
> links or open attachments unless you recognize the sender and know the
> content is safe.
> 
> 
