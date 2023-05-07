Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAE1C77B7C
	for <linux-raid@archiver.kernel.org>; Sun,  7 May 2023 21:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjEGVRm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 May 2023 17:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjEGVRl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 7 May 2023 17:17:41 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D8C198B
        for <linux-raid@vger.kernel.org>; Sun,  7 May 2023 14:17:39 -0700 (PDT)
Received: from host86-157-72-252.range86-157.btcentralplus.com ([86.157.72.252] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pvllB-0002xh-FB;
        Sun, 07 May 2023 22:17:37 +0100
Message-ID: <6d61ab0f-6112-373c-090c-34aa7d07e89e@youngman.org.uk>
Date:   Sun, 7 May 2023 22:17:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Second of 3 drives in RAID5 missing
To:     Alex Elder <elder@ieee.org>, Hannes Reinecke <hare@suse.de>,
        linux-raid@vger.kernel.org
References: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
 <7605c54f-670a-a804-b238-627cd561ce52@suse.de>
 <0b5a2849-90ec-573c-03ed-0847135a4e9d@youngman.org.uk>
 <8f046b28-f187-66d8-f67c-3e5821f66e92@ieee.org>
 <b754545f-c505-71d9-6da0-2df8c607ae52@youngman.org.uk>
 <fc55e52f-f97c-03b1-04a2-c2c300f9550b@ieee.org>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <fc55e52f-f97c-03b1-04a2-c2c300f9550b@ieee.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 07/05/2023 17:47, Alex Elder wrote:
> I think I'm on my way back now.  Thank you very much.    -Alex
> 
> root@meat:/home/elder# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md127 : active raid5 sdc1[4] sdb1[0] sdd1[3]
>        15627786240 blocks super 1.2 level 5, 512k chunk, algorithm 2 
> [3/2] [U_U]
>        [>....................]  recovery =  1.2% (96275752/7813893120) 
> finish=639.3min speed=201178K/sec
>        bitmap: 0/59 pages [0KB], 65536KB chunk

Looking good!

Just one last bit of advice - if you can, get another drive. Okay, you 
may not have a bay, or a sata port, or the cash ...

Add it to the array same as before. That'll give you a 3-drive raid plus 
spare. If another drive fails, it will then just start rebuilding 
straight away.

You'll get various people saying "if you've got 4 drives, just go 
raid-6". I'm not going to advise either way, other than to say "don't do 
it just now". If you read the list archive you'll see a couple of arrays 
have got wedged upgrading - udevd quite literally threw a monkey wrench 
into the works. Looks like an easy fix, but better not to risk it - just 
wait until the problem is fixed :-)

Nice drives btw, I've got a 3-drive raid-5 plus spare setup - 3TB 
Barracuda (DON'T use those!), two by 4TB Ironwolf, and an 8TB N300.

Cheers,
Wol
