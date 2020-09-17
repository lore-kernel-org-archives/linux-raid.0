Return-Path: <SRS0=RAIN=C2=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB79C433E2
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 08:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7214C20715
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 08:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bitfolk.com header.i=@bitfolk.com header.b="l7GvXf8d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgIQI3m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgIQI3e (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Sep 2020 04:29:34 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA864C06174A
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2020 01:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date; bh=q1d6GuWOtpnpmcFuA6XUBRkAEj1xURYs/o0fUGVHDAs=;
        b=l7GvXf8doJcvm0m6OLrWDpPc1UmRZaF0bcXW2vpnhmSyS7mgLKbxKB3CRSXNheVD0AIfKaFc+j3A2/2tp6lSnLuS4nnZgfqfTbhv2MHRMf1MlAeARX4C47W/dGBizGJi0Z5q3mUmaVKI9Yh3YVpIDXWpc8//KujnyQsQd1ZlUkvRBisKvfvYY9WQGN/Ana/PWzwsXSZg5hmgVbO4AUJ681Wd0OkIQgSFbALuXzOG+Z0qvNXpPb6rPeegmnEPZh5Hw5OlLwriZkELRjV+GayXrUPMBckWXN/ayHuQnOAUmSxOcmIlNE6Hp3SAMjUlk7+/0mHGg//8Y/hTgqhIT8Y9dg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kIpIJ-0008Cz-0O
        for linux-raid@vger.kernel.org; Thu, 17 Sep 2020 08:29:31 +0000
Date:   Thu, 17 Sep 2020 08:29:30 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: "--re-add for /dev/sdb1 to /dev/md0 is not possible"
Message-ID: <20200917082930.GB23197@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <20200915102736.GE13298@bitfolk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915102736.GE13298@bitfolk.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 15, 2020 at 10:27:36AM +0000, Andy Smith wrote:
> mdadm: --re-add for /dev/sdb1 to /dev/md6 is not possible
> 
> So, is that supposed to work and if so, why doesn't it work for me?
> 
> In both cases these are simple two device RAID-1 metadata version
> 1.2 arrays. Neither has bitmaps.

The lack of bitmaps was why I couldn't use --re-add. I was testing
with small arrays that didn't get a bitmap by default. As mentioned
on the wiki, a bitmap can be added like:

# mdadm --grow --bitmap=internal /dev/mdX

So, as pointed out to me by Jakub Wilk, it is possible to remove the
bad blocks log on a running array by failing and re-adding each
device in turn, as long as you are willing to experience lower / no
redundancy while it rebuilds.

# mdadm --fail /dev/md0 /dev/sdb1 \
        --remove /dev/sdb1 \
        --re-add /dev/sdb1 \
        --update=no-bbl

Cheers,
Andy
