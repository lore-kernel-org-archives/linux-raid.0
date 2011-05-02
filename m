From: Jameson Graef Rollins <jrollins@finestructure.net>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio too big device md0 (248 > 240)" in kern.log
Date: Sun, 01 May 2011 18:17:06 -0700
Message-ID: <87pqo1ewa5.fsf@servo.factory.finestructure.net>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net> <1304051980.3105.46.camel@localhost> <8739kyf53e.fsf@servo.factory.finestructure.net> <1304294457.2833.111.camel@localhost>  <4DBDFE0C.3000304@fifthhorseman.net> <1304298258.2833.125.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1304298258.2833.125.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>, Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Cc: 624343@bugs.debian.org, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 02 May 2011 02:04:18 +0100, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> On Sun, 2011-05-01 at 20:42 -0400, Daniel Kahn Gillmor wrote:
> So far as I'm aware, the RAID may stop working, but without loss of data
> that's already on disk.

What exactly does "RAID may stop working mean"?  Do you mean that this
bug will be triggered?  The raid will refuse to do further syncs?  Or do
you mean something else?

> > How is an admin to know which I/O capabilities to check before adding a
> > device to a RAID array?  When is it acceptable to mix I/O capabilities?
> >  Can a RAID array which is not currently being used as a backing store
> > for a filesystem be assembled of unlike disks?  What if it is then
> > (later) used as a backing store for a filesystem?
> [...]
>=20
> I think the answers are:
> - Not easily
> - When the RAID does not have another device on top

This is very upsetting to me, if it's true.  It completely undermines
all of my assumptions about how software raid works.

Are you really saying that md with mixed disks is not possible/supported
when the md device has *any* other device on top of it?  This is a in
fact a *very* common setup.  *ALL* of my raid devices have other devices
on top of them (lvm at least).  In fact, the debian installer supports
putting dm and/or lvm on top of md on mixed disks.  If what you're
saying is true then the debian installer is in big trouble.

jamie.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJNvgYSAAoJEO00zqvie6q86lAP/3LtkkpHPdE6kY9kBQVlEPb+
iR+V58tBq4mKAzc8Lta3HfJCZMEiZoQveUJiJYuMtwsI9eo9ED5XDapme5GUocgN
fliyUHHCwMjvwzzBwYRZxOxMPJo8VfTovf3cfJdcma3legERCb7qE3tO8daaTkSP
9e9g5BWu0RNtHapk+IkC+TFSLMzd+q9CSLmgI1jL9+GJLjaRSj8vyTdpy9Z9PlVz
uXUm/cv6AF5H/+lPlKvH+dUT6diuaN1eg5ixSdkeaV5t3S2ndxC4qPUsdOqiTJOn
DbLPL+DKvYwqcvEH/muAPOxQAS/dEH8qrB1hyLRODbUvXcwGmdhr3Z8GVO7nCm1U
pu8VfGLyZrwx2CyDYVJK6yW7BqBWT4gBWIM/zjE4yAxJQlI2YWRv/wiWUhQ7tdrZ
Y3MdOfYegTWgRLV6nmhVvNYLA1yOiOcjLTj67PWTJG/z5LiSUY9n1l8AkdgpIHLu
YQhHUcO01JdkPgQapZJc+U6KY2JJWjElmMc/mzEDeIFVObMBPN7xm4ehhgsYD2yV
2QC2dJ/Vx66xvRxMv5dGALH3gqCoUs8h4CQtbUD0dFf8y2eRZjN36BA+fyRx5tBB
TpQkDtqL50xPii41eHyDETyBARJNoDi5e8cxYa5XFePg+P0ASCfKn7DKsLDDp0kY
qjxCc+gFIZ/WJb1WJ6Cb
=gdgF
-----END PGP SIGNATURE-----
--=-=-=--
