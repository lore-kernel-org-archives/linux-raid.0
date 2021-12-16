Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAD3C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 21:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242380AbhLPVoj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:44:39 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:44558 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242965AbhLPVnp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Dec 2021 16:43:45 -0500
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 8815F21EA5;
        Thu, 16 Dec 2021 16:43:44 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id E3644A76E6; Thu, 16 Dec 2021 16:43:43 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25019.45839.872620.235430@quad.stoffel.home>
Date:   Thu, 16 Dec 2021 16:43:43 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Wol <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Debugging system hangs
In-Reply-To: <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
        <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
        <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
        <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Another thing that struck me is maybe it's time to boot into a small
stress testing image and see if it's more of a hardware issue.  It
might also be a power supply issue, where as the load goes up, your
power supply can't keep the voltage up and the system fails that way?

There's the 'stress-ng' package for beating on systems.  And I think
I've used 'sysrecue' in the past to boot up systems and run stress
tests.

Getting the regular OS out of the way with something lower level and
simpler to stress test the hardware is a good idea.

https://www.stresslinux.org/sl/

Might be another good option.

Good luck!
John
