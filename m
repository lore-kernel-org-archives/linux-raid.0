Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C21C49EA6
	for <linux-raid@archiver.kernel.org>; Thu, 24 Jun 2021 16:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215CD613C2
	for <linux-raid@archiver.kernel.org>; Thu, 24 Jun 2021 16:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhFXQmL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Jun 2021 12:42:11 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:33452 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhFXQmL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Jun 2021 12:42:11 -0400
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 9F31A288A6;
        Thu, 24 Jun 2021 12:39:51 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id EA39DA71C3; Thu, 24 Jun 2021 12:39:50 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24788.46422.901912.368152@quad.stoffel.home>
Date:   Thu, 24 Jun 2021 12:39:50 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     antlists <antlists@youngman.org.uk>
Cc:     John Stoffel <john@stoffel.org>,
        Bill Hudacek <bill.hudacek@gmail.com>,
        mdraid <linux-raid@vger.kernel.org>
Subject: Re: Question: RAID cabinet for home use
In-Reply-To: <1986d43d-11e9-fbf0-7812-0aafc6568855@youngman.org.uk>
References: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
        <24787.28117.662584.586506@quad.stoffel.home>
        <1986d43d-11e9-fbf0-7812-0aafc6568855@youngman.org.uk>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "antlists" == antlists  <antlists@youngman.org.uk> writes:

antlists> On 23/06/2021 18:22, John Stoffel wrote:
>> If you have space inside your main computer, then I would look into an
>> LSI Logic MTP Fusion SATA/SAS controller with 8 ports.  Then you can
>> use some of the "IcyDock" expansion bays inside which turns two or
>> three 5.25" bays into 4-5 3.5" bays.

antlists> If that's the route you're looking at, I'm trying to source
antlists> a Cooler Master N300 case, which takes EIGHT 3.5"
antlists> drives. Most of them are internal so hotswap is out of the
antlists> question, though.

I did more serious looking last fall, but supplies were low and
hot-swap bays start to get expensive and I don't really need them.
Wanting is another story.  :-)

antlists> Dunno what's happened with the cases - have they dropped the
antlists> line? Or has CoVid just exhausted current supplies?

I think Covid has messed up supply lines and such.  It's going to be a
while before things are normal again.

I'm almost tempted to try and goto a local used computer place and see
what they have for big old cases.  
