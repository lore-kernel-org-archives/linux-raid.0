Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4B7C64E8A
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C9F21527
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bitfolk.com header.i=@bitfolk.com header.b="nKgi1Zo8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbgK1VuR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387609AbgK1TwP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 28 Nov 2020 14:52:15 -0500
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DE9C0613D1
        for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2020 11:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=QGBdELbSlrhrWgrOpNdibMEfeOCFNWXxl1d9YEPZGZ0=;
        b=nKgi1Zo8vNWIXECJ4/2mrcROfy3LX7wUwoDxqRy3rxkQkVYak379TuyrZhqQmnoenmFTnzU8EO9YQ8+n90SbzYQuSQt9O7oiJT5i+KWYI/K5FGhENu5ZVdNaMI6GYYdI5OFoVl3y5T6prn9LE2s7Bcju6vL/Tzszabe2vprdf29hRUXVvdcpiAGy+mDSbayQgmglA4P24yndPrNr4GStcZslDc3qUWWbruKCH6it1HpXC7qBgQZq+V6PDca8pMmqjzEyHNgtBvkwqnMGvDTnYYPZHL/JH9r9YuMuVBK0+nh9Utc7wGlSZTSt47sKcYwR7PyZBWmzVl+PydC8INi7cQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kj6Fo-0007vS-70; Sat, 28 Nov 2020 19:51:32 +0000
Date:   Sat, 28 Nov 2020 19:51:32 +0000
From:   Andy Smith <andy@strugglers.net>
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: "--re-add for /dev/sdb1 to /dev/md0 is not possible"
Message-ID: <20201128195132.GI16071@bitfolk.com>
Mail-Followup-To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <20200915102736.GE13298@bitfolk.com>
 <913919976.4679345.1600770460519.JavaMail.zimbra@karlsbakk.net>
 <13ffabf0-b848-c29a-eee6-d017e569f098@youngman.org.uk>
 <52711994.8373999.1606586365403.JavaMail.zimbra@karlsbakk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52711994.8373999.1606586365403.JavaMail.zimbra@karlsbakk.net>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Roy,

On Sat, Nov 28, 2020 at 06:59:25PM +0100, Roy Sigurd Karlsbakk wrote:
> Will anyone look into this issue, please? It really is a problem.

You already did ask once and got the response to get on with it and
let everyone else know; asking further times isn't going to get
anywhere so I suggest you do what is within your power to do.

If the option of coding the fix yourself is not available and you
can't convince (or pay?) someone else to do it, I guess that just
leaves you with the option of disabling BBL.

At least we did go through this before and established that it's
possible to do without downtime, though with short period of loss of
redundancy.

Cheers,
Andy
