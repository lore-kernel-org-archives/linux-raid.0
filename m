Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EC8C25B0E
	for <linux-raid@archiver.kernel.org>; Fri, 12 Aug 2022 08:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbiHLIpM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Aug 2022 04:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237569AbiHLIpE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 Aug 2022 04:45:04 -0400
X-Greylist: delayed 356 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 Aug 2022 01:45:01 PDT
Received: from smtp-delay1.nerim.net (mailhost-x5-p4.nerim-networks.com [195.5.209.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86A6DA8CCA
        for <linux-raid@vger.kernel.org>; Fri, 12 Aug 2022 01:45:01 -0700 (PDT)
Received: from maiev.nerim.net (smtp-155-friday.nerim.net [194.79.134.155])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id 3082422F93E
        for <linux-raid@vger.kernel.org>; Fri, 12 Aug 2022 10:39:03 +0200 (CEST)
Received: from [192.168.0.247] (plouf.fr.eu.org [213.41.155.166])
        by maiev.nerim.net (Postfix) with ESMTP id 8902F2E00C;
        Fri, 12 Aug 2022 10:38:56 +0200 (CEST)
Message-ID: <a0143fd9-b99b-6c41-e2a0-da60d0d11cd2@plouf.fr.eu.org>
Date:   Fri, 12 Aug 2022 10:38:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: mirroring existing boot drive sanity check
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <8319a7ea67dc601c8ca4556ff15702d5@justpickone.org>
 <014ce113-3c6d-ea1d-a576-cb06e5126748@plouf.fr.eu.org>
 <fc6cd184-5570-3afa-e477-03008be58183@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <fc6cd184-5570-3afa-e477-03008be58183@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 12/08/2022 à 09:23, Wols Lists a écrit :
> On 11/08/2022 22:26, Pascal Hambourg wrote:
>> However I do not think it is possible to cleanly boot from an 
>> unpartitioned drive used as a software RAID member, as a RAID capable 
>> boot loader could hardly fit in the 4-KiB area before the RAID 
>> superblock.
> 
> Firstly, is there a 4K block there? iirc it's only 1.2 that leaves said 
> block.

Yes, but 1.2 is the default, so I assumed it.

> And secondly, does raid assume that 4K space belongs to it? I know it's 
> seen as a safety space, so there's nothing permanent left there, but 
> that's no guarantee raid doesn't think "that's mine, I'll stash 
> something there temporarily". After all, the space allocated explicitly 
> begins at the start of the 4K.

On one hand other 1.x subversions do not have that 4-KiB space so I 
assume it is not used. Also the gap between the superblock and the data 
may be used to hold temporary stuff.

On the other hand ext* filesystems do not use the first sector either 
but mke2fs erases it anyway, wiping any existing boot sector.

Anyway, as I wrote previously, no usable boot loader would fit there, so 
the point is moot.
