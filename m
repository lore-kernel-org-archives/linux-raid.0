Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77ABC433ED
	for <linux-raid@archiver.kernel.org>; Fri, 14 May 2021 14:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C20161458
	for <linux-raid@archiver.kernel.org>; Fri, 14 May 2021 14:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhENOtx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 May 2021 10:49:53 -0400
Received: from zimbra.karlsbakk.net ([193.29.58.196]:53358 "EHLO
        zimbra.karlsbakk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbhENOtw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 May 2021 10:49:52 -0400
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 26ADF3C032F;
        Fri, 14 May 2021 16:48:40 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id i7x4_dhElOkr; Fri, 14 May 2021 16:48:38 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id C13123C28E4;
        Fri, 14 May 2021 16:48:38 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net C13123C28E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1621003718;
        bh=viD8bH3E3Ceu41yk99WhMfXiK1v8GoNkvpCbGE+7QNc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=FLjVrh68n4pjmQXv9n/GO+JELGRIMcMZla1QvsV92EPfrB1RFuMI8owdfJ5Gme8N7
         4FTDuCnc2LLtKdJPxgHmf1AhQEndMGWAHI1g9MdgC4kGBXdoHT05yn3dS5IRd1swqI
         PcaNxhRRnMzkv0anv51XBS50Q68VT2C6yudJtd+FeXqiTDKThN1zkJhW1P7sEIGIda
         24BYOJ6XLxMOF61sCqoLx7NRjCZ0bIdAI6jljsUlOCX71IEsOv0qcecVk70PlL5iRY
         v07x244oDjbbACwuyKaMp7fr8MlVNzh49pcxx2ytyYjfIKH/DMJtBsL2dfbew9TJXx
         JO4BL78JXhtsw==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id pFw19HivF-Zv; Fri, 14 May 2021 16:48:38 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 615773C032F;
        Fri, 14 May 2021 16:48:38 +0200 (CEST)
Date:   Fri, 14 May 2021 16:48:37 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Phillip Susi <phill@thesusis.net>
Cc:     Phil Turmel <philip@turmel.org>, d tbsky <tbskyd@gmail.com>,
        Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <87y2ch4c3w.fsf@vps.thesusis.net>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com> <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net> <87a6oyr64b.fsf@vps.thesusis.net> <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org> <87y2ch4c3w.fsf@vps.thesusis.net>
Subject: Re: raid10 redundancy
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2a01:79c:cebf:61e4:981d:72a4:70a1:eb51]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF88 (Mac)/8.8.10_GA_3786)
Thread-Topic: raid10 redundancy
Thread-Index: u3K+AgT5hup15fuu+/xxIAYz2SIOxg==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> Phil Turmel writes:
>=20
>> No, rebuild isn't just writing to the new disk.  You have to read other
>> disks to get the data to write.  In raid6, you must read at least n-2
>> drives, compute, then write.  In raid10, you just read the other drive
>> (or one of the other drives when copies>2), then write.
>=20
> Yes, but the data is striped across those multiple disks, so reading
> them in parallel takes no more time.  At least unless you have a
> memory/bus bottleneck rather than a disk bottleneck.  so again, you're
> probably right if you are using blazing fast NVME drives, but not for
> conventional HDD.

RAID10 is like RAID1+0, only a bit more fancy. That means it's basically st=
riping across mirrors. It's *not* like RAID0+1, which is the other way, whe=
n you mirror two RAID0 sets. So when a drive dies in a RAID10, you'll have =
to read from one or two other drives, depending on redundancy and the numbe=
r of drives (odd or even).

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
