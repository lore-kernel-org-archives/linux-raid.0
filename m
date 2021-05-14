Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07869C433B4
	for <linux-raid@archiver.kernel.org>; Fri, 14 May 2021 14:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE997613BE
	for <linux-raid@archiver.kernel.org>; Fri, 14 May 2021 14:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhENOik (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 May 2021 10:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbhENOii (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 May 2021 10:38:38 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D854C061574
        for <linux-raid@vger.kernel.org>; Fri, 14 May 2021 07:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sMgR26ZAMfk33zp/8s9FUHe2Oe5emjK8KB89MvIeDPs=; b=fqgf7FHhIlfJEOGuWmG2Uzrpy2
        1hTKxpmx2oV8j5+sJ9Uhihmhmmy1G5vzDGg8yGf+zPCva2hUfwrO/iqNOgp8UsTPBIL19qFUn1+G+
        l8uHeTKYk02ybH/UjjKoXHqLAAuvZ9TSMC1qjejTvcoVavI24mPyXwlQhvux4XlXN3hINNZv9uqyo
        FUCJgLMHfCYDMfD86ZH4HWfEE5Jre+ZPQ9HS2LY3g/EK3XLTUw6rvMbO4xm6+H4MY/EdSejfMmleS
        0/GHEazceDqQJRlZEtElvWFQeV8O2qJQaXg7F7NFcd2sE3hmnZAzhxAzUo3NFdXDfYdtuK7bnaAP4
        epai1pCQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1lhYwP-0001Xq-BW
        for linux-raid@vger.kernel.org; Fri, 14 May 2021 14:37:25 +0000
Date:   Fri, 14 May 2021 14:37:25 +0000
From:   Andy Smith <andy@strugglers.net>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210514143725.qaezymawflfybjv3@bitfolk.com>
Mail-Followup-To: list Linux RAID <linux-raid@vger.kernel.org>
References: <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
 <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
 <20210508134726.GA11665@www5.open-std.org>
 <87y2co1zun.fsf@vps.thesusis.net>
 <20210512172242.GX1415@justpickone.org>
 <877dk2r5s3.fsf@vps.thesusis.net>
 <20210513155956.6m6yek3t4ln464bw@bitfolk.com>
 <871ra95qxg.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ra95qxg.fsf@vps.thesusis.net>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Phillip,

On Fri, May 14, 2021 at 10:28:52AM -0400, Phillip Susi wrote:
> Andy Smith writes:
> > While the *layout* would be identical to RAID-1 in this case, there
> > is the difference that a single threaded read will come from both
> > devices with RAID-10, right?
> 
> No, since the data is not striped, you would get *worse* performance if
> you tried to do that.

Are you absolutely sure about this? Previous posts from Neil and
others seem to contradict you:

    https://www.spinics.net/lists/raid/msg47219.html
    https://www.spinics.net/lists/raid/msg47240.html

and what I have tested and observed in the past backs up the theory
that a single threaded read against a Linux RAID-10 can use n
devices whereas a single-threaded read against Linux RAID-1 will
only use 1 device.

Cheers,
Andy
