Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D24CA0FE8
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 20:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347993AbjIAUhP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbjIAUhO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 16:37:14 -0400
Received: from len.romanrm.net (len.romanrm.net [IPv6:2001:41d0:1:8b3b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6101EE7E
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 13:37:11 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id A460140171;
        Fri,  1 Sep 2023 20:37:08 +0000 (UTC)
Date:   Sat, 2 Sep 2023 01:37:00 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     CoolCold <coolthecold@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10, far layout initial sync slow + XFS question
Message-ID: <20230902013700.4c969472@nvm>
In-Reply-To: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On Sat, 2 Sep 2023 03:23:00 +0700
CoolCold <coolthecold@gmail.com> wrote:

> So the strange thing I do observe, is its initial raid sync speed.
> Created with:
> mdadm --create /dev/md3 --run -b none --level=10 --layout=f2
> --chunk=16 --raid-devices=4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
> /dev/nvme5n1
> 
> sync speed:
> 
> md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
>       7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
>       [=>...................]  resync =  6.2% (466905632/7501212288)
> finish=207.7min speed=564418K/sec

Any difference if you use e.g. --chunk=1024?

How about a newer kernel (such as 6.1)?

-- 
With respect,
Roman
