Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10DFC433E1
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 14:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F332078D
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 14:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="AanwGFad"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgHMObo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 10:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgHMObn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Aug 2020 10:31:43 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C6FC061757
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 07:31:43 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 843123C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 16:31:40 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id Ldh61VQobdQm for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 16:31:39 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 404A13C27A0
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 16:31:39 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 404A13C27A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1597329099;
        bh=ROVuKl8b6ZBxJ0rlY9+CZ6jKX6J9tuX8W/tnLtKUGlA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=AanwGFadNdXdFCssV3YxZEKYtWDeoWp/hsbMCTPL63I/se2OT69/ZwiHOSw/XTvPJ
         Oc0zU/KSgf27kqOgN+4XDQJ+p7V+8Fp+WT1B+dnzaas2TOcOxHkxLWJg1ClFQ3QX8U
         3k3NK0aXbTX+G5J+7ynwWrBWIt5exQClKnRvwUw64F5TcfNBUsX+LdoWRwJv4Rze8d
         ZNCTX/IuukMpar8ZJrZ3UaGiY6ry7OmGRB7CcJF1Ec6YG9xS+SmKJjgfWCCvmcxaRK
         oNPqKXnxEiK0IGMTRA4i7z0AIVeD9Ica/q36RQzIMN5nY4x2WKc2FaAFyeyJohnW7H
         VyCiokddNL8KQ==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id WSG4b8Mh6ZWG for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 16:31:39 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 25AE43C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 16:31:39 +0200 (CEST)
Date:   Thu, 13 Aug 2020 16:31:36 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Message-ID: <2053545579.22464117.1597329096623.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net>
References: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net>
Subject: Re: Confusing output of --examine-badblocks1 message
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:51.175.216.121]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF79 (Mac)/8.8.10_GA_3786)
Thread-Topic: Confusing output of --examine-badblocks1 message
Thread-Index: 6fFysasCZBtSZ6hKL7EEKs2k82fW09O0JgJt
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> However, back to --examine-badblocks. It seems it's reporting the same se=
ctor
> numbers in the list for several (up to eight) drives. If I understand thi=
s
> correctly, something strange has hit and damanged all drives on fixed sec=
tor
> numbers, such as this
>=20
> Bad-blocks on /dev/sdm:
>           436362944 for 128 sectors
>=20
> It doesn't seem very likely, to be honest, that a lot of drives suddenly =
damage
> the same sector at once. I can see the same occur on a friend's server -
> sectors with identical 'bad' sector numbers been listed on individual dri=
ves.

It seems very likely the badblocks list is just replicated to new drives. I=
 just started

# mdadm /dev/md0 --replace /dev/sdb --with /dev/sdk

where sdk is a drive known to be good. It's about halfway through and it's =
already copied part of the badblocks list. No I/O errors have been reported=
 in dmesg or otherwise.

Any idea how to remove this list and start over?

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

