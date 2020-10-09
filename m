Return-Path: <SRS0=zRnh=DQ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FD6C433DF
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 01:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF5222242
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 01:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgJIBH5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Oct 2020 21:07:57 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:36908 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgJIBH5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Oct 2020 21:07:57 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2020 21:07:56 EDT
Received: from quad.stoffel.org (066-189-075-104.res.spectrum.com [66.189.75.104])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 3995220F2A;
        Thu,  8 Oct 2020 21:00:13 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 92394A6771; Thu,  8 Oct 2020 21:00:11 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24447.46619.550227.607747@quad.stoffel.home>
Date:   Thu, 8 Oct 2020 21:00:11 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     antlists <antlists@youngman.org.uk>,
        Daniel Sanabria <sanabria.d@gmail.com>,
        Roman Mamedov <rm@romanrm.net>,
        Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: do i need to give up on this setup
In-Reply-To: <CAAMCDefj4koi_+g-vdzWpfSB21KLgRq2kJ9sCZK04iX85b_qfw@mail.gmail.com>
References: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
        <20201005184449.54225175@natsu>
        <CAHscji0pNezf6xCpjWto5-21ayoCeLWm34GTYh5TSgxkOw90mw@mail.gmail.com>
        <20201005190421.4ecd8f1b@natsu>
        <CAHscji1VrccTOaQc4GdWof4E+Bzs5KL0-tJJj0ZUM9Db=QBriw@mail.gmail.com>
        <CAAMCDedZfx+w3NT_QgB0KGkeEQikCtYVy9YuiNEhNaEjXF1C8w@mail.gmail.com>
        <CAHscji01ikKz4fQ_9i4Tb3AraTD+ZcXBbK-Mm+zY4p3p2qbF4Q@mail.gmail.com>
        <CAAMCDeeRNnoC6mdj7L1PdD5Ztek1tzm++UPi3k=hWvBUA=oLxQ@mail.gmail.com>
        <5be31543-22ec-dd9f-fd08-d759c4b0df3a@youngman.org.uk>
        <CAAMCDefj4koi_+g-vdzWpfSB21KLgRq2kJ9sCZK04iX85b_qfw@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Roger" == Roger Heflin <rogerheflin@gmail.com> writes:

Roger> The controller is crap, and is expected to have serious issues no
Roger> matter what drives are on the controller.

I can't say enough good things about the LSI SATA RAID controllers.
You can usually get them pretty cheap on eBay, and just flash them
with the JBOD firmware and they do great.

  LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT S)

It's been a while, but I think it was an IBM branded card at the
time.  8 ports, easy setup, works well.  And looking on ebay, they're
cheap now, around $50 though you might have to pay for the 1-to-4
cables to goto SATA drives.  9211, 9341, stuff like that.  Here's an
eBay listing with cables:

https://www.ebay.com/p/1404809612?iid=133501363959&_trkparms=aid%3D555018%26algo%3DPL.SIM%26ao%3D1%26asc%3D20170810093926%26meid%3De20ed20fb9634e328a31bca5c9e2063c%26pid%3D100854%26rk%3D1%26rkt%3D1%26itm%3D133501363959%26pmt%3D1%26noa%3D0%26pg%3D2322090%26algv%3DSimplAMLSeedlessV2&_trksid=p2322090.c100854.m4779

In my mind, the other advantage of these cards is that you can get two
of them, and split your data across two controllers.  But it also gets
your data disks off the internal controllers, which means you don't
run into nearly as many problems where the system tries to boot off
your data drives, or you have to put boot blocks on them, etc.  

This controller would be more tolerant of your existing drives, since
you have the 850w power supply, it's almost certainly not power
problems either.

John
