Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5232CC83018
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A7F21D7A
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bitfolk.com header.i=@bitfolk.com header.b="UDXeWgY8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389936AbgK1VuS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387757AbgK1VAY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 28 Nov 2020 16:00:24 -0500
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2BFC0613D1
        for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2020 12:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=dGsEDecFNZWjrMYn5uHYdjUr9zcCvzf51LUyvBujP/g=;
        b=UDXeWgY84dqJDHi6hP7t8Mtr8xNdtWyX8AenS5u5dJVQXTguZ/OFYbriM/EYm7dMzKLIXk8CPRAM7gVTnSoSzpQF0zF4nAyhuby+6m7+xLEABg3KFQq2Go1ICZ73+/EriOk5xgFWjrmu66Dc3mdAjkNHTx3hLjPAXAa3G5rr9QIO8tnuqtA2rbPxEAyqUQVAAuHlXMrfiFGgCtPqofubJQ2FCjRIKPLFl3/o2qb8Nh/T1W25ZOaaw9gzmE/5xLcvtyGiFgdHXWSZWX9M05i893mnwnIfBfOVTGCv/KYDyjExsg9RO+f5SWHo7MYSHBiKQKX9LVs8BJev3LkBlNqspg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kj7Jx-0001q0-2g; Sat, 28 Nov 2020 20:59:53 +0000
Date:   Sat, 28 Nov 2020 20:59:53 +0000
From:   Andy Smith <andy@strugglers.net>
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Config option for removing bbl on assembly?
Message-ID: <20201128205953.GJ16071@bitfolk.com>
Mail-Followup-To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <20200904074557.GT13298@bitfolk.com>
 <1375483028.8430464.1606594500693.JavaMail.zimbra@karlsbakk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375483028.8430464.1606594500693.JavaMail.zimbra@karlsbakk.net>
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

On Sat, Nov 28, 2020 at 09:15:00PM +0100, Roy Sigurd Karlsbakk wrote:
> Will anyone look into this issue, please? It really is a problem.

Since it seems you can remove the BBL by removing and re-adding a
device I no longer see a need for a new option that removes it on
assembly.

Ideally I remember to do the remove and re-add before the machine is
put into service, but failing that just doing a remove and re-add
one time seems reasonable enough.

Cheers,
Andy
