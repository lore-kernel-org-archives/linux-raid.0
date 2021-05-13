Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A65C433ED
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 15:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D8DF6142E
	for <linux-raid@archiver.kernel.org>; Thu, 13 May 2021 15:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbhEMPji (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 May 2021 11:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbhEMPjf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 May 2021 11:39:35 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F5C061574
        for <linux-raid@vger.kernel.org>; Thu, 13 May 2021 08:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3zznT7CHTwaVKEBOzE62uWSvW2WU702Ae8S06xMfPh4=; b=VyAJ7jc0DDDpoGdOJlJH4cBhfU
        qFoRzY6xAVGjqD11RswomCfmrAFWXQtOm57jNXTONkZFxth0TtL8dc9jBIfr1H4zBtRYuD+p+gPFM
        6WCsN0y/xpo8cD6fDcPY6T+d8t31ZdcxE6C6rkWTDq7rI2YT71zWZMAEOqvha7GD+UYPzrgJJLfjL
        2Jci2O1OadpaEO3cvS41u1yep6UPdaUNPqcmUsnIIY7YUOOoAYrl6cq/tIvQV/q9lWkOxelw0Sz/p
        d9G8kAbfLtUPhyYEDYW3snsqAXwUYRD2TwTiX3i6GpaLAAq8LCXyysQ9nYNi8PryA/mgt93xYrC+R
        GwfgBqpQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1lhDPq-0005gH-KO
        for linux-raid@vger.kernel.org; Thu, 13 May 2021 15:38:22 +0000
Date:   Thu, 13 May 2021 15:38:22 +0000
From:   Andy Smith <andy@strugglers.net>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210513153822.n74ezf5jav3ywuqn@bitfolk.com>
Mail-Followup-To: list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
 <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
 <20210508134726.GA11665@www5.open-std.org>
 <87y2co1zun.fsf@vps.thesusis.net>
 <20210512172242.GX1415@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512172242.GX1415@justpickone.org>
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

On Wed, May 12, 2021 at 01:22:42PM -0400, David T-G wrote:
> RAID10 is striping AND mirroring (leaving out for the moment the distinction
> of striping mirrors vs mirroring stripes).  How can one have both with only
> two disks??  You either stripe the two disks together for more storage or
> mirror them for redundant storage, but I just don't see how one could do both.

Linux RAID-1 is a mirror - all devices are identical. A reading
thread picks a device and reads from it. You get up to 1 device
worth of IOPS.

Linux RAID-10 splits the data into chunks and stripes them across
the devices with as many copies as desired (default 2). So a single
threaded reader can get up to n devices worth of IOPS.

When n is 2 and there's only 2 identical devices and the load is
multi-thread/process then you may not see much difference. Measure
it and let us know!

Cheers,
Andy
