Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D554C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 12:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbiCRMba (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiCRMba (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 08:31:30 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA49D2D639D
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 05:30:10 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id E1615620;
        Fri, 18 Mar 2022 12:30:07 +0000 (UTC)
Date:   Fri, 18 Mar 2022 17:30:07 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5
 array?
Message-ID: <20220318173007.3ad9348c@nvm>
In-Reply-To: <20220318030855.GV3131742@merlins.org>
References: <20220318030855.GV3131742@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 17 Mar 2022 20:08:55 -0700
Marc MERLIN <marc@merlins.org> wrote:

> old drive:
> Device Model:     ST6000VN0041-2EL11C
> Serial Number:    ZA18WX4T
> LU WWN Device Id: 5 000c50 0a47d527a
> Firmware Version: SC61
> User Capacity:    6,001,175,126,016 bytes [6.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> 
>    8      128 5860522584 sdi
>    8      129 5860521543 sdi1
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
>    8      160 5860522580 sdk
>    8      161 5860521536 sdk1
> 
> New drive is 4 sectors shorter, so I assume I can't use it as a replacement in my md5
> array because it's 4 sectors too short, or does swraid5 not need the last few sectors
> of a drive?
> 
> Looks like formatting as MDR won't help, I'm still 4 sectors short.

Check "Used Dev Size" in "mdadm --detail" of your array. I suppose that is how
much (at least) it actually needs from any new member to be suitable for the
array.

If you find it needs more than the size of sdk1, as an emergency measure you
could wipe off the partition table and add the entire sdk as the array member.
While usually not recommended, if you don't boot other operating systems on
the same machine (that could see the "raw" drive and mess with it), it should
not cause any problem.

However there should not be such size difference in the first place, check
your dmesg if drive detection messages report "HPA", and/or check with "hdparm
-N" if there's this HPA enabled, cutting off a portion of the drive at the end.

-- 
With respect,
Roman
