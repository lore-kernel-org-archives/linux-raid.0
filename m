Return-Path: <SRS0=Kmql=BZ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93910C433E1
	for <linux-raid@archiver.kernel.org>; Sat, 15 Aug 2020 21:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 515A6206B6
	for <linux-raid@archiver.kernel.org>; Sat, 15 Aug 2020 21:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="jW0q3+fU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgHOVvo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 15 Aug 2020 17:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgHOVvh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 15 Aug 2020 17:51:37 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8540C0F26D3
        for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2020 10:33:35 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id DD0D63C22F8;
        Sat, 15 Aug 2020 19:33:25 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id tPV5qurPEvoO; Sat, 15 Aug 2020 19:33:23 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id B5C5E3C27B3;
        Sat, 15 Aug 2020 19:33:23 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net B5C5E3C27B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1597512803;
        bh=GPleY1PhZWScA7MxtC7yr++pbQs2LcmUt90j7i7m4AQ=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=jW0q3+fUSyWyzupkz4HFjFEFhRjHIJC8PV+VrlCtw8M7WuS2IiyaXvEM8GpwmGVcf
         LUhKcDG11EbxuY/D3m0GWLjuGRhzlAjye2iWeeeWbLTimGzqh91/3tA+O/6opCLpY6
         mLQEzeTN1xudIzYVS4vtppIe9kZw6A1qD5+EU5rCLdl/l+UMayQsubNEBGV3/H89oJ
         fPryB/H4iTXpX89YTlDkq8rbWHl8M1brmcnxnrfGGG6PGHkxHA+IsXQSEQK9jPueZO
         XJo5XKQSE9KXCz40ytTLfJnW2P0oIn874iEomoxFwHj7jZneAH0IPVvs5DLOWQe5uG
         thuFfkA0cwq4w==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id rH0Rrg_uim2d; Sat, 15 Aug 2020 19:33:23 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 9458A3C22F8;
        Sat, 15 Aug 2020 19:33:23 +0200 (CEST)
Date:   Sat, 15 Aug 2020 19:33:23 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Phil Turmel <philip@turmel.org>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <1188544829.565.1597512803014.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <de6e9dd1-7447-54ab-1818-ceabf422c8a0@turmel.org>
References: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net> <2053545579.22464117.1597329096623.JavaMail.zimbra@karlsbakk.net> <303847410.22535373.1597344622629.JavaMail.zimbra@karlsbakk.net> <573421659.22903312.1597428439621.JavaMail.zimbra@karlsbakk.net> <de6e9dd1-7447-54ab-1818-ceabf422c8a0@turmel.org>
Subject: Re: Confusing output of --examine-badblocks1 message
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:51.175.216.121]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF79 (Mac)/8.8.10_GA_3786)
Thread-Topic: Confusing output of --examine-badblocks1 message
Thread-Index: zCSKiE0jckwJcNRTTpkKYw7cooYmeA==
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> In my not-so-humble opinion, the bug is the existence of the BadBlocks
> feature.  Once a badblock is recorded for a sector, redundancy is
> permanently lost at that location.  There is no tool to undo this.
>=20
> I strongly recommend that you remove badblock logs on all arrays before
> the "feature" screws you.

I think it has screwed me a bit already, but then, I didn't check until rec=
ently. I didn't even know about this "feature". But doesn't help much when =
those "badblocks" are recorded already. What would be the official way to r=
emove them apart from rebuild the whole array?

A friend of mine wrote a thing in python to remove the badblocks list from =
an offline array. I haven't dared to test it on a live system, but apparent=
ly it worked on his (5 drives in RAID-5 IIRC with three of them showing a l=
ist identical of badblocks). You can find the code here https://git.thehawk=
en.org/hawken/md-badblocktool.git

Vennlig hilsen

roy
--=20
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.
