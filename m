Return-Path: <SRS0=QefQ=BY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4061C433E1
	for <linux-raid@archiver.kernel.org>; Fri, 14 Aug 2020 18:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DAB420771
	for <linux-raid@archiver.kernel.org>; Fri, 14 Aug 2020 18:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="eYOSuQ6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgHNSHZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Aug 2020 14:07:25 -0400
Received: from zimbra.karlsbakk.net ([193.29.58.196]:55912 "EHLO
        zimbra.karlsbakk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbgHNSHY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Aug 2020 14:07:24 -0400
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 5C6123C2767
        for <linux-raid@vger.kernel.org>; Fri, 14 Aug 2020 20:07:22 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id dNCDM1A2Nqr7 for <linux-raid@vger.kernel.org>;
        Fri, 14 Aug 2020 20:07:21 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 06E853C2778
        for <linux-raid@vger.kernel.org>; Fri, 14 Aug 2020 20:07:21 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 06E853C2778
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1597428441;
        bh=QkXkNIvGzuA1d7bMOsXl8MxbhN0SfkTzwb/1wWZapL8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=eYOSuQ6VWh8SKIIjfqCH/2kWSxNtybmyfp1APVjYStvhZttO/foCUWu4ypnTXWUfr
         PiUc4tL9Fw9JUwfClmfhaOnTv87hHA/izWay5xCW8+82sgY4L6FqGNunhtMeGLQXST
         sJh6TDDy748lFNi29b6YXxLr2PQ4mReTbsDFlerQClWdb+pQ5c6WEw7x1Z/oBIKAyE
         sJNQ6Xu8yAXo4WGcSEG1RZP55M3vQfYFehP+3v18gEuihYs6dTUp4m/hWxffjsWMsu
         nyLDzscxe8Gfw0Q73ir+tuCFqkYRgXdF3ROqkpdi0BaILRh80gmBPZBbldp56QeMdT
         b2AxQLz7tkxHw==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 8I1rppVd86kB for <linux-raid@vger.kernel.org>;
        Fri, 14 Aug 2020 20:07:20 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id E269D3C2767
        for <linux-raid@vger.kernel.org>; Fri, 14 Aug 2020 20:07:20 +0200 (CEST)
Date:   Fri, 14 Aug 2020 20:07:19 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <573421659.22903312.1597428439621.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <303847410.22535373.1597344622629.JavaMail.zimbra@karlsbakk.net>
References: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net> <2053545579.22464117.1597329096623.JavaMail.zimbra@karlsbakk.net> <303847410.22535373.1597344622629.JavaMail.zimbra@karlsbakk.net>
Subject: Re: Confusing output of --examine-badblocks1 message
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:51.175.216.121]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF79 (Mac)/8.8.10_GA_3786)
Thread-Topic: Confusing output of --examine-badblocks1 message
Thread-Index: 6fFysasCZBtSZ6hKL7EEKs2k82fW09O0JgJtymPdY0TtHOP6xA==
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I just tried another approach, mdadm --remove on the spares, mdadm --exam=
ine on
> the removed spares, no superblock. Then madm --fail for one of the drives=
 and
> mdadm --add for another, now spare for a few milliseconds until recovery
> started. This runs as it should, slower than --replace, but I don't care.=
 After
> 12% or so, I checked with --examine-badblocks, and the same sectors are p=
opping
> up again. This was just a small test to see i --replace was the "bad guy"=
 here
> or if a full recovery would do the same. It does.

For the record, I just tested mdadm --replace again on a disk in the raid. =
The source disk had no badblocks. The destination disk is new-ish (that is,=
 a few years old, but hardly written to and without an md superblock). It s=
eems the badblocks present on other drives in the raid6 are also replicated=
 to the "new" disk. This is not really how it should be IMO.

There must be a major bug in here somewhere. If there's a bad sector somewh=
ere, well, ok, I can handle some corruption. The filesystem will probably b=
e able to handle it as well. But if this is all blocked because of flakey "=
bad" sectors not really being bad, then something is bad indeed.

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
