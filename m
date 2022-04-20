Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73317C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 11:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351118AbiDTLK7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 07:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiDTLK6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 07:10:58 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B227B28E1D
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 04:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w4v/km3eK82JY+avY3J6OYrhNtXO6e7ZOM0o+QMTc9Q=; b=XbnVIKpB9sDffCBbk0izrQmYzp
        oaSQOzAxYl2wbjB9pSzZDAgxDKJShFs2X0nZjpBJrI182nPIsnSPv6hfOrczNKOyeERCxTptetNND
        l5IWa1VxdPJbsTZqAZsYDmu9xwtJyRgTs71J27+FDHc+MAzRm1Xc1LwtQtwDOQqu4OboTsLSwfESk
        Qa8QFrQ/l4DpgF3Nu8+SNz35+JPgcKXnoQfgngtG9IX8tNlI2mwJnngKPhx8/DU4plz5dlMMrv+hW
        iu1QH3RS/qG6boPg/LLxY7tiFwHpiVPiCxAPTxzW0fvTm/oYw9GvGzeFu1mTMWsWuaUhWEm+n0bVh
        El0mIbVQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1nh8Bu-0007w9-Hc
        for linux-raid@vger.kernel.org; Wed, 20 Apr 2022 11:08:10 +0000
Date:   Wed, 20 Apr 2022 11:08:10 +0000
From:   Andy Smith <andy@strugglers.net>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Need to move RAID1 with mounted partition
Message-ID: <20220420110810.x2ydoqhyeuocnrwy@bitfolk.com>
Mail-Followup-To: Linux RAID <linux-raid@vger.kernel.org>
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On Wed, Apr 20, 2022 at 03:40:12AM -0500, Leslie Rhorer wrote:
> The third partition on each drive is assigned as swap, and of
> course it was easy to resize those partitions, leaving an
> additional 512MB between the second and third partitions on each
> drive.  All I need to do is move the second partition on each
> drive up by 512MB.

I'd be tempted to just make these two new 512M spaces into new
partitions for a RAID-1 and move your /boot to that, abandoning the
RAID-1 you have for the /boot that is using the partitions at the
start of the disk. What would you lose? A couple of hundred MB?
Exchanged for a much easier life.

You could do away with the swap partitions entirely and use swap
files instead.

You could recycle the first partitions as swap, too.

Cheers,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
