Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58D1C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 10 Oct 2022 15:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJJPYR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Oct 2022 11:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJJPYP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Oct 2022 11:24:15 -0400
Received: from mallaury.nerim.net (smtp-101-monday.noc.nerim.net [178.132.17.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD7427330E
        for <linux-raid@vger.kernel.org>; Mon, 10 Oct 2022 08:24:11 -0700 (PDT)
Received: from [192.168.0.247] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 095F7DB17C;
        Mon, 10 Oct 2022 17:23:59 +0200 (CEST)
Message-ID: <0a80cb3e-9f95-3058-b362-0d4eb03e1896@plouf.fr.eu.org>
Date:   Mon, 10 Oct 2022 17:23:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: calculate "Array Size" for fdisk
To:     Reindl Harald <h.reindl@thelounge.net>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <e2c8b04b-1f4b-6d65-101f-6cb83dff6be8@thelounge.net>
Content-Language: en-US
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <e2c8b04b-1f4b-6d65-101f-6cb83dff6be8@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/10/2022 at 15:49, Reindl Harald wrote :
> i  am at creating new RAID1 stoarges on twice sized disks to replace 
> existing 4 drive RAID10
> 
> looking with fdisk and calculate twice din't end well and finally "dd" 
> the FS in the array stopped with around 2 MB too small

Which is probably the size of RAID metadata added at the beginning or 
end of the partitions.

> is the "30716928" MiB or MB and what takes fdisk with "+30716928M"?

MiB for both.

>          Array Size : 30716928 (29.29 GiB 31.45 GB)
>       Used Dev Size : 15358464 (14.65 GiB 15.73 GB)
> 
> did i say that i hate it that M isn't strictly 1024 when it comes to IT?

"M" is never 1024.
"M" (mega) was defined and should always be used as 1000000. If you mean 
1048576, use "Mi" (mebi).
