From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Sleepy drives and MD RAID 6
Date: Tue, 12 Aug 2014 09:29:01 +0600
Message-ID: <20140812092901.60f007e6@natsu>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YpC55XmwizsMml/PSNxj3oE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YpC55XmwizsMml/PSNxj3oE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Aug 2014 18:03:17 -0700
Adam Talbot <ajtalbot1@gmail.com> wrote:

> I need help from the Linux RAID pros.
>=20
> To make a very long story short; I have a 7 disk in a RAID 6 array.  I
> put the drives to sleep after 7 minutes of inactivity.

It is well known that repeatedly spinning a drive down/up is absolutely the
worst possible thing you can do to it, from a long term reliability standpo=
int.
So my personal suggestion would be to reconsider if you really want this. T=
he
power consumption from 7 spinning drives with no access should be no higher
than 60-70 watt; IMHO saving that amount, is not something that's worth ris=
king
your disks and data for.

--=20
With respect,
Roman

--Sig_/YpC55XmwizsMml/PSNxj3oE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPpif0ACgkQTLKSvz+PZwj5XwCfYXkANxK59mhr0eelVWlKXiRM
XUMAnjQBm5Bwa2T3Tei5jqj2zhF77Tzj
=Ke5n
-----END PGP SIGNATURE-----

--Sig_/YpC55XmwizsMml/PSNxj3oE--
