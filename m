Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60735CE7A89
	for <linux-raid@archiver.kernel.org>; Sat, 23 Sep 2023 15:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjIWPfc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Sep 2023 11:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjIWPfc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Sep 2023 11:35:32 -0400
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F7F9E
        for <linux-raid@vger.kernel.org>; Sat, 23 Sep 2023 08:35:25 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id A8D3E4010A;
        Sat, 23 Sep 2023 15:35:23 +0000 (UTC)
Date:   Sat, 23 Sep 2023 20:35:12 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Joel Parthemore <joel@parthemores.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: request for help on IMSM-metadata RAID-5 array
Message-ID: <20230923203512.581fcd7d@nvm>
In-Reply-To: <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
        <20230923162449.3ea0d586@nvm>
        <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 23 Sep 2023 17:18:00 +0200
Joel Parthemore <joel@parthemores.com> wrote:

> I didn't want to try that again until I had confirmation that the 
> out-of-sync wouldn't (or shouldn't) be an issue. (I had tried it once 
> before, but the system had somehow swapped /dev/md126 and /dev/md127 so 
> that /dev/md126 became the container and /dev/md127 the RAID-5 array, 
> which confused me. So I stopped experimenting further until I had a 
> chance to write to the list.)
> 
> The array is assembled read only, and this time both /dev/md126 and 
> /dev/md127 are looking like I expect them to. I started dd to make a 
> backup image using dd if=/dev/md126 of=/dev/sdc bs=64K 
> conv=noerror,sync. (The EXT4 file store on the 2TB RAID-5 array is about 
> 900GB full.) At first, it was running most of the time and just 
> occasionally in uninterruptible sleep, but the periods of 
> uninterruptible sleep quickly started getting longer. Now it seems to be 
> spending most but not quite all of its time in uninterruptible sleep. Is 
> this some kind of race condition? Anyway, I'll leave it running 
> overnight to see if it completes.
> 
> Accessing the RAID array definitely isn't locking things up this time. I 
> can go in and look at the partition table, for example, no problem. 
> Access is awfully slow, but I assume that's because of whatever dd is or 
> isn't doing.
> 
> By the way, I'm using kernel 6.5.3, which isn't the latest (that would 
> be 6.5.5) but is close.

Maybe it's an HDD issue, one of them did have some unreadable sectors in the
past, although the firmware has not decided to do anything about that, such
as reallocating them and recording that in SMART. 

Check if one of the drives is holding up things, with a command like

  iostat -x 2 /dev/sd?

If you see 100% next to one of the drives, and much less for others, that one
might be culprit.

-- 
With respect,
Roman
