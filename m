Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B1BC433B4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 15:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F8C61006
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 15:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhEGPNW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 May 2021 11:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhEGPNV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 May 2021 11:13:21 -0400
X-Greylist: delayed 1147 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 07 May 2021 08:12:22 PDT
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01128C061574
        for <linux-raid@vger.kernel.org>; Fri,  7 May 2021 08:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MsMHzzbmYrNEl7c/G3IoF/MqRKfd+qHpyCbvfzm7BRU=; b=0c6j6MOElGmLwcv/v9bavx9Xk+
        gjeeL4hfBsVgLwPvg2G8iD60fljxpHFjKAIbZwZNjzeVWnBK7RJJ8Ahghn7J0V9hkW5Sot/rjqPMk
        zrzYaP52c7wLYPnkFJLHi4/z1GDzXTTQhfkA/QBat2g3kkfiUDU3TcT2+ZPk3LChZ2OtAHj+1ZbXy
        aqm9zc9/yhLY1iqTYhggbeBZcj/YG5xbMKxpSVW57kx58qa1PZCdWXEbOtZo7UrfiWJVgChVbY1cK
        jT0+argC32yYXnSZMhkOZEhIFTmQquJQOD3YIbckO8GzuWfUSMX7Ds6JhbnbJYBnW0fPmf/xqUMeO
        0XTzXkzw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1lf1qq-0002aY-Ca
        for linux-raid@vger.kernel.org; Fri, 07 May 2021 14:53:12 +0000
Date:   Fri, 7 May 2021 14:53:12 +0000
From:   Andy Smith <andy@strugglers.net>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
Message-ID: <20210507145312.qjrvho4m64s3uz3t@bitfolk.com>
Mail-Followup-To: list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <871rakovki.fsf@vps.thesusis.net>
 <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
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

On Fri, May 07, 2021 at 09:47:39AM +0800, d tbsky wrote:
> I thought someone test the performance of two ssd, raid-1 outperforms
> all the layout. so maybe under ssd it's not important?

If you're referring to this, which I wrote:

    http://strugglers.net/~andy/blog/2019/06/01/why-linux-raid-10-sometimes-performs-worse-than-raid-1/

then it only matters when the devices have dramatically different
performance. In that case is was a SATA SSD and an NVMe, but
probably you could see the same with a rotational HDD and a SATA SSD.

Also, it was a bug (or rather a missing feature). RAID-10 was
missing the ability to choose to read from the least loaded device,
so it's the difference between getting 50% of your reads from the
much slower device compared to hardly any of them.

And Guoqing Jiang fixed it 2 years ago.

Cheers,
Andy
