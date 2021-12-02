Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EB7C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  2 Dec 2021 22:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhLBWJ2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Dec 2021 17:09:28 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:59949 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231365AbhLBWJ2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Dec 2021 17:09:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id DA1C43201C6E
        for <linux-raid@vger.kernel.org>; Thu,  2 Dec 2021 17:06:04 -0500 (EST)
Received: from imap47 ([10.202.2.97])
  by compute4.internal (MEProxy); Thu, 02 Dec 2021 17:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=dwntib/i3+N8Anbry5EZdEnk9LYUh
        VOdIKrnmjeU+xk=; b=SkufR4aCB9Oz19gPZ552dW2bOVLd2vEtRVGvPdz9qRQye
        iiJEVZXBeKHBb+jpuki/MTAgTEjNPQVmk04bjR8KxoGHJUsYQHBZZeAMzApw1oxg
        +vqKxOFx445aVzRO3BGAvykO8BmeRxD/3vgHFrvXDSeyO3qaormm0vnsAXLyxd6s
        JBrUj/08TUCxld/piJ8Wv7THldwZqr1wj3lQNMx8692Ue4uORjFJxoBHj8t94nzM
        bmkPkqWZB/OPG7DDB0myQp1+ez9uw15IrMdY4I1t+OYqKm4xZJz2ar8sCxQVGEwm
        OxaTB57y6S5ao68wtlpu5A447qz3a8iC62av4ONmQ==
X-ME-Sender: <xms:TEOpYRPCj9OaFI4tWgAjWpCcWRJUhBvf5-FHdN4S2tGnGayrCGrERQ>
    <xme:TEOpYT_QDOjkSxlm6iivPFWtNPNn0JKh_ekjJ1Gi6vjBvqpS8_cC0sk__bILiS9aV
    epbH-Q2FB9pMc2d>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieehgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehttdertd
    erredtnecuhfhrohhmpedfofgrthhtucfirghrrhgvthhsohhnfdcuoehmrghtthesmhgr
    thhthihordhnvghtqeenucggtffrrghtthgvrhhnpefghfetfeejvdejuddtheduhfefue
    dtkeevjeejheefhfefgedvleekudeuiedvhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehmrghtthesmhgrthhthihordhnvght
X-ME-Proxy: <xmx:TEOpYQSdAeRWBcFv7bjca2cIU5qb27wbh_UxAHT6YlmTvHhNkmMEVQ>
    <xmx:TEOpYdveVAQcW_PQse2CKr_iqs_tqA1fS7t3OCNWGTFUyqWUS0m5dg>
    <xmx:TEOpYZdpg7A2s-kZSxsSFJd4rRddRKHmzrjXFb-Hf_Zp4QiSszCRXQ>
    <xmx:TEOpYTo8IfW0pcmOg6zSyQhdeH6wZzWdiSHHF7k6nl5iodwRfnI1iA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EAA9927407D4; Thu,  2 Dec 2021 17:06:03 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4458-g51a91c06b2-fm-20211130.004-g51a91c06
Mime-Version: 1.0
Message-Id: <7be1c467-c2c2-5f90-dc1c-f1c443954f03@mattyo.net>
Date:   Thu, 02 Dec 2021 17:04:57 -0500
From:   "Matt Garretson" <matt@mattyo.net>
To:     linux-raid@vger.kernel.org
Subject: Help ironing out persistent mismatches on raid6
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, I have this RAID6 array of 6x 8TB drives:

/dev/md1:
           Version : 1.2
     Creation Time : Fri Jul  6 23:20:38 2018
        Raid Level : raid6
        Array Size : 31255166976 (29.11 TiB 32.01 TB)
     Used Dev Size : 7813791744 (7.28 TiB 8.00 TB)
      Raid Devices : 6

There is an ext4 fs on the device (no lvm).

The array for over a year has had 40 contiguous mismatches in the same spot:

md1: mismatch sector in range 2742891144-2742891152
md1: mismatch sector in range 2742891152-2742891160
md1: mismatch sector in range 2742891160-2742891168
md1: mismatch sector in range 2742891168-2742891176
md1: mismatch sector in range 2742891176-2742891184

Sector size is 512, so I guess this works out to be five 4KiB blocks, or
20KiB of space.

The array is checked weekly, but never been "repaired".  The ext4
filesystem has been fsck'd a lot over the years, with no problems.  But
I worry about what file might potentially have bad data in it.  There
are a lot of files.

I have done:

dd status=none if=/dev/md1 ibs=512 skip=2742891144 count=40  |hexdump -C

... and I don't see anything meaningful to me.

I have done  dumpe2fs -h /dev/md1 and it tells me block size is 4096 and
the first block is 0.  So does....

2742891144 * 512 / 4096 = 342861393

...mean we are dealing with blocks # 342861393 - 342861398 of the
filesystem?  If so, is there a way for me to see what file(s) use those
blocks?

Thanks in advance for any tips...
-Matt
