From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian "woody", homebrew 2.4.25
 kernel
Date: Wed, 4 Aug 2004 14:25:34 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408041423480.7382-100000@uplift.swm.pp.se>
References: <200408041310.12982.jens@spamfreemail.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408041310.12982.jens@spamfreemail.de>
To: Jens Benecke <jens-dated-1092049816.9085e9@spamfreemail.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 4 Aug 2004, Jens Benecke wrote:

> thanks for your answer. What hardware RAID1 options would I have here=
 that=20
> are somewhat affordable? I see 3ware 2-drive RAID controllers for =A4=
120.-=20
> here, and Promise UDMA for =A460.-
>=20
> I hear Promise only offers binary drivers and is only "software RAID"=
, is=20
> the 3ware solution worth the extra =A460 (less hassle and more=20
> compatbility)?

I have never tried to boot off of a 3ware raid, but to Linux it looks l=
ike=20
a scsi drive so I would imagine that it should work well. Someone else =
who=20
has actually done this for real is probably better suited to answer.

I never use software raid for the partitions that need to be present at=
=20
boot, since I have had total nightmares with root mirroring on other OS=
es=20
(Solaris and DEC OSF), and I feel that backups of those partitions are=20
better than the problems one might run into with software root mirrorin=
g.

--=20
Mikael Abrahamsson    email: swmike@swm.pp.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
