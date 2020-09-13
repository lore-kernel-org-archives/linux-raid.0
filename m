Return-Path: <SRS0=mN13=CW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D30C433E2
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 16:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE7020829
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 16:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgIMQBi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 13 Sep 2020 12:01:38 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:9492 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgIMQBf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 13 Sep 2020 12:01:35 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kHURY-000520-6L; Sun, 13 Sep 2020 17:01:33 +0100
Subject: Re: Linux raid-like idea
To:     John Stoffel <john@stoffel.org>
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
Cc:     linux-raid@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <5F5E425B.3040501@youngman.org.uk>
Date:   Sun, 13 Sep 2020 17:01:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <24414.5523.261076.733659@quad.stoffel.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/09/20 13:50, John Stoffel wrote:
> I know, I really need to buy another drive, but my main system is
> full, so I *also* need to either get a new case, or one of those 5 x
> 3.5" into 3 x 5.25" bay cages to make some room.  Decisions... decisions...

I know I keep on saying it, but I really think I'm close to getting my
new main system (and hence my development system) sorted, and I think I
need to buy one of those cages too.

If you did get those two 8TB drives, you could still have your 8TB 3-way
mirror without needing any more bays/sata-ports.

My problem, of course, is if I'm playing with raid layouts I need as
many disks as I can cram in :-) I'm counting 6 tucked away in my drawer,
which means I'll almost certainly need to add an add-in 4-way sata card,
and as those drives are a mixture of 500GB and 1TB, I'll probably split
the 1TBs into 2x500GB and ignore md complaining that I have multiple
components on the same physical disk ...

Cheers,
Wol
