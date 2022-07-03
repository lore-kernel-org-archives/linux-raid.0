Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95106C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jul 2022 21:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiGCVUr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 17:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiGCVUq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 17:20:46 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51025584
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 14:20:44 -0700 (PDT)
Received: from host86-160-229-11.range86-160.btcentralplus.com ([86.160.229.11] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o871G-0000OG-Br;
        Sun, 03 Jul 2022 22:20:42 +0100
Message-ID: <15211b19-7499-95b6-7616-6fbd13d434ca@youngman.org.uk>
Date:   Sun, 3 Jul 2022 22:20:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Is it correct that raid5 cannot be converted from Consistency
 Policy: bitmap to ppl?
Content-Language: en-GB
To:     Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
References: <20220703200741.GA3138296@merlins.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20220703200741.GA3138296@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/07/2022 21:07, Marc MERLIN wrote:
> Is there any way around this, or not without a full reformat/rebuild?

Not sure, but I expect there is ... is this the collision between 
journal and bitmap? I know it won't let you mix those.

Look at the wiki, it tells you how to get rid of the bitmap, and then 
you can probably change it to pol.

Cheers,
Wol

https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> gargamel:~# mdadm --query --detail /dev/md5
> /dev/md5:
>             Version : 1.2
>       Creation Time : Tue Jan 21 10:35:52 2014
>          Raid Level : raid5
>          Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
>       Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
>        Raid Devices : 5
>       Total Devices : 5
>         Persistence : Superblock is persistent
> 
>       Intent Bitmap : Internal
> 
>         Update Time : Sun Jul  3 03:02:01 2022
>               State : active, checking
>      Active Devices : 5
>     Working Devices : 5
>      Failed Devices : 0
>       Spare Devices : 0
> 
>              Layout : left-symmetric
>          Chunk Size : 512K
> 
> Consistency Policy : bitmap
> 
>        Check Status : 99% complete
> 
>                Name : gargamel.svh.merlins.org:5  (local to host gargamel.svh.merlins.org)
>                UUID : ec672af7:a66d9557:2f00d76c:38c9f705
>              Events : 642977
> 
>      Number   Major   Minor   RaidDevice State
>         0       8      193        0      active sync   /dev/sdm1
>         6       8      177        1      active sync   /dev/sdl1
>         2       8      209        2      active sync   /dev/sdn1
>         3       8        1        3      active sync   /dev/sda1
>         5       8       17        4      active sync   /dev/sdb1
> gargamel:~# mdadm --grow --consistency-policy=ppl /dev/md5
> mdadm: Current consistency policy is bitmap, cannot change to ppl
> 
> Kernel 5.16.
> 
> Thanks,
> Marc

