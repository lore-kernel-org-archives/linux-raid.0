Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9925EC4338F
	for <linux-raid@archiver.kernel.org>; Mon, 26 Jul 2021 07:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C59B60F21
	for <linux-raid@archiver.kernel.org>; Mon, 26 Jul 2021 07:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhGZHRB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Jul 2021 03:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhGZHRB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 26 Jul 2021 03:17:01 -0400
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B171C061757
        for <linux-raid@vger.kernel.org>; Mon, 26 Jul 2021 00:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=u/F8ExNLzn+IrF1UQGhrpecMZYoNbMSSNtUYZkQNQb4=; b=VPl+nJaiEYSw2X72asmdkDImpy
        f3s+tL6rzP/JoZaAqCJzCpupNP6OKqY1EQKE3hU5ER34VPKLG0jdnb8LH3xOhFs0IxfZyL2onW1o/
        /IwZPN6zs1UwKcx8/t1FM95jABiTi3K3r5JTPIUtpo+w5W6mUwvMs1sW8Hpgl8TdVumi8Ai8q0R6K
        TMquJrNBsOaAIBR7dj4Z+szaiOi+rLiVIa34SgcJuEp8TNFU83f/qvkSOHMNt27PJFDMrXLL2NGrf
        SfouV6I/VHq38aoDjOnSigQlW+Fx6/VS7MXnoXS/kNARu9tI4o13+K+LqRbeuUYELCEG/JQRK/uVC
        Vi1gs2mw==;
Received: from b2b-37-24-20-172.unitymedia.biz ([37.24.20.172] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1m7vUL-004nNv-MY   id 1m7vUL-004nNv-MYby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Mon, 26 Jul 2021 07:57:25 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1m7vUE-003d2g-9A
        for <linux-raid@vger.kernel.org>; Mon, 26 Jul 2021 09:57:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24830.27358.78544.178603@cyme.ty.sabi.co.uk>
Date:   Mon, 26 Jul 2021 09:57:18 +0200
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
In-Reply-To: <85c7e18c-5a77-2a20-b170-2a45d7e37dc7@turmel.org>
References: <2232919.g0K5C1TF2C@chirone>
        <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
        <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
        <24829.15553.689641.666563@cyme.ty.sabi.co.uk>
        <85c7e18c-5a77-2a20-b170-2a45d7e37dc7@turmel.org>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@raid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[...]

> I must not be the only one ignoring you, causing you to use
> multiple subdomains.

It seems sad that my changing address occasionally when they get
spammed as they get "harvested" may tickle someone's foolish
arrogance of thinking themselves so important that it is done
just to get their worthless attention.
http://www.sabi.co.uk/blog/0705may.html?070527c#070527c

Unfortunately in some cases my technical comments therefore get
replies without any technical content. As to this though:

> without going in detail about all other possible cases.

There are indeed many twists and turns and "legacy" situations,
as in several places timeouts and retries are hardcoded, and
IIRC the "default" for retries is 5. But I have spent a bit of
time looking at some of the weirdness and it turns out that
nowadays the 'sd' module defines a 'max_retries' setting in the
device attributes (rather than a module parameter as in
'nvme_core'):

  https://elixir.bootlin.com/linux/latest/source/drivers/scsi/sd.c#L598

It is only available from 5.10 and would be for example at:

  /sys/class/scsi_disk/0:0:0:0/max_retries

I have also noticed that XFS bizarrely has its own layer of
recovery on top of that of the Linux IO subsystems and of the
device itself:

  https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_file_systems/configuring-xfs-error-behavior_managing-file-systems
  https://elixir.bootlin.com/linux/v5.13.5/source/fs/xfs/xfs_buf.c#L1264
