From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: Soft-/Hardware RAID Performance
Date: 20 Feb 2003 10:31:38 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1045765895.2116.2.camel@gregdell>
References: <5.1.0.14.0.20030220112347.028ef5c0@195.90.31.33>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JHpiVSQhP7ncU3t7xgcp"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.0.20030220112347.028ef5c0@195.90.31.33>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-JHpiVSQhP7ncU3t7xgcp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2003-02-20 at 02:55, Daniel Brockhaus wrote:
[snip]
> One suggestion to speed up the reads was to issue several reads in=20
> parallel. Silly me didn't think of that, I was completely focused on the=20
> writes, which are more important for my application. Anyway. Using parall=
el=20
> reads (from four processes), read performance scales almost with the numb=
er=20
> of disks in the array. This goes for both, hardware and software RAID, wi=
th=20
> software RAID being about 15% faster.
>=20
> Write performance on the other hand does not change at all when using=20
> multiple processes - for obvious reasons: The kernel queues, sorts and=20
> merges write requests anyway, so the number of processes doing the writes=
=20
> does not matter. But I've noticed something peculiar: If I change my=20
> benchmark to write 4K blocks at 4K boundaries, write performance increase=
s=20
> to almost 300%. This is quite logical, since the kernel can write a 'page=
=20

What was your previous benchmark write size?  And what parameters did
you use when creating the RAID 0 array and filesystem?  There may be
opportunities for tuning there.
	Greg
[snip]

--=-JHpiVSQhP7ncU3t7xgcp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+VR8GnAkVXO6fw4sRAnKqAJ9ksAQ2Lxf8+GEiuhruPmX9PWg8WwCeL3x1
uJFklugLBG1SXYyGmeNAhgI=
=c2gA
-----END PGP SIGNATURE-----

--=-JHpiVSQhP7ncU3t7xgcp--

