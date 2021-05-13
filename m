Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AECC433B4
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 16:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E2B613BC
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 16:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhEMQBJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 May 2021 12:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhEMQBI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 May 2021 12:01:08 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EC9C061574
        for <linux-raid@vger.kernel.org>; Thu, 13 May 2021 08:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HGUfMpBD++IBLEw/N/T4gYBARRFjJrepY5XwksyMkVA=; b=jHmofaeK7JUJi3sdRW1WAZiUV7
        P9hU2sXjU5R5VnF4coqltHkSdMMO4IcU6aCWbqh6+NpFVYUiaXd5L3VanHU1KjlnXN/sCKdRiQAVZ
        UzE1SmBAQf4ExSu6JbzNqABLpk6cbER+pxx+H2Fq7WtMY+PG6wUo6yyeqY0P0T3ERKc1jxeBOB5Y8
        ByUTue0rheZIoo9r+cS35Id+hE6fftdTEyZnBPq73xxjChBbyjZ7n/2dP33Pb5nHEDfy/oxXJuoBr
        j51oRftACIDnu2cqkl9/3co3jSIw/M6oSv691WArPdyUdAlVfPBCuMgt5gBG44ICk27uokJYU4tyJ
        +OGdOQ8Q==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1lhDki-0006aB-RZ
        for linux-raid@vger.kernel.org; Thu, 13 May 2021 15:59:56 +0000
Date:   Thu, 13 May 2021 15:59:56 +0000
From:   Andy Smith <andy@strugglers.net>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210513155956.6m6yek3t4ln464bw@bitfolk.com>
Mail-Followup-To: list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
 <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
 <20210508134726.GA11665@www5.open-std.org>
 <87y2co1zun.fsf@vps.thesusis.net>
 <20210512172242.GX1415@justpickone.org>
 <877dk2r5s3.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dk2r5s3.fsf@vps.thesusis.net>
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

On Thu, May 13, 2021 at 11:46:42AM -0400, Phillip Susi wrote:
> 
> David T-G writes:
> 
> > RAID10 is striping AND mirroring (leaving out for the moment the distinction
> > of striping mirrors vs mirroring stripes).  How can one have both with only
> > two disks??  You either stripe the two disks together for more storage or
> > mirror them for redundant storage, but I just don't see how one could do both.
> 
> In the default near layout, you don't get the striping with only two
> disks; it is identical to raid1.

While the *layout* would be identical to RAID-1 in this case, there
is the difference that a single threaded read will come from both
devices with RAID-10, right?

Cheers,
Andy
