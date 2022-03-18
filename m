Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3141C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 07:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiCRHzx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 03:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiCRHzx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 03:55:53 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B588716E204
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 00:54:33 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nV7RP-00056m-B9;
        Fri, 18 Mar 2022 07:54:31 +0000
Message-ID: <484d394a-fd96-a576-1199-d57b88a59b5e@youngman.org.uk>
Date:   Fri, 18 Mar 2022 07:54:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
Content-Language: en-GB
To:     Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
References: <20220318030855.GV3131742@merlins.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20220318030855.GV3131742@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18/03/2022 03:08, Marc MERLIN wrote:
> old drive:
> Device Model:     ST6000VN0041-2EL11C
> Serial Number:    ZA18WX4T
> LU WWN Device Id: 5 000c50 0a47d527a
> Firmware Version: SC61
> User Capacity:    6,001,175,126,016 bytes [6.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> 
>     8      128 5860522584 sdi
>     8      129 5860521543 sdi1
> 
> 
> new drive:
> Device Model:     ST6000VN001-2BB186
> Serial Number:    ZR118A1Y
> LU WWN Device Id: 5 000c50 0dba1b3c0
> Firmware Version: SC60
> User Capacity:    6,001,175,126,016 bytes [6.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> 
>     8      160 5860522580 sdk
>     8      161 5860521536 sdk1
> 
> New drive is 4 sectors shorter, so I assume I can't use it as a replacement in my md5
> array because it's 4 sectors too short, or does swraid5 not need the last few sectors
> of a drive?
> 
> Looks like formatting as MDR won't help, I'm still 4 sectors short.
> 
Suck it and see ...

The two drives look like they report the same User Capacity, ie 6 
terabytes "exactly". They should therefore be drop-in replacements for 
each other.

And I find that eg when I partition a drive it reports unusable space at 
the end - you should find that any lost space will get lost there ...

And are you using sdk, or sdk1, as your block device to add to the 
array? While I'd be a little surprised, is it possible the disk drives 
are reporting different geometries and messing up fdisk's default 
partition sizes? Try copying the partition geometry exactly from sdi to 
sdk using sector numbers ...

Plus they're both Seagates (Ironwolf, good choice :-), so there really 
shouldn't be a problem. The only odd thing I notice is your new drive 
seems to have an older firmware?

Cheers,
Wol
