From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Changing Chunk Size on Array
Date: Sun, 18 Jul 2010 03:30:47 +0600
Message-ID: <20100718033047.2ee80eac@natsu>
References: <CC.8D.04655.49D124C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iifDTYWMwn/eJW0ZAieZi6x"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CC.8D.04655.49D124C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iifDTYWMwn/eJW0ZAieZi6x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Jul 2010 16:15:55 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

>=20
> 	I'm thinking about changing the chunk size on one of my arrays in
> order to potentially improve performance.  The man page rather suggests -c
> is a vlaid option under Grow mode, although it doesn't specifically say
> mdadm supports it under --grow.  Is it indeed supported under mdadm 2.6.7=
.2
> and kernel 2.6.26-2?  Assuming so, I would like to know a bit more about =
the
> change before issuing the command.  Speficialy, what are the details of t=
he
> process?  Does the entire (RAID 6) array have to be re-written, such as is
> the case with adding a drive to the array?  Does the recovery start
> immediately?  Can it be interrupted and then continue at a later time?

Out of curiosity, which chunk size do you have, and which you want to change
it to, and do you expect the new size to be faster based on any tests?

--=20
With respect,
Roman

--Sig_/iifDTYWMwn/eJW0ZAieZi6x
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxCIQcACgkQTLKSvz+PZwgXiACfbolpTWI4xyfUzVF03TKfNvcQ
5LkAmgL7dkddiU1zC7mlclrCX1ax3LDN
=Vjq5
-----END PGP SIGNATURE-----

--Sig_/iifDTYWMwn/eJW0ZAieZi6x--
