Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D1FC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 08:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E9960E54
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 08:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhKNIy4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Nov 2021 03:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhKNIyy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 14 Nov 2021 03:54:54 -0500
X-Greylist: delayed 270 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 Nov 2021 00:51:58 PST
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C103C061746
        for <linux-raid@vger.kernel.org>; Sun, 14 Nov 2021 00:51:57 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 46335626;
        Sun, 14 Nov 2021 08:47:24 +0000 (UTC)
Date:   Sun, 14 Nov 2021 13:47:23 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     David T-G <davidtg+robot@justpickone.org>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: overlays on dd images of 4T drives
Message-ID: <20211114134723.46092368@nvm>
In-Reply-To: <20211114022924.GA21337@opal1.opalstack.com>
References: <20211114022924.GA21337@opal1.opalstack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 14 Nov 2021 02:29:24 +0000
David T-G <davidtg+robot@justpickone.org> wrote:

>   diskfarm:/mnt/10Traid50md/tmp # ls -goh overlay-sd*
>   -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sda1
>   -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sdb1
>   -rw-r--r-- 1 4.0T Nov 12 02:05 overlay-sdc1
>   diskfarm:/mnt/10Traid50md/tmp # losetup -a
>   /dev/loop1: [66326]:1059 (/mnt/10Traid50md/tmp/overlay-sdb1)
>   /dev/loop2: [66326]:1060 (/mnt/10Traid50md/tmp/overlay-sdc1)
>   /dev/loop0: [66326]:1058 (/mnt/10Traid50md/tmp/overlay-sda1)
> 
> my overlay files and loopback devices.  But ...
> 
> It seems that blockdev does not like
> 
>   diskfarm:/mnt/10Traid50md/tmp # blockdev --getsize ./overlay-sda1
>   blockdev: ioctl error on BLKGETSIZE: Inappropriate ioctl for device
> 
> my files

It must be run on block devices, not files, so try: 

  blockdev --getsize /dev/loop0

-- 
With respect,
Roman
