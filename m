From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Promise TX2-plus and kernel 2.6
Date: Thu, 22 Jan 2004 17:19:29 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040122161929.GA26026@rap.rap.dk>
References: <20040122004820.GA2515@rap.rap.dk> <400FF229.6000507@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <400FF229.6000507@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 22, 2004 at 10:54:17AM -0500, Jeff Garzik wrote:
> Keld J=F8rn Simonsen wrote:
> >Does anybody know what level of support that is planned for the
> >Promise TX2 Plus SATA disk controller in the 2.6 kernel? My understa=
nding
> >is that the PATA channels will not work under 2.6, while it works fi=
ne
> >under 2.4. This does have some influence on deciding whether to upgr=
ade
> >to 2.6 :-(
>=20
>=20
> No Linux kernel, 2.4 or 2.6, supports the PATA channels currently.  O=
nly=20
> the SATA channels are supported.

I am running linux kernel 2.4.22-26mdk and it supports PATA right out o=
f
the box, on a Promise TX2-plus controller. I have one disk on the PATA
port (and one disk on one of the SATA ports). I would probably like to
run kernel 2.6, mostly because I think of implementing some striping
RAID-1 on it and try that new module out, but if kernel 2.6 does not
support PATA on the TX2-plus then I am at a loss.

best regards
Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
