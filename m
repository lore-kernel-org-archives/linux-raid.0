Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B468CC4338F
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 20:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9305D60E78
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 20:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhGXUAL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 24 Jul 2021 16:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGXUAI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 24 Jul 2021 16:00:08 -0400
X-Greylist: delayed 1138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 24 Jul 2021 13:40:35 PDT
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07291C061575
        for <linux-raid@vger.kernel.org>; Sat, 24 Jul 2021 13:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Y5giB6quq/FeVDR+yubNS92IlE+aFcRWBBnavfnUEDo=; b=OJMGXjX7XtVB8WG3NHUhuVjnwt
        ShC4p43vVC0qkKGVd5URxApYRP7G6sZD7wC3sXri1kBvFgueMyZr9WnoN7G5XmAmsxKediqQ5IBeM
        xm763BF9l1yDrcNNPNKzzZD/BNIfL2j78NeWiEVdYAA9Ba1aUJ+1ucSJGCM9w0tidt3t3x08tBYWP
        kGgW36bb9g5a8NacDCfX9ncTNy9DSJUNwPTEaMNJMoOazaa1NLEmR3XR/lSdzG7L/Txj7svS9bAWw
        XF2E/5An8mqVcuedRRKnk0CZbTAwe1aZlehd7FjlqMBaB2Ay2ob0ySO+1hnsYt1o8uPhz1pCw7p2f
        9x2MGovw==;
Received: from b2b-37-24-20-172.unitymedia.biz ([37.24.20.172] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1m7O9O-004iLD-PM   id 1m7O9O-004iLD-PMby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Sat, 24 Jul 2021 20:21:34 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1m7O6x-002cpS-2J
        for <linux-raid@vger.kernel.org>; Sat, 24 Jul 2021 22:19:03 +0200
Message-ID: <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
Date:   Sat, 24 Jul 2021 22:19:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
In-Reply-To: <2232919.g0K5C1TF2C@chirone>
References: <2232919.g0K5C1TF2C@chirone>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@list.for.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> the recovery time in case of media errors could exceed kernel
> timeouts and possibly kick off the entire drive from the RAID
> set and, in turn, lead to a fault of a RAID5 system upon a
> subsequent error in a second drive.

My understanding seems different:

* The purpose of having a short device error retry period is the
  opposite, it is to fail a drive as fast as possible, in
  workloads where latency matters ( or there is also the risk of
  bus/link resets hitting multiple drives). In those cases error
  retry periods of 1-2 seconds (at most) are common, rather than
  the mid-way "7 seconds" from copy-and-paste from web pages..

* The purpose of having a long device error retry is to instead
  to minimize the chances of declaring a drive failed, hoping
  that many retries succeed. (but note the difference between
  reads and writes).

* It is possible to set the kernel timeouts higher than device
  retry periods, if one does not care about latency, to minimize
  the chances of declaring a drive failed (not the difference
  between Linux command timeouts and retry timeouts, the latter
  can also be long).

> But in the case of SSD drives (where, possibly, the error
> recovery activities performed by the drive firmware are very
> fast) [...]

I guess that depends on the firmware: On one hand MLC cells can
become quite unreliable, especially at higher temperatures,
requiring many retries and lots of ECC, on the other on "write"
allocating a new erase-block is easy, as unlike for most HDDs
with a FTL, SDD sector logical and physical sector locations are
independent. Unfortunately most flash SSD drive makers don't
supply technical information on details like error recovery
strategies.
