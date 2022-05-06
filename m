Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09950C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  6 May 2022 11:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391497AbiEFLwh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 May 2022 07:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390339AbiEFLwg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 May 2022 07:52:36 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A597B56C3D
        for <linux-raid@vger.kernel.org>; Fri,  6 May 2022 04:48:50 -0700 (PDT)
Subject: Re: Unable to add journal device to RAID 6 array
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651837729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Shuqjwp4XAyShxs5S8mOnGESRq1uKmHpYLT0BEc/N20=;
        b=Tpx/REnRhLmT6tUOJwnJFRs0PaLL3Ceq9AiwBghmaKWhZIxHxtnDNmM6gvpkoRdq8Vbzdj
        tsDs7Dys7NcGOT1AHi8NOdh6HsvpfeFr/zmNWl9VhBiNk/iiHHmGx+u0xgI8qpY594cTGu
        hLbU8yA6cAYtlwSa0wNq2yH0IozG8mQ=
To:     James Stephenson <inbox@jstephenson.me>, linux-raid@vger.kernel.org
References: <CA+an+MoM_Vb4Z3FSRcTo+ykmFTW5cwh1CQWCN9BMT45CdW_P0g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <26c0f640-8801-240c-ce2c-99246b09f2e2@linux.dev>
Date:   Fri, 6 May 2022 19:48:45 +0800
MIME-Version: 1.0
In-Reply-To: <CA+an+MoM_Vb4Z3FSRcTo+ykmFTW5cwh1CQWCN9BMT45CdW_P0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/6/22 6:42 PM, James Stephenson wrote:
> Hi,
>
> First time using this (and indeed any) mailing list, so apologies if I
> violate any etiquette I'm not aware of!
>
> I'm trying to add a write-back journal device to an existing RAID 6
> array, and it's proving difficult. Essentially I did this:
>
> 1. Put the array in read-only
> 2. Attempt to add a journal device to the array
> 3. md said no because the array has a bitmap
> 4. I tried to remove the bitmap, and it said no: 'md: couldn't update
> array info. -16'
> 5. I rebooted
> 6. The array wouldn't start, and to my surprise was listed as having a
> journal device. Here's what it looked like:
> https://gist.github.com/jstephenson/1db2008c4243c2539d029f1f4706dc14
> 7. It was _very_ unhappy, and refused to do anything: 'md/raid:md126:
> array cannot have both journal and bitmap'
> 8. The only thing I could do was to zero the superblock on the journal
> device, and then fortunately everything assemble again nicely (with
> bitmap still in place)
>
> So, after a bit of messing around the array is back to where I
> started—RAID 6 with internal bitmap. However, I still cannot remove
> its bitmap.
>
> 1. sudo mdadm --grow /dev/md126 --bitmap=none
> 2. md: couldn't update array info. -16

-16 means EBUSY, so probably the array needs resync or recovery per

https://elixir.bootlin.com/linux/v5.10.106/source/drivers/md/md.c#L7374

Thanks,
Guoqing
