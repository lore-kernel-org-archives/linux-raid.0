From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: SSD + Rust as raid1
Date: Fri, 31 May 2013 13:54:34 +0600
Message-ID: <20130531135434.5b6bdddb@natsu>
References: <51A7C36F.4030605@timedicer.co.uk>
	<20130531133018.77cd9285@natsu>
	<51A85574.8080709@timedicer.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Gy5ynqw/mXM2fzJP1XXV4aA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51A85574.8080709@timedicer.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Dominic Raferd <dominic@timedicer.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Gy5ynqw/mXM2fzJP1XXV4aA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 31 May 2013 08:47:00 +0100
Dominic Raferd <dominic@timedicer.co.uk> wrote:

> This is my idea too (see my OP), but I am concerned about optimisation=20
> (--write-behind, --bitmap and --bitmap-chunk settings) especially for=20
> writes.

> --write-behind=3D16384

I think this will not work, you will have to use 16383.

> --bitmap=3D/mnt/sda1/write-intent-bitmap.file=20

Save yourself lots of maintenance headache, just use --bitmap=3Dinternal

> --bitmap-chunk=3D256M

Looks OK.

--=20
With respect,
Roman

--Sig_/Gy5ynqw/mXM2fzJP1XXV4aA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGoVzoACgkQTLKSvz+PZwivxwCbB+4ZaMR0/WbgOwTq0nucnSPS
k5EAn0Fb2vWtFElshCnzdpMOZJ8wJYy6
=ehcv
-----END PGP SIGNATURE-----

--Sig_/Gy5ynqw/mXM2fzJP1XXV4aA--
