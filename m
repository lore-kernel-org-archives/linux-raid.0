Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B08C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 02:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiCIClF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 21:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiCIClE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 21:41:04 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 18:40:05 PST
Received: from rin.romanrm.net (rin.romanrm.net [51.158.148.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661763B2B1
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 18:40:03 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id AD3AF6CF;
        Tue,  8 Mar 2022 23:34:48 +0000 (UTC)
Date:   Wed, 9 Mar 2022 04:34:47 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Jani Partanen <jiipee@sotapeli.fi>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: striping 2x500G to mirror 1x1T
Message-ID: <20220309043447.70281a4d@nvm>
In-Reply-To: <9b00eff9-1540-228c-60af-d33c32e1b45a@sotapeli.fi>
References: <20220305044704.GB4455@justpickone.org>
        <9b00eff9-1540-228c-60af-d33c32e1b45a@sotapeli.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 9 Mar 2022 01:08:47 +0200
Jani Partanen <jiipee@sotapeli.fi> wrote:

> Hello, I don't think you gain really any benefit from that raid-0, just 
> go linear array, IMHO.

There is no gain from the linear array either. In none of the performance,
reliability or even simplicity, since managing a linear md array is not any
simpler than managing an md RAID0.

Smaller disks tend to be slower in linear speeds than larger and more densely
written ones. If that is the case with the particular models used here, then
having the 2x500 side in a RAID0 will help them match up in linear speeds to
the 1TB side.

And a very good point that Wols mentioned, the 1TB-disk member can be set as
--write-mostly, since the 2x500GB RAID0 is likely to overshoot the performance
of a single 1TB disk, even if its individual disks were slower. Not to mention
it has two independent head sets for the same amount of data. (If we're still
talking rotational here...)

-- 
With respect,
Roman
