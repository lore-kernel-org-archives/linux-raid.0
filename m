Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33779C43216
	for <linux-raid@archiver.kernel.org>; Mon, 26 Jul 2021 16:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B5C860C41
	for <linux-raid@archiver.kernel.org>; Mon, 26 Jul 2021 16:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhGZPcU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Jul 2021 11:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbhGZPcB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 26 Jul 2021 11:32:01 -0400
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC35C0613CF
        for <linux-raid@vger.kernel.org>; Mon, 26 Jul 2021 09:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6e9t0Ep3rycA5rwlMB+Gk6B0LjBdRibcCgh9GQwCisg=; b=f8QNGLugTfj3CxwAbTeBYcM1w5
        S029PKcVWVGdelZJrJaNNCILEft0wNzaukLFLBHjiq4Z1jR/rd3RQOUlQkja7l+/nhfgmNp9RtlUy
        6hdE1BIpO/xjgprZiXLDPWoZWoI9aklpuGLBt2iIWbeNpq6R+I/cDRMBxOBKbtzfI4C042gPoJBtu
        /4lLDM+MeiZXnRMI5LjAv1fGy6dMG0zUK3H4m4AYedICYbBjAuNcoCZYM3OzKXUWBUhHLdeUsSvEs
        sWESP89srm31VjOfCchb8VarRELOCYvfARNWLAmzNrxU8LVXPvsap/s5p+G6/ZOmqcM7YyzuXOB/B
        2DHgDLiw==;
Received: from b2b-37-24-228-251.unitymedia.biz ([37.24.228.251] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1m83D8-004oWt-CK   id 1m83D8-004oWt-CKby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Mon, 26 Jul 2021 16:12:10 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1m83D3-003fNY-TV
        for <linux-raid@vger.kernel.org>; Mon, 26 Jul 2021 18:12:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24830.57045.462708.449341@cyme.ty.sabi.co.uk>
Date:   Mon, 26 Jul 2021 18:12:05 +0200
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
In-Reply-To: <24830.27358.78544.178603@cyme.ty.sabi.co.uk>
References: <2232919.g0K5C1TF2C@chirone>
        <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
        <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
        <24829.15553.689641.666563@cyme.ty.sabi.co.uk>
        <85c7e18c-5a77-2a20-b170-2a45d7e37dc7@turmel.org>
        <24830.27358.78544.178603@cyme.ty.sabi.co.uk>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@raid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[...]
> I have also noticed that XFS bizarrely has its own layer of
> recovery on top of that of the Linux IO subsystems and of the
> device itself:

>   https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_file_systems/configuring-xfs-error-behavior_managing-file-systems
>   https://elixir.bootlin.com/linux/v5.13.5/source/fs/xfs/xfs_buf.c#L1264

Some people have been proposing to do the same with MD RAID, and
some similar layer sometimes is embedded in the firmware of
hardware RAID host adapters.

Consider this scenario (include the relevant error handling and
timeouts):

  * The device firmware does physical operation retries.
  * The Linux IO subsystem does device operation retries.
  * MD RAID does Linux IO operation retries.
  * XFS does MD RAID IO operation retries.

Is there something weird with this?

BTW there is something similar with read ahead or write behind:
sometimes several software layers assume that lower software
layers are doing too little of it, and do their own additional
read ahead or write behind.
