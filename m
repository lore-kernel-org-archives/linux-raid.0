Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FE1C433E2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 18:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66E7320738
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 18:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgIOSI1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:08:27 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:55942 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgIOSHW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 14:07:22 -0400
Received: from quad.stoffel.org (066-189-075-104.res.spectrum.com [66.189.75.104])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 37CA320DF0;
        Tue, 15 Sep 2020 14:07:11 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id B5C8DA6689; Tue, 15 Sep 2020 14:07:10 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24417.718.670043.535084@quad.stoffel.home>
Date:   Tue, 15 Sep 2020 14:07:10 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     John Stoffel <john@stoffel.org>,
        Wols Lists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Linux raid-like idea
In-Reply-To: <CAAMCDefi-Y8joeobCJt-9_a8cDpeVWDsfGeVxXFWuQiwH2G0JQ@mail.gmail.com>
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
        <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
        <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
        <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
        <5F54146F.40808@youngman.org.uk>
        <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
        <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
        <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
        <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
        <24413.1342.676749.275674@quad.stoffel.home>
        <9ba44595-8986-0b22-7495-d8a15fb96dbd@youngman.org.uk>
        <24414.5523.261076.733659@quad.stoffel.home>
        <5F5E425B.3040501@youngman.org.uk>
        <24416.8802.152441.102558@quad.stoffel.home>
        <CAAMCDefi-Y8joeobCJt-9_a8cDpeVWDsfGeVxXFWuQiwH2G0JQ@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Roger" == Roger Heflin <rogerheflin@gmail.com> writes:

>> I've been looking at them for a while now, but hesitating
>> because... not sure why.  I'm using a CoolerMaster case with five
>> 5.25" bays, plus a 3.5" bay external, and another three or four
>> internal 3.5" bays.  Works great.  Nice and plain and not flashing
>> lights or other bling.  And not too loud either.  Which is good.
>> 
>> But I've used crappy drive cages before, crappy hot swap ones.  Not
>> good.  And I think it's time I just went with a 4U rack mount with a
>> bunch of hot swap bays, if I could only find one that wasn't an arm
>> and a leg.
>> 

Roger> I have had good luck with the ICY DOCK brand how swap I have 4
Roger> different 4 bay-3bay ones spanning 6+ years and they all seem
Roger> to just work.  And each newer version seemed to have improved
Roger> design from the prior ones (plugs easier to get to, and such).

Thanks for the recommendation!  I'll be looking at these for
sure. Just wish my case could hold two of them.  It would be nice if
they made a 2.5 x 5.25" to 4 x 3.5" disk carrier, so I could stuff two
of them into my 5 exposed 5.25" bays.  *grin*
