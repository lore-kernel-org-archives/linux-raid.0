Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2592EC433ED
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 17:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF9C7613E6
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 17:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhELRX0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 13:23:26 -0400
Received: from zimbra.karlsbakk.net ([193.29.58.196]:58070 "EHLO
        zimbra.karlsbakk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbhELQho (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 12:37:44 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 12:37:44 EDT
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 2718F3C032F;
        Wed, 12 May 2021 18:31:10 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 8fTpghDpSggu; Wed, 12 May 2021 18:31:08 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 089733C28E3;
        Wed, 12 May 2021 18:31:08 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 089733C28E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1620837068;
        bh=CnrHI5eD/Pa1c1BDg5NFIs4z+PJPMjLDfck46aUGJFs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=VBg88EkeXWBitfKPf2w0ihShBjez8FGjL1kmJm3rsw4QUR5Ed4O4fEgmWDIG8HMku
         ZKH4kma1zxIeyVW2uam8JR+thuJAl9bRwWYZqi0mosJxAJsfvdancJrpwzOoaTEF9g
         K80wFMJgiz2jDr+QuyjZOLDmb3sWhf1K9J9rWjPgek4AuN0FcbKEFD6BkVafGvkYa4
         7VLHtwZR80gB644F8Yp4iVYbnSA7sft6TkKkGYBzt6quROE44aVa7ni1I89N8NR+Xc
         uRwqjFz6NLmqDCHPrT7D4zRhN5JGyAT+Vy2odds8nv0/kYDM3uBmpPQgsFYyL0+uUf
         YdaDQJhCu7VwQ==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id RKvK-CXBYtM3; Wed, 12 May 2021 18:31:07 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id D9AEE3C032F;
        Wed, 12 May 2021 18:31:07 +0200 (CEST)
Date:   Wed, 12 May 2021 18:31:07 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     d tbsky <tbskyd@gmail.com>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
Subject: Re: raid10 redundancy
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:158.39.192.235]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF88 (Mac)/8.8.10_GA_3786)
Thread-Topic: raid10 redundancy
Thread-Index: Ya+/7rstP7P9Tagh/Q4bp+MHzeicIg==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> Hi:
>   I am curious about raid10 redundancy when created with disk numbers bel=
ow:
>=20
> 2 disks =3D> 1 disk tolerance
> 3 disks =3D > 1 disk  tolerance
> 4 disks =3D>  possible 2 disks?  or still only 1 disk ?
>=20
> how about 5/6 disks with raid10?
> thanks a lot for confirmation!!

Basically, the reason to use raid10 over raid6 is to increase performance. =
This is particularly important regarding rebuild times. If you have a huge =
raid-6 array with large drives, it'll take a long time to rebuild it after =
a disk fails. With raid10, this is far lower, since you don't need to rewri=
te and compute so much. Personally, I'd choose raid6 over raid10 in most se=
tups unless I need I lot of IOPS, where RAID6 isn't that good. RAID5 is als=
o ok, if you don't have too much drives, but if you get a double disk failu=
re, well, you're fucked.

PS: Always make sure to have a good backup. RAID isn't backup, it's just re=
dundancy and won't help you if your house burns down or a filesystem messes=
 up after a PSU problem or similar.=20

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

