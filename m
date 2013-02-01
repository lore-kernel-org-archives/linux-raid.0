From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Raid 5 to 6 migration
Date: Sat, 2 Feb 2013 00:16:25 +0600
Message-ID: <20130202001625.2b7d6514@natsu>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl>
	<510C0075.9010908@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sr_4MwJtqAcnUtXaRq9asKT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510C0075.9010908@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Dominique <dcouot@hotmail.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/sr_4MwJtqAcnUtXaRq9asKT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 01 Feb 2013 12:50:45 -0500
Phil Turmel <philip@turmel.org> wrote:

> On 02/01/2013 12:17 PM, Dominique wrote:
> > Hi list,
> >=20
> > I was wondering what would be the best way to convert a 6 hdd raid 5 to
> > raid 6. Ideally without having to reformat everything and lose all the
> > data in the process. I have backups of the data but I don't look forward
> > reinstalling everything on that server.

...

> 3) Convert array to raid6 w/ "mdadm --grow --level=3Draid6"

--layout=3Dpreserve will make it an order of magnitude faster. Read "man md=
adm"
for more details. (And "man md" to learn about things in general.)

That's all while still assuming you *can* or want to add a 7th drive.
If not, things become more complex.

--=20
With respect,
Roman

--Sig_/sr_4MwJtqAcnUtXaRq9asKT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEMBnkACgkQTLKSvz+PZwjblgCeKMwA2Bq8PErGDhUgCpnvWUnb
3gUAn3v66AemSPCc6FCfI0Cl2g80bLK+
=WnXs
-----END PGP SIGNATURE-----

--Sig_/sr_4MwJtqAcnUtXaRq9asKT--
