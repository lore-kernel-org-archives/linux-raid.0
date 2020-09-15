Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DF6C43461
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 02:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5C020678
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 02:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgIOCMR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 22:12:17 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:51572 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOCMR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Sep 2020 22:12:17 -0400
Received: from quad.stoffel.org (066-189-075-104.res.spectrum.com [66.189.75.104])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id ADEF625522;
        Mon, 14 Sep 2020 22:12:15 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 2049AA6683; Mon, 14 Sep 2020 22:12:15 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <24416.8959.80816.985785@quad.stoffel.home>
Date:   Mon, 14 Sep 2020 22:12:15 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
Subject: Re: Linux raid-like idea
In-Reply-To: <f9144d16-3c8d-821c-c951-1fb5e6a7d317@aim.com>
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
        <f9144d16-3c8d-821c-c951-1fb5e6a7d317@aim.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Brian" == Brian Allen Vanderburg <brianvanderburg2@aim.com> writes:

Brian> OT, but I've got one of those 3x5.25 to 5x3.5 hot swap bays in
Brian> my main system and I love it.  I'm using it with an LSI 9207-8i
Brian> as my motherboard only supports a few SATA connectors with
Brian> several already used, so needed something to provide more ports
Brian> for future expansion for my main system's storage.

Very much like what I'm doing with my LSI board providing most of my
data storage, with boot disks (mirrored) on the MB SATA ports.  Makes
for a simpler setup.

Brian> For more drives, you can use one of those external drive shelf
Brian> boxes.  I currently have the HP M6710 I got off eBay with all
Brian> caddies for about $100, which can house 24 2.5 hard drives in a
Brian> 2U chassis and I've used an LSI 9201-16e to access it (both
Brian> HBAs flashed to 20.00.07 or something like that).  I've already
Brian> tested it and it works great, though a bit loud on the fans
Brian> when powering on.  My understanding is also if you have more
Brian> than one of these shelves you can daisy chain them via their
Brian> ports SAS card -> Shelf 1 -> Shelf 2, etc, even cycling back to
Brian> the SAS card for multi-path support (which is at the time over
Brian> my head).  My plan for it is to put in my network closet once I
Brian> get it cleaned out and cabling ran better to provide
Brian> whole-house NAS storage.  I think there is also an M6720 model
Brian> for 24 3.5 drives in a 4U chassis.  There is also NetApp shelf
Brian> I was looking at but from reading looks like it uses a QSFP
Brian> connector on it's IOM, and the cables that converted from
Brian> SFF-8088 were quite expensive.

This is a nice idea, just not sure I want to go with 2.5" drives since
they're expensive per TB of storage.  I just want one of those old
style monster cases with 8 x 5.25" bays so I can fill it with 3.5"
bays.  Or there was a review on Phoronix.com about a 4U chassis that
looked pretty good, esp with USB3 front ports.

