Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E03C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  2 Dec 2021 22:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237341AbhLBWJq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Dec 2021 17:09:46 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38615 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231365AbhLBWJq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Dec 2021 17:09:46 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id ECD663201C5C
        for <linux-raid@vger.kernel.org>; Thu,  2 Dec 2021 17:06:22 -0500 (EST)
Received: from imap47 ([10.202.2.97])
  by compute5.internal (MEProxy); Thu, 02 Dec 2021 17:06:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
        mime-version:message-id:date:from:to:subject:content-type; s=
        fm1; bh=dwntib/i3+N8Anbry5EZdEnk9LYUhVOdIKrnmjeU+xk=; b=AXR5RDyb
        +8RKAE9jXIjTwJag88qwn6vKMuEkSKwpLfoSX1qArw8owo3XVKkYl7Iv6tvH+siy
        bjYDKINgQoe0NsRyvAbkQ0eKxrH9RRlpQ5t29+UxmGnDJRa2K0lE+Aw1Yr7HCqGx
        WAl7buhlJQdUFu2ahN0taX7XiouhIPO/bemNMUolcUoYO5SW8mfjyObjA6eV7OZp
        HJjFfZQNBseOXqwjeKlGfMHoFLJllYuoiOu+Zesk+ZtiYztnPVT1vITN/DfurKT3
        GmOUiCzXK6X+pl0pQvWD4Nde+wjdhSPCRfmlzJOKXuBU3+lPdSGGtfCxcLOYMjv5
        XBZAoGhlUlz+xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=dwntib/i3+N8Anbry5EZdEnk9LYUh
        VOdIKrnmjeU+xk=; b=g8o+BOUhbidk2HSwGJ6Ln7x7bYKkMdWdxDD50KsPBgiPr
        57dnjOZTlrWFrL80TwJfwjES9Kc9RibUa2zL6pX+RUMvhrqUlCjWga2ggAnjKhdV
        SVKdbjFWfQAEosN2vhLi1VrgFnhAmTawj7UA/tNpUKkahR/IO0bmpSOEacR04gT6
        f2bJ4cL0r+gzbVhH45vC+Xpa1xlfwg3GOZI9eSLtK0ZJT0XSJ8nGYGu0bBnoHXaq
        9GvDA8t2lAUlO6gjI+HdfWrORzcgJBVe1CSf+nMqNzIKl0EtJyo0LMqdG3eso8uq
        W7jmGqLW0zj/wTj2UExHYhyYCRePrunu/7x8SHoSQ==
X-ME-Sender: <xms:XkOpYdq5RU7ckpZlNy2B9EFCKADV_0TY54wltwjoRZsDC1wTimPscQ>
    <xme:XkOpYfl-F8JkG-TCDtzudIO4AA-g19-zQZ5BuLr-_jwuU0SjcEQx0uck9pjfd3l-I
    3O9TCCIrZJ4I000>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieehgdduheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehttdertd
    erredtnecuhfhrohhmpehlihhsthihsehfrghsthhmrghilhdrfhhmnecuggftrfgrthht
    vghrnhepudeggefftdekhfefgfeutdeufeehgffhueehueffgfevheehteeuudeggeffie
    ehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheplhhi
    shhthiesfhgrshhtmhgrihhlrdhfmh
X-ME-Proxy: <xmx:XkOpYXG7xVxP87hQ__WI8VPt6YCUGuUSmfBHQ7AfFBr6IAvxG8EzSQ>
    <xmx:XkOpYQpCb7LhWuGMgdtauJFD2ZWJOHKubi--DJpRMxhN13v2mwp4Zg>
    <xmx:XkOpYb4j64oiB1zzsFWG3zO8DQ-RJeU5w8_gq-RlpzVGfInL3hvNcA>
    <xmx:XkOpYRtSz_d0wgEmv9M7TQPdISGNCgLVAyRkkoTs5-DlEtnT08xIqg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5545A274065C; Thu,  2 Dec 2021 17:06:22 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4458-g51a91c06b2-fm-20211130.004-g51a91c06
Mime-Version: 1.0
Message-Id: <5bf7416c-ee1f-4739-834c-cbf87441d3ed@www.fastmail.com>
Date:   Thu, 02 Dec 2021 17:06:02 -0500
From:   listy@fastmail.fm
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
