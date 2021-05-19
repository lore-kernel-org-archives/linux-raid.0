Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660F0C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 14:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4665961244
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 14:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbhESOWB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 10:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347519AbhESOVu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 May 2021 10:21:50 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AE0C0613ED
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 07:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9peY4wuDmh1FJYn4OFWlZeGpdWqnwYzuEECfh6OOvLM=; b=eXb+2u4GSYI5FTZnKby9njIaNc
        UT81eWgpC6E3rfeCGv75ZXB23YiKkQ9JVNVKa9/Eqmjf2XmgDnBl2Uo4rcp7NsN8dalwPqoo0eEt+
        nZ4E6s/Hs5b94kCsQdEwsn/c6rP2UFqGWfq4dXmcuFMGluEWHoPQhK0RboOBPJWXt7AZqQKXvy8Hz
        G5UXh8WrTJqJyWCZJpX1gkUFIqzLUVhXV1J5BTxJ59poa4DK+ZSvrXqkpQr3ezQa+6wfss21JkJC+
        y46XCORapVXezOyXAmEU40yr0aIU8AHyJa5S4SZH2hOgu2JtaOw+Fhph4yfIg9TOEWuYBi0ZC/jZA
        2gbvlXaw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1ljN3j-0001y5-AX
        for linux-raid@vger.kernel.org; Wed, 19 May 2021 14:20:27 +0000
Date:   Wed, 19 May 2021 14:20:27 +0000
From:   Andy Smith <andy@strugglers.net>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: My superblocks have gone missing, can't reassemble raid5
Message-ID: <20210519142027.o6qob6po43aaahcc@bitfolk.com>
Mail-Followup-To: Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
 <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
 <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
 <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
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

On Wed, May 19, 2021 at 08:20:19AM -0500, Leslie Rhorer wrote:
> 1. Partitioning is not necessary.  Doing something that is not necessary is
> not usually worthwhile.

I'm with you in that I prefer not to use partitions when I don't
need to.

However, there are many reports of people suffering corrupted disks
that ended up being due to their motherboard helpfully deciding that
if it sees a disk with no MBR nor GPT then it should create its own
at every boot.

    http://forum.asrock.com/forum_posts.asp?TID=10174&title=asrock-motherboard-destroys-linux-software-raid

So, I'm not going to rail against anyone who prefer to always
partition.

Cheers,
Andy
