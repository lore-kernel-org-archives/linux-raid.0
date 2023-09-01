Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8714BCA0FF6
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 21:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350771AbjIAVBT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 17:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350804AbjIAVBR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 17:01:17 -0400
Received: from len.romanrm.net (len.romanrm.net [IPv6:2001:41d0:1:8b3b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC901984
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 14:01:04 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id B86F840171;
        Fri,  1 Sep 2023 21:00:56 +0000 (UTC)
Date:   Sat, 2 Sep 2023 02:00:48 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     CoolCold <coolthecold@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10, far layout initial sync slow + XFS question
Message-ID: <20230902020048.356667d4@nvm>
In-Reply-To: <CAGqmV7reuaeGNY3jz-8BjrmwTR3kmNzCXEa7JxouZ8v7t9QqnA@mail.gmail.com>
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
        <20230902013700.4c969472@nvm>
        <CAGqmV7reuaeGNY3jz-8BjrmwTR3kmNzCXEa7JxouZ8v7t9QqnA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 2 Sep 2023 03:43:42 +0700
CoolCold <coolthecold@gmail.com> wrote:

> > > md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
> > >       7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
> > >       [=>...................]  resync =  6.2% (466905632/7501212288)
> > > finish=207.7min speed=564418K/sec
> >
> > Any difference if you use e.g. --chunk=1024?
> Goes up to 1.4GB
> 
> md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
>       7501209600 blocks super 1.2 1024K chunks 2 far-copies [4/4] [UUUU]
>       [>....................]  resync =  0.4% (35959488/7501209600)
> finish=86.4min speed=1438382K/sec

Looks like you have found at least some bottleneck. Does it ever reach the
RAID1 performance at some point if you raise it further to 4096, 8192 or more?

It might also be worth it to try making the RAID with --assume-clean, and then
look at the actual array performance, not just the sync speed.

> > How about a newer kernel (such as 6.1)?
> Not applicable in my case- there is no test machine unluckily to play
> around with non LTS and reboots. Upgrading to next HWE kernel may
> happen though, which is 5.15.0-82-generic #91-Ubuntu.
> Do you know any specific patches/fixes landed since 5.4?

No idea. I guessed if you are just setting up a new server, it would be
possible to slip in a reboot or a few. :)

-- 
With respect,
Roman
