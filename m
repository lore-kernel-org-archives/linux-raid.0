Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817D8C63777
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92F420706
	for <linux-raid@archiver.kernel.org>; Sat, 28 Nov 2020 22:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.jp header.i=@posteo.jp header.b="EtmfGNyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgK1VuR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:17 -0500
Received: from mout01.posteo.de ([185.67.36.65]:54019 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732401AbgK1SHu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 28 Nov 2020 13:07:50 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 109B316005C
        for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2020 13:11:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.jp; s=2017;
        t=1606565474; bh=Iyf6Xc8yMBELkpYBcxZObM7Lit1STYNqeSddGo09j+8=;
        h=Date:From:To:Subject:From;
        b=EtmfGNyRLVhzjMbq5xzbv3E3Q7wFINaal0rt2O9nlAoMpED1RJtyw6r1WqYkQdAg3
         Wg6ETyUoL7Q0UvHQdrNAdQVrIFqHmQjr7QF9BqGBdOFpK9J4wFefoDhM0b2FZvgE09
         hjvSsy8gXQy8Axt10PsBDAOuIheTiUKCTIqK8bubdkBzbHe6w/bX8sqp0PF/VW4yVr
         uv+joD+dk5a7A9k2SqqCaraJkuCIfcySWHlZohaelr0Vx5dhZDMkMDj29CiDzg1KLY
         GVSJtsHPzAGCWmf7L+9fCWLRmy2H7fBy+xeBb3gBfo9jJXLmJvz0Pu/CNFKLs1Ip7n
         QL3PsQBriF3TA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Cjr1s57ZLz9rxL
        for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2020 13:11:13 +0100 (CET)
Date:   Sat, 28 Nov 2020 13:11:08 +0100
From:   <c.buhtz@posteo.jp>
To:     linux-raid@vger.kernel.org
Subject: Assemble RAID on new machine but with missing devices
Followup-To: linux-raid@vger.kernel.org
Reply-To: linux-raid@vger.kernel.org
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <4Cjr1s6fhJz9rxP@submission02.posteo.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I red some stuff about assembling mode for mdadm. But two points are
unclear for me.

1. Missing devices
I have two HDDs in a RAID1 - only data, no OS, on them. I want to
physical remove one HDD and plug it into a new server machine. Then I
want to bring the RAID1 online again on the new machine but with one
existing and one missing drive.
Background: When finished I will plug in a new fresh HDD as the second
one to the new server.

2. mdadm.conf
On the web I read sometimes about modifying mdadm.conf on the new
machine. But I do not understand why. If so. Why and what do I have to
modify in the mdadm.conf?

Kind
Christian
