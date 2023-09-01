Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEB1CA0FE8
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 22:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350871AbjIAWkG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 18:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350884AbjIAWkE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 18:40:04 -0400
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C83A198B
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 14:55:49 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id B2D5040171;
        Fri,  1 Sep 2023 21:26:37 +0000 (UTC)
Date:   Sat, 2 Sep 2023 02:26:29 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     CoolCold <coolthecold@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10, far layout initial sync slow + XFS question
Message-ID: <20230902022629.6ab77d48@nvm>
In-Reply-To: <CAGqmV7oX90YGM8-XwS_yqT_Lk94_EMWKr0SpQ+cmrgVpywKdbA@mail.gmail.com>
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
        <20230902013700.4c969472@nvm>
        <CAGqmV7reuaeGNY3jz-8BjrmwTR3kmNzCXEa7JxouZ8v7t9QqnA@mail.gmail.com>
        <20230902020048.356667d4@nvm>
        <CAGqmV7oX90YGM8-XwS_yqT_Lk94_EMWKr0SpQ+cmrgVpywKdbA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 2 Sep 2023 04:17:46 +0700
CoolCold <coolthecold@gmail.com> wrote:

> Definitely there is a bottleneck and I very much doubt I'm the first
> one facing this - NVMe drives with > 1GB/sec are quite widespread.
> 
> > RAID1 performance at some point if you raise it further to 4096, 8192 or more?
> 
> I can try, for sake of testing, but in terms of practical outcome -
> let's imagine with 8MB chunks it reaches maximum - what to do with
> that knowledge?

Maybe then it would be easier for an mdadm developer to chime in and pinpoint
the reason why it might be slow for you at the smaller chunk sizes, provide a
hint if there were any commits improving that aspect in kernel versions later
than you use, etc.

-- 
With respect,
Roman
