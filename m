Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDE0C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 15:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3484610A0
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 15:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242848AbhJ0PyB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Oct 2021 11:54:01 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:18858 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242835AbhJ0PyA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Oct 2021 11:54:00 -0400
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mflD7-0002Nb-C1; Wed, 27 Oct 2021 16:51:30 +0100
Subject: Re: (looking for) more info on parity creation
To:     Marek <mlf.conv@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
References: <CA+sqOsZB7s76CVmOQw6jbG3L9q7FLJ_Lw85QEnYVn7RTr4RNxw@mail.gmail.com>
From:   Wol <antlists@youngman.org.uk>
Message-ID: <a0f411bb-31b0-484c-b405-1e45590be761@youngman.org.uk>
Date:   Wed, 27 Oct 2021 16:51:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CA+sqOsZB7s76CVmOQw6jbG3L9q7FLJ_Lw85QEnYVn7RTr4RNxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 25/10/2021 13:01, Marek wrote:
> Hi all,
> 
> I'm looking for the piece of code inside mdadm source code that
> calculates parity can someone please point me to the part of source
> code which implements parity creation?
> Also is it just a simple XOR as described everywhere:
> eg double word disk1 XOR  double word disk2 XOR double word disk3 =
> double word disk 4
> or is something more complex going on.
> thanks
> 
Parity? Which parity? Yes something more complex is going on ...

I believe you are right with regards to raid-5, but with raid-6 that 
approach doesn't work, it has to be much more complex.

Also, if you're looking in mdadm, you're looking in the wrong place. 
There may be some code to do with parity there, but mdadm basically 
manages WHAT IS SUPPOSED TO HAPPEN.

The actual "make it happen" code is in the md-raid drivers in the kernel 
(not to be confused with the dm-raid code drivers, or the btrfs-raid 
drivers, etc etc).

If you go to the linux-raid website it will hopefully give you more 
information along the lines of what you want. Iirc there is a fairly 
detailed explanation of raid-6 linked to from there ...

https://raid.wiki.kernel.org/index.php/Linux_Raid

Cheers,
Wol
