Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6222AC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 08:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376977AbiDTI6d (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351198AbiDTI6Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 04:58:24 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C7E237E0
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 01:55:37 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 55E1B7ED;
        Wed, 20 Apr 2022 08:55:34 +0000 (UTC)
Date:   Wed, 20 Apr 2022 13:55:33 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Leslie Rhorer <lesrhorer@att.net>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Need to move RAID1 with mounted partition
Message-ID: <20220420135533.39a32200@nvm>
In-Reply-To: <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
        <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
        <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
        <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
        <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
        <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
        <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 20 Apr 2022 03:40:12 -0500
Leslie Rhorer <lesrhorer@att.net> wrote:

> 	I have run into a little problem.  I know of a couple of ways to fix it 
> by shutting down the system and physically taking it apart, but for 
> various reasons I don't wish to take that route.  I want to be able to 
> re-arrange the system with it running.
> 
> 	The latest version (bullseye) of Debian will not complete its upgrade 
> properly because my /boot file system is a little too small.  I have two 
> bootable drives with three partitions on them.  The first partition on 
> each drive is assembled into a RAID1 as /dev/md1 mounted as /boot.  Once 
> the system is booted, these can of course easily be umounted, the RAID1 
> stopped, and there is then no problem increasing the size of the 
> partitions if there were space to be had.  The third partition on each 
> drive is assigned as swap, and of course it was easy to resize those 
> partitions, leaving an additional 512MB between the second and third 
> partitions on each drive.  All I need to do is move the second partition 
> on each drive up by 512MB.
> 
> 	The problem is the second partition on both drives is also assembled 
> into a RAID1 array on /dev/md2, formatted as ext4 and mounted as /.  Is 
> there a way I can move the RAID1 array up without shutting down the 
> system?  I don't need to resize the array, just move it.

You could fail one half of the RAID1, remove it, recreate the partition at the
required offset, add the new partition into the array and let it rebuild. Then
repeat with the other half.

However during that process you do not have the redundancy protection, so in
case the remaining array drive fails or has a bad sector, it could become
tricky to recover.

Maybe run a bad block scan, or "smartctl -t long" on the disks first. And of
course have a backup.

-- 
With respect,
Roman
