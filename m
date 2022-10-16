Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C610C433FE
	for <linux-raid@archiver.kernel.org>; Sun, 16 Oct 2022 22:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJPWW1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 16 Oct 2022 18:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJPWW0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 16 Oct 2022 18:22:26 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1B3371BC
        for <linux-raid@vger.kernel.org>; Sun, 16 Oct 2022 15:22:21 -0700 (PDT)
Received: from host86-161-232-249.range86-161.btcentralplus.com ([86.161.232.249] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1okC1T-0003tR-8O;
        Sun, 16 Oct 2022 23:22:19 +0100
Message-ID: <499878ba-c52a-0041-e4b1-697bce7c9fba@youngman.org.uk>
Date:   Sun, 16 Oct 2022 23:22:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: Rebuilding mdadm RAID array after OS drive failure
Content-Language: en-GB
To:     Steve Kolk <stevekolk@gmail.com>, linux-raid@vger.kernel.org
References: <CACZftsg4Cg5UM8derE46m2JgHWFAoNYFvDXbFKfoU4Jrbmhx_g@mail.gmail.com>
From:   anthony <antmbox@youngman.org.uk>
In-Reply-To: <CACZftsg4Cg5UM8derE46m2JgHWFAoNYFvDXbFKfoU4Jrbmhx_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16/10/2022 22:38, Steve Kolk wrote:
> I have a system that was running Ubuntu 18.04 server with a 5 drive
> RAID 6 array using mdadm. I had a hard drive failure, but instead of
> the array it was the OS hard drive that completely failed. I also do
> not have access to the original mdadm.conf file.
> 
> In an attempt to get my array back up, I booted Ubuntu 22.04 from a
> USB and tried to assemble and mount the array.  It did not work.
> Trying some diagnostic steps I found online, it seems to be claiming
> that there is no md superblock on any of the drives.

 From this site? https://raid.wiki.kernel.org/index.php/Linux_Raid

Try https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
> 
> I've included the commands I ran and their output below. Does anyone
> have any advice on what next steps I can take? I have no reason to
> think these drives have failed mechanically (much less all of them). I
> also tried with Ubuntu 18.04 and got the same results.
> 
If you've got python 2.7, can you run lsdrv? Hopefully that will give us 
some more clues.

Provided the data itself isn't damaged, you should be able to retrieve 
your array. Read up the section on overlays, that will protect your data 
from being overwritten while you play around trying to recover it.

The other thing I would do here, is five drives is a lot to try and get 
right. I'd pick just three drives, and try to get them to assemble 
correctly (using overlays for safety!). Once you've got three drives to 
give you a functional array, you can then try and get the other two 
correct before the final recovery.

What can you remember about the system? What version of superblock? And 
something I've noticed that seems weird, why do your drives have 
partitions 1 & 9, but not 2-8? That is well odd ... Have you rebuilt the 
array in any way, or is it exactly as originally created? Etc etc the 
more information you can give us the better.

Let us know how you get on with this, and then we'll come back with more.

Cheers,
Wol
