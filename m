Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8DCC433DB
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 02:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CF1F23159
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 02:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbhALCES (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Jan 2021 21:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbhALCER (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Jan 2021 21:04:17 -0500
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAF5C061575
        for <linux-raid@vger.kernel.org>; Mon, 11 Jan 2021 18:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date; bh=x6WnEUA7+yGWJlBP9H2A45ipBgwXk7eREBBzV2ILWP4=;
        b=srw0Ddncn2zpxv2UgptGCbluFjqUKSe83Ux4uTuKY/JiNWxSTeHIkdkvqLfUI/ELg+4cVEMZb4HRb6yl+kQGLV6uR8q+ixRtRUk03D1AQgS6+AP9USovo0l7qMqALhPi/otXI6FJx/7Q5w2xicgDQ6tSOd0I7IFtae3Gsq+4KUSIrtGDLF6o6AXF9MWf+CB3ikm4HvBtvLytdwj/Xx8FyrQY7ecJjxQPiekbOdPkDMX3mbA41Wiy2fZfECdUJSZsFHEBczDSg8zydazw04MfHgvZsZa3jL4n1xflFmqXoCHsGHAmEI6LxQXz5hDWeQ8FiLy+Xmg3hj8ydmyJTxMSMA==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kz920-000156-1v
        for linux-raid@vger.kernel.org; Tue, 12 Jan 2021 02:03:36 +0000
Date:   Tue, 12 Jan 2021 02:03:36 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: "md/raid10:md5: sdf: redirecting sector 2979126480 to another
 mirror"
Message-ID: <20210112020336.GJ3712@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <20210106232716.GY3712@bitfolk.com>
 <a5c10248-9835-dec9-2ac2-a72b9a49deff@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5c10248-9835-dec9-2ac2-a72b9a49deff@cloud.ionos.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guoqing,

Thanks for following up on this. I have a couple of questions.

On Tue, Jan 12, 2021 at 01:36:55AM +0100, Guoqing Jiang wrote:
> On 1/7/21 00:27, Andy Smith wrote:
> >err_rdev there can only be set inside the block above that starts
> >with:
> >
> >     if (r10_bio->devs[slot].rdev) {
> >         /*
> >          * This is an error retry, but we cannot
> >          * safely dereference the rdev in the r10_bio,
> >          * we must use the one in conf.
> >
> >…but why is this an error retry? Nothing was logged so how do I find
> >out what the error was?
> 
> This is because handle_read_error also calls raid10_read_request, pls see
> commit 545250f2480 ("md/raid10: simplify handle_read_error()").

So if I understand you correctly, this is a consequence of
raid10_read_request being reworked so that it can be called by
handle_read_error, but in my case it is not being called by
handle_read_error but instead raid10_make_request and is incorrectly
going down an error path and reporting a redirected read?

From my stack trace it seemed that it was just
raid10.c:__make_request that was calling raid10_read_request but I
could not see where in __make_request the r10_bio->devs[slot].rdev
was being set, enabling the above test to succeed. All I could see
was a memset to 0.

I understand that your patch makes it so this test can no longer
succeed when being called by __make_request, meaning that aside from
not logging about a redirected read it will also not do the
rcu_read_lock() / rcu_dereference() / rcu_read_unlock() that's in
that if block. Is that a significant amount of work that is being
needlessly done right now or is it trivial?

I'm trying to understand how big of a problem this is, beyond some
spurious logging.

Right now when it is logging about redirecting a read, does that
mean that it isn't actually redirecting a read? That is, when it
says:

Jan 11 17:10:40 hostname kernel: [1318773.480077] md/raid10:md3: nvme1n1p5: redirecting sector 699122984 to another mirror

in the absence of any other error logging it is in fact its first
try at reading and it will really be using device nvme1n1p5 (rdev)
to satisfy that?

I suppose I am also confused why this happens so rarely. I can only
encourage it to happen a couple of times by putting the array under
very heavy read load, and it only seems to happen with pretty high
performing arrays (all SSD). But perhaps that is the result of the
rate-limited logging with pr_err_ratelimited() causing me to only
see very few of the actual events.

Thanks again,
Andy
