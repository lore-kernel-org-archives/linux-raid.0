Return-Path: <SRS0=mN13=CW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2580AC43461
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 12:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D410421548
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 12:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgIMMud (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 13 Sep 2020 08:50:33 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:42736 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgIMMu3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 13 Sep 2020 08:50:29 -0400
Received: from quad.stoffel.org (066-189-075-104.res.spectrum.com [66.189.75.104])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id F03771F125;
        Sun, 13 Sep 2020 08:50:27 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 50771A666B; Sun, 13 Sep 2020 08:50:27 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24414.5523.261076.733659@quad.stoffel.home>
Date:   Sun, 13 Sep 2020 08:50:27 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     antlists <antlists@youngman.org.uk>
Cc:     John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
Subject: Re: Linux raid-like idea
In-Reply-To: <9ba44595-8986-0b22-7495-d8a15fb96dbd@youngman.org.uk>
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
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "antlists" == antlists  <antlists@youngman.org.uk> writes:

antlists> On 12/09/2020 18:28, John Stoffel wrote:
>> I had one of my 4tb disks fall out of my main VG, but I didn't lose
>> and data, I just checked the disk and added it back in.  I've got a
>> new 4tb disk on order along with a drive cage so I can balance things
>> better.
>> 
>> But it's almost to the point where it's cheaper to buy a pair of 8tb
>> drives to replace the 4x4tb drives I'm using now.  But I probably
>> won't.
>> 

antlists> You should have bought an 8TB to replace the 4 ... one more
antlists> failure :-( and you would have your 2x8 (and raid-0 the
antlists> remaining 4s to provide your 3rd mirror).

I know, I really need to buy another drive, but my main system is
full, so I *also* need to either get a new case, or one of those 5 x
3.5" into 3 x 5.25" bay cages to make some room.  Decisions... decisions...

>> I could  write for hours here... it's a tough problem space to work
>> through.

antlists> Made worse if, like me, you're more into logical
antlists> completeness than "will it finish in finite time" :-)

For sure!
