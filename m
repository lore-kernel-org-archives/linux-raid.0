From: Kasper Dupont <kasperd@daimi.au.dk>
Subject: Re: RAID-6 support in kernel?
Date: Mon, 03 Jun 2002 16:52:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CFB82A0.EB2062AE@daimi.au.dk>
References: <Pine.LNX.4.33.0206031020290.30424-100000@mail.pronto.tv> <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <20020603113128.C13204@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Derek Vadala <derek@cynicism.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tedd Hansen <tedd@konge.net>, Christian Vik <christian@konge.net>, Lars Christian Nygaard <lars@snart.com>
List-Id: linux-raid.ids

Vojtech Pavlik wrote:
>=20
> He was thinking "mirror", not "stripe". Mirror of 2 RAID-5 arrays (wo=
uld
> be probably called RAID-15 (when there is a RAID-10 for mirrored stri=
pe
> arrays)), can withstand any two disks failing anytime.

It can actually withstand any *three* disks failing anytime.

> Even more for
> certain combinations. But it is terribly inefficient.

--=20
Kasper Dupont -- der bruger for meget tid p=E5 usenet.
=46or sending spam use mailto:razor-report@daimi.au.dk
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
