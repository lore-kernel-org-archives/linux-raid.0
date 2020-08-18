Return-Path: <SRS0=fBal=B4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABACC433E3
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 18:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B416F206B5
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 18:00:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="oSixRLLF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHRSA2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Aug 2020 14:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgHRSAV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Aug 2020 14:00:21 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231C8C061389
        for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2020 11:00:20 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id B280A3C2751;
        Tue, 18 Aug 2020 20:00:10 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 7WbRju8HTguZ; Tue, 18 Aug 2020 20:00:09 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 4CB883C27C7;
        Tue, 18 Aug 2020 20:00:09 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 4CB883C27C7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1597773609;
        bh=vijal7nb8T9huIXoXhtas5wcr7JgWO+20AkSxOe9mwc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=oSixRLLFFscKdQ+9UavZ7vEI3riyKdPXNdjk3uevT68BDzCK9Oi8CJgevZYlvuaE6
         YLbkxhxY4VrarR+igxbB6hhs5THoVGv1ZKotb+o+l5kvWLUuC0i35aXO2sr08FogrS
         k0CtlIsfvOQlS+xIH/u/8XTeShisNmMa2EWxFYJW3ysSnfNryMA0OL6dS1iG3/XanP
         E2OkWMuvaMpQLEkQJ6NSMovxKJczTwYJh0pm9FS6yDgK7opMQfFJrSVMHHWuUSDfor
         wG9eAKWR6beg4NIPsp1DUTvRYrx7gCx8JgSGJOp2/H+gIf7YSREdonRC/NnMWteqaq
         tgCiueiHqHEUg==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 932RfGVFiKzU; Tue, 18 Aug 2020 20:00:09 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 1E8443C2751;
        Tue, 18 Aug 2020 20:00:09 +0200 (CEST)
Date:   Tue, 18 Aug 2020 20:00:08 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc:     =?utf-8?Q?H=C3=A5kon?= <hawken@thehawken.org>
Message-ID: <75076966.1748398.1597773608869.JavaMail.zimbra@karlsbakk.net>
Subject: Feature request: Remove the badblocks list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:51.175.216.121]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF79 (Mac)/8.8.10_GA_3786)
Thread-Index: sqiaJlTWHLo05Q49ZO2a/oc1lMBbhg==
Thread-Topic: Feature request: Remove the badblocks list
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

It seems the badblocks list was added around 10 years ago[1]. The reason wa=
s to keep a track on sectors not readable, which may have made sensee 20 ye=
ars earlier, but not even in 2010. The first IDE drives came out in the end=
 of the 1980s and were named thus of their 'Integrated Drive Electronics' w=
hich was a new thing at the time. Opposed to earlier MFM drives and such, t=
hese were "smart" and could handle errors a bit better, even reallocate bad=
 sectors to somewhere else when needed. A lot happened beween 1987 and 2010=
, but for some reason, this feature slipped through anyway, perhaps becauas=
e Linus was drunk, I don't know. As far as I can understand, this feature w=
orks a bit like this

 - If a bad (that is, unreadable) block is found, it is flagged as bad, not=
 to be used ever again, in the md member's superblock
 - If a new disk is added to the array, the block number of the initial bad=
 block is flagged on the new drive, since the whole stripe is rendered usel=
ess (erm, didn't we have redundency here?)
 - If replacing the original drive with a new drive, md happily replaces al=
l the data to the new drive and updates the superblock with the same badblo=
ck list.

So no attempt is ever done to check or repair that sector. Disks reallocate=
 sectors if they are bad and it's not necessarily a big issue unless there'=
s a lot of such errors. We just say 'this sector or block said *ouch* and i=
s thus dead, and so will his siblings be for ever and ever'. There's a nice=
 article about it here[2].

In practice, if you have data in stripes with badblocks, they may be lost f=
orever and for no reason at all, since drives tend to fix their problems if=
 you issue a write to that sector. ZFS does this nicely - when it finds a b=
ad read, it reconstructs from parity or mirror and writes it again. If it e=
ncounters a write error, it tries over. Eventually the drive may fail, but =
hell, that's why we have redundancy.

As far as I can see, the only solution to remove the badblocks list, is "md=
adm ... --assemble --update=3Dno-bbl", from [2], and have md return garbage=
 for those lost sectors, which is fine, since fsck/xfs_repair should fix wh=
at's fixable (and still won't be readable anyway). An alternate version wri=
tten by a friend of mine (H=C3=A5kon on cc) is present on [3] to remove the=
 list from an offlined array.

As far as I can understand, this list doesn't have any reason to exist, exc=
ept to annoy sysadmins.

So please remove this useless thing or at least don't enable it by default

[1] https://linux-raid.vger.kernel.narkive.com/R1rvkUiQ/using-the-new-bad-b=
lock-log-in-md-for-linux-3-1
[2] https://raid.wiki.kernel.org/index.php/The_Badblocks_controversy
[3] https://git.thehawken.org/hawken/md-badblocktool.git

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
