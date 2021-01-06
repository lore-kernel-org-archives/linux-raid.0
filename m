Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1980C433E0
	for <linux-raid@archiver.kernel.org>; Wed,  6 Jan 2021 23:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76EA2313E
	for <linux-raid@archiver.kernel.org>; Wed,  6 Jan 2021 23:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbhAFXoK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Jan 2021 18:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbhAFXoK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Jan 2021 18:44:10 -0500
X-Greylist: delayed 956 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Jan 2021 15:43:14 PST
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B555C061786
        for <linux-raid@vger.kernel.org>; Wed,  6 Jan 2021 15:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Subject:To:From:Date; bh=bPeouSZ1JpBj7J1oFqfS0x/iwXX7Au5rfCTevuxSkjo=;
        b=jyqgHEGCYG9vUKik+phkLb08J7LmV/MJUHYv3TBAl42HMtewOEUMl/5QE9SorDAIdt2TWjN0Nj7L8tKx4UE2etwwwPs03YS6nC5dWgjWnqQY5Ht+78ulmukQix/Bd86a5Gin4O8QSZbiWN7x+hQ/G7wavLBIK9C19CVmwMa1W2qSVxra+bnN+TuHHXjSRoO2dUdTpcUTSXmvEukVGtS/694/ANMUbu5uSvLTw/RfNAHffyKz43tJiYXZjj8igcNPz3LrVvH3qEyMX1W3pHQW/jVkSbwGajyxZxNPvu1AS4vlUepf5uI2RdrDQgR4qpPyTeIHpHaJh5l6bZ9RRtDLpw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kxICy-0005TO-6j
        for linux-raid@vger.kernel.org; Wed, 06 Jan 2021 23:27:16 +0000
Date:   Wed, 6 Jan 2021 23:27:16 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: "md/raid10:md5: sdf: redirecting sector 2979126480 to another mirror"
Message-ID: <20210106232716.GY3712@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

"md/raid10:md5: sdf: redirecting sector 2979126480 to another
mirror"

I've actually been seeing these messages very occasionally across
many machines for years but have never found anything wrong so kept
putting investigation of it to the bottom of my TODO list. I have
even in the past upon seeing this done a full scrub and check and
found no issue.

Having just seen one of them again now, and having some spare time I
tried to look into it.

So, this messages comes from here:

    https://github.com/torvalds/linux/blob/v5.8/drivers/md/raid10.c#L1188

but under what circumstances does it actually happen?

This time, as with the other times, I cannot see any indication of
read error (i.e. no logs of that) and no problems apparent in SMART
data.

err_rdev there can only be set inside the block above that starts
with:


    if (r10_bio->devs[slot].rdev) {
        /*
         * This is an error retry, but we cannot
         * safely dereference the rdev in the r10_bio,
         * we must use the one in conf.

…but why is this an error retry? Nothing was logged so how do I find
out what the error was?

Cheers,
Andy
