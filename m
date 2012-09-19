From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: raid6 low performance 8x3tb drives in singledegraded
 mode(=7x3tb)
Date: Wed, 19 Sep 2012 13:40:30 +0600
Message-ID: <20120919134030.222e4b04@natsu>
References: <504FD153.9090602@sandberg-consult.dk>
	<20120919162557.03df6af2@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/93cB.bcZssf37NM0X5SOJvI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120919162557.03df6af2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Kasper Sandberg <kontakt@sandberg-consult.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/93cB.bcZssf37NM0X5SOJvI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Sep 2012 16:25:57 +1000
NeilBrown <neilb@suse.de> wrote:

> RAID5/RAID6 write speed is never going to be brilliant, but there probabl=
y is
> room for improvement.  Hopefully one day I figure out how to effect that
> improvement.

"/sys/block/md*/md/stripe_cache_size" is absolutely the first thing one sho=
uld
look at when facing a problem with md RAID5/6 write performance. It is
understandable that the default value can't be high (as it consumes a lot of
RAM on large disk counts), but increasing it if you have the RAM can increa=
se
the write speed by 200 to 400%:

  http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-=
transfer/

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/93cB.bcZssf37NM0X5SOJvI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBZdu4ACgkQTLKSvz+PZwhNbwCgi8jH9dqR7hz4xq51C9imz3j9
X2cAn1FgCKvDLSylwwMarBLQa31UXWrN
=yQdu
-----END PGP SIGNATURE-----

--Sig_/93cB.bcZssf37NM0X5SOJvI--
