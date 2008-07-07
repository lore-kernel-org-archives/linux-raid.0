From: Doug Ledford <dledford@redhat.com>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Mon, 07 Jul 2008 10:02:40 -0400
Message-ID: <1215439360.14196.17.camel@firewall.xsintricity.com>
References: <484F9A3E.7020709@rabbit.us>
	 <18512.25940.653867.623185@notabene.brown> <486BFB03.7060100@zytor.com>
	 <1215062276.14196.6.camel@firewall.xsintricity.com>
	 <18545.35548.800516.532854@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IlGwDMDs/0ScfiTfcVrr"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18545.35548.800516.532854@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-IlGwDMDs/0ScfiTfcVrr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-07 at 13:17 +1000, Neil Brown wrote:
> On Thursday July 3, dledford@redhat.com wrote:
> > Actually, if you are going to use version 1 superblocks anyway, then
> > just list the partitions as normal linux partitions.  The whole
> > linux-raid-autodetect partition type was originally only for auto detec=
t
> > at bootup.  If you weren't using that feature, then standard linux type
> > was good enough.  And if you use version 1.1 or 1.2 superblocks, then
> > you really don't have anything to worry about since the location of the
> > superblock and the data start offset means that the partition won't get
> > accidentally recognized as a non-raid partition.
>=20
> But if you use 1.0, then some well-meaning install program might mount
> one drive from a raid1 as a filesystem, write to it, and get your RAID
> all out of sync.

The same is true of version 0.90.0 superblocks.  It was probably a bad
decision to make raid1 arrays mountable as normal filesystems in
hindsight, but it did ease a lot of things at the time (like booting
from a raid1 device using lilo, the only boot loader back in the day).
In any case, given the number of existing 0.90.0 and 1.0 superblock
systems out there, any install code that doesn't look for them is just
flat deficient.  So I can see your point from the stand point of wanting
to correct a past mistake, but the flip side of the coin is that even if
you do such a thing, any installer will still be buggy and broken for
many years to come if it doesn't check for raid superblocks before
treating a filesystem like a normal filesystem.

> The whole point of this exercise was to find a way to make sure code
> that took the partition type to mean something didn't make the wrong
> decision.  0xDA seems the best answer for that.
>=20
> NeilBrown
> =20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-IlGwDMDs/0ScfiTfcVrr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhyIfsACgkQTzP9PM7pjw8xfQCfWUOSeU+AfNSwcRorns8FV48j
zPoAn29pP0FQXR8sKaSi0WDgiJZbQU1Z
=hjJ+
-----END PGP SIGNATURE-----

--=-IlGwDMDs/0ScfiTfcVrr--

