Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3407FC00140
	for <linux-raid@archiver.kernel.org>; Fri, 12 Aug 2022 07:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiHLHYG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Aug 2022 03:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiHLHYF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 Aug 2022 03:24:05 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B639A50E7
        for <linux-raid@vger.kernel.org>; Fri, 12 Aug 2022 00:24:03 -0700 (PDT)
Received: from host86-128-157-135.range86-128.btcentralplus.com ([86.128.157.135] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oMP1U-00060W-7j;
        Fri, 12 Aug 2022 08:24:00 +0100
Message-ID: <fc6cd184-5570-3afa-e477-03008be58183@youngman.org.uk>
Date:   Fri, 12 Aug 2022 08:23:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: mirroring existing boot drive sanity check
Content-Language: en-GB
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <8319a7ea67dc601c8ca4556ff15702d5@justpickone.org>
 <014ce113-3c6d-ea1d-a576-cb06e5126748@plouf.fr.eu.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <014ce113-3c6d-ea1d-a576-cb06e5126748@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/08/2022 22:26, Pascal Hambourg wrote:
> However I do not think it is possible to cleanly boot from an 
> unpartitioned drive used as a software RAID member, as a RAID capable 
> boot loader could hardly fit in the 4-KiB area before the RAID 
> superblock. So you still have to create a partition table on the raw 
> drives. Also, if you use GPT format and GRUB boot loader, you need to 
> create a small (100 kB to 1 MB) partition with type "BIOS boot" (or 
> libparted bios_grub flag).

Firstly, is there a 4K block there? iirc it's only 1.2 that leaves said 
block.

And secondly, does raid assume that 4K space belongs to it? I know it's 
seen as a safety space, so there's nothing permanent left there, but 
that's no guarantee raid doesn't think "that's mine, I'll stash 
something there temporarily". After all, the space allocated explicitly 
begins at the start of the 4K.

(That's completely different to the rouge tools the space is there to 
protect - those tools that think "that's nobody's, I'll just grab it".)

Cheers,
Wol
