Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492AAC433FE
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 01:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiKYBRE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Nov 2022 20:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYBRD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Nov 2022 20:17:03 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663A7FE5
        for <linux-raid@vger.kernel.org>; Thu, 24 Nov 2022 17:17:02 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id f68so1473839vkc.8
        for <linux-raid@vger.kernel.org>; Thu, 24 Nov 2022 17:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/4h8sCCpUx1LNv0T7REysemjfbXhaGzIazEzRIJxml4=;
        b=LphkfnTbP9JENR1iZCZnF+oS5MyZvUwqC/1LrdqQlZS/ME4qYyfTIfgiSEZz7mZTFZ
         EZSvYJAT+8BXSsXUDM399zhF2XR0mgkv5uMnb7MZbiSK10XHl+Uq5elKq7mtgiYCM/2o
         dhuLC5rUAXoL3H7x6EG/gow5hJrpi7qJmN0yXVmFSfojJNvEKbYxiqpTG9aCHfgPoeN/
         cmCSOqFMyYPEnzQzVreRH4kkG/NynurZl32Reu6A8qTGNMKhaHArdxbdIn6oMpsJW08l
         aUydaeKCvzROFopPIzv+25KIpC3XQPtBQd6HHWVlvqFs3G4NeVxEEXsRbcsn+cgWiw8w
         U5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/4h8sCCpUx1LNv0T7REysemjfbXhaGzIazEzRIJxml4=;
        b=tS7nv0Ng/t8GFamE1masJY//gisF/io2fCWkLj/9ISWIMycXVWvqIqJYKVynqGlIw4
         KcjBlHuBGfT4UYkdwmTKRs5NELBzTkAjRqHqiIbaAti39eNsOsjRUFgzo9NddB103YKl
         ZlMmgOAgZCo+xxA8YKfuNSkmWhywa+56LQg44ZsElTB61Zd/A8rEughyhg/pc6uJKBZT
         zrmIHxMmjYSd+c4IRJxqr364NQhTYaw/fQSW5I2YmPmVI7R1oOJ56OEUvShx1dx/DaiR
         wAobNbj0QLDJ37lxfnq9W2k6OZSyhQ2HGD9AGNvqexBKySjlPCCGOp+6VcL/PZU3h/Jx
         C+Iw==
X-Gm-Message-State: ANoB5pkCQuaEwD2MNb9Akz6mRj5ecknD/Y9mWCuULvDcC0m2SzcvfuMG
        zCVnXZXBqCUi6H9KGp2ep38HD846t/eaPyVYJMVxh1u9
X-Google-Smtp-Source: AA0mqf73Iuj5WDChniN0BFodQDN/S9f8xpQcVj8HYculX5oZ8EznIOp18pSjJ9N4uLXg712pS7dvjZjgxZ0x2yfjE9o=
X-Received: by 2002:a1f:58c1:0:b0:3b7:bd26:9251 with SMTP id
 m184-20020a1f58c1000000b003b7bd269251mr9565967vkb.25.1669339021479; Thu, 24
 Nov 2022 17:17:01 -0800 (PST)
MIME-Version: 1.0
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo> <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
In-Reply-To: <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Thu, 24 Nov 2022 19:16:50 -0600
Message-ID: <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
Subject: Re: how do i fix these RAID5 arrays?
To:     Wol <antlists@youngman.org.uk>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

 If you had 5 raw disks raid0 is faster, but with the separate
partition setup linear will be faster because linear does not have a
seek from one partition to another but instead a linear write.  Note
that on reads raid5 performs similar to a raid0 stripe of 1 less disk,
writes on raid5

Based on those messages The re-add would be expected to work fine.  it
appears that the machine was shutdown wrong and/or crashed and kicked
the devices out because the data was a few events behind on that
device.     I have seen this happen from time to time.  In general the
re-add will do the right thing or will get an error.      When
something goes wrong you always need to check messages and see what
the underlying issue is/was.

Find any lvm instruction and treat the N mdraids as "disks" but and do
not do stripe (the simple default will do what you want)  and the
default method lvm uses will lay out the new block devices as one big
device basically using all of the first raid and then the next one and
so on.   or you can simply recreate the big device and specific an
mdadm type of "linear" rather than raid0.


On Thu, Nov 24, 2022 at 4:03 PM Wol <antlists@youngman.org.uk> wrote:
>
> On 24/11/2022 21:10, David T-G wrote:
> > How is linear different from RAID0?  I took a quick look but don't quite
> > know what I'm reading.  If that's better then, hey, I'd try it (or at
> > least learn more).
>
> Linear tacks one drive on to the end of another. Raid-0 stripes across
> all drives. Both effectively combine a bunch of drives into one big drive.
>
> Striped gives you speed, a big file gets spread over all the drives. The
> problem, of course, is that losing one drive can easily trash pretty
> much every big file on the array, irretrievably.
>
> Linear means that much of your array can be recovered if a drive fails.
> But it's no faster than a single drive because pretty much every file is
> stored on just the one drive. And depending on what drive you lose, it
> can wipe your directory structure such that you just end up with a
> massive lost+found directory.
>
> That's why there's raid-10. Note that outside of Linux (and often
> inside) when people say "raid-10" they actually mean "raid 1+0". That's
> two striped raid-0's, mirrored.
>
> Linux raid-10 is different. it means you have at least two copies of
> each stripe, smeared across all the disks.
>
> Either version (10, or 1+0), gives you get the speed of striping, and
> the safety of a mirror. 10, however, can use an odd number of disks, and
> disks of random sizes.
>
> Cheers,
> Wol
