From: Doug Ledford <dledford@redhat.com>
Subject: Re: why partition arrays?
Date: Wed, 18 Oct 2006 17:42:08 -0400
Message-ID: <1161207728.2917.537.camel@fc6.xsintricity.com>
References: <20061018124225.GA23653@piper.madduck.net>
	 <1161178012.2917.529.camel@fc6.xsintricity.com>
	 <20061018134322.GA910@piper.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xv31i25O8tt0fRfK0QkT"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061018134322.GA910@piper.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-Xv31i25O8tt0fRfK0QkT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-10-18 at 15:43 +0200, martin f krafft wrote:
> also sprach Doug Ledford <dledford@redhat.com> [2006.10.18.1526 +0200]:
> > There are a couple reasons I can think.
>=20
> Thanks for your elaborate response. If you don't mind, I shall link
> to it from the FAQ.

Sure.

> I have one other question: do partitionable and traditional arrays
> actually differ in format? Put differently: can I assemble
> a traditional array as a partitionable one simply by specifying:
>=20
>   mdadm --create ... /dev/md0 ...
>   mdadm --stop /dev/md0
>   mdadm --assemble --auto=3Dpart ... /dev/md0 ...
>=20
> ? Or do the superblocks actually differ?

Neil would be more authoritative about what would differ in the
superblocks, but yes, it is possible to do as you listed above.  In
fact, if you create a partitioned array, and your mkinitrd doesn't
restart it as a partitioned array, you'll wonder how to mount your
filesystems since the system will happily start that originally
partitioned array as non partitioned.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-Xv31i25O8tt0fRfK0QkT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFNp+wTzP9PM7pjw8RAnrVAJ9gudsLDMPRrL9h/NAreavrLGxEPgCfbqwI
VGgikIoVAddImxJyQixyrIE=
=03Bf
-----END PGP SIGNATURE-----

--=-Xv31i25O8tt0fRfK0QkT--

