Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C49C4332F
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 14:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiK0OUX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 09:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiK0OUW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 09:20:22 -0500
X-Greylist: delayed 595 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Nov 2022 06:20:21 PST
Received: from mr5.vodafonemail.de (mr5.vodafonemail.de [145.253.228.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CABDDF35
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 06:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1669558224;
        bh=s1kmSUJC83asWo/Pn4+rhCEqWg1LhhCdMmRzZwtZkEU=;
        h=Date:Content-Type:X-Mailer:From:Message-ID:Subject:To:In-Reply-To:
         References:From;
        b=nIuctA5H1AtQ0bExagdoGpBlZ3c541caGBIYqacw2RjLdNI6YufxIIxwrXoUHtgpH
         8jM1QQz1zXgYQQZE/l8r4bPozMxZ0wJbW+PPA5BhAoS2VdGAIqxZUyAmrATzwT8HJB
         QJPEeSzZ5yDjbcCyFjA+2WmbncYjv/vnouoGuNxY=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr5.vodafonemail.de (Postfix) with ESMTPS id 4NKr8w03sQz1yCX;
        Sun, 27 Nov 2022 14:10:23 +0000 (UTC)
Received: from brix (p4fd6dceb.dip0.t-ipconnect.de [79.214.220.235])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4NKr8f6GXmz9sHw;
        Sun, 27 Nov 2022 14:10:07 +0000 (UTC)
MIME-Version: 1.0
Date:   Sun, 27 Nov 2022 14:10:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: SnappyMail/2.22.3
From:   piergiorgio.sartor@nexgo.de
Message-ID: <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
Subject: Re: how do i fix these RAID5 arrays?
To:     "Reindl Harald" <h.reindl@thelounge.net>,
        "John Stoffel" <john@stoffel.org>,
        "Wols Lists" <antlists@youngman.org.uk>
Cc:     "David T-G" <davidtg-robot@justpickone.org>,
        "Linux RAID list" <linux-raid@vger.kernel.org>
In-Reply-To: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
References: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1487
X-purgate-ID: 155817::1669558223-007EF4DE-18307838/0/0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

November 27, 2022 at 12:46 PM, "Reindl Harald" <h.reindl@thelounge.net> w=
rote:


>=20
>=20Am 26.11.22 um 21:02 schrieb John Stoffel:
>=20
>=20>=20
>=20> I call it a failure of the layering model. If you want RAID, use MD=
.
> >  If you want logical volumes, then put LVM on top. Then put
> >  filesystems into logical volumes.
> >  So much simpler...
> >=20
>=20
> have you ever replaced a 6 TB drive and waited for the resync of mdadm =
in the hope in all that hours no other drive goes down?
>=20
>=20when your array is 10% used it's braindead
> when your array is new and empty it's braindead
>=20
>=20ZFS/BTRFS don't neeed to mirror/restore 90% nulls
>

You cannot consider the amount of data in the
array as parameter for reliability.

If the array is 99% full, MD or ZFS/BTRFS have
same behaviour, in terms of reliability.
If the array is 0% full, as well.

The only advantage is you wait less, if less
data is present (for ZFS/BTRFS).

Because the day that the ZFS/BTRFS is 99% full,
you got a resync and a failure you have also
double damage: lost array and 99% of the data.

Furthermore, non-layered systems, like those two,
tend to have dependent failures, in terms of
software bugs.

Layered systems have more isolation, bug propagation
is less likely.

Meaning that the risk of a software bug is much
higher, to happen and to have catastrophic effects,
for non-layered systems.

bye,

pg

--=20

piergiorgio=20sartor
