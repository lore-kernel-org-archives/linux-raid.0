Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BDCC4743C
	for <linux-raid@archiver.kernel.org>; Wed, 23 Jun 2021 17:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D7B611AC
	for <linux-raid@archiver.kernel.org>; Wed, 23 Jun 2021 17:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWRb3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Jun 2021 13:31:29 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:56650 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWRb3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Jun 2021 13:31:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2021 13:31:29 EDT
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id C4D402468D;
        Wed, 23 Jun 2021 13:22:30 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id B60DCA71B9; Wed, 23 Jun 2021 13:22:29 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24787.28117.662584.586506@quad.stoffel.home>
Date:   Wed, 23 Jun 2021 13:22:29 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Bill Hudacek <bill.hudacek@gmail.com>
Cc:     mdraid <linux-raid@vger.kernel.org>
Subject: Re: Question: RAID cabinet for home use
In-Reply-To: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
References: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Bill" == Bill Hudacek <bill.hudacek@gmail.com> writes:

Bill> My 2021 Sans Digital TR5UT+B held 5 SATA disks. I had an eSATA 
Bill> connection to the host box. It went belly-up a few weeks ago.

Bill> After some careful searching, a good replacement seemed to be the Oyen 
Bill> Digital Mobius 3R5-EB3-M. Found it for about $300USD.

Bill> It was plug-and-play replace. Drives were being addressed by
Bill> UUID in Fedora so no issues at all. It came right up.

Excellent!

Bill> However, smart reporting looks horrible even compared to the
Bill> TR5UT+B (which had its own issues).

I think this all comes down to the eSATA bridge chip used in the
expansion bay.  Not much you can do about it. 

Bill> What RAID cabinets would be a better alternative? I have 5
Bill> drives but an 8-bay cabinet would work too.

I think what you're looking for isn't really a "RAID Cabinet" but an
"Expansion Bay", which has full SATA passthrough.

If you have space inside your main computer, then I would look into an
LSI Logic MTP Fusion SATA/SAS controller with 8 ports.  Then you can
use some of the "IcyDock" expansion bays inside which turns two or
three 5.25" bays into 4-5 3.5" bays.

Each bay has it's own direct connection to the controller, which is a
good thing, since you'll have full access to the drives.

The controllers are cheap on ebay, and you can even use multiple ones
(if you have the room) to give even more redunacy and performance.

Personally, I've been looking into getting a 4U server case with 12
3.5" hot swap bays, but they're all either A) out of stock or B) don't
have USB3 ports on them.  Life is all about tradeoffs.

The problem with IcyDock and other bays like this is A) heat, B) poor
fans, C) price, D) cheap handles, E) reliability.

If you don't hot-swap often, then I think you'll be ok (as will I when
I finally pull the trigger for my own setup) if you are careful when
using them.

I have a USB3/eSATA external case which holds five drives, but it
flakes out if I put in more than two drives.  Ugh!  Doing this well
can require spending some serious money.  I personally just like
getting a big huge case with lots of drive bays and plugging stuff in
directly.  It's my home system, so it can go down when needed.

I'm not at the system, so getting you model number isn't easy.  But
look in the archives of this list, there have been good discussions in
the past year or so on controllers and such.

John
