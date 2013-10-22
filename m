From: Roman Mamedov <rm@romanrm.net>
Subject: Re: [Question] how to proceed after bad raid5 reshape
Date: Wed, 23 Oct 2013 04:16:40 +0600
Message-ID: <20131023041640.0e8ae338@natsu>
References: <5266F5F8.4040503@woh.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hzj5Eu_2968xFqYlsArgNEG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5266F5F8.4040503@woh.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Knight <dknight1989@woh.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hzj5Eu_2968xFqYlsArgNEG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Oct 2013 18:02:32 -0400
Dan Knight <dknight1989@woh.rr.com> wrote:

> Checking mdadm -Evvvvs shows that maybe 2 drives went bad during the=20
> reshape?

And maybe, just maybe, `dmesg` would have something about this, if this ind=
eed
happened. But of course asking people on the internet to play with you an
exciting game of guesswork is much more exciting than looking at the actual
log which would simply and boringly TELL you what exactly happened...

--=20
With respect,
Roman

--Sig_/hzj5Eu_2968xFqYlsArgNEG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJm+UgACgkQTLKSvz+PZwjaEgCfXjRXX+bKQr+FPi7+WPpKbfgv
VRMAnRN/xlIMDB4bFz+dP9HNUUBk5dVT
=HbuJ
-----END PGP SIGNATURE-----

--Sig_/hzj5Eu_2968xFqYlsArgNEG--
