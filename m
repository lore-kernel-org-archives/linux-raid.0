From: Kasper Dupont <kasperd@daimi.au.dk>
Subject: Re: SV: RAID-6 support in kernel?
Date: Mon, 03 Jun 2002 13:08:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CFB4E19.C916D938@daimi.au.dk>
References: <A2C65A3296DA4A4FB30DB57A9A464A16436851@exchange.lan.vanadis.no> <200206030959.g539xXb31139@mail.pronto.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Christian Vik <cvik@vanadis.no>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dstephenson@snapserver.com
List-Id: linux-raid.ids

Roy Sigurd Karlsbakk wrote:
>=20
> Below is a (patented?)

No problem for me I live in Europe.

> version that works. This is from the linux-raid list
>=20
> >  A1   A2  (P1) (PA)
> > (P2) (PB)  B2   B1

Nice, looks like it works.

> >  C4   C3  (PC) (P3)
> > (PD) (P4)  D3   D4

In this encoding the roles of disk one and two are
switched, and three and four are also switched. Are
there any reason for this?

--=20
Kasper Dupont -- der bruger for meget tid p=E5 usenet.
=46or sending spam use mailto:razor-report@daimi.au.dk
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
